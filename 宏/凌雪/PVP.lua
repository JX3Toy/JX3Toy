output("��Ѩ:[����][ѩ��][����][����][����][��ǵ][����][����][�Ƿ�][��Ѫ][���][��ɽ����]")

--�����
load("Macro/Lib_PVP.lua")

--������
local v = {}
v["�Լ��ķ���"] = 0
v["�ȴ�����"] = false
v["�ȴ�����"] = false


--������
local f = {}

local tMainKong = { "Ѫ����Ȫ", "��ڤ����", "���͹�", "�����⹳", "�·��̤", "�������" }
f["û���"] = function()
	if buffstate("�����ʱ��") >= 0 then return false end
	for k,v in ipairs(tMainKong) do
		if gettimer(v) <= 0.25 then
			return false
		end
	end
	return true
end

--��ѭ��
function Main(g_player)
	if v["�ȴ�����"] and gettimer("Ѫ����Ȫ") <= 0.25 then
		print("�ȴ�����")
		return
	end
	if v["�ȴ�����"] and gettimer("��ڤ����") <= 0.25 then
		print("�ȴ�����")
		return
	end
	if buff("ʮ������") or gettimer("ʮ������") < 0.5 then
		return
	end
	
	if state("���") then
		deltimer("�ȴ����")
	end
	if gettimer("�ȴ����") < 0.25 then
		return
	end

	--�ȴ�����
	v["��������"] = enemy("�ڹ�:��Ӱʥ��", "����<10", "buffʱ��:̰ħ��<-1")
	if v["��������"] ~= 0 then
		settar(v["��������"])
	end
	v["����û����������"] = enemy("�ڹ�:��Ӱʥ��", "����<10", "buff״̬:��Ĭʱ��<-1", "buff״̬:����ʱ��<-1", "buff״̬:��еʱ��<-1", "buff״̬:����ʱ��<-1", "buff״̬:ѣ��ʱ��<-1", "buff״̬:����ʱ��<-1")

	--��ʼ��
	g_func["��ʼ��"]()

	v["����"] = buff("15524")
	v["˫��"] = buff("15565")
	v["˫��"] = not v["����"] and not v["˫��"]
	v["����"] = bufftime("16662", tid()) >= 0 or bufftime("16663", tid()) >= 0
	

	local tSpeedXY, tSpeedZ = speed(tid())
	v["Ŀ�겻�ڿ����ƶ�"] = tSpeedXY < 400 and tSpeedZ <= 0

	v["Ŀ��������"] = tmount(g_var["�����ķ�"])
	v["Ŀ���ǽ�ս"] = tmount(g_var["��ս�ķ�"])
	v["Ŀ����Զ��"] = tmount(g_var["Զ���ķ�"])

	f["����ХӰ"]()
	f["����˺�"]()
	f["�������ƶ�"]()

	v["����������1"] = g_var["Ŀ��ɹ���"] and visible() and height() < 2 and heightz() < 8 and v["Ŀ�겻�ڿ����ƶ�"]
	v["����������2"] =  dis() > 6 and dis() < 12
	

	f["������"]()

	--������ ���е
	if v["����û����������"] ~= 0 then
		acast("������")
	end

	f["���л�ת"]()

	f["��ɽ����"]()

	--���꺮�� ���˺�
	if qixue("����") and g_var["Ŀ��ɹ���"] and g_var["Ŀ�굥������"] <= 0 then
		if cast("���꺮��") then
			settimer("���꺮��")
		end
	end

	--���͹�
	local szReason = f["�Ŵ��͹�"]()
	if szReason then
		if cast("���͹�") then
			print(szReason)
		end
	end

	--������ ���˺�
	if v["˫��"] and v["����������1"] and v["����������2"] then
		if acast("������") then
			stopmove()
			exit()
		end
	end

	--ն�޳�
	local szReason = f["��ն�޳�"]()
	if szReason then
		if cast("ն�޳�") then
			print(szReason)
			return
		end
	end
	
	--�ź��
	if g_var["Ŀ��ɹ���"] and v["˫��"] and dis() > 6 and dis() < 12 then
		cast("�ź��")
	end
	
	--���꺮�� �����
	if not qixue("����") and g_var["Ŀ��ɿ���"] and v["����"] then
		if qixue("�Ƿ�") then
			if tbuffstate("����ʱ��") < 1 and tbuffstate("ѣ��ʱ��") < 1 then
				if tbuffstate("�ɻ���") or (tbuffstate("����ʱ��") > 0.125 and tbuffstate("����ʱ��") < 1) then
					cast("���꺮��")
				end
			end
		else
			if tbuffstate("�ɻ���") and tbuffstate("����ʱ��") < 1 and tbuffstate("ѣ��ʱ��") < 1 then
				cast("���꺮��")
			end
		end
	end

	--������ ���
	if g_var["Ŀ��ɹ���"] and g_var["ͻ��"] then
		if (v["Ŀ��������"] or v["Ŀ����Զ��"]) or (buff("16071") and tbuffstate("��ѣ��")) or cdtime("���꺮��") < 1 then	--���ƺ�Զ��ֱ�Ӵ򣬽�սս�ɿزŴ�
			if cast(22613) then
				settimer("�ȴ����")
				return
			end
		end
	end

	--������ ��ͨ
	if g_var["Ŀ��ɹ���"] then
		cast(22144)
	end
	
	--�Ǵ�ƽҰ
	if g_var["Ŀ��ɹ���"] and visible() then
		if buff("15430") then	--����
			local x, y = xxpos(id(), tid())
			if x > 0 and x < 7 and y > -2 and y < 2 and heightz() < 6 then
				cast("�Ǵ�ƽҰ")
			end
		else
			if dis() < 6 and face() < 90 then
				cast("�Ǵ�ƽҰ")
			end
		end
	end

	--�·��̤
	f["�·��̤"]()

	--ʮ������
	if fight() and life() < 0.5 then
		f["ʮ������"]()
	end
	
	g_func["�����ڽ�е"]()

	if buffstate("��еʱ��") > 2 then
		f["ʮ������"]()
	end

	--Ѫ����Ȫ
	if f["û���"]() then
		if cast("Ѫ����Ȫ") then
			v["�ȴ�����"] = true
			settimer("Ѫ����Ȫ")
			print("--------------------���������")
			exit()
		end
	end

	f["��ڤ����"]()
	

	--[[
	if v["����������1"] and f["Ŀ�궨��ʱ��"](2) and dis2() < 3.5 then
		if cdtime("���͹�") < 0.5 or cdtime("������") < 0.5 then
			if v["˫��"] or cast("��ڤ����") then
				if cast("�����⹳") then
					settimer("�ȴ����")
					print("���������⹳��������")
					exit()
				end
			end
		end
	end
	--]]

	--�����⹳
	local szReason = f["�������⹳"]()
	if szReason then
		if cast("�����⹳") then
			settimer("�����⹳")
			print(szReason)
			return
		end
	end
	--]]

	--�������
	if f["���������"]() then
		if cast("�������") then
			exit()
		end
	end

	--���ƽ⽩ֱ
	if buffstate("��ֱʱ��") > 0.5 then
		cast("��������")
	end

	--�ҷ�ҡ
	if jjc() and nobuff("����") then
		cast("��ҡֱ��")
	end

	--�ɼ�������Ʒ
	if nofight() then
		g_func["�ɼ�"](g_player)
	end

