:Class chat : MiSocket


    ∇ onCompletedFragmentedTransfer buffer;msg;allWSs
      msg←⎕NS''
      msg.handle←'system'
      msg.date←#.Dates.HttpDate ⎕TS
      msg.text←buffer
      allWSs←GetOpenWebSockets
      allWSs.SendText⊂toJSON msg
     
    ∇

    ∇ OnText ws;data;msg;allWSs
      :Access Public Override
      data←ws.payload
      :If ws.fragmented
          onCompletedFragmentedTransfer ws.payload
      :Else
          msg←fromJSON data
          msg.date←#.Dates.HttpDate ⎕TS
          allWSs←GetOpenWebSockets
          allWSs.SendText⊂toJSON msg
      :EndIf
    ∇

    toJSON←7160⌶
    fromJSON←7159⌶
:EndClass