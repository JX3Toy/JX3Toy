--[[ ��Ѩ: [����][����][����][����][���Q][Ԩ��][�ɾ�][����][�����ƶ�][����][��ɫ][��������]
�ؼ�:
��˹�  2��Ϣ 2Ч��
�׼�  2��Ϣ 2Ч��
����  3Ч�� 1����
����  3��Ч 1��Χ
ʥ��  2��Ϣ 2��Ч
ǧ��  3��Ϣ 1��Ч
Ů�  3��Ϣ 1����
����  2���� 1Ч�� 1����

�ٴ���� �غ� -> ������ -> �׼� -> Ů� ->  �̵���
û�����������ǰĿ��һֱѡ��boss
��Ŀ��10���ڷŶ�
��˹� �Ƴ��׼� �ֶ���
--]]

--��ѡ��
addopt("���", false)

--������
local v = {}
v["��¼��Ϣ"] = true

--������
local f = {}

--��ѭ��
function Main()
	--�����Զ����ݼ�1�ҷ�ҡ, ע���ǿ�ݼ��趨�������Ŀ�ݼ�1ָ���İ��������Ǽ����ϵ�1
	if keydown(1) then
		fcast("��ҡֱ��")
	end

	--ǧ����������
	if gettimer("ǧ������") < 0.3 or casting("ǧ������") then
		return
	end

	--�ȴ����������ʼ
	if gettimer("�������") < 0.3 then
		return
	end

	if casting("�����ƶ�") and castleft() < 0.13 then
		settimer("����������")
	end

	--����
	if fight() and pet() and life() < 0.6 then
		fcast("��ˮ��", true)
	end

	--���
	if getopt("���") and tbuffstate("�ɴ��") then
		fcast("���")
	end

	--��ʼ������
	v["������"] = charinfo("������")
	v["����Ŀ��"] = f["��ȡ����Ŀ��"]()
	v["����Ŀ��Ѫ��"] = xlife(v["����Ŀ��"])
	v["������boss"] = npc("��ϵ:�ж�", "ǿ��=6", "��ѡ��", "����<30") ~= 0
	v["Ŀ����boss"] = rela("�ж�") and target("boss")
	local tSpeedXY, tSpeedZ = speed(tid())
	v["Ŀ�꾲ֹ"] = rela("�ж�") and tSpeedXY <= 0 and tSpeedZ <= 0		--Ŀ��û�ƶ�
	v["��������"] = buffsn("����")
	v["����ʱ��"] = bufftime("����")

	---------------------------------------------

	--�ٺ���
	if not pet("�̵�") then
		cast("�̵���")
	end

	--��ɢ
	if pet("�̵�") then
		v["��Ҫ��ɢ����"] = xparty(petid(), "û״̬:����", "����<40", "���߿ɴ�", "buff����ʱ��:���Բ���Ч��|��Ԫ�Բ���Ч��|���Բ���Ч��|���Բ���Ч��>1")		--������Χ40����, ���߿ɴ�, ��ָ������Ч��
		if v["��Ҫ��ɢ����"] ~= 0  then
			if settar(v["��Ҫ��ɢ����"]) then	--���ֻ�����ڵ�ǰĿ��
				cast("���")
			end
		end
	end

	--�ƻ�
	if fight() and v["Ŀ����boss"] and ttid() ~= 0 and ttid() ~= id() then	--Ŀ����boss Ŀ���Ŀ����� �����Լ�
		if xbufftime("�ƻ�����", ttid(), id()) < 5 then
			xcast("�ƻ�����", ttid())	--��Ŀ���Ŀ��
		end
	end

	--ǧ��
	if fight() then
		_, v["��Ѫ����������"] = party("û״̬:����", "����<20", "���߿ɴ�", "û�ؾ�", "��Ѫ<0.6")	--�Լ�20����
		if qixue("���Q") and pet("�̵�") then
			_, v["��Ѫ����������"] = xparty(petid(), "û״̬:����", "����<20", "���߿ɴ�", "û�ؾ�", "��Ѫ<0.6")	--����20����
		end
		
		if v["��Ѫ����������"] >= 3 then
			if fcast("ǧ������") then
				settimer("ǧ������")
				return
			end
		end
	end

	--ʥ��
	if fight() and v["����Ŀ��Ѫ��"] < 0.6 then
		CastX("ʥ��֯��", true)
	end

	--Ů�
	if fight() and v["������boss"] then
		cast("Ů洲���")
	end

	--�ֲ�
	if fight() and v["Ŀ����boss"] and v["Ŀ�꾲ֹ"] then
		cast("��������")
	end

	--����
	if v["����Ŀ��Ѫ��"] < 0.85 then
		CastX("����ǣ˿", true)
	end

	--�Ŷ�
	if fight() and v["Ŀ����boss"] and v["Ŀ�꾲ֹ"] and dis() < 10 and gettimer("����������") > 0.5 then
		cast("�����ƶ�")
	end

	--�Զ�
	if gettimer("����������") > 0.5 and nobuff("��ʱ") and life() < 0.7 and cdleft(16) > 0.5 then
		interact("�����ƶ�")
	end

	--����
	if v["����Ŀ��Ѫ��"] < 0.95 then
		if casting("�������") then
			v["����NPC"] = npc("��ϵ:�Լ�", "ģ��ID:107819")
			if v["����NPC"] ~= 0 and xxdis(v["����NPC"], v["����Ŀ��"]) > range("�������", true) then	--�ڶ�������, ����Ŀ�겻�����跶Χ��, �����ͷ�
				if CastX("�������", true) then
					settimer("�������")
					return
				end
			end
		else
			if CastX("�������") then
				settimer("�������")
				return
			end
		end
	end

	--��ս����
	if casting("��������") and castleft() < 0.13 then
		settimer("������������")
	end
	if nofight() and gettimer("������������") > 0.5 then
		xcast("��������", party("��״̬:����", "����<20", "���߿ɴ�"))
	end
end

-------------------------------------------------------------------------------

f["��ȡ����Ŀ��"] = function()
	local targetID = id()	--����Ŀ��������Ϊ�Լ�, ���ڶ�������Ŷ���ʱ party ���� 0
	local partyID = party("û״̬:����", "�����Լ�", "����<20", "���߿ɴ�", "û�ؾ�", "��Ѫ����")	--��ȡѪ�����ٶ���
	if partyID ~= 0 and partyID ~= targetID and xlife(partyID) < life() then	--��Ѫ�����ٶ����ұ��Լ�Ѫ����
		targetID = partyID	--����ָ��Ϊ����Ŀ��
	end
	return targetID
end

--��¼��Ϣ
function PrintInfo(s)
	local t = {}
	if s then t[#t+1] = s end
	t[#t+1] = "����Ŀ��:"..v["����Ŀ��"]
	t[#t+1] = "����Ŀ��Ѫ��:"..format("%0.2f", v["����Ŀ��Ѫ��"])
	print(table.concat(t, ", "))
end

--������Ŀ��ʹ�ü���
function CastX(szSkill, bf)
	if xcast(szSkill, v["����Ŀ��"], bf) then
		if v["��¼��Ϣ"] then PrintInfo() end
		return true
	end
	return false
end

-------------------------------------------------------------------------------
--��ʼ����
function OnChannel(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, Frame, StartFrame, FrameCount)
	if CasterID == id() then
		if SkillID == 33444 then	--����
			deltimer("�������")
		end
	end
end