end

f["��ڤ����"] = function()
	if buff("15583") then
		if f["û���"]() then
			if cast("��ڤ����") then
				v["�ȴ�����"] = true
				settimer("��ڤ����")
				print("--------------------���������")
				exit()
			end
		end
	end
end

f["Ŀ�궨��ʱ��"] = function(nTime)
	if tbuffstate("����ʱ��") > nTime then return true end
	if tbuffstate("����ʱ��") > nTime then return true end
	if tbuffstate("ѣ��ʱ��") > nTime then return true end
	if tbuffstate("����ʱ��") > nTime - 0.5 then return true end
	return false
end

f["�������⹳"] = function()
	if v["˫��"] and v["����������1"] and f["Ŀ�궨��ʱ��"](2) and dis2() < 3.5 then
		if cdtime("���͹�") < 0.5 or cdtime("������") < 0.5 then
			return "���������������"
		end
	end
	return false
end

f["�Ŵ��͹�"] = function()
	if v["˫��"] and v["����������1"] and v["����������2"] and f["Ŀ�궨��ʱ��"](1.5) and cdtime("������") <= 0 then
		return "���͹������򶨵�������"
	end
	if f["û���"]() and cdtime("Ѫ����Ȫ") > 4 and nobuff("15583") then
		return "���͹������"
	end
	return false
end

f["������"] = function()
	--�Ʒ���
	v["����"] = npc("��ϵ:�Լ�", "ģ��ID:107305", "����<12")
	if v["����"] ~= 0 then
		if acast("������", 0, v["����"]) then
			print("�������Ʒ���")
			return
		end
	end

	--��������CD
	if qixue("���л�ת") and cdtime("���л�ת") < 20 then
		return
	end

	--Ŀ��������buff����
	if tbuff("��ɽ����", id()) then return end
	
	--��϶���
	if g_var["Ŀ��ɿ���"] and visible() and dis() < 12 and tbuffstate("����") then
		local szSkill = tcasting()
		if szSkill and tcastleft() > 0.125 and tcastleft() <= 0.5 then
			if acast("������") then
				print("�����״�϶���: " .. szSkill)
				return
			end
		end
	end
end

