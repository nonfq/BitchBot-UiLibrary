local LIB_URL = "https://raw.githubusercontent.com/nonfq/BitchBot-UiLibrary/main/lib.luau"

local ok, src = pcall(game.HttpGet, game, LIB_URL)
assert(ok and type(src) == "string" and #src > 100, "Could not download the UI library from: " .. LIB_URL)
local chunk, err = loadstring(src)
assert(chunk, "Library failed to compile: " .. tostring(err))

local Lib = chunk({
	Name      = "My Menu",               -- window title
	ToggleKey = Enum.KeyCode.LeftAlt,    -- key that opens / closes the menu
})

-- =====================================================================
--  TAB 1: every element, with a comment saying what it does
-- =====================================================================
local Tab = Lib:AddTab("Showcase")

---------------------------------------------------------------- LEFT SIDE
local Toggles = Tab:AddGroup("Toggles", "left")

-- Plain on/off switch.  :Get() -> true / false
local plainToggle = Toggles:AddToggle("Plain Toggle", false, {
	Tooltip = "Hover text appears here",
})

-- Toggle with a keybind box. Click the box, press a key.
-- KeybindMode: "Hold" (on while held) | "Toggle" (press on/off) | "HoldOff" | "Always"
-- :Get() -> is the toggle switched on?   :IsKeyActive() -> is the key currently "active"?
local keyToggle = Toggles:AddToggle("Toggle + Keybind", false, {
	Keybind = true,              -- or a default key:  Keybind = Enum.KeyCode.E
	KeybindMode = "Toggle",
})

-- Toggle with ONE colour picker.  :GetColor() -> {r,g,b,a}   :GetColor3() -> Color3
local colorToggle = Toggles:AddToggle("Toggle + Color", false, {
	Color = { 255, 80, 80 },
	ColorName = "My Color",
})

-- Toggle with TWO colour pickers.  :GetColor(1) / :GetColor(2)
local twoColorToggle = Toggles:AddToggle("Toggle + 2 Colors", false, {
	Colors = { { 255, 0, 0 }, { 0, 0, 255 } },
	ColorNames = { "Fill", "Outline" },
})

local Sliders = Tab:AddGroup("Sliders", "left")

-- AddSlider(name, start, min, max, options)
local plainSlider = Sliders:AddSlider("Plain Slider", 50, 0, 100)

-- Suffix adds a symbol after the number
local percentSlider = Sliders:AddSlider("Percent Slider", 25, 0, 100, { Suffix = "%" })

-- Decimals = how many decimal places, Custom = replace a number with a word
local customSlider = Sliders:AddSlider("Custom Slider", 0, 0, 10, {
	Decimals = 1,
	Custom = { [0] = "Off" },
})

--------------------------------------------------------------- RIGHT SIDE
local Dropdowns = Tab:AddGroup("Dropdowns", "right")

-- Pick ONE.  :Get() -> number of the choice (1,2,3...)   :GetText() -> the word
local dropdown = Dropdowns:AddDropdown("Single Dropdown", { "Low", "Medium", "High" }, 2)

-- Pick MANY. Each entry is { "Name", startsEnabled }.
-- :GetTable() -> { Head = true, Body = false, ... }
local multi = Dropdowns:AddMultiDropdown("Multi Dropdown", {
	{ "Head", true },
	{ "Body", true },
	{ "Arms", false },
	{ "Legs", false },
})

local Other = Tab:AddGroup("Text & Buttons", "right")

-- Text box. Click it, type, press Enter. :Get() -> the text
local textbox = Other:AddTextbox("Text Box", "type here")

-- Button: name, then the function that runs when clicked
Other:AddButton("Normal Button", function()
	Lib:Notify("You clicked the normal button!")
end)

-- Confirm = true means you have to click twice (good for risky buttons)
Other:AddButton("Confirm Button", function()
	Lib:Notify("Confirmed!")
end, { Confirm = true })

-- Button that prints every value above, so you can see how reading works
Other:AddButton("Print All Values", function()
	print("--- values ---")
	print("Plain Toggle      :", plainToggle:Get())
	print("Keybind Toggle    :", keyToggle:Get(), "| key:", keyToggle:GetKeybind(), "| active:", keyToggle:IsKeyActive())
	print("Color Toggle      :", colorToggle:Get(), colorToggle:GetColor3())
	print("2 Color Toggle    :", twoColorToggle:Get(), twoColorToggle:GetColor3(1), twoColorToggle:GetColor3(2))
	print("Plain Slider      :", plainSlider:Get())
	print("Percent Slider    :", percentSlider:Get())
	print("Custom Slider     :", customSlider:Get())
	print("Single Dropdown   :", dropdown:Get(), dropdown:GetText())
	for name, on in pairs(multi:GetTable()) do print("Multi Dropdown    :", name, on) end
	print("Text Box          :", textbox:Get())
	Lib:Notify("Values printed to the console (F9)")
end)

-- =====================================================================
--  DRAW THE MENU  (always the last menu line; Settings tab is added for you)
-- =====================================================================
Lib:Show()

-- =====================================================================
--  YOUR OWN LOGIC GOES BELOW. Read the handles whenever you need them.
--  Example: a loop that reacts to the plain toggle.
-- =====================================================================
local loop = game:GetService("RunService").Heartbeat:Connect(function()
	if plainToggle:Get() then
		-- do something every frame while the toggle is on
	end
end)

-- Runs when you press Unload, leave the game, or teleport.
-- Disconnect/undo anything YOU created here.
Lib:OnUnload(function()
	loop:Disconnect()
end)
