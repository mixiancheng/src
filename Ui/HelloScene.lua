require "Cocos2d"
local scheduler = cc.Director:getInstance():getScheduler()
local s = cc.Director:getInstance():getWinSize()
local HelloScene = class("HelloScene")
HelloScene.__index = HelloScene
HelloScene._uiLayer= nil
HelloScene._widget = nil
HelloScene._sceneTitle = nil
HelloScene.Name=nil
HelloScene.Pass=nil
function HelloSceneLayerStep(dt) --@return typeOrObject
end
function HelloScene.extend(target)
    local t = tolua.getpeer(target)
    if not t then
        t = {}
        tolua.setpeer(target, t)
    end
    setmetatable(t, HelloScene)
    return target
end
function HelloScene:init()
    self._uiLayer = cc.Layer:create()
    self:addChild(self._uiLayer)
--    self._widget = ccs.GUIReader:getInstance():widgetFromJsonFile("res/battle/BattleMap_test_1.json")
    self._widget =ccs.GUIReader:getInstance():widgetFromJsonFile("res/DemoLogin_1/DemoLogin.json")
    self._uiLayer:addChild(self._widget)
    local root = self._uiLayer:getChildByTag(1)
    self.Name=root:getChildByName("name_TextField")
    self.Pass=root:getChildByName("password_TextField")
    require "Network"
    cclog("git")
    Network.netInit()
    Network.Connect("localhost", 1235)
--    Network.Connect("fbjellyth.topgame.com", 3100)
--    ("fbjellyth.topgame.com", 3100)
--    Network.Connect("localhost", 1235)
    local function nextCallback(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            
            function fnUserLogin(cbName, dictData, bRet)
                cclog("fnUserLogin---->%s",dictData)
            end
            
            Network.rpc(fnUserLogin,"user.userLogin", "user.userLogin", "persion", true)
--            function fnUserLogin(cbName, dictData, bRet)
--                cclog("fnUserLogin---->")
--            end 
--            Network.rpc(fnUserLogin,"user.userLogin", "user.userLogin", "person", true)
--            local _name=self.Name:getStringValue()
--            local _pass=self.Pass:getStringValue()
--            function fnUserLogin(cbName, dictData, bRet)
--        cclog("fnUserLogin------------------>%s",cbName)
--        local msg=person_pb.Person()
--        msg:ParseFromString(dictData)
--        cclog("name====%s",msg.name)
--        cclog("email====%s",msg.email)
    end 
--       local person_pb=require("person_pb")
--                local person=person_pb.Person()
--                person.id=1001
--                person.name=_name
--                person.email=_pass
--                local _data=person:SerializeToString()
--                require "Network"
--                Network.netInit()
--                Network.connect("localhost", 1235)
--                Network.rpc(fnUserLogin,"user.userLogin", "user.userLogin", "person", true)
--        end
    end
    local right_button = root:getChildByName("login_Button")
    right_button:addTouchEventListener(nextCallback)
end
function HelloScene.create()
    local scene = cc.Scene:create()
    local layer = HelloScene.extend(cc.Layer:create())
    layer:init()
    scene:addChild(layer)
    return scene   
end 
function runCocosHelloScene()
    local _scene = HelloScene.create()
    if cc.Director:getInstance():getRunningScene() then
        cc.Director:getInstance():replaceScene(_scene)
    else
        cc.Director:getInstance():runWithScene(_scene)
    end
end