--[[ ��Ѩ: [���][����][��Į][��Ԧ][�۳�][����][�绢][ս��][Ԩ][ҹ��][��Ѫ][����]
�ؼ�:
����  1��Ϣ 1���� 2�˺�
����  1��Ϣ 3�˺�
����  1���� 3�˺�
ͻ    1���� 1���� 2�˺�
��    1��Ϣ 1���� 2�˺�
ս�˷� 1Ŀ����� 1��Χ 2�˺�
�ϻ�� 2��Ϣ 2�˺�

����֮��, ��Ԧ����3��Ͷ�����, ��3��վ׮��
--]]

--��ѡ��
addopt("���������", false)

--������
local v = {}
v["ս��"] = rage()

--��ѭ��
function Main()
	--����
	if fight() then
		cast("Х�绢")

		if life() < 0.55 then
			cast("����ɽ")
		end
	end

	--Ŀ�겻�ǵж�, ����
	if not rela("�ж�") then return end

	--�ȴ���̽���
	if gettimer("���") < 0.3 then return end

	--�ȴ��γ۳��ͷ�
	if casting("�γ۳�") and castleft() < 0.13 then
		settimer("�γ۳Ҷ�������")
	end
	if gettimer("�γ۳Ҷ�������") < 0.3 then return end
	

	--��ʼ������
	--v["Ŀ����Ѫʱ��"] = tbufftime("��Ѫ", id())
	--v["��Ԧ����"] = buffsn("��Ԧ")
	--v["�۳�"] = bufftime("�۳�")
	--v["����"] = bufftime("����")
	--v["Ԩ"] = bufftime("2778")
	--v["������"] = buff("����")
	--v["�ж���"] = selft().IsInParty()

	--����
	if buff("����") and nobuff("�۳�") and cn("�γ۳�") > 0 then
		--if cdleft(16) >= 1 and v["ս��"] < 5 and scdtime("������") < 1.5 then
		if scdtime("������") < 1 then
			cbuff("����")
			settimer("���") exit()
		end
	end


	--Ԩ
	v["Ŀ�긽������"] = tparty("û״̬:����", "�����Լ�", "�Լ�����>6", "�Լ�����<20", "����<25","�����ڹ�:ϴ�辭|������|����������|������", "���߿ɴ�", "�������")
	if v["Ŀ�긽������"] ~= 0 then
		if xcast("Ԩ", v["Ŀ�긽������"]) then
			settimer("���") exit()
		end
	end

	--ͻ
	--if cdleft(16) > 0.5 or nobuff("����") then
	if cast("ͻ") then
		settimer("���") exit()
	end

	--������
	if rela("�ж�") and dis() < 8 and cdleft(16) < 0.5 then
		if qixue("��Ԧ") then
			if bufftime("�۳�") > 9 then
				cast("������", true)
			end
		else
			cast("������", true)
		end
	end

	--�ϻ��
	if v["ս��"] <= 2 or dis() > 12 then
		if cast("�ϻ��") then
			settimer("���") exit()
		end
	end

	---------------------------------------------

	if getopt("���������") and tbuffstate("�ɴ��") then
		cast("������")
	end

	--�γ۳�
	if qixue("��Ԧ") then
		if buff("����") then
			cast("�γ۳�")
		end
	end

	--����Ѫ
	if tbufftime("��Ѫ", id()) < cdinterval(16) * 2 then
		if v["ս��"] <= 2 then
			cast("��")
		end
		cast("����")
		cast("��")
	end

	--����
	if v["ս��"] >= 5 then
		cast("����")
	end

	--ս�˷�
	_, v["6���ڵ�������"] = npc("��ϵ:�ж�", "����<6", "��ѡ��")
	if v["6���ڵ�������"] >= 3 then
		cast("ս�˷�")
	end

	--��
	if v["ս��"] <= 2 then
		cast("��")
	end

	--����
	if v["ս��"] <= 3 then
		cast("����")
	end

	--����
	cast("����")
end

--�ͷż���
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		if SkillID == 428  then	--�ϻ��
			v["ս��"] = v["ս��"] + 3
		end
		if SkillID == 433 then	--�γ۳�
			deltimer("�γ۳Ҷ�������")
		end
	end
end

--״̬����
function OnStateUpdate(nCurrentLife, nCurrentMana, nCurrentRage, nCurrentEnergy, nCurrentSunEnergy, nCurrentMoonEnergy)
	--print("OnStateUpdate, ս��: "..nCurrentRage)
	v["ս��"] = nCurrentRage
end
