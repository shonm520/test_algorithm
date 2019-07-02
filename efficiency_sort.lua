--[[
  高效排序的实现
  data:20190702
]]

math.randomseed(os.time())	 
local function quick_sort(arr)
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
