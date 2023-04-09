--奇穴: [淮茵][息缠][岚因][断泽][划云][遍休][茎蹊][逐鸿][疾根][折枝拂露][荡襟][青圃着尘]

--载入库
load("Macro/Lib_PVP.lua")

--变量表
local v = {}

--函数表
local f = {}

f["没免控"] = function()
	if buffstate("免击倒时间") >= 0 then
		return false
	end
	local t = { "绿野蔓生", "逐云寒蕊", "且待时休", "凌然天风", "惊鸿掠水", "回风微澜" }
	for k,v in ipairs(t) do
		if gettimer(v) <= 0.25 then
			return false
		end
	end

	return true
end

f["没凌然天风"] = function()
	return bufftime("凌然天风") <= 0 and gettimer("凌然天风") > 0.25 and gettimer("回风微澜") > 0.25
end

f["有凌然天风"] = function()
	return bufftime("凌然天风") > 0 or gettimer("凌然天风") < 0.25 or gettimer("回风微澜") < 0.25
end

f["放惊鸿掠水"] = function()
	if f["有凌然天风"]() then return false end

	if g_var["突进"] then
		if cdtime("含锋破月") < 1 and v["逆乱层数"] >= 8 and v["逆乱时间"] > 11 then
			--if not qixue("折枝拂露") or v["药性"] > 1 then
				return "靠近打含锋"
			--end
		end
	end
	return false
end

f["川乌射罔"] = function()
	if buff("21474") then return false end

	if g_var["目标可攻击"] then

		if state("跳跃|攻击位移状态") then
			if height() > 10 and dis2() > 8 then
				if acast("川乌射罔") then
					exit()
				end
			end
		end

		if dis2() > 8 then
			if acast("川乌射罔") then
				exit()
			end
			if face() < 60 then
				if cast("川乌射罔") then
					exit()
				end
			end
		end
	end
end

f["且待时休"] = function()
	if bufftime("21474") > -1 then return false end

	--续免控
	if g_var["目标可控制"] and f["没免控"]() and dis() < 10 and theight() < 10 and v["逆乱层数"] > 4 and v["逆乱时间"] > 5 then
		if cast("且待时休") then
			stopmove()		--停止移动
			nomove(true)	--禁止移动
			settimer("且待时休")
			exit()
		end
	end
end

f["放沾衣未妨"] = function()
	if g_var["目标可攻击"] and theight() < 6 then
		if qixue("荆障") and tnpc("关系:自己", "名字:苍棘缚地", "距离<8") ~= 0 then
			return true
		end
		if qixue("令芷") and v["逆乱层数"] >= 4 then
			if tbuffstate("定身时间") <= 0 and tbuffstate("眩晕时间") <= 0 and tbuffstate("击倒时间") <= 0 and tbuffstate("可定身") then
				return true
			end
		end
	end
	return false
end

f["放紫叶沉疴"] = function()
	--目标是奶妈
	if tmount(g_var["治疗心法"]) then
		return true
	end

	--目标附近有奶妈
	if allbattle() then
		if tenemy("内功:"..g_var["治疗心法"], "距离<40") ~= 0 then
			return true
		end
	end
	return false
end

f["千枝绽蕊"] = function()
	if v["目标是我的敌人"] == 0 then
		cast("千枝伏藏")
	else
		if mana() > 0.6 then
			cast("千枝绽蕊")
		end
	end
end


