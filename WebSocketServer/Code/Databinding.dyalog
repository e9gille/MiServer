:Namespace Databinding

    ∇ BoundTables ipa;clients;json;rsp
      :Implements Trigger TableA,TableB,TableC,TableD
      clients←#.Boot.ms.GetOpenWebSockets'/livetable/tables.dyalog'
      :If 0<≢clients
          rsp←⎕NS''
          rsp.table_name←ipa.Name
          rsp.table_rows←↓ipa.NewValue
          json←(7160⌶)rsp
          clients.SendText&⊂json
      :EndIf
    ∇
     
    ∇ ScanTableD(seconds frq);coords;i;⎕IO;n;period;start;elapsed;j;d;ms
    ⍝ seconds is duration of scan
    ⍝ frq is frequency of updates
      ⎕IO←0
      seconds frq←⌈¨seconds frq
     
      period←1÷frq
      TableD←10 10⍴0
      coords←,⍳⍴TableD
      elapsed←0
      i←j←0
      n←1
      start←2⊃⎕AI
      ms←seconds×1000
      :Repeat
          d←0⌈(period×j+1)-0.001×elapsed
          ⎕DL d
          ((i⊃coords)⌷TableD)←n
          j+←1
          i←(≢coords)|j
          n+←i=0
          elapsed←start-⍨2⊃⎕AI
      :Until elapsed≥ms
      ⎕←,'I2,<s >,I3,<ms>'⎕FMT⍉⍪0 1000⊤elapsed
    ∇

:EndNamespace