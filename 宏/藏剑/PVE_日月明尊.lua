--[[镇派
[花明]2 [寻芳]3 [雷音]2
[云体]2 [龙池]2 [急电]3 [残雪]1
[踏雪寻梅]1 [怒涛]1 [奔浪]2
[淘尽]3 [声趣]2 [云石]1
[山重水复]3
[香疏影]1
[山色]2 [怜光]3
[厌高]2
--]]
--能打，伤害不高

--关闭自动面向
setglobal("自动面向", false)

--宏选项
addopt("副本防开怪", false)
addopt("给T探梅", false)

--变量表
local v = {}
v["剑气"] = rage()
v["等待内功切换"] = false

--函数表
local f = {}

--主循环
function Main(g_player)
	--副本处理
	local mapName = map()
	local func = tMapFunc[mapName]
	if func then
		func(g_player)
	end
	
	--减伤
	if fight() and life() < 0.6 then
		cast("泉凝月")
	end

	if casting("云飞玉皇") and castleft() < 0.13 then
		settimer("云飞玉皇读条结束")
	end
	if casting("夕照雷峰") and castleft() < 0.13 then
		settimer("夕照雷峰读条结束")
	end

	if v["等待内功切换"] and gettimer("啸日") <= 0.25 then
		return
	end

	--梅隐香
	if mount("问水诀") and bufftime("梅隐香") < 23 then
		if cast("梅隐香") then
			settimer("梅隐香")
		end
	end

	--副本防开怪
	if getopt("副本防开怪") and dungeon() and nofight() then return end
	
	if tbuff("隐遁") then
		bigtext("目标无敌", 0.5)
		return
	end

	--打断
	if tbuffstate("可打断") then
		if gettimer("玉虹贯日") > 1 and cast("摘星") then
			settimer("摘星")
		end
		if gettimer("摘星") > 1 and cast("玉虹贯日") then
			settimer("玉虹贯日")
		end
	end

	v["目标血量较多"] = rela("敌对") and tlifevalue() > lifemax() * 10	--目标血量大于自己最大血量10倍

	---------------------------------------------轻剑
	if mount("问水诀") then
		--探梅
		if getopt("给T探梅") and rela("敌对") then
			xcast("探梅", tparty("没状态:重伤", "内功:洗髓经|铁牢律|明尊琉璃体|铁骨衣", "距离<8", "自己距离<15", "视线可达", "距离最近"))
		end

		--[[黄龙吐翠
		if cdleft(16) >= 0.875 and face() > 100 then 
			cast("黄龙吐翠")
		end
		--]]

		--啸日
		if gettimer("梅隐香") < 1 or bufftime("梅隐香") > 12 then
			if v["目标血量较多"] and dis() < 8 and cdleft(16) < 0.5 and cdtime("香疏影") <= 0 then
				f["啸日"]("香疏影切重剑")
			end

			if v["剑气"] >= 100 then
				f["啸日"]("剑气大于100切重剑")
			end

			if buffsn("声趣") >= 3 then
				f["啸日"]("3层声趣切重剑")
			end
		end
		
		if buff("梅隐香") then
			if cdtime("啸日") > 2 or bufftime("御风") < 2 then
				cast("断潮")
			end
		end

		if cdtime("啸日") > 8 then
			cast("梦泉虎跑")
		end

		cast("踏雪寻梅")
		
		

		cast("听雷")

		if v["目标血量较多"] and dis() < 4 and ttid() == id() then
			cast("云栖松")
		end
		
		--[[
		if cdtime("黄龙吐翠") <= 0 then
			cast("平湖断月")
		end
		--]]

		if dis() > 8 then
			cast("玉虹贯日")
		end
	end

	---------------------------------------------重剑
	if mount("山居剑意") then
		--爆发
		if rela("敌对") and dis() < 8 and cdleft(16) < 0.5 and bufftime("啸日") > 10 then		--目标时敌人, 距离小于8尺, GCD快好了
			if tlifevalue() > lifemax() * 5 then		--目标当前血量大于自己最大血量5倍
				cast("猛虎下山")
			end

			if v["目标血量较多"] then
				if cast("香疏影") then
					settimer("香疏影")
				end
			end
		end

		if bufftime("啸日") <= cdinterval(16) and nobuff("声趣") and (cdtime("云飞玉皇") > cdinterval(16) or gettimer("云飞玉皇读条结束") < 1) then
			f["啸日"]("啸日时间不够打一个技能")
		end

		if gettimer("云飞玉皇读条结束") < 1 or cdtime("云飞玉皇") > cdinterval(16) or bufftime("啸日") <= cdinterval(16) or bufftime("御风") <= cdinterval(16) then
			if cast("断潮") then
				settimer("断潮")
			end
		end

		--雪断桥
		if bufftime("啸日") > cdinterval(16) and rage() < 20 then
			if cast("雪断桥") then
				settimer("雪断桥")
			end
		end

		_, v["6尺内怪物数量"] = npc("关系:敌对", "距离<6", "可选中")
		if v["6尺内怪物数量"] >= 3 then
			cast("风来吴山")
		end
		
		if gettimer("云飞玉皇读条结束") > 0.25 then
			cast("云飞玉皇")
		end

		if gettimer("断潮") >= 0.25 then
			if gettimer("夕照雷峰读条结束") >= 0.25 or cdtime("断潮") > 0 then
				cast("夕照雷峰")
			end
		end

		if rela("敌对") and dis() > 12 and dis() < 20 and face() < 60 then
			acast("鹤归孤山")
		end

		--啸日
		if gettimer("香疏影") > 0.5 then
			if nofight() then
				f["啸日"]("脱战切轻剑")
			end
			if v["剑气"] < 15 and gettimer("雪断桥") > 0.25 then
				f["啸日"]("剑气不够打一个技能")
			end
		end
	end
