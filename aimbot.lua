--[[ 
    SCRIPT: ONE TAP AIMBOT + ESP BOX (Mobile/Delta)
    GAME: [FPS] Satu Ketuk by Stringless Banjo
    OPTIMIZED: Untuk Delta Executor di HP Android
    FITUR: UI Toggle (Buka/Tutup) + Aimbot + ESP Box + Tracer + Health Bar
--]]

-- ========== KONFIGURASI ==========
local Settings = {
    Aimbot = {
        Enabled = false,        -- Default mati, aktifkan dari UI
        Key = "E",              -- Tombol untuk aimbot (E, Q, F, dll)
        Smoothness = 0.3,       
        FOV = 150,              
        AimPart = "Head"        
    },
    ESP = {
        Enabled = false,        -- Default mati, aktifkan dari UI
        Box = true,             
        Line = true,            
        HealthBar = true,       
        Color = Color3.fromRGB(0, 255, 255) -- Warna cyan biar keren
    }
}

-- ========== JANGAN UBAH DI BAWAH INI ==========
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local ScreenGui = Instance.new("ScreenGui")
local HoldingKey = false

-- ========== UI TOGGLE (BUKA/TUTUP) ==========
local function CreateUI()
    -- Buat ScreenGui
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.Name = "OneTapUI"
    ScreenGui.ResetOnSpawn = false
    
    -- Tombol Toggle (di pojok kiri atas)
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Parent = ScreenGui
    ToggleButton.Size = UDim2.new(0, 120, 0, 40)
    ToggleButton.Position = UDim2.new(0, 10, 0, 10)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    ToggleButton.BackgroundTransparency = 0.2
    ToggleButton.BorderSizePixel = 2
    ToggleButton.BorderColor3 = Color3.fromRGB(0, 200, 255)
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.TextSize = 14
    ToggleButton.Font = Enum.Font.GothamBold
    ToggleButton.Text = "☰ Menu"
    ToggleButton.ZIndex = 10
    
    -- Panel Menu (muncul saat toggle diklik)
    local MenuPanel = Instance.new("Frame")
    MenuPanel.Parent = ScreenGui
    MenuPanel.Size = UDim2.new(0, 250, 0, 300)
    MenuPanel.Position = UDim2.new(0, 10, 0, 60)
    MenuPanel.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    MenuPanel.BackgroundTransparency = 0.15
    MenuPanel.BorderSizePixel = 2
    MenuPanel.BorderColor3 = Color3.fromRGB(0, 200, 255)
    MenuPanel.Visible = false
    MenuPanel.ZIndex = 10
    
    -- Judul
    local Title = Instance.new("TextLabel")
    Title.Parent = MenuPanel
    Title.Size = UDim2.new(1, 0, 0, 35)
    Title.Position = UDim2.new(0, 0, 0, 0)
    Title.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    Title.BackgroundTransparency = 0.3
    Title.Text = "⚡ ONE TAP CONTROL ⚡"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 16
    Title.Font = Enum.Font.GothamBold
    Title.ZIndex = 11
    
    -- ====== TOGGLE AIMBOT ======
    local AimbotLabel = Instance.new("TextLabel")
    AimbotLabel.Parent = MenuPanel
    AimbotLabel.Size = UDim2.new(0, 100, 0, 30)
    AimbotLabel.Position = UDim2.new(0, 10, 0, 45)
    AimbotLabel.BackgroundTransparency = 1
    AimbotLabel.Text = "🔫 Aimbot"
    AimbotLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    AimbotLabel.TextSize = 14
    AimbotLabel.Font = Enum.Font.GothamBold
    AimbotLabel.TextXAlignment = Enum.TextXAlignment.Left
    AimbotLabel.ZIndex = 11
    
    local AimbotToggle = Instance.new("TextButton")
    AimbotToggle.Parent = MenuPanel
    AimbotToggle.Size = UDim2.new(0, 60, 0, 30)
    AimbotToggle.Position = UDim2.new(0, 170, 0, 45)
    AimbotToggle.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    AimbotToggle.Text = "OFF"
    AimbotToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    AimbotToggle.TextSize = 14
    AimbotToggle.Font = Enum.Font.GothamBold
    AimbotToggle.ZIndex = 11
    
    -- ====== TOGGLE ESP ======
    local ESPLabel = Instance.new("TextLabel")
    ESPLabel.Parent = MenuPanel
    ESPLabel.Size = UDim2.new(0, 100, 0, 30)
    ESPLabel.Position = UDim2.new(0, 10, 0, 85)
    ESPLabel.BackgroundTransparency = 1
    ESPLabel.Text = "👁️ ESP"
    ESPLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    ESPLabel.TextSize = 14
    ESPLabel.Font = Enum.Font.GothamBold
    ESPLabel.TextXAlignment = Enum.TextXAlignment.Left
    ESPLabel.ZIndex = 11
    
    local ESPToggle = Instance.new("TextButton")
    ESPToggle.Parent = MenuPanel
    ESPToggle.Size = UDim2.new(0, 60, 0, 30)
    ESPToggle.Position = UDim2.new(0, 170, 0, 85)
    ESPToggle.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    ESPToggle.Text = "OFF"
    ESPToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    ESPToggle.TextSize = 14
    ESPToggle.Font = Enum.Font.GothamBold
    ESPToggle.ZIndex = 11
    
    -- ====== KEYBIND INFO ======
    local KeyLabel = Instance.new("TextLabel")
    KeyLabel.Parent = MenuPanel
    KeyLabel.Size = UDim2.new(1, 0, 0, 30)
    KeyLabel.Position = UDim2.new(0, 0, 0, 130)
    KeyLabel.BackgroundTransparency = 1
    KeyLabel.Text = "🎯 Tekan 'E' untuk Aimbot"
    KeyLabel.TextColor3 = Color3.fromRGB(150, 150, 200)
    KeyLabel.TextSize = 12
    KeyLabel.Font = Enum.Font.Gotham
    KeyLabel.ZIndex = 11
    
    -- ====== VISUAL TOGGLE ======
    local function UpdateAimbotButton()
        if Settings.Aimbot.Enabled then
            AimbotToggle.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
            AimbotToggle.Text = "ON"
        else
            AimbotToggle.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            AimbotToggle.Text = "OFF"
        end
    end
    
    local function UpdateESPButton()
        if Settings.ESP.Enabled then
            ESPToggle.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
            ESPToggle.Text = "ON"
        else
            ESPToggle.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            ESPToggle.Text = "OFF"
        end
    end
    
    -- ====== FUNGSI TOMBOL ======
    -- Toggle menu
    ToggleButton.MouseButton1Click:Connect(function()
        MenuPanel.Visible = not MenuPanel.Visible
        if MenuPanel.Visible then
            ToggleButton.Text = "✕ Tutup"
        else
            ToggleButton.Text = "☰ Menu"
        end
    end)
    
    -- Toggle Aimbot
    AimbotToggle.MouseButton1Click:Connect(function()
        Settings.Aimbot.Enabled = not Settings.Aimbot.Enabled
        UpdateAimbotButton()
        if Settings.Aimbot.Enabled then
            print("✅ Aimbot Aktif! Tekan E untuk aim")
        else
            print("❌ Aimbot Mati")
        end
    end)
    
    -- Toggle ESP
    ESPToggle.MouseButton1Click:Connect(function()
        Settings.ESP.Enabled = not Settings.ESP.Enabled
        UpdateESPButton()
        if Settings.ESP.Enabled then
            print("✅ ESP Aktif!")
        else
            print("❌ ESP Mati")
            -- Hapus semua ESP
            for _, esp in pairs(ESPObjects) do
                for _, line in pairs(esp.Lines) do line:Remove() end
                if esp.HealthBar then esp.HealthBar:Remove() end
                if esp.NameText then esp.NameText:Remove() end
                if esp.Tracer then esp.Tracer:Remove() end
            end
            ESPObjects = {}
        end
    end)
    
    -- Inisialisasi tombol
    UpdateAimbotButton()
    UpdateESPButton()
    
    -- ====== FUNGSI UNTUK HP (Touch) ======
    -- Buat tombol aimbot di layar (untuk sentuh)
    local TouchAimButton = Instance.new("TextButton")
    TouchAimButton.Parent = ScreenGui
    TouchAimButton.Size = UDim2.new(0, 80, 0, 80)
    TouchAimButton.Position = UDim2.new(0.8, 0, 0.7, 0) -- Pojok kanan bawah
    TouchAimButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    TouchAimButton.BackgroundTransparency = 0.3
    TouchAimButton.BorderSizePixel = 3
    TouchAimButton.BorderColor3 = Color3.fromRGB(255, 255, 255)
    TouchAimButton.Text = "🔫\nAIM"
    TouchAimButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TouchAimButton.TextSize = 16
    TouchAimButton.Font = Enum.Font.GothamBold
    TouchAimButton.ZIndex = 5
    TouchAimButton.Visible = true
    
    -- Sentuh untuk aim (seperti tombol tembak)
    TouchAimButton.TouchBegan:Connect(function()
        HoldingKey = true
        TouchAimButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        TouchAimButton.BackgroundTransparency = 0.1
    end)
    
    TouchAimButton.TouchEnded:Connect(function()
        HoldingKey = false
        TouchAimButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        TouchAimButton.BackgroundTransparency = 0.3
    end)