f["��ն�޳�"] = function()
	--����, ��Զ�̼���
	--Զ�̱��� ****

	if v["˫��"] and cdtime("������") > 4 then
		return "ն�޳� ������CD"
	end

	--�����
	if f["û���"]() and cdtime("Ѫ����Ȫ") > 4 and nobuff("15583") then
		return "ն�޳������"
	end
	--if f["û���"]() and 

	if v["����û����������"] ~= 0 then
		return "ն�޳����е"
	end
	return false
end


f["���������"] = function()
	--��Χ�м���NPC����
	if tnpc("��ϵ:�Լ�|����", "ģ��ID:67632", "ƽ�����<4") ~= 0 then return false end	--���� Ѫ������
	if tnpc("��ϵ:�Լ�|����", "ģ��ID:107305", "ƽ�����<8") ~= 0 then return false end	--���л�ת
	if tnpc("��ϵ:�Լ�|����", "ģ��ID:67665", "ƽ�����<3") ~= 0 then return false end	--��ɽ����
	if tnpc("��ϵ:�Լ�|����", "ģ��ID:101122", "ƽ�����<9") ~= 0 then return false end --�˰���
	

	if gettimer("��ɽ����") < 0.5 or gettimer("���꺮��") < 0.5 then
		return false
	end

	--Ŀ�걻����, ����С��15��, ���߿ɴ�, û�޵�, û����, û������(buff 15603), ���ڳ�̻����ﻯ����
	if v["����"] and g_var["Ŀ��û����"] and g_var["Ŀ�굥������"] <= 0 and dis() < 14 and visible() and tbuffstate("����ʱ��") < -1 and tbufftime("15603") < -1 and (tnostate("���") or tbuff("13781")) then
		if qixue("����") and cdtime("���꺮��") > 1 then
			return true
		end
	end
	return false
end

f["�·��̤"] = function()
	local bResult = false
	if buffstate("����ʱ��") > 2 and buffstate("����ʱ��") > 2 or buffstate("ѣ��ʱ��") > 2 or buffstate("����ʱ��") > 1.5 or buffstate("��ֱʱ��") > 0.5 then
		if castxyz("�·��̤", point(tid(), 11, 180)) then
			bResult = true
		elseif castxyz("�·��̤", point(tid(), 11, 90)) then
			bResult = true
		elseif castxyz("�·��̤", point(tid(), 11, -90)) then
			bResult = true
		elseif castxyz("�·��̤", point(tid(), 11, 0)) then
			bResult = true
		elseif cast("�·��̤", true) then
			bResult = true
		end
	end
	if bResult then
		settimer("�ȴ����")
		exit()
	end
end

f["�·��̤����"] = function()
	--Ŀ�걳��8��
	--castxy(22616, )
end

f["�·��̤����"] = function()
	--cast("25306")
end


f["ʮ������"] = function()
	if cast("ʮ������") then
		settimer("ʮ������")
		exit()
	end
	
	if cdtime("ʮ������") <= 0 then
		local enemyID = enemy("����<20", "���߿ɴ�", "�������")
		if enemyID ~= 0 then
			if xcast("ʮ������", enemyID) then
				settimer("ʮ������")
				exit()
			end
		end
	end
end

f["���л�ת"] = function()
	if g_var["Ŀ��û����"] and dis() < 11 and theight() < 6 and v["Ŀ�겻�ڿ����ƶ�"] and cdtime("������") <= 0 then
		cast("���л�ת")
	end
end

f["��ɽ����"] = function()
	if g_var["Ŀ��û����"] and g_var["Ŀ�굥������"] <= 1 and theight() < 2 and v["Ŀ�겻�ڿ����ƶ�"] then
		--���� ���꺮��
		if qixue("����") then
			if dis() < 5 and cdtime("���꺮��") < cdinterval(16) then
				if cast("��ɽ����") then
					settimer("��ɽ����")
					stopmove()
					print("��ɽ���� ���� ���꺮��")
				end
			end
			return
		end
		
		--���� �������
		if v["���������"] and cdtime("�������") <= 0.5 then
			if cast("��ɽ����") then
				settimer("��ɽ����")
				print("��ɽ���� ���� �������")
			end
		end
	end
end

f["�������ƶ�"] = function()
	if casting("������") then
		if tid() ~= 0 then
			local x, y = xxpos(id(), tid())
			if x > 10 then
				movef(true)
			end
			if x < 7 then
				moveb(true)
			end
			if y  > 2 then
				movel(true)
			end
			if y < -2 then
				mover(true)
			end
		end
		exit()
	else
		if not keydown("MOVEFORWARD") then
			movef(false)
		end
		if not keydown("MOVEBACKWARD") then
			moveb(false)
		end
		if not keydown("STRAFELEFT") then
			movel(false)
		end
		if not keydown("STRAFERIGHT") then
			mover(false)
		end
	end
