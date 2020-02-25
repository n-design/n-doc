bridge_tls={}

tls=require("tls")

function bridge_tls.printTlsConnectionTable(tex)
   conntable = tls.printTlsConnectionTable()
   tex.sprint(conntable)
end

function bridge_tls.getTlsConnectionTableRow(key, document, tex)
   conntable = tls.getTlsConnectionTableRow(key, string.find(document, "advtds"))
   tex.sprint(conntable)
end

function bridge_tls.printTlsParametersForModule(key, tex)
   conntable = tls.printTlsParametersForModule(key)
   tex.sprint(conntable)
end

return bridge_tls
