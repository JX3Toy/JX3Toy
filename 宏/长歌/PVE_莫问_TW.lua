--[[
奇穴:[號鍾][飛帆][弦風][流照][豪情][師襄][知止][刻夢][書離][雲漢][參連][正律和鳴]
秘籍:
宫 2读条 1伤害 1会心
商 2会心 2伤害
徵 2会心 2伤害
羽 2会心 2伤害

循环  徵徵羽徵羽 - 高山 - 变宫 - 阳春 - 徵徵羽徵羽
--]]

--关闭自动面向
setglobal("自动面向", false)

--变量表
local v = {}
v["输出信息"] = true
v["变宫目标"] = 0

--函数表
local f = {}

--主循环
function Main(g_player)
	if casting("變宮") and castleft() < 0.13 then
		settimer("变宫读条结束")
	end
	if casting("徵|變徵") and castleft() < 0.13 then
		settimer("徵读条结束")
	end

	--初始化变量
	v["曲风层数"] = buffsn("24327")
	v["影子数量"] = 0
	for i = 3, 8 do
		if buff("999"..i) then
			v["影子数量"] = v["影子数量"] + 1
		end
	end
	v["目标商时间"] = tbufftime("商", id())
	v["目标角时间"] = tbufftime("角", id())
	v["正律CD"] = scdtime("正律和鳴")
	v["孤影CD"] = cdtime(14081)	--和回影子重名, 用ID
	v["目标血量较多"] = rela("敌对") and tlifevalue() > lifemax() * 5	--小怪不想开爆发，改这个系数

	--孤影回
	f["孤影化双回"]()

	--横影
	f["疏影横斜"]()

	--等待曲风buff同步, 读条结束buff没同步，曲风层数判断有问题
	if gettimer("变宫读条结束") < 0.5 then
		--print("---------等待曲风层数同步")
		return
	end
	if gettimer("阳春白雪") < 0.5 or gettimer("高山流水") < 0.5 then
		print("---------等待切换曲风")
		return
	end

	--起手高山
	if nofight() and v["曲风层数"] == 0 and v["正律CD"] <= 0 and nobuff("高山流水") then
		f["高山流水"]()
	end

	--没进战，平A
	if nofight() then
		CastX("五音六律")
	end

	--徵读条 + 羽 + 变宫读条 时间
	local nTime = casttime("徵") + cdinterval(16) + casttime("變宮") + 0.5

	--------------------阳春白雪--------------------
	if buff("9320") then
		if v["曲风层数"] == 0 then
			if v["目标商时间"] < nTime or v["目标角时间"] < nTime then
				f["高山流水"]()
			end
		end

		if v["曲风层数"] == 0 or v["曲风层数"] == 4 then
			if CastX("徵") then
				settimer("徵")
			end
		end

		if v["曲风层数"] == 0 or v["曲风层数"] == 5 then
			CastX("羽")
		end
	end

	--------------------高山流水--------------------
	if buff("9319") then
		--合奏
		if buff("正律和鳴") then
			f["正律合奏"]()
			return
		end

		--进入正律合奏
		if fight() and v["目标血量较多"] and dis() < 20 and nobuff("正律和鳴|知音妙意") then
			if cdtime("正律和鳴") < 0.5 then
				f["孤影化双"]()
				if v["孤影CD"] > 1 then
					f["高山流水主动"]()
				end
				if v["孤影CD"] > 1 and scdtime(14229) > 1 then 
					if CastX("正律和鳴") then
						settimer("正律和鸣")
					end
				end
				return
			end
		end

		--切换阳春
		if v["目标商时间"] > nTime and v["目标角时间"] > nTime then
			if gettimer("正律和鸣") > 0.5 and gettimer("孤影化双") > 0.5 then
				if v["曲风层数"] == 0 or v["曲风层数"] == 4 or v["曲风层数"] == 5 then
					f["阳春白雪"]()
				end
			end
		end

		if v["变宫目标"] ~= 0 and v["变宫目标"] == tid() then
			--print("----------变宫后等待目标buff刷新")
			return
		end
		
		if fight() and gettimer("孤影化双") > 0.5 then
			--if v["目标商时间"] <= casttime("變宮") or v["曲风层数"] == 2 or v["曲风层数"] == 6 then
			if v["目标商时间"] <= casttime("變宮") or v["曲风层数"] == 2 then
				CastX("商")
			end

			--if v["目标角时间"] <= casttime("變宮") or v["曲风层数"] == 3 or v["曲风层数"] == 7 then
			if v["目标角时间"] <= casttime("變宮") or v["曲风层数"] == 3 then
				CastX("角")
			end

			if v["曲风层数"] == 0 or v["曲风层数"] >= 5 then	--大于5都用变宫修正
				if CastX("變宮") then
					settimer("变宫")
				end
			end
			
			if v["曲风层数"] == 4 then
				CastX("羽")
			end
		end
	end

	f["没放技能"]()
