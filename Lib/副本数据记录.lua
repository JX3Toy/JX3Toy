--[[ ģ��: �������ݼ�¼

ʹ��˵��:

-- ���꿪ʼ����ģ��
DungeonLog = DungeonLog or load("Lib/�������ݼ�¼.lua")	--�����ַ�ʽ��Ϊ�˷�ֹ�ظ�����

-- ���������ʵ����ͬ���ص�����, ת������¼�, ����
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	
	-------------- �������������ش���

	--����ģ��, ����ȫ������ģ��
	if getopt("��¼��������") and DungeonLog then
		DungeonLog.OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	end
end

-- ���������û��ʵ��ͬ���ص���ֱ�Ӱ�ģ��Ļص�������Ϊ����Ļص�
-- ע��: ���ַ�ʽ�Ḳ�������ͬ������, �����������ͬ��������������ļ�ӵ���
if getopt("��¼��������") and DungeonLog then
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

-- ע��: ģ���ж�������к�����Ҫ��������ֱ�ӻ��ӵĵ���
-- ���긱����, ����־�����е���Ҽ� ���Ϊ ���浽һ���ļ���, ���ں��ڷ���Boss�ļ���ѭ��
--]]


-- ����Ҫ��¼�ļ���
local tSkill = {
[28] = "����(NPC��ս��ͨ�⹦����)",
[6746] = "����(����_��ŵ���Ѫ)",
}

--����Ҫ��¼��Buff
local tBuff = {
[14321] = "쫷���Ʒ��˺�",
}

-- Boss��
local tBoss = {}

-- Boss�ٻ���NPC
local tNpc = {}


-- ����һ������Ϊģ��, ���еĳ�����������������Ϊ��ģ��Ľӿ�
local DungeonLog = {}


-- �����ͼ
DungeonLog.OnEnterMap = function(MapID, MapName)
	print("------------------------------ �����ͼ:"..MapName, MapID)
end

-- NPC����
DungeonLog.OnNpcEnter = function(NpcID, NpcName, NpcTemplateID, NpcModelID, EmployerID, Intensity)
	if dungeon() then	--�ڸ�����
		if Intensity == 6 and NpcName and #NpcName > 0 then		--��Boss
			tBoss[NpcID] = NpcName
			print("Boss����->["..NpcName.."]", "ģ��ID:"..NpcTemplateID, NpcID)
		end
		if tBoss[EmployerID] then	--������Boss
			tNpc[NpcID] = NpcName
			print("OnNpcEnter->["..NpcName.."]", NpcID, NpcTemplateID, NpcModelID, EmployerID, Intensity)
		end
	end
end

-- NPC��ʧ
DungeonLog.OnNpcLeave = function(NpcID, NpcName, NpcTemplateID, NpcModelID, EmployerID, Intensity)
	tBoss[NpcID] = nil	--��Boss���Ƴ�
	tNpc[NpcID] = nil	--��NPC�����Ƴ�
end

-- ��ʼ����
DungeonLog.OnPrepare = function(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, Frame, StartFrame, FrameCount)
	if tSkill[SkillID] then return end
	local szName = tBoss[CasterID] or tNpc[CasterID]
	if szName then		--��Boss
		local t = {}
		t[#t+1] = "OnPrepare->["..szName.."]"
		t[#t+1] = "������:"..SkillName
		t[#t+1] = "����ID:"..SkillID
		t[#t+1] = "���ܵȼ�:"..SkillLevel
		if TargetType == 2 then
			t[#t+1] = "Ŀ��:"..TargetID.."|"..PosY.."|"..PosZ
		else
			t[#t+1] = "Ŀ��:"..TargetID
		end
		t[#t+1] = "����֡��:"..Frame
		t[#t+1] = "��ʼ֡:"..StartFrame
		t[#t+1] = "��ǰ֡:"..FrameCount
		print(table.concat(t, ", "))
	end
end

-- ��ʼ����
DungeonLog.OnChannel = function(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, Frame, StartFrame, FrameCount)
	if tSkill[SkillID] then return end
	local szName = tBoss[CasterID] or tNpc[CasterID]
	if szName then		--��Boss
		local t = {}
		t[#t+1] = "OnChannel->["..szName.."]"
		t[#t+1] = "������:"..SkillName
		t[#t+1] = "����ID:"..SkillID
		t[#t+1] = "���ܵȼ�:"..SkillLevel
		if TargetType == 2 then
			t[#t+1] = "Ŀ��:"..TargetID.."|"..PosY.."|"..PosZ
		else
			t[#t+1] = "Ŀ��:"..TargetID
		end
		t[#t+1] = "����֡��:"..Frame
		t[#t+1] = "��ʼ֡:"..StartFrame
		t[#t+1] = "��ǰ֡:"..FrameCount
		print(table.concat(t, ", "))
	end
end

-- �ͷż���
DungeonLog.OnCast = function(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if tSkill[SkillID] then return end
	local szName = tBoss[CasterID] or tNpc[CasterID]
	if szName then		--��Boss
		local t = {}
		t[#t+1] = "OnCast->["..szName.."]"
		t[#t+1] = "������:"..SkillName
		t[#t+1] = "����ID:"..SkillID
		t[#t+1] = "���ܵȼ�:"..SkillLevel
		if TargetType == 2 then
			t[#t+1] = "Ŀ��:"..TargetID.."|"..PosY.."|"..PosZ
		else
			t[#t+1] = "Ŀ��:"..TargetID
		end
		t[#t+1] = "��ʼ֡:"..StartFrame
		t[#t+1] = "��ǰ֡:"..FrameCount
		print(table.concat(t, ", "))
	end
end

-- Buff����
DungeonLog.OnBuff = function(CharacterID, BuffName, BuffID, BuffLevel, StackNum, SkillSrcID, StartFrame, EndFrame, FrameCount)
	if StackNum > 0 and SkillSrcID and SkillSrcID ~= 0 then	--�����, ��Դ��ɫ
		if tBoss[SkillSrcID] or tNpc[SkillSrcID] then	--��Bossʩ�ӵ�buff
			local t = {}
			t[#t+1] = "OnBuff->buff��:"..BuffName
			t[#t+1] = "buffID:"..BuffID
			t[#t+1] = "buff�ȼ�:"..BuffLevel
			t[#t+1] = "buff����:"..StackNum
			t[#t+1] = "Ŀ��:"..CharacterID
			t[#t+1] = "��ʼ֡:"..StartFrame
			t[#t+1] = "����֡:"..EndFrame
			t[#t+1] = "����ʱ��:"..(EndFrame - StartFrame) / 16
			print(table.concat(t, ", "))
		end
	end
end

-- Boss����
DungeonLog.OnSay = function(Name, SayText, CharacterID)
	if tBoss[CharacterID] then
		print("OnSay->["..Name.."]˵:"..SayText)
	end
end

-- ������Ϣ
DungeonLog.OnWarning = function(szText, szType)
	if dungeon() then
		print("OnWarning->"..szText, szType)
	end
end

-- ս��״̬�ı�
DungeonLog.OnFight = function(bFight)
	if dungeon() then
		if bFight then
			print("-------------------- ����ս��")
		else
			print("-------------------- ����ս��")
		end
	end
end

-- ����ģ���
return DungeonLog
