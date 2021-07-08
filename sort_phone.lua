
--[[
    桶排序的应用：排序手机号码
]]




local Max = 100
local PhoneLen = 11

--[[
    随机生成手机号
    规则为13|5|7|9xxxxxxxx
]]
local function gen_phone(max)
    local phone_num = {}
    local Er = {'3', '5', '7', '8'}
    for _ = 1, max do
        local phone = "1" .. Er[math.random(1, #Er)] .. tostring(math.random(0, 9))
        phone = phone .. string.format("%08d", math.random(0, 99999999))
        table.insert(phone_num,  phone)
    end
    return phone_num
end


--[[
    排序手机号 思想：
    用桶排序的思想把数据分为10组 先根据手机号码最后一位排序 然后倒数第二 。。。至到首位 这个过程是稳定排序的过程
    算法时间复杂度 K * O(N) == O(N) 当数据量非常大的时候效率远高于快速排序 N*ln(N)
    空间复杂度 O(N)
]]
local function sort_phone(tab_phone)
    local bucket = {}
    for k = 0, PhoneLen - 1 do
        for i = 1, 10 do
            bucket[i] = {}
        end
        for _, v in pairs(tab_phone) do
            local b = string.byte(v, #v - k, #v - k) - 0x30 + 1
            table.insert(bucket[b], v)
        end

        local count = 1
        for _, v in pairs(bucket) do
            for _, vv in pairs(v) do
                tab_phone[count] = vv
                count = count + 1
            end
        end
    end
end


local function test()
    local tab = gen_phone(Max)
    sort_phone(tab)

    for k, v in pairs(tab) do
        print(k, v)
    end
end

test()
