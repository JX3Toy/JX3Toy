--��Ѩ: [����][Ϣ��][���][����][����][����][����][���][����][��֦��¶][����][�����ų�]

--�����
load("Macro/Lib_PVP.lua")

--������
local v = {}

--������
local f = {}

f["û���"] = function()
	if buffstate("�����ʱ��") >= 0 then
		return false
	end
	local t = { "��Ұ����", "���ƺ���", "�Ҵ�ʱ��", "��Ȼ���", "������ˮ", "�ط�΢��" }
	for k,v in ipairs(t) do
		if gettimer(v) <= 0.25 then
			return false
		end
	end

	return true
end

f["û��Ȼ���"] = function()
	return bufftime("��Ȼ���") <= 0 and gettimer("��Ȼ���") > 0.25 and gettimer("�ط�΢��") > 0.25
end

f["����Ȼ���"] = function()
	return bufftime("��Ȼ���") > 0 or gettimer("��Ȼ���") < 0.25 or gettimer("�ط�΢��") < 0.25
end

f["�ž�����ˮ"] = function()
	if f["����Ȼ���"]() then return false end

	if g_var["ͻ��"] then
		if cdtime("��������") < 1 and v["���Ҳ���"] >= 8 and v["����ʱ��"] > 11 then
			--if not qixue("��֦��¶") or v["ҩ��"] > 1 then
				return "�����򺬷�"
			--end
		end
	end
	return false
end

f["��������"] = function()
	if buff("21474") then return false end

	if g_var["Ŀ��ɹ���"] then

		if state("��Ծ|����λ��״̬") then
			if height() > 10 and dis2() > 8 then
				if acast("��������") then
					exit()
				end
			end
		end

		if dis2() > 8 then
			if acast("��������") then
				exit()
			end
			if face() < 60 then
				if cast("��������") then
					exit()
				end
			end
		end
	end
end

f["�Ҵ�ʱ��"] = function()
	if bufftime("21474") > -1 then return false end

	--�����
	if g_var["Ŀ��ɿ���"] and f["û���"]() and dis() < 10 and theight() < 10 and v["���Ҳ���"] > 4 and v["����ʱ��"] > 5 then
		if cast("�Ҵ�ʱ��") then
			stopmove()		--ֹͣ�ƶ�
			nomove(true)	--��ֹ�ƶ�
			settimer("�Ҵ�ʱ��")
			exit()
		end
	end
end

f["��մ��δ��"] = function()
	if g_var["Ŀ��ɹ���"] and theight() < 6 then
		if qixue("����") and tnpc("��ϵ:�Լ�", "����:�Լ�����", "����<8") ~= 0 then
			return true
		end
		if qixue("����") and v["���Ҳ���"] >= 4 then
			if tbuffstate("����ʱ��") <= 0 and tbuffstate("ѣ��ʱ��") <= 0 and tbuffstate("����ʱ��") <= 0 and tbuffstate("�ɶ���") then
				return true
			end
		end
	end
	return false
end

f["����Ҷ����"] = function()
	--Ŀ��������
	if tmount(g_var["�����ķ�"]) then
		return true
	end

	--Ŀ�긽��������
	if allbattle() then
		if tenemy("�ڹ�:"..g_var["�����ķ�"], "����<40") ~= 0 then
			return true
		end
	end
	return false
end

f["ǧ֦����"] = function()
	if v["Ŀ�����ҵĵ���"] == 0 then
		cast("ǧ֦����")
	else
		if mana() > 0.6 then
			cast("ǧ֦����")
		end
	end
end


