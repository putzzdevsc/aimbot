-- Script Exploit FPS Satu Ketuk (Android / GameGuardian + Lua)
-- Fitur: AIMBOT, ESP LINE & BOX, UI TOGGLE
-- Kompatibel dengan executor Lua di HP (GG, LGL, atau similar)

-- ===== KHAI BÁO TOÀN CỤC =====
local aimbotActive = false
local espActive = false
local uiVisible = true

-- Địa chỉ giả định (thay bằng địa chỉ thực tế trong game)
local PLAYER_PTR = 0x12345678   -- Con trỏ người chơi
local ENEMY_LIST_PTR = 0x87654321 -- Danh sách địch
local VIEW_ANGLE_X = 0x11223344
local VIEW_ANGLE_Y = 0x55667788

-- ===== HÀM VẼ UI =====
function drawUI()
    if not uiVisible then return end
    gg.toast("=== FPS EXPLOIT ===")
    gg.toast("[1] Bật/tắt Aimbot: " .. tostring(aimbotActive))
    gg.toast("[2] Bật/tắt ESP: " .. tostring(espActive))
    gg.toast("[3] Đóng UI")
end

-- ===== HÀM AIMBOT =====
function aimbot()
    if not aimbotActive then return end
    local player = gg.getValues({{address = PLAYER_PTR, flags = gg.TYPE_FLOAT}})
    local enemies = gg.getValues({{address = ENEMY_LIST_PTR, flags = gg.TYPE_DWORD}})
    
    local targetX, targetY = 0, 0
    local minDist = 9999
    
    for i = 1, #enemies do
        local enemyAddr = enemies[i].value
        if enemyAddr ~= 0 then
            local enemyPos = gg.getValues({
                {address = enemyAddr, flags = gg.TYPE_FLOAT},
                {address = enemyAddr + 0x4, flags = gg.TYPE_FLOAT}
            })
            local dx = enemyPos[1].value - player[1].value
            local dy = enemyPos[2].value - player[1].value
            local dist = math.sqrt(dx*dx + dy*dy)
            if dist < minDist then
                minDist = dist
                targetX = enemyPos[1].value
                targetY = enemyPos[2].value
            end
        end
    end
    
    if minDist < 9999 then
        gg.setValues({
            {address = VIEW_ANGLE_X, value = targetX, flags = gg.TYPE_FLOAT},
            {address = VIEW_ANGLE_Y, value = targetY, flags = gg.TYPE_FLOAT}
        })
    end
end

-- ===== HÀM ESP (LINE & BOX) =====
function esp()
    if not espActive then return end
    local enemies = gg.getValues({{address = ENEMY_LIST_PTR, flags = gg.TYPE_DWORD}})
    
    for i = 1, #enemies do
        local enemyAddr = enemies[i].value
        if enemyAddr ~= 0 then
            local enemyPos = gg.getValues({
                {address = enemyAddr, flags = gg.TYPE_FLOAT},
                {address = enemyAddr + 0x4, flags = gg.TYPE_FLOAT},
                {address = enemyAddr + 0x8, flags = gg.TYPE_FLOAT} -- chiều cao
            })
            -- Vẽ LINE (kết nối từ tâm màn hình đến enemy)
            gg.drawLine({
                x1 = 0.5, y1 = 0.5,  -- tâm màn hình
                x2 = enemyPos[1].value, y2 = enemyPos[2].value,
                color = 0xFF0000FF, -- màu đỏ
                width = 2
            })
            -- Vẽ BOX (hình hộp bao quanh enemy)
            local halfW = 0.05
            local halfH = 0.1
            gg.drawBox({
                x = enemyPos[1].value - halfW, y = enemyPos[2].value - halfH,
                width = halfW * 2, height = halfH * 2,
                color = 0x00FF00FF, -- màu xanh lá
                thickness = 2
            })
        end
    end
end

-- ===== XỬ LÝ PHÍM BẤM (TOGGLE) =====
function handleInput()
    -- Giả lập phím bấm: sử dụng gg.prompt để nhận lệnh
    local choice = gg.prompt({
        "Nhập lệnh (1: Aimbot, 2: ESP, 3: Đóng UI)"
    }, {[1] = "1"}, {[1] = "number"})
    
    if choice == nil then return false end
    local cmd = choice[1]
    
    if cmd == 1 then
        aimbotActive = not aimbotActive
        gg.toast("Aimbot: " .. tostring(aimbotActive))
    elseif cmd == 2 then
        espActive = not espActive
        gg.toast("ESP: " .. tostring(espActive))
    elseif cmd == 3 then
        uiVisible = false
        gg.toast("Đã đóng UI")
        return false
    end
    return true
end

-- ===== VÒNG LẬP CHÍNH =====
while true do
    drawUI()
    aimbot()
    esp()
    if not handleInput() then break end
    gg.sleep(100) -- delay 100ms để tránh lag
end

gg.toast("Script đã dừng")