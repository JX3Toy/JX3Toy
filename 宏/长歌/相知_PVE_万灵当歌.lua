--[[ ��Ѩ: [ε��][���][����][��� �� һָ���][����][����][������][����][��˪][����][����][�޾���]
�ؼ�:
��  2���� 1���� 1��Ч
��  2��Ч 2����
��  2���� 2��Ч
��  1���� 1���� 2��Ч
��ˮ  3���� 1����

û�����������ǰĿ��һֱѡ��boss
--]]


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

	--��¼��������
	if casting("��") and castleft() < 0.13 then
		settimer("����������")
	end

	--��ʼ������
	v["������"] = charinfo("������")
	v["����Ŀ��"] = f["��ȡ����Ŀ��"]()
	v["����Ŀ��Ѫ��"] = xlife(v["����Ŀ��"])
	v["Ӱ������"] = 0
	for i = 3, 8 do
		if buff("999"..i) then
			v["Ӱ������"] = v["Ӱ������"] + 1
		end
	end

	---------------------------------------------
	
	--�л���������ѩ
	if nobuff("9320") then
		cast("������ѩ")
	end
	
	--��Ŀ���Ӱ��
	if v["Ӱ������"] < 6 and fight() and rela("�ж�") and cn("��Ӱ��б") > 2 then
		cast("��Ӱ��б")
	end

	--��ɢ
	v["��Ҫ��ɢ����"] = party("û״̬:����", "����<20", "���߿ɴ�", "buff����ʱ��:���Բ���Ч��|��Ԫ�Բ���Ч��|���Բ���Ч��|���Բ���Ч��>1")
	if v["��Ҫ��ɢ����"] ~= 0  then
		xcast("һָ���", v["��Ҫ��ɢ����"], true)
	end

	--�Ƿ��ж������
	local bBreak = false
	if casting("��") then
		v["�����Ŀ��"] = casttarget()
		if v["�����Ŀ��"] ~= v["����Ŀ��"] or xlife(v["�����Ŀ��"]) > 0.98 then	--�����Ŀ�겻��Ѫ�����ٶ��� �� �Ѿ���Ѫ
			bBreak = true
		end
	end

	--��
	if fight() and v["����Ŀ��Ѫ��"] < 0.7 then
		CastX("��", bBreak)
	end

	--��
	if v["����Ŀ��Ѫ��"] < 0.9 and gettimer("����������") > 0.5 and xbufftime("����", v["����Ŀ��"], id()) < 2 then
		CastX("��", bBreak)
	end

	--��
	if v["����Ŀ��Ѫ��"] < 0.9 then
		CastX("��", bBreak)
	end

	--�� ��
	if v["����Ŀ��Ѫ��"] < 0.95 then
		if xbufftime("��", v["����Ŀ��"], id()) < -1 then
			CastX("��", bBreak)
		end
		if xbufftime("��", v["����Ŀ��"], id()) < -1 then
			CastX("��", bBreak)
		end
	end

	--Ŀ���Ŀ��
	if fight() and rela("�ж�") then
		v["Ŀ���Ŀ��"] = ttid()
		if v["Ŀ���Ŀ��"] ~= 0 then
			--����
			if gettimer("����������") > 0.5 and xbufftime("����", v["Ŀ���Ŀ��"], id()) < 2 then
				xcast("��", v["Ŀ���Ŀ��"], bBreak)
			end
			--hot
			if xbufftime("��", v["Ŀ���Ŀ��"], id()) < -1 then
				xcast("��", v["Ŀ���Ŀ��"], bBreak)
			end
			if xbufftime("��", v["Ŀ���Ŀ��"], id()) < -1 then
				xcast("��", v["Ŀ���Ŀ��"], bBreak)
			end
		end
	end

	--��ս����
	if casting("�辡Ӱ��") and castleft() < 0.13 then
		settimer("�辡��������")
	end
	if nofight() and gettimer("�辡��������") > 1 then
		xcast("�辡Ӱ��", party("��״̬:����", "����<20", "���߿ɴ�"))
	end

	--��T��hot
	xcast("��", party("û״̬:����", "����<20", "�ڹ�:ϴ�辭|������|����������|������", "���߿ɴ�", "�ҵ�buffʱ��:��<-1"))
	xcast("��", party("û״̬:����", "����<20", "�ڹ�:ϴ�辭|������|����������|������", "���߿ɴ�", "�ҵ�buffʱ��:��<-1"))

	--������������hot
	xcast("��", party("û״̬:����", "����<20", "���߿ɴ�", "�ҵ�buffʱ��:��<-1"))
	xcast("��", party("û״̬:����", "����<20", "���߿ɴ�", "�ҵ�buffʱ��:��<-1"))
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
