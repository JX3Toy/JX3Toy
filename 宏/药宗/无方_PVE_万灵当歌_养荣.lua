--[[ ��Ѩ: [����][���][���][�龣][���][����][��ʹ][���][����][�Ϸ�][����][����]
�ؼ�:
��½  2���� 2�˺�
����  2���� 2�˺�
����  2���� 1�˺� 1����
�Ҵ�  2��Ϣ 2�˺�
����  1���� 1Ч��(������Χ�������ͷ�) 2����

�պ�����, ����15���ڴ�, �����³��龣��ʱ����Ҫ��ϴ��ں��Ҵ�
5������, ��ս��Χû������һ��, ���մ�´��5�㺮, ��2�������Ͳ�����
--]]

--�ر��Զ�����
setglobal("�Զ�����", false)

--��ѡ��
addopt("����������", false)
addopt("����С��60%��ǧ֦", false)

--������
local v = {}
v["��¼��Ϣ"] = true
v["��������"] = 0
v["�Ҵ�����"] = 0
v["մ������"] = 0
v["��ǧ֦"] = false

--������
local f = {}

--��ѭ��
function Main()
	--�����Զ����ݼ�1�ҷ�ҡ, ע���ǿ�ݼ��趨�������Ŀ�ݼ�1ָ���İ���, ���Ǽ����ϵ�1
	if keydown(1) then
		cast("��ҡֱ��")
	end

	--��¼��������
	if casting("��½׺��") and castleft() < 0.13 then
		settimer("��½��������")
	end
	if casting("��������") and castleft() < 0.13 then
		settimer("���ڶ�������")
	end
	if casting("�Ҵ�ʱ��") and castleft() < 0.13 then
		settimer("�Ҵ���������")
	end

	--��ʼ������
	v["ҩ��"] = yaoxing()	--�´���0 ��С��0 -5��5����
	v["ҩ�Ծ���ֵ"] = math.abs(v["ҩ��"])
	local tSpeedXY, tSpeedZ = speed(tid())
	v["Ŀ�꾲ֹ"] = rela("�ж�") and tSpeedXY <= 0 and tSpeedZ <= 0

	v["GCD���"] = cdinterval(16)
	v["GCD"] = cdleft(16)
	v["����͸֧����"] = od("��������")
	v["����͸֧��ȴʱ��"] = odtime("��������")
	v["����CD"] = scdtime("��������")
	v["մ��CD"] = scdtime("մ��δ��")
	v["�Ҵ�CD"] = scdtime("�Ҵ�ʱ��")
	v["����CD"] = scdtime("������ѩ")
	v["����CD"] = cdleft(2021)
	v["�Լ�CD"] = scdtime("�Լ�����")
	v["��ҶCD"] = scdtime("��Ҷ����")
	v["��ҰCD"] = scdtime("��Ұ����")
	v["Ӧ��CD"] = scdtime("Ӧ����ҩ")

	v["���Ҳ���"] = tbuffsn("����", id())
	v["����ʱ��"] = tbufftime("����", id())
	v["��ʹʱ��"] = bufftime("��ʹ")
	v["���ʱ��"] = bufftime("���")
	v["��½˲��"] = buff("21106")
	v["��Ұ����"] = buff("24458")
	v["Ӧ�����д���"] = buffsn("24469")

	v["�Լ�"] = npc("��ϵ:�Լ�", "ģ��ID:106107")
	v["��Ҷ��"] = npc("��ϵ:�Լ�", "ģ��ID:106632")
	v["��Ҷ��ʱ��"] = bufftime("20702")
	v["�ƶ���������"] = keydown("MOVEFORWARD") or keydown("MOVEBACKWARD") or keydown("STRAFELEFT") or keydown("STRAFERIGHT") or keydown("JUMP")

	---------------------------------------------------------------------------

	--û��ս մ�´��5�㺮
	if nofight() and v["ҩ��"] > -5 then 
		if not rela("�ж�") or dis() > 35 and  v["GCD"] <= 0 then
			if npc("��ϵ:�ж�", "����<11") == 0 then	--11����û��
				CastX("մ��δ��", true)
			end
		end
	end

	--����������
	if getopt("����������") and dungeon() and nofight() then return end

	---------------------------------------------------------------------------

	v["��Ҷ����"] = false
	if rela("�ж�") and buff("20071") then
		if (dis() < 10 and face() < 90) or (v["�Լ�"] ~= 0 and xxdis(v["�Լ�"], tid()) < 10) then	--�Լ���Լ�10����
			if v["���Ҳ���"] >= 8 and v["����ʱ��"] > 7 then
				v["��Ҷ����"] = true
				CastX("��Ҷ����")
			end
		end
	end

	--��Ҷ����
	if v["��Ҷ����"] then
		CastX("��Ҷ����")
	end

	--������ѩ
	if rela("�ж�") then
		if dis() < 6 or (v["�Լ�"] ~= 0 and xxdis(v["�Լ�"], tid()) < 6) then	--�Լ���Լ�6����
			--if v["���ʱ��"] > 0 and v["��ʹʱ��"] > 0 and buff("ǧ֦����") and gettimer("��ǧ֦") > 0.3 then
			if v["���ʱ��"] > 0 and v["��ʹʱ��"] > 0 then
				if cdtime("������ѩ") <= 0 then
					if CastX("��Ұ����") then	--��Ұ������, �����Ҷϵ����
						CastX("������ѩ")
					end
					if v["��ҰCD"] > 6 then
						CastX("������ѩ")
					end
				end
			end
		end
	end

	--����
	if bufftime("21796") > casttime("��������") then
		f["��ǧ֦"]("�Ŵ���", 0.25)
		CastX("��������")
	end

	--�Լ�����
	if rela("�ж�") then
		CastX("�Լ�����")
	end

	--��Ҷ����
	if rela("�ж�") then
		if CastX("��Ҷ����") then
			CastX("մ��δ��")
		end
	end

	--�ȴ���½�ͷ� ҩ��ͬ��
	if gettimer("��½��������") < 0.3 then
		--print("----------�ȴ���½�ͷ�")
		return
	end

	--����
	if rela("�ж�") and dis() < 20 and gettimer("���ڶ�������") > 0.5 and not v["�ƶ���������"] then
		if v["���ʱ��"] < 12 then
			if v["ҩ��"] <= -3 or (gettimer("�ͷ�մ��δ��") < 4 and v["ҩ��"] - (5 -v["�Ҵ�����"]) <= -3) then
				if cdtime("��������") <= 0 then
					f["��ǧ֦"]("�Ŵ���", 0.25)
					if CastX("��������") then
						v["��������"] = 0
						stopmove()
						return
					end
				end
			end
		end
	end

	--�Ҵ�ʱ��
	if rela("�ж�") and (v["Ŀ�꾲ֹ"] or ttid() == id()) and dis() < 15 and not v["�ƶ���������"] then
		if v["���Ҳ���"] >= 4 and v["����ʱ��"] > casttime("�Ҵ�ʱ��") + v["GCD���"] * 2 + 0.5 and not v["��Ҷ����"] then
			if v["����CD"] > casttime("�Ҵ�ʱ��") and v["��ʹʱ��"] > casttime("�Ҵ�ʱ��") + casttime("��������") + 0.5 then
				if cdtime("�Ҵ�ʱ��") <= 0 then
					f["��ǧ֦"]("���Ҵ�", 0.4)
					if CastX("�Ҵ�ʱ��") then
						v["�Ҵ�����"] = 0
						stopmove()
						return
					end
				end
			end
		end
	end

	--��������
	if rela("�ж�") then
		if (dis() < 6 and face() < 90) or (v["�Լ�"] ~= 0 and xxdis(v["�Լ�"], tid()) < 6) then	--�Լ���Լ�6����
			if v["ҩ��"] <= -3 or (gettimer("�ͷ�մ��δ��") < 4 and v["ҩ��"] - (5 -v["�Ҵ�����"]) <= -3) or v["����CD"] > v["GCD���"] * 2 then
				if v["���Ҳ���"] >= 8 and v["����ʱ��"] > 11 then
					if v["���ʱ��"] > 1 and v["��ʹʱ��"] > 1 then
						if cdtime("��������") <= 0 then
							f["��ǧ֦"]("�ź���", 0.4)
							CastX("��������")
						end
					end
				end
			end
		end
	end

	--����
	if v["��ʹʱ��"] < 3 or v["ҩ��"] < -3 --[[or v["ҩ��"] - (5 -v["�Ҵ�����"]) < -3--]] then
		CastX("���Ƕϳ�")
	end

	--��½
	CastX("��½׺��")

	f["��ǧ֦"]()

	--û�ż��ܼ�¼��Ϣ
	if fight() and rela("�ж�") and dis() < 20 and state("վ��") and cdleft(16) <= 0 and castleft() <= 0 then
		if gettimer("��������") > 0.3 and gettimer("��½׺��") > 0.3 and gettimer("�Ҵ�ʱ��") > 0.3 and gettimer("�Լ�����") > 0.3 and gettimer("���ڶ�������") > 0.3 and gettimer("�Ҵ���������") > 0.3 then
			PrintInfo("-- û�ż���")
		end
	end
