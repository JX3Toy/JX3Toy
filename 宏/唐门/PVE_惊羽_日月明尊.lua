--[[����
[�ױ�����]2 [��绯Ѫ]3 [�����ѵ�]2
[�س�����]3 [ӥ�ﻢ��]2 [Ѹ������]2
[��ʯ����]2 [���Ǽ�]1 [���Ȫ]2
[ԡѪ�߹�]1 [ս������]2
[׷������]2 [��������]3 [��������]1
[������]1
[������ȭ]3 [��������]2
[��������]2
--]]

--�ر��Զ�����
setglobal("�Զ�����", false)

--��ѡ��
addopt("����������", false)
addopt("��׷", true)
addopt("жԪ����ɢ", false)

--������
local v = {}
v["���ֵ"] = energy()
v["�ȴ������ͷ�"] = false

--������
local f ={}

--��ѭ��
function Main(g_player)
	--�����������������õȴ���־Ϊ��
	if casting("���Ǽ�|������") and castleft() < 0.13 then
		v["�ȴ������ͷ�"] = true
		settimer("�ȴ������ͷ�")
	end

	--����
	if fight() and life() < 0.6 then
		cast("��������")
	end

	--��������
	local mapName = map()
	local func = tMapFunc[mapName]
	if func then
		func(g_player)
	end
	----------------------------------------��ʼ���
	
	--�ȴ����������ͷ�
	if v["�ȴ������ͷ�"] and gettimer("�ȴ������ͷ�") <= 0.25 then
		return
	end

	--����������
	if getopt("����������") and dungeon() and nofight() then return end

	--Ŀ�겻�ǵ���, ����
	if not rela("�ж�") then return end

	if tbuff("����") then
		bigtext("Ŀ���޵�", 0.5)
		return
	end

	--÷����
	if tbuffstate("�ɴ��") then
		cast("÷����")
	end

	--жԪ��
	if getopt("жԪ����ɢ") and tbufftype("��������|��������|��������|��Ԫ������") > 0 then
		cast("жԪ��")
	end

	--��ʼ������
	local tSpeedXY, tSpeedZ = speed(tid())
	v["Ŀ�꾲ֹ"] = tSpeedXY == 0 and tSpeedZ == 0		--xy�ٶȺ�Z�ٶȶ�Ϊ0
	v["Ŀ��Ѫ���϶�"] = tlifevalue() > lifemax() * 10	--Ŀ��Ѫ�������Լ����Ѫ��10��
	v["û�����ʯ��"] = nobuff("50351")
	v["û������Ǽ�"] = nobuff("50349")

	--����
	if dis() < 25 and face() < 60 and v["Ŀ��Ѫ���϶�"] and v["Ŀ�꾲ֹ"] and state("վ��") then
		if cdleft(16) < 0.5 then	--GCD�����
			cast("�ͻ���ɽ")
		end

		--if bufftime("��������") > 6 and cdleft(16) >= 0.5 and cdleft(16) <= 1 and v["���ֵ"] < 45 then
		if cdleft(16) >= 0.5 and cdleft(16) <= 1 and v["���ֵ"] < 45 then
			cast("��������")
		end

		if getopt("��׷") and dis() < 24 and cdtime("׷����") <= 0.25 and v["���ֵ"] >= 45 and bufftime("׷������") > 5 then
			if cast("������Ӱ") then
				settimer("������Ӱ")
			end
		end
	end

	--������
	if bufftime("��������") > 0 then
		--׷����
		f["׷����"]()

		if dis() > 20 then
			cast("���Ǽ�")
		end

		if cdtime("׷����") < 2 and nobuff("׷������") then
			if bufftime("��������") > casttime("���Ǽ�") and v["û������Ǽ�"] then
				f["���Ǽ�"]()
			end
		end

		--�а���ȴ���������
		if buff("����") then
			f["��ʯ��"]()
		end

		cast("���Ǽ�")

		if bufftime("��������") > casttime("������") then
			cast("������")
		end

		if bufftime("��������") > casttime("���Ǽ�") and v["û������Ǽ�"] then
			f["���Ǽ�"]()
		end

		if bufflv("��������") >= 4 or v["���ֵ"] >= 80 then
			f["��ʯ��"]()
		end

		if cdtime("���Ǽ�") > bufftime("��������") then
			if bufflv("��������") >= 3 and bufftime("��������") > casttime("������") / 3 + 0.0625 then
				cast("������")
			end
		end
	end

	--��Ѫ��
	if tnobuff("��Ѫ��", id()) then
		cast("��Ѫ��")
	end

	--��ȸ��
	if buffsn("����") >= 2 or buff("׷������") then
		cast("��ȸ��")
	else
		f["���Ǽ�"]()
	end
	
	f["�ͷŶ��Ǽ�"]()
