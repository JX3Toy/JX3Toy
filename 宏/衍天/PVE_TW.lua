--[[ 奇穴: [水盈][天網][順祝][列宿遊][重山][堪卜][亙天][連斷][熒入白][徵凶][焚如][增卜]
秘籍:
三星临		1会心 3伤害
兵主逆		1会心 3伤害
天斗旋		1调息 1会心 2伤害
起卦		2调息 1效果
变卦		2调息 2效果
奇门飞宫	1调息 2距离 1效果
返闭惊魂	2调息 1效果(必须)
--]]

--关闭自动面向
setglobal("自动面向", false)

--变量表
local v = {}
v["输出信息"] = true
v["兵主逆延长卦象次数"] = 0

--主循环
function Main(g_player)
	--等待兵主逆开始引导, 兵主逆的子技能才是引导技能, 本身瞬发不引导
	if gettimer("兵主逆") < 0.3 then print("----------等待兵开始引导") return end

	--减伤
	if fight() and life() < 0.6 then
		cast("巨門北落")
	end

	---------------------------------------------初始化变量
	v["星运"] = rage()
	v["兵主逆CD"] = scdtime("兵主逆")
	v["斗破招计数"] = buffsn("24457")
	v["天斗旋充能次数"] = cn("天鬥旋")
	v["天斗旋充能时间"] = cntime("天鬥旋", true)

	v["灯1时间"] = bufftime("17743")
	v["灯2时间"] = bufftime("17744")
	v["灯3时间"] = bufftime("17745")
	v["有连局"] = buff("18231")
	v["连局时间"] = math.min(v["灯1时间"], v["灯2时间"], v["灯3时间"])	--最短灯时间就是连局剩余时间
	v["灯数量"] = 0
	for i = 1, 3 do
		if v["灯"..i.."时间"] >= 0 then
			v["灯数量"] = v["灯数量"] + 1
		end
	end
	local tDeng = { 99569, 100085, 100086 }
	for i, nID in ipairs(tDeng) do			--获取灯强化层数
		v["灯"..i.."层数"] = 0
		local deng = npc("关系:自己", "模板ID:"..nID)
		if deng ~= 0 then
			v["灯"..i.."层数"] = xbuffsn("24480", deng)
		end
	end
	v["返闭CD"] = scdtime("返閉驚魂")

	v["荧入白时间"] = bufftime("熒入白")	--兵每跳延长 卦象 主动 变卦 荧入白
	v["卦象"] = "无卦"
	v["卦象时间"] = -100
	local tGX = { "水坎", "山艮", "火離" }
	for i, szBuff in ipairs(tGX) do
		local nTime = bufftime(szBuff)
		v[szBuff.."时间"] = nTime
		if nTime >= 0 then
			v["卦象"] = szBuff
			v["卦象时间"] = nTime
		end
	end
	v["目标火离时间"] = tbufftime("17605", id())
	v["目标增卜层数"] = tbuffsn("增卜", id())
	v["目标增卜时间"] = tbufftime("增卜", id())
	v["起卦CD"] = scdtime("起卦")
	v["变卦充能次数"] = cn("變卦")
	v["变卦充能时间"] = cntime("變卦", true)

	local tSpeedXY, tSpeedZ = speed(tid())
	v["目标静止"] = rela("敌对") and tSpeedXY <= 0 and tSpeedZ <= 0

	---------------------------------------------等待buff同步
	if gettimer("奇門飛宮") < 0.3 or gettimer("返閉驚魂") < 0.3 then
		print("----------等待灯同步")
		return
	end
	if gettimer("起卦") < 0.3 or gettimer("變卦") < 0.3 or gettimer("祝由·火離") < 0.3 then
		print("----------等待卦象同步")
		return
	end

	---------------------------------------------处理灯
	--小于3个放灯
	if rela("敌对") and v["灯数量"] < 3 then
		if CastX("奇門飛宮") then return end
	end

	--重置过放新灯
	if rela("敌对") and buff("24656") and gettimer("奇門飛宮") >= 0.5 and gettimer("释放奇门飞宫") > 4 then
		if CastX("奇門飛宮") then return end
	end

	--返闭放灯
	if rela("敌对") and dis() < 20 and v["灯数量"] < 3 then
		if CastX("返閉驚魂") then return end
	end
	
	--返闭续时间
	if v["灯数量"] >= 3 and v["连局时间"] < 3.5 then
		if nobuff("24656") and gettimer("列宿遊") >= 0.5 and v["灯1层数"] >= 3 and v["灯2层数"] >= 3 and v["灯3层数"] >= 3 then
			if CastX("返閉驚魂") then return end
		end
	end

	--移灯
	if v["目标静止"] and dis() < 20 and gettimer("奇門飛宮") >= 0.5 then
		if v["灯数量"] >= 3 or cn("奇門飛宮") < 1 then	--有3个灯或者放不出灯
			if tnpc("关系:自己", "模板ID:99569|100085|100086", "平面距离<5") == 0 then	--目标5尺内没有自己的灯
				for i = 1, 3 do
					if v["灯"..i.."时间"] > 0 then
						if cast(24857 + i) then
							break
						end
					end
				end
			end
		end
	end

	---------------------------------------------平A进战
	if nofight() then
		CastX("魂擊")
		return
	end

	---------------------------------------------处理卦象
	v["目标没火离"] = false
	if rela("敌对") and dis() < 25 and v["目标火离时间"] < 0 and gettimer("祝由·火離") >= 0.5 then
		v["目标没火离"] = true
	end

	--变卦
	v["需要变卦"] = false

	--水
	if v["水坎时间"] >= 0 then
		if gettimer("祝由·水坎") > 0.3 then
			CastX("祝由·水坎", true)	--主动给自己
		end
		v["需要变卦"] = "水变火"
	end
	
	--山
	if v["山艮时间"] >= 0 then
		if gettimer("祝由·山艮") > 0.3 then
			CastX("祝由·山艮")
		end

		if v["目标没火离"] then
			v["需要变卦"] = "山变火上dot"
		end
	end

	--火
	if v["火離时间"] >= 0 then
		--放主动
		if gettimer("祝由·火離") > 0.3 then
			local bCast = false
			if v["目标火离时间"] < 0 then	--目标没火离
				bCast = true
			end
			if v["起卦CD"] < 0.25 then		---起卦马上好
				bCast = true
			end
			if v["起卦CD"] > 8 and v["变卦充能次数"] > 0 then	--能变山
				bCast = true
			end
			if bCast then
				if CastX("祝由·火離") then return end
			end
		end
		
		--放过主动变卦
		if nobuff("17825") and v["起卦CD"] > 7.5 then
			v["需要变卦"] = "火变山, 放过主动"
		end
	end

	if v["需要变卦"] and gettimer("起卦") > 0.5 and gettimer("释放起卦") > 3 then
		if CastX("變卦") then
			print(v["需要变卦"])
			return
		end
	end

	--起卦
	v["需要起卦"] = false

	if fight() then
		if v["斗破招计数"] < 1 then
			v["需要起卦"] = "破招层数小于1"
		elseif v["水坎时间"] >= 0 then
			v["需要起卦"] = "水卦直接起"
		elseif v["火離时间"] >= 0 and nobuff("17825") then
			v["需要起卦"] = "火卦主动打过了"
		elseif rela("敌对") and v["目标火离时间"] < 3 then
			v["需要起卦"] = "目标火离小于3秒"
		end
	end

	if v["需要起卦"] then
		if CastX("起卦") then
			print(v["需要起卦"])
			return
		end
	end

	---------------------------------------------九字诀

	--马上重置把斗打完
	if v["灯1层数"] >= 4 and v["灯2层数"] >= 4 and v["灯3层数"] >= 4 and v["连局时间"] > 3.5 then
		CastX("天鬥旋")
		CastX("列宿遊")
	end

	if v["星运"] >= 70 then
		if v["灯数量"] >= 3 or cn("奇門飛宮") < 1 then
			CastX("列宿遊")
		end
	end

	if v["天斗旋充能时间"] < 3.5 then
		CastX("天鬥旋")
	end

	--兵延长卦象
	if v["兵主逆延长卦象次数"] < 3 and (nobuff("17825") or v["目标火离时间"] > 3) then
		if (v["山艮时间"] > 0.5 and v["山艮时间"] < v["起卦CD"] + 3) or (v["荧入白时间"] < v["起卦CD"] + 3) then
			if CastX("兵主逆") then
				print("----------兵延长卦象")
				return
			end
		end
	end

	--兵打增卜层数
	if v["目标火离时间"] > 3.5 and v["目标增卜层数"] < 10 then
		if CastX("兵主逆") then
			print("----------兵打增卜层数")
			return
		end
	end

	if v["斗破招计数"] > 0 then
		CastX("天鬥旋")
	end

	CastX("三星臨")

	--if fight() and rela("敌对") and dis() < 20 and face() < 90 and cdleft(16) <= 0 and castleft() <= 0 and gettimer("天鬥旋") > 0.3 and state("站立|走路|跑步|跳躍") then
	--	PrintInfo("----------没打技能, ")
	--end
