module ("Network", package.seeall)
local _net=nil
local tm_cbFuncs = {}
local re_cbFuncs = {}
local no_loading_cbFunc = {}
function netInit()
    _net=NetUtil:create()
end 
-- lua层主动调用网络连接接口
-- phost: 服务器hostname或ip
-- pport: 服务器端口
function connect (phost, pport)
    local dhost = phost or g_host
    local dport = pport or g_port

--    local client = BTNetClient:getInstance()

    if (not _net:connect(dhost, dport)) then
--        CCLuaLog("The network is unavailable.")
        return false
    end
    return true
end
--调用网络接口 
--cbFunc: 回调的方法 type->lua function
--cbFlag: 回调的标识名称, 用于区别其他回调 type->string
--rpcName: 调用后端函数的名称 type->string
--args: 调用函数需要的参数  type->CCArray
--autoRelease: 调用完成后是否删除此回调方法
--return:无
function rpc(cbFunc, cbFlag, rpcName, args, autoRelease)
--    local disp = BTEventDispatcher:getInstance()
    local sendString = args:SerializeToString()
    cclog("--------->%s",sendString)
    local a=string.byte(sendString,1)
    local sendData={string.byte(sendString,1,-1)}
    cclog("sendPack: \n"..text_format.msg_format(args))
    _net:addLuaHandler(cbFlag, networkHandler, autoRelease)
    _net:callRPC(cbFlag, rpcName, sendData,table.getn(sendData))

    tm_cbFuncs[cbFlag] = cbFunc

--    LoadingUI.addLoadingUI()
    -- 网络请求 0.5秒后才出现
    -- LoadingUI.setVisiable(false)
    -- local runningScene = CCDirector:sharedDirector():getRunningScene()
    -- local actionArray = CCArray:create()
    -- actionArray:addObject(CCDelayTime:create(0.5))
    -- actionArray:addObject(CCCallFunc:create(function ( ... )
    --  if(tm_cbFuncs[cbFlag] ~= nil) then
    --      LoadingUI.setVisiable(true)
    --      local actions = CCArray:create()
    --      actions:addObject(CCDelayTime:create(5))
    --      actions:addObject(CCCallFunc:create(function ( ... )
    --          if(LoadingUI.getVisiable() == true) then
    --              LoadingUI.setVisiable(false)
    --          end
    --      end))
    --      runningScene:runAction(CCSequence:create(actions))
    --  end
    -- end))
    -- runningScene:runAction(CCSequence:create(actionArray))

end
-- 网络统一接口
function networkHandler(cbFlag, dictData, bRet)
--    LoadingUI.reduceLoadingUI()
    if not bRet and g_debug_mode then
        -- 调试模式先调错误页面
--        require "script/ui/tip/AlertTip"
--        AlertTip.showAlert(dictData.err, function ( ... )
            -- body
--            end)
    end

    -- 把网络结果传给UI
    if (tm_cbFuncs[cbFlag] == nil) then
        return
    end
    tm_cbFuncs[cbFlag](cbFlag, dictData, bRet)
    tm_cbFuncs[cbFlag] = nil
end