output("��Ѩ: [�Ĺ�][����][������][����][����][����][����][����][�ʳ�][����][�鼫][����]")

--������
local v = {}

--��ѭ��
function Main(g_player)

	if nofight() and nobuff("��������") then
		cast("��������")
	end

	--����
	if fight() and life() < 0.5 and buffstate("����Ч��") < 38 and gettimer("��������") > 0.5 and gettimer("תǬ��") > 0.5 then
		if cast("��������") then
			settimer("��������")
			return
		end
		if cast("תǬ��") then
			settimer("תǬ��")
			return
		end
	end

	if casting("���ǳ�") and castleft() < 0.13 then
		settimer("���ǳ���������")
	end

	--Ŀ�겻�ǵжԣ�ֱ�ӽ���
	if not rela("�ж�") then return end


	--����
	if dis() < 6 and nobuff("��������") and gettimer("���ǳ���������") < 1 and bufftime("14983") > 5 and bufftime("14984") > 5 then
		if cast("��������") then
			cast("ƾ������")
		end
	end

	--���
	if dis() < 6 and tbuffstate("�ɴ��") then
		cast("�򽣹���")
	end

	
	_, v["��������"] = npc("��ϵ:�Լ�", "����:������̫��|�������ǳ�|����������", "����<13")
	v["������"] = npc("��ϵ:�Լ�", "����:����������", "����<15")
	v["���ǳ�"] = npc("��ϵ:�Լ�", "����:�������ǳ�", "����<13")


	--�˽�
	if dis() < 5 and v["��������"] >= 3 and v["������"] == 0 and cdtime("���ǳ�") < 2 then
		cast("�˽���һ")
	end

	if v["���ǳ�"] == 0 or gettimer("�ͷ��˽���һ") < 2 then
		cast("���ǳ�")
	end


	if tbuffsn("����", id()) < 7 then
		if qidian() >= 8 then
			cast("�����޽�")
		end
	end

	cast("��������")

	if v["��������"] < 3 then
		cast("������")
		cast("��̫��")
	end

	if qidian() >= 6 then
		cast("�����޽�")
	end

	if mana() < 0.3 then
		cast("������", true)
	end

	_, v["��Χ8�ߵж�����"] = npc("��ϵ:�ж�", "����<8", "��ѡ��")
	if v["��Χ8�ߵж�����"] >= 3 then
		cast("�򽣹���")
	end

	cast("�˻Ĺ�Ԫ")
end


function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	--����ͷż��ܵ����Լ�
	if CasterID == id() then
		if SkillID == 588 then
			settimer("�ͷ��˽���һ")
		end
	end
end
