bridge = require "bridge_common"
bridge.init("../common/test_db/")

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


function init(db_path)
   if _G.db_core == nil then
      _G.db_core = require "db_core"
      _G.db_core.init(db_path)
   end
end

init("../common/test_db/")
