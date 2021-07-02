--[[
    栈的应用2
    匹配括号
]]

local Stack = {}

--[[
    下面是栈的接口
]]
function Stack:init()
    self.items = {}
end

function Stack:push(item)
    self.items[#self.items + 1] = item
end

function Stack:pop()
    if #self.items == 0 then
        error("Stack has no items!")
    end
    local item = self.items[#self.items]
    table.remove(self.items, #self.items)
    return item
end

function Stack:top()
    local item = self.items[#self.items]
    return item
end

function Stack:size()
    return #self.items
end


local function new_obj(obj)
    obj = obj or {}
    local new_o = setmetatable({}, {__index = obj})
    if new_o.init then
        new_o:init()
    end
    return new_o
end




--[[
    判断字符串是否为有效的括号对 例如 {[()]}
    利用栈 遇到左括号时压入 右括号判断并弹出
    弹出时采用符合的绝对值是否一样来判断 (和)的绝对值一样
]]
local function match(str)
    -- local op = {
    --     "(" = -1,
    --     '[' = -2,
    --     '{' = -3,
    --     ')' = 1,
    --     ']' = 2,
    --     '}' = 3,
    -- }

    local stack = new_obj(Stack)
    for i = 1, string.len(str) do
        local s = string.sub(str, i, i)
        local v
        if s == "(" then
            v = -1
        elseif s == "[" then
            v = -2
        elseif s == "{" then
            v = -3
        elseif s == ")" then
            v = 1
        elseif s == "]" then
            v = 2
        elseif s == "}" then
            v = 3
        end
        if v then
            if v < 0 then
                stack:push(v)
            else
                local t = stack:top()
                if t and t == v * -1 then
                    stack:pop()
                else
                    error("op not match") 
                end
            end
        else
            error("invalide op")
        end        
    end

    if stack:size() ~= 0 then
        error("op not match: more op left")
    end
end


local function test()
    match("[][]{[()]}")
end

test()
