lu = require('luaunit')

tex={}
function tex.print(texoutput)
   lu.assertEquals(texoutput, tex.expectedresult)
   tex.expected(nil)
end
tex.sprint=tex.print
function tex.expected(expectedresult)
   tex.expectedresult=expectedresult
   return tex
end

bridge_common = require "bridge_common"
bridge_common.init("../common/test_db/")

