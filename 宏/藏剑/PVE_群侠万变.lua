--[[ ��Ѩ: [�Ծ�][���][���][����][ӳ������][����][����][����][����][�̹�][���][��������]
�ؼ�:
��Ϫ  2�˺� 2��Χ
����  2�˺� 2Ч��(����)
�Ʒ�  2���� 1�˺� 1����
Ϧ��  1���� 2�˺� 1����
����  3�˺� 1����
����  2���� 2�˺�
Х��  1Ч��(����) 3����
������ 2��Ϣ 1Ч��(�ؽ���)
--]]

--�ر��Զ�����
setglobal("�Զ�����", false)

--������
local v = {}

--������
local f = {}

--��ѭ��
function Main(g_player)
	--����
	if fight() and life() < 0.5 then
		cast("Ȫ����")
	end
	
	if casting("�Ʒ����") and castleft() < 0.13 then
		settimer("�Ʒɶ�������")
	end

	if gettimer("�л��ڹ�") < 0.3 then return end
	if gettimer("���") < 0.3 then return end

	--��ʼ������
	v["����"] = rage()
	v["��ϪХ����ȴ"] = scdtime("��Ϫ����") < 0.125 and cntime("Х��", true) < 0.25
	v["��ϪХ��û��ȴ"] = scdtime("��Ϫ����") > 3 or cntime("Х��", true) > 3
	v["������ɽNPC"] = npc("��ϵ:�Լ�", "ģ��ID:57739")
	v["�з�����ɽ"] = v["������ɽNPC"] ~= 0 and xnpc(v["������ɽNPC"], "��ϵ:�ж�", "����<10", "��ѡ��") ~= 0
	v["û������ɽ"] = v["������ɽNPC"] == 0 or xnpc(v["������ɽNPC"], "��ϵ:�ж�", "����<10", "��ѡ��") == 0
	local speedXY, speedZ = speed(tid())
	v["Ŀ�꾲ֹ"] = rela("�ж�") and speedXY <= 0 and speedZ <= 0
	v["Ŀ��Ѫ���϶�"] = rela("�ж�") and tlifevalue() > lifemax() * 5
	v["����CD"] = cdleft(1832)	--scdtime("��������") �л��ڹ����˲�伫������»ᱨ��, ֱ����CooldownID
	
	--------------------------------------------- �ὣ
	if mount("��ˮ��") then
		if rela("�ж�") and dis() < 6 then
			if v["����"] >= 90 then
				f["Х��"]()
			end

			if scdtime("��Ϫ����") > 1 and scdtime("�����´�") > 1 then
				f["Х��"]()
			end
		end

		if rela("�ж�") and dis2() < 5 then
			cast("��Ϫ����")
		end

		if scdtime("��Ϫ����") > 0 then
			cast("����")
		end

		if cdleft(16) >= 0.5 then
			if acast("�����´�", 180) then
				settimer("���")
				exit()
			end
		end

		if cast("������") then
			settimer("���")
			exit()
		end
	end

	--------------------------------------------- �ؽ�
	if mount("ɽ�ӽ���") then
		--�������ὣ
		if v["��ϪХ����ȴ"] and v["����"] < 15 then
			f["Х��"]("����С��15��")
		end

		--������ɽȺ��
		_, v["10���ڵ�������"] = npc("��ϵ:�ж�", "����<9", "��ѡ��")
		if v["10���ڵ�������"] >= 3 then
			cast("������ɽ")
		end

		--�Ʒ�
		if gettimer("�Ʒɶ�������") > 0.25 and bufftime("����") > casttime("�Ʒ����") then
			cast("�Ʒ����")
		end

		--�ὣ�ؽ���
		if v["��ϪХ����ȴ"] and v["����"] < 35 then
			f["Х��"]("���ὣ�ؽ���")
		end

		--�ؽ���
		f["�ؽ���"]()
		
		--���ײ�����
		if rela("�ж�") and v["������ɽNPC"] ~= 0 and xdis(v["������ɽNPC"], tid()) < 10 then
			if tbufftime("����", id()) < xbufftime("12340", v["������ɽNPC"]) + 0.25 then
				cast("����")
			end
		end

		--�б̹��Ϧ��
		if bufftime("�̹�") > casttime("Ϧ���׷�") then
			cast("Ϧ���׷�")
		end

		--���ײ�����
		if bufftime("����") < casttime("Ϧ���׷�") then
			cast("����")
		end

		--Ϧ��
		cast("Ϧ���׷�")

		--��̥
		cast("����")
	end

end

f["Х��"] = function(szReason)
	if cast("Х��") then
		if szReason then print("Х��: "..szReason) end
		settimer("�л��ڹ�")
		exit()
	end
end

f["�ؽ���"] = function()
	if rela("�ж�") and dis() < 6 then
		if v["��ϪХ��û��ȴ"] and gettimer("ݺ����") > 0.75 and v["����"] < 60 then
			if gettimer("������ɽ") > 1 and gettimer("��������") > 0.5 and gettimer("������") > 0.5 then
				if nobuff("����|26053") and v["û������ɽ"] then	--buff 26053 �з���
				
					--������ɽ
					if v["Ŀ�꾲ֹ"] and v["Ŀ��Ѫ���϶�"] then
						if cntime("ݺ����", true) < 8 and cdtime("������ɽ") <= 0 then
							if cast("ݺ����") then
								settimer("ݺ����")
							end
						end
						if cast("������ɽ") then
							settimer("������ɽ")
							return
						end
					end

					--��������
					if cast("��������") then
						settimer("��������")
						return
					end

					--ݺ����
					if v["����CD"] > 1 and scdtime("������ɽ") > 1 then
						if cast("ݺ����") then
							settimer("ݺ����")
							return
						end
					end

					--������
					if cast("������") then
						settimer("������")
						return
					end

				end
			end
		end
	end
end

--�л��ڹ�
function OnMountKungFu(KungFu, Level)
	deltimer("�л��ڹ�")
	
	if KungFu == 10145 then		--�л���ɽ�ӽ���, ������������ʱû��
		v["�Ź�������ɽ"] = false
		v["�Ź���������"] = false
	end
end

--״̬����
function OnStateUpdate(nCurrentLife, nCurrentMana, nCurrentRage, nCurrentEnergy, nCurrentSunEnergy, nCurrentMoonEnergy)
	--��������䶯���
	--print("OnStateUpdate, ����: "..nCurrentRage, "��ǰ֡: ".. frame())
end

--�ͷż���
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		if SkillID == 18333 then	--������ɽ
			v["�Ź�������ɽ"] = true
		end
		if SkillID == 25070 then	--��������
			v["�Ź���������"] = true
		end
	end
end
