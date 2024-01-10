--[[ 奇穴: [秋霽][雪覆][折意][風骨][北闕][淵嶽][玄肅][飛刃回轉][百節][忘斷][徵逐][孤路]
秘籍:
星垂	1会心 3伤害
金戈	2调息 2伤害
寂洪荒	3伤害 1消耗
乱天狼	2调息 2伤害
隐风雷	1会心 3伤害
斩无常  2调息 2伤害
血覆	2调息 2距离
幽冥	1会心 2伤害 1减伤

1段加速, 3.5尺内起手
出链金戈后要靠近目标3.5尺内, 因为后面日月后移8尺多, 太远打不到
日月后, 如果目标没动, 那基本不用管, 否则看情况保持6-12尺
打木桩还行, 实战体验不是很好
--]]

--关闭自动面向
setglobal("自动面向", false)

--宏选项
addopt("副本防开怪", false)

--变量表
local v = {}
v["记录信息"] = true

--函数表
local f = {}

--主循环
function Main()
	--按下自定义快捷键1挂扶摇, 注意是快捷键设定里面插件的快捷键1指定的按键，不是键盘上的1
	if keydown(1) then
		fcast("扶搖直上")
	end

	--记录读条结束
	if casting("寂洪荒") and castleft() < 0.13 then
		settimer("寂洪荒读条结束")
	end
	if casting("亂天狼") and castleft() < 0.13 then
		settimer("乱天狼读条结束")
	end

	--初始化变量
	local tSpeedXY, tSpeedZ = speed(tid())
	v["目标静止"] = rela("敌对") and tSpeedXY <= 0 and tSpeedZ <= 0
	v["GCD间隔"] = cdinterval(16)
	v["GCD"] = cdleft(16)
	v["金戈CD"] = scdtime("金戈回瀾")
	v["寂洪荒充能次数"] = cn("寂洪荒")
	v["寂洪荒充能时间"] = cntime("寂洪荒", true)
	v["寂洪荒CD"] = scdtime("寂洪荒")
	v["乱天狼CD"] = scdtime("亂天狼")
	v["隐风雷CD"] = scdtime("隱風雷")
	v["斩无常CD"] = scdtime("斬無常")
	v["血覆充能次数"] = cn("血覆黃泉")
	v["血覆充能时间"] = cntime("血覆黃泉", true)
	v["日月CD"] = scdtime("日月吳鉤")
	v["崔嵬CD"] = scdtime("崔嵬鬼步")
	v["飞刃CD"] = scdtime("飛刃回轉")
	v["寂洪荒读条时间"] = casttime("寂洪荒")
	v["乱天狼读条时间"] = casttime("亂天狼")
	v["斩无常读条时间"] = casttime("斬無常")

	v["目标链接时间"] = tbufftime("連結", id())
	v["风骨层数"] = buffsn("26215")			--8秒, 3层时寂洪荒打一次伤害然后删除
	v["风骨时间"] = bufftime("26215")
	v["崔嵬时间"] = bufftime("崔嵬鬼步")	--buff 16596 会心会效攻击+15% 给的是6秒 但是4秒崔嵬结束会删除, buff 24244 5秒额外乱天狼
	v["百节层数"] = buffsn("百節")			--6秒 3层 实际效果 15927 15928 15929, 加寂乱隐斩4个技能伤害 10% 20% 30%
	v["百节时间"] = bufftime("百節")
	v["忘断时间"] = bufftime("忘斷")		--10秒, 攻击+25%
	v["徵逐时间"] = bufftime("徵逐")		--10秒, 无视防御+50%
	v["额外隐风雷时间"] = bufftime("24744")			--孤路额外隐风雷


	--目标不是敌人 直接结束
	if not rela("敌对") then return end

	--副本防开怪
	if getopt("副本防开怪") and dungeon() and nofight() then return end

	--等待状态同步
	if gettimer("寂洪荒读条结束") < 0.3 then
		--if cdleft(16) <= 0 then print("----------等待寂洪荒释放") end
		return
	end

	--判断寂乱条件
	v["可放寂乱"] = false
	v["寂乱需要时间"] = 0
	if v["百节时间"] < v["寂洪荒读条时间"] then	--续不上了，等于没有百节
		if v["寂洪荒充能次数"] >= 3 and v["乱天狼CD"] <= v["寂洪荒读条时间"] * 3 then	--3寂 + 乱
			v["可放寂乱"] = "3寂 + 乱"
			v["寂乱需要时间"] = v["寂洪荒读条时间"] * 3 + casttime("亂天狼")
		end
	else
		if v["寂洪荒充能次数"] + v["百节层数"] >= 3 then	--能打够3百节
			if v["乱天狼CD"] <= (3 - v["百节层数"]) * v["寂洪荒读条时间"] then	--乱天狼CD小于打够3百节时间
				v["可放寂乱"] = format("%d寂 + 乱", 3 - v["百节层数"])
				v["寂乱需要时间"] = v["寂洪荒读条时间"] * (3 - v["百节层数"]) + casttime("亂天狼")
			end
		end
	end

	--双持斩无常条件
	v["放斩无常"] = false
	if not v["可放寂乱"] and dis() < 4 and v["斩无常CD"] <= v["GCD"] then
		if v["寂洪荒充能时间"] > v["斩无常读条时间"] and v["百节时间"] > v["斩无常读条时间"] + v["寂洪荒读条时间"] + 0.25 then
			v["放斩无常"] = true
		end
	end

	--断斩无常
	f["断斩"]()

	--日月吴钩, 向后冲刺 0.5秒 8.75尺左右, 读条中可用
	v["寂洪荒读条日月剩余"] = 0.625
	v["寂洪荒读条日月已读"] = v["寂洪荒读条时间"] - v["寂洪荒读条日月剩余"]
	if casting("寂洪荒") and castleft() <= v["寂洪荒读条日月剩余"] and dis() < 3.5 then
		--if v["百节时间"] > castleft() + 0.1 and v["百节层数"] + v["寂洪荒充能次数"] >= 3 and v["乱天狼CD"] <= (3 - v["百节层数"]) * v["GCD间隔"] then
		if not v["放斩无常"] then
			if v["徵逐时间"] > 3 then
				aCastX("日月吳鉤")
			end
		end
	end

	--乱天狼条件
	v["放乱天狼"] = false
	if (v["目标静止"] or ttid() == id()) and dis() < 12 and face() < 90 then
		if v["GCD"] < 0.5 and v["乱天狼CD"] <= v["GCD"] then
			if v["百节层数"] >= 3 and v["百节时间"] > v["寂洪荒读条时间"] + v["乱天狼读条时间"] + v["GCD"] + 0.3 then
				v["放乱天狼"] = true
			end
			
		end
	end

	if buff("單鏈") or gettimer("血覆黃泉") < 0.3 then
		if gettimer("幽冥窺月") > 0.3 then
			f["单链"]()
		end
	end

	if nobuff("單鏈") or gettimer("幽冥窺月") < 0.3 then
		if gettimer("血覆黃泉") > 0.3 then
			f["双持"]()
		end
	end

	--没放技能记录信息
	if fight() and rela("敌对") and dis() < 12 and face() < 60 and cdleft(16) <= 0 and castleft() <= 0  and state("站立|走路|跑步|跳躍") then
		if gettimer("幽冥窺月") > 0.3 and gettimer("血覆黃泉") > 0.3 and gettimer("寂洪荒") > 0.3 and gettimer("寂洪荒读条结束") > 0.3 and gettimer("亂天狼") > 0.3 and gettimer("乱天狼读条结束") > 0.3 and gettimer("斬無常") > 0.3 then
			PrintInfo("---------- 没放技能")
		end
	end
