--[[镇派
[腾焰飞芒]2 [洞若观火]3 [无幽不烛]2
[火舞长空]2 [无往不复]2 [幽隐尘迹]1
[流光囚影]1 [寂灭劫灰]3 [天地诛戮]1
[无间影狱]1 [辉耀红尘]2 [日月同辉]3
[血泪成悦]3 [燎原烈火]2 [断愁]1
[生灭予夺]1
[无量妙境]3 [日月凌天]2
--]]

--关闭自动面向
setglobal("自动面向", false)

--宏选项
addopt("副本防开怪", false)

--变量表
local v = {}
v["打过日斩"] = false
v["打过月斩"] = false

--主循环
function Main(g_player)
	--副本处理
	local mapName = map()
	local func = tMapFunc[mapName]
	if func then
		func(g_player)
	end

	v["日灵"] = sun()
	v["满日"] = sun_power()
	v["月魂"] = moon()
	v["满月"] = moon_power()
	v["目标血量较多"] = rela("敌对") and tlifevalue() > lifemax() * 10	--目标血量大于自己最大血量10倍
	local tSpeedXY, tSpeedZ = speed(tid())
	v["目标静止"] = tSpeedXY == 0 and tSpeedZ == 0		--xy速度和Z速度都为0


	--副本防开怪
	if getopt("副本防开怪") and dungeon() and nofight() then return end

	--[[打断
	if tbuffstate("可打断") then
		cast("寒月耀")
	end
	--]]

	if v["目标血量较多"] and dis() < 4 and face() < 60 then
		if buff("日月同辉") then
			cast("光明相")
		end
		
		if fight() and v["目标静止"] and state("站立") and cdleft(503) <= 0.25 and (tface() > 90 or buff("50986|51004|洞察万物")) and cdtime("驱夜断愁") > 1 then
			if not v["满日"] and not v["满月"] and nobuff("日月灵魂|日月同辉") then
				cast("生灭予夺")
			end
		end
	end

	if tface() > 90 or buff("50986|51004|洞察万物") then
		cast("驱夜断愁")
	end

	cast("净世破魔击")

	if not v["打过日斩"] and not v["打过月斩"] or (cdtime("烈日斩") <= 0 and  cdtime("银月斩") <= 0) then
		cast("烈日斩")
		cast("银月斩")
	end

	if v["月魂"] > v["日灵"] then
		cast("幽月轮")
	end
	
	cast("赤日轮")

	cast("银月斩")
end

--释放技能
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		--print("OnCast->:"..SkillName..", 技能ID:"..SkillID..", 技能等级:"..SkillLevel..", 目标ID:"..TargetID..", 开始帧:"..StartFrame..", 当前帧:"..FrameCount)

		--银月斩
		if SkillID == 3960 then
			v["打过月斩"] = true
			return
		end

		--烈日斩
		if SkillID == 3963 then
			v["打过日斩"] = true
			return
		end

		--净世破魔击
		if SkillID == 3967 then
			v["打过月斩"] = false
			v["打过日斩"] = false
			return
		end
	end
end

-------------------------------------------------副本处理
tMapFunc = {}

tMapFunc["归墟秘境"] = function(g_player)
	--击飞
	if tcasting("击飞") and dis() < 10 and tcastleft() < 1.5 then
		stopcasting()
		if tcastleft() < 0.5 then
			cast("蹑云逐月")
			cast("迎风回浪")
		end
		exit()
	end

	--护体
	if tcasting("护体") and tcastleft() < 0.5 then
		settimer("目标读条护体")
	end
	if gettimer("目标读条护体") < 2 or tbuff("4147") then	--护体 反弹伤害
		turn(180)			--背对目标
		exit()
	else
		if tname("午") and face() > 60 then
			turn()		--面向目标
		end
	end

	--毒爆
	if tcasting("毒爆(穿透)") and dis() < 10 and tcastleft() < 1.5 then
		if tcastleft() < 1 then
			acast2("蹑云逐月", tid(), 11)
			castxyz("幻光步", point(tid(), 12, 0, tid(), id()))
		end
		exit()
	end
end