end

--输出信息
function PrintInfo(s)
	local szinfo = "星运:"..v["星运"]..", 斗破招:"..v["斗破招计数"]..", 兵主逆CD:"..v["兵主逆CD"]..", 天斗旋CD:"..v["天斗旋充能次数"]..", "..v["天斗旋充能时间"]..", 荧入白:"..v["荧入白时间"]..", 卦象:"..v["卦象"]..", "..v["卦象时间"]..", 火离:"..v["目标火离时间"]..", 增卜:"..v["目标增卜层数"]..", "..v["目标增卜时间"]..", 起卦:"..v["起卦CD"]..", 变卦:"..v["变卦充能次数"]..", "..v["变卦充能时间"]..", 灯:"..v["灯数量"]..", "..v["连局时间"]..", 灯强化:"..v["灯1层数"]..", "..v["灯2层数"]..", "..v["灯3层数"]..", 返闭CD:"..v["返闭CD"]
	if s then
		szinfo = s..szinfo
	end
	print(szinfo)
end

--使用技能并输出信息
function CastX(szSkill, bSelf)
	if cast(szSkill, bSelf) then
		settimer(szSkill)
		if v["输出信息"] then PrintInfo() end
		return true
	end
	return false
end

--技能释放
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		if SkillID == 24831 then	--水
			settimer("起卦_水坎")
			print("----------起卦_水坎")
			return
		end
		if SkillID == 24832 then	--山
			settimer("起卦_山艮")
			print("----------起卦_山艮")
			return
		end
		if SkillID == 24833 then	--火
			settimer("起卦_火离")
			print("----------起卦_火离")
			return
		end
		if SkillID == 24375 then	--起卦
			deltimer("起卦")
			settimer("释放起卦")
			return
		end
		if SkillID == 24378 then	--放灯
			settimer("释放奇门飞宫")
			return
		end
		if SkillID == 32791 then	--列宿游
			deltimer("列宿遊")
			return
		end
		if SkillID == 24410 or SkillID == 24744 or SkillID == 24745 then 	--兵主逆 水 山 火
			v["兵主逆延长卦象次数"] = v["兵主逆延长卦象次数"] + 1
			return
		end
	end
