--[[ 奇穴: [淮茵][鴆羽][結草][靈荊][苦苛][堅陰][相使][悽骨][疾根][紫伏][甘遂][養榮]
秘籍:
商陆  2会心 2伤害
钩吻  2会心 2伤害
川乌  2会心 1伤害 1回内
且待  2调息 2伤害
银光  1会心 1效果(超出范围对自身释放) 2消耗

凑合能用, 靠近15尺内打, 把握下吃灵荆的时机不要打断川乌和且待
5寒起手, 脱战周围没怪运行一下, 会放沾衣打出5点寒, 打2分钟蓝就不够了
--]]

--关闭自动面向
setglobal("自动面向", false)

--宏选项
addopt("副本防开怪", false)
addopt("内力小于60%关千枝", false)

--变量表
local v = {}
v["记录信息"] = true
v["川乌跳数"] = 0
v["且待跳数"] = 0
v["沾衣跳数"] = 0
v["关千枝"] = false

--函数表
local f = {}

--主循环
function Main()
	--按下自定义快捷键1挂扶摇, 注意是快捷键设定里面插件的快捷键1指定的按键, 不是键盘上的1
	if keydown(1) then
		cast("扶搖直上")
	end

	--记录读条结束
	if casting("商陸綴寒") and castleft() < 0.13 then
		settimer("商陆读条结束")
	end
	if casting("川烏射罔") and castleft() < 0.13 then
		settimer("川乌读条结束")
	end
	if casting("且待時休") and castleft() < 0.13 then
		settimer("且待读条结束")
	end

	--初始化变量
	v["药性"] = yaoxing()	--温大于0 寒小于0 -5到5区间
	v["药性绝对值"] = math.abs(v["药性"])
	local tSpeedXY, tSpeedZ = speed(tid())
	v["目标静止"] = rela("敌对") and tSpeedXY <= 0 and tSpeedZ <= 0

	v["GCD间隔"] = cdinterval(16)
	v["GCD"] = cdleft(16)
	v["川乌透支次数"] = od("川烏射罔")
	v["川乌透支冷却时间"] = odtime("川烏射罔")
	v["川乌CD"] = scdtime("川烏射罔")
	v["沾衣CD"] = scdtime("沾衣未妨")
	v["且待CD"] = scdtime("且待時休")
	v["银光CD"] = scdtime("銀光照雪")
	v["含锋CD"] = cdleft(2021)
	v["苍棘CD"] = scdtime("蒼棘縛地")
	v["紫叶CD"] = scdtime("紫葉沉痾")
	v["绿野CD"] = scdtime("綠野蔓生")
	v["应理CD"] = scdtime("應理與藥")

	v["逆乱层数"] = tbuffsn("逆亂", id())
	v["逆乱时间"] = tbufftime("逆亂", id())
	v["相使时间"] = bufftime("相使")
	v["凄骨时间"] = bufftime("悽骨")
	v["商陆瞬发"] = buff("21106")
	v["绿野破招"] = buff("24458")
	v["应理破招次数"] = buffsn("24469")

	v["苍棘"] = npc("关系:自己", "模板ID:106107")
	v["紫叶花"] = npc("关系:自己", "模板ID:106632")
	v["紫叶花时间"] = bufftime("20702")
	v["移动键被按下"] = keydown("MOVEFORWARD") or keydown("MOVEBACKWARD") or keydown("STRAFELEFT") or keydown("STRAFERIGHT") or keydown("JUMP")

	---------------------------------------------------------------------------

	--没进战 沾衣打出5点寒
	if nofight() and v["药性"] > -5 then 
		if not rela("敌对") or dis() > 35 and  v["GCD"] <= 0 then
			if npc("关系:敌对", "距离<11") == 0 then	--11尺内没怪
				CastX("沾衣未妨", true)
			end
		end
	end

	--副本防开怪
	if getopt("副本防开怪") and dungeon() and nofight() then return end

	---------------------------------------------------------------------------

	v["飞叶条件"] = false
	if rela("敌对") and buff("20071") then
		if (dis() < 10 and face() < 90) or (v["苍棘"] ~= 0 and xxdis(v["苍棘"], tid()) < 10) then	--自己或苍棘10尺内
			if v["逆乱层数"] >= 8 and v["逆乱时间"] > 7 then
				v["飞叶条件"] = true
				CastX("飛葉滿襟")
			end
		end
	end

	--飞叶满襟
	if v["飞叶条件"] then
		CastX("飛葉滿襟")
	end

	--银光照雪
	if rela("敌对") then
		if dis() < 6 or (v["苍棘"] ~= 0 and xxdis(v["苍棘"], tid()) < 6) then	--自己或苍棘6尺内
			--if v["凄骨时间"] > 0 and v["相使时间"] > 0 and buff("千枝綻蕊") and gettimer("关千枝") > 0.3 then
			if v["凄骨时间"] > 0 and v["相使时间"] > 0 then
				if cdtime("銀光照雪") <= 0 then
					if CastX("綠野蔓生") then	--绿野绑定银光, 含锋飞叶系数低
						CastX("銀光照雪")
					end
					if v["绿野CD"] > 6 then
						CastX("銀光照雪")
					end
				end
			end
		end
	end

	--橙武
	if bufftime("21796") > casttime("川烏射罔") then
		f["开千枝"]("放川乌", 0.25)
		CastX("川烏射罔")
	end

	--苍棘缚地
	if rela("敌对") then
		CastX("蒼棘縛地")
	end

	--紫叶沉疴
	if rela("敌对") then
		if CastX("紫葉沉痾") then
			CastX("沾衣未妨")
		end
	end

	--等待商陆释放 药性同步
	if gettimer("商陆读条结束") < 0.3 then
		--print("----------等待商陆释放")
		return
	end

	--川乌
	if rela("敌对") and dis() < 20 and gettimer("川乌读条结束") > 0.5 and not v["移动键被按下"] then
		if v["凄骨时间"] < 12 then
			if v["药性"] <= -3 or (gettimer("释放沾衣未妨") < 4 and v["药性"] - (5 -v["且待跳数"]) <= -3) then
				if cdtime("川烏射罔") <= 0 then
					f["开千枝"]("放川乌", 0.25)
					if CastX("川烏射罔") then
						v["川乌跳数"] = 0
						stopmove()
						return
					end
				end
			end
		end
	end

	--且待时休
	if rela("敌对") and (v["目标静止"] or ttid() == id()) and dis() < 15 and not v["移动键被按下"] then
		if v["逆乱层数"] >= 4 and v["逆乱时间"] > casttime("且待時休") + v["GCD间隔"] * 2 + 0.5 and not v["飞叶条件"] then
			if v["川乌CD"] > casttime("且待時休") and v["相使时间"] > casttime("且待時休") + casttime("川烏射罔") + 0.5 then
				if cdtime("且待時休") <= 0 then
					f["开千枝"]("放且待", 0.4)
					if CastX("且待時休") then
						v["且待跳数"] = 0
						stopmove()
						return
					end
				end
			end
		end
	end

	--含锋破月
	if rela("敌对") then
		if (dis() < 6 and face() < 90) or (v["苍棘"] ~= 0 and xxdis(v["苍棘"], tid()) < 6) then	--自己或苍棘6尺内
			if v["药性"] <= -3 or (gettimer("释放沾衣未妨") < 4 and v["药性"] - (5 -v["且待跳数"]) <= -3) or v["川乌CD"] > v["GCD间隔"] * 2 then
				if v["逆乱层数"] >= 8 and v["逆乱时间"] > 11 then
					if v["凄骨时间"] > 1 and v["相使时间"] > 1 then
						if cdtime("含鋒破月") <= 0 then
							f["开千枝"]("放含锋", 0.4)
							CastX("含鋒破月")
						end
					end
				end
			end
		end
	end

	--钩吻
	if v["相使时间"] < 3 or v["药性"] < -3 --[[or v["药性"] - (5 -v["且待跳数"]) < -3--]] then
		CastX("鉤吻斷腸")
	end

	--商陆
	CastX("商陸綴寒")

	f["关千枝"]()

	--没放技能记录信息
	if fight() and rela("敌对") and dis() < 20 and state("站立") and cdleft(16) <= 0 and castleft() <= 0 then
		if gettimer("川烏射罔") > 0.3 and gettimer("商陸綴寒") > 0.3 and gettimer("且待時休") > 0.3 and gettimer("蒼棘縛地") > 0.3 and gettimer("川乌读条结束") > 0.3 and gettimer("且待读条结束") > 0.3 then
			PrintInfo("-- 没放技能")
		end
	end
