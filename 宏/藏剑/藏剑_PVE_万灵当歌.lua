--[[ ��Ѩ: [�Ծ�][���][���][����][ӳ������][����][����][����][����][�̹�][���][��������]
�ؼ�:
��Ϫ  2�˺� 2��Χ
����  2�˺� 2Ч��(����)
�Ʒ�  2���� 1�˺� 1����
Ϧ��  1���� 2�˺� 1����
����  3�˺� 1����
����  2���� 2�˺�
Х��  1Ч��(����) 3����
������ 2��Ϣ 1Ч��(����) 1��Ѫ

5���⿪��, �������
--]]

--�ر��Զ�����
setglobal("�Զ�����", false)

--��ѡ��
addopt("����������", false)

--������
local v = {}
v["��¼��Ϣ"] = true

--������
local f = {}

--��ѭ��
function Main()
	--�����Զ����ݼ�1�ҷ�ҡ, ע���ǿ�ݼ��趨�������Ŀ�ݼ�1ָ���İ��������Ǽ����ϵ�1
	if keydown(1) then
		cast("��ҡֱ��")
	end

	--����
	if fight() and life() < 0.5 then
		cast("Ȫ����")
	end
	
	--��¼��������
	if casting("�Ʒ����") and castleft() < 0.13 then
		settimer("�Ʒɶ�������")
	end
	if casting("������ɽ") and castleft() < 0.13 then
		settimer("������ɽ��������")
	end

	--��ʼ������
	v["����"] = rage()

	v["GCD���"] = cdinterval(16)
	v["��ϪCD"] = scdtime("��Ϫ����")
	v["����CD"] = scdtime("�����´�")
	v["Х�ճ��ܴ���"] = cn("Х��")
	v["Х�ճ���ʱ��"] = cntime("Х��", true)
	v["�Ʒ�CD"] = scdtime("�Ʒ����")
	v["�糵CD"] = scdtime("������ɽ")
	v["ݺ�����ܴ���"] = cn("ݺ����")
	v["ݺ������ʱ��"] = cntime("ݺ����", true)
	v["����CD"] = scdtime("������")
	v["����CD"] = scdtime("��������")

	v["��������"] = buffsn("����")		--�������к�, Ϧ�� �Ʒ� ����&�˺�+15% 10�� 2��
	v["����ʱ��"] = bufftime("����")
	v["����ʱ��"] = bufftime("����")	--Ϧ�����к�, ���ӷ���60% 5��
	v["��ڲ���"] = buffsn("���")		--�Ʒ����к�, ��Ч+8% 15�� 3��
	v["���ʱ��"] = bufftime("���")
	v["Ŀ�꾪��ʱ��"] = tbufftime("����", id())	--�������к�, �糵�����˺� 10��
	v["�̹����"] = buffsn("�̹�")		--�糵ÿ2�μ�1��, �Ʒ� Ϧ�� �׹� �˺�+30%, 9�� ���4��
	v["�̹�ʱ��"] = bufftime("�̹�")
	v["���ʱ��"] = bufftime("���")	--Х�����ؽ���, ����+8%, 10��, ÿ�λ����ӳ�5��
	v["����ʱ��"] = bufftime("����")	--����+10% �ϳ��˺�+40%
	
	v["������ɽ"] = npc("��ϵ:�Լ�", "ģ��ID:57739")
	v["�з�����ɽ"] = v["������ɽ"] ~= 0 and xnpc(v["������ɽ"], "��ϵ:�ж�", "����<10", "��ѡ��") ~= 0
	v["����"] = npc("��ϵ:�Լ�", "ģ��ID:122728", "��ɫ����<8")		--�������ٽ���
	
	local tSpeedXY, tSpeedZ = speed(tid())
	v["Ŀ�꾲ֹ"] = rela("�ж�") and tSpeedXY <= 0 and tSpeedZ <= 0
	v["Ŀ��Ѫ���϶�"] = rela("�ж�") and tlifevalue() > lifemax() * 10


	--�ȴ��ڹ��л�
	if gettimer("Х��") < 0.3 then return end

	--��ս���ὣ
	if nofight() and mount("ɽ�ӽ���") and v["����"] < 30 then
		f["Х��"]("��ս���ὣ")
	end

	--Ŀ�겻�ǵ��� ֱ�ӽ���
	if not rela("�ж�") then return end

	--����������
	if getopt("����������") and dungeon() and nofight() then return end
	
	--���˺�
	if mount("��ˮ��") then
		f["�ὣ"]()
	end
	if mount("ɽ�ӽ���") then
		f["�ؽ�"]()
	end

	--û�ż��ܼ�¼��Ϣ
	if fight() and dis() < 4 and state("վ��") and cdleft(16) <= 0 and castleft() <= 0 and gettimer("Ϧ���׷�") > 0.3 and gettimer("�Ʒ����") > 0.3 and gettimer("������ɽ") > 0.3 then
		PrintInfo("----------û�ż���")
	end
