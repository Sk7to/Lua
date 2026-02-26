local playersService = cloneref(game:GetService("Players"))
local lplr = playersService.LocalPlayer

local functions = {}

function functions.getChar()
    return lplr.Character or lplr.CharacterAdded:Wait()
end

function functions.getHum()
    return functions.getChar():WaitForChild("Humanoid")
end

function functions.getRoot()
    return functions.getHum().RootPart or functions.getHum():GetPropertyChangedSignal("RootPart"):Wait()
end

function functions.printHello()
    print("Hello")
end

return functions