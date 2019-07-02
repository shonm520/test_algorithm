--[[
    hashmap 元素冲突时开链的实现
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
        else                        --把新元素作为表头
            H.items[k] = {key = key, val = val}
            H.items[k].next = item
        end
    else                            --没碰撞直接加入
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
        repeat 
            if item.key == key then
                return item.val, k
            else
                item = item.next
            end
        until (not item)
    end
end

function H.remove(key)
    local _, k = H.find(key)
    if k then 
        local item = H.items[k]
        if item.next then
            if item.key == key then
                H.items[k] = item.next
            else
                repeat
                    if item.next.key == key then
                        item.next = item.next.next
                        break
                    else
                        item = item.next
                    end
                until (not item)                
            end
        else
            H.items[k] = nil
        end
    end
end

function H.print()
    for k, v in pairs(H.items) do 
        repeat
            local next = v.next
            print(string.format('slot:%d, key:%d, val:%d', k, v.key, v.val)) 
        until (not next)
    end
end


t = {1,2,3,4,5,6,7}
for i = #t , 1, -1 do
    table.remove(t, i)
end
t = {1,2,3,4,5,6,7}
for k, v in pairs(t) do
    table.remove(t, k)
end

H.init(10)
H.insert(11, 110)
H.insert(21, 210)
H.insert(31, 310)

H.remove(31)
H.remove(11)
H.remove(21)


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
H.remove(38)
H.insert(1, 10)



local v = H.find(21)
H.print()
