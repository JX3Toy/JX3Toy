output("----------����----------")
output("2 2 3")
output("3 2 1 2")
output("3 1 1 1")
output("3 0 2")
output("2 3")
output("1")
output("0 3 1")


--������
local v = {}

--����
function JianShang()
	if fight() and gettimer("Х�绢") > 0.5 and gettimer("��") > 0.5 and gettimer("����ɽ") > 0.5 and nobuff("Х�绢|��|����ɽ") then
		if cast("Х�绢") then
			settimer("Х�绢")
			return
		end

		if rela("�ж�") and ttid() == id() then
			if dis() < 4 or (tcasting() and tcastleft() < 1) then		--����С��4�� �� ����ʣ��ʱ��С��1��
				if cast("��") then
					settimer("��")
					return
				end
			end
		end

		if life() < 0.5 and buffstate("����Ч��") < 45 then
			if cast("����ɽ") then
				settimer("����ɽ")
				return
			end
		end

		if life() < 0.4 then
			cast("������")
			return
		end
	end
end

--��ѭ��
function Main(g_player)
	
	if nobuff("������") then
		cast("������", true)
	end

	if rela("�ж�") then
		if ttid() ~= 0 and ttid() ~= id() then		--Ŀ����Ŀ�꣬�����Լ�
			cast("����")
		end

		if dis() < 4 and mana() < 0.4 then
			cast("������")
		end
	end

	if cdtime("����") > 5 then
		cast("�����")
	end

	--���
	if tbuffstate("�ɴ��") and tcastleft() < 1 then
		cast("��")
	end

	--Ԩ
	if map("Ӣ�۷�����") then
		if life() > 0.7 then
			xcast("Ԩ", party("buffʱ��:��������>5"))		--������_��������_��Ѫ��_��������
		end
	end
	if fight() and life() > 0.8 then
		xcast("Ԩ", party("û״̬:����", "����<20", "��Ѫ<0.4", "�ڹ�:�뾭�׵�|�����ľ�|�����|��֪|����", "���߿ɴ�"))		--��Ѫ������
	end

	--����
	JianShang()


	_, v["Ŀ����Χ��������"] = tnpc("��ϵ:�ж�", "����<8", "��ѡ��")
	if v["Ŀ����Χ��������"] >= 2 then
		cast("��")
	end
	cast("��")
	cast("�Ʒ�")
end