end

-------------------------------------------------------------------------------

f["单链"] = function()
	--收链乱天狼
	if v["放乱天狼"] and dis() > 6 then
		if f["收链"]("放乱天狼") then
			return
		end
	end

	--收链斩无常
	v["移动键被按下"] = keydown("MOVEFORWARD") or keydown("MOVEBACKWARD") or keydown("STRAFELEFT") or keydown("STRAFERIGHT") or keydown("JUMP")
	if not v["移动键被按下"] and dis() < 4 and cdtime("斬無常") <= 0 then
		if v["日月CD"] <= v["斩无常读条时间"] / 8 * 5 + v["寂洪荒读条日月已读"] then
			if v["百节时间"] > v["斩无常读条时间"] / 8 * 5 + v["寂洪荒读条时间"] + 0.3 then
				if f["收链"]("放斩无常") then
					CastX("斬無常")
				end
			end
		end
	end
	
	--n寂 + 乱
	if v["可放寂乱"] then
		if v["金戈CD"] > 0 or v["忘断时间"] > v["寂乱需要时间"] then
			if dis() < 12 and cdtime("寂洪荒") <= 0 and f["收链"](v["可放寂乱"]) then
				CastX("寂洪荒")
				return
			end
		end
	end

	--收链放寂洪荒保百节
	if v["百节时间"] > v["寂洪荒读条时间"] and v["百节时间"] < 2.5 then
		if dis() < 12 and cdtime("寂洪荒") <= 0 then
			if f["收链"]("放寂洪荒保百节") then
				CastX("寂洪荒")
			end
		end
	end

	--金戈 + 星垂 + 收链寂洪荒 + 日月
	if v["日月CD"] < v["GCD间隔"] * 2 + v["寂洪荒读条日月已读"] then
		if v["目标链接时间"] > 0 then
			CastX("金戈回瀾")
		end
	end

	--金戈 + 收链寂洪荒 + 斩无常 + 寂洪荒 + 日月
	if v["斩无常CD"] <= v["GCD间隔"] + v["寂洪荒读条时间"] then
		if v["日月CD"] < v["GCD间隔"] + v["寂洪荒读条时间"] + v["斩无常读条时间"] + v["寂洪荒读条日月已读"] then
			if v["目标链接时间"] > 0 then
				CastX("金戈回瀾")
			end
		end
	end

	--星垂
	if v["金戈CD"] > 0 and dis() < 6 and face() < 90 then
		if v["寂洪荒充能时间"] > v["GCD间隔"] + v["寂洪荒读条时间"] and v["百节时间"] > v["GCD间隔"] + v["寂洪荒读条时间"] + 0.3 then
			CastX("星垂平野")
		end
	end

	--收链寂洪荒
	if cdleft(16) <= 0 and dis() < 12 and cdtime("寂洪荒") <= 0 then
		if v["金戈CD"] > 0 or v["目标链接时间"] > 0 then
			if f["收链"]("放寂洪荒") then
				CastX("寂洪荒")
			end
		end
	end
