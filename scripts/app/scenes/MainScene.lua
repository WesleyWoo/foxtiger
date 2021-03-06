
local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()
    local sharedDirector = CCDirector:sharedDirector()
    self:initUI()
end

local loginLayer = nil
local loginWidget = nil
local loginBtn = nil
local agree_CheckBox = nil
local name_TextField = nil
local password_TextField = nil
local confirm_TextField = nil

local isAgree = false
local loginName = nil
local loginPassworld = nil
local loginConfirm = nil

function MainScene:initUI()
    loginLayer = ccs.layer()
    self:addChild(loginLayer)

    loginWidget = ccs.loadWidget("DemoLogin/DemoLogin.json")
    loginWidget:setPosition(CCPoint(display.cx - loginWidget:getSize().width/2,display.cy - loginWidget:getSize().height/2))
    loginLayer:addWidget(loginWidget)

    loginBtn = loginWidget:getChild("login_Button")
    loginBtn:setListener({ [ccs.TouchEventType.ended] = function(uiwidget) self:onLoginBtnHandler() end })

    agree_CheckBox = loginWidget:getChild("agree_CheckBox")
    agree_CheckBox:setListener({[ccs.CheckBoxEventType.selected]   = function() isAgree = true end,
                                [ccs.CheckBoxEventType.unselected] = function() isAgree = false end})
    agree_CheckBox:setSelectedState(true)

    name_TextField = loginWidget:getChild("name_TextField")
    name_TextField:setText(Global.USER_NAME)
    password_TextField = loginWidget:getChild("password_TextField")
    password_TextField:setText(""..Global.USER_PASSWORD)
    confirm_TextField = loginWidget:getChild("confirm_TextField")
    confirm_TextField:setText(""..Global.USER_PASSWORD)
end

function MainScene:onLoginBtnHandler()
    --print( loginConfirm.."  "..loginPassworld )
    loginName = name_TextField:getStringValue()
    loginConfirm = tonumber(confirm_TextField:getStringValue())
    loginPassworld = tonumber(password_TextField:getStringValue())
    --[[if isAgree == false then
        do return end
    end
    if loginName == "" then
        do return end
    end
    if loginPassworld ~= loginConfirm then
        do return end
    end--]]
    local msg = {username = loginName,password = loginPassworld,msgID = 101}
    NetworkLogic:send_message(msg)
    --print( "sent login msg" )
end

function MainScene:onLoginSuccess()
    app:enterAirBattleScene()
end


function MainScene:onEnter()
    if device.platform == "android" then
        -- avoid unmeant back
        self:performWithDelay(function()
            -- keypad layer, for android
            local layer = display.newLayer()
            layer:addKeypadEventListener(function(event)
                if event == "back" then app.exit() end
            end)
            self:addChild(layer)

            layer:setKeypadEnabled(true)
        end, 0.5)
    end
end

function MainScene:onExit()
end

return MainScene
