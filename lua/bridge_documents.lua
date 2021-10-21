bridge_documents={}

documents = require "documents"

function bridge_documents.getDocumentVersion(key, tex)
   tex.sprint(documents.getDocumentVersion(key))
end

function bridge_documents.gitCommitId(key, tex)
   docversion = documents.getDocumentVersion(key)
   if string.find(docversion, "-SNAPSHOT") then
      tex.sprint("\\\\\\textsmaller{[Commit~\\gitAbbrevHash{}~/~\\gitBranch{}]}")
   end
end

function bridge_documents.getDocumentDate(key, tex)
   tex.sprint(documents.getDocumentDate(key))
end

function bridge_documents.get_version_number_for_reflist(version)
   return documents.get_version_number_for_reflist(version)
end

return bridge_documents