end

-- ========== FUNGSI AIMBOT ==========
local function GetClosestPlayer()
    local closest = nil
    local closestDistance = Settings.Aimbot.FOV
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local rootPart = player.Character.HumanoidRootPart
            local screenPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
            
            if onScreen then
                local distance = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                if distance < closestDistance then
                    closestDistance = distance
                    closest = player
                end
            end
        end
    end
    return closest
end

local function Aimbot()
    if not Settings.Aimbot.Enabled or not HoldingKey then return end
    
    local target = GetClosestPlayer()
    if not target or not target.Character then return end
    
    local targetPart = target.Character:FindFirstChild(Settings.Aimbot.AimPart) or target.Character:FindFirstChild("HumanoidRootPart")
    if not targetPart then return end
    
    local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
    if not onScreen then return end
    
    local currentMouse = UserInputService:GetMouseLocation()
    local targetPos = Vector2.new(screenPos.X, screenPos.Y)
    local smoothPos = currentMouse:Lerp(targetPos, Settings.Aimbot.Smoothness)
    
    local delta = smoothPos - currentMouse
    if delta.Magnitude > 1 then
        mousemoverel(delta.X, delta.Y)
    end
end

-- ========== ESP DRAWING ==========
local Drawing = Drawing or {}
local ESPObjects = {}

