:Class WSS: MiServer

    ∇ Make config
      :Access Public
      :Implements Constructor :Base config
    ∇

    :section Override
⍝ ↓↓↓--- Methods which are usually overridden ---

    ∇ onServerStart
      :Access Public Override
    ⍝ Handle any server startup processing
      #.Games←⍬
    ∇


⍝    ∇ onSessionStart req
⍝      :Access Public Override
⍝    ⍝ Process a new session
⍝    ∇
⍝
⍝    ∇ onSessionEnd session
⍝      :Access Public Override
⍝    ⍝ Handle the end of a session
⍝    ∇
⍝
⍝    ∇ onIdle
⍝      :Access Public Override
⍝    ⍝ Idle time handler - called when the server has gone idle for a period of time
⍝    ∇
⍝
⍝    ∇ Error req
⍝      :Access Public Override
⍝    ⍝ Handle trapped errors
⍝      req.Response.HTML←'<font face="APL385 Unicode" color="red">',(⊃,/⎕DM,¨⊂'<br/>'),'</font>'
⍝      req.Fail 500 ⍝ Internal Server Error
⍝      1 Log ⎕DM
⍝    ∇
⍝
⍝    ∇ level Log msg
⍝      :Access Public override
⍝    ⍝ Logs server messages
⍝    ⍝ levels implemented in MildServer are:
⍝    ⍝ 1-error/important, 2-warning, 4-informational, 8-transaction (GET/POST)
⍝      :If Config.LogMessageLevel bit level ⍝ if set to display this level of message
⍝          ⎕←msg ⍝ display it
⍝      :EndIf
⍝    ∇
⍝
⍝    ∇ Cleanup
⍝      :Access Public override
⍝    ⍝ Perform any site specific cleanup
⍝    ∇

⍝ ↑↑↑--- End of Overridable methods ---
    :endsection


:EndClass