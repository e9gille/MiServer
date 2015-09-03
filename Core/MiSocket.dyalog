:Class MiSocket

⍝  Base class for web socket handler

    :Field Public _PageName←'' ⍝ Page file name
    :Field Public _PageDate←'' ⍝ Page saved date
    :field Public _Request     ⍝ HTTPRequest
    :field Public _PageData    ⍝
    :field Public _OPCODE      ⍝
    :field Public _FragmentBuffer

    ∇ Make
      :Access public
      :Implements constructor
      _PageData←⎕NS''
    ∇

    ∇ Make1 req
      :Access public
      _Request←req
      :Implements constructor
      _PageData←⎕NS''
    ∇

    ∇ r←{proto}Get names
      :Access public
      :If 0=⎕NC'proto' ⋄ proto←'' ⋄ :EndIf
      names←,⍕names
      names←#.Strings.deb names
      :If ' '∊names
          names←{⎕ML←3 ⋄ ⍵⊂⍨⍵≠' '}names
          r←proto∘Get¨names
      :ElseIf 2≠_PageData.⎕NC names
          r←proto
      :Else
          r←_PageData⍎names
          :If 1<|≡r ⋄ r←∊r ⋄ :EndIf
          :If ~0 2∊⍨10|⎕DR proto
              r←{0∊⍴⍵:⍬ ⋄ w←⍵ ⋄ ((w='-')/w)←'¯' ⋄ ⊃(//)⎕VFI w}r
          :EndIf
      :EndIf
    ∇

    ∇ Close session ⍝ Called when the session ends
      :Access Public Overridable
    ∇

    ∇ _init
      :Access public
    ∇

    ∇ Wrap
      :Access Public
    ∇

    ∇ resp←Render;f;list;game;res;ws_key;ws_ver;ws_ext;magic_key;ws_accept;hdrs
      :Access Public Instance Overridable
     
      res←_Request.Response
     
      ws_key←_Request.GetHeader'Sec-WebSocket-Key'
      ws_ver←_Request.GetHeader'Sec-WebSocket-Version'
      ws_ext←_Request.GetHeader'Sec-WebSocket-Extensions'
      magic_key←'258EAFA5-E914-47DA-95CA-C5AB0DC85B11'
      ws_accept←#.Hash.Base64 #.Hash.GetSHA1 ws_key,magic_key
     
      res.(Status StatusText)←101 'WebSocket Protocol Handshake'
     
      hdrs←0 2⍴''
      hdrs⍪←'Upgrade' 'websocket'
      hdrs⍪←'Connection' 'Upgrade'
      hdrs⍪←'Sec-WebSocket-Accept'ws_accept
      res.Headers←hdrs
     ⍝Sec-WebSocket-Extensions
     ⍝Sec-WebSocket-Protocol: chat
     ⍝
     
⍝      status←res.((⍕Status),' ',StatusText)
⍝      hdr←{⎕ML←3 ⋄ ∊⍵}{⍺,': ',⍵,NL}/res.Headers
⍝      answer←(toutf8'HTTP/1.1 ',status,NL,'Content-Length: ',(⍕0),NL,hdr,NL),res.HTML
⍝
⍝      :If 0≠1⊃z←#.DRC.Send obj answer
⍝               ⍝ Failed? What to do?
⍝      :EndIf
      resp←''
    ∇


    :Section WebSocketCallbacks

    ∇ OnText ws
      :Access Public Instance Overridable
    ∇

    ∇ OnTextFragment ws
      :Access Public Instance Overridable
    ∇

    ∇ OnBinary ws
      :Access Public Instance Overridable
    ∇

    ∇ OnBinaryFragment ws
      :Access Public Instance Overridable
    ∇

    ∇ OnClose ws
      :Access Public Instance Overridable
      ws.CloseSocket 1000 ''
     
    ∇

    ∇ OnPing ws
      :Access Public Instance Overridable
      ws.Pong''
     
    ∇

    ∇ OnPong ws
      :Access Public Instance Overridable
    ∇

    :EndSection

:EndClass