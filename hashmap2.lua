--[[
    hashmap 元素冲突时开链的实现(由于lua不习惯表示链表，故用table实现)
    auth:shonm
    date:20190701
]]

local hash = function(key, cap)
    local k = key % cap
    if k == 0 then
        k = cap
    end
    return k
end

local H = {
    items = {}
}

function H.init(cap)                --初始化大小                
    H.cap = cap or 1024
end

function H.insert(key, val)   
    if not key or not val then 
        return
    end
    local k = hash(key, H.cap)
    local item = H.items[k]
    if item then                    --有碰撞
        if H.find(key) then         --重复插入
            return 
        else
            if not H.items[k].siblings then      --第一次碰撞
                H.items[k].siblings = {}
                table.insert(H.items[k].siblings, {key = item.key, val = item.val})
                table.insert(H.items[k].siblings, {key = key, val = val})
                H.items[k].key = nil
                H.items[k].val = nil
            else
                table.insert(H.items[k].siblings, {key = key, val = val})
            end
        end
    else                                  --没碰撞直接加入
        H.items[k] = {key = key, val = val}
        return true
    end
end 

function H.expand(fac)
    local old_cap = H.cap
    H.cap = H.cap * (fac or 2)
    H.temp = H.items
    H.items = {}
    for i = 1, old_cap do
        local item = H.temp[i]
        if item then
            H.insert(item.key, item.val)
        end
    end
end

function H.find(key)                      --返回值，slot id 
    local k = hash(key, H.cap)
    local item = H.items[k]
    if item then
        if next(item.siblings or {}) then
            for _, v in pairs(item.siblings) do 
                if v.key == key then
                    return v.val, k
                end
            end
        else
            if item.key == key then
                return item.val, k
            end
        end
    end
end

function H.remove(key)
    local _, k = H.find(key)
    if k then 
        local item = H.items[k].siblings
        if next(item or {}) then
            for i = #item, 1 do
                if item[i].key == key then 
                    table.remove(item, item[i])
                end
            end
        else
            H.items[k] = nil
        end
    end
end

function H.print()
    for k, v in pairs(H.items) do 
        if not v.del then
            print(string.format('slot:%d, key:%d, val:%d', k, v.key, v.val))
        end
    end
end

H.init(10)
H.insert(11, 110)
H.insert(21, 210)
H.insert(31, 310)

-- H.insert(32, 320)
-- H.insert(36, 360)
-- H.insert(15, 150)
-- H.insert(28, 280)
-- H.insert(9, 90)
-- H.insert(2, 20)
-- H.insert(3, 30)
H.insert(6, 60)
H.insert(38, 380)
H.insert(9, 990)

H.remove(11)
H.insert(1, 10)



local v = H.find(21)
H.print()


