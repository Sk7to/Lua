-- Global Variables
getgenv().script_name = "kitty"
getgenv().script_version = "client"

-- Services
local playersService = cloneref(game:GetService("Players"))

-- Variables
local lplr = playersService.LocalPlayer

-- Functions
local function getChar()
    return lplr.Character or lplr.CharacterAdded:Wait()
end

local function getHum()
    return getChar():WaitForChild("Humanoid")
end

local function getRoot()
    return getHum().RootPart or getHum():GetPropertyChangedSignal("RootPart"):Wait()
end

-- User Interface
local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/panduh16/juju/main/ui.lua"))()
local menu = lib["menu"]

local main = lib["menu"].create_group("Main")
main:create_tab("Training")

local autofarm_section = main:create_section("Training", "Macros", 1, 1, 0)

local main_quest_macro = autofarm_section:create_element({["name"] = "Main Quest"}, {
    ["toggle"] = {["flag"] = "!main_quest_macro", ["default"] = false}
})

local connection = lib["create_connection"](main_quest_macro["on_toggle_change"], function(bool)
    print(bool)
end)