--��ѭ��
function Main(g_player)
	--���ʼ��
	g_func["��ʼ��"]()

	v["���Ҳ���"] = tbuffsn("����", id())
	v["����ʱ��"] = tbufftime("����", id())
	v["ҩ��"] = yaoxing()		--���Դ���0�� ����С��0

	--�Ҵ�ʱ�ݷ����
	if gettimer("�Ҵ�ʱ��") < 0.5 or casting("�Ҵ�ʱ��") then
		return
	else
		nomove(false)
	end

	--���ƺ����ֹ�ƶ�, buff 20131 
	if gettimer("���ƺ���") < 0.5 or npc("��ϵ:�Լ�", "ģ��ID:106623", "����<10") ~= 0 then
		return
	else
		nomove(false)
	end
	
	--����ʱ����Ŀ��
	if casting("��½׺��|��������") then
		turn()
	end

	v["Ŀ�����ҵĵ���"] = enemy("Ŀ������", "����<30", "�����Լ�")

	--[[���ƺ���
	--������
	_, v["Ŀ�����ҵ�������"] = enemy("Ŀ������", "����<20")
	if v["Ŀ�����ҵ�������"] >= 2 then
		if cast("���ƺ���") then
			settimer("���ƺ���")
			exit()
		end
	end
	--]]

	--���ƺ���, ����㴦����
	if fight() and life() < 0.3 then
		cast("���ƺ���", true)
	end

	--�ȴ��ƶ�״̬ͬ��
	local t = { "������ˮ", "�ط�΢��", "��������", "��Ҷ����", "��֦��¶", "��֦����", "��Ȼ���", "��Ȼ��硤ǰ", "��Ȼ��硤��", "��Ȼ��硤��", "��Ȼ��硤��", "��Ȼ��硤��" }
	for k, v in ipairs(t) do
		if gettimer(v) < 0.25 then
			return
		end
	end

	f["ǧ֦����"]()

	--������ѩ
	if g_var["Ŀ��ɹ���"] then
		cast("������ѩ")
	end

	--��֦����
	if g_var["Ŀ��ɹ���"] and cast("��֦����") then
		settimer("��֦����")
	end

	--��֦��¶
	if g_var["Ŀ��ɹ���"] and cast("��֦��¶") then
		settimer("��֦��¶")
	end

	--��Ҷ����
	if g_var["ͻ��"] then
		if cast("��Ҷ����") then
			settimer("��Ҷ����")
		end
	end

	--��������
	if g_var["ͻ��"] and f["û��Ȼ���"]() then
		if v["���Ҳ���"] >= 8 and v["����ʱ��"] > 9 then
			if cdtime("��������") <= 0 and dis() < 12 then
				cast("մ��δ��")
			end
			--if not qixue("��֦��¶") or v["ҩ��"] > 1 then
				if cast("��������") then
					settimer("��������")
					exit()
				end
			--end
		end
	end

	--[[մ��δ��
	if f["��մ��δ��"]() then
		cast("մ��δ��")
	end
	--]]

	--������ˮ
	local szReason = f["�ž�����ˮ"]()
	--print(v["���Ҳ���"], v["����ʱ��"], szReason)
	if szReason then
		if cast("������ˮ") then
			settimer("������ˮ")
			print(szReason)
			exit()
		end
	end
	
	--�ط�΢��
	if cdtime("��������") > 1 and gettimer("��������") > 0.75 and nobuff("20071|22810|24482") then
		if cast("�ط�΢��") then
			settimer("�ط�΢��")
			exit()
		end
	end

	f["�Ҵ�ʱ��"]()

	--��������
	f["��������"]()
	
	--���Ƕϳ�������
	if v["����ʱ��"] > 0 and v["����ʱ��"] <= cdinterval(16) then
		if cast("���Ƕϳ�") then
			print("���Ƕϳ�������")
		end
	end

	--�����ų�
	if g_var["Ŀ��ɹ���"] and g_var["Ŀ��û����"] and dis() > 10 then
		cast("�����ų�")
	end


	--��½׺��
	if g_var["Ŀ��ɹ���"] and v["ҩ��"] >= 2 and dis2() > 8 then
		if bufftime("21106") > 0.1 or nobuff("21106") then
			cast("��½׺��")
		end
	end

	--�Լ�����
	if g_var["Ŀ��ɹ���"] then
		cast("�Լ�����")
	end

	--��Ҷ����
	if f["����Ҷ����"]() then
		cast("��Ҷ����")
	end

	--���Ƕϳ�
	if g_var["Ŀ��ɹ���"] then
		cast("���Ƕϳ�")
	end


	--��Ȼ����ƶ�
	if bufftime("��Ȼ���") > 0.5 and bufftime("20095") > 0.1 then
		if gettimer("��Ȼ���") > 0.25 and gettimer("�ط�΢��") > 0.25 and gettimer("��������") > 0.25 then
			--ǰ
			if dis2() > 20 then
				if acast(27643) then
					settimer("��Ȼ��硤ǰ")
					exit()
				end
			end
			--��
			if dis2() < 10 then
				if acast(27644) then
					settimer("��Ȼ��硤��")
					exit()
				end
			end
			--��
			if height() < 10 then
				if cast(27782) then
					settimer("��Ȼ��硤��")
					exit()
				end
			end
			--��
			if gettimer("��Ȼ��硤��") < 1.5 and cast(27646) then
				settimer("��Ȼ��硤��")
				exit()
			end
			--��
			if cast(27645) then
				settimer("��Ȼ��硤��")
				exit()
			end
		end
	end

	--��Ȼ���
	if f["û���"] then
		if v["Ŀ�����ҵĵ���"] ~= 0 or (rela("�ж�") and dis() < 30) then
			if cast("��Ȼ���") then
				settimer("��Ȼ���")
				exit()
			end
		end
	end


	--û��ս, մ��δ�����5�㺮
	if enemy("����<70") == 0 and v["ҩ��"] <= 1 and v["ҩ��"] > -5 then
		cast("մ��δ��", true)
	end

	f["���"]()


	--�ҷ�ҡ
	--if enemy("�ڹ�:"..g_var["��ս�ķ�"], "����<50") then
	if allbattle() then
		cast("��ҡֱ��")
	end

	--����е
	if buffstate("��еʱ��") > 2 then
		if buff("����") then
			jump()
		else
			if cast("��ҡֱ��") then
				jump()
			end
		end
	end



	--�ɼ�������Ʒ
	if nofight() then
		g_func["�ɼ�"](g_player)
	end
	