end

-------------------------------------------------------------------------------

f["开千枝"] = function(szReason, nMana)
	v["关千枝"] = false
	if buff("千枝綻蕊") and gettimer("关千枝") > 0.3 then
		return true
	end

	if mana() > nMana then
		if cast("千枝綻蕊") then
			print("-------------------- 开千枝:"..szReason)
			return true
		end
	end
	return false
end

f["关千枝"] = function()
	if gettimer("川烏射罔") < 0.3 or casting("川烏射罔") or gettimer("川乌读条结束") < 0.3 then return end
	if gettimer("且待時休") < 0.3 or casting("且待時休") or gettimer("且待读条结束") < 0.3 then return end
	if gettimer("含鋒破月") < 0.3 or v["飞叶条件"] or gettimer("释放飞叶满襟") <= 0.5 then return end

	--川乌 含锋 且待都CD
	if v["川乌CD"] > 3 and v["含锋CD"] > 3 and v["且待CD"] > 3 then
		if not getopt("内力小于60%关千枝") or mana() < 0.6 then
			if cbuff("千枝綻蕊") then
				settimer("关千枝")
			end
		end
	end

	--目标不是敌对
	if not rela("敌对") then
		if cbuff("千枝綻蕊") then
			settimer("关千枝")
		end
	end
