output("��Ѩ: [���][����][��Į][��Ԧ][�۳�][����][�绢][ս��][Ԩ][ҹ��][��Ѫ][����]")

--������
local v = {}

--��ѭ��
function Main(g_player)

	--����
	if fight() then
		cast("Х�绢")

		if life() < 0.55 then
			cast("����ɽ")
		end
	end

	--Ŀ�겻�ǵж�, ����
	if not rela("�ж�") then return end

	--Ԩ
	v["Ŀ�긽������"] = tparty("û״̬:����", "�����Լ�", "����>6", "����<20", "�����ڹ�:ϴ�辭|������|����������|������", "���߿ɴ�", "�������")
	--if v["Ŀ�긽������"] ~= 0 and bufftime("�۳�") > 10 then
	if v["Ŀ�긽������"] ~= 0 then
		xcast("Ԩ", v["Ŀ�긽������"])
	end

	--ͻ
	if bufftime("����") < 38 then
		cast("ͻ")
	end

	--������
	if rela("�ж�") and dis() < 8 then
		cast("������", true)
	end

	--�γ۳�
	if nobuff("�۳�") and cn("�γ۳�") > 0 then
		if cdleft(16) > 1 and bufftime("����") < 1 then
			cbuff("����")
		end

		if bufftime("����") > 38 then
			cast("�γ۳�")
		end
	end

	if rage() >= 5 then
		cast("����")
	end

	cast("����")

	if rage() <= 2 then
		cast("��")
	end

	cast("����")
end
