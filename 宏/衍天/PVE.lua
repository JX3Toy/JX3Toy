output("��Ѩ: [ˮӯ][����][˳ף][����][��ɽ][���][ף��][����][ӫ���][����][����][����]")


--��������
local guaxiang = function()
	
	--������л�û�򣬲����Ա���
	if buff("24457") then return end

	--��������
	if gettimer("ף�ɡ�����") > 0.3 then
		if cast("ף�ɡ�����") then
			settimer("ף�ɡ�����")
		end
	end

	if gettimer("ף�ɡ�ˮ��") > 0.3 and rela("�ж�") then
		if xcast("ף�ɡ�ˮ��", ttid()) then
			settimer("ף�ɡ�ˮ��")
		end
	end

	if gettimer("�����ʱ��") < 0.5 then return end

	--����
	local biangua = false

	if rela("�ж�") and dis() < 20 then
		if buff("ˮ��") and mana() > 0.6 then
			biangua = true
		end
		if buff("ɽ��") and tbufftime("ף�ɡ�����", id()) < 1 then
			biangua = true
		end
		if buff("����") and nobuff("17825") then
			biangua = true
		end
	end

	if biangua then
		if fcast("����") then
			settimer("�����ʱ��")
			return
		end
	end

	--����
	local qigua = false

	if mana() < 0.19 then
		qigua = true
	end

	if nobuff("ˮ��|ɽ��|����") then
		qigua = true
	end

	if rela("�ж�") and dis() < 20 and tbufftime("ף�ɡ�����", id()) < 1 and nobuff("17825") then
		qigua = true
	end

	if biangua or qigua then
		if cast("����") then
			settimer("�����ʱ��")
		end
	end
end

--�����
local deng = function()

	--�ŵ�
	if rela("�ж�") then
		--��ǰ�Ƶ�����
		local lampCount = dengcount()

		--û�еƣ����վ���ŵ�һ����
		if lampCount == 0 and dis() < 15 then
			if cast("���վ���") then
				return
			end
		end
		
		--��1���ƣ��ŵڶ���
		if lampCount == 1 then
			tfangdeng()
		end
		
		--��2���ƣ��ŵ�3��������Ŀ��5.5����
		if lampCount == 2 then
			tfangdeng(5.5)
		end
	end

	--�Ƶ�
	if ljtime() > 8 then
		if npc("��ϵ:�Լ�", "buffʱ��:22960>0") == 0 then		--û����
			tmovedeng(5.5)
		end
	end

	--����ʱ��쵽�˱���
	if lianju() and ljtime() < 2 then
		fcast("���ǿ�Ѩ")
	end

	--�ŵ���������
	if lianju() and cn("���ŷɹ�") >= 2 and cdtime("���վ���") < 4 then
		--û��ݣ�����Ŀ�겻����������, ����
		if bufftime("���") < 1 or xnolianju(tid()) then
			fcast("���ǿ�Ѩ")
		end
		--����
		if tbufftime("ף�ɡ�����", id()) < 1 and xinlianju(tid()) and bufftime("����") > 0.5 then
			fcast("���ǿ�Ѩ")
		end
	end
end

--��ѭ��
function Main(g_player)
	if casting("�춷��") and castleft() < 0.13 then
		settimer("�춷����������")
	end


	--���
	if tbuffstate("�ɴ��") then
		cast("��Լ�")
	end

	--��������
	guaxiang()

	--�����
	deng()
	
	if buff("��һ") then
		fcast("�춷��")
	end

	if tbufftime("ף�ɡ�����", id()) > 1 and tbuffsn("����", id()) < 10 then
		cast("������")
	end

	--[[
	if bufftime("ɽ��") > 1.5 then
		cast("�춷��")
	end
	--]]

	if buff("24457") and gettimer("�춷����������") > 0.5 then
		cast("�춷��")
	end
	
	cast("������")
	
	if gettimer("�춷����������") > 0.5 then
		cast("�춷��")
	end

	cast("������")
end
