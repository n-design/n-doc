sfrchecker = {}

function sfrchecker.checkSfrReferences()
   allReferenced = true
   result = ""
   for key,sfrEntry in pairs(sfr) do
     if sfrEntry["count"] == 0 then
       if allReferenced == true then
	  result = "\nUnreferenzierte SFR im Dokument gefunden"
	  result = result .. "\\todo[Undefined SFR]{Im Dokument unreferenzierte SFR}\\"
	  result = result .. "\\begin{itemize}"
       end 
       print(key .. "\t" .. sfrEntry["sfr"])
       result = result .. "\\item \\textcolor{magenta}{\\texttt{" .. sfrEntry["sfr"] .. "}}"
       allReferenced = false
     end
   end
   if allReferenced == true then
     print("All SFR referenced")
   else
      result = result .. "\\end{itemize}"
      return result
   end
end

return sfrchecker
