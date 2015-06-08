﻿:Class StackPanel : #._html.table
    :Field public Items←⍬
    :Field public Horizontal←0 ⍝ orientation

    ∇ Make0
      :Access public
      :Implements constructor
    ∇

    ∇ Make1 args
      :Access public
      :Implements constructor
      Items←args
    ∇

    ∇ {r}←{attr}Add item;td
      :Access public
      attr←{6::⍵ ⋄ attr}''
      r←attr(td←⎕NEW #._html.td).Add item ⍝ #.HtmlElement.Add
      Items,←td
    ∇

    ∇ html←Render
      :Access public
      Items←Itemize¨Items
      :If (,Horizontal)≡,1
          (Content←⎕NEW #._html.tr).Add Items
      :Else
          (Content←⎕NEW¨(⍴Items)⍴#._html.tr).Add Items
      :EndIf
      html←⎕BASE.Render
    ∇

    ∇ r←Itemize item
      :If 0=⍴⍴item
      :AndIf isInstance item
      :AndIf #._html.td≡⊃⊃⎕CLASS item
          r←item
      :Else
          (r←⎕NEW #._html.td).Add item
      :EndIf
    ∇

:endclass