output("----------����----------")
output("2 3 2")
output("3 2 2 0")
output("1 2 2 3")
output("2 2 1 1")
output("2 1 1")
output("1 1")
output("0 0 2")


--������
local v = {}

--��ѭ��
function Main(g_player)
	if nofight() and nobuff("���ľ���") then
		cast("���ľ���", true)
	end

	--���
	if tbuffstate("�ɴ��") then
		cast("����ָ")
	end

	--ȷ������Ŀ��
	v["����Ŀ��"] = id()
	v["Ѫ�����ٶ���"] = party("û״̬:����", "�����Լ�", "����<20", "���߿ɴ�", "û�ؾ�", "��Ѫ����")
	if v["Ѫ�����ٶ���"] ~= 0 and xlife(v["Ѫ�����ٶ���"]) < life() then
		v["����Ŀ��"] = v["Ѫ�����ٶ���"]
	end

	v["Ŀ��Ѫ��"] = xlife(v["����Ŀ��"])
	v["Ŀ����T"] = xmount("ϴ�辭|������|����������|������", v["����Ŀ��"])

	--����
	if fight() and v["����Ŀ��"] ~= id() then		--ս���У������Լ�
		if v["Ŀ��Ѫ��"] < 0.3 and life() > 0.9 then
			xcast("���紵ѩ", v["����Ŀ��"])
		end
	end

	--����
	if v["Ŀ��Ѫ��"] < 0.4 or (v["Ŀ����T"] and v["Ŀ��Ѫ��"] < 0.6) then
		if buff("����Ѫ|ˮ���޼�") then
			xcast("����", v["����Ŀ��"])
		else
			if cdtime("����") <= 0 then
				if cast("ˮ���޼�", true) then
					xcast("����", v["����Ŀ��"])
				end
			end
		end
	end

	--����
	if fight() and v["Ŀ����T"] and v["Ŀ��Ѫ��"] < 0.5 and xbuffstate("����Ч��", v["����Ŀ��"]) < 40 then		--TѪ����50%��û���ˣ�ǰ�泤��û���ϣ��ϴ���
		xcast("���໤��", v["����Ŀ��"])
	end

	--��ɢ
	xcast("��紹¶", party("û״̬:����", "����<20", "���߿ɴ�", "buff����ʱ��:���Բ���Ч��|��Ԫ�Բ���Ч��|���Բ���Ч��|��Ѩ����Ч��|���Բ���Ч��>1"))

	--����
	_, v["10���ڲ���Ѫ��������"] = party("û״̬:����", "����<10", "���߿ɴ�", "��Ѫ<0.7")
	if v["10���ڲ���Ѫ��������"] > 3 then
		cast("����")
	end

	--����
	if v["Ŀ��Ѫ��"] < 0.8 or (v["Ŀ����T"] and v["Ŀ��Ѫ��"] < 0.9) then
		xcast("����", v["����Ŀ��"])
	end
	
	if fight() then
		if buffsn("����") < 4 or bufftime("����") < 5 or bufftime("����Ѫ") < 5 then
			local tank = party("û״̬:����", "����<20", "�ڹ�:ϴ�辭|������|����������|������", "���߿ɴ�")
			if tank ~= 0 then
				xcast("����", tank)
			else
				cast("����", true)
			end
		end
	end

	--����
	if v["Ŀ��Ѫ��"] < 0.9 and xbufftime("����", v["����Ŀ��"]) < -1 then		--������Ѫ���ϸ�����
		xcast("����", v["����Ŀ��"])
	end
	xcast("����", party("û״̬:����", "����<20", "�ڹ�:ϴ�辭|������|����������|������", "���߿ɴ�", "buffʱ��:����<-1"))		--��T������


	--����
	if nobuff("��ˮ����") and life() > 0.9 and mana() < 0.7 then
		cast("����")
	end

	if mana() < 0.4 then
		cast("��ˮ����", true)
	end

	--����ŵ�����, �ƶ��зŲ����������ܣ����Լ���Ѫ
	if life() < 0.7 then
		cast("��������", true)
	end
end
