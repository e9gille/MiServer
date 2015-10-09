:Namespace Databinding

    ∇ BoundTables ipa;clients;json
      :Implements Trigger TableA,TableB,TableC
      clients←#.Boot.ms.GetOpenWebSockets'/livetable/livetable.dyalog'
      json←(7160⌶)↓ipa.NewValue
      clients.SendText⊂json
    ∇

:EndNamespace