local function CreateBox(player)
    if not Settings.ESP.Enabled or not Settings.ESP.Box then return end
    
    local esp = {}
    local lines = {}
    for i = 1, 4 do
        local line = Drawing.new("Line")
        line.Thickness = 2
        line.Color = Settings.ESP.Color
        line.Transparency = 0.8
        lines[i] = line
    end
    esp.Lines = lines
    
    if Settings.ESP.HealthBar then
        local healthBar = Drawing.new("Line")
        healthBar.Thickness = 3
        healthBar.Color = Color3.fromRGB(0, 255, 0)
        healthBar.Transparency = 0.9
        esp.HealthBar = healthBar
    end
    
    local nameText = Drawing.new("Text")
    nameText.Text = player.Name
    nameText.Size = 14
    nameText.Center = true
    nameText.Color = Color3.fromRGB(255, 255, 255)
    nameText.Transparency = 0.9
    nameText.Font = 3
    esp.NameText = nameText
    
    if Settings.ESP.Line then
        local tracer = Drawing.new("Line")
        tracer.Thickness = 2
        tracer.Color = Settings.ESP.Color
        tracer.Transparency = 0.7
        esp.Tracer = tracer
    end
    
    ESPObjects[player] = esp
end

local function UpdateESP()
    if not Settings.ESP.Enabled then
        for _, esp in pairs(ESPObjects) do
            for _, line in pairs(esp.Lines) do line:Remove() end
            if esp.HealthBar then esp.HealthBar:Remove() end
            if esp.NameText then esp.NameText:Remove() end
            if esp.Tracer then esp.Tracer:Remove() end
        end
        ESPObjects = {}
        return
    end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        
        if not ESPObjects[player] then
            CreateBox(player)
        end
        
        local esp = ESPObjects[player]
        if not esp then continue end
        
        local character = player.Character
        if not character then
            for _, line in pairs(esp.Lines) do line:Remove() end
            if esp.HealthBar then esp.HealthBar:Remove() end
            if esp.NameText then esp.NameText:Remove() end
            if esp.Tracer then esp.Tracer:Remove() end
            ESPObjects[player] = nil
            continue
        end
        
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        local headPart = character:FindFirstChild("Head")
        local humanoid = character:FindFirstChild("Humanoid")
        if not rootPart or not headPart or not humanoid then continue end
        
        local rootPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
        local headPos = Camera:WorldToViewportPoint(headPart.Position)
        
        if not onScreen then
            for _, line in pairs(esp.Lines) do line.Visible = false end
            if esp.HealthBar then esp.HealthBar.Visible = false end
            if esp.NameText then esp.NameText.Visible = false end
            if esp.Tracer then esp.Tracer.Visible = false end
            continue
        end
        
        local height = (rootPos.Y - headPos.Y) * 1.5
        local width = height * 0.5
        local top = headPos.Y - (height * 0.1)
        local left = rootPos.X - (width / 2)
        local bottom = top + height
        local right = left + width
        
        local linePositions = {
            {left, top, right, top},
            {right, top, right, bottom},
            {right, bottom, left, bottom},
            {left, bottom, left, top}
        }
        
        for i, line in pairs(esp.Lines) do
            if i <= #linePositions then
                line.From = Vector2.new(linePositions[i][1], linePositions[i][2])
                line.To = Vector2.new(linePositions[i][3], linePositions[i][4])
                line.Visible = true
            end
        end
        
        if esp.HealthBar then
            local healthPercent = humanoid.Health / humanoid.MaxHealth
            local barX = left - 6
            local barY = top
            local barHeight = height * healthPercent
            
            esp.HealthBar.From = Vector2.new(barX, bottom - barHeight)
            esp.HealthBar.To = Vector2.new(barX, bottom)
            esp.HealthBar.Color = Color3.fromRGB(
                255 * (1 - healthPercent),
                255 * healthPercent,
                0
            )
            esp.HealthBar.Visible = true
        end
        
        if esp.NameText then
            esp.NameText.Position = Vector2.new(rootPos.X, top - 20)
            esp.NameText.Visible = true
        end
        
        if esp.Tracer then
            local screenCenter = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
            esp.Tracer.From = screenCenter
            esp.Tracer.To = Vector2.new(rootPos.X, rootPos.Y)
            esp.Tracer.Visible = true
        end
    end
