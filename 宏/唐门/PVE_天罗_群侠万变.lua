--[[ ��Ѩ:[ѪӰ����][��缳��][�������][ǧ��֮��][���޵���][�۾�����][��Ѫ����][�׼�����][���ɢӰ][�س�����][��ɫ�ߺ�][ǧ�����]
�ؼ�:
����	1���� 2�˺� 1Ч��
ʴ����	2���� 2�˺�
���	3�˺� 1��Χ
����	1���� 3�˺�
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
	--�������
	if gettimer("����") < 0.5 or gettimer("�ͷŹ�") < 2 or casting("����") then
		return
	else
		nomove(false)		--�����ƶ�
	end

	--����
	if fight() and life() < 0.5 then
		cast("��������")
	end

	--��ʼ������
	v["���ֵ"] = energy()
	v["ǧ��CD"] = scdtime("ǧ�����")
	v["ǧ�����CD"] = scdtime("ǧ����١�����")
	v["ǧ��ʱ��"] = bufftime("ǧ�����")
	v["����CD"] = scdtime("����ɱ��")
	v["���CD"] = scdtime("�������")
	v["GCD"] = cdleft(16)
	local tSpeedXY, tSpeedZ = speed(tid())
	v["Ŀ�꾲ֹ"] = rela("�ж�") and tSpeedXY <= 0 and tSpeedZ <= 0
	v["Ŀ��Ѫ���϶�"] = rela("�ж�") and tlifevalue() > lifemax() * 10
	
	--Ŀ�겻�ǵж�, ����
	if not rela("�ж�") then return end

	--����
	if dis() < 20 then
		if nopuppet() or xxdis(pupid(), tid()) > 25 then		--û����������Ŀ�곬��25��
			CastX("ǧ����", true)
		end

		--����
		if puppet("����ǧ�������|����ǧ��������") then
			CastX("������̬")
		end

		--ʱ��쵽�ˣ�������
		if puppet("����ǧ��������") and gettimer("�ͷ�����") > 116.5 then
			CastX("������̬")
		end
	end

	--����������
	if getopt("����������") and dungeon() and nofight() then return end

	--�󹥻�
	if puppet("����ǧ��������|����ǧ��������") and puptid() ~= tid() and xxdis(pupid(), tid()) < 25 and xxvisible(pupid(), tid()) then
		CastX("����")
	end

	--����ɱ��
	CastX("����ɱ��")

	--ǧ�����
	if bufftime("ǧ�����") > 0 then
		CastX("ǧ����١�����")
	end

	--���ް󶨹�
	if gettimer("�ͷŹ�") < 5 or bufftime("����") > 13 then
		CastX("��������")
	end

	--��
	if not getopt("�ֶ�����") and puppet("����ǧ��������") and xdis(pupid()) < 4 and gettimer("�ͷ�����") < 100 then	--���ʣ��ʱ�����20��
		if v["Ŀ�꾲ֹ"] and v["Ŀ��Ѫ���϶�"] and xxdis(pupid(), tid()) < 25 and v["ǧ��CD"] < 4 then
			if CastX("����") then
				stopmove()			--ֹͣ�����ƶ�
				nomove(true)		--��ֹ�ƶ�
				exit()				--�жϽű�ִ��
			end
		end
	end

	--ǧ�����
	CastX("ǧ�����")

	--��Ůɢ�� ��dot
	if tnobuff("��Ѫ", id()) then
		CastX("��Ůɢ��")
	end

	--ͼ��ذ��
	_, v["����ɱ������"] = tnpc("��ϵ:�Լ�", "ģ��ID:16000", "ƽ�����<6")
	if v["����ɱ������"] >= 3 then
		CastX("ͼ��ذ��")
	end

	--�������
	if v["Ŀ�꾲ֹ"] then
		CastX("�������")
	end

	--��Ůɢ�� Ⱥ��
	_, v["Ŀ��10�ߵ�������"] = tnpc("��ϵ:�ж�", "����<10", "��ѡ��")
	if v["Ŀ��10�ߵ�������"] >= 3 then
		CastX("��Ůɢ��")
	end

	--�����滨��
	if v["ǧ��CD"] >= 2 then
		if gettimer("ǧ����١�����") < 0.5 or v["ǧ�����CD"] >= 2 or v["ǧ�����CD"] >= v["ǧ��ʱ��"] then
			CastX("�����滨��")
		end
	end

	--ʴ����
	if v["ǧ��CD"] >= 1 and v["����CD"] > 0.5 then
		if gettimer("ǧ����١�����") < 0.5 or v["ǧ�����CD"] >= 1 or v["ǧ�����CD"] >= v["ǧ��ʱ��"] then
			CastX("ʴ����")
		end
	end

	--��Ůɢ��
	if v["ǧ��CD"] > 1 then
		CastX("��Ůɢ��")
	end

	--û���������Ϣ
	if rela("�ж�") and fight() and dis() < 20 and cdleft(16) <= 0 and castleft() <= 0 and gettimer("ǧ����") > 0.3 and gettimer("�����滨��") > 0.3 and gettimer("ʴ����") > 0.3 then
		PrintInfo("----------û�ż���, ")
	end
end

--�����Ϣ
function PrintInfo(s)
	local szinfo = "���ֵ:"..v["���ֵ"]..", GCD:"..v["GCD"]..", ǧ��CD:"..v["ǧ��CD"]..", ǧ�����CD:"..v["ǧ�����CD"]..", ǧ��ʱ��:"..v["ǧ��ʱ��"]..", ����:"..bufftime("����")..", ��ǰ֡:"..frame()
	if s then
		szinfo = s..szinfo
	end
	print(szinfo)
end

--ʹ�ü��ܲ������Ϣ
function CastX(szSkill, bSelf)
	if cast(szSkill, bSelf) then
		settimer(szSkill)
		if v["�����Ϣ"] then PrintInfo() end
		return true
	end
	return false
end

--�ͷż���
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		if SkillID == 3368 then	--������̬
			settimer("�ͷ�����")
		end
		if SkillID == 3110 then
			settimer("�ͷŹ�")
		end
	end
end
