output("----------����----------")
output("2 2 3")
output("0 0 2 1")
output("1 1 3 2")
output("0 2 3 0")
output("0 3 3 0")
output("0 1")
output("2 0 3")
output("0 2 0 0")


--������
local v = {}
v["��ѩ����Ŀ��"] = 0

--��ѭ������, ÿ�����10+��
function Main(g_player)
	
	--����϶���
	if casting("��������|������ת") then return end
	if casting("��ѩƮҡ") and castprog() < 0.34 then return end

	--������
	if nobuff("����") then
		cast("�����ķ�", true)
	end

	--ս���в��õĸ�������
	if fight() then
		--����, �����
		if mana() < 0.83 then
			cast("������", true)
		end
		--�������10��
		if buffsn("����") < 3 then
			cast("������", true)
		end
		--����������
		if cdtime("������") > 20 and mana() < 0.6 then
			cast("������", true)
		end
		--����֦, ����20% 5��
	end

	if nofight() and nobuff("����") then
		cast("������", true)
	end

	--������Ŀ���ʼ��Ϊ�Լ�
	v["����Ŀ��"] = id()

	--�����Ŷ���Ѫ�����ٵĶ��ѣ�������Լ���Ѫ���ͣ��Ͱ�����Ŀ������Ϊ��
	v["Ѫ�����ٶ���"] = party("û״̬:����", "�����Լ�", "����<20", "���߿ɴ�", "��Ѫ����")
	if v["Ѫ�����ٶ���"] ~= 0 and xlife(v["Ѫ�����ٶ���"]) < life() then		--�ҵ��ˣ�����Ѫ��С���Լ���Ѫ��
		v["����Ŀ��"] = v["Ѫ�����ٶ���"]		--����Ŀ�������Ϊ��
	end

	--��ѩ����1�����Ŷ�
	if castprog() > 0.34 then
		v["�ϻ�ѩ"] = true
	end
	
	--��Ѫ��Ѫ��
	v["��Ѫ��"] = 0.5
	if xmount("ϴ�辭|������|����������|������", v["����Ŀ��"]) then
		v["��Ѫ��"] = 0.65		--��T�Ļ���Ѫ�߶���һ��
	end

	v["Ŀ��Ѫ��"] = xlife(v["����Ŀ��"])

	if v["Ŀ��Ѫ��"] < v["��Ѫ��"] then
		xcast("��ĸ����", v["����Ŀ��"], true)
		xcast("��������", v["����Ŀ��"], true)
		xcast("����Ͱ�", v["����Ŀ��"], true)
	end

	_, v["10���ڲ���Ѫ��������"] = party("û״̬:����", "����<10", "���߿ɴ�", "��Ѫ<0.65")
	if v["10���ڲ���Ѫ��������"] > 3 then
		fcast("������ת")
	end

	--����Ŀ���ǵ�ǰ���ڶ�����Ѫ��Ŀ��
	if casting("��ѩƮҡ") and v["����Ŀ��"] == casttarget() then
		return
	end

	if v["Ŀ��Ѫ��"] < 0.9 then
		if xbufftime("����", v["����Ŀ��"]) <= 0 then
			xcast("�������", v["����Ŀ��"], true)
		end
	end
	
	if v["Ŀ��Ѫ��"] < 0.8 then
		if xbufftime("��Ԫ����", v["����Ŀ��"]) <= 0 then
			xcast("��Ԫ����", v["����Ŀ��"], true)
		end
		xcast("��ѩƮҡ", v["����Ŀ��"], true)
	end

	

	--��T�ϳ���
	xcast("��Ԫ����", party("û״̬:����", "����<20", "�ڹ�:ϴ�辭|������|����������|������", "���߿ɴ�", "�ҵ�buffʱ��:��Ԫ����<0"))
	xcast("�������", party("û״̬:����", "����<20", "�ڹ�:ϴ�辭|������|����������|������", "���߿ɴ�", "�ҵ�buffʱ��:����<0"))

	--��T��������
	if party("�ҵ�buffʱ��:������>0") == 0 then		--�Ŷ���û���Լ��Ϲ�������Ķ���, ��������жϾͻ᲻ͣˢ������
		xcast("������", party("û״̬:����", "����<20", "�ڹ�:ϴ�辭|������|����������|������", "���߿ɴ�", "buffʱ��:������<0"))		--���������ϸ���û���������T
	end

	--[[��ս����
	if nofight() then
		xcast("��������", party("��״̬:����", "����<20", "���߿ɴ�"))
	end
	--]]
end

----------------------------------------------------------------�������ݼ�¼
local bLog = false

--�ж϶����Ƿ�Boss, Ѫ������100���NPC������Boss
local IsBoss = function(CharacterID)
	if CharacterID >= 0x40000000 and xlifemax(CharacterID) > 100 * 10000 then
		return true
	end
	return false
end

--�ͷż���
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if bLog and dungeon() and IsBoss(CasterID) then
		if TargetType == 2 then
			print("OnCast->["..xname(CasterID).."] �ͷ�:"..SkillName..", ����ID:"..SkillID..", ���ܵȼ�:"..SkillLevel..", Ŀ��λ��:"..TargetID.."|"..PosY.."|"..PosZ..", ��ʼ֡:"..StartFrame..", ��ǰ֡:"..FrameCount)
		else
			print("OnCast->["..xname(CasterID).."] �ͷ�:"..SkillName..", ����ID:"..SkillID..", ���ܵȼ�:"..SkillLevel..", Ŀ��ID:"..TargetID..", ��ʼ֡:"..StartFrame..", ��ǰ֡:"..FrameCount)
		end
	end
end

--��ʼ����
function OnPrepare(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, Frame, StartFrame, FrameCount)
	if bLog and dungeon() and IsBoss(CasterID) then
		if TargetType == 2 then
			print("OnPrepareXYZ->["..xname(CasterID).."] ��ʼ����:"..SkillName..", ����ID:"..SkillID..", ���ܵȼ�:"..SkillLevel..", Ŀ��λ��:"..TargetID.."|"..PosY.."|"..PosZ..", ����֡��:"..Frame..", ��ʼ֡:"..StartFrame..", ��ǰ֡:"..FrameCount)
		else
			print("OnPrepare->["..xname(CasterID).."] ��ʼ����:"..SkillName..", ����ID:"..SkillID..", ���ܵȼ�:"..SkillLevel..", Ŀ��ID:"..TargetID..", ����֡��:"..Frame..", ��ʼ֡:"..StartFrame..", ��ǰ֡:"..FrameCount)
		end
	end
end

--������Ϣ
function OnWarning(szText)
	if bLog and dungeon() then
		print("OnWarning->"..szText)
	end
end

--npc����
function OnSay(Name, SayText, CharacterID)
	if bLog and dungeon() and IsBoss(CharacterID) then
		print("OnSay->["..Name.."]˵:"..SayText)
	end
end
