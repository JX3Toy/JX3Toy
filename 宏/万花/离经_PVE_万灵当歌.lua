--[[ ��Ѩ: [��ָ �� ����][��ϼ �� ��Ϣ][���� �� �»� �� ����][���� �� ����ָ][΢��][����][����][���� �� ����][���� �� ��ĩ][����][ң��][�����޻�]
�ؼ�:
��¥  2��Ϣ 1���� 1����
����  2���� 1��Ч 1��ī��
����  1���� 1���� 2��Ч
����  1���� 3����

��Ѩ�ؼ�ֻ���Ƽ�����Ҳ��̫���棬�����������Լ����ŵ�
�����Ҫ��ϵ�[����ָ], ������ѡ���еĴ��
û�����������ǰĿ��һֱѡ��boss������
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
		cast("��ҡֱ��")
	end

	--����
	if fight() and life() < 0.5 then
		cast("��¥��Ӱ")
	end

	--���
	if getopt("���") and tbuffstate("�ɴ��") then
		cast("����ָ")
	end

	--��ʼ������
	v["ī��"] = rage()
	v["������"] = charinfo("������")	--����뾫ȷ���ƣ������� * ����ϵ�� = ����ʵ�ʼ�Ѫ��
	v["����Ŀ��"] = f["��ȡ����Ŀ��"]()
	v["����Ŀ��Ѫ��"] = xlife(v["����Ŀ��"])
	v["����Ŀ����T"] = xmount("ϴ�辭|������|����������|������", v["����Ŀ��"])

	---------------------------------------------

	--����
	if fight() and v["����Ŀ��Ѫ��"] < 0.4 and life() > 0.8 then
		CastX("���紵ѩ")
	end

	--����
	if v["����Ŀ��Ѫ��"] < 0.75 then
		--ˮ��
		if fight() and v["ī��"] < 20 then
			cast("ˮ���޼�")
		end

		if buff("412|722|932|3458|6266") then	--��˲��
			CastX("����")
		end
	end

	--����

	--����
	if v["����Ŀ��Ѫ��"] < 0.9 then		--��Ѫ
		CastX("����")
	end
	if v["ī��"] < 30 then				--ˢī��
		CastX("����")
	end

	--����
	if rela("�ж�") and ttid() ~= 0 and xrela("�Լ�|�Ѻ�|����", ttid()) then	--Ŀ���Ŀ�� boss��Ŀ�����ʾ�����һ��Ҫ�̵���
		if xbufftime("����", ttid(), id()) < 3 then
			xcast("����", ttid())
		end
	end

	--��ˮ
	if fight() and mana() < 0.45 then
		cast("��ˮ����", true)
	end

	--����
	if fight() and target("boss") and face() < 80 and qixue("����") and tbufftime("����") < 3 then
		cast("����ָ")
	end

	--��T������
	xcast("����", party("û״̬:����", "����<20", "�ڹ�:ϴ�辭|������|����������|������", "���߿ɴ�", "�ҵ�buffʱ��:����<3"))

	--��ս����
	if casting("����") and castleft() < 0.13 then
		settimer("�����������")
	end
	if nofight() and gettimer("�����������") > 0.5 then
		xcast("����", party("��״̬:����", "����<20", "���߿ɴ�"))
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
	t[#t+1] = "ī��:"..v["ī��"]
	t[#t+1] = "����Ŀ��:"..v["����Ŀ��"]
	t[#t+1] = "����Ŀ��Ѫ��:"..format("%0.2f", v["����Ŀ��Ѫ��"])
	print(table.concat(t, ", "))
end

--������Ŀ��ʹ�ü���
function CastX(szSkill)
	if xcast(szSkill, v["����Ŀ��"]) then
		if v["��¼��Ϣ"] then PrintInfo() end
		return true
	end
	return false
end