end

f["啸日"] = function(szReason)
	if cast("啸日") then
		v["等待内功切换"] = true
		settimer("啸日")
		if szReason then
			print("啸日: "..szReason, cdtime("啸日"))
		end
		exit()
	end
end

--状态更新
function OnStateUpdate(nCurrentLife, nCurrentMana, nCurrentRage, nCurrentEnergy, nCurrentSunEnergy, nCurrentMoonEnergy)
	v["剑气"] = nCurrentRage
end

--切换内功
function OnMountKungFu(KungFu, Level)
	v["等待内功切换"] = false
end

--释放技能
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		if SkillID == 1600 then
			deltimer("夕照雷峰读条结束")
			return
		end
	end
end

local tBuff = {
[50283] = "云石_夕照云飞伤害提高",
[1722] = "断潮buff",
}

--更新buff
function OnBuff(CharacterID, BuffName, BuffID, BuffLevel, StackNum, SkillSrcID, StartFrame, EndFrame, FrameCount)
	--输出buff调试信息
	if CharacterID == id() and tBuff[BuffID] then
		if StackNum > 0 then
			print("添加buff: "..BuffName, "ID: "..BuffID, "等级: "..BuffLevel, "层数: "..StackNum, "剩余时间:"..((EndFrame - FrameCount) / 16))
		else
			print("移除buff: "..BuffName)
		end
	end
end

-------------------------------------------------副本处理
tMapFunc = {}

tMapFunc["归墟秘境"] = function(g_player)
	--击飞
	if tcasting("击飞") then
		stopcasting()
		if tcastleft() < 0.5 then
			cast("蹑云逐月")
			cast("迎风回浪")
			cast("凌霄揽胜")
			cast("瑶台枕鹤")
		end
		exit()
	end

	--护体
	if tcasting("护体") and tcastleft() < 0.5 then
		settimer("目标读条护体")
	end
	if gettimer("目标读条护体") < 2 or tbuff("4147") then	--护体 反弹伤害
		stopcasting()		--停止读条
		turn(180)			--背对目标
		--关闭梦泉虎跑
		if buff("梦泉虎跑") and nobuff("50254") and gettimer("行川逍遥") > 0.25 then
			if cast("行川逍遥") then
				settimer("行川逍遥")
			end
		end
		exit()
	else
		if tname("午") and face() > 60 then
			turn()
		end
	end
end
