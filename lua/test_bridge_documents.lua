#!/usr/bin/env texlua

dofile("init_test_bridge.lua")

testbridge = {}

bridge = require("bridge_documents")

function testbridge.test_getDocumentVersion()
   bridge.getDocumentVersion("adv_tds", tex.expected("1.0-SNAPSHOT"))
end

function testbridge.test_gitCommitId()
   bridge.gitCommitId("adv_tds", tex.expected([[\\\textsmaller{[Commit~\gitAbbrevHash{}~/~\gitBranch{}]}]]))
end

function testbridge.test_getDocumentDate()
   bridge.getDocumentDate("adv_tds", tex.expected([[\today]]))
end

os.exit( lu.LuaUnit.run() )