end


f["双持"] = function()
	--隐风雷
	if dis() > 6 and dis() < 12 and face() < 90 and v["飞刃CD"] > 20 then
		 if v["百节层数"] >= 3 and v["百节时间"] > 0 and v["忘断时间"] >= 0 and v["徵逐时间"] >= 0 then
			aCastX("隱風雷")
		 end
	end
	v["飞刃"] = npc("关系:自己", "模板ID:107305")
	if v["飞刃"] ~= 0 and xdis(v["飞刃"]) < 12 then
		aCastX("隱風雷", 0, v["飞刃"])
	end

	--飞刃回转
	if dis() < 12 and v["百节时间"] >= v["GCD间隔"] + v["寂洪荒读条时间"] + 0.5 then
		if v["额外隐风雷时间"] >= 0 and v["忘断时间"] > 7 then
			if CastX("飛刃回轉") then
				aCastX("隱風雷")
			end
		end
	end

	--崔嵬鬼步
	v["寂+乱读条时间"] = v["寂洪荒读条时间"] + v["乱天狼读条时间"] + 0.3
	if (v["目标静止"] or ttid() == id()) and dis() > 6 and dis() < 12 then
		if v["百节层数"] >= 2 and v["百节时间"] > casttime("寂洪荒") and v["忘断时间"] > v["寂+乱读条时间"] and v["徵逐时间"] > v["寂+乱读条时间"] then
			if cdtime("寂洪荒") <= 0 and cdtime("崔嵬鬼步") <= 0 then
				CastX("崔嵬鬼步")
				CastX("寂洪荒")
			end
		end

		if v["忘断时间"] > v["乱天狼读条时间"] and v["徵逐时间"] > v["乱天狼读条时间"] then
			if v["百节层数"] >= 3 and v["百节时间"] > v["寂洪荒读条时间"] + v["乱天狼读条时间"] + v["GCD"] then
				if v["GCD"] < 0.5 and v["寂洪荒充能时间"] > 5 then
					CastX("崔嵬鬼步")
				end
			end
		end
	end

	--乱天狼
	if v["放乱天狼"] then
		if v["徵逐时间"] > v["乱天狼读条时间"] or gettimer("幽冥窺月") < 0.3 then
			aCastX("亂天狼")
		end
		if v["徵逐时间"] <= v["乱天狼读条时间"] and gettimer("幽冥窺月") > 0.3 then
			f["出链"]("乱天狼续徵逐")
		end
	end

	--斩无常
	if v["放斩无常"] then
		CastX("斬無常")
	end

	--出链
	if v["GCD"] < 0.5 and v["金戈CD"] <= v["GCD"] and v["日月CD"] <= v["GCD"] + v["GCD间隔"] * 2 + v["寂洪荒读条日月已读"] then
		if v["百节时间"] > v["GCD"] + v["GCD间隔"] * 2 + v["寂洪荒读条时间"] then
			f["出链"]("金戈 + 星垂 + 收链寂洪荒 + 日月")
		end
	end
	
	if v["GCD"] < 0.5 and v["金戈CD"] <= v["GCD"] then
		if v["斩无常CD"] <= v["GCD"] + v["GCD间隔"] + v["寂洪荒读条时间"] then
			if v["日月CD"] <= v["GCD"] + v["GCD间隔"] + v["寂洪荒读条时间"] + v["斩无常读条时间"] + v["寂洪荒读条日月已读"] then
				if v["百节时间"] > v["GCD"] + v["GCD间隔"] + v["寂洪荒读条时间"] then
					f["出链"]("金戈 + 收链寂洪荒 + 斩无常 + 寂洪荒 + 日月")
				end
			end
		end
	end

	--寂洪荒
	if v["寂洪荒充能次数"] >= 3 then	--起手
		if CastX("寂洪荒") then
			print("起手寂洪荒")
		end
	end

	if dis() < 12 and v["GCD"] < 0.5 and v["寂洪荒CD"] <= v["GCD"] then
		if v["徵逐时间"] <= v["寂洪荒读条时间"] then
			f["出链"]("寂洪荒续徵逐")
		end
		CastX("寂洪荒")
	end
