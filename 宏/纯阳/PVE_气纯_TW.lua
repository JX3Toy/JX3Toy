--[[ 奇穴: [白虹][霜鋒][化三清][歸元][同塵][跬步][萬物][抱陽][浮生][破勢][重光][固本]
秘籍:
破苍穹  1读条 3范围
四象  2会心 2读条
两仪  1会心 2伤害 1效果
太极  1会心 3伤害
万世  3伤害 1消耗
坐忘  2调息 2效果
--]]

--关闭自动面向
setglobal("自动面向", false)

-- 变量表
local v = {}

--函数表
local f = {}

--主循环
function Main(g_player)
	--减伤
	if fight() and life() < 0.5 and nobuff("坐忘無我") then
		cast("坐忘無我")
	end

	if casting("六合獨尊") and castleft() < 0.13 then
		settimer("六合读条结束")
	end
	if casting("破蒼穹") and castleft() < 0.13 then
		settimer("破苍穹读条结束")
	end

	if casting("四象輪回") and castleft() < 0.13 then
		settimer("等待气点同步")
	end
	if gettimer("等待气点同步") < 0.3 then return end

	--初始化变量
	v["气点"] = qidian()
	local tSpeedXY, tSpeedZ = speed(tid())
	v["目标静止"] = rela("敌对") and tSpeedXY <= 0 and tSpeedZ <= 0		--目标没移动
	v["破苍穹距离"], v["破苍穹时间"] = qc("氣場破蒼穹", id(), id())		--自己附近自己的气场, 距离是自己到气场边缘的距离，在圈外是正数，在圈内是负数
	v["目标位置自己的六合"] = tnpc("关系:自己", "模板ID:58295", "平面距离<5")
	v["目标血量较多"] = rela("敌对") and tlifevalue() > lifemax() * 5	--目标当前血量大于自己最大血量5倍


	--镇山河
	if qixue("破勢") then
		cast("鎮山河", true)
	end

	--紫气
	if v["目标静止"] and v["目标血量较多"] and dis() < 20 then
		if v["破苍穹距离"] < -3 and v["破苍穹时间"] > 10 then
			if v["目标位置自己的六合"] ~= 0 and gettimer("释放六合") < 2 then
				if cast("紫氣東來") then
					settimer("紫氣東來")
				end
			end
		end
	end

	--三才
	if qixue("厚亡") and v["目标静止"] and dis() < 5 and face() < 60 and f["没紫气"]() and scdtime("紫氣東來") > 5 and cdleft(16) >= 0.5 then
		if cast("三才化生") then
			settimer("三才化生")
		end
	end

	--万世一段
	if rela("敌对") and dis() < 25 and qjcount() < 5 then
		cast(18640)
	end

	--破苍穹
	if rela("敌对") and dis() < 25 and v["破苍穹距离"] > -1 then	--没有破苍穹或者快出圈了
		cast("破蒼穹", true)
	end

	--万世二段
	if buff("12504|12783") then
		if bufftime("氣劍") < 3.75 then
			cast(18654)
		end

		--[[六合紫气前放二段?
		if scdtime("六合獨尊") < cdinterval(16) and scdtime("紫氣東來") < cdinterval(16) * 2 then
			cast(18654)
		end
		--]]
		
		--[[气点不够两仪，万世一段CD小于一个GCD，打二段，实战测试是否有提升
		if gettimer("释放飞剑") < 1 and scdtime(18640) < cdinterval(16) and v["气点"] < 7 then
			cast(18654)
		end
		--]]
	end

	--六合
	if gettimer("六合读条结束") > 0.25 and v["目标静止"] then
		if scdtime("紫氣東來") < cdinterval(16) then
			if v["破苍穹距离"] < -3 and v["破苍穹时间"] > 12 then
				cast("六合獨尊")
			end
		end

		if scdtime("紫氣東來") > 10 then
			cast("六合獨尊")
		end
	end

	--两仪
	if v["气点"] >= 7 then
		cast("兩儀化形")
	end

	--补破苍穹
	if rela("敌对") and dis() < 25 and scdtime("六合獨尊") < cdinterval(16) and scdtime("紫氣東來") < cdinterval(16) * 2 and v["破苍穹时间"] < 12 then
		cast("破蒼穹", true)
	end

	--化三清
	if fight() and mana() < 0.4 and state("站立") then
		cast("化三清", true)
	end

	--四象
	if gettimer("六合读条结束") > 0.5 then
		if f["有紫气"]() then
			if v["气点"] < 5 then
				cast("四象輪回")
			end
		else
			cast("四象輪回")
		end
	end

	if nofight() and nobuff("坐忘無我") then
		cast("坐忘無我")
	end
end

f["没紫气"] = function()
	if buff("紫氣東來") or gettimer("紫氣東來") < 0.5 or gettimer("三才化生") < 0.5 then
		return false
	end
	return true
end

f["有紫气"] = function()
	if buff("紫氣東來") or gettimer("紫氣東來") < 0.5 or gettimer("三才化生") < 0.5 then
		return true
	end
	return false
end

--气点更新
function OnQidianUpdate()
	deltimer("等待气点同步")
end

--释放技能
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		if SkillID == 18667 then
			settimer("释放飞剑")
			return
		end
		if SkillID == 18668 then
			settimer("释放六合")
			return
		end
	end
end
