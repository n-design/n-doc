tg = {}

local relationtypes = {enf = "Enforcing", sup = "Supporting"}

local eol = [[\\]]
-- local ps_eol = eol .. "*"
local ps_eol = eol
local eoc = " & "

function tg.column_iterator_3(t)
   local max_col = 3
   local s = 1
   local num_rows = math.floor(#t / max_col)
   if #t % max_col > 0 then
      num_rows = num_rows + 1
   end
   return function()
      local col1 = s
      local col2 = s+num_rows
      local col3 = s+(2*num_rows)
      if s > num_rows then return nil end
      s=s+1
      return col1, col2, col3 
   end
end

function tg.column_iterator_4(t)
   local max_col = 4
   local s = 1
   local num_rows = math.floor(#t / max_col)
   if #t % max_col > 0 then
      num_rows = num_rows + 1
   end
   return function()
      local col1 = s
      local col2 = s+num_rows
      local col3 = s+(2*num_rows)
      local col4 = s+(3*num_rows)
      if s > num_rows then return nil end
      s=s+1
      return col1, col2, col3, col4
   end
end

tg.column_iterators = {}
tg.column_iterators[3] = tg.column_iterator_3
tg.column_iterators[4] = tg.column_iterator_4

function tg.get_module_status(key)
   local cc_core = require("cc_core")
   return cc_core.get_module_status(key)
end

tg.itemformatters = {
   tsfi = function(i) if i then return "\\tsfi{" .. i .. "}" end end,
   tsfianchor = function(i) if i then return "\\hypertarget{" .. i .. "}{\\tsfi{" .. i .. "}}" end end,      
   tsfilink = function(i) if i then return "\\tsfilink{" .. i .. "}" end end,
   sflink = function(i) if i then return "\\secfunclink{" .. i .. "}" end end,
   bundle = function(i) if i then return "\\bundle{" .. i .. "}" end end,
   sfr = function(i) if i then return "\\sfrlink{" .. i .. "}" end end,
   sfrnolink = function(i) if i then return "\\sfr{" .. i .. "}" end end,
   sfrnoindex = function(i) if i then return "\\sfrlinknoindex{" .. i .. "}" end end,
   module = function(i) if i then return "\\tdslink[fq]{" .. i .. "}" end end,
   modulestatus = function(i) if i then return "\\tdslink[fq]{" .. i .. "} & " .. tg.get_module_status(i) end end,
   sfranchor = function(i) if i then return "\\index{\\sfrplain{" .. i .. "}@\\sfr{" .. i .. "}|textbf}\\hypertarget{" .. i .. "}{\\sfr{".. i .."}}" end end,
   sfranchornoindex = function(i) if i then return "\\hypertarget{" .. i .. "}{\\sfr{".. i .."}}" end end
}

function tg.print_sfr_table_for_subsys(enfsup, sfrs)
   local result = {"\\begin{enfsfrsubsystable}"}
   table.insert(result, relationtypes[enfsup])
   table.insert(result, [[~SFR & \ndocpurpose \\\midrule\relax]])
   if #sfrs > 0 then
      local formatsfr = tg.itemformatters["sfrnoindex"]
      for _,v in pairs(sfrs) do
	 row = {}
	 table.insert(row, formatsfr(v.sfr))
	 table.insert(row, v.purpose and eoc)
	 table.insert(row, v.purpose)
	 if #row > 0 then
	    table.insert(row, eol)
	 end
	 table.insert(result, table.concat(row))
      end
   else
      table.insert(result,[[\ndocnone]])
      table.insert(result, eol)
   end
   table.insert(result,"\\end{enfsfrsubsystable}")
   return table.concat(result)
end

function tg.print_sfr_table_for_module(enfsup, sfrs)
   local result = {"\\begin{enfsfrtable}"}
   table.insert(result, relationtypes[enfsup])
   table.insert(result, "~SFR\\\\\\midrule\\relax")
   if #sfrs > 0 then
      local formatsfr = tg.itemformatters["sfrnoindex"]
      for col1, col2, col3 in tg.column_iterator_3(sfrs) do
         local row = {}
         local sfr1 = formatsfr(sfrs[col1])
         local sfr2 = formatsfr(sfrs[col2])
         local sfr3 = formatsfr(sfrs[col3])
         table.insert(row, sfr1)
         table.insert(row, sfr2 and eoc)
         table.insert(row, sfr2)
         table.insert(row, sfr3 and eoc)
         table.insert(row, sfr3)
         if #row > 0 then
	    table.insert(row, eol)
	 end
	 table.insert(result, table.concat(row))
      end
   else
      table.insert(result,[[\ndocnone]])
      table.insert(result, eol)
   end
   table.insert(result,"\\end{enfsfrtable}")
   return table.concat(result)
end

function tg.print_bundle_table_for_module(bundles)
   local result = {"\\begin{bundletable}"}
   table.insert(result, "Bundles\\\\\\midrule\\relax")
   for _,bundle in pairs(bundles) do
      local row = {}
      table.insert(row, tg.itemformatters["bundle"](bundle))
      if #row > 0 then
	 table.insert(row, eol)
      end
      table.insert(result, table.concat(row))
   end
   table.insert(result,"\\end{bundletable}")
   return table.concat(result)
end


function tg.print_item_list(items, itemtype, outputparams)
   local result = {}
   local sepchar = outputparams and outputparams["sepchar"] or ", "
   local emptyitem = outputparams and outputparams["emptyitem"] or [[\ndocnone]]
   for _,item in pairs(items) do
      table.insert(result, tg.itemformatters[itemtype](item))
   end
   if #result==0 then table.insert(result, emptyitem) end
   return table.concat(result, sepchar)
end

function tg.generate_modules_for_sfr_row(sfr, enf_modules, sup_modules)
    local result = {"\\midrule\\relax"}
    local formatsfr = tg.itemformatters["sfranchor"]
    
    table.insert(result, formatsfr(sfr) .. " & Enforcing & ")
    appendmodules(enf_modules, result)
    
    table.insert(result, "& Supporting & ")
    appendmodules(sup_modules, result)
    
    if result[#result] == ps_eol then result[#result] = eol end
    return table.concat(result)
end

function appendmodules(modules, result)
    if #modules > 0 then
        local formatmod = tg.itemformatters["module"]
        for i, module in pairs(modules) do
            if i > 1 then
                table.insert(result, "& & ")
            end
            table.insert(result, formatmod(module))
            table.insert(result, ps_eol)
        end
    else
       table.insert(result,[[\ndocnone]])
        table.insert(result, ps_eol)
    end
end

function tg.generate_tsfi_for_sfr_row(sfr, tsfi)
    local result = {"\\midrule\\relax"}
    local formatsfr = tg.itemformatters["sfranchornoindex"]

    table.insert(result, formatsfr(sfr) .. " & ")
    appendtsfi(tsfi, result)

    if result[#result] == ps_eol then result[#result] = eol end
    return table.concat(result)
end

function appendtsfi(tsfi, result)
    if #tsfi > 0 then
        local formattsfi = tg.itemformatters["tsfilink"]
        for i, ls in pairs(tsfi) do
            if i > 1 then
                table.insert(result, "&")
            end
            table.insert(result, formattsfi(ls.label))
            table.insert(result, "&")
            table.insert(result, ls.purpose)
            table.insert(result, ps_eol)
        end
    else
       table.insert(result,[[\ndocnone]])
        table.insert(result, ps_eol)
    end
end


function tg.generate_sfr_for_tsfi_row(tsfi, sfr)
    local result = {"\\midrule\\relax"}
    local formattsfi = tg.itemformatters["tsfianchor"]

    table.insert(result, formattsfi(tsfi) .. " & ")
    appendsfr(sfr, result)

    if result[#result] == ps_eol then result[#result] = eol end
    return table.concat(result)
end

function appendsfr(sfr, result)
    if #sfr > 0 then
        local formatsfr = tg.itemformatters["sfr"]
        for i, ls in pairs(sfr) do
            if i > 1 then
                table.insert(result, "&")
            end
            table.insert(result, formatsfr(ls.label))
            table.insert(result, "&")
            table.insert(result, ls.purpose)
            table.insert(result, ps_eol)
        end
    else
       table.insert(result,[[\ndocnone]])
        table.insert(result, ps_eol)
    end
end

function tg.generate_testcase_row(testcase, submods, sfrs, tsfis)
   local result = {}
   table.insert(result, testcase:gsub("_", "\\_") .. eoc)
   table.insert(result, tg.print_item_list(submods, "module"))
   table.insert(result, eoc)
   table.insert(result, tg.print_item_list(sfrs, "sfrnolink"))
   table.insert(result, eoc)
   table.insert(result, tg.print_item_list(tsfis, "tsfi"))
   table.insert(result, eol .. "[1ex]")
   return table.concat(result)
end

function tg.generate_numbers_rows(items, label, counterfunc, columns)
   local result = {}
   local formatter = tg.itemformatters[label]
   local col_iterator = tg.column_iterators[columns]
   for col1, col2, col3, col4 in col_iterator(items) do
      local row = {}
      local item_col1 = formatter(items[col1])
      local item_col2 = formatter(items[col2])
      local item_col3 = formatter(items[col3])
      local item_col4 = formatter(items[col4])
      -- 1. Eintrag
      table.insert(row, item_col1)
      table.insert(row, eoc)
      table.insert(row, counterfunc(items[col1]))
      -- 2. Eintrag
      table.insert(row, item_col2 and eoc)
      table.insert(row, item_col2 and item_col2)
      table.insert(row, item_col2 and eoc)
      table.insert(row, item_col2 and counterfunc(items[col2]))
      -- 3. Eintrag
      table.insert(row, item_col3 and eoc)
      table.insert(row, item_col3 and item_col3)
      table.insert(row, item_col3 and eoc)
      table.insert(row, item_col3 and counterfunc(items[col3]))
         -- 4. Eintrag
      table.insert(row, item_col4 and eoc)
      table.insert(row, item_col4 and item_col4)
      table.insert(row, item_col4 and eoc)
      table.insert(row, item_col4 and counterfunc(items[col4]))
      if #row > 0 then
	 table.insert(row, eol)
      end
      table.insert(result, table.concat(row))
   end
   return table.concat(result)
end

return tg
