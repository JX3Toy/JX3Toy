output("��Ѩ: [�׺�][�Ĺ�][������][��Ԫ][ͬ��][�Ͳ�][����][����][����][����][�ع�][�̱�]")

--������
local v = {}
v["�ȴ������ͷ�"] = false
v["����"] = qidian()

function Main(g_player)
	--�ȴ������ͷ�
	if casting("�����ֻ�") and castleft() < 0.13 then
		v["�ȴ������ͷ�"] = true
		settimer("�����ֻض�������")
	end
	if v["�ȴ������ͷ�"] and gettimer("�����ֻض�������") < 0.3 then
		return
	end

	if qixue("����") then
		cast("��ɽ��")
	end

	--�Լ���Χ�Լ����Ʋ��
	local pcqdist, pcqtime = qc("�����Ʋ��", id(), id())

	--Ŀ��5���Լ�������
	v["Ŀ��5���Լ�������"] = tnpc("��ϵ:�Լ�", "ģ��ID:58295", "����<5")

	--��������
	if rela("�ж�") and dis() < 19 and tstate("վ��|������|ѣ��|����|����|����") then
		if pcqdist < -5 and pcqtime > 10 and qjcount() >= 5 and bufftime("����") > 10 and v["Ŀ��5���Լ�������"] ~= 0 and gettimer("�ͷ����϶���") < 2 then
			cast("��������")
		end
	end
	
	--���Լ��Ʋ��
	if rela("�ж�") and dis() < 20 then
		if pcqdist > -1 then		--û���Ʋ����߿��Ȧ��, �������Լ���������Ե�ľ��룬��Ȧ������������Ȧ���Ǹ���
			cast("�Ʋ��", true)
		end
	end

	--���ǻ���
	if v["����"] >= 9 then
		cast("���ǻ���")
	end

	--��������
	if qjcount() < 5 then
		cast("��������")
	end

	--���϶���
	if rela("�ж�") and tstate("վ��|������|ѣ��|����|����|����") then
		cast("���϶���")
	end

	--������
	if fight() and mana() < 0.4 then
		cast("������", true)
	end

	--�����ֻ�
	if v["����"] <= 7 then
		cast("�����ֻ�")
		cast("̫���޼�")
	end

	if nobuff("��������") then
		cast("��������")
	end
end


--�������
OnQidianUpdate = function()
	v["����"] = qidian()
end


--�ͷż���
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		--����
		if SkillID == 367 then
			v["�ȴ������ͷ�"] = false
		end
		--����
		if SkillID == 18668 then
			settimer("�ͷ����϶���")
		end
	end
end
