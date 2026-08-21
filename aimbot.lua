--[[ 
    SCRIPT: ONE TAP AIMBOT + ESP BOX
    GAME: [FPS] Satu Ketuk by Stringless Banjo
    FITUR: Aimbot (Lock Target) + ESP Box + ESP Line (Tracer)
--]]

-- ========== KONFIGURASI ==========
local Settings = {
    Aimbot = {
        Enabled = true,
        Key = "E",              -- Tombol untuk aimbot (E, Q, F, dll)
        Smoothness = 0.3,       -- Kehalusan aim (0-1, makin kecil makin halus)
        FOV = 120,              -- Radius deteksi target (derajat)
        AimPart = "Head"        -- Bagian tubuh: "Head", "HumanoidRootPart", dll
    },
    ESP = {
        Enabled = true,
        Box = true,             -- Box ESP
        Line = true,            -- Garis Tracer
        HealthBar = true,       -- Bar kesehatan
        Color = Color3.fromRGB(255, 0, 0) -- Warna ESP
    }
}

-- ========== JANGAN UBAH DI BAWAH INI ==========
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local AimTarget = nil
local HoldingKey = false

-- ========== FUNGSI UTAMA ==========

-- Fungsi mendapatkan target terdekat
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

-- Fungsi untuk aimbot
local function Aimbot()
    if not Settings.Aimbot.Enabled or not HoldingKey then return end
    
    local target = GetClosestPlayer()
    if not target or not target.Character then return end
    
    local targetPart = target.Character:FindFirstChild(Settings.Aimbot.AimPart) or target.Character:FindFirstChild("HumanoidRootPart")
    if not targetPart then return end
    
    -- Hitung posisi di layar
    local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
    if not onScreen then return end
    
    -- Gerakkan mouse secara halus ke target
    local currentMouse = UserInputService:GetMouseLocation()
    local targetPos = Vector2.new(screenPos.X, screenPos.Y)
    local smoothPos = currentMouse:Lerp(targetPos, Settings.Aimbot.Smoothness)
    
    -- Set posisi mouse (gunakan mousemoverel untuk simulasi)
    local delta = smoothPos - currentMouse
    if delta.Magnitude > 1 then
        mousemoverel(delta.X, delta.Y)
    end
end

-- ========== ESP DRAWING ==========

local Drawing = Drawing or {}
local ESPObjects = {}

-- Fungsi buat box ESP
local function CreateBox(player)
    if not Settings.ESP.Enabled or not Settings.ESP.Box then return end
    
    local esp = {}
    
    -- Buat garis box
    local lines = {}
    for i = 1, 4 do
        local line = Drawing.new("Line")
        line.Thickness = 1.5
        line.Color = Settings.ESP.Color
        line.Transparency = 0.8
        lines[i] = line
    end
    esp.Lines = lines
    
    -- Buat bar kesehatan
    if Settings.ESP.HealthBar then
        local healthBar = Drawing.new("Line")
        healthBar.Thickness = 3
        healthBar.Color = Color3.fromRGB(0, 255, 0)
        healthBar.Transparency = 0.9
        esp.HealthBar = healthBar
    end
    
    -- Nama player
    local nameText = Drawing.new("Text")
    nameText.Text = player.Name
    nameText.Size = 12
    nameText.Center = true
    nameText.Color = Color3.fromRGB(255, 255, 255)
    nameText.Transparency = 0.9
    nameText.Font = 3
    esp.NameText = nameText
    
    -- Garis tracer
    if Settings.ESP.Line then
        local tracer = Drawing.new("Line")
        tracer.Thickness = 1.5
        tracer.Color = Settings.ESP.Color
        tracer.Transparency = 0.7
        esp.Tracer = tracer
    end
    
    ESPObjects[player] = esp
end

-- Fungsi update ESP
local function UpdateESP()
    if not Settings.ESP.Enabled then
        -- Hapus semua ESP
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
            -- Hapus jika player mati
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
        
        -- Dapatkan posisi di layar
        local rootPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
        local headPos = Camera:WorldToViewportPoint(headPart.Position)
        
        if not onScreen then
            -- Sembunyikan jika di luar layar
            for _, line in pairs(esp.Lines) do line.Visible = false end
            if esp.HealthBar then esp.HealthBar.Visible = false end
            if esp.NameText then esp.NameText.Visible = false end
            if esp.Tracer then esp.Tracer.Visible = false end
            continue
        end
        
        -- Hitung ukuran box
        local height = (rootPos.Y - headPos.Y) * 1.5
        local width = height * 0.5
        local top = headPos.Y - (height * 0.1)
        local left = rootPos.X - (width / 2)
        local bottom = top + height
        local right = left + width
        
        -- Update garis box
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
        
        -- Update bar kesehatan
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
        
        -- Update nama
        if esp.NameText then
            esp.NameText.Position = Vector2.new(rootPos.X, top - 18)
            esp.NameText.Visible = true
        end
        
        -- Update tracer
        if esp.Tracer then
            local screenCenter = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
            esp.Tracer.From = screenCenter
            esp.Tracer.To = Vector2.new(rootPos.X, rootPos.Y)
            esp.Tracer.Visible = true
        end
    end
end

-- ========== KEYBIND HANDLER ==========

-- Deteksi tombol ditekan
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
        AimTarget = nil
    end
end)

-- ========== LOOP UTAMA ==========

-- Update setiap frame
RunService.RenderStepped:Connect(function()
    -- Aimbot
    if Settings.Aimbot.Enabled and HoldingKey then
        Aimbot()
    end
    
    -- ESP
    UpdateESP()
end)

-- Tambahkan ESP untuk player yang join
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        CreateBox(player)
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

print("✅ SCRIPT LOADED!")
print("🔫 Tekan " .. Settings.Aimbot.Key .. " untuk Aimbot")
print("📦 ESP Box + Line Aktif")