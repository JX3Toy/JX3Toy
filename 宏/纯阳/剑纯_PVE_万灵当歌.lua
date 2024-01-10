--[[ 奇穴: [心固][环月][化三清][无意][风逝][叠刃][长生][裂云][故长][剑入][虚极][玄门]
秘籍:
吞日月	3消耗 1驱散(看情况点)
三环	1调息 1会心 2伤害
无我	1会心 2伤害 1效果
八荒	1调息 2伤害 1效果
人剑	1调息 1dot 1吞碎气剑 1伤害提高60%
坐忘	2调息 1回血蓝 1减伤
凭虚	2调息

是我不会玩还是装备太烂还是哪里有问题, 伤害是真的低
--]]

--关闭自动面向
setglobal("自动面向", false)

--宏选项
addopt("副本防开怪", false)

--变量表
local v = {}
v["记录信息"] = true

--主循环
function Main()
	--按下自定义快捷键1挂扶摇, 注意是快捷键设定里面插件的快捷键1指定的按键，不是键盘上的1
	if keydown(1) then
		cast("扶摇直上")
	end

	--减伤
	if fight() and life() < 0.5 and buffstate("减伤效果") < 40 then
		if gettimer("坐忘无我") > 0.3 and nobuff("坐忘无我") then
			cast("转乾坤")
		end
		if gettimer("转乾坤") > 0.3 then
			cast("坐忘无我")
		end
	end

	--初始化变量
	v["气点"] = qidian()

	local tSpeedXY, tSpeedZ = speed(tid())
	v["目标静止"] = rela("敌对") and tSpeedXY <= 0 and tSpeedZ <= 0
	v["GCD间隔"] = cdinterval(16)
	v["碎星辰CD"] = scdtime("碎星辰")
	v["吞日月CD"] = scdtime("吞日月")
	v["三环CD"] = scdtime("三环套月")
	v["万剑CD"] = scdtime("万剑归宗")
	v["八荒CD"] = scdtime("八荒归元")
	v["人剑CD"] = scdtime("人剑合一")
	v["紫气充能次数"] = cn("紫气东来")
	v["紫气充能时间"] = cntime("紫气东来", true)

	v["紫气时间"] = bufftime("紫气东来")
	v["目标叠刃层数"] = tbuffsn("叠刃", id())
	v["目标叠刃时间"] = tbufftime("叠刃", id())
	v["碎星辰buff时间"] = bufftime("碎星辰")	--会心5% 会效10% 无视防御60% 4秒
	v["风逝时间"] = bufftime("风逝")		--14931 无我伤害提高30% 5秒
	v["裂云时间"] = bufftime("裂云")		--17933 15%会效
	v["玄门层数"] = buffsn("玄门")			--每层提高 破防20% 会心3%
	v["玄门时间"] = bufftime("玄门")
	
	v["碎星辰"] = npc("关系:自己", "名字:气场碎星辰", "距离<13")
	v["吞日月"] = npc("关系:自己", "名字:气场吞日月", "距离<13")
	v["化三清"] = npc("关系:自己", "名字:气场化三清", "距离<15")
	_, v["气场数量"] = npc("关系:自己", "名字:气场生太极|气场碎星辰|气场吞日月", "距离<13")

	--没进战，挂坐忘
	if nofight() and nobuff("坐忘无我") then
		CastX("坐忘无我")
	end
	
	--没进战 目标位置3碎星辰
	v["碎星辰时间"], v["碎星辰数量"] =  qctime(id(), 10, 4980)	--自己10尺内碎星辰, 最短时间, 数量
	if nofight() and rela("敌对") then
		if v["碎星辰数量"] < 3 or v["碎星辰时间"] < 12 then
			CastX("碎星辰")
		end
	end

	--副本防开怪
	if getopt("副本防开怪") and dungeon() and nofight() then return end

	--人剑 起手打玄门
	if rela("敌对") and dis() < 8 and v["气场数量"] >= 3 and v["玄门层数"] < 3 then
		if v["化三清"] == 0 and v["碎星辰CD"] <= v["GCD间隔"] then
			CastX("人剑合一")
		end
	end

	--碎星辰
	v["碎星辰气场距离"], v["碎星辰气场时间"] = qc("气场碎星辰", id(), id())
	if rela("敌对") and v["碎星辰气场距离"] > 0 then	--没有碎星辰或在外面
		CastX("碎星辰")
	end

	--橙武
	if buff("1915") and tbuffsn("23170" , id()) < 3 then
		CastX("八荒归元")
	end

	--无我
	if v["风逝时间"] >= 0 and v["气点"] > 9 then
		CastX("无我无剑")
	end

	--三环
	if v["目标叠刃时间"] < 0 or v["目标叠刃时间"] > 12 then
		--紫气
		if nobuff("紫气东来") and rela("敌对") and dis() < 6 and face() < 90 and v["目标静止"] then
			if v["八荒CD"] <= v["GCD间隔"] * 2 and v["碎星辰气场距离"] <-1 and v["碎星辰气场时间"] > 10 and v["人剑CD"] > 10 then
				if cdtime("三环套月") <= 0 then
					if CastX("紫气东来") then
						CastX("凭虚御风")
					end
				end
			end
		end

		CastX("三环套月")
	end

	--人剑
	if rela("敌对") and dis() < 6 and v["碎星辰"] ~= 0 and v["吞日月"] ~= 0 and v["化三清"] == 0 then
		if v["碎星辰CD"] <= v["GCD间隔"] then
			CastX("人剑合一")
		end
	end

	--无我
	if v["风逝时间"] >= 0 and v["气点"] >= 6 then
		CastX("无我无剑")
	end

	--八荒
	CastX("八荒归元")

	--吞日月
	if rela("敌对") and v["吞日月"] == 0 and v["紫气时间"] < 0 then
		CastX("吞日月")
	end

	--化三清
	v["移动键被按下"] = keydown("MOVEFORWARD") or keydown("MOVEBACKWARD") or keydown("STRAFELEFT") or keydown("STRAFERIGHT") or keydown("JUMP")
	if fight() and mana() < 0.45 and v["目标静止"] and dis() < 6 and not v["移动键被按下"] then
		CastX("化三清", true)
	end

	--万剑
	if rela("敌对") and dis() < 8 then
		if v["三环CD"] > 0.5 and v["八荒CD"] > 0.5 and v["人剑CD"] > 0.5 then
			CastX("万剑归宗")
		end
	end

	--没放技能记录信息
	if fight() and rela("敌对") and dis() < 4 and face() < 90 and cdleft(16) <= 0 and castleft() <= 0 and state("站立|走路|跑步|跳跃") then
		if gettimer("碎星辰") > 0.3 and gettimer("吞日月") > 0.3 then
			PrintInfo("-- 没放技能")
		end
	end
