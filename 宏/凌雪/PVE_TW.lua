--[[ 奇穴: [秋霽][雪覆][折意][風骨][北闕][淵嶽][玄肅][飛刃回轉][百節][忘斷][徵逐][青山共我]
秘籍:
星垂	1会心 3伤害
金戈	2会心 2伤害
寂洪荒	3伤害
乱天狼	2调息 2伤害
隐风雷	1会心 3伤害
血覆	2调息 2距离
幽冥	2伤害 2会心或1会心1减伤
--]]

--关闭自动面向
setglobal("自动面向", false)

--宏选项
addopt("副本防开怪", false)

--变量表
local v = {}
v["输出信息"] = true
v["放过乱天狼"] = false

--主循环
function Main(g_player)
	if casting("寂洪荒") and castleft() < 0.13 then
		settimer("寂洪荒读条结束")
	end
	if casting("亂天狼") and castleft() < 0.13 then
		settimer("乱天狼读条结束")
	end

	--初始化变量
	v["金戈CD"] = scdtime("金戈回瀾")
	v["寂洪荒充能总时间"] = cntime("寂洪荒", true)
	v["寂洪荒充能次数"] = cn("寂洪荒")
	v["乱天狼CD"] = scdtime("亂天狼")
	v["日月吴钩CD"] = scdtime("日月吳鉤")
	v["鬼步CD"] = scdtime("崔嵬鬼步")
	v["飞刃CD"] = scdtime("飛刃回轉")
	v["青山CD"] = scdtime("青山共我")
	v["鬼步时间"] = bufftime("崔嵬鬼步")	--会心会效基础攻击提高15%, 4秒
	v["鬼步乱天狼时间"] = bufftime("24244")	--额外乱天狼 5秒
	v["风骨层数"] = buffsn("26215")
	v["风骨时间"] = bufftime("26215")		--8秒
	v["百节层数"] = buffsn("百節")			--实际效果 15927 15928 15929
	v["百节时间"] = bufftime("百節")		--5秒
	v["忘断时间"] = bufftime("忘斷")		--10秒
	v["徵逐时间"] = bufftime("徵逐")		--10秒
	v["单链"] = buff("15524")
	v["双链"] = buff("15565")
	v["双持"] = nobuff("15524|15565")
	local tSpeedXY, tSpeedZ = speed(tid())
	v["目标静止"] = rela("敌对") and tSpeedXY <= 0 and tSpeedZ <= 0
	v["寂洪荒读条时间"] = casttime("寂洪荒")

	--目标不是敌对, 结束
	if not rela("敌对") then return end
	--副本 没进战 选项打开, 结束
	if getopt("副本防开怪") and dungeon() and nofight() then return end

	--等待状态同步
	if gettimer("等待出链") < 0.3 then print("--------------------等待出链") return end
	if gettimer("等待收链") < 0.3 then print("--------------------等待收链") return end
	if gettimer("寂洪荒读条结束") < 0.3 then
		--print("----------等待寂洪荒释放")
		return
	end

	--隐风雷推飞刃
	v["飞刃"] = npc("关系:自己", "模板ID:107305", "距离<12")
	if v["飞刃"] ~= 0 then
		aCastX("隱風雷", 0, v["飞刃"])
	end

	--日月吴钩
	if dis() < 5 and v["徵逐时间"] > 9 then
		if aCastX("日月吳鉤") then
			settimer("日月吴钩")
		end
	end

	---------------------------------------------

	if v["双持"] then
		--隐风雷
		if dis() > 6 and dis() < 12 and face() < 60 and v["飞刃CD"] > 20 then
			 if v["百节层数"] >= 3 and v["百节时间"] > 0 and v["忘断时间"] > 0 and v["徵逐时间"] > 0 then
				CastX("隱風雷")
			 end
		end

		--鬼步
		if dis() < 12 and v["寂洪荒充能总时间"] > 4.5  and v["乱天狼CD"] > 8 and v["徵逐时间"] > 8 then
			if CastX("崔嵬鬼步") then
				settimer("崔嵬鬼步")
			end
		end

		--出链
		v["出链"] = false

		if v["徵逐时间"] < 2 then
			v["出链"] = "出链, 徵逐时间快到了"
		elseif v["百节层数"] < 3 and v["徵逐时间"] < 3 then
			v["出链"] = "出链, 没3层百节徵逐时间小于3秒"
		elseif v["放过乱天狼"] then
			v["出链"] = "出链, 放过乱天狼"
		end

		if v["出链"] then
			if CastX("血覆黃泉") then
				settimer("等待出链")
				print(v["出链"])
				return
			end
		end

		--飞刃
		if dis() < 12 and gettimer("日月吴钩") > 0.3 and v["忘断时间"] > 7 then
			CastX("飛刃回轉")
		end

		--寂洪荒
		if v["百节层数"] < 3 or v["百节时间"] < 2.5 or v["鬼步时间"] > 3 then
			if CastX("寂洪荒") then
				settimer("寂洪荒")	--冲刺中可用
			end
		end

		--乱天狼
		if dis() < 12 and face() < 60 then
			if v["百节层数"] >= 3 or v["鬼步时间"] > 1 then
				if aCastX("亂天狼") then
					settimer("乱天狼")
				end
			end
		end
	end

	---------------------------------------------

	if v["单链"] then
		--收链
		local nTime = (v["寂洪荒读条时间"] + 0.0625) * 2 + 0.25
		if v["飞刃CD"] < 1 then
			nTime = nTime + cdinterval(16)
		end

		v["收链"] = false
		if dis() < 5 and v["寂洪荒充能总时间"] <= nTime then	--能打3次乱
			v["收链"] = "收链, 打寂 * 3 + 乱"
			cbuff("百節")
		elseif dis() > 6 and dis() < 12 and v["目标静止"] and v["鬼步CD"] < 0.1 and v["寂洪荒充能次数"] >= 1 and v["寂洪荒充能总时间"] > 5 and v["乱天狼CD"] > 8.5 then
			v["收链"] = "收链, 打鬼步 + 寂 + 乱"
		end

		if v["收链"] then
			if CastX("幽冥窺月") then
				settimer("等待收链")
				print(v["收链"])
				return
			end
		end

		--CastX("鐵馬冰河")
		
		--金戈
		CastX("金戈回瀾")

		--青山
		if v["目标静止"] and v["金戈CD"] > 0 then
			CastX("青山共我")
		end
		
		--星垂
		if v["金戈CD"] > 0 and dis() < 6 and face() < 90 then
			CastX("星垂平野")
		end
	end

	---------------------------------------------

	if fight() and rela("敌对") and dis() < 12 and face() < 60 and cdleft(16) <= 0 and castleft() <= 0  and gettimer("寂洪荒") > 0.3 and gettimer("乱天狼") > 0.3 and state("站立|走路|跑步|跳躍") then
		PrintInfo("----------没打技能, ")
	end
