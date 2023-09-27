
require("mysqloo")
include("../../config/database.lua")

AGF.DB = {}

---Variables---

AGF.DB.Var = {}

AGF.DB.Var.table = ''
AGF.DB.Var.select = {'i.*'}
AGF.DB.Var.join = ''
AGF.DB.Var.where = ''
AGF.DB.Var.group_by = ''
AGF.DB.Var.order_by = ''
AGF.DB.Var.limit = 1000
AGF.DB.Var.where_second_use = false

---Variables---

AGF.DB.Object = mysqloo.connect(AGF.Settings.DB.host, AGF.Settings.DB.user, AGF.Settings.DB.password, AGF.Settings.DB.database_name, AGF.Settings.DB.port)

AGF.DB.Object:connect()

function AGF.DB.Object:onConnected()
	print("Connection to DataBase successful")
end

function AGF.DB.Object:onConnectionFailed(err)
	print("-----------------------------------")
	print("MySql connection failed")
	print("Error: "..err)
	print("-----------------------------------")
end

function AGF.DB.Query(sql_query)
	
	if AGF.DB.Object:status() ~= 0 then
		if AGF.DB.Object:status() == 1 then
			AGF.DB.Object:wait()
		elseif AGF.DB.Object:status() == 2 then
			AGF.DB.Object:connect()
		elseif AGF.DB.Object:status() == 3 then
			print("Internal error")
		end
	end
	
	local query = AGF.DB.Object:query(sql_query)
	
	local data = {}
	
	function query:onSuccess(response)
		if #response > 0 then
			data = response
		else
			data = "null" //{response = "NULL"}
		end
	end
	
	function query:onError(err, sql_query)

		print("****************************************************")
		print("MySQL Query: "..sql_query)
		print("----------------------------------------------------")
		print("Error: "..err)
		print("****************************************************")

	end
	
	query:start()
	query:wait()
	
	return data
	
end

function AGF.DB.Insert(name_table, data_table)
	
	local keys, values = {}, {}
	
	for key, value in pairs(data_table) do
		table.insert(keys, "`"..key.."`")
		table.insert(values, "'"..value.."'")
	end

	keys = string.Implode(", ", keys)
	values = string.Implode(", ", values)
	
	local sql_query = "INSERT INTO `"..name_table.."` ("..keys..") VALUES ("..values..")"
	
	AGF.DB.Query(sql_query)
	
end

function AGF.DB.Update(name_table, data_table, filter_table)

	local keys_and_values, filter = {}, {}
	
	for key, value in pairs(filter_table) do
		table.insert(filter, key.."='"..value.."'")
	end
	
	for key, value in pairs(data_table) do
		table.insert(keys_and_values, "`"..key.."`='"..value.."'")
	end

	keys_and_values = string.Implode(", ", keys_and_values)
	
	filter = string.Implode(", ", filter)
	
	local sql_query = "UPDATE `"..name_table.."` SET "..keys_and_values.." WHERE "..filter
	
	AGF.DB.Query(sql_query)

end

function AGF.DB.InsertOrUpdate(name_table, data_table)

	local keys, values, set = {}, {}, {}
	
	for key, value in pairs(data_table) do
		table.insert(keys, key)
		table.insert(values, "'"..value.."'")
		table.insert(set, "`"..key.."` = ".."'"..value.."'")
	end

	keys = string.Implode(", ", keys)
	values = string.Implode(", ", values)
	set = string.Implode(", ", set)
	
	local sql_query = "INSERT INTO "..name_table.." ("..keys..") VALUES ("..values..") ON DUPLICATE KEY UPDATE "..set
	
	AGF.DB.Query(sql_query)

end

function AGF.DB.Select(field, as)

	local var = as and "i."..field.." as "..as or "i."..field
	
	table.insert(AGF.DB.Var.select, var)

end

function AGF.DB.Filter(condition)

	if (AGF.DB.Var.where_second_use) then
	
		AGF.DB.Var.where = AGF.DB.Var.where.." AND "
	
	end
	
	AGF.DB.Var.where = AGF.DB.Var.where.."("..condition..")"
	
	AGF.DB.Var.where_second_use = true

end

function AGF.DB.FilterEqual(field, value)

	AGF.DB.Filter(field.." = '"..value.."'")

end

function AGF.DB.Join(name_table, as, on)

	AGF.DB.Var.join = AGF.DB.Var.join.."JOIN "..name_table.." as "..as.." ON "..on

end

function AGF.DB.GroupBy(field)

	AGF.DB.Var.group_by = AGF.DB.Var.group_by..field

end

function AGF.DB.OrderBy(field)

	AGF.DB.Var.order_by = AGF.DB.Var.order_by..field

end

function AGF.DB.Limit(from, how_many)

	AGF.DB.Var.limit = from
	
	if (how_many ~= nil) then
		
		AGF.DB.Var.limit = AGF.DB.Var.limit..", "..how_many
		
	end

end

function AGF.DB.Get(name_table)

	AGF.DB.Var.table = name_table
	
	local sql_query = AGF.DB.GetSQL()
	
	AGF.DB.ResetFilters()
	
	local data = AGF.DB.Query(sql_query)
	
	return data

end

function AGF.DB.GetSQL()

	if(#AGF.DB.Var.select != 1) then table.remove(AGF.DB.Var.select, 1) end

	local select = string.Implode(', ', AGF.DB.Var.select)
	
	local sql_query = "SELECT "..select.." FROM "..AGF.DB.Var.table.." i"
	
	if (AGF.DB.Var.join ~= "") then sql_query = sql_query..AGF.DB.Var.join end
	
	if (AGF.DB.Var.where ~= "") then sql_query = sql_query.." WHERE "..AGF.DB.Var.where end
	
	if (AGF.DB.Var.group_by ~= "") then sql_query = sql_query.." GROUP BY "..AGF.DB.Var.group_by end
	
	if (AGF.DB.Var.order_by ~= "") then sql_query = sql_query.." ORDER BY "..AGF.DB.Var.order_by end
	
	sql_query = sql_query.." LIMIT "..AGF.DB.Var.limit
	
	return sql_query

end

function AGF.DB.ResetFilters()

	AGF.DB.Var.select = {'i.*'}
	AGF.DB.Var.join = ''
	AGF.DB.Var.where = ''
	AGF.DB.Var.group_by = ''
	AGF.DB.Var.order_by = ''
	AGF.DB.Var.limit = 1000
	AGF.DB.Var.where_second_use = false

end