end

-------------------------------------------------------------------------------

--记录信息
function PrintInfo(s)
	local t = {}
	if s then t[#t+1] = s end
	t[#t+1] = "气点:"..v["气点"]

	t[#t+1] = "玄门:"..v["玄门层数"]..", "..v["玄门时间"]
	t[#t+1] = "碎星辰:"..v["碎星辰buff时间"]
	t[#t+1] = "风逝:"..v["风逝时间"]
	t[#t+1] = "裂云:"..v["裂云时间"]
	t[#t+1] = "目标叠刃:"..v["目标叠刃层数"]..", "..v["目标叠刃时间"]
	t[#t+1] = "紫气:"..v["紫气时间"]
	t[#t+1] = "云中剑碎星辰:"..bufftime("14983")
	
	t[#t+1] = "碎星辰CD:"..v["碎星辰CD"]
	t[#t+1] = "吞日月CD:"..v["吞日月CD"]
	t[#t+1] = "三环CD:"..v["三环CD"]
	t[#t+1] = "万剑CD:"..v["万剑CD"]
	t[#t+1] = "八荒CD:"..v["八荒CD"]
	t[#t+1] = "人剑CD:"..v["人剑CD"]
	t[#t+1] = "紫气CD:"..v["紫气充能次数"]..", "..v["紫气充能时间"]

	print(table.concat(t, ", "))
end

--使用技能并记录信息
function CastX(szSkill, bSelf)
	if cast(szSkill, bSelf) then
		settimer(szSkill)
		if v["记录信息"] then PrintInfo() end
		return true
	end
	return false
end

-------------------------------------------------------------------------------

local tWWSkills = {
[383] = "无我1点气",
[386] = "无我2点气",
[387] = "无我3点气",
[388] = "无我4点气",
[389] = "无我5点气",
[390] = "无我6点气",
[391] = "无我7点气",
[392] = "无我8点气",
[393] = "无我9点气",
[394] = "无我10点气",
}

--释放技能
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		--if SkillID == 21816 then
		--	print("---------- 云中剑")
		--end

		--记录无我实际释放气点
		local s = tWWSkills[SkillID]
		if s then
			print("---------- "..s)
		end	
	end
end

--记录战斗状态改变
function OnFight(bFight)
	if bFight then
		print("--------------------进入战斗")
	else
		print("--------------------离开战斗")
	end
end
