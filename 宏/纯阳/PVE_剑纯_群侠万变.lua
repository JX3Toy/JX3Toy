--[[ 奇穴:[心固][环月][化三清][镜花影][风逝][叠刃][长生][裂云][故长][期声][虚极][玄门]
秘籍:
生太极	3读条 1效果
吞日月	全点
三环	1会心 3伤害 (1段以上加速 伤害3换成减CD)
无我	1会心 2伤害 1效果
八荒	3伤害 1效果
人剑	1调息 1dot 1吞碎气剑 1伤害
坐忘	2调息 1回血蓝 1减伤
凭虚	2调息 1减消耗 1闪避回血
--]]

--关闭自动面向
setglobal("自动面向", false)

--宏选项
addopt("副本防开怪", false)
addopt("手动爆发", false)

--变量表
local v = {}
v["输出信息"] = true

--主循环
function Main()
	--初始化变量
	v["气点"] = qidian()
	v["碎星辰CD"] = scdtime("碎星辰")
	v["吞日月CD"] = scdtime("吞日月")
	v["三环CD"] = scdtime("三环套月")
	v["万剑CD"] = scdtime("万剑归宗")
	v["八荒CD"] = scdtime("八荒归元")
	v["人剑CD"] = scdtime("人剑合一")
	v["叠刃时间"] = tbufftime("叠刃", id())
	v["叠刃层数"] = tbuffsn("叠刃", id())
	v["风逝时间"] = bufftime("风逝")
	v["玄门时间"] = bufftime("玄门")
	v["玄门层数"] = buffsn("玄门")

	local tSpeedXY, tSpeedZ = speed(tid())
	v["目标静止"] = rela("敌对") and tSpeedXY <= 0 and tSpeedZ <= 0
	v["化三清"] = npc("关系:自己", "名字:气场化三清", "距离<15")
	v["碎星辰"] = npc("关系:自己", "名字:气场碎星辰", "距离<13")
	v["吞日月"] = npc("关系:自己", "名字:气场吞日月", "距离<13")
	_, v["气场数量"] = npc("关系:自己", "名字:气场生太极|气场碎星辰|气场吞日月", "距离<13")

	--没进战，挂坐忘
	if nofight() and nobuff("坐忘无我") then
		CastX("坐忘无我")
	end

	--减伤
	if fight() and life() < 0.5 and gettimer("坐忘无我") > 0.3 and nobuff("坐忘无我") and gettimer("转乾坤") > 0.3 and buffstate("减伤效果") < 40 then
		if CastX("坐忘无我") then return end
		if CastX("转乾坤") then return end
	end

	--没进战 3碎
	if nofight() and v["目标静止"] then
		_, v["目标气场数量"] = tnpc("关系:自己", "名字:气场生太极|气场碎星辰|气场吞日月", "距离<13")
		if v["目标气场数量"] < 3 then
			CastX("碎星辰")
		end
	end
	
	--副本防开怪
	if getopt("副本防开怪") and dungeon() and nofight() then return end

	--人剑 起手打玄门
	if rela("敌对") and dis() < 6 and v["气场数量"] >= 3 and v["玄门层数"] < 3 then
		if v["化三清"] == 0 and v["碎星辰CD"] < cdinterval(16) then
			CastX("人剑合一")
		end
	end

	--插气场打出3玄门
	if v["气场数量"] < 3 and v["气场数量"] + v["玄门层数"] < 3 then
		CastX("吞日月")
		CastX("生太极")
	end

	--三环套月
	if v["叠刃时间"] < 0 or v["叠刃时间"] > 12 then
		CastX("三环套月")
	end

	--碎星辰
	v["碎星辰距离"], v["碎星辰时间"] = qc("气场碎星辰", id(), id())
	if v["碎星辰距离"] > -1 or v["碎星辰时间"] < 1 then
		CastX("碎星辰")
	end

	--紫气, 绑定镜花影
	if not getopt("手动爆发") or keydown(1) then	--没打开手动爆发选项, 或者按下快捷键1(不是按键1, 是在快捷键设置中自己设置的快捷键1对应的按键)
		if nobuff("紫气东来") and rela("敌对") and dis() < 6 and face() < 90 and bufftime("镜花影") > 0.5 and cdtime("镜花影") <= 0 then
			if v["玄门时间"] > 10 and v["玄门层数"] >= 3 then
				if CastX("紫气东来") then
					CastX("凭虚御风")
				end
			end
		end
	end

	--镜花影
	CastX("镜花影")

	--万剑归宗
	if rela("敌对") and dis() < 8 and tnpc("关系:自己", "名字:气场吞日月", "角色距离<10") ~= 0 then
		CastX("万剑归宗")
	end
	
	--无我无剑
	if v["风逝时间"] > 0 and qidian() >= 6 then
		if v["叠刃时间"] < 12 then
			CastX("无我无剑")
		end
	end

	--人剑爆气场
	if rela("敌对") and dis() < 6 and v["碎星辰"] ~= 0 and v["吞日月"] ~= 0 then
		if v["化三清"] == 0 and v["碎星辰CD"] < cdinterval(16) then
			CastX("人剑合一")
		end
	end

	--无我无剑
	if v["风逝时间"] > 0 and qidian() >= 6 then
		CastX("无我无剑")
	end

	--吞日月
	if v["吞日月"] == 0 then
		CastX("吞日月")
	end

	--化三清
	if fight() and mana() < 0.4 then
		if CastX("化三清", true) then
			stopmove()
		end
	end

	--八荒归元
	CastX("八荒归元")

	--没打技能输出信息
	if fight() and rela("敌对") and dis() < 6 and cdleft(16) <= 0 and castleft() <= 0 and gettimer("吞日月") > 0.3 and gettimer("碎星辰") > 0.3 and gettimer("生太极") > 0.3 and gettimer("化三清") > 0.3 and state("站立|走路|跑步|跳跃") then
		PrintInfo("----------没打技能, ")
	end
end

--输出信息
function PrintInfo(s)
	if not v["输出信息"] then return end
	local szinfo = "气点:"..v["气点"]..", 叠刃:"..v["叠刃层数"]..", "..v["叠刃时间"]..", 风逝:"..v["风逝时间"]..", 玄门:"..v["玄门层数"]..", "..v["玄门时间"]..", 三环CD:"..v["三环CD"]..", 碎星辰CD:"..v["碎星辰CD"]..", 人剑CD:"..v["人剑CD"]..", 万剑CD:"..v["万剑CD"]..", 碎星辰CD:"..v["碎星辰CD"]..", 吞日月CD:"..v["吞日月CD"]
	if s then
		szinfo = s..szinfo
	end
	print(szinfo)
end

--使用技能并输出信息
function CastX(szSkill, bSelf)
	if cast(szSkill, bSelf) then
		settimer(szSkill)
		PrintInfo()
		return true
	end
	return false
end

--战斗状态改变
function OnFight(bFight)
	if bFight then
		print("--------------------进入战斗")
	else
		print("--------------------离开战斗")
	end
end
