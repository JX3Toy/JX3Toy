--[[����
[����]2 [��β]3 [�޳�]2
[��Ļ]3 [����]2 [����]2
[����]2 [����]3 [����]1
[����]2 [����]3
[����]1 [�ҽ�]2 [��Ӱ]3 [����]1
[�Ƴ��]1
[�ɾ�]3
--]]
--�Ƽ�1�μ���
--������: ʥЫ, ����, ����, ����, ���, �̵�

--�ر��Զ�����
setglobal("�Զ�����", false)

--��ѡ��
addopt("����������", false)
addopt("���", false)

--������
local v = {}

--��ѭ��
function Main(g_player)
	--��������
	local mapName = map()
	local func = tMapFunc[mapName]
	if func then
		func(g_player)
	end

	--[[û��ս�����и�Ы��
	if nofight() and nopet("ʥЫ") then
		cast("ʥЫ��")
	end
	--]]
	
	--�ٳ���
	if nopet() then
		cast("������")
		cast("ʥЫ��")
	end

	--����
	if fight() then
		if life() < 0.2 then
			cast("����")
		end
		if life() < 0.6 and pet() then
			cast("��ˮ��")
		end
	end

	--Ŀ�겻�ǵ���, ����
	if not rela("�ж�") then return end

	--����������
	if getopt("����������") and dungeon() and nofight() then return end

	if tbuff("����") then
		bigtext("Ŀ���޵�", 0.5)
		return
	end

	v["Ŀ��Ѫ���϶�"] = rela("�ж�") and tlifevalue() > lifemax() * 10		--Ŀ��Ѫ�������Լ����Ѫ��10��

	--�񱩸��ߣ����뵽�׼��м�
	if v["Ŀ��Ѫ���϶�"] and pet("����") and xxdis(petid(), tid()) < 4 and lasttime("�Ƴ��׼�") > 2 and lasttime("�Ƴ��׼�") < 10 then
		cast("�Ƴ��")
	end

	--�������
	if pet() then
		if v["Ŀ��Ѫ���϶�"] and dis() < 20 then
			if cdtime("������") < 2  or cdtime("ʥЫ��") < 2 then
				if cast("�Ƴ��׼�") then
					settimer("�Ƴ��׼�")
				end
			end
		end

		if gettimer("�Ƴ��׼�") > 0.5 then
			if pettid() ~= tid() then		--�����Ŀ�겻���Լ���Ŀ��
				cast("����")
			end
			cast("�û�")

			if getopt("���") and xxdis(petid(), tid()) < 5.5 then
				cast("���")
			end
		end
	end

	--Ŀ���в����Լ��Ķ�����, ������������
	if tbufftime("������") > 16 and tnobuff("������", id()) then
		cast("�ݲй�")
		cast("���Ĺ�")
	end
	cast("������")

	if tnobuff("����", id()) then
		cast("����")
	end

	if tbufftime("��Ӱ", id()) < 3 then
		cast("��Ӱ")
	end
	
	if tnobuff("�Х", id()) then
		cast("�Х")
	end

	cast("Ы��")
	cast("ǧ˿")
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
	if gettimer("Ŀ���������") < 1 or tbuff("4147") then	--���� �����˺�
		stopcasting()
		exit()
	end
end