end

f["�ὣ"] = function()
	--���ؽ�
	if dis() < 8 then
		if v["����"] >= 90 then
			f["Х��"]("���ؽ�, ��������")
		end
		if v["��ϪCD"] > 1 and v["����CD"] > 1 then
			f["Х��"]("���ؽ�, ��Ϫ����������")
		end
	end

	--�ȴ����
	if gettimer("�����´�") < 0.3 or gettimer("������") < 0.3 then
		if state("���") then
			deltimer("�����´�")
			deltimer("������")
		else
			return
		end
	end

	--��Ϫ����
	if dis() < 4 then
		CastX("��Ϫ����")
	end

	--����
	if v["��ϪCD"] > 0 then
		CastX("����")
	end

	--�����´�
	if cdleft(16) >= 0.5 and face() < 80 then
		if aCastX("�����´�", 180) then
			return
		end
	end

	--������
	if face() < 80 then
		CastX("������")
	end
end

f["�ؽ�"] = function()
	--�Ʒ����
	if gettimer("�Ʒɶ�������") > 0.3 and v["����ʱ��"] > casttime("�Ʒ����") then
		CastX("�Ʒ����")
	end

	--�ؽ��� �Ʒ�֮����߽���С��30
	if gettimer("�Ʒɶ�������") < 0.3 or gettimer("�ͷ��Ʒ����") < 1 or v["����"] < 30 then
		f["�ؽ���"]()
	end

	--�б̹��Ϧ��
	if v["�з�����ɽ"] or bufftime("�̹�") < casttime("Ϧ���׷�") + 0.5 then
		if bufftime("�̹�") > casttime("Ϧ���׷�") then
			CastX("Ϧ���׷�")
		end
	end

	--���ײ�����
	if bufftime("����") < casttime("Ϧ���׷�") then
		CastX("����")
	end

	--Ϧ��
	CastX("Ϧ���׷�")

	--��̥
	CastX("����")

	--[[������ɽȺ��, ��ȥ��
	_, v["10���ڵ�������"] = npc("��ϵ:�ж�", "����<9", "��ѡ��")
	if v["10���ڵ�������"] >= 3 then
		CastX("������ɽ")
	end
	--]]
end

