--[[����
[����]2 [Ѱ��]3 [����]2
[����]2 [����]2 [����]3 [��ѩ]1
[̤ѩѰ÷]1 [ŭ��]1 [����]2
[�Ծ�]3 [��Ȥ]2 [��ʯ]1
[ɽ��ˮ��]3
[����Ӱ]1
[ɽɫ]2 [����]3
[���]2
--]]
--�ܴ��˺�����

--�ر��Զ�����
setglobal("�Զ�����", false)

--��ѡ��
addopt("����������", false)
addopt("��T̽÷", false)

--������
local v = {}
v["����"] = rage()
v["�ȴ��ڹ��л�"] = false

--������
local f = {}

--��ѭ��
function Main(g_player)
	--��������
	local mapName = map()
	local func = tMapFunc[mapName]
	if func then
		func(g_player)
	end
	
	--����
	if fight() and life() < 0.6 then
		cast("Ȫ����")
	end

	if casting("�Ʒ����") and castleft() < 0.13 then
		settimer("�Ʒ���ʶ�������")
	end
	if casting("Ϧ���׷�") and castleft() < 0.13 then
		settimer("Ϧ���׷��������")
	end

	if v["�ȴ��ڹ��л�"] and gettimer("Х��") <= 0.25 then
		return
	end

	--÷����
	if mount("��ˮ��") and bufftime("÷����") < 23 then
		if cast("÷����") then
			settimer("÷����")
		end
	end

	--����������
	if getopt("����������") and dungeon() and nofight() then return end
	
	if tbuff("����") then
		bigtext("Ŀ���޵�", 0.5)
		return
	end

	--���
	if tbuffstate("�ɴ��") then
		if gettimer("������") > 1 and cast("ժ��") then
			settimer("ժ��")
		end
		if gettimer("ժ��") > 1 and cast("������") then
			settimer("������")
		end
	end

	v["Ŀ��Ѫ���϶�"] = rela("�ж�") and tlifevalue() > lifemax() * 10	--Ŀ��Ѫ�������Լ����Ѫ��10��

	---------------------------------------------�ὣ
	if mount("��ˮ��") then
		--̽÷
		if getopt("��T̽÷") and rela("�ж�") then
			xcast("̽÷", tparty("û״̬:����", "�ڹ�:ϴ�辭|������|����������|������", "����<8", "�Լ�����<15", "���߿ɴ�", "�������"))
		end

		--[[�����´�
		if cdleft(16) >= 0.875 and face() > 100 then 
			cast("�����´�")
		end
		--]]

		--Х��
		if gettimer("÷����") < 1 or bufftime("÷����") > 12 then
			if v["Ŀ��Ѫ���϶�"] and dis() < 8 and cdleft(16) < 0.5 and cdtime("����Ӱ") <= 0 then
				f["Х��"]("����Ӱ���ؽ�")
			end

			if v["����"] >= 100 then
				f["Х��"]("��������100���ؽ�")
			end

			if buffsn("��Ȥ") >= 3 then
				f["Х��"]("3����Ȥ���ؽ�")
			end
		end
		
		if buff("÷����") then
			if cdtime("Х��") > 2 or bufftime("����") < 2 then
				cast("�ϳ�")
			end
		end

		if cdtime("Х��") > 8 then
			cast("��Ȫ����")
		end

		cast("̤ѩѰ÷")
		
		

		cast("����")

		if v["Ŀ��Ѫ���϶�"] and dis() < 4 and ttid() == id() then
			cast("������")
		end
		
		--[[
		if cdtime("�����´�") <= 0 then
			cast("ƽ������")
		end
		--]]

		if dis() > 8 then
			cast("������")
		end
	end

	---------------------------------------------�ؽ�
	if mount("ɽ�ӽ���") then
		--����
		if rela("�ж�") and dis() < 8 and cdleft(16) < 0.5 and bufftime("Х��") > 10 then		--Ŀ��ʱ����, ����С��8��, GCD�����
			if tlifevalue() > lifemax() * 5 then		--Ŀ�굱ǰѪ�������Լ����Ѫ��5��
				cast("�ͻ���ɽ")
			end

			if v["Ŀ��Ѫ���϶�"] then
				if cast("����Ӱ") then
					settimer("����Ӱ")
				end
			end
		end

		if bufftime("Х��") <= cdinterval(16) and nobuff("��Ȥ") and (cdtime("�Ʒ����") > cdinterval(16) or gettimer("�Ʒ���ʶ�������") < 1) then
			f["Х��"]("Х��ʱ�䲻����һ������")
		end

		if gettimer("�Ʒ���ʶ�������") < 1 or cdtime("�Ʒ����") > cdinterval(16) or bufftime("Х��") <= cdinterval(16) or bufftime("����") <= cdinterval(16) then
			if cast("�ϳ�") then
				settimer("�ϳ�")
			end
		end

		--ѩ����
		if bufftime("Х��") > cdinterval(16) and rage() < 20 then
			if cast("ѩ����") then
				settimer("ѩ����")
			end
		end

		_, v["6���ڹ�������"] = npc("��ϵ:�ж�", "����<6", "��ѡ��")
		if v["6���ڹ�������"] >= 3 then
			cast("������ɽ")
		end
		
		if gettimer("�Ʒ���ʶ�������") > 0.25 then
			cast("�Ʒ����")
		end

		if gettimer("�ϳ�") >= 0.25 then
			if gettimer("Ϧ���׷��������") >= 0.25 or cdtime("�ϳ�") > 0 then
				cast("Ϧ���׷�")
			end
		end

		if rela("�ж�") and dis() > 12 and dis() < 20 and face() < 60 then
			acast("�׹��ɽ")
		end

		--Х��
		if gettimer("����Ӱ") > 0.5 then
			if nofight() then
				f["Х��"]("��ս���ὣ")
			end
			if v["����"] < 15 and gettimer("ѩ����") > 0.25 then
				f["Х��"]("����������һ������")
			end
		end
	end
