--[[
    hashmap 元素冲突时线性探测的实现
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
        if item.key == key then     --重复插入
            return 
        else
            if item.del then        --插入的坑位上次是被删除过的
                H.items[k] = {key = key, val = val}
                return true
            end
            local ok
            local i = k + 1
            repeat                 --从下一个开始试探,如果到底了还没有找到，从头开始直到当前        
                if not H.items[i] then
                    H.items[i] = {key = key, val = val}
                    ok = true
                    break
                end
                if i == H.cap then 
                    i = 1
                else
                    i = i + 1
                end
            until (i == k)
            if not ok then                --找到最后都没有找到，就扩容
                H.expand()
                return H.insert(key, val)   
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
    if H.items[k] then
        for i = k, H.cap do               --如果有冲突就要逐一检查，直到相等或者坑位为空
            local item = H.items[i]
            if item then
                if item.key == key then
                    return item.val, i
                end
            else
                break
            end 
        end
    end
end

function H.remove(key)
    local _, k = H.find(key)
    if k then             
        H.items[k] = {del = true}         --坑位不清空，数据清空
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


