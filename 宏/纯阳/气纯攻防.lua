output("��Ѩ: [����][�¹�����][��һ][��Ԫ][����][�Ͳ�][����][����][˪��][����][�ع�][����]")

--�����
load("Macro/Lib_PVP.lua")

--������
local v = {}

--������
local f = {}

--��ѭ��
function Main(g_player)
	--��ʼ��
	g_func["��ʼ��"]()

	--ѡĿ��
	f["�л�Ŀ��"]()

	--��ɽ��
	if fight() and life() < 0.5 and height() < 3 then
		if nobuff("��ɽ��") and gettimer("��ɽ��") > 1 then
			if cast("��ɽ��", true) then
				settimer("��ɽ��")
				stopmove()
			end
		end
	end

	--ƾ������
	if fight() and life() < 0.75 then
		cast("ƾ������")
	end

	--��������
	if rela("�ж�") and g_var["Ŀ��û����"] and dis() < 20 and qidian() <= 3 and qjcount() >= 5 and bufftime("����") > 10 then
		if nobuff("��������") and gettimer("��������") > 0.3 then
			if cast("��������") then
				settimer("��������")
			end
		end
	end

	--��̫��
	v["��̫������"], v["��̫��ʱ��"] = qc("������̫��", id(), id())
	if v["��̫������"] > -1 or v["��̫��ʱ��"] < 1 then
		cast("��̫��", true)
	end

	--��������
	if nobuff("��������") then
		cast("��������")
	end

	if g_var["Ŀ��ɹ���"] then
		if qidian() >= 8 then
			cast("���ǻ���")
		end
	end

	if qjcount() < 5 then
		cast("��������")
	end

	if g_var["Ŀ��ɹ���"] then
		cast("�����ֻ�")
		cast("̫���޼�")
	end

	--�ɼ�������Ʒ
	if nofight() then
		g_func["�ɼ�"](g_player)
	end
end

f["�л�Ŀ��"] = function()
	v["20���ڵ���"] = enemy("����<20", "���߿ɴ�", "û�ؾ�", "��Ѫ����")
	if v["20���ڵ���"] ~= 0 then
		--ûĿ����ǵж�
		if not rela("�ж�") then
			settar(v["20���ڵ���"])
			return
		end
		
		--��ǰĿ�����
		if tstate("����") then
			settar(v["20���ڵ���"])
			return
		end
		
		--����̫Զ
		if dis() > 20 then
			settar(v["20���ڵ���"])
			return
		end
		
		--���߲��ɴ�
		if tnovisible() then
			settar(v["20���ڵ���"])
			return
		end
		
		--�ȵ�ǰĿ��Ѫ����
		if tlife() > 0.3 and xlife(v["20���ڵ���"]) < tlife() then
			settar(v["20���ڵ���"])
			return
		end
	end
end
