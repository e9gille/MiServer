﻿:Class ejAccordionSimple: MiPageSample
⍝ Control:: _SF.ejAccordion
⍝ Description:: Insert an accordion

    ∇ Compose;ac;path
      :Access public
      ac←Add _SF.ejAccordion              ⍝ add the accordion widget
      ac.Titles←'First' 'Second'          ⍝ headings for each of two sections
      ac.Sections←999⍴¨'Ut sed viverra velit. ' 'Ac malesuada ante. '
    ∇

:EndClass