end

--不放技能输出信息，可能哪里有问题
f["没放技能"] = function()
	if fight() and rela("敌对") and dis() < 20 and face() < 90 and cdleft(16) <= 0 and castleft() <= 0 and gettimer("变宫") > 0.5 and gettimer("徵") > 0.5 and gettimer("徵读条结束") > 0.5 and state("站立") then
		PrintInfo("----------没打技能, ")
	end
end

f["正律合奏"] = function()
	if v["曲风层数"] == 6 then
		CastX("商")
	end
	if v["曲风层数"] == 5 then
		if CastX("變宮") then
			settimer("变宫")
		end
	end
	if v["曲风层数"] == 4 then
		if buffsn("知音和鳴") == 4 then	--最后一次合奏
			f["阳春白雪"]()
		else
			CastX("羽")
		end
	end
	if v["曲风层数"] == 3 then
		if CastX("變徵") then
			settimer("徵")
		end
	end
	if v["曲风层数"] == 2 then
		CastX("角")
	end

	f["没放技能"]()
end

f["阳春白雪"] = function()
	if CastX(14070) then
		settimer("阳春白雪")
		exit()
	end
end

f["高山流水"] = function()
	if CastX(14069) then
		settimer("高山流水")
		exit()
	end
end

f["高山流水主动"] = function()
	cast(14229)
end

f["孤影化双"] = function()
	if cast(14081) then
		settimer("孤影化双")
	end
end

f["孤影化双回"] = function()
	if casting("徵|變徵") and bufftime("孤影化雙") < 0.5 then	--徵读条中时间快到了，打断
		fcast(14162)
		return
	end
	if bufftime("孤影化雙") <= casttime("變宮") then	--小于一个变宫读条
		cast(14162)
		return
	end
	if scdtime(14229) > 1 and v["正律CD"] > 1 then		--高山主动和正律用过了
		if v["影子数量"] >= 6 or cn("疏影橫斜") < 1 then	--影子满了或疏影横斜用完了
			cast(14162)
		end
	end
end

f["疏影横斜"] = function()
	if v["影子数量"] < 6 then
		if buff("正律和鳴|孤影化雙") then
			cast("疏影橫斜")
		end
	end
end

--输出信息
function PrintInfo(s)
	local szinfo = "曲风层数:"..v["曲风层数"]..", 目标商:"..v["目标商时间"]..", 目标角:"..v["目标角时间"]..", 横影充能:"..cn("疏影橫斜")..", "..cntime("疏影橫斜", true)..", 徵充能:"..cn("徵")..", 羽充能"..cn("羽")..", 正律CD:"..v["正律CD"]
	if s then
		szinfo = s..szinfo
	end
	print(szinfo)
end

--使用技能
function CastX(szSkill)
	if cast(szSkill) then
		if v["输出信息"] then
			PrintInfo()
		end
		return true
	end
	return false
end

--释放技能回调
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		if SkillID == 14298 then	--变宫
			v["变宫目标"] = TargetID	--记录目标ID
			return
		end
		if SkillID == 34676 then	--知音兴尽, 输出看看等级，21级伤害最高
			print("OnCast->释放:"..SkillName..", 技能ID:"..SkillID..", 技能等级:"..SkillLevel..", 目标ID:"..TargetID..", 开始帧:"..StartFrame..", 当前帧:"..FrameCount)
			return
		end
	end
end

--用于输出指定buff的添加移除情况
local tBuff = {
--[24247] = "原名",	--弦风
--[24754] = "原名",	--流照
--[24327] = "曲风",
--[9495] = "原名",	--书离
--[12576] = "云汉",
--[9430] = "阳春白雪主动需求",
}

--buff更新回调
function OnBuff(CharacterID, BuffName, BuffID, BuffLevel, StackNum, SkillSrcID, StartFrame, EndFrame, FrameCount)
	if CharacterID == id() then
		--[[
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
		--]]
		if StackNum  > 0 then
			if BuffID == 9319 then
				deltimer("高山流水")
				return
			end
			if BuffID == 9320 then
				deltimer("阳春白雪")
				return
			end
			if BuffID == 24327 then	--曲风
				deltimer("变宫读条结束")
				return
			end
		end
	end
end

--更新buff列表回调
function OnBuffList(CharacterID)
	if CharacterID == v["变宫目标"] then
		v["变宫目标"] = 0
	end
end

--战斗状态回调
function OnFight(bFight)
	if bFight then
		print("--------------------进入战斗")
	else
		print("--------------------离开战斗")
	end
end

--[[
	阳	高
徵	5	6
羽	4	5
宫	3	4
商	2	3
角	1	2
--]]
