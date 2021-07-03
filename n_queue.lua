--[[
    求解N皇后问题
]]

--[[
    tab[i]的值 表示第i层皇后的row位置 即x坐标
    line 层
    num 皇后个数
    res 返回的结果列表
]]
local function search_queen(tab, line, num, res)
    if line == num + 1 then
        local t = {}
        for k, v in pairs(tab) do
            table.insert(t, v)
        end
        table.insert(res, t)
        return
    end

    local jude = function(row)      --在第line行row列摆放时 检查之前的是否合理 即用的反向思维
        for i = 1, line - 1 do
            if tab[i] == row or     --不能在同一个列上
               math.abs(row - tab[i]) == line - i then    --两个点列坐标只差不能等于行坐标只差 即在斜线上
                return false
            end
        end
        return true
    end

    for row = 1, num do
        tab[line] = row
        local bOk = jude(row)
        if bOk then
            search_queen(tab, line + 1, num, res)
        end
    end
end

--[[
    n 为皇后的个数
]]
local function n_queue(n)
    local t = {}
    for i = 1, n do
        table.insert(t, 0)
    end
    local res = {}
    search_queen(t, 1, n, res)

    for k, v in pairs(res) do
        print(k, table.concat(v, ", "))
    end
end


n_queue(8)
