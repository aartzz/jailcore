--[[
       _         _____ _      _____ ____  _____  ______ 
      | |  /\   |_   _| |    / ____/ __ \|  __ \|  ____|
      | | /  \    | | | |   | |   | |  | | |__) | |__   
  _   | |/ /\ \   | | | |   | |   | |  | |  _  /|  __|  
 | |__| / ____ \ _| |_| |___| |___| |__| | | \ \| |____ 
  \____/_/    \_\_____|______\_____\____/|_|  \_\______|
             BB0.1 // perc.ct.ws // main.lua
--]]

-- Instances:

local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local ImageLabel = Instance.new("ImageLabel")
local TextLabel = Instance.new("TextLabel")
local ImageButton = Instance.new("ImageButton")
local Frame_2 = Instance.new("Frame")

--Properties:

ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

Frame.Parent = ScreenGui
Frame.Active = true
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.0305967834, 0, 0.0369884893, 0)
Frame.Size = UDim2.new(0, 525, 0, 454)

ImageLabel.Parent = Frame
ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ImageLabel.BackgroundTransparency = 1.000
ImageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
ImageLabel.BorderSizePixel = 0
ImageLabel.Position = UDim2.new(0.213333443, 0, 0.0242290758, 0)
ImageLabel.Size = UDim2.new(0, 301, 0, 58)
ImageLabel.Image = "rbxassetid://100503944749966"

TextLabel.Parent = Frame
TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.BackgroundTransparency = 1.000
TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.BorderSizePixel = 0
TextLabel.Position = UDim2.new(0.304761916, 0, 0.151982382, 0)
TextLabel.Size = UDim2.new(0, 205, 0, 21)
TextLabel.Font = Enum.Font.Unknown
TextLabel.Text = "perc.ct.ws"
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextScaled = true
TextLabel.TextSize = 14.000
TextLabel.TextWrapped = true

ImageButton.Parent = Frame
ImageButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ImageButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
ImageButton.BorderSizePixel = 0
ImageButton.Position = UDim2.new(0.0568591021, 0, 0.26342532, 0)
ImageButton.Size = UDim2.new(0, 130, 0, 130)
ImageButton.Image = "rbxassetid://7699371504"

Frame_2.Parent = Frame
Frame_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Frame_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame_2.BorderSizePixel = 0
Frame_2.Position = UDim2.new(0.0201554354, 0, 0.21418339, 0)
Frame_2.Size = UDim2.new(0, 503, 0, 4)

-- Scripts:

local function QEGRY_fake_script() -- Frame.LocalScript 
	local script = Instance.new('LocalScript', Frame)

	local frame = script.Parent
	
	frame.Draggable = true
end
coroutine.wrap(QEGRY_fake_script)()
local function ZTHXMUS_fake_script() -- ImageButton.LocalScript 
	local script = Instance.new('LocalScript', ImageButton)

	local HttpService = game:GetService("HttpService")
	local imageButton = script.Parent
	local frameToDestroy = script.Parent.Parent  -- Assuming the Frame to destroy is the parent of the ImageButton
	
	imageButton.MouseButton1Click:Connect(function()
	    local url = "https://raw.githubusercontent.com/aartzz/jailcore/main/arsenal.lua"
	    local success, response = pcall(function()
	        return HttpService:GetAsync(url)
	    end)
	
	    if success and response then
	        local scriptSuccess, errorMessage = pcall(loadstring(response))
	        if not scriptSuccess then
	            warn("Failed to execute script: " .. errorMessage)
	        else
	            -- Destroy the frame after successful script execution
	            if frameToDestroy and frameToDestroy:IsA("Frame") then
	                frameToDestroy:Destroy()
	            else
	                warn("Frame to destroy not found or is not a Frame.")
	            end
	        end
	    else
	        warn("Failed to load script from URL: " .. (response or "Unknown error"))
	    end
	end)
	
	
end
