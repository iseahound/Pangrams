#Requires AutoHotkey v2.0

; Press 1 to generate pangrams?
1:: SendText GenerateLine("Pangrams.txt", PangramVerify)

GenerateLine(filepath, verify := "") {
   static cache := Map()

   if cache.has(filepath)
      goto generate

   if !FileExist(filepath)
      throw OSError()

   cache[filepath] := []
   FileEncoding "UTF-8"
   f := FileOpen(filepath, "r")
   while !f.AtEOF
      cache[filepath].push(f.ReadLine())

   generate:
   line := cache[filepath][Random(1, cache[filepath].length)]

   ; Add a space if it ends in punctuation.
   (line ~= "[?.!”]$") && line .= A_Space

   ; Run the verification callback.
   if v := verify(line)
      line .= "`n" v "`n"

   return line
}

PangramVerify(s) {
   alphabet := "abcdefghijklmnopqrstuvwxyz"
   Loop StrLen(s)
      alphabet := StrReplace(alphabet, SubStr(s, A_Index, 1))
   if (alphabet != "")
      return "Missing: <" alphabet ">"
   return ""
}