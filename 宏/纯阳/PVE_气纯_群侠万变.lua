--[[ ��Ѩ: [�׺�][˪��][������][��Ԫ][ͬ��][�Ͳ�][����][����][����][����][�ع�][�̱�]
�ؼ�:
�Ʋ��  1���� 3��Χ
����  2���� 2����
����  1���� 2�˺� 1Ч��
̫��  1���� 3�˺�
����  3�˺� 1���Ļ�����
����  2��Ϣ 1��Ѫ�� 1����
ƾ��  2��Ϣ 1������ 1���ܻ�Ѫ
--]]

--�ر��Զ�����
setglobal("�Զ�����", false)

-- ������
local v = {}

--������
local f = {}

--��ѭ��
function Main(g_player)
	--����
	if fight() and life() < 0.5 and nobuff("��������") then
		cast("��������")
	end

	if casting("���϶���") and castleft() < 0.13 then
		settimer("���϶�������")
	end
	if casting("�Ʋ��") and castleft() < 0.13 then
		settimer("�Ʋ���������")
	end

	if casting("�����ֻ�") and castleft() < 0.13 then
		settimer("�ȴ�����ͬ��")
	end
	if gettimer("�ȴ�����ͬ��") < 0.3 then return end

	--��ʼ������
	v["����"] = qidian()
	local tSpeedXY, tSpeedZ = speed(tid())
	v["Ŀ�꾲ֹ"] = rela("�ж�") and tSpeedXY <= 0 and tSpeedZ <= 0		--Ŀ��û�ƶ�
	v["�Ʋ�����"], v["�Ʋ��ʱ��"] = qc("�����Ʋ��", id(), id())		--�Լ������Լ�������, �������Լ���������Ե�ľ��룬��Ȧ������������Ȧ���Ǹ���
	v["Ŀ��λ���Լ�������"] = tnpc("��ϵ:�Լ�", "ģ��ID:58295", "ƽ�����<5")
	v["Ŀ��Ѫ���϶�"] = rela("�ж�") and tlifevalue() > lifemax() * 5	--Ŀ�굱ǰѪ�������Լ����Ѫ��5��


	--��ɽ��
	if qixue("����") then
		cast("��ɽ��", true)
	end

	--����
	if v["Ŀ�꾲ֹ"] and v["Ŀ��Ѫ���϶�"] and dis() < 20 then
		if v["�Ʋ�����"] < -3 and v["�Ʋ��ʱ��"] > 10 then
			if v["Ŀ��λ���Լ�������"] ~= 0 and gettimer("�ͷ�����") < 2 then
				if cast("��������") then
					cast("ƾ������")
					settimer("��������")
				end
			end
		end
	end

	--����
	if qixue("����") and v["Ŀ�꾲ֹ"] and dis() < 5 and face() < 60 and f["û����"]() and scdtime("��������") > 5 and cdleft(16) >= 0.5 then
		if cast("���Ż���") then
			settimer("���Ż���")
		end
	end

	--����һ��
	if rela("�ж�") and dis() < 25 and qjcount() < 5 then
		cast(18640)
	end

	--�Ʋ��
	if rela("�ж�") and dis() < 25 and v["�Ʋ�����"] > -1 then	--û���Ʋ����߿��Ȧ��
		cast("�Ʋ��", true)
	end

	--��������
	if buff("12504|12783") then
		if bufftime("����") < 3.75 then
			cast(18654)
		end

		--[[��������ǰ�Ŷ���?
		if scdtime("���϶���") < cdinterval(16) and scdtime("��������") < cdinterval(16) * 2 then
			cast(18654)
		end
		--]]
		
		--[[���㲻�����ǣ�����һ��CDС��һ��GCD������Σ�ʵս�����Ƿ�������
		if gettimer("�ͷŷɽ�") < 1 and scdtime(18640) < cdinterval(16) and v["����"] < 7 then
			cast(18654)
		end
		--]]
	end

	--����
	if gettimer("���϶�������") > 0.25 and v["Ŀ�꾲ֹ"] then
		if scdtime("��������") < cdinterval(16) then
			if v["�Ʋ�����"] < -3 and v["�Ʋ��ʱ��"] > 12 then
				cast("���϶���")
			end
		end

		if scdtime("��������") > 10 then
			cast("���϶���")
		end
	end

	--����
	if v["����"] >= 7 then
		cast("���ǻ���")
	end

	--���Ʋ��
	if rela("�ж�") and dis() < 25 and scdtime("���϶���") < cdinterval(16) and scdtime("��������") < cdinterval(16) * 2 and v["�Ʋ��ʱ��"] < 12 then
		cast("�Ʋ��", true)
	end

	--������
	if fight() and mana() < 0.4 and state("վ��") then
		cast("������", true)
	end

	--����
	if gettimer("���϶�������") > 0.5 then
		if f["������"]() then
			if v["����"] < 5 then
				cast("�����ֻ�")
			end
		else
			cast("�����ֻ�")
		end
	end

	if nofight() and nobuff("��������") then
		cast("��������")
	end
end

f["û����"] = function()
	if buff("��������") or gettimer("��������") < 0.5 or gettimer("���Ż���") < 0.5 then
		return false
	end
	return true
end

f["������"] = function()
	if buff("��������") or gettimer("��������") < 0.5 or gettimer("���Ż���") < 0.5 then
		return true
	end
	return false
end

--�������
function OnQidianUpdate()
	deltimer("�ȴ�����ͬ��")
end

--�ͷż���
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		if SkillID == 18667 then
			settimer("�ͷŷɽ�")
			return
		end
		if SkillID == 18668 then
			settimer("�ͷ�����")
			return
		end
	end
end
