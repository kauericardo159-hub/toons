local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--[[ 
===========================================================
🎨 PAINEL UNIVERSE TOONS - TOON STYLE V10 🎨
===========================================================
]]

-- 1. LIMPEZA DE INTERFACES ANTIGAS
local coreName = "SistemaPainel_Toons"
local oldGui = playerGui:FindFirstChild(coreName)
if oldGui then oldGui:Destroy() end

-- 2. ESTRUTURA BASE
local screenGui = Instance.new("ScreenGui")
screenGui.Name = coreName
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true 
screenGui.Parent = playerGui

-- 3. PAINEL PRINCIPAL (Estilo Fofo & Cartunesco)
local painel = Instance.new("Frame")
painel.Name = "Panel" 
painel.Size = UDim2.new(0, 500, 0, 320)
painel.Position = UDim2.new(0.5, 0, 1.5, 0) -- Fora da tela para animação
painel.AnchorPoint = Vector2.new(0.5, 0.5)
painel.BackgroundColor3 = Color3.fromRGB(35, 30, 75) -- Roxo escuro pastel (fundo principal)
painel.BackgroundTransparency = 0.05
painel.Visible = false
painel.ClipsDescendants = false
painel.Parent = screenGui

-- Borda bem arredondada (estilo desenho animado)
local painelCorner = Instance.new("UICorner")
painelCorner.CornerRadius = UDim.new(0, 32)
painelCorner.Parent = painel

-- 4. 🌟 BORDA GRADIENTE ESTILO TOONS (Roxo -> Azul -> Magenta)
local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 6 -- Borda grossa marcante estilo Toon
UIStroke.Transparency = 0
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Parent = painel

local strokeGradient = Instance.new("UIGradient")
strokeGradient.Rotation = 45
strokeGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 120, 220)),   -- Magenta Pastel
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(120, 200, 255)), -- Azul Iluminado
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 210, 100))   -- Amarelo Mágico
})
strokeGradient.Parent = UIStroke

-- 5. 🔮 SOMBRA SUAVE E ELEGANTE
local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.AnchorPoint = Vector2.new(0.5, 0.5)
shadow.BackgroundTransparency = 1
shadow.Position = UDim2.new(0.5, 0, 0.5, 8)
shadow.Size = UDim2.new(1, 50, 1, 50)
shadow.Image = "rbxassetid://6014264792"
shadow.ImageColor3 = Color3.fromRGB(15, 10, 35)
shadow.ImageTransparency = 0.4
shadow.ZIndex = painel.ZIndex - 1
shadow.Parent = painel

-- 6. 🎈 TÍTULO ESTILIZADO (Estilo Logo do Jogo)
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, -40, 0, 50)
titleLabel.Position = UDim2.new(0, 20, 0, 15)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "UNIVERSE TOONS"
titleLabel.Font = Enum.Font.FredokaOne -- Fonte divertida e arredondada
titleLabel.TextSize = 28
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextYAlignment = Enum.TextYAlignment.Center
titleLabel.Parent = painel

local titleStroke = Instance.new("UIStroke")
titleStroke.Thickness = 3
titleStroke.Color = Color3.fromRGB(40, 20, 80)
titleStroke.Parent = titleLabel

local titleGradient = Instance.new("UIGradient")
titleGradient.Rotation = 90
titleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 230, 120)), -- Amarelo
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 140, 0))    -- Laranja
})
titleGradient.Parent = titleLabel

-- 7. 🎬 ANIMAÇÃO ELÁSTICA (Efeito Cartoon/Pop)
local function abrirPainel()
    painel.Visible = true
    
    -- Efeito de "Pulo" (Back Out)
    local tweenInfo = TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    local targetPosition = UDim2.new(0.5, 0, 0.5, 0)
    
    TweenService:Create(painel, tweenInfo, {Position = targetPosition}):Play()
end

-- Rotação contínua da borda mágica
task.spawn(function()
    while painel.Parent do
        local tween = TweenService:Create(strokeGradient, TweenInfo.new(6, Enum.EasingStyle.Linear), {Rotation = 405})
        tween:Play()
        tween.Completed:Wait()
        strokeGradient.Rotation = 45
    end
end)

-- Descomente a linha abaixo para testar a abertura assim que der Play:
abrirPainel()

print("✨ Painel Toons Universe aplicado com sucesso!")