end

--开始引导
function OnChannel(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, Frame, StartFrame, FrameCount)
	if CasterID == id() then
		if SkillID == 24409 or SkillID == 24410 or SkillID == 24744 or SkillID == 24745 then	--兵主逆引导子技能
			deltimer("兵主逆")
		end
	end
end

local tBuff = {
[24656] = "列重置过标记",
}

--buff更新
function OnBuff(CharacterID, BuffName, BuffID, BuffLevel, StackNum, SkillSrcID, StartFrame, EndFrame, FrameCount)
	if CharacterID == id() then
		if StackNum  > 0 then
			if BuffID == 17588 or BuffID == 17801 or BuffID == 17802 then	--3个卦象buff
				deltimer("起卦_水坎")
				deltimer("起卦_山艮")
				deltimer("起卦_火离")
				deltimer("變卦")
				deltimer("释放起卦")
				v["兵主逆延长卦象次数"] = 0
			end
			if BuffID == 17743 or BuffID == 17744 or BuffID == 17745 then	--3个灯buff
				deltimer("奇門飛宮")
				deltimer("返閉驚魂")
			end
		else
			if BuffID == 17825 then	--火主动buff
				deltimer("祝由·火離")
			end
		end

		--输出buff增删信息
		local szName = tBuff[BuffID]
		if szName then
			if szName ~= "原名" then
				BuffName = szName
			end
			if StackNum  > 0 then
				print("OnBuff->添加buff: ".. BuffName..", ID: "..BuffID..", 等级: "..BuffLevel..", 层数: "..StackNum..", 源ID: "..SkillSrcID..", 开始帧: "..StartFrame..", 当前帧: "..FrameCount..", 结束帧: "..EndFrame..", 剩余时间: "..(EndFrame-FrameCount)/16)
			else
				print("OnBuff->移除buff: ".. BuffName..", ID: "..BuffID..", 等级: "..BuffLevel..", 层数: "..StackNum..", 源ID: "..SkillSrcID..", 开始帧: "..StartFrame..", 当前帧: "..FrameCount)
			end
		end
	end
end

--战斗状态改变
function OnFight(bFight)
	if bFight then
		print("--------------------进入战斗")
	else
		print("--------------------离开战斗")
	end
end