end

f["���"] = function()
	--���ƽ⽩ֱ
	if buffstate("��ֱʱ��") > 0.5 then
		if cast("��������") then
			exit()
		end
	end

	--��ֹ�ظ��Ž��
	if gettimer("��Ұ����") <  0.5 or gettimer("���ƺ���") < 0.5 then return end

	if buffstate("����ʱ��") > 1.5 or buffstate("����ʱ��") > 1.5 or buffstate("ѣ��ʱ��") > 1.5 or buffstate("����ʱ��") > 1.5 or buffstate("��ֱʱ��") > 0.5 then
		--��Ұ����
		if cast("��Ұ����") then
			settimer("��Ұ����")
			exit()
		end
		
		--���ƺ���
		if cast("���ƺ���") then
			stopmove()		--ֹͣ�ƶ�
			nomove(true)	--��ֹ�ƶ�
			settimer("���ƺ���")
			exit()
		end
	end
end


--�ͷż���
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		if SkillID == 27560 then
			--print("����")
		end
	end
end

local tBuff = {
--[21106] = "��Ȼ���˲����½׺��",
--[20037] = "������ˮ������",
--[20071] = "�������¶���",
--[22806] = "�������¿��Դ�����",
--[22810] = "������������",
--[24482] = "���������Ķ�",
[20072] = "��Ȼ���",
}

--���buff�䶯���
function OnBuff(CharacterID, BuffName, BuffID, BuffLevel, StackNum, SkillSrcID, StartFrame, EndFrame, FrameCount)
	if CharacterID == id() then
		if StackNum  > 0 then
			local bPrint = false
			if  BuffID ~= 17584 then
				if buffis(BuffID, BuffLevel, "���⹦") then
					print("����Ĭ")
					bigtext("����Ĭ")
					bPrint = true
				end
				if buffis(BuffID, BuffLevel, "��е") then
					print("����е")
					bigtext("����е")
					bPrint = true
				end
				if buffis(BuffID, BuffLevel, "���Ԫ") then
					print("������")
					bigtext("������")
					bPrint = true
				end
				if buffis(BuffID, BuffLevel, "����") then
					print("������")
					bigtext("������")
					bPrint = true
				end
				if buffis(BuffID, BuffLevel, "����") then
					print("������")
					bigtext("������")
					bPrint = true
				end
				if buffis(BuffID, BuffLevel, "ѣ��") then
					print("��ѣ��")
					bigtext("��ѣ��")
					bPrint = true
				end
				if buffis(BuffID, BuffLevel, "����") then
					print("������")
					bigtext("������")
					bPrint = true
				end
			end

			if tBuff[BuffID] or bPrint then
				print("���buff: ".. BuffName..", ID: "..BuffID..", �ȼ�: "..BuffLevel..", ����: "..StackNum..", ԴID: "..SkillSrcID..", ��ʼ֡: "..StartFrame..", ��ǰ֡: "..FrameCount..", ����֡: "..EndFrame..", ʣ��ʱ��: "..(EndFrame-FrameCount)/16)
			end
		else
			if tBuff[BuffID] then
				print("�Ƴ�buff: ".. BuffName..", ID: "..BuffID..", �ȼ�: "..BuffLevel..", ����: "..StackNum..", ԴID: "..SkillSrcID..", ��ʼ֡: "..StartFrame..", ��ǰ֡: "..FrameCount)
			end
		end
	end
end
