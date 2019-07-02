--[[
    三种基础排序算法的实现
    date:20190702
]]



local function print_t(arr)
    local str = ''
    for i = 1, #arr do
        str = str..string.format('%d ', arr[i])
    end
    print(str)
end



--[[
    冒泡排序的思路很简单，每次都从数组的最后一个元素开始，与左边的元素比较，大于则交换
    一遍交换后，第一个元素就是最小的元素了，第二遍交换后，第二个元素就是次小的了。。。
    所以内层循环总是从最后一个元素开始的，递减直到倒数第i个，所以外层循环最后递增
    冒泡排序有个优化的地方，当一遍遍历的时候发现没有元素交换，说明都已经排好序了
]]
local function bubble_sort(arr)
    local len = #arr
    for i = 1, len - 1 do
        local flag 
        for j = len, i + 1, -1 do 
            if arr[j] < arr[j - 1] then
                arr[j], arr[j - 1] = arr[j - 1], arr[j]
                flag = true
            end
        end
        if not flag then
            break
        end
    end
end


--[[
    插入排序的思路也简单，从第二个元素开始，与前面的元素比较，大于则交换，这样前面的2个元素就是有序的
    然后再把第三个元素与前面的有序元素依次对比。。。
    插入排序类似于我们排序扑克牌，从牌堆里拿一张牌，然后把这张牌插入到手上的有序牌堆中的正确位置
]]
local function insert_sort(arr)
    local len = #arr
    for i = 2, len do 
        for j = i, 2, -1 do 
            if arr[j] < arr[j - 1] then
                arr[j], arr[j - 1] = arr[j - 1], arr[j]
            end
        end
    end
end


--[[
    选择排序的思路也很简单，从后面的元素中选择最小的一个元素，与当前的元素交换，因此前面的元素就是有序的
    选择排序有个缺陷就是，他是不稳定的排序
    例如5, 5.1, 1(这里为了区分，5 == 5.1)经过选择排序之后就是1, 5.1, 5, 因此他是不稳定的
]]
local function select_sort(arr)
    local len = #arr
    for i = 1, len do
        local small = i
        for j = i + 1, len do 
            if arr[j] < arr[small] then
               small = j
            end
        end
        if arr[small] < arr[i] then
            arr[small], arr[i] = arr[i], arr[small]
        end
    end
end


local arr = {7,4,6,8,1,9,2,5,3,0}
local function test(arr, fc)
    print('sort bf:')
    print_t(arr)
    fc(arr)
    print('sort aft:')
    print_t(arr)
end



local function test_time(arr, fc, n)
    local s = os.time()
    for i = 1, n do
        fc(arr)
    end
    local sp = os.time() - s
    return sp
end


local fcs = {
    {name = 'bubble_sort', fc = bubble_sort},
    {name = 'insert_sort', fc = insert_sort},
    {name = 'select_sort', fc = select_sort},
}

for _, v in pairs(fcs) do
    local sp = test_time(arr, v.fc, 5000000)
    print(v.name, 'time span is ', sp)
end

--[[
    结果为：
    bubble_sort	time span is 	3
    insert_sort	time span is 	11
    select_sort	time span is 	13
    我们看到优化过后的冒泡排序是最快的
    插入排序要比选择排序快
]]

