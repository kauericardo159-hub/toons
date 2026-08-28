local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

--[[ 
===========================================================
       🎈 GERENCIADOR DA LISTA DE OPÇÕES (TOONS UNIVERSE) 🎈
===========================================================
]]

-- 1. LOCALIZAÇÃO E LIMPEZA
local playerGui = player:WaitForChild("PlayerGui")
local coreGui = playerGui:WaitForChild("SistemaPainel_Toons")
local painel = coreGui:WaitForChild("Panel")

if painel:FindFirstChild("ListaOpcoesContainer") then
    painel.ListaOpcoesContainer:Destroy()
end

-- 2. CONTAINER PRINCIPAL (ScrollingFrame)
local listaContainer = Instance.new("ScrollingFrame")
listaContainer.Name = "ListaOpcoesContainer"
listaContainer.Size = UDim2.new(0.55, 0, 0.7, 0) 
listaContainer.Position = UDim2.new(0.95, 0, 0.58, 0)
listaContainer.AnchorPoint = Vector2.new(1, 0.5)

listaContainer.BackgroundTransparency = 0.85
listaContainer.BackgroundColor3 = Color3.fromRGB(15, 10, 30)
listaContainer.BorderSizePixel = 0

-- Barra de Rolagem Estilizada (Toon Glow)
listaContainer.ScrollBarThickness = 6
listaContainer.ScrollBarImageColor3 = Color3.fromRGB(255, 120, 220)
listaContainer.ScrollBarImageTransparency = 0.2
listaContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
listaContainer.ClipsDescendants = true
listaContainer.ZIndex = painel.ZIndex + 2
listaContainer.Parent = painel

-- 3. ESTILIZAÇÃO VISUAL (Borda Arredondada & Gradiente Mágico)
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 18)
uiCorner.Parent = listaContainer

local uiStroke = Instance.new("UIStroke")
uiStroke.Thickness = 3
uiStroke.Transparency = 0.2
uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
uiStroke.Parent = listaContainer

local strokeGradient = Instance.new("UIGradient")
strokeGradient.Rotation = 45
strokeGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 120, 220)),   -- Magenta
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(120, 200, 255)), -- Azul
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 210, 100))   -- Amarelo
})
strokeGradient.Parent = uiStroke

-- 4. ORGANIZAÇÃO AUTOMÁTICA DOS ITENS
local layout = Instance.new("UIListLayout")
layout.Parent = listaContainer
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 10)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 12)
padding.PaddingBottom = UDim.new(0, 12)
padding.PaddingLeft = UDim.new(0, 10)
padding.PaddingRight = UDim.new(0, 10)
padding.Parent = listaContainer

-- 5. GERADOR GLOBAL DE CARDS DE OPÇÃO (Para Minipainéis Externos)
_G.AddToonListItem = function(id, titulo, iconeId, callback)
    local itemFrame = Instance.new("Frame")
    itemFrame.Name = "Item_" .. tostring(id)
    itemFrame.Size = UDim2.new(1, 0, 0, 48)
    itemFrame.BackgroundColor3 = Color3.fromRGB(48, 42, 95)
    itemFrame.BackgroundTransparency = 0.1
    itemFrame.Parent = listaContainer

    local itemCorner = Instance.new("UICorner")
    itemCorner.CornerRadius = UDim.new(0, 14)
    itemCorner.Parent = itemFrame

    local itemStroke = Instance.new("UIStroke")
    itemStroke.Thickness = 2
    itemStroke.Color = Color3.fromRGB(80, 70, 140)
    itemStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    itemStroke.Parent = itemFrame

    -- Ícone Lateral
    local iconLabel = Instance.new("ImageLabel")
    iconLabel.Name = "Icon"
    iconLabel.Size = UDim2.new(0, 28, 0, 28)
    iconLabel.Position = UDim2.new(0, 10, 0.5, 0)
    iconLabel.AnchorPoint = Vector2.new(0, 0.5)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Image = iconeId or "rbxassetid://6031097225"
    iconLabel.Parent = itemFrame

    -- Texto da Opção
    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "Title"
    textLabel.Size = UDim2.new(1, -50, 1, 0)
    textLabel.Position = UDim2.new(0, 45, 0, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = titulo
    textLabel.Font = Enum.Font.FredokaOne
    textLabel.TextSize = 16
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Parent = itemFrame

    local textStroke = Instance.new("UIStroke")
    textStroke.Thickness = 2
    textStroke.Color = Color3.fromRGB(20, 15, 45)
    textStroke.Parent = textLabel

    -- Botão Transparente para Interatividade
    local clickButton = Instance.new("TextButton")
    clickButton.Name = "ClickDetector"
    clickButton.Size = UDim2.new(1, 0, 1, 0)
    clickButton.BackgroundTransparency = 1
    clickButton.Text = ""
    clickButton.Parent = itemFrame

    -- Animação de Hover e Clique
    clickButton.MouseEnter:Connect(function()
        TweenService:Create(itemFrame, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(1, 4, 0, 50),
            BackgroundColor3 = Color3.fromRGB(65, 58, 125)
        }):Play()
        TweenService:Create(itemStroke, TweenInfo.new(0.2), {
            Color = Color3.fromRGB(255, 120, 220)
        }):Play()
    end)

    clickButton.MouseLeave:Connect(function()
        TweenService:Create(itemFrame, TweenInfo.new(0.2), {
            Size = UDim2.new(1, 0, 0, 48),
            BackgroundColor3 = Color3.fromRGB(48, 42, 95)
        }):Play()
        TweenService:Create(itemStroke, TweenInfo.new(0.2), {
            Color = Color3.fromRGB(80, 70, 140)
        }):Play()
    end)

    clickButton.MouseButton1Click:Connect(function()
        local pressTween = TweenService:Create(itemFrame, TweenInfo.new(0.08), {
            Size = UDim2.new(0.95, 0, 0, 44)
        })
        pressTween:Play()
        pressTween.Completed:Wait()
        
        TweenService:Create(itemFrame, TweenInfo.new(0.2, Enum.EasingStyle.Back), {
            Size = UDim2.new(1, 0, 0, 48)
        }):Play()

        if callback then
            callback()
        end
    end)

    return itemFrame
end

-- 6. ANIMAÇÃO DE ENTRADA (Efeito Cascata Cartoon)
local function animateListItems()
    local index = 0
    for _, item in ipairs(listaContainer:GetChildren()) do
        if item:IsA("Frame") then
            index = index + 1
            item.Position = UDim2.new(0.3, 0, 0, 0)
            item.BackgroundTransparency = 1
            
            task.delay(index * 0.06, function()
                TweenService:Create(item, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Position = UDim2.new(0, 0, 0, 0),
                    BackgroundTransparency = 0.1
                }):Play()
            end)
        end
    end
end

-- 7. SINCRONIZAÇÃO E REDIMENSIONAMENTO
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    listaContainer.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 24)
end)

painel:GetPropertyChangedSignal("Visible"):Connect(function()
    if painel.Visible then
        task.wait(0.3)
        animateListItems()
    end
end)

-- Rotação Contínua do Gradiente da Borda
task.spawn(function()
    while listaContainer.Parent do
        local tween = TweenService:Create(strokeGradient, TweenInfo.new(5, Enum.EasingStyle.Linear), {Rotation = 405})
        tween:Play()
        tween.Completed:Wait()
        strokeGradient.Rotation = 45
    end
end)

print("✨ ListManager Toons Universe pronto para receber minipainéis!")

