--[[ 奇穴: [冰体][蛊梦][连契][虫兽][翩翾][渊兮][纳精][诀灵][仙王蛊鼎][蝶隐][五色][迷仙引梦]
秘籍:
凤凰蛊  2调息 2效果
献祭  2调息 2效果
冰蚕  3效果 1读条
醉舞  3疗效 1范围
圣手  2调息 2疗效
千蝶  3调息 1疗效
女娲  3调息 1持续
迷仙  2会心 1效果 1读条

召大蝴蝶 关宏 -> 灵蛇引 -> 献祭 -> 女娲 ->  碧蝶引
没有特殊情况当前目标一直选中boss
离目标10尺内放鼎
凤凰蛊 蛊虫献祭 手动放
--]]

--宏选项
addopt("打断", false)

--变量表
local v = {}
v["记录信息"] = true

--函数表
local f = {}

--主循环
function Main()
	--按下自定义快捷键1挂扶摇, 注意是快捷键设定里面插件的快捷键1指定的按键，不是键盘上的1
	if keydown(1) then
		fcast("扶摇直上")
	end

	--千蝶读条保护
	if gettimer("千蝶吐瑞") < 0.3 or casting("千蝶吐瑞") then
		return
	end

	--等待醉舞读条开始
	if gettimer("醉舞九天") < 0.3 then
		return
	end

	if casting("仙王蛊鼎") and castleft() < 0.13 then
		settimer("鼎读条结束")
	end

	--减伤
	if fight() and pet() and life() < 0.6 then
		fcast("玄水蛊", true)
	end

	--打断
	if getopt("打断") and tbuffstate("可打断") then
		fcast("灵蛊")
	end

	--初始化变量
	v["治疗量"] = charinfo("治疗量")
	v["治疗目标"] = f["获取治疗目标"]()
	v["治疗目标血量"] = xlife(v["治疗目标"])
	v["附近有boss"] = npc("关系:敌对", "强度=6", "可选中", "距离<30") ~= 0
	v["目标是boss"] = rela("敌对") and target("boss")
	local tSpeedXY, tSpeedZ = speed(tid())
	v["目标静止"] = rela("敌对") and tSpeedXY <= 0 and tSpeedZ <= 0		--目标没移动
	v["蚕引层数"] = buffsn("蚕引")
	v["蚕引时间"] = bufftime("蚕引")

	---------------------------------------------

	--召蝴蝶
	if not pet("碧蝶") then
		cast("碧蝶引")
	end

	--驱散
	if pet("碧蝶") then
		v["需要驱散队友"] = xparty(petid(), "没状态:重伤", "距离<40", "视线可达", "buff类型时间:阳性不利效果|混元性不利效果|阴性不利效果|毒性不利效果>1")		--蝴蝶周围40尺内, 视线可达, 有指定不利效果
		if v["需要驱散队友"] ~= 0  then
			if settar(v["需要驱散队友"]) then	--蝶鸾只作用于当前目标
				cast("蝶鸾")
			end
		end
	end

	--蛊惑
	if fight() and v["目标是boss"] and ttid() ~= 0 and ttid() ~= id() then	--目标是boss 目标的目标存在 不是自己
		if xbufftime("蛊惑众生", ttid(), id()) < 5 then
			xcast("蛊惑众生", ttid())	--给目标的目标
		end
	end

	--千蝶
	if fight() then
		_, v["低血量队友数量"] = party("没状态:重伤", "距离<20", "视线可达", "没载具", "气血<0.6")	--自己20尺内
		if qixue("翩翾") and pet("碧蝶") then
			_, v["低血量队友数量"] = xparty(petid(), "没状态:重伤", "距离<20", "视线可达", "没载具", "气血<0.6")	--蝴蝶20尺内
		end
		
		if v["低血量队友数量"] >= 3 then
			if fcast("千蝶吐瑞") then
				settimer("千蝶吐瑞")
				return
			end
		end
	end

	--圣手
	if fight() and v["治疗目标血量"] < 0.6 then
		CastX("圣手织天", true)
	end

	--女娲
	if fight() and v["附近有boss"] then
		cast("女娲补天")
	end

	--种菜
	if fight() and v["目标是boss"] and v["目标静止"] then
		cast("迷仙引梦")
	end

	--冰蚕
	if v["治疗目标血量"] < 0.85 then
		CastX("冰蚕牵丝", true)
	end

	--放鼎
	if fight() and v["目标是boss"] and v["目标静止"] and dis() < 10 and gettimer("鼎读条结束") > 0.5 then
		cast("仙王蛊鼎")
	end

	--吃鼎
	if gettimer("鼎读条结束") > 0.5 and nobuff("蛊时") and life() < 0.7 and cdleft(16) > 0.5 then
		interact("仙王蛊鼎")
	end

	--醉舞
	if v["治疗目标血量"] < 0.95 then
		if casting("醉舞九天") then
			v["醉舞NPC"] = npc("关系:自己", "模板ID:107819")
			if v["醉舞NPC"] ~= 0 and xxdis(v["醉舞NPC"], v["治疗目标"]) > range("醉舞九天", true) then	--在读条醉舞, 治疗目标不在醉舞范围内, 重新释放
				if CastX("醉舞九天", true) then
					settimer("醉舞九天")
					return
				end
			end
		else
			if CastX("醉舞九天") then
				settimer("醉舞九天")
				return
			end
		end
	end

	--脱战救人
	if casting("涅槃重生") and castleft() < 0.13 then
		settimer("涅槃读条结束")
	end
	if nofight() and gettimer("涅槃读条结束") > 0.5 then
		xcast("涅槃重生", party("有状态:重伤", "距离<20", "视线可达"))
	end
end

-------------------------------------------------------------------------------

f["获取治疗目标"] = function()
	local targetID = id()	--治疗目标先设置为自己, 不在队伍或者团队中时 party 返回 0
	local partyID = party("没状态:重伤", "不是自己", "距离<20", "视线可达", "没载具", "气血最少")	--获取血量最少队友
	if partyID ~= 0 and partyID ~= targetID and xlife(partyID) < life() then	--有血量最少队友且比自己血量少
		targetID = partyID	--把他指定为治疗目标
	end
	return targetID
end

--记录信息
function PrintInfo(s)
	local t = {}
	if s then t[#t+1] = s end
	t[#t+1] = "治疗目标:"..v["治疗目标"]
	t[#t+1] = "治疗目标血量:"..format("%0.2f", v["治疗目标血量"])
	print(table.concat(t, ", "))
end

--对治疗目标使用技能
function CastX(szSkill, bf)
	if xcast(szSkill, v["治疗目标"], bf) then
		if v["记录信息"] then PrintInfo() end
		return true
	end
	return false
end

-------------------------------------------------------------------------------
--开始引导
function OnChannel(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, Frame, StartFrame, FrameCount)
	if CasterID == id() then
		if SkillID == 33444 then	--醉舞
			deltimer("醉舞九天")
		end
	end
end
