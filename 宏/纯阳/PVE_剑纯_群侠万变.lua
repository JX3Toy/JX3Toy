--[[ ��Ѩ:[�Ĺ�][����][������][����Ӱ][����][����][����][����][�ʳ�][����][�鼫][����]
�ؼ�:
��̫��	3���� 1Ч��
������	ȫ��
����	1���� 3�˺� (1�����ϼ��� �˺�3���ɼ�CD)
����	1���� 2�˺� 1Ч��
�˻�	3�˺� 1Ч��
�˽�	1��Ϣ 1dot 1�������� 1�˺�
����	2��Ϣ 1��Ѫ�� 1����
ƾ��	2��Ϣ 1������ 1���ܻ�Ѫ
--]]

--�ر��Զ�����
setglobal("�Զ�����", false)

--��ѡ��
addopt("����������", false)
addopt("�ֶ�����", false)

--������
local v = {}
v["�����Ϣ"] = true

--��ѭ��
function Main()
	--��ʼ������
	v["����"] = qidian()
	v["���ǳ�CD"] = scdtime("���ǳ�")
	v["������CD"] = scdtime("������")
	v["����CD"] = scdtime("��������")
	v["��CD"] = scdtime("�򽣹���")
	v["�˻�CD"] = scdtime("�˻Ĺ�Ԫ")
	v["�˽�CD"] = scdtime("�˽���һ")
	v["����ʱ��"] = tbufftime("����", id())
	v["���в���"] = tbuffsn("����", id())
	v["����ʱ��"] = bufftime("����")
	v["����ʱ��"] = bufftime("����")
	v["���Ų���"] = buffsn("����")

	local tSpeedXY, tSpeedZ = speed(tid())
	v["Ŀ�꾲ֹ"] = rela("�ж�") and tSpeedXY <= 0 and tSpeedZ <= 0
	v["������"] = npc("��ϵ:�Լ�", "����:����������", "����<15")
	v["���ǳ�"] = npc("��ϵ:�Լ�", "����:�������ǳ�", "����<13")
	v["������"] = npc("��ϵ:�Լ�", "����:����������", "����<13")
	_, v["��������"] = npc("��ϵ:�Լ�", "����:������̫��|�������ǳ�|����������", "����<13")

	--û��ս��������
	if nofight() and nobuff("��������") then
		CastX("��������")
	end

	--����
	if fight() and life() < 0.5 and gettimer("��������") > 0.3 and nobuff("��������") and gettimer("תǬ��") > 0.3 and buffstate("����Ч��") < 40 then
		if CastX("��������") then return end
		if CastX("תǬ��") then return end
	end

	--û��ս 3��
	if nofight() and v["Ŀ�꾲ֹ"] then
		_, v["Ŀ����������"] = tnpc("��ϵ:�Լ�", "����:������̫��|�������ǳ�|����������", "����<13")
		if v["Ŀ����������"] < 3 then
			CastX("���ǳ�")
		end
	end
	
	--����������
	if getopt("����������") and dungeon() and nofight() then return end

	--�˽� ���ִ�����
	if rela("�ж�") and dis() < 6 and v["��������"] >= 3 and v["���Ų���"] < 3 then
		if v["������"] == 0 and v["���ǳ�CD"] < cdinterval(16) then
			CastX("�˽���һ")
		end
	end

	--���������3����
	if v["��������"] < 3 and v["��������"] + v["���Ų���"] < 3 then
		CastX("������")
		CastX("��̫��")
	end

	--��������
	if v["����ʱ��"] < 0 or v["����ʱ��"] > 12 then
		CastX("��������")
	end

	--���ǳ�
	v["���ǳ�����"], v["���ǳ�ʱ��"] = qc("�������ǳ�", id(), id())
	if v["���ǳ�����"] > -1 or v["���ǳ�ʱ��"] < 1 then
		CastX("���ǳ�")
	end

	--����, �󶨾���Ӱ
	if not getopt("�ֶ�����") or keydown(1) then	--û���ֶ�����ѡ��, ���߰��¿�ݼ�1(���ǰ���1, ���ڿ�ݼ��������Լ����õĿ�ݼ�1��Ӧ�İ���)
		if nobuff("��������") and rela("�ж�") and dis() < 6 and face() < 90 and bufftime("����Ӱ") > 0.5 and cdtime("����Ӱ") <= 0 then
			if v["����ʱ��"] > 10 and v["���Ų���"] >= 3 then
				if CastX("��������") then
					CastX("ƾ������")
				end
			end
		end
	end

	--����Ӱ
	CastX("����Ӱ")

	--�򽣹���
	if rela("�ж�") and dis() < 8 and tnpc("��ϵ:�Լ�", "����:����������", "��ɫ����<10") ~= 0 then
		CastX("�򽣹���")
	end
	
	--�����޽�
	if v["����ʱ��"] > 0 and qidian() >= 6 then
		if v["����ʱ��"] < 12 then
			CastX("�����޽�")
		end
	end

	--�˽�������
	if rela("�ж�") and dis() < 6 and v["���ǳ�"] ~= 0 and v["������"] ~= 0 then
		if v["������"] == 0 and v["���ǳ�CD"] < cdinterval(16) then
			CastX("�˽���һ")
		end
	end

	--�����޽�
	if v["����ʱ��"] > 0 and qidian() >= 6 then
		CastX("�����޽�")
	end

	--������
	if v["������"] == 0 then
		CastX("������")
	end

	--������
	if fight() and mana() < 0.4 then
		if CastX("������", true) then
			stopmove()
		end
	end

	--�˻Ĺ�Ԫ
	CastX("�˻Ĺ�Ԫ")

	--û���������Ϣ
	if fight() and rela("�ж�") and dis() < 6 and cdleft(16) <= 0 and castleft() <= 0 and gettimer("������") > 0.3 and gettimer("���ǳ�") > 0.3 and gettimer("��̫��") > 0.3 and gettimer("������") > 0.3 and state("վ��|��·|�ܲ�|��Ծ") then
		PrintInfo("----------û����, ")
	end
end

--�����Ϣ
function PrintInfo(s)
	if not v["�����Ϣ"] then return end
	local szinfo = "����:"..v["����"]..", ����:"..v["���в���"]..", "..v["����ʱ��"]..", ����:"..v["����ʱ��"]..", ����:"..v["���Ų���"]..", "..v["����ʱ��"]..", ����CD:"..v["����CD"]..", ���ǳ�CD:"..v["���ǳ�CD"]..", �˽�CD:"..v["�˽�CD"]..", ��CD:"..v["��CD"]..", ���ǳ�CD:"..v["���ǳ�CD"]..", ������CD:"..v["������CD"]
	if s then
		szinfo = s..szinfo
	end
	print(szinfo)
end

--ʹ�ü��ܲ������Ϣ
function CastX(szSkill, bSelf)
	if cast(szSkill, bSelf) then
		settimer(szSkill)
		PrintInfo()
		return true
	end
	return false
end

--ս��״̬�ı�
function OnFight(bFight)
	if bFight then
		print("--------------------����ս��")
	else
		print("--------------------�뿪ս��")
	end
end
