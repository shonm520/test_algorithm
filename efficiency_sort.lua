--[[
  高效排序的实现
  20190702 快速排序
  20200928 堆排序
]]

math.randomseed(os.time())	 
local function quick_sort(arr)           --快速排序
    local partion = function(arr, start, tail)
        if start >= tail then
            return -1
        end
        local small = start - 1
        local m = math.random(start, tail)
        arr[m], arr[tail] = arr[tail], arr[m]
        for i = start, tail do
            if arr[i] < arr[tail] then
                small = small + 1
                if i ~= small then 
                    arr[small], arr[i] = arr[i], arr[small]
                end
            end  
        end
        small = small + 1
        arr[small], arr[tail] = arr[tail], arr[small]
        return small
    end
    
    local function sort(arr, start, tail)
        local ind = partion(arr, start, tail)
        if ind ~= -1 then 
            sort(arr, start, ind - 1)
            sort(arr, ind + 1, tail)
        end
    end
    
    sort(arr, 1, #arr)
end



local function heap_sort(arr_input)               --堆排序

    local function adjust(arr, len, index)        --len的作用仅仅只是限制元素比较的范围 index实际是三元组的父节点
        local left = 2 * index                    --三元组的左右节点
        local right = left + 1

        local max_index = index                   --假设目前最大元素是父节点
        if left < len and arr[left] > arr[max_index] then max_index = left end
        if right < len and arr[right] > arr[max_index] then max_index = right end

        if max_index ~= index then                --如果三元组的最大元素不是他的父节点 则把目前的父节点和最大元素交换
            arr[max_index], arr[index] = arr[index], arr[max_index]
            adjust(arr, len, max_index)           --交换之后可能会影响被交换元素为父节点组成的三元组的规则 所以再次调整那个三元组 递归下去
        end
    end

    local size = #arr_input
    for i = size // 2, 1,  -1 do                  --从最后一个非叶子节点开始 即最后一组三元组(最后一组可能只有2个元素)
        adjust(arr_input, size, i)
    end

    for i = size, 1, -1 do
        arr_input[1], arr_input[i] = arr_input[i], arr_input[1]       --把第i个(从最后一个元素开始依次，该元素就是目前未排序中最大的元素)元素同根元素交换
        adjust(arr_input, i, 1)                     --这时只需要从根步调整三元组，因为他会递归完成的
    end
end

