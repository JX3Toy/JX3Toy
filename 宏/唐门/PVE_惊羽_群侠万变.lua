--[[ ��Ѩ: [��������][ǧ���޺�][����ҹ��][����][��籩��][�۾�����][��һ����][�滨����][���ɢӰ][��������][��������][����׷��]
�ؼ�:
����  1���� 2�˺� 1Ч��
����  2���� 1�˺� 1����
׷��  2��Ϣ 2Ч��(����20%�⹦���� �˺����20$)
����  1Ч��(10���) 3�˺�
����  1��Ϣ 2�˺� 1����
--]]

--�ر��Զ�����
setglobal("�Զ�����", false)

--������
local v = {}
v["����Ŀ��"] = 0

--������
local f = {}

--��ѭ��
function Main(g_player)
	--����
	if fight() and life() < 0.5 then
		cast("��������")
	end

	--�ȴ����������ͷ� buffͬ��
	if casting("���Ǽ�") and castleft() < 0.13 then
		settimer("���Ƕ�������")
	end
	if gettimer("���Ƕ�������") < 0.3 then return end

	if casting("�����滨��") and castleft() < 0.13 then
		settimer("�����������")
	end
	if gettimer("�����������") < 0.35 then return end

	if casting("������") and castleft() < 0.13 then
		settimer("�������������")
	end
	if gettimer("�������������") < 0.3 then return end
	
	--��ʼ������
	local speedXY, speedZ = speed(tid())
	v["Ŀ�꾲ֹ"] = rela("�ж�") and speedXY <= 0 and speedZ <= 0
	v["���ֵ"] = energy()
	v["ע��"] = bufflv("26055")	--�ϴδ����ע�ܼ���
	v["Ŀ��Ѫ���϶�"] = rela("�ж�") and tlifevalue() > lifemax() * 5

	--����
	if v["Ŀ�꾲ֹ"] and v["Ŀ��Ѫ���϶�"] and dis() < 25 and cdleft(16) < 0.5 and scdtime(18672) < 15 then		--18672 ����һ��
		cast("��������")
	end

	--���ֱ���
	if nobuff("����") then
		f["�����滨��"]()
	end

	--������
	v["Ŀ�괩��ʱ��"] = tbufftime("����", id())
	if v["Ŀ�괩��ʱ��"] > cdinterval(16) + 0.2 and v["Ŀ�괩��ʱ��"] < 5 then
		f["������"]()
	end
	
	f["�������"]()
	f["����һ��"]()

	f["׷����"]()

	if bufftime("��������") > casttime("�����滨��") or v["���ֵ"] >= 70 then
		f["�����滨��"]()
	end

	if v["���ֵ"] >= 70 then
		if tbuffsn("����", id()) < 3 or v["Ŀ�괩��ʱ��"] < 8.5 then
			f["������"]()
		end
	end
	
	f["���Ǽ�"]()
	f["�����滨��"]()
	f["���Ǽ�"]()
	f["������"]()
end

f["����һ��"] = function()
	if v["Ŀ�꾲ֹ"] then
		if cast(18672) then
			v["����Ŀ��"] = tid()	--��¼һ��Ŀ��
		end
	end
end

f["�������"] = function()
	if casting("����׷��") and v["����Ŀ��"] ~= 0 then
		local speedXY, speedZ = speed(v["����Ŀ��"])
		if speedXY > 0 or speedZ > 0 then	--Ŀ�궯�˴����
			cast(18673)
		end
	end
end

f["�����滨��"] = function()
	if v["ע��"] ~= 6 then
		cast("�����滨��")
	end
end

f["׷����"] = function()
	if buff("׷������") and v["ע��"] ~= 1 then
		cast("׷����")
	end
end

f["���Ǽ�"] = function()
	if buff("��������") and v["ע��"] ~= 5 then
		cast("���Ǽ�")
	end
end

f["������"] = function()
	if v["ע��"] ~= 4 then
		cast("������")
	end
end

f["���Ǽ�"] = function()
	if v["ע��"] ~= 3 then
		cast("���Ǽ�")
	end
end

--�ͷż���
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	--����ͷż��ܵ����Լ�
	if CasterID == id() then
		if SkillID == 3095 then		--���Ǽ�
			deltimer("���Ƕ�������")
			return
		end
		if SkillID == 3098 then		--������
			deltimer("�������������")
			return
		end
	end
end

--buff����
function OnBuff(CharacterID, BuffName, BuffID, BuffLevel, StackNum, SkillSrcID, StartFrame, EndFrame, FrameCount)
	if CharacterID == id() then
		if StackNum > 0 and BuffID == 25901 then	--���buff ��������
			deltimer("�����������")
		end
	end
end