f["�ؽ���"] = function()
	--�շŹ�ݺ����
	if gettimer("ݺ����") < 0.5 or gettimer("�ͷ�ݺ����") < 2 then
		return
	end

	--�ڽ�����
	if gettimer("��������") < 0.5 or gettimer("�ͷŷ�������") < 1.5 or v["����"] ~= 0 or buff("����") then
		return
	end

	--�з糵
	if gettimer("������ɽ��������") < 0.5 or gettimer("�ͷŷ�����ɽ") < 1 or v["�з�����ɽ"] then
		return
	end

	--�շŹ�������
	if gettimer("������") < 0.5 or buff("����") then
		return
	end

	--��������
	if v["Ŀ�꾲ֹ"] and dis() < 6 and v["����"] < 60 then
		if CastX("��������") then
			return
		end
	end

	--������ɽ
	if v["Ŀ�꾲ֹ"] and v["Ŀ��Ѫ���϶�"] and dis() < 6 then
		if v["����"] < 60 or (v["����ʱ��"] > 8 and v["����"] < 80) then
			if v["��ڲ���"] >= 3 and v["���ʱ��"] > 5 then
				if v["ݺ������ʱ��"] < 100 and cdtime("������ɽ") <= 0 then
					CastX("ݺ����")
				end
				if CastX("������ɽ") then
					return
				end
			end
		end
	end

	--���ὣ�ؽ���
	if v["��ϪCD"] < 1 and v["Х�ճ���ʱ��"] < 1 and v["����"] < 60 then
		f["Х��"]("���ὣ�ؽ���")
	end

	--ݺ����
	if cdleft(16) <= 0 and v["����CD"] > 0 and v["��ϪCD"] > 0 and v["����"] < 60 and dis() < 8 then
		if CastX("ݺ����") then
			return
		end
	end

	--������
	if dis() < 8 and v["����"] < 60 then
		CastX("������")
	end
end

f["Х��"] = function(szReason)
	if CastX("Х��") then
		print("------------------------------ "..szReason)	--�ָ��� �л�ԭ��
		exit()
	end
end

-------------------------------------------------------------------------------

--��¼��Ϣ
function PrintInfo(s)
	local t = {}
	if s then t[#t+1] = s end
	t[#t+1] = "����:"..v["����"]
	t[#t+1] = "����:".. format("%0.1f", dis())

	t[#t+1] = "����:"..v["��������"]..", "..v["����ʱ��"]
	t[#t+1] = "����:"..v["����ʱ��"]
	t[#t+1] = "���:"..v["��ڲ���"]..", "..v["���ʱ��"]
	t[#t+1] = "�̹�:"..v["�̹����"]..", "..v["�̹�ʱ��"]
	t[#t+1] = "����:"..v["Ŀ�꾪��ʱ��"]
	t[#t+1] = "����:"..v["����ʱ��"]

	t[#t+1] = "��ϪCD:"..v["��ϪCD"]
	t[#t+1] = "Х��CD:"..v["Х�ճ��ܴ���"]..", "..v["Х�ճ���ʱ��"]
	t[#t+1] = "�Ʒ�CD:"..v["�Ʒ�CD"]
	t[#t+1] = "�糵CD:"..v["�糵CD"]
	t[#t+1] = "ݺ��CD:"..v["ݺ�����ܴ���"]..", "..v["ݺ������ʱ��"]
	t[#t+1] = "����CD:"..v["����CD"]
	t[#t+1] = "����CD:"..v["����CD"]

	print(table.concat(t, ", "))
end

--ʹ�ü��ܲ���¼��Ϣ
function CastX(szSkill, bSelf)
	if cast(szSkill, bSelf) then
		settimer(szSkill)
		if v["��¼��Ϣ"] then PrintInfo() end
		return true
	end
	return false
end

function aCastX(szSkill, nAngle)
	if acast(szSkill, nAngle) then
		settimer(szSkill)
		if v["��¼��Ϣ"] then PrintInfo() end
		return true
	end
	return false
end

-------------------------------------------------------------------------------

--�л��ڹ�
function OnMountKungFu(KungFu, Level)
	deltimer("Х��")
end

--�ͷż���
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		if SkillID == 1593 then		--�Ʒ�
			settimer("�ͷ��Ʒ����")
		end
		if SkillID == 1663 then		--ݺ����
			settimer("�ͷ�ݺ����")
		end
		if SkillID == 25070 then	--��������
			settimer("�ͷŷ�������")
		end
		if SkillID == 18333 then	--������ɽ
			settimer("�ͷŷ�����ɽ")
		end
	end
end

--��¼ս��״̬�ı�
function OnFight(bFight)
	if bFight then
		print("--------------------����ս��")
	else
		print("--------------------�뿪ս��")
	end
end