end

f["���Ǽ�"] = function()
	if (buff("����") and v["���ֵ"] >= 12) or v["���ֵ"] >= 29 then
		cast("���Ǽ�")
	end
end

f["�ͷŶ��Ǽ�"] = function()
	if cdtime("���Ǽ�") < cdleft(16) and bufftime("��������") > cdleft(16) then return end
	--if cdtime("������") < cdleft(16) and bufftime("��������") > cdleft(16) + casttime("������") then return end
	if cdtime("��ȸ��") >= 1 and v["���ֵ"] >= 74 then
		f["���Ǽ�"]()
	end
end

f["׷����"] = function()
	if buff("׷������") then
		if (buff("����") and v["���ֵ"] >= 18) or v["���ֵ"] >= 45 then
			cast("׷����")
		end
	end
end

f["��ʯ��"] = function()
	if v["û�����ʯ��"] then
		if (buff("����") and v["���ֵ"] >= 18) or v["���ֵ"] >= 45 then
			cast("��ʯ��")
		end
	end
end


--�ͷż���
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		--print("OnCast->:"..SkillName..", ����ID:"..SkillID..", ���ܵȼ�:"..SkillLevel..", Ŀ��ID:"..TargetID..", ��ʼ֡:"..StartFrame..", ��ǰ֡:"..FrameCount)

		--���Ǽ�
		if SkillID == 3095 then
			v["���ֵ"] = v["���ֵ"] - 29
			v["�ȴ������ͷ�"] = false
			return
		end

		--������
		if SkillID == 3098 then
			v["���ֵ"] = v["���ֵ"] - 30
			v["�ȴ������ͷ�"] = false
			return
		end

		--����
		if SkillID == 64083 then
			print("����")
			return
		end
	end
end


--����buff
local tBuff = {
[3278] = "����",
[50354] = "��������",
}
function OnBuff(CharacterID, BuffName, BuffID, BuffLevel, StackNum, SkillSrcID, StartFrame, EndFrame, FrameCount)
	--[[
	if CharacterID == id() and tBuff[BuffID] then
		if StackNum > 0 then
			print("���buff: "..BuffName, "ID: "..BuffID, "�ȼ�: "..BuffLevel, "����: "..StackNum, "ʣ��ʱ��:"..((EndFrame - FrameCount) / 16))
		else
			print("�Ƴ�buff: "..BuffName, "ID: "..BuffID, "�ȼ�: "..BuffLevel)
		end
	end
	--]]
end

--״̬����
function OnStateUpdate(nCurrentLife, nCurrentMana, nCurrentRage, nCurrentEnergy, nCurrentSunEnergy, nCurrentMoonEnergy)
	v["���ֵ"] = nCurrentEnergy
end

-------------------------------------------------��������
tMapFunc = {}

tMapFunc["�����ؾ�"] = function(g_player)
	--����
	if tcasting("����") then
		stopcasting()
		if tcastleft() < 0.5 then
			cast("��������")
			cast("ӭ�����")
			cast("������ʤ")
			cast("��̨���")
		end
		exit()
	end

	--����
	if tcasting("����") and tcastleft() < 0.5 then
		settimer("Ŀ���������")
	end
	if gettimer("Ŀ���������") < 2 or tbuff("4147") then	--���� �����˺�
		stopcasting()
		exit()
	end
end

tMapFunc["�����ؾ�"] = function(g_player)
	--����
	if tcasting("����") then
		stopcasting()
		if tcastleft() < 0.5 then
			cast("��������")
			cast("ӭ�����")
			cast("������ʤ")
			cast("��̨���")
		end
		exit()
	end

	--����
	if tcasting("����") and tcastleft() < 0.5 then
		settimer("Ŀ���������")
	end
	if gettimer("Ŀ���������") < 2 or tbuff("4147") then	--���� �����˺�
		stopcasting()		--ֹͣ����
		turn(180)			--����Ŀ��
		exit()
	else
		if tname("��") and face() > 60 then
			turn()
		end
	end
end