end

-------------------------------------------------------------------------------

f["��ǧ֦"] = function(szReason, nMana)
	v["��ǧ֦"] = false
	if buff("ǧ֦����") and gettimer("��ǧ֦") > 0.3 then
		return true
	end

	if mana() > nMana then
		if cast("ǧ֦����") then
			print("-------------------- ��ǧ֦:"..szReason)
			return true
		end
	end
	return false
end

f["��ǧ֦"] = function()
	if gettimer("��������") < 0.3 or casting("��������") or gettimer("���ڶ�������") < 0.3 then return end
	if gettimer("�Ҵ�ʱ��") < 0.3 or casting("�Ҵ�ʱ��") or gettimer("�Ҵ���������") < 0.3 then return end
	if gettimer("��������") < 0.3 or v["��Ҷ����"] or gettimer("�ͷŷ�Ҷ����") <= 0.5 then return end

	--���� ���� �Ҵ���CD
	if v["����CD"] > 3 and v["����CD"] > 3 and v["�Ҵ�CD"] > 3 then
		if not getopt("����С��60%��ǧ֦") or mana() < 0.6 then
			if cbuff("ǧ֦����") then
				settimer("��ǧ֦")
			end
		end
	end

	--Ŀ�겻�ǵж�
	if not rela("�ж�") then
		if cbuff("ǧ֦����") then
			settimer("��ǧ֦")
		end
	end
