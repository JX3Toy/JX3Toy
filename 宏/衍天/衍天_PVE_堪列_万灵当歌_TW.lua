--[[ 奇穴: [水盈][天網][順祝][列宿遊][重山][堪卜][亙天][連斷][熒入白][徵凶][焚如][增卜]
秘籍:
三星临		1会心 3伤害
兵主逆		1会心 3伤害
天斗旋		1调息 1会心 2伤害
起卦		2调息 1消耗 1效果
变卦		1调息 3减星运
奇门飞宫	2调息 2距离
返闭惊魂	2调息 1消耗 1效果(灯延长10秒, 必须)
--]]

--关闭自动面向
setglobal("自动面向", false)

--宏选项
addopt("副本防开怪", false)

--变量表
local v = {}
v["记录信息"] = true
v["兵主逆延长卦象次数"] = 0

--函数表
local f = {}

--主循环
function Main(g_player)
	--按下自定义快捷键1挂扶摇, 注意是快捷键设定里面插件的快捷键1指定的按键，不是键盘上的1
	if keydown(1) then
		cast("扶摇直上")
	end

	--等待兵主逆开始引导, 兵主逆的子技能才是引导技能, 本身瞬发不引导
	if gettimer("兵主逆") < 0.3 then return end

	--减伤
	if fight() and life() < 0.6 then
		cast("巨門北落")
	end

	--初始化变量
	v["星运"] = rage()

	v["灯数量"] = 0
	for i = 1, 3 do
		v["灯"..i.."时间"] = bufftime("1774"..i + 2)	--17743 17744 17745
		if v["灯"..i.."时间"] >= 0 then
			v["灯数量"] = v["灯数量"] + 1
		end
	end
	v["有连局"] = buff("18231")
	v["连局时间"] = math.min(v["灯1时间"], v["灯2时间"], v["灯3时间"])	--最短灯时间就是连局剩余时间

	local tDeng = { 99569, 100085, 100086 }		--灯123 模板ID
	for i, nID in ipairs(tDeng) do			--获取灯强化层数
		v["灯"..i.."层数"] = 0
		local deng = npc("关系:自己", "模板ID:"..nID)
		if deng ~= 0 then
			v["灯"..i.."层数"] = xbuffsn("24480", deng)
		end
	end

	v["卦象"] = "无卦"
	v["卦象时间"] = -100
	local tGX = { "水坎", "山艮", "火離" }
	for i, szBuff in ipairs(tGX) do
		v[szBuff.."时间"] = bufftime(szBuff)
		if v[szBuff.."时间"] >= 0 then
			v["卦象"] = szBuff
			v["卦象时间"] = v[szBuff.."时间"]
		end
	end
	v["荧入白时间"] = bufftime("熒入白")	--兵每跳延长 卦象 主动 变卦 荧入白
	v["目标火离时间"] = tbufftime("17605", id())
	v["目标增卜层数"] = tbuffsn("增卜", id())
	v["目标增卜时间"] = tbufftime("增卜", id())
	v["斗破招计数"] = buffsn("24457")	--最大5层

	v["起卦CD"] = scdtime("起卦")
	v["变卦充能次数"] = cn("變卦")
	v["变卦充能时间"] = cntime("變卦", true)
	v["兵主逆CD"] = scdtime("兵主逆")
	v["天斗旋充能次数"] = cn("天鬥旋")
	v["天斗旋充能时间"] = cntime("天鬥旋", true)
	v["返闭CD"] = scdtime("返閉驚魂")

	local tSpeedXY, tSpeedZ = speed(tid())
	v["目标静止"] = rela("敌对") and tSpeedXY <= 0 and tSpeedZ <= 0

	--目标不是敌人, 直接结束
	if not rela("敌对") then return end

	--副本防开怪
	if getopt("副本防开怪") and dungeon() and nofight() then return end

	f["处理灯"]()

	--平A进战
	if nofight() then
		CastX("魂擊")
		return
	end

	f["处理卦象"]()
	f["九字诀"]()
	

	--if fight() and rela("敌对") and dis() < 20 and face() < 90 and cdleft(16) <= 0 and castleft() <= 0 and gettimer("天鬥旋") > 0.3 and state("站立|走路|跑步|跳躍") then
	--	PrintInfo("----------没打技能")
	--end
end

-------------------------------------------------------------------------------

