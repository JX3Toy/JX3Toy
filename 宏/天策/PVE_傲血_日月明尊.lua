--[[����
[��ˮ]2 [���]3 [�ܻ�]1
[���]3 [����]2 [����]2 [����]2
[Ӣ��]2 [����]3 [�ɽ�]1
[����]3 [ҹ��]2 [��¥��]1
[����]2
[����]1
[��ϸ]2 [����]3
[�ֻ�]1
--]]

--�ر��Զ�����
setglobal("�Զ�����", false)

--���ѡ��, ������û��ս���ż���, Ĭ�Ϲر�
addopt("����������", false)

--������
local v = {}

--������
local f = {}

--��ѭ��
function Main()
	--����
	f["����"]()

	--����������
	if getopt("����������") and dungeon() and nofight() then return end

	--���
	if tbuffstate("�ɴ��") and tcastleft() < 1 then
		cast("��")
	end

	v["Ŀ��Ѫ���϶�"] = tlifevalue() > lifemax() * 5		--Ŀ�굱ǰѪ�������Լ����Ѫ��5��

	if rela("�ж�") and dis() < 4 and v["Ŀ��Ѫ���϶�"] and cdleft(16) < 0.5 then
		--������
		if fight() and cdleft(16) < 0.5 then
			if life() < 0.8 or mana() < 0.8 then
				cast("������")
			end
		end
		
		--�ͻ���ɽ
		cast("�ͻ���ɽ")

		--�����
		if bufftime("����") > 3 then
			cast("�����")
		end

		--������
		if bufftime("��ˮ") > 3 then
			cast("������")
		end
	end

	--����Ѫ
	if tbuff("�²�", id()) then
		if tnobuff("��Ѫ", id()) then
			cast("�Ʒ�")
		end

		if tbuff("��Ѫ", id()) then
			cast("��")
		end
	end

	--[[
	if buffsn("����") >= 5 and bufftime("����") > 6 and tbufftime("��Ѫ", id()) > 6 then
		cast("����")	
	end
	--]]

	cast("����")
	cast("����")
	cast("����")

	cast("����")


	--Ԩ
	v["�ʺ�Ԩ�Ķ���"] = tparty("û״̬:����", "�����ڹ�:ϴ�辭|������|����������|������", "����>10", "����<25", "�Լ�����>6", "�Լ�����<20")
	if rela("�ж�") and cdtime("ͻ") < 0.5 and nobuff("����") and gettimer("��ҡֱ��") > 0.5 then
		if cdleft(16) > 1 or cdleft(16) <= 0 then
			if v["�ʺ�Ԩ�Ķ���"] ~= 0 then
				xcast("Ԩ", v["�ʺ�Ԩ�Ķ���"])
			end
		end
	end

	--ͻ
	if state("��Ծ") then
		cast("ͻ")
	end

	--��
	if rela("�ж�") and dis() < range("ͻ") and cdtime("ͻ") < 0.5 and nostate("��Ծ") then
		local bJump = false
		if dis() > 8 then
			bJump = true
		end
		if buff("����") and (cdleft(16) > 1 or cdleft(16) <= 0) then
			bJump = true
		end
		if bJump then
			jump()
			settimer("��")
		end
	end

	--��ҡ
	if rela("�ж�") and gettimer("��") > 0.5 and dis() < 8 then
		if v["�ʺ�Ԩ�Ķ���"] == 0 or cdtime("Ԩ") > 1 then
			if cast("��ҡֱ��") then
				settimer("��ҡֱ��")
			end
		end
	end

end

--����
f["����"] = function()
	--û��ս���ü��˼���
	if nofight() then return end

	--Х�绢
	cast("Х�绢")

	--��
	if gettimer("����ɽ") > 0.3 and nobuff("����ɽ") and rela("�ж�") and ttid() == id() then
		if dis() < 4 or (tcasting() and tcastleft() < 1) then		--����С��4�� �� ����ʣ��ʱ��С��1��
			if cast("��") then
				settimer("��")
				return
			end
		end
	end

	--����ɽ
	if gettimer("��") > 0.3 and nobuff("��") then
		if life() < 0.5 then
			if cast("����ɽ") then
				settimer("����ɽ")
				return
			end
		end
	end
end
