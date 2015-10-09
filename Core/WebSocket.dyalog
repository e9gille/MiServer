:Class WebSocket

    :Field Public Instance FIN
    :Field Public Instance RSV
    :Field Public Instance OPCODE
    :Field Public Instance MASK
    :Field Public Instance MASKING_KEY

    :Field Public Instance completed←0
    :Field Public Instance fragmented←0
    :Field Public Instance payload
    :Field Public Instance connection

    :Field Public Shared ReadOnly OP_CONTINUATION   ←0  ⍝       0  Continuation Frame      [RFC6455]
    :Field Public Shared ReadOnly OP_TEXT           ←1  ⍝       1  Text Frame              [RFC6455]
    :Field Public Shared ReadOnly OP_BINARY         ←2  ⍝       2  Binary Frame            [RFC6455]
                                                        ⍝     3-7  Unassigned Non-Control Frames
    :Field Public Shared ReadOnly OP_CLOSE          ←8  ⍝       8  Connection Close Frame  [RFC6455]
    :Field Public Shared ReadOnly OP_PING           ←9  ⍝       9  Ping Frame              [RFC6455]
    :Field Public Shared ReadOnly OP_PONG           ←10 ⍝      10  Pong Frame              [RFC6455]
                                                        ⍝   11-15  Unassigned Control Frames


    ∇ Make1(cn)
      :Access Public Instance
      :Implements Constructor
      :If 9=⎕NC'cn'
          HandleConnection cn
      :Else
          connection←cn
      :EndIf
    ∇

    ∇ HandleConnection cn;⎕IO;payload_len;buf;length;cnt
⍝    ∇ Make2(cn data);⎕IO;payload_len;buf;length
⍝      :Access Public Instance
⍝      :Implements Constructor
      ⎕IO←0
      connection←cn.Connection
      buf←cn.Buffer
      cnt←0
      FIN RSV OPCODE MASK payload_len←0 1 4 8 9{(⍺∊⍨⍳⍴⍵)⊂⍵}binary 2↑buf
      OPCODE←2⊥OPCODE
      buf←2↓buf ⋄ cnt+←2
      length←2⊥payload_len
      :If length=126
          length←2⊥binary 2↑buf
          buf←2↓buf ⋄ cnt+←2
      :ElseIf length=127
          length←2⊥binary 8↑buf
          buf←8↓buf ⋄ cnt+←8
      :EndIf
     
      :If MASK
          MASKING_KEY←binary 4↑buf
          buf←4↓buf ⋄ cnt+←4
      :EndIf
     
      :If length>≢buf
      ⍝ missing data
          :Return
      :EndIf
     
      buf←length↑buf
      cn.Buffer←(cnt+length)↓cn.Buffer
     
      :If ∨/RSV
 ⍝ failed
      :EndIf
     
      fragmented←(OPCODE=OP_CONTINUATION)∨FIN=0
     
      :If MASK
          buf←MASKING_KEY applyMask buf
      :EndIf
      completed←1
      :If OPCODE=OP_TEXT
          payload←'UTF-8'⎕UCS buf
      :Else
          payload←buf
      :EndIf
    ∇


      binary←{
          ⍺←8
          ,⍉(⍺⍴2)⊤⍵
      }

      applyMask←{
      ⍝ ⍺ is binary mask
      ⍝ ⍵ is byte stream
      ⍝ return mask XOR byte stream
          256|83 ⎕DR ⍺{⍵≠(⍴⍵)⍴⍺}binary ⍵
      }

    ∇ {fragSize}SendFrame(opcode payload);fin;rsv;mask;op;length;frame;fragments;opcodes;fins;data;opc;r
⍝ Opcode   Meaning                 Reference
⍝       0  Continuation Frame      [RFC6455]
⍝       1  Text Frame              [RFC6455]
⍝       2  Binary Frame            [RFC6455]
⍝     3-7  Unassigned
⍝       8  Connection Close Frame  [RFC6455]
⍝       9  Ping Frame              [RFC6455]
⍝      10  Pong Frame              [RFC6455]
⍝   11-15  Unassigned
      rsv mask←(0 0 0)0
     
      {0=⎕NC ⍵:⍎⍵,'←0'}'fragSize'
      :If opcode∊OP_TEXT OP_BINARY
      :AndIf fragSize>0
      :AndIf fragSize<≢payload
          fragments←fragSize{⎕IO←0 ⋄ ⍵⊂⍨0=⍺|⍳≢⍵}payload
      :Else
          fragments←,⊂payload
      :EndIf
      opcodes fins←(1 ¯1×≢fragments)↑¨opcode 1
      :For data opc fin :InEach fragments opcodes fins
          op←4 binary opc
          length←{
              ⍵≥2*16:(7 binary 127),64 binary ⍵
              ⍵>125:(7 binary 126),16 binary ⍵
              7 binary ⍵
          }≢data
          frame←(83 ⎕DR fin,rsv,op,mask,length),data
          r←#.DRC.Send connection frame
      :EndFor
     ⍝
    ∇

    ∇ {fragSize}SendText txt
      :Access Public Instance
      {0=⎕NC ⍵:⍎⍵,'←0'}'fragSize'
      fragSize SendFrame 1('UTF-8'⎕UCS txt)
    ∇

    ∇ {fragSize}SendBinary bin
      :Access Public Instance
      {0=⎕NC ⍵:⍎⍵,'←0'}'fragSize'
      fragSize SendFrame 2 bin
    ∇

    ∇ CloseSocket(sc txt);msg;z
      :Access Public Instance
⍝  Status Code  Meaning                     Contact             Reference
⍝         1000  Normal Closure              [IESG_HYBI]         [RFC6455]
⍝         1001  Going Away                  [IESG_HYBI]         [RFC6455]
⍝         1002  Protocol error              [IESG_HYBI]         [RFC6455]
⍝         1003  Unsupported Data            [IESG_HYBI]         [RFC6455]
⍝         1004  Reserved                    [IESG_HYBI]         [RFC6455]
⍝         1005  No Status Rcvd              [IESG_HYBI]         [RFC6455]
⍝         1006  Abnormal Closure            [IESG_HYBI]         [RFC6455]
⍝         1007  Invalid frame payload data  [IESG_HYBI]         [RFC6455]
⍝         1008  Policy Violation            [IESG_HYBI]         [RFC6455]
⍝         1009  Message Too Big             [IESG_HYBI]         [RFC6455]
⍝         1010  Mandatory Ext.              [IESG_HYBI]         [RFC6455]
⍝         1011  Internal Error              [IESG_HYBI]         [RFC6455][RFC Errata 3227]
⍝         1012  Service Restart             [Alexey_Melnikov ]  [http://www.ietf.org/mail-archive/web/hybi/current/msg09670.html]
⍝         1013  Try Again Later             [Alexey_Melnikov ]  [http://www.ietf.org/mail-archive/web/hybi/current/msg09670.html]
⍝    1014-1014  Unassigned
⍝         1015  TLS handshake               [IESG_HYBI]         [RFC6455]
⍝    1016-3999  Unassigned
⍝    4000-4999  Reserved for Private Use                        [RFC6455]
      msg←16 binary sc
      msg,←'UTF-8'⎕UCS txt
      SendFrame 8 msg
      z←#.DRC.Close connection
      ⍝
    ∇

    ∇ Ping txt
      :Access Public Instance
      SendFrame 9('UTF-8'⎕UCS txt)
      ⍝
    ∇

    ∇ Pong txt
      :Access Public Instance
      SendFrame 10('UTF-8'⎕UCS txt)
      ⍝
    ∇

:EndClass