--主循环
function Main(g_player)
	--库初始化
	g_func["初始化"]()

	v["逆乱层数"] = tbuffsn("逆乱", id())
	v["逆乱时间"] = tbufftime("逆乱", id())
	v["药性"] = yaoxing()		--温性大于0， 寒性小于0

	--且待时休防打断
	if gettimer("且待时休") < 0.5 or casting("且待时休") then
		return
	else
		nomove(false)
	end

	--逐云寒蕊禁止移动, buff 20131 
	if gettimer("逐云寒蕊") < 0.5 or npc("关系:自己", "模板ID:106623", "距离<10") ~= 0 then
		return
	else
		nomove(false)
	end
	
	--读条时面向目标
	if casting("商陆缀寒|川乌射罔") then
		turn()
	end

	v["目标是我的敌人"] = enemy("目标是我", "距离<30", "可视自己")

	--[[逐云寒蕊
	--被集火
	_, v["目标是我敌人数量"] = enemy("目标是我", "距离<20")
	if v["目标是我敌人数量"] >= 2 then
		if cast("逐云寒蕊") then
			settimer("逐云寒蕊")
			exit()
		end
	end
	--]]

	--逐云寒蕊, 先随便处理下
	if fight() and life() < 0.3 then
		cast("逐云寒蕊", true)
	end

	--等待移动状态同步
	local t = { "惊鸿掠水", "回风微澜", "含锋破月", "飞叶满襟", "折枝拂露", "折枝留春", "凌然天风", "凌然天风·前", "凌然天风·后", "凌然天风·上", "凌然天风·左", "凌然天风·右" }
	for k, v in ipairs(t) do
		if gettimer(v) < 0.25 then
			return
		end
	end

	f["千枝绽蕊"]()

	--银光照雪
	if g_var["目标可攻击"] then
		cast("银光照雪")
	end

	--折枝留春
	if g_var["目标可攻击"] and cast("折枝留春") then
		settimer("折枝留春")
	end

	--折枝拂露
	if g_var["目标可攻击"] and cast("折枝拂露") then
		settimer("折枝拂露")
	end

	--飞叶满襟
	if g_var["突进"] then
		if cast("飞叶满襟") then
			settimer("飞叶满襟")
		end
	end

	--含锋破月
	if g_var["突进"] and f["没凌然天风"]() then
		if v["逆乱层数"] >= 8 and v["逆乱时间"] > 9 then
			if cdtime("含锋破月") <= 0 and dis() < 12 then
				cast("沾衣未妨")
			end
			--if not qixue("折枝拂露") or v["药性"] > 1 then
				if cast("含锋破月") then
					settimer("含锋破月")
					exit()
				end
			--end
		end
	end

	--[[沾衣未妨
	if f["放沾衣未妨"]() then
		cast("沾衣未妨")
	end
	--]]

	--惊鸿掠水
	local szReason = f["放惊鸿掠水"]()
	--print(v["逆乱层数"], v["逆乱时间"], szReason)
	if szReason then
		if cast("惊鸿掠水") then
			settimer("惊鸿掠水")
			print(szReason)
			exit()
		end
	end
	
	--回风微澜
	if cdtime("含锋破月") > 1 and gettimer("含锋破月") > 0.75 and nobuff("20071|22810|24482") then
		if cast("回风微澜") then
			settimer("回风微澜")
			exit()
		end
	end

	f["且待时休"]()

	--川乌射罔
	f["川乌射罔"]()
	
	--钩吻断肠续逆乱
	if v["逆乱时间"] > 0 and v["逆乱时间"] <= cdinterval(16) then
		if cast("钩吻断肠") then
			print("钩吻断肠续逆乱")
		end
	end

	--青圃着尘
	if g_var["目标可攻击"] and g_var["目标没减伤"] and dis() > 10 then
		cast("青圃着尘")
	end


	--商陆缀寒
	if g_var["目标可攻击"] and v["药性"] >= 2 and dis2() > 8 then
		if bufftime("21106") > 0.1 or nobuff("21106") then
			cast("商陆缀寒")
		end
	end

	--苍棘缚地
	if g_var["目标可攻击"] then
		cast("苍棘缚地")
	end

	--紫叶沉疴
	if f["放紫叶沉疴"]() then
		cast("紫叶沉疴")
	end

	--钩吻断肠
	if g_var["目标可攻击"] then
		cast("钩吻断肠")
	end


	--凌然天风移动
	if bufftime("凌然天风") > 0.5 and bufftime("20095") > 0.1 then
		if gettimer("凌然天风") > 0.25 and gettimer("回风微澜") > 0.25 and gettimer("川乌射罔") > 0.25 then
			--前
			if dis2() > 20 then
				if acast(27643) then
					settimer("凌然天风·前")
					exit()
				end
			end
			--后
			if dis2() < 10 then
				if acast(27644) then
					settimer("凌然天风·后")
					exit()
				end
			end
			--上
			if height() < 10 then
				if cast(27782) then
					settimer("凌然天风·上")
					exit()
				end
			end
			--右
			if gettimer("凌然天风·左") < 1.5 and cast(27646) then
				settimer("凌然天风·右")
				exit()
			end
			--左
			if cast(27645) then
				settimer("凌然天风·左")
				exit()
			end
		end
	end

	--凌然天风
	if f["没免控"] then
		if v["目标是我的敌人"] ~= 0 or (rela("敌对") and dis() < 30) then
			if cast("凌然天风") then
				settimer("凌然天风")
				exit()
			end
		end
	end


	--没进战, 沾衣未妨打出5点寒
	if enemy("距离<70") == 0 and v["药性"] <= 1 and v["药性"] > -5 then
		cast("沾衣未妨", true)
	end

	f["解控"]()


	--挂扶摇
	--if enemy("内功:"..g_var["近战心法"], "距离<50") then
	if allbattle() then
		cast("扶摇直上")
	end

	--被缴械
	if buffstate("缴械时间") > 2 then
		if buff("弹跳") then
			jump()
		else
			if cast("扶摇直上") then
				jump()
			end
		end
	end



	--采集任务物品
	if nofight() then
		g_func["采集"](g_player)
	end
	
end

f["解控"] = function()
	--蹑云解僵直
	if buffstate("僵直时间") > 0.5 then
		if cast("蹑云逐月") then
			exit()
		end
	end

	--防止重复放解控
	if gettimer("绿野蔓生") <  0.5 or gettimer("逐云寒蕊") < 0.5 then return end

	if buffstate("锁足时间") > 1.5 or buffstate("定身时间") > 1.5 or buffstate("眩晕时间") > 1.5 or buffstate("击倒时间") > 1.5 or buffstate("僵直时间") > 0.5 then
		--绿野蔓生
		if cast("绿野蔓生") then
			settimer("绿野蔓生")
			exit()
		end
		
		--逐云寒蕊
		if cast("逐云寒蕊") then
			stopmove()		--停止移动
			nomove(true)	--禁止移动
			settimer("逐云寒蕊")
			exit()
		end
	end
end


--释放技能
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		if SkillID == 27560 then
			--print("逆乱")
		end
	end
end

local tBuff = {
--[21106] = "凌然天风瞬发商陆缀寒",
--[20037] = "惊鸿掠水换二段",
--[20071] = "含锋破月二段",
--[22806] = "含锋破月可以打三段",
--[22810] = "含锋破月三段",
--[24482] = "含锋破月四段",
[20072] = "凌然天风",
}

--输出buff变动情况
function OnBuff(CharacterID, BuffName, BuffID, BuffLevel, StackNum, SkillSrcID, StartFrame, EndFrame, FrameCount)
	if CharacterID == id() then
		if StackNum  > 0 then
			local bPrint = false
			if  BuffID ~= 17584 then
				if buffis(BuffID, BuffLevel, "封外功") then
					print("被沉默")
					bigtext("被沉默")
					bPrint = true
				end
				if buffis(BuffID, BuffLevel, "缴械") then
					print("被缴械")
					bigtext("被缴械")
					bPrint = true
				end
				if buffis(BuffID, BuffLevel, "封混元") then
					print("被封内")
					bigtext("被封内")
					bPrint = true
				end
				if buffis(BuffID, BuffLevel, "锁足") then
					print("被锁足")
					bigtext("被锁足")
					bPrint = true
				end
				if buffis(BuffID, BuffLevel, "定身") then
					print("被定身")
					bigtext("被定身")
					bPrint = true
				end
				if buffis(BuffID, BuffLevel, "眩晕") then
					print("被眩晕")
					bigtext("被眩晕")
					bPrint = true
				end
				if buffis(BuffID, BuffLevel, "击倒") then
					print("被击倒")
					bigtext("被击倒")
					bPrint = true
				end
			end

			if tBuff[BuffID] or bPrint then
				print("添加buff: ".. BuffName..", ID: "..BuffID..", 等级: "..BuffLevel..", 层数: "..StackNum..", 源ID: "..SkillSrcID..", 开始帧: "..StartFrame..", 当前帧: "..FrameCount..", 结束帧: "..EndFrame..", 剩余时间: "..(EndFrame-FrameCount)/16)
			end
		else
			if tBuff[BuffID] then
				print("移除buff: ".. BuffName..", ID: "..BuffID..", 等级: "..BuffLevel..", 层数: "..StackNum..", 源ID: "..SkillSrcID..", 开始帧: "..StartFrame..", 当前帧: "..FrameCount)
			end
		end
	end
end
