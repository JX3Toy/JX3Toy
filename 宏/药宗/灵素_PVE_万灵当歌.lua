--[[ ��Ѩ: [����][�¼�][��Ⱦ][��ʱ][����][����][����][Ʈ��][����][ͬ��][����][��ì]
�ؼ�:
����  2���� 1��Ч 1Ч��
����  2��Ϣ 1Ч�� 1��Ч
����  1���� 1��Ч 2Ч��
����  2��Ϣ 2Ч��
����  2���� 2��Ч
��ľ  3��Ϣ 1Ч��(��Ѫ)
����  3��Ϣ 1Ч��(��Ѫ���)

���������ְҵ, ���д��, �����ս����û����, ��ǰĿ��ѡ��boss������ (��ʵ��ѡ˭������ν, ѡ��boss��ΪĿ����Ҫ��Ŀ��λ�÷��ന���)
--]]

--��ѡ��
addopt("�ֶ����ƺ���", false)
addopt("�ֶ��ന���", false)

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

	--��ʼ������
	v["������"] = charinfo("������")
	v["ҩ��"] = yaoxing()
	v["����Ŀ��"] = f["��ȡ����Ŀ��"]()
	v["����Ŀ��Ѫ��"] = xlife(v["����Ŀ��"])
	local tSpeedXY, tSpeedZ = speed(tid())
	v["Ŀ�꾲ֹ"] = rela("�ж�") and tSpeedXY <= 0 and tSpeedZ <= 0


	--���ƺ���
	if not getopt("�ֶ����ƺ���") and fight() and v["Ŀ�꾲ֹ"] and target("boss") and dis() < 10 then
		v["���ƺ���"] = npc("ģ��ID:106623")
		if v["���ƺ���"] == 0 then
			_, v["û��ƶ�������"] = party("û״̬:����", "ƽ�����<10", "buffʱ��:���<-1")
			if v["û��ƶ�������"] >= 4 then
				cast("���ƺ���")
			end
		end
	end

	--�ന���
	if not getopt("�ֶ��ന���") and fight() and v["Ŀ�꾲ֹ"] and target("boss") then
		cast("�ന���")
	end

	--������ѩ
	if v["����Ŀ��Ѫ��"] < 0.7 and xdis(v["����Ŀ��"]) < 6 and xxface(id(), v["����Ŀ��"]) < 130 then
		cast("������ѩ")
	end
	
	---------------------------------------------

	--�����Կ�
	if fight() and v["����Ŀ��Ѫ��"] < 0.4 then
		CastX("�����Կ�")
	end

	--����ͺ�
	if fight() and v["����Ŀ��Ѫ��"] < 0.6 then
		CastX("����ͺ�")
	end

	--��������
	if v["����Ŀ��Ѫ��"] < 0.8 then
		CastX("��������")
	end

	--���ֺ���
	if v["����Ŀ��Ѫ��"] < 0.95 then
		CastX("���ֺ���")
	end

	--���ƺ���
	if v["����Ŀ��Ѫ��"] < 0.95 then
		CastX("���ƺ���")
	end
end

-------------------------------------------------------------------------------

f["��ȡ����Ŀ��"] = function()
	local targetID = id()	--����Ŀ��������Ϊ�Լ�, ���ڶ�������Ŷ���ʱ party ���� 0
	local partyID = party("û״̬:����", "�����Լ�", "����<20", "���߿ɴ�", "û�ؾ�", "��Ѫ����")	--��ȡѪ�����ٶ���
	if partyID ~= 0 and partyID ~= targetID and xlife(partyID) < life() then	--��Ѫ�����ٶ����ұ���Լ�Ѫ����
		targetID = partyID	--����ָ��Ϊ����Ŀ��
	end
	return targetID
end

--������Ŀ��ʹ�ü���
function CastX(szSkill)
	if xcast(szSkill, v["����Ŀ��"]) then
		if v["��¼��Ϣ"] then PrintInfo() end
		return true
	end
	return false
end

--��¼��Ϣ
function PrintInfo(s)
	local t = {}
	if s then t[#t+1] = s end
	t[#t+1] = "ҩ��:"..v["ҩ��"]
	t[#t+1] = "����Ŀ��:"..v["����Ŀ��"]
	t[#t+1] = "����Ŀ��Ѫ��:"..format("%0.2f", v["����Ŀ��Ѫ��"])

	print(table.concat(t, ", "))
end

--��¼ս��״̬�ı�
function OnFight(bFight)
	if bFight then
		print("--------------------����ս��")
	else
		print("--------------------�뿪ս��")
	end
end
