--[[ 奇穴: [渊壑][扶桑][羽彰][清源][海碧][风驰][惊潮][怅归][溯徊][驰行][梦悠][濯流]
秘籍:
击水 1会心 3伤害
木落 1会心 3伤害
定波 2调息 2消耗
翼绝 1会心 3伤害
振翅 1会心 2伤害 1效果
跃潮 2调息 2消耗
浮游 3会心 1效果
物化 3效果 1距离
海运 2会心 2伤害
-]]

--宏选项
addopt("副本防开怪", false)

--变量表
local v = {}
v["输出信息"] = true

--主循环
function Main(g_player)
	if casting("定波砥澜") and castleft() < 0.13 then
		settimer("定波读条结束")
	end
	
	--初始化变量
	v["跃潮CD"] = scdtime("跃潮斩波")
	v["海运CD"] = scdtime("海运南冥")
	v["溟海CD"] = scdtime("溟海御波")
	v["逐波CD"] = scdtime("逐波灵游")
	v["浮游CD"] = scdtime("浮游天地")
	v["木落CD"] = scdtime("木落雁归")
	local tSpeedXY, tSpeedZ = speed(tid())
	v["目标静止"] = rela("敌对") and tSpeedXY <= 0 and tSpeedZ <= 0
	v["浮游"] = buff("13475") and gettimer("释放落地") > 0.5
	v["物化"] = buff("13781")
	v["驰风震域时间"] = bufftime("24192")
	v["海碧层数"] = buffsn("24229")

	--目标不是敌对结束
	if not rela("敌对") then return end
	--副本防开怪
	if getopt("副本防开怪") and dungeon() and nofight() then return end

	cast("振翅图南")
	cast("翼绝云天")

	if gettimer("等待浮游同步") < 0.5 or gettimer("等待物化同步") < 0.5 then
		--print("----------等待buff同步")
		return
	end

	-------------------------------------------------------天上
	if v["浮游"] then		--浮游
		v["落地"] = false
		if v["海运CD"] > 1 and v["溟海CD"] > 1 and v["逐波CD"] > 1 then	--掌法打完了落地
			v["落地"] = true
		end
		--正常情况下5秒内4个技能打完, 先注释掉，手动看情况处理
		--if settimer("释放浮游") > 5 then
		--	v["落地"] = true
		--end

		if v["落地"] then
			if CastX("浮游天地·落地") then
				settimer("等待浮游同步")
				return
			end
		end

		if v["物化"] then
			if dis3() <= 4 then
				CastX("海运南冥")
			end
			if v["海运CD"] > 0.5 then
				CastX("溟海御波")
				CastX("逐波灵游")
			end
		else
			if CastX("物化天行") then
				settimer("等待物化同步")
				return
			end
		end

	-------------------------------------------------------地面
	else
		v["自己6尺有驰风"] = npc("关系:自己", "模板ID:64696", "角色距离<6") ~= 0
		v["目标6尺有驰风"] = xnpc(tid(), "关系:自己", "模板ID:64696", "平面距离<6") ~= 0

		--浮游
		if dis() < 6 and v["自己6尺有驰风"] and v["驰风震域时间"] > 0 and v["海运CD"] < 2 then
			if CastX("浮游天地") then
				settimer("等待浮游同步")
				return
			end
		end

		--定波快充能结束
		if cntime("定波砥澜", true) < cdinterval(16) then
			if gettimer("定波读条结束") > 0.5 and v["目标静止"] and dis() < 5 then
				if CastX("定波砥澜") then
					settimer("定波砥澜")
				end
			end
		end

		--跃潮
		if gettimer("定波读条结束") > 0.5 then
			CastX("跃潮斩波")
		end

		--海运
		if v["浮游CD"] > 3 then
			if dis3() <= 4 then
				CastX("海运南冥")
			end
		end

		--木落
		CastX("木落雁归")

		--溟海
		if v["浮游CD"] > 2.1875 then
			CastX("溟海御波")
		end

		--定波
		if gettimer("定波读条结束") > 0.5 and v["目标静止"] and dis() < 5 then
			if CastX("定波砥澜") then
				settimer("定波砥澜")
			end
		end
		
		--击水
		if dis() < 6 and face() < 60 then
			CastX("击水三千")
		end
	end

	if fight() and rela("敌对") and dis() < 20 and cdleft(16) <= 0 and castleft() <= 0 and cdleft(1424) <= 0 and gettimer("定波砥澜") > 0.3 and state("站立|轻功") then
		PrintInfo("----------没打技能, ")
	end
end

--输出信息
function PrintInfo(s)
	local szinfo = "木落CD:"..v["木落CD"]..", 定波CD:"..cn("定波砥澜")..", "..cntime("定波砥澜", true)..", 跃潮CD:"..v["跃潮CD"]..", 海运CD:"..v["海运CD"]..", 溟海CD:"..scdtime("溟海御波")..", 逐波CD:"..v["逐波CD"]..", 浮游CD:"..v["浮游CD"]..", 物化CD:"..cn("物化天行")..", "..cntime("物化天行", true)..", 驰风震域时间:"..v["驰风震域时间"]..", 海碧层数:"..v["海碧层数"]
	if s then
		szinfo = s..szinfo
	end
	print(szinfo)
end

--使用技能并输出信息
function CastX(szSkill)
	if cast(szSkill) then
		if v["输出信息"] then
			PrintInfo()
		end
		return true
	end
	return false
end

--释放技能
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		if SkillID == 20944 then
			settimer("释放落地")
			return
		end
		if SkillID == 19828 then
			settimer("释放浮游")
			return
		end
	end
end

local tBuff = {
[14083] = "原名",	--太息
[13475] = "原名",	--浮游
[13781] = "物化",
}

--buff更新
function OnBuff(CharacterID, BuffName, BuffID, BuffLevel, StackNum, SkillSrcID, StartFrame, EndFrame, FrameCount)
	if CharacterID == id() then
		if BuffID == 13475 then
			deltimer("等待浮游同步")
		elseif BuffID == 13781 then
			deltimer("等待物化同步")
		end
		
		--[[输出buff增删信息
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
	end
end

--战斗状态改变
function OnFight(bFight)
	if not bFight then
		print("--------------------离开战斗")
	end
end