end

--����ХӰ, ���˺�֮ǰ����
f["����ХӰ"] = function()
	v["ХӰԴ��ɫ"] = buffsrc("ХӰ")
	if v["ХӰԴ��ɫ"] ~= 0 then
		v["ХӰNPC"] = npc("ģ��ID:58636", "����:"..v["ХӰԴ��ɫ"])
		if v["ХӰNPC"] ~= 0 then
			acast2("��������", v["ХӰNPC"], 16)
		end
		bigtext("��ХӰ")
		exit()
	end
end

f["����˺�"] = function()
	--�ؽ� ������ɽ
	v["����������ɽ����"] = enemy("ƽ�����<10", "����:������ɽ")
	if v["����������ɽ����"] ~= 0 then
		if acast2("��������", v["����������ɽ����"], 12) then
			bigtext("�������ɽ����")
			return
		end
	end
	v["�жԷ�����ɽNpc"] = npc("��ϵ:�ж�", "ƽ�����<10", "ģ��ID:57739")
	if v["�жԷ�����ɽNpc"] ~= 0 then
		if acast2("��������", v["�жԷ�����ɽNpc"], 12) then
			bigtext("�������ɽNpc")
			return
		end
	end

	--���� ˪�콣��
	v["˪�콣��Դ��ɫ"] = buffsrc("˪�콣��")
	if v["˪�콣��Դ��ɫ"] ~= 0 then
		if acast2("��������", v["˪�콣��Դ��ɫ"], 17) then
			bigtext("����˪�콣��")
			return
		end
	end
end


--�ͷż���
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		if SkillID == 22274 then
			v["�ȴ�����"] = false
			return
		end
		if SkillID == 22361 then
			v["�ȴ�����"] = false
			return
		end

		--[[
		if SkillID == 22398 then
			settimer("��������˺�")
		end
		if SkillID == 29166 then
			settimer("�ͷŷ��л�ת")
		end
		--]]
	end
end


local tBuff = {}

--buff����
function OnBuff(CharacterID, BuffName, BuffID, BuffLevel, StackNum, SkillSrcID, StartFrame, EndFrame, FrameCount)
	--���� buff 21310 �ȼ�1 2 3
	if CharacterID == v["�Լ��ķ���"] and StackNum  > 0 then
		print("OnBuff->���� ���buff: ".. BuffName..", ID: "..BuffID..", �ȼ�: "..BuffLevel..", ����: "..StackNum..", ԴID: "..SkillSrcID..", ��ʼ֡: "..StartFrame..", ��ǰ֡: "..FrameCount..", ����֡: "..EndFrame..", ʣ��ʱ��: "..(EndFrame-FrameCount)/16)
		return
	end

	if CharacterID == id() then
		if StackNum  > 0 then
			local bPrintAdd = false
			if buffis(BuffID, BuffLevel, "���⹦") then
				print("����Ĭ")
				bigtext("����Ĭ")
				bPrintAdd = true
			end

			if buffis(BuffID, BuffLevel, "��е") then
				print("����е")
				bigtext("����е")
				bPrintAdd = true
			end

			if buffis(BuffID, BuffLevel, "����") then
			 	print("������")
				bigtext("������")
				bPrintAdd = true
			end

			if buffis(BuffID, BuffLevel, "����") then
				print("������")
				bigtext("������")
				bPrintAdd = true
			end

			if buffis(BuffID, BuffLevel, "ѣ��") then
				print("��ѣ��")
				bigtext("��ѣ��")
				bPrintAdd = true
			end
		
			if buffis(BuffID, BuffLevel, "����") then
				print("������")
				bigtext("������")
				bPrintAdd = true
			end

			if tBuff[BuffID] or bPrintAdd then
				print("���buff: ".. BuffName..", ID: "..BuffID..", �ȼ�: "..BuffLevel..", ����: "..StackNum..", ԴID: "..SkillSrcID..", ��ʼ֡: "..StartFrame..", ��ǰ֡: "..FrameCount..", ����֡: "..EndFrame..", ʣ��ʱ��: "..(EndFrame-FrameCount)/16)
			end
		else
			if tBuff[BuffID] then
				print("�Ƴ�buff: ".. BuffName..", ID: "..BuffID..", �ȼ�: "..BuffLevel..", ����: "..StackNum..", ԴID: "..SkillSrcID..", ��ʼ֡: "..StartFrame..", ��ǰ֡: "..FrameCount)
			end
		end
	end
end

--NPC���볡��
function OnNpcEnter(NpcID, NpcName, NpcTemplateID, NpcModelID, EmployerID)
	if EmployerID == id() and NpcTemplateID == 107305 then
		v["�Լ��ķ���"] = NpcID		--��¼���Լ��ķ���ID
	end
end