end

f["Х��"] = function(szReason)
	if cast("Х��") then
		v["�ȴ��ڹ��л�"] = true
		settimer("Х��")
		if szReason then
			print("Х��: "..szReason, cdtime("Х��"))
		end
		exit()
	end
end

--״̬����
function OnStateUpdate(nCurrentLife, nCurrentMana, nCurrentRage, nCurrentEnergy, nCurrentSunEnergy, nCurrentMoonEnergy)
	v["����"] = nCurrentRage
end

--�л��ڹ�
function OnMountKungFu(KungFu, Level)
	v["�ȴ��ڹ��л�"] = false
end

--�ͷż���
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		if SkillID == 1600 then
			deltimer("Ϧ���׷��������")
			return
		end
	end
end

local tBuff = {
[50283] = "��ʯ_Ϧ���Ʒ��˺����",
[1722] = "�ϳ�buff",
}

--����buff
function OnBuff(CharacterID, BuffName, BuffID, BuffLevel, StackNum, SkillSrcID, StartFrame, EndFrame, FrameCount)
	--���buff������Ϣ
	if CharacterID == id() and tBuff[BuffID] then
		if StackNum > 0 then
			print("���buff: "..BuffName, "ID: "..BuffID, "�ȼ�: "..BuffLevel, "����: "..StackNum, "ʣ��ʱ��:"..((EndFrame - FrameCount) / 16))
		else
			print("�Ƴ�buff: "..BuffName)
		end
	end
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
		stopcasting()		--ֹͣ����
		turn(180)			--����Ŀ��
		--�ر���Ȫ����
		if buff("��Ȫ����") and nobuff("50254") and gettimer("�д���ң") > 0.25 then
			if cast("�д���ң") then
				settimer("�д���ң")
			end
		end
		exit()
	else
		if tname("��") and face() > 60 then
			turn()
		end
	end
end
