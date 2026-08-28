local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--[[ 
===========================================================
       🎈 CONTROLADOR DO BOTÃO TOONS UNIVERSE (DRAGGABLE) 🎈
===========================================================
]]

-- Ícone temático estilo Toon/Estrela (substitua pelo ID da logo se preferir)
local BUTTON_ID_CLOSED = "rbxassetid://6031097225" 
local MENU_NAME = "InterfaceMenu_Toons"
local PAINEL_CORE_NAME = "SistemaPainel_Toons"
local BUTTON_SIZE = 65
local HOLD_TIME = 1.5 -- Tempo em segundos para liberar o arraste (ajustado para ser mais ágil)

-- 1. CONFIGURAÇÃO DE EFEITOS
local blurEffect = Lighting:FindFirstChild("MenuBlur") or Instance.new("BlurEffect", Lighting)
blurEffect.Name = "MenuBlur"
blurEffect.Size = 0

-- Limpeza de versões antigas
local oldMenu = playerGui:FindFirstChild(MENU_NAME)
if oldMenu then oldMenu:Destroy() end

-- 2. CRIAÇÃO DA INTERFACE
local screenGui = Instance.new("ScreenGui")
screenGui.Name = MENU_NAME
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

local mainButton = Instance.new("ImageButton") 
mainButton.Name = "ToggleButton"
mainButton.Size = UDim2.new(0, BUTTON_SIZE, 0, BUTTON_SIZE)
mainButton.Position = UDim2.new(0, 25, 0.4, -(BUTTON_SIZE/2))
mainButton.BackgroundColor3 = Color3.fromRGB(35, 30, 75) -- Roxo escuro pastel
mainButton.BackgroundTransparency = 0.05
mainButton.Image = BUTTON_ID_CLOSED
mainButton.ScaleType = Enum.ScaleType.Fit
mainButton.AutoButtonColor = false
mainButton.Parent = screenGui

-- Estilização Toon Circular e Gradiente
local corner = Instance.new("UICorner", mainButton)
corner.CornerRadius = UDim.new(1, 0) -- Totalmente redondo

local stroke = Instance.new("UIStroke", mainButton)
stroke.Thickness = 4
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local buttonGradient = Instance.new("UIGradient", stroke)
buttonGradient.Rotation = 45
buttonGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 120, 220)),   -- Magenta Pastel
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(120, 200, 255)), -- Azul Iluminado
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 210, 100))   -- Amarelo Mágico
})

-- 3. VARIÁVEIS DE CONTROLE
local isOpen = false
local isAnimating = false
local dragging = false
local canDrag = false
local dragInput, dragStart, startPos
local holdTimer = 0

-- 4. FUNÇÃO TOGGLE (ABRIR/FECHAR COM EFEITO POP)
local function toggleUI()
    if dragging or canDrag then return end
    local coreGui = playerGui:FindFirstChild(PAINEL_CORE_NAME)
    local painel = coreGui and coreGui:FindFirstChild("Panel")
    if not painel or isAnimating then return end
    
    isAnimating = true
    isOpen = not isOpen
    
    -- Animações Toon com EasingStyle.Back
    local openTweenInfo = TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    local closeTweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In)

    if isOpen then
        painel.Visible = true
        TweenService:Create(painel, openTweenInfo, {Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
        TweenService:Create(blurEffect, TweenInfo.new(0.5), {Size = 12}):Play()
        TweenService:Create(mainButton, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Rotation = 15}):Play()
    else
        local closeTween = TweenService:Create(painel, closeTweenInfo, {Position = UDim2.new(0.5, 0, 1.6, 0)})
        closeTween:Play()
        TweenService:Create(blurEffect, TweenInfo.new(0.5), {Size = 0}):Play()
        TweenService:Create(mainButton, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Rotation = 0}):Play()
        closeTween.Completed:Connect(function() 
            if not isOpen then painel.Visible = false end 
        end)
    end
    task.wait(0.6)
    isAnimating = false
end

-- 5. LÓGICA DE ARRASTAR (DRAG)
local function updateDrag(input)
    local delta = input.Position - dragStart
    mainButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

mainButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        local currentHold = true
        holdTimer = tick()
        
        -- Efeito visual de clique Toon (Encolhe)
        TweenService:Create(mainButton, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, BUTTON_SIZE - 10, 0, BUTTON_SIZE - 10)
        }):Play()

        -- Checar hold time para liberar arraste
        task.delay(HOLD_TIME, function()
            if (tick() - holdTimer) >= HOLD_TIME and currentHold then
                canDrag = true
                -- Pulso Amarelo para indicar modo de edição/movimento
                TweenService:Create(mainButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 200, 50)}):Play()
                print("✨ Modo de movimento ativado!")
            end
        end)

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                currentHold = false
                if not canDrag then
                    toggleUI()
                end
                canDrag = false
                dragging = false
                TweenService:Create(mainButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 30, 75)}):Play()
                TweenService:Create(mainButton, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
                    Size = UDim2.new(0, BUTTON_SIZE, 0, BUTTON_SIZE)
                }):Play()
            end
        end)
        
        dragStart = input.Position
        startPos = mainButton.Position
    end
end)

mainButton.InputChanged:Connect(function(input)
    if canDrag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        dragging = true
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateDrag(input)
    end
end)

-- Hover Effects Cartoon
mainButton.MouseEnter:Connect(function()
    TweenService:Create(mainButton, TweenInfo.new(0.2), {
        Size = UDim2.new(0, BUTTON_SIZE + 6, 0, BUTTON_SIZE + 6),
        BackgroundColor3 = Color3.fromRGB(50, 42, 100)
    }):Play()
end)

mainButton.MouseLeave:Connect(function()
    if not dragging then
        TweenService:Create(mainButton, TweenInfo.new(0.2), {
            Size = UDim2.new(0, BUTTON_SIZE, 0, BUTTON_SIZE),
            BackgroundColor3 = Color3.fromRGB(35, 30, 75)
        }):Play()
    end
end)

-- Rotação contínua da borda gradiente
task.spawn(function()
    while mainButton.Parent do
        local tween = TweenService:Create(buttonGradient, TweenInfo.new(5, Enum.EasingStyle.Linear), {Rotation = 405})
        tween:Play()
        tween.Completed:Wait()
        buttonGradient.Rotation = 45
    end
end)

print("✅ Botão Toons Universe configurado com sucesso!")

