local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- Global Variables
getgenv().script_name = "1000-7"
getgenv().script_version = "client"

-- Services
local playersService = cloneref(game:GetService("Players"))
local replicatedStorageService = cloneref(game:GetService("ReplicatedStorage"))

-- Variables
local lplr = playersService.LocalPlayer

-- Paths
local questsFolder = lplr:WaitForChild("Quests")
local statsFolder = lplr:WaitForChild("Stats")
local upgradesFolder = lplr:WaitForChild("Upgrades")

-- Tables
local stats = {
    ["1"] = { -- strength
        ["amount"] = statsFolder:WaitForChild("1").Value,
        ["multiplier"] = upgradesFolder:WaitForChild("1").Value
    },
    ["2"] = { -- durability
        ["amount"] = statsFolder:WaitForChild("2").Value,
        ["multiplier"] = upgradesFolder:WaitForChild("2").Value
    },
    ["3"] = { -- chakra
        ["amount"] = statsFolder:WaitForChild("3").Value,
        ["multiplier"] = upgradesFolder:WaitForChild("3").Value
    },
    ["4"] = { -- sword
        ["amount"] = statsFolder:WaitForChild("4").Value,
        ["multiplier"] = upgradesFolder:WaitForChild("4").Value
    },
    ["5"] = { -- agility
        ["amount"] = statsFolder:WaitForChild("5").Value,
        ["multiplier"] = upgradesFolder:WaitForChild("5").Value
    },
    ["6"] = { -- speed
        ["amount"] = statsFolder:WaitForChild("6").Value,
        ["multiplier"] = upgradesFolder:WaitForChild("6").Value
    }
}
local connections = {}

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

local function disconnect(name: string)
    if connections[name] then
        connections[name]:Disconnect()
        connections[name] = nil
    end
end

local function trainStat(stat: number) 
    local args = {
	    "Train",
	    stat
    }
    replicatedStorageService:WaitForChild("shared"):WaitForChild("Remotes"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
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
    if bool then
        disconnect("completedQuestConnection")
        disconnect("newQuestConnection")

        local currentQuest = nil
        local statsToTrain = {}
        for _, quest in pairs(questsFolder:GetChildren()) do
            if string.find(quest.Name, "Boom") and not quest:WaitForChild("Completed").Value and #quest:GetChildren() > 0 then
                currentQuest = quest.Name
                print(currentQuest)
                for _, stat in pairs(questsFolder:WaitForChild(currentQuest):WaitForChild("Requirements"):GetChildren()) do
                    if stats[stat.Name] then
                        statsToTrain[stat.Name] = stat.Value
                    end
                end

                for i, v in pairs(statsToTrain) do
                    print(i, v)
                end
                break
            end
        end

        connections["newQuestConnection"] = questsFolder.ChildAdded:Connect(function(quest)
            if string.find(quest.Name, "Boom") and not quest:WaitForChild("Completed").Value and #quest:GetChildren() > 0 then
                currentQuest = quest.Name
                print(currentQuest)
                for _, stat in pairs(questsFolder:WaitForChild(currentQuest):WaitForChild("Requirements"):GetChildren()) do
                    if stats[stat.Name] then
                        statsToTrain[stat.Name] = stat.Value
                    end
                end

                for i, v in pairs(statsToTrain) do
                    print(i, v)
                end
            end
        end)

        connections["completedQuestConnection"] = questsFolder[currentQuest]:WaitForChild("Completed"):GetPropertyChangedSignal("Value"):Connect(function()
            if true then
                print(`Completed {currentQuest}`)
                currentQuest = nil
                statsToTrain = {}
            end
        end)

        for stat, amount in pairs(statsToTrain) do
            task.spawn(function()
                while currentQuest and statsToTrain[stat] do
                    trainStat(tonumber(stat))
                    task.wait(0.5)
                end
            end)
        end

    else
        disconnect("completedQuestConnection")
        disconnect("newQuestConnection")
        currentQuest = nil
        statsToTrain = {}
    end
end)

-- Connections
for _, stat in pairs(statsFolder:GetChildren()) do
    stat:GetPropertyChangedSignal("Value"):Connect(function()
        stats[stat.Name].amount = stat.Value
        print(`{stats[stat.Name]}'s new amount is: {stats[stat.Name].amount}`)
    end)
end

---34, 80, 3