end

-- ========== KEYBIND KEYBOARD (E) ==========
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode[Settings.Aimbot.Key] then
        HoldingKey = true
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode[Settings.Aimbot.Key] then
        HoldingKey = false
    end
end)

-- ========== LOOP UTAMA ==========
RunService.RenderStepped:Connect(function()
    if Settings.Aimbot.Enabled and HoldingKey then
        Aimbot()
    end
    if Settings.ESP.Enabled then
        UpdateESP()
    end
end)

-- ========== INIT ==========
-- Panggil UI
pcall(function()
    CreateUI()
end)

-- Tambahkan ESP untuk player baru
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        if Settings.ESP.Enabled then
            CreateBox(player)
        end
    end)
end)

-- Hapus ESP saat player keluar
Players.PlayerRemoving:Connect(function(player)
    if ESPObjects[player] then
        local esp = ESPObjects[player]
        for _, line in pairs(esp.Lines) do line:Remove() end
        if esp.HealthBar then esp.HealthBar:Remove() end
        if esp.NameText then esp.NameText:Remove() end
        if esp.Tracer then esp.Tracer:Remove() end
        ESPObjects[player] = nil
    end
end)

print("✅ SCRIPT LOADED! (Mobile/Delta Optimized)")
print("📱 Klik ☰ Menu di pojok kiri atas")
print("🔫 Tombol AIM di kanan bawah untuk aim (touch)")
print("⌨️ Tekan E di keyboard untuk aim (jika ada)")