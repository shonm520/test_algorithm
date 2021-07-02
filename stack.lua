
--[[
    栈的应用
    计算表达式的值 简单的四则运算 不包括()
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

local function cal(num1, num2, op)
    if op == '+' then
        return num1 + num2
    elseif op == '-' then
        return num1 - num2
    elseif op == '*' then
        return num1 * num2
    elseif op == '/' then
        return num1 / num2
    else
        print("invalide op", op)
    end
end

--[[
    计算表达式的逻辑
    利用两个栈 栈1装载操作数 栈2装载操作方法如 +-*/
    当要压入操作符时 先判断栈2顶层的操作符优先级是否大于等于它 是就先求栈中的值
    例如 1 * 2 + 3   遇到 + 时 优先级低于 *  故先计算1 * 2 然后压入栈
    1 + 2 + 3 也是先计算1 + 2 这样只需一遍计算 就可以了 不需要到最后才把相同等级的运算计算一遍
    还一个注意的点是  取操作数时的先后顺序 对于+ * 是没有关系 但是对于- /就很重要了
    2 - 1 由于先压入2 后压入1 所有取操作数时应该是先pop的那个值是num2 后pop的那个值是num1 
]]
local function cal_exp(exp)
    local op_level = {
        ["+"] = 1,
        ["-"] = 1,
        ["*"] = 2,
        ["/"] = 2,
    }

    local stack_num = new_obj(Stack)
    local stack_op  = new_obj(Stack)

    for k, v in pairs(exp) do
        if op_level[v] then     --是操作符
            local top = stack_op:top()
            if top and op_level[top] >= op_level[v] then
                local num2 = stack_num:pop()
                local num1 = stack_num:pop()
                local op_top = stack_op:pop()
                local ret = cal(num1, num2, op_top)
                stack_num:push(ret)
            end
            stack_op:push(v)
        else
            if type(v) == "number" then
                stack_num:push(v)
                local top = stack_op:top()
                if top and op_level[top] == 2 then
                    local num2 = stack_num:pop()
                    local num1 = stack_num:pop()
                    local op_top = stack_op:pop()
                    local ret = cal(num1, num2, op_top)
                    stack_num:push(ret)
                end
            else
                error("input is valid")
            end            
        end
    end

    assert(stack_num:size() == 2, "num invalide " .. stack_num:size())
    assert(stack_op:size() == 1, "op invalide " .. stack_op:size())

    local num2 = stack_num:pop()
    local num1 = stack_num:pop()
    local op_top = stack_op:pop()
    local ret = cal(num1, num2, op_top)
    return ret
end


--[[
    由于解析纯表达式比较麻烦 这里直接用table来装载表达式的各项
]]
local function test()
    local t = {1, "+", 1, "+", 2, "*", 3, "*", 1, "/", 1, "/", 9}
    local ret = cal_exp(t)
    print("ret is :", ret)
end

test()