end

--记录信息
function PrintInfo(s)
	local t = {}
	if s then t[#t+1] = s end
	t[#t+1] = "药性:"..v["药性"]
	t[#t+1] = "内力:"..format("%.2f", mana())

	t[#t+1] = "逆乱:"..v["逆乱层数"]..", "..v["逆乱时间"]
	t[#t+1] = "相使:"..v["相使时间"]
	t[#t+1] = "凄骨:"..v["凄骨时间"]

	t[#t+1] = "川乌CD:"..v["川乌透支次数"]..", "..v["川乌透支冷却时间"]..", "..v["川乌CD"]
	t[#t+1] = "且待CD:"..v["且待CD"]
	t[#t+1] = "苍棘CD:"..v["苍棘CD"]
	t[#t+1] = "紫叶CD:"..v["紫叶CD"]
	t[#t+1] = "含锋CD:"..v["含锋CD"]
	t[#t+1] = "银光CD:"..v["银光CD"]
	t[#t+1] = "沾衣CD:"..v["沾衣CD"]
	t[#t+1] = "绿野CD:"..v["绿野CD"]
	t[#t+1] = "千枝CD:"..scdtime("千枝綻蕊")
	
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

--buff更新
function OnBuff(CharacterID, BuffName, BuffID, BuffLevel, StackNum, SkillSrcID, StartFrame, EndFrame, FrameCount)
	if CharacterID == id() then
		if BuffID == 20075 then		--千枝绽蕊
			deltimer("关千枝")
			if StackNum > 0 then
				print("-------------------- 开千枝")
			else
				print("-------------------- 关千枝")
			end
		end

		if StackNum <= 0 and BuffID == 20071 then
			v["关千枝"] = "含锋二段buff移除"
		end

		--[[调试buff增减
		if StackNum > 0 then
			print("添加buff->"..BuffName, BuffID, BuffLevel, SkillSrcID, StartFrame, (EndFrame -StartFrame) / 16, EndFrame, FrameCount)
		else
			print("移除buff->"..BuffName, BuffID, BuffLevel)
		end
		--]]
	end
end

--药性更新
function OnYaoxingUpdate()
	deltimer("商陆读条结束")
end

--读条中断
function OnBreak(CharacterID)
	if CharacterID == id() then
		v["关千枝"] = "读条中断"
	end
end

--释放技能
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		--[[调试技能释放
		if TargetType == 2 then
			print("OnCast->"..SkillName, "技能ID:"..SkillID, "等级:"..SkillLevel, "目标:"..TargetID.."|"..PosY.."|"..PosZ, "开始帧:"..StartFrame, "当前帧:"..FrameCount)
		else
			print("OnCast->"..SkillName, "技能ID:"..SkillID, "等级:"..SkillLevel, "目标:"..TargetID, "开始帧:"..StartFrame, "当前帧:"..FrameCount)
		end
		--]]

		if SkillID == 27578 then
			v["沾衣跳数"] = 0
			settimer("释放沾衣未妨")
		end

		if SkillID == 28114 then
			v["沾衣跳数"] = v["沾衣跳数"] + 1
			if v["沾衣跳数"] >= 5 then
				deltimer("释放沾衣未妨")
			end
		end

		if SkillID == 27556 then	--川乌每跳
			v["川乌跳数"] = v["川乌跳数"] + 1
			if v["川乌跳数"] >= 4 then
				v["关千枝"] = "川乌读条结束"
			end
		end

		if SkillID == 27584 then	--且待每跳
			v["且待跳数"] = v["且待跳数"] + 1
			if v["且待跳数"] >= 5 then
				v["关千枝"] = "且待读条结束"
			end
		end

		if SkillID == 28372 then
			v["关千枝"] = "飞叶释放结束"
		end

		if SkillID == 27637 then	--飞叶
			settimer("释放飞叶满襟")
		end
	end
end

local tNpcName = {
[106107] = "苍棘缚地",
[106632] = "紫叶花",
}

--NPC进入场景
function OnNpcEnter(NpcID, NpcName, NpcTemplateID, NpcModelID, EmployerID)
	if EmployerID == id() then
		local szName = tNpcName[NpcTemplateID]
		if szName then
			print("-------------------- OnNpcEnter->"..szName, frame())
		end
	end
end

--NPC离开场景
function OnNpcLeave(NpcID, NpcName, NpcTemplateID, NpcModelID, EmployerID)
	if EmployerID == id() then
		local szName = tNpcName[NpcTemplateID]
		if szName then
			print("-------------------- OnNpcLeave->"..szName, frame())
		end
	end
end

--战斗状态改变
function OnFight(bFight)
	if bFight then
		print("--------------------进入战斗")
	else
		--脱战关千枝
		v["关千枝"] = "脱战"

		--副本脱战提醒打坐
		if dungeon() then
			bigtext("记得打坐把蓝回满")
		end
		
		print("--------------------离开战斗")
	end
end
