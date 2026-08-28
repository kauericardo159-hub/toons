local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--[[ 
===========================================================
       🎈 SISTEMA DE NOTIFICAÇÕES (TOONS UNIVERSE) 🎈
===========================================================
]]

local function notify(titleText, messageText, status)
    -- status: true (Ativado/Verde Menta) | false (Desativado/Rosa Magenta)
    
    local coreName = "ToonsNotifications"
    local screenGui = playerGui:FindFirstChild(coreName) or Instance.new("ScreenGui", playerGui)
    screenGui.Name = coreName
    screenGui.DisplayOrder = 100 -- Fica acima de todas as outras UIs
    
    -- 1. PALETA DE CORES TOON
    local colorSuccess = Color3.fromRGB(80, 230, 140)  -- Verde Menta
    local colorDanger = Color3.fromRGB(255, 100, 130)  -- Rosa Chiclete / Vermelho Toon
    local accentColor = status and colorSuccess or colorDanger
    local bgColor = Color3.fromRGB(35, 30, 75)          -- Roxo Escuro Pastel
    
    -- 2. ESTRUTURA DO CARD (Toast)
    local toast = Instance.new("Frame")
    toast.Name = "ToonToast"
    toast.Size = UDim2.new(0, 300, 0, 75)
    toast.Position = UDim2.new(1.3, 0, 0.82, 0) -- Começa escondido à direita
    toast.BackgroundColor3 = bgColor
    toast.BackgroundTransparency = 0.05
    toast.BorderSizePixel = 0
    toast.Parent = screenGui

    local corner = Instance.new("UICorner", toast)
    corner.CornerRadius = UDim.new(0, 20)

    -- Borda Mágica Estilizada
    local stroke = Instance.new("UIStroke", toast)
    stroke.Thickness = 3.5
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    
    local strokeGradient = Instance.new("UIGradient", stroke)
    strokeGradient.Rotation = 45
    strokeGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, accentColor),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, accentColor)
    })

    -- Sombra Profunda estilo Desenho
    local shadow = Instance.new("ImageLabel", toast)
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 45, 1, 45)
    shadow.Position = UDim2.new(0.5, 0, 0.5, 4)
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://6014264792"
    shadow.ImageColor3 = Color3.fromRGB(15, 10, 35)
    shadow.ImageTransparency = 0.35
    shadow.ZIndex = toast.ZIndex - 1

    -- Ícone de Status (⭐ para Ativado | ❌ para Desativado)
    local iconLabel = Instance.new("TextLabel", toast)
    iconLabel.Size = UDim2.new(0, 40, 0, 40)
    iconLabel.Position = UDim2.new(0, 12, 0.5, 0)
    iconLabel.AnchorPoint = Vector2.new(0, 0.5)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = status and "✨" or "💥"
    iconLabel.TextSize = 26
    iconLabel.Parent = toast

    -- Título
    local title = Instance.new("TextLabel", toast)
    title.Size = UDim2.new(1, -65, 0, 26)
    title.Position = UDim2.new(0, 56, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = titleText:upper()
    title.TextColor3 = accentColor
    title.Font = Enum.Font.FredokaOne
    title.TextSize = 16
    title.TextXAlignment = Enum.TextXAlignment.Left

    local titleStroke = Instance.new("UIStroke", title)
    titleStroke.Thickness = 2
    titleStroke.Color = Color3.fromRGB(15, 10, 30)

    -- Mensagem
    local msg = Instance.new("TextLabel", toast)
    msg.Size = UDim2.new(1, -65, 0, 22)
    msg.Position = UDim2.new(0, 56, 0, 34)
    msg.BackgroundTransparency = 1
    msg.Text = messageText
    msg.TextColor3 = Color3.fromRGB(240, 240, 255)
    msg.Font = Enum.Font.FredokaOne
    msg.TextSize = 13
    msg.TextXAlignment = Enum.TextXAlignment.Left

    local msgStroke = Instance.new("UIStroke", msg)
    msgStroke.Thickness = 1.5
    msgStroke.Color = Color3.fromRGB(15, 10, 30)

    -- Barra de Progresso Fofa (5 segundos)
    local progressBacking = Instance.new("Frame", toast)
    progressBacking.Size = UDim2.new(1, -24, 0, 5)
    progressBacking.Position = UDim2.new(0, 12, 1, -10)
    progressBacking.BackgroundColor3 = Color3.fromRGB(20, 15, 40)
    progressBacking.BorderSizePixel = 0
    Instance.new("UICorner", progressBacking).CornerRadius = UDim.new(1, 0)

    local progressBar = Instance.new("Frame", progressBacking)
    progressBar.Size = UDim2.new(1, 0, 1, 0)
    progressBar.BackgroundColor3 = accentColor
    progressBar.BorderSizePixel = 0
    Instance.new("UICorner", progressBar).CornerRadius = UDim.new(1, 0)

    -- 3. SOM POP / TOON
    local sound = Instance.new("Sound", toast)
    sound.SoundId = "rbxassetid://9114223179" -- Efeito sonoro suave/pop
    sound.Volume = 0.6
    sound:Play()

    -- 4. ANIMAÇÃO DE ENTRADA E SAÍDA (Efeito Pulo Cartoon)
    local targetPos = UDim2.new(1, -320, 0.82, 0)
    local exitPos = UDim2.new(1.3, 0, 0.82, 0)

    -- Pulo para a tela
    TweenService:Create(toast, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = targetPos
    }):Play()

    -- Animação da barra do timer
    local progressTween = TweenService:Create(progressBar, TweenInfo.new(5, Enum.EasingStyle.Linear), {
        Size = UDim2.new(0, 0, 1, 0)
    })
    progressTween:Play()

    -- Animação da borda brilhando
    task.spawn(function()
        while toast.Parent do
            local tween = TweenService:Create(strokeGradient, TweenInfo.new(3, Enum.EasingStyle.Linear), {Rotation = 405})
            tween:Play()
            tween.Completed:Wait()
            strokeGradient.Rotation = 45
        end
    end)

    -- Encerramento e saída
    task.delay(5, function()
        if toast and toast.Parent then
            local exitTween = TweenService:Create(toast, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                Position = exitPos
            })
            exitTween:Play()
            exitTween.Completed:Connect(function()
                toast:Destroy()
            end)
        end
    end)
end

-- Exportar Globalmente
_G.NotifyElite = notify

print("✨ NotificationManager Toons Universe carregado!")

