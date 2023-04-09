function Main(g_player)
	
end


--开始读条
function OnPrepare(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, Frame, StartFrame, FrameCount)
	if CasterID == id() then
		if TargetType == 2 then
			print("OnPrepareXYZ->["..xname(CasterID).."] 开始读条:"..SkillName..", 技能ID:"..SkillID..", 技能等级:"..SkillLevel..", 目标位置:"..TargetID.."|"..PosY.."|"..PosZ..", 读条帧数:"..Frame..", 开始帧:"..StartFrame..", 当前帧:"..FrameCount)
		else
			print("OnPrepare->["..xname(CasterID).."] 开始读条:"..SkillName..", 技能ID:"..SkillID..", 技能等级:"..SkillLevel..", 目标ID:"..TargetID..", 读条帧数:"..Frame..", 开始帧:"..StartFrame..", 当前帧:"..FrameCount)
		end
	end
end

--开始引导
function OnChannel(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, Frame, StartFrame, FrameCount)
	if CasterID == id() then
		if TargetType == 2 then
			print("OnChannelXYZ->["..xname(CasterID).."] 开始读条:"..SkillName..", 技能ID:"..SkillID..", 技能等级:"..SkillLevel..", 目标位置:"..TargetID.."|"..PosY.."|"..PosZ..", 读条帧数:"..Frame..", 开始帧:"..StartFrame..", 当前帧:"..FrameCount)
		else
			print("OnChannel->["..xname(CasterID).."] 开始读条:"..SkillName..", 技能ID:"..SkillID..", 技能等级:"..SkillLevel..", 目标ID:"..TargetID..", 读条帧数:"..Frame..", 开始帧:"..StartFrame..", 当前帧:"..FrameCount)
		end
	end
end


local tSkill = {
[17] = "打坐",
[13] = "三柴剑法",
[18383] = "藏剑三柴剑法有特效",
[6505] = "唐门_90奇穴_千机变加增益",
[1795] = "四季剑法",
[1797] = "藏剑_内功_技能事件_普通攻击命中回气",
[22423] = "判断是否有3D障碍单一目标",
[2341] = "名动四方_添加剑舞",
[21286] = "删除潜龙勿用图标",
}

--释放技能
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	--过滤掉不重要的技能
	if tSkill[SkillID] then return end

	--输出自己技能释放信息
	if CasterID == id() then
		if TargetType == 2 then
			print("OnCast->["..xname(CasterID).."] 释放:"..SkillName..", 技能ID:"..SkillID..", 技能等级:"..SkillLevel..", 目标位置:"..TargetID.."|"..PosY.."|"..PosZ..", 开始帧:"..StartFrame..", 当前帧:"..FrameCount)
		else
			print("OnCast->["..xname(CasterID).."] 释放:"..SkillName..", 技能ID:"..SkillID..", 技能等级:"..SkillLevel..", 目标ID:"..TargetID..", 开始帧:"..StartFrame..", 当前帧:"..FrameCount)
		end
	end
end

--频繁刷新不重要的buff
local tBuff = {
[103] = "调息",
[23390] = "NPC助战能量buff",
[12740] = "测试(唐门_通用有子弹加会心)",
[12085] = "通用疾速跑",
[24104] = "注视 (多个刀宗注视用)",
[7795] = "副本保护_冲刺标记BUFF",
[1687] = "秀水剑法换动作用隐藏Buff",
[21607] = "灵荆",
[12850] = "驱夜断愁新需求Buff",
[12590] = "每点禅那加攻击",
[6193] = "少林_判禅那",
[6094] = "纯阳_位于气场中判定1",
[6095] = "纯阳_位于气场中判定2",
[6422] = "纯阳_点亮万世不竭",
[8423] = "从容",
[8393] = "刀魂",
[10440] = "长歌临时复活减伤标记BUFF",
[8571] = "心法10%常驻减伤",
[6204] = "少林_洗髓_判血量",
[6004] = "切换奇穴播放特效用",
[6176] = "七秀_判10层剑舞",
[12382] = "剑舞表现",
[21756] = "药宗_飞叶表现",
[15798] = "铁马冰河允许释放标记BUFF",
}

--自己和队友单个buff更新
function OnBuff(CharacterID, BuffName, BuffID, BuffLevel, StackNum, SkillSrcID, StartFrame, EndFrame, FrameCount)
	--过滤掉不重要的buff
	if tBuff[BuffID] then return end

	--输出自己buff信息
	if CharacterID == id() or xname(CharacterID) == "诡鉴冥微" then
		if StackNum  > 0 then
			print("OnBuff->["..xname(CharacterID).."] 添加buff: ".. BuffName..", ID: "..BuffID..", 等级: "..BuffLevel..", 层数: "..StackNum..", 源ID: "..SkillSrcID..", 开始帧: "..StartFrame..", 当前帧: "..FrameCount..", 结束帧: "..EndFrame..", 剩余时间: "..(EndFrame-FrameCount)/16)
		else
			print("OnBuff->["..xname(CharacterID).."] 移除buff: ".. BuffName..", ID: "..BuffID..", 等级: "..BuffLevel..", 层数: "..StackNum..", 源ID: "..SkillSrcID..", 开始帧: "..StartFrame..", 当前帧: "..FrameCount)
		end
	end
end

--NPC进入场景
function OnNpcEnter(NpcID, NpcName, NpcTemplateID, NpcModelID, EmployerID)
	if EmployerID == id() then
		print("OnNpcEnter->"..NpcName..", NPCID: "..NpcID..", 模板ID: "..NpcTemplateID..", 表现ID: "..NpcModelID)
	end
end

--状态更新
function OnStateUpdate(nCurrentLife, nCurrentMana, nCurrentRage, nCurrentEnergy, nCurrentSunEnergy, nCurrentMoonEnergy)
	--print("日灵: "..nCurrentSunEnergy / 100, "月魂: "..nCurrentMoonEnergy / 100)
end

--报警信息
function OnWarning(szText, szType)
	print("OnWarning->"..szText)
end

--气点更新
function OnQidianUpdate()

end

--切换内功
function OnMountKungFu(KungFu, Level)

end

--系统信息
function OnMessage(szMsg, szType)

end

--NPC喊话
function OnSay(szName, szSay, CharacterID, nChannel)

end

--进战脱战
function OnFight(bFight)

end

--更新buff列表
function OnBuffList(CharacterID)

end