f["处理灯"] = function()
	--放灯
	if v["灯数量"] < 3 then
		if v["灯数量"] < 2 or gettimer("返閉驚魂") > 0.3 then
			CastX("奇門飛宮")
		end
		if v["灯数量"] < 2 or gettimer("奇門飛宮") > 0.3 then
			CastX("返閉驚魂")
		end
	end

	--重置过放新灯
	if buff("24656") and gettimer("奇門飛宮") > 0.3 and gettimer("奇門飛宮") > 0.3 and gettimer("生成魂灯") > 5 then
		CastX("奇門飛宮")
	end

	--返闭续时间
	if v["灯数量"] >= 3 and v["连局时间"] < 2 then
		if nobuff("24656") and gettimer("列宿遊") >= 0.5 and v["灯1层数"] >= 3 and v["灯2层数"] >= 3 and v["灯3层数"] >= 3 then
			CastX("返閉驚魂")
		end
	end

	--移灯
	if v["目标静止"] and dis() < 20 and gettimer("奇門飛宮") > 0.3 and gettimer("生成魂灯") > 0.3 then
		if tnpc("关系:自己", "模板ID:99569|100085|100086", "平面距离<5") == 0 then	--目标5尺内没有自己的灯
			local tSkillID = { 24858, 24859, 24860 }	--灯123对应的纵横三才技能ID
			local nIndex = 0
			local nTime = 0
			for i = 1, 3 do
				if v["灯"..i.."时间"] > nTime then	--剩余时间最长的灯
					nTime = v["灯"..i.."时间"]
					nIndex = i
				end
			end
			if nTime > 5 then
				cast(tSkillID[nIndex])
			end
		end
	end
end

f["处理卦象"] = function()
	
	--卦象同步
	if gettimer("起卦") < 0.3 or gettimer("變卦") < 0.3 or gettimer("祝由·火離") < 0.3 then
		print("----------等待卦象同步")
		return
	end

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
				CastX("祝由·火離")
			end
		end
		
		--放过主动变卦
		if nobuff("17825") and v["起卦CD"] > 7.5 then
			v["需要变卦"] = "火变山, 放过主动"
		end
	end

	if v["需要变卦"] and gettimer("起卦") >= 0.5 and gettimer("释放起卦") > 3 then
		if CastX("變卦") then
			print(v["需要变卦"])
			exit()
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
			exit()
		end
	end
end

f["九字诀"] = function()
	--马上重置把斗打完
	if v["灯1层数"] >= 4 and v["灯2层数"] >= 4 and v["灯3层数"] >= 4 and v["连局时间"] > 3.5 then
		CastX("天鬥旋")
		CastX("列宿遊")
	end

	if v["星运"] >= 70 or not v["需要变卦"] then
		if v["灯数量"] >= 3 or cn("奇門飛宮") < 1 then
			CastX("列宿遊")
		end
	end

	if v["斗破招计数"] > 0 then
		CastX("天鬥旋")
	end

	if v["天斗旋充能时间"] < 3.5 then
		CastX("天鬥旋")
	end

	if v["灯数量"] < 3 or v["连局时间"] > 5 then
		CastX("兵主逆")
	end

	CastX("天鬥旋")

	CastX("三星臨")
end

-------------------------------------------------------------------------------

--记录信息
function PrintInfo(s)
	local t = {}
	if s then t[#t+1] = s end
	t[#t+1] = "星运:"..v["星运"]
	t[#t+1] = "灯数量:"..v["灯数量"]
	t[#t+1] = "连局时间:"..v["连局时间"]
	t[#t+1] = "灯强化:"..v["灯1层数"]..", "..v["灯2层数"]..", "..v["灯3层数"]
	t[#t+1] = "卦象:"..v["卦象"]..", "..v["卦象时间"]
	t[#t+1] = "荧入白:"..v["荧入白时间"]
	t[#t+1] = "火离:"..v["目标火离时间"]
	t[#t+1] = "增卜:"..v["目标增卜层数"]..", "..v["目标增卜时间"]
	t[#t+1] = "斗破招:"..v["斗破招计数"]
	t[#t+1] = "起卦CD:"..v["起卦CD"]
	t[#t+1] = "变卦CD:"..v["变卦充能次数"]..", "..v["变卦充能时间"]
	t[#t+1] = "兵主逆CD:"..v["兵主逆CD"]
	t[#t+1] = "天斗旋CD:"..v["天斗旋充能次数"]..", "..v["天斗旋充能时间"]
	t[#t+1] = "返闭CD:"..v["返闭CD"]

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
		if SkillID == 24409 or SkillID == 24410 or SkillID == 24744 or SkillID == 24745 then	--兵主逆引导子技能, 无卦和3种卦象
			deltimer("兵主逆")
		end
	end
end

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
				settimer("生成魂灯")
				deltimer("奇門飛宮")
				deltimer("返閉驚魂")
			end

			if BuffID == 24656 then
				print("------------------------------ 分隔线, 列宿游重置")
			end
		else
			if BuffID == 17825 then	--火主动buff
				deltimer("祝由·火離")
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
