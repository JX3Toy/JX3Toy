output("----------����----------")
output("2 3 2")
output("0 2 2 3")
output("2 1 0 2")
output("0 2 3")
output("0 3 0")
output("1 1")
output("0 3 2")
output("2 0 0 0")


--��ѡ��
addopt("����������", true)

--������
local v = {}

--��ѭ��
function Main(g_player)

	--��ֹ��Ϲ�
	if gettimer("����") < 0.5 or lasttime("����") < 2 or casting("����") then
		return
	else
		nomove(false)		--�����ƶ�
	end

	--��������, �����ֵͬ������Ϊ��
	if casting("ǧ����|ʴ����") and castleft() < 0.13 then
		v["�ȴ����ֵͬ��"] = true
		settimer("��������")
	end

	--��ֹ�ظ���ǧ����
	if casting("ǧ����") and castleft() < 0.13 then
		settimer("ǧ�����������")
	end
	
	--����
	if fight() and life() < 0.5 then
		cast("��������")
	end

	--�ȴ����ֵͬ��
	if v["�ȴ����ֵͬ��"] and gettimer("��������") < 0.5 then
		--print("�ȴ����ֵͬ��")
		return
	end


	--����
	v["��Ҫ��ǧ����"] = false
	if rela("�ж�") and dis() < 20 then
		if gettimer("ǧ�����������") > 2 and nopuppet() or xxdis(pupid(), tid()) > 25 then		--û����������Ŀ�곬��25��
			v["��Ҫ��ǧ����"] = true
			cast("ǧ����", true)
		end

		if puppet("����ǧ�������") then
			_, v["����10���ڵ�������"] = xnpc(pupid(), "��ϵ:�ж�", "����<10", "��ѡ��")
			if v["����10���ڵ�������"] >= 3 then
				cast("��ɲ��̬")
			end
			cast("������̬")
			--cast("������̬")
		end
	end

	--�ŵ�
	if rela("�ж�") and tstate("վ��|������|ѣ��|����|����|����") and energy() >= 70 and cdleft(16) <= 1 then
		cast("����ɱ��")
	end

	--����������
	if getopt("����������") and dungeon() and nofight() then return end

	---------------------------------------------��ʼ���

	--�󹥻�
	if puppet("����ǧ��������|����ǧ��������") and puptid() ~= tid() and xxdis(pupid(), tid()) < 25 and xxvisible(pupid(), tid()) then
		cast("����")
	end

	--���ް󶨹�
	if lasttime("����") < 5 then
		cast("��������")
	end

	_, v["����ɱ������"] = tnpc("��ϵ:�Լ�", "����:���ذ���ɱ��", "����<6")

	--��
	if (puppet("����ǧ��������") and lasttime("������̬") < 80) or (puppet("����ǧ��������") and lasttime("������̬") < 80) then	--������������ʣ��ʱ�����40��
		if xdis(pupid()) < 4 and tlifevalue() > lifemax() * 10 and v["����ɱ������"] >= 2 then		--�Լ�����ľ���С��4�ߣ�Ŀ�굱ǰ����ֵ�����Լ��������ֵ10��(Ŀ�껹û���)
			if cast("����") then
				stopmove()			--ֹͣ�����ƶ�
				nomove(true)		--��ֹ�ƶ�
				settimer("����")
				exit()				--�жϽű�ִ��
			end
		end
	end
	
	--����
	if v["����ɱ������"] >= 3 then
		cast("ͼ��ذ��")
	end

	--��Ѫ��
	if tnobuff("��Ѫ��", id()) then
		cast("��Ѫ��")
	end


	--�������
	v["���������"] = false

	--[[���Լ����
	_, v["��Χ6�ߵ�������"] =  npc("��ϵ:�ж�", "����<6", "��ѡ��")
	if v["��Χ6�ߵ�������"] >= 3 then
		v["���������"] = true
		cast("�������", true)
	end
	--]]

	--��Ŀ�����
	if rela("�ж�") and tstate("վ��|������|ѣ��|����|����|����") then
		v["���������"] = true
		cast("�������")
	end

	--������צ, ��10���
	if energy() < 40 then
		cast("������צ")
	end

	--��Ůɢ��
	_, v["Ŀ��9�ߵ�������"] = tnpc("��ϵ:�ж�", "����<9", "��ѡ��")
	if v["Ŀ��9�ߵ�������"] >= 3 then
		cast("��Ůɢ��")
	end

	--�а���ȴ������
	if bufftime("����") > casttime("ʴ����") then		--����ʱ�����ʴ��������ʱ��
		cast("ʴ����")
	end

	cast("��ȸ��")


	--[[��������
	if nobuff("��������") then
		if nobuff("3286") or nobuff("3283") then
			cast("�����滨��")
		end
	end
	--]]

	cast("�����滨��")

	if energy() >= 50 and not v["��ǧ����"]  then		--��ֹʴ��������������Ų����������
		cast("ʴ����")
	end
end


--�Լ�״̬����
function OnStateUpdate(nCurrentLife, nCurrentMana, nCurrentRage, nCurrentEnergy, nCurrentSunEnergy, nCurrentMoonEnergy, n_UnKnow)
	v["�ȴ����ֵͬ��"] = false
end


local tSkill = {
[17] = "����",
[3121] = "��ڷ�",
[3298] = "��������",
[3299] = "���İ���",
[3169] = "�س�����",
}

function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if tSkill[SkillID] then return end

	--[[
	if CasterID == id() then
		if TargetType == 2 then		--����2 ��ָ��λ��, ���� 3 4 ��ָ����NPC�����
			print("OnCast->["..xname(CasterID).."] �ͷ�:"..SkillName..", ����ID:"..SkillID..", ���ܵȼ�:"..SkillLevel..", Ŀ��λ��:"..TargetID.."|"..PosY.."|"..PosZ..", ��ʼ֡:"..StartFrame..", ��ǰ֡:"..FrameCount)
		else
			print("OnCast->["..xname(CasterID).."] �ͷ�:"..SkillName..", ����ID:"..SkillID..", ���ܵȼ�:"..SkillLevel..", Ŀ��ID:"..TargetID..", ��ʼ֡:"..StartFrame..", ��ǰ֡:"..FrameCount)
		end
	end
	--]]
end


--[[����buff
function OnBuff(CharacterID, BuffName, BuffID, BuffLevel, StackNum, SkillSrcID, StartFrame, EndFrame, FrameCount)
	if CharacterID == id() then
		if StackNum > 0 then
			print("���buff: "..BuffName, "ID: "..BuffID, "�ȼ�: "..BuffLevel, "����: "..StackNum, "ʣ��ʱ��:"..((EndFrame - FrameCount) / 16))
		else
			print("�Ƴ�buff: "..BuffName)
		end
	end
end
--]]

--��������: ����ǧ�������, ����ǧ��������, ����ǧ��������, ����ǧ�������
