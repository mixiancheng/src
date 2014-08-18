require "Cocos2d"
require "Cocos2dConstants"

-- cclog
cclog = function(...)
    print(string.format(...))
end

-- for CCLuaEngine traceback
function __G__TRACKBACK__(msg)
    cclog("----------------------------------------")
    cclog("LUA ERROR: " .. tostring(msg) .. "\n")
    cclog(debug.traceback())
    cclog("----------------------------------------")
    return msg
end

local function main()
    collectgarbage("collect")
    -- avoid memory leak
    collectgarbage("setpause", 100)
    collectgarbage("setstepmul", 5000)
    cc.Director:getInstance():getOpenGLView():setDesignResolutionSize(480, 320, 0)
	cc.FileUtils:getInstance():addSearchResolutionsOrder("src");
    cc.FileUtils:getInstance():addSearchResolutionsOrder("src/pb");
    cc.FileUtils:getInstance():addSearchResolutionsOrder("src/protobuf");
    cc.FileUtils:getInstance():addSearchResolutionsOrder("src/Net");
	cc.FileUtils:getInstance():addSearchResolutionsOrder("res");
	local schedulerID = 0
    --support debug
    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
    if (cc.PLATFORM_OS_IPHONE == targetPlatform) or (cc.PLATFORM_OS_IPAD == targetPlatform) or 
       (cc.PLATFORM_OS_ANDROID == targetPlatform) or (cc.PLATFORM_OS_WINDOWS == targetPlatform) or
       (cc.PLATFORM_OS_MAC == targetPlatform) then
        cclog("result is ")
		--require('debugger')()
        
    end
    require "hello2"
    cclog("result is " .. myadd(1, 1))
    local person_pb=require("person_pb")
    local person=person_pb.Person()
    person.id=1001
    person.name="als"
    person.email="email1111"
--    local _data=person:SerializeToString()
--    local msg=person_pb.Person()
--    msg:ParseFromString(_data)
    print(""..text_format.msg_format(person))
    ---------------
    function fnUserLogin(cbName, dictData, bRet)
        cclog("fnUserLogin------------------>%s",cbName)
        local msg=person_pb.Person()
        msg:ParseFromString(dictData)
        cclog("name====%s",msg.name)
        cclog("email====%s",msg.email)
    end 
    require("Network")
    Network.netInit()
--    Network.connect("fbjellyth.topgame.com", 3100)
    Network.connect("localhost", 1235)
    Network.rpc(fnUserLogin,"user.userLogin", "user.userLogin", person, true) 
--    local Num=1001
--    local function TestFun(dt)
--    Num=Num+1
--        cclog("Num=======%d",Num)
--    end
--    local scheduler = cc.Director:getInstance():getScheduler()
--    scheduler:scheduleScriptFunc(TestFun, 1.0, false)
    local visibleSize = cc.Director:getInstance():getVisibleSize()
    local origin = cc.Director:getInstance():getVisibleOrigin()

    -- add the m
end


local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    error(msg)
end
