--[[ 模块: 副本数据记录

使用说明:

-- 主宏开始载入模块
DungeonLog = DungeonLog or load("Lib/副本数据记录.lua")	--用这种方式是为了防止重复加载

-- 如果主宏中实现了同名回调函数, 转发相关事件, 例如
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	
	-------------- 这里是主宏的相关处理

	--调用模块, 参数全部传给模块
	if getopt("记录副本数据") and DungeonLog then
		DungeonLog.OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	end
end

-- 如果主宏中没有实现同名回调，直接把模块的回调函数作为主宏的回调
-- 注意: 这种方式会覆盖主宏的同名函数, 如果主宏中有同名函数，用上面的间接调用
if getopt("记录副本数据") and DungeonLog then
	OnEnterMap = DungeonLog.OnEnterMap
	OnNpcEnter = DungeonLog.OnNpcEnter
	OnNpcLeave = DungeonLog.OnNpcLeave
	OnPrepare = DungeonLog.OnPrepare
	OnChannel = DungeonLog.OnChannel
	OnCast = DungeonLog.OnCast
	OnBuff = DungeonLog.OnBuff
	OnSay = DungeonLog.OnSay
	OnWarning = DungeonLog.OnWarning
	OnFight = DungeonLog.OnFight
end

-- 注意: 模块中定义的所有函数都要在主宏中直接或间接的调用
-- 打完副本后, 在日志窗口中点击右键 另存为 保存到一个文件中, 用于后期分析Boss的技能循环
--]]


-- 不需要记录的技能
local tSkill = {
[28] = "攻击(NPC近战普通外功攻击)",
[6746] = "寂灭(明教_归寂道回血)",
}

--不需要记录的Buff
local tBuff = {
[14321] = "飓风加掌法伤害",
}

-- Boss表
local tBoss = {}

-- Boss召唤的NPC
local tNpc = {}


-- 创建一个表作为模块, 表中的常量、变量、函数作为该模块的接口
local DungeonLog = {}


-- 进入地图
DungeonLog.OnEnterMap = function(MapID, MapName)
	print("------------------------------ 进入地图:"..MapName, MapID)
end

-- NPC出现
DungeonLog.OnNpcEnter = function(NpcID, NpcName, NpcTemplateID, NpcModelID, EmployerID, Intensity)
	if dungeon() then	--在副本内
		if Intensity == 6 and NpcName and #NpcName > 0 then		--是Boss
			tBoss[NpcID] = NpcName
			print("Boss出现->["..NpcName.."]", "模板ID:"..NpcTemplateID, NpcID)
		end
		if tBoss[EmployerID] then	--主人是Boss
			tNpc[NpcID] = NpcName
			print("OnNpcEnter->["..NpcName.."]", NpcID, NpcTemplateID, NpcModelID, EmployerID, Intensity)
		end
	end
end

-- NPC消失
DungeonLog.OnNpcLeave = function(NpcID, NpcName, NpcTemplateID, NpcModelID, EmployerID, Intensity)
	tBoss[NpcID] = nil	--从Boss表移除
	tNpc[NpcID] = nil	--从NPC表中移除
end

-- 开始读条
DungeonLog.OnPrepare = function(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, Frame, StartFrame, FrameCount)
	if tSkill[SkillID] then return end
	local szName = tBoss[CasterID] or tNpc[CasterID]
	if szName then		--是Boss
		local t = {}
		t[#t+1] = "OnPrepare->["..szName.."]"
		t[#t+1] = "技能名:"..SkillName
		t[#t+1] = "技能ID:"..SkillID
		t[#t+1] = "技能等级:"..SkillLevel
		if TargetType == 2 then
			t[#t+1] = "目标:"..TargetID.."|"..PosY.."|"..PosZ
		else
			t[#t+1] = "目标:"..TargetID
		end
		t[#t+1] = "读条帧数:"..Frame
		t[#t+1] = "开始帧:"..StartFrame
		t[#t+1] = "当前帧:"..FrameCount
		print(table.concat(t, ", "))
	end
end

-- 开始引导
DungeonLog.OnChannel = function(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, Frame, StartFrame, FrameCount)
	if tSkill[SkillID] then return end
	local szName = tBoss[CasterID] or tNpc[CasterID]
	if szName then		--是Boss
		local t = {}
		t[#t+1] = "OnChannel->["..szName.."]"
		t[#t+1] = "技能名:"..SkillName
		t[#t+1] = "技能ID:"..SkillID
		t[#t+1] = "技能等级:"..SkillLevel
		if TargetType == 2 then
			t[#t+1] = "目标:"..TargetID.."|"..PosY.."|"..PosZ
		else
			t[#t+1] = "目标:"..TargetID
		end
		t[#t+1] = "引导帧数:"..Frame
		t[#t+1] = "开始帧:"..StartFrame
		t[#t+1] = "当前帧:"..FrameCount
		print(table.concat(t, ", "))
	end
end

-- 释放技能
DungeonLog.OnCast = function(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if tSkill[SkillID] then return end
	local szName = tBoss[CasterID] or tNpc[CasterID]
	if szName then		--是Boss
		local t = {}
		t[#t+1] = "OnCast->["..szName.."]"
		t[#t+1] = "技能名:"..SkillName
		t[#t+1] = "技能ID:"..SkillID
		t[#t+1] = "技能等级:"..SkillLevel
		if TargetType == 2 then
			t[#t+1] = "目标:"..TargetID.."|"..PosY.."|"..PosZ
		else
			t[#t+1] = "目标:"..TargetID
		end
		t[#t+1] = "开始帧:"..StartFrame
		t[#t+1] = "当前帧:"..FrameCount
		print(table.concat(t, ", "))
	end
end

-- Buff更新
DungeonLog.OnBuff = function(CharacterID, BuffName, BuffID, BuffLevel, StackNum, SkillSrcID, StartFrame, EndFrame, FrameCount)
	if StackNum > 0 and SkillSrcID and SkillSrcID ~= 0 then	--是添加, 有源角色
		if tBoss[SkillSrcID] or tNpc[SkillSrcID] then	--是Boss施加的buff
			local t = {}
			t[#t+1] = "OnBuff->buff名:"..BuffName
			t[#t+1] = "buffID:"..BuffID
			t[#t+1] = "buff等级:"..BuffLevel
			t[#t+1] = "buff层数:"..StackNum
			t[#t+1] = "目标:"..CharacterID
			t[#t+1] = "开始帧:"..StartFrame
			t[#t+1] = "结束帧:"..EndFrame
			t[#t+1] = "持续时间:"..(EndFrame - StartFrame) / 16
			print(table.concat(t, ", "))
		end
	end
end

-- Boss喊话
DungeonLog.OnSay = function(Name, SayText, CharacterID)
	if tBoss[CharacterID] then
		print("OnSay->["..Name.."]说:"..SayText)
	end
end

-- 警告信息
DungeonLog.OnWarning = function(szText, szType)
	if dungeon() then
		print("OnWarning->"..szText, szType)
	end
end

-- 战斗状态改变
DungeonLog.OnFight = function(bFight)
	if dungeon() then
		if bFight then
			print("-------------------- 进入战斗")
		else
			print("-------------------- 脱离战斗")
		end
	end
end

-- 返回模块表
return DungeonLog