end

f["断斩"] = function()
	local szBreakReason = nil
	if casting("斬無常") then
		v["6尺内敌人"] = npc("关系:敌对", "可选中", "距离<6")
		if v["6尺内敌人"] == 0 then
			szBreakReason = "6尺内没敌人"
		end
		if v["额外隐风雷时间"] >= 0 then
			if v["寂洪荒充能次数"] >= 1 and v["百节时间"] > v["寂洪荒读条时间"] and v["百节时间"] < v["寂洪荒读条时间"] + 0.3 then
				szBreakReason = "保百节"
			end
			if v["飞刃CD"] <= v["寂洪荒读条时间"] and v["寂洪荒充能次数"] >= 2 then
				szBreakReason = "放飞刃"
			end
		end
	end

	if szBreakReason then
		stopcasting()
		PrintInfo("--断斩无常:"..szBreakReason)
	end
end

f["出链"] = function(szReason)
	if gettimer("血覆黃泉") > 0.3 and CastX("血覆黃泉") then
		print("-------------------- 出链:"..szReason, frame())
		exit()
	end
end

f["收链"] = function(szReason)
	if gettimer("幽冥窺月") > 0.3 and CastX("幽冥窺月") then
		print("-------------------- 收链:"..szReason, frame())
		return true
	end
	return false
end

-------------------------------------------------------------------------------

--记录信息
function PrintInfo(s)
	local t = {}
	if s then t[#t+1] = s end
	
	--t[#t+1] = "目标链接:"..v["目标链接时间"]
	t[#t+1] = "百节:"..v["百节层数"]..", "..v["百节时间"]
	t[#t+1] = "忘断:"..v["忘断时间"]
	t[#t+1] = "徵逐:"..v["徵逐时间"]
	t[#t+1] = "崔嵬:"..v["崔嵬时间"]
	t[#t+1] = "风骨:"..v["风骨层数"]..", "..v["风骨时间"]

	t[#t+1] = "寂洪荒CD:"..v["寂洪荒充能次数"]..", "..v["寂洪荒充能时间"]
	t[#t+1] = "乱天狼CD:"..v["乱天狼CD"]
	t[#t+1] = "日月CD:"..v["日月CD"]
	t[#t+1] = "金戈CD:"..v["金戈CD"]
	t[#t+1] = "崔嵬CD:"..v["崔嵬CD"]
	t[#t+1] = "斩无常CD:"..v["斩无常CD"]
	t[#t+1] = "飞刃CD:"..v["飞刃CD"]
	t[#t+1] = "隐风雷CD:"..v["隐风雷CD"]
	--t[#t+1] = "血覆CD:"..v["血覆充能次数"]..", "..v["血覆充能时间"]
	t[#t+1] = "额外隐风雷:"..v["额外隐风雷时间"]
	t[#t+1] = "距离:"..format("%.1f", dis())
	t[#t+1] = "GCD:"..v["GCD"]
	
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

function aCastX(szSkill)
	if acast(szSkill) then
		settimer(szSkill)
		if v["记录信息"] then PrintInfo() end
		return true
	end
	return false
end

-------------------------------------------------------------------------------

--buff更新
function OnBuff(CharacterID, BuffName, BuffID, BuffLevel, StackNum, SkillSrcID, StartFrame, EndFrame, FrameCount)
	if CharacterID == id() then
		if BuffID == 15524 then		--单链
			deltimer("血覆黃泉")
			deltimer("幽冥窺月")
		end
		if BuffID == 26215 then	--寂洪荒风骨计数
			if StackNum  > 0 then
				deltimer("寂洪荒读条结束")
			end
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