end

--��¼��Ϣ
function PrintInfo(s)
	local t = {}
	if s then t[#t+1] = s end
	t[#t+1] = "ҩ��:"..v["ҩ��"]
	t[#t+1] = "����:"..format("%.2f", mana())

	t[#t+1] = "����:"..v["���Ҳ���"]..", "..v["����ʱ��"]
	t[#t+1] = "��ʹ:"..v["��ʹʱ��"]
	t[#t+1] = "���:"..v["���ʱ��"]

	t[#t+1] = "����CD:"..v["����͸֧����"]..", "..v["����͸֧��ȴʱ��"]..", "..v["����CD"]
	t[#t+1] = "�Ҵ�CD:"..v["�Ҵ�CD"]
	t[#t+1] = "�Լ�CD:"..v["�Լ�CD"]
	t[#t+1] = "��ҶCD:"..v["��ҶCD"]
	t[#t+1] = "����CD:"..v["����CD"]
	t[#t+1] = "����CD:"..v["����CD"]
	t[#t+1] = "մ��CD:"..v["մ��CD"]
	t[#t+1] = "��ҰCD:"..v["��ҰCD"]
	t[#t+1] = "ǧ֦CD:"..scdtime("ǧ֦����")
	
	print(table.concat(t, ", "))
end

--ʹ�ü��ܲ���¼��Ϣ
function CastX(szSkill, bSelf)
	if cast(szSkill, bSelf) then
		settimer(szSkill)
		if v["��¼��Ϣ"] then PrintInfo() end
		return true
	end
	return false
end

-------------------------------------------------------------------------------

--buff����
function OnBuff(CharacterID, BuffName, BuffID, BuffLevel, StackNum, SkillSrcID, StartFrame, EndFrame, FrameCount)
	if CharacterID == id() then
		if BuffID == 20075 then		--ǧ֦����
			deltimer("��ǧ֦")
			if StackNum > 0 then
				print("-------------------- ��ǧ֦")
			else
				print("-------------------- ��ǧ֦")
			end
		end

		if StackNum <= 0 and BuffID == 20071 then
			v["��ǧ֦"] = "�������buff�Ƴ�"
		end

		--[[����buff����
		if StackNum > 0 then
			print("���buff->"..BuffName, BuffID, BuffLevel, SkillSrcID, StartFrame, (EndFrame -StartFrame) / 16, EndFrame, FrameCount)
		else
			print("�Ƴ�buff->"..BuffName, BuffID, BuffLevel)
		end
		--]]
	end
end

--ҩ�Ը���
function OnYaoxingUpdate()
	deltimer("��½��������")
end

--�����ж�
function OnBreak(CharacterID)
	if CharacterID == id() then
		v["��ǧ֦"] = "�����ж�"
	end
end

--�ͷż���
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		--[[���Լ����ͷ�
		if TargetType == 2 then
			print("OnCast->"..SkillName, "����ID:"..SkillID, "�ȼ�:"..SkillLevel, "Ŀ��:"..TargetID.."|"..PosY.."|"..PosZ, "��ʼ֡:"..StartFrame, "��ǰ֡:"..FrameCount)
		else
			print("OnCast->"..SkillName, "����ID:"..SkillID, "�ȼ�:"..SkillLevel, "Ŀ��:"..TargetID, "��ʼ֡:"..StartFrame, "��ǰ֡:"..FrameCount)
		end
		--]]

		if SkillID == 27578 then
			v["մ������"] = 0
			settimer("�ͷ�մ��δ��")
		end

		if SkillID == 28114 then
			v["մ������"] = v["մ������"] + 1
			if v["մ������"] >= 5 then
				deltimer("�ͷ�մ��δ��")
			end
		end

		if SkillID == 27556 then	--����ÿ��
			v["��������"] = v["��������"] + 1
			if v["��������"] >= 4 then
				v["��ǧ֦"] = "���ڶ�������"
			end
		end

		if SkillID == 27584 then	--�Ҵ�ÿ��
			v["�Ҵ�����"] = v["�Ҵ�����"] + 1
			if v["�Ҵ�����"] >= 5 then
				v["��ǧ֦"] = "�Ҵ���������"
			end
		end

		if SkillID == 28372 then
			v["��ǧ֦"] = "��Ҷ�ͷŽ���"
		end

		if SkillID == 27637 then	--��Ҷ
			settimer("�ͷŷ�Ҷ����")
		end
	end
end

local tNpcName = {
[106107] = "�Լ�����",
[106632] = "��Ҷ��",
}

--NPC���볡��
function OnNpcEnter(NpcID, NpcName, NpcTemplateID, NpcModelID, EmployerID)
	if EmployerID == id() then
		local szName = tNpcName[NpcTemplateID]
		if szName then
			print("-------------------- OnNpcEnter->"..szName, frame())
		end
	end
end

--NPC�뿪����
function OnNpcLeave(NpcID, NpcName, NpcTemplateID, NpcModelID, EmployerID)
	if EmployerID == id() then
		local szName = tNpcName[NpcTemplateID]
		if szName then
			print("-------------------- OnNpcLeave->"..szName, frame())
		end
	end
end

--ս��״̬�ı�
function OnFight(bFight)
	if bFight then
		print("--------------------����ս��")
	else
		--��ս��ǧ֦
		v["��ǧ֦"] = "��ս"

		--������ս���Ѵ���
		if dungeon() then
			bigtext("�ǵô�����������")
		end
		
		print("--------------------�뿪ս��")
	end
end
