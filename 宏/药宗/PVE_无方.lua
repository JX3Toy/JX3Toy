output("��Ѩ: [����][���][���][�龣][���][����][��ʹ][���][����][�Ϸ�][����][Ӧ����ҩ]")

--������
local v = {}
v["����Ŀ��"] = 0
v["���Ҵ���"] = 0

--������
local f = {}

f["ǧ֦����"] = function()
	if cast("ǧ֦����") then
		settimer("ǧ֦����")
	end
end

f["��ǧ֦����"] = function()
	return buff("ǧ֦����") or gettimer("ǧ֦����") < 1
end

--��ѭ��
function Main(g_player)

	v["���Ҳ���"] = tbuffsn("����", id())
	if v["����Ŀ��"] ~= 0 and tid() == v["����Ŀ��"] then		--�����ҵ�Ŀ��buff��ûͬ�������Ӳ���
		v["���Ҳ���"] = v["���Ҳ���"] + v["���Ҵ���"]
	end
	if v["���Ҳ���"] > 8 then
		v["���Ҳ���"] = 8
	end

	v["����ʱ��"] = tbufftime("����", id())
	v["���д���"] = buffsn("24469")
	v["ҩ�Ծ���ֵ"] = math.abs(yaoxing())
	v["�ǵж�û�ƶ�"]  = rela("�ж�") and tstate("վ��|������|ѣ��|����|����|����")

	---------------------------------------------������

	--��Ұ����, ��һ��������
	if dis() < 6 and cdtime("������ѩ") <= 0 then	--�ܴ�����
		if cast("��Ұ����") then
			settimer("��Ұ����")
		end
	end

	if buff("24458") or gettimer("��Ұ����") < 1 then
		f["ǧ֦����"]()
	end

	--������ѩ, 6��, ûGCD, 10��CD, 
	cast("������ѩ")

	--��Ҷ����, ûGCD, ����180, 10��, 1 ����
	if face() < 180 and dis() < 10 and v["���Ҳ���"] >= 8 then
		if buff("20071") then
			f["ǧ֦����"]()
		end
		if f["��ǧ֦����"]() then
			cast("��Ҷ����")
		end
	end
	
	--��������, 20��CD, ����120, 6��, 1 ����
	if face() < 120 and dis() < 6 and v["���Ҳ���"] >= 8 then
		if cdtime("��������") < 0.5 then
			f["ǧ֦����"]()
		end
		if f["��ǧ֦����"]() then
			cast("��������")
		end
	end

	--�Ҵ�ʱ��, 4 ����
	if dis() < 13 and v["���Ҳ���"] >= 4 and v["����ʱ��"] >= casttime("�Ҵ�ʱ��") + 0.1 and (v["���д���"] < 1 or v["ҩ�Ծ���ֵ"] >= 5) then
		if cdtime("�Ҵ�ʱ��") < 0.5 then
			f["ǧ֦����"]()
		end
		
		if f["��ǧ֦����"]() then
			cast("�Ҵ�ʱ��")
		end
	end

	--��������, 10��CD, 2.5������, 4 ����, 1 ����
	if bufftime("���") < 3 then
		cast("��������")
	end
	
	---------------------------------------------

	--մ��δ��, 20��CD,  5 ����
	if scdtime("�Լ�����") > 20 then
		cast("մ��δ��")
	end

	--�Լ�����
	if cast("�Լ�����") then
		cast("մ��δ��")
	end

	--��Ҷ����
	if v["�ǵж�û�ƶ�"] then
		cast("��Ҷ����")
	end


	--��Ұ����

	--���Ƕϳ�, 1 ����
	if bufftime("��ʹ") < 2 then
		cast("���Ƕϳ�")
	end

	--��½׺��, 1 ���� (��ҩ�� 3 ����)
	cast("��½׺��")
end

--�ͷż���
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		--Ŀ��buffͬ����ʱ̫��, �����¼�����ҵ�Ŀ��
		if SkillID == 27560 then
			v["����Ŀ��"] = TargetID
			v["���Ҵ���"] = v["���Ҵ���"] + 1
		end
	end
end

--����buff�б�
function OnBuffList(CharacterID)
	--������µ����Լ������ҵ�Ŀ�꣬Ŀ��buff�Ѿ�ͬ��, ����Ŀ����Ϊ0, �����Ӳ���
	if CharacterID == v["����Ŀ��"] then
		v["����Ŀ��"] = 0
		v["���Ҵ���"] = 0
	end
end
