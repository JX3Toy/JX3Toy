--������ְ���
--��Ѩ: [����][ȡ��][�޳�][�̷�][��Ե][���سɷ�][����][������][����][����][����][Ħ��]

--�����
load("Macro/Lib_PVP.lua")

--������
local v = {}

--��ѭ��
function Main(g_player)

	if fight() then
		if life() < 0.3 then
			cast("�͹Ǿ�")
		end

		if nobuff("�����") and life() < 0.7 then
			cast("���������ɫ")
		end
	end

	if rela("�ж�") and dis() < 5 and qidian() < 2 then
		cast("������")
	end

	if qidian() >= 3 then
		cast("�޺�����")
		cast("Τ������")
	end

	if target("player") and tbuffstate("�ɻ���")  then
		cast("Ħڭ����")
	end

	--���������
	if cdtime("���������ɫ") > 15 then
		v["�����������"] = party("û״̬:����", "�����Լ�", "û�ؾ�", "���߿ɴ�", "�������")
		if v["�����������"] ~= 0 then
			xcast("�����", v["�����������"])
		end
	end

	if rela("�ж�") and dis() < 6 then
		cast("��ɨ����")
	end

	cast("�ն��ķ�")

	if nobuff("������") then
		cast("������")
	end

	if nofight() and nobuff("��Ϣ") then
		if life() < 0.95 or mana() < 0.95 then
			cast("����")
		end
	end

	--�ɼ�������Ʒ
	if nofight() then
		g_func["�ɼ�"](g_player)
	end

end