end

--输出信息
function PrintInfo(s)
	local szinfo = "金戈CD:"..v["金戈CD"]..", 寂洪荒CD:"..v["寂洪荒充能次数"]..", "..v["寂洪荒充能总时间"]..", 乱天狼CD:"..v["乱天狼CD"]..", 日月吴钩CD:"..v["日月吴钩CD"]..", 鬼步CD:"..v["鬼步CD"]..", 飞刃CD:"..v["飞刃CD"]..", 青山CD:"..v["青山CD"]..", 风骨:"..v["风骨层数"]..", "..v["风骨时间"]..", 百节:"..v["百节层数"]..", "..v["百节时间"]..", 忘断:"..v["忘断时间"]..", 徵逐:"..v["徵逐时间"]..", 鬼步:" ..v["鬼步时间"]..", "..v["鬼步乱天狼时间"]
	if s then
		szinfo = s..szinfo
	end
	print(szinfo)
end

--使用技能并输出信息
function CastX(szSkill)
	if cast(szSkill) then
		if v["输出信息"] then PrintInfo() end
		return true
	end
	return false
end

function aCastX(szSkill)
	if acast(szSkill) then
		if v["输出信息"] then PrintInfo() end
		return true
	end
	return false
end

--技能释放
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		if SkillID == 22327 then	--寂洪荒
			deltimer("寂洪荒读条结束")
			return
		end
		if SkillID == 22361 then	--幽冥窥月
			v["放过乱天狼"] = false
			return
		end
		if SkillID == 22320 then	--乱天狼
			v["放过乱天狼"] = true
			return
		end
	end
end

--buff更新
function OnBuff(CharacterID, BuffName, BuffID, BuffLevel, StackNum, SkillSrcID, StartFrame, EndFrame, FrameCount)
	if CharacterID == id() then
		if BuffID == 15524 then	--单链
			if StackNum  > 0 then
				deltimer("等待出链")
			else
				deltimer("等待收链")
			end
		end
	end
end

--没用，输出下信息
function OnFight(bFight)
	if gettimer("进战脱战") > 5 then
		settimer("进战脱战")
		if bFight then
			print("--------------------进入战斗")
		else
			print("--------------------离开战斗")
		end
	end
end
