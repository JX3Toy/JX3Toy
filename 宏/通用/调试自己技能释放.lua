function Main(g_player)
	
end


--��ʼ����
function OnPrepare(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, Frame, StartFrame, FrameCount)
	if CasterID == id() then
		if TargetType == 2 then
			print("OnPrepareXYZ->["..xname(CasterID).."] ��ʼ����:"..SkillName..", ����ID:"..SkillID..", ���ܵȼ�:"..SkillLevel..", Ŀ��λ��:"..TargetID.."|"..PosY.."|"..PosZ..", ����֡��:"..Frame..", ��ʼ֡:"..StartFrame..", ��ǰ֡:"..FrameCount)
		else
			print("OnPrepare->["..xname(CasterID).."] ��ʼ����:"..SkillName..", ����ID:"..SkillID..", ���ܵȼ�:"..SkillLevel..", Ŀ��ID:"..TargetID..", ����֡��:"..Frame..", ��ʼ֡:"..StartFrame..", ��ǰ֡:"..FrameCount)
		end
	end
end

--��ʼ����
function OnChannel(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, Frame, StartFrame, FrameCount)
	if CasterID == id() then
		if TargetType == 2 then
			print("OnChannelXYZ->["..xname(CasterID).."] ��ʼ����:"..SkillName..", ����ID:"..SkillID..", ���ܵȼ�:"..SkillLevel..", Ŀ��λ��:"..TargetID.."|"..PosY.."|"..PosZ..", ����֡��:"..Frame..", ��ʼ֡:"..StartFrame..", ��ǰ֡:"..FrameCount)
		else
			print("OnChannel->["..xname(CasterID).."] ��ʼ����:"..SkillName..", ����ID:"..SkillID..", ���ܵȼ�:"..SkillLevel..", Ŀ��ID:"..TargetID..", ����֡��:"..Frame..", ��ʼ֡:"..StartFrame..", ��ǰ֡:"..FrameCount)
		end
	end
end


local tSkill = {
[17] = "����",
[13] = "���񽣷�",
[18383] = "�ؽ����񽣷�����Ч",
[6505] = "����_90��Ѩ_ǧ���������",
[1795] = "�ļ�����",
[1797] = "�ؽ�_�ڹ�_�����¼�_��ͨ�������л���",
[22423] = "�ж��Ƿ���3D�ϰ���һĿ��",
[2341] = "�����ķ�_��ӽ���",
[21286] = "ɾ��Ǳ������ͼ��",
}

--�ͷż���
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	--���˵�����Ҫ�ļ���
	if tSkill[SkillID] then return end

	--����Լ������ͷ���Ϣ
	if CasterID == id() then
		if TargetType == 2 then
			print("OnCast->["..xname(CasterID).."] �ͷ�:"..SkillName..", ����ID:"..SkillID..", ���ܵȼ�:"..SkillLevel..", Ŀ��λ��:"..TargetID.."|"..PosY.."|"..PosZ..", ��ʼ֡:"..StartFrame..", ��ǰ֡:"..FrameCount)
		else
			print("OnCast->["..xname(CasterID).."] �ͷ�:"..SkillName..", ����ID:"..SkillID..", ���ܵȼ�:"..SkillLevel..", Ŀ��ID:"..TargetID..", ��ʼ֡:"..StartFrame..", ��ǰ֡:"..FrameCount)
		end
	end
end

--Ƶ��ˢ�²���Ҫ��buff
local tBuff = {
[103] = "��Ϣ",
[23390] = "NPC��ս����buff",
[12740] = "����(����_ͨ�����ӵ��ӻ���)",
[12085] = "ͨ�ü�����",
[24104] = "ע�� (�������ע����)",
[7795] = "��������_��̱��BUFF",
[1687] = "��ˮ����������������Buff",
[21607] = "�龣",
[12850] = "��ҹ�ϳ�������Buff",
[12590] = "ÿ�����Ǽӹ���",
[6193] = "����_������",
[6094] = "����_λ���������ж�1",
[6095] = "����_λ���������ж�2",
[6422] = "����_������������",
[8423] = "����",
[8393] = "����",
[10440] = "������ʱ������˱��BUFF",
[8571] = "�ķ�10%��פ����",
[6204] = "����_ϴ��_��Ѫ��",
[6004] = "�л���Ѩ������Ч��",
[6176] = "����_��10�㽣��",
[12382] = "�������",
[21756] = "ҩ��_��Ҷ����",
[15798] = "������������ͷű��BUFF",
}

--�Լ��Ͷ��ѵ���buff����
function OnBuff(CharacterID, BuffName, BuffID, BuffLevel, StackNum, SkillSrcID, StartFrame, EndFrame, FrameCount)
	--���˵�����Ҫ��buff
	if tBuff[BuffID] then return end

	--����Լ�buff��Ϣ
	if CharacterID == id() or xname(CharacterID) == "���ڤ΢" then
		if StackNum  > 0 then
			print("OnBuff->["..xname(CharacterID).."] ���buff: ".. BuffName..", ID: "..BuffID..", �ȼ�: "..BuffLevel..", ����: "..StackNum..", ԴID: "..SkillSrcID..", ��ʼ֡: "..StartFrame..", ��ǰ֡: "..FrameCount..", ����֡: "..EndFrame..", ʣ��ʱ��: "..(EndFrame-FrameCount)/16)
		else
			print("OnBuff->["..xname(CharacterID).."] �Ƴ�buff: ".. BuffName..", ID: "..BuffID..", �ȼ�: "..BuffLevel..", ����: "..StackNum..", ԴID: "..SkillSrcID..", ��ʼ֡: "..StartFrame..", ��ǰ֡: "..FrameCount)
		end
	end
end

--NPC���볡��
function OnNpcEnter(NpcID, NpcName, NpcTemplateID, NpcModelID, EmployerID)
	if EmployerID == id() then
		print("OnNpcEnter->"..NpcName..", NPCID: "..NpcID..", ģ��ID: "..NpcTemplateID..", ����ID: "..NpcModelID)
	end
end

--״̬����
function OnStateUpdate(nCurrentLife, nCurrentMana, nCurrentRage, nCurrentEnergy, nCurrentSunEnergy, nCurrentMoonEnergy)
	--print("����: "..nCurrentSunEnergy / 100, "�»�: "..nCurrentMoonEnergy / 100)
end

--������Ϣ
function OnWarning(szText, szType)
	print("OnWarning->"..szText)
end

--�������
function OnQidianUpdate()

end

--�л��ڹ�
function OnMountKungFu(KungFu, Level)

end

--ϵͳ��Ϣ
function OnMessage(szMsg, szType)

end

--NPC����
function OnSay(szName, szSay, CharacterID, nChannel)

end

--��ս��ս
function OnFight(bFight)

end

--����buff�б�
function OnBuffList(CharacterID)

end
