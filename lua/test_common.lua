#!/usr/bin/env texlua

dofile("init_test_db.lua")

local common = require "common"

lu = require('luaunit')

testcommon = {}

-- Nur lokale Tests, verwenden keine Datenbank
function testcommon.test_basis()
   lu.assertEquals(common.replaceUnderscore("FCS_COP.1/AK.Xml"), "FCS\\_COP.1/AK.Xml")
end

function testcommon.test_remove_smart_hyphen()
   lu.assertEquals(common.remove_smart_hyphen([[SF.Card\-Ter\-min\-al\-Mgmt]]), "SF.CardTerminalMgmt")
end

function testcommon.test_generate_label_list_for_tsfi()
   local expected={
    "ls.lan",
    "ls.lan.ether",
    "ls.lan.httpmgmt",
    "ls.lan.ip",
    "ls.lan.tcp",
    "ls.lan.tls",
    "ls.lan.udp",
    "ls.led",
    "ls.wan",
    "ls.wan.dhcp",
    "ls.wan.ether",
    "ls.wan.ip",
    "ls.wan.ipsec",
    "ls.wan.ntp",
    "ls.wan.tcp",
    "ls.wan.udp",
    "no_tsfi"
   }
   lu.assertEquals(common.generate_label_list("tsfi", srckey), expected)
end

function testcommon.test_generate_label_list_for_modules()
   lu.assertEquals(common.generate_label_list("modules", srckey), {
   "mod.adminsystem.mgmt", "mod.adminsystem.webserver",
   "mod.cryptsystem.algorithms", "mod.cryptsystem.keymgmt",
   "mod.cryptsystem.rng", "mod.ntpclient.core", "mod.selfprotect.memory",
   "mod.selfprotect.selftest", "mod.tls.cert", "mod.tls.core", "mod.vpn.cert",
   "mod.vpn.core" })
end

os.exit( lu.LuaUnit.run() )
