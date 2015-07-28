﻿:class asideSimple: MiPage⍝Sample
⍝ Control:: _html.aside 
⍝ Description:: defines some content aside from the content it is placed in.
⍝ The aside content should be related to the surrounding content. 
  
  ∇ Compose;note
      :Access public 
      Add'This is the body text...'
      note←Add _.aside 'This note is only related, and is therefore set aside.'
      'style' note.Set 'text-align:right'
      Add'... it continues down here.'
    ∇
:endclass
