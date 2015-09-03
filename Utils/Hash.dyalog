:Namespace Hash

    ∇ h←GetMD5 text;⎕USING;hash;md5
      ⎕USING←'System.Security.Cryptography,mscorlib.dll'
      md5←MD5.Create ⍬
      h←md5.ComputeHash(⊂'UTF-8'⎕UCS text)
     
    ∇

    ∇ h←GetSHA1 text;⎕USING;sha1
      ⎕USING←'System.Security.Cryptography,mscorlib.dll'
      sha1←⎕NEW SHA1Managed
      h←sha1.ComputeHash(⊂'UTF-8'⎕UCS text)
    ∇

    ∇ h←GetSHA256 text;⎕USING;sha256
      ⎕USING←'System.Security.Cryptography,mscorlib.dll'
      sha256←⎕NEW SHA256Managed
      h←sha256.ComputeHash(⊂'UTF-8'⎕UCS text)
    ∇

    ∇ h←GetSHA512 text;⎕USING;sha512
      ⎕USING←'System.Security.Cryptography,mscorlib.dll'
      sha512←⎕NEW SHA512Managed
      h←sha512.ComputeHash(⊂'UTF-8'⎕UCS text)
    ∇
    
      Hex←{⎕IO←0
          d←'0123456789abcdef'
          80=⎕DR ⍵:16⊥'0123456789abcdef'⍳⍉(2,⍨0.5×⍴⍵)⍴⍵
          ,⍉d[16 16⊤⍵]
      }

:EndNamespace