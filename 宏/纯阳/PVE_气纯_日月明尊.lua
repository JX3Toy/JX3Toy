--[[����
[����]2 [�Ĺ�]3 [����]2 
[�꼯]2 [��ţ]2 [����]3
[׽Ӱ]3 [�巽�о�]1 [�˻�����]2
[����]1 [���⽭ɽ]1
[����]1 [ȫ��]2 [��]1 [��ʵ]1
[�̱�]1 [��������]1
[�׺�]3 [����]2
[����]1 [�ٷ�]1
--]]

--****************************����1�μ���, 1�����ϼ���1��GCD��������ȶ�3��

--�ر��Զ�����
setglobal("�Զ�����", false)

--������û��ս������, �ڹ����ؾ�Ҫ�ر�
addopt("����������", false)

--������
local v = {}
v["��������"] = 0
v["�ȴ�����ͬ��"] = false

--��ѭ��
function Main()
	--����
	if fight() then
		--��������
		if life() < 0.6 and buffstate("����Ч��") < 40 and nobuff("����") then
			fcast("��������")
		end

		--��ɽ��
		if life() < 0.35 then
			if fcast("��ɽ��", true) then
				stopmove()
				bigtext("��ɽ��", 2, 2)
			end
		end
	end

	--�����ؾ�
	if tcasting("����") and castleft() < 0.5 then
		settimer("Ŀ���������")
	end
	if gettimer("Ŀ���������") < 1 or tbuff("4147") then	--���� �����˺�
		stopcasting()
		return
	end

	--���Զ���
	if tbuffstate("�ɴ��") and tcastleft() < 1 then
		fcast("���Զ���")
	end

	--���Ϸ����
	if casting("���϶���") then
		if castleft() < 0.13 then
			settimer("���϶����������")
		end
		return
	end

	--��ʼ��
	v["����"] = qidian()
	v["��������"] = npc("����:��������", "��ɫ����<3")
	v["����ʣ��ʱ��"] = bufftime("51072") - 8
	local tSpeedXY, tSpeedZ = speed(tid())
	v["Ŀ�꾲ֹ"] = tSpeedXY == 0 and tSpeedZ == 0		--xy�ٶȺ�Z�ٶȶ�Ϊ0
	v["�Ʋ�����"], v["�Ʋ��ʱ��"] = qc("�����Ʋ��", id(), id())		--�Լ���Χ�Լ����Ʋ��


	--����������������õȴ�����ͬ��
	if casting("�����ֻ�") and castleft() < 0.13 and v["����"] == 7 then
		SetWait()
	end

	--�Ʋ��
	if rela("�ж�") and dis() < 20 then
		if v["�Ʋ�����"] > -1 or v["�Ʋ��ʱ��"] < 1 then		--û���Ʋ����߿��Ȧ��, �������Լ���������Ե�ľ��룬��Ȧ������������Ȧ���Ǹ���
			fcast("�Ʋ��", true)
		end
	end

	--�ȴ�����ͬ��
	if v["�ȴ�����ͬ��"] and gettimer("�ȴ�����ͬ��") <= 0.25 then
		print("�ȴ�����ͬ��")
		return
	end

	--����������
	if getopt("����������") and dungeon() and nofight() then return end

	if tbuff("����") then
		bigtext("Ŀ���޵�", 0.5)
		return
	end

	--��ת��һ, ����˺�
	if cdleft(16) > 0.5 then
		cast("��ת��һ")
	end

	--ƾ������
	if fight() and rela("�ж�") and dis() < 20 then
		cast("ƾ������")
	end

	--��Ԫ��ȱ
	if fight() and mana() < 0.45 and v["����"] >= 9 then
		if fcast("��Ԫ��ȱ") then
			fcast("�������")
		end
	end

	--躹�����
	if rela("�ж�") and dis() < 20 and bufftime("��������") > 7.5 and cdleft(16) < 0.5 then
		fcast("躹�����")
	end

	--���ǻ���
	if v["����"] >= 8 then
		if fcast("���ǻ���") then
			fcast("�������")
		end
	end
	
	--���϶���
	if rela("�ж�") and v["��������"] ~= 0 and gettimer("���϶����������") > 0.5 then
		if v["�Ʋ�����"] < -1 and v["�Ʋ��ʱ��"] > 3 and (v["Ŀ�꾲ֹ"] or v["����ʣ��ʱ��"] < 5) then
			--��������
			if v["Ŀ�꾲ֹ"] and dis2() < 19.5 and visible() and cdleft(16) <= 0 then	--����������
				if v["��������"] == 0 and v["����ʣ��ʱ��"] > 3 then		--���ܴ�3�θ���
					if buffsn("����") >= 5 and bufftime("����") > 3 then	--5�㾭��, ����û��Ҫ��ע�͵�
						fcast("��������")
					end
				end
			end

			fcast("���϶���")
		end
	end

	--�����ֻ�
	if fcast("�����ֻ�") then
		if buff("�꼯") then
			fcast("�������")
		end
	end

	--̫���޼�
	if cast("̫���޼�") then
		cast("�������")
	end

	--�������, 1.5��CD���ܼ���Ӱ��
	if cdleft(16) > 1 then
		cast("�������")
	end
end

--��������ȴ���־
function SetWait()
	v["�ȴ�����ͬ��"] = true
	settimer("�ȴ�����ͬ��")
	exit()
end

--�������
function OnQidianUpdate()
	v["�ȴ�����ͬ��"] = false
	--print("OnQidianUpdate", qidian())
end

--buff����
function OnBuff(CharacterID, BuffName, BuffID, BuffLevel, StackNum, SkillSrcID, StartFrame, EndFrame, FrameCount)
	if CharacterID == id() and StackNum  > 0 then	--�Լ� ���
		if BuffID == 51072 then	--ÿ�γ��ָ������ۻ�������buff
			v["��������"] = 0
		end
	end
end

--�ͷż���
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetID, nStartFrame, nFrameCount)
	if CasterID == id() then
		if SkillID == 64144 then	--���϶��𡤸���, ÿ�θ������۳���ֻ��Ч3��
			v["��������"] = v["��������"] + 1
		end
		--print("OnCast -> ".."������: "..SkillName..", ID: "..SkillID..", �ȼ�: "..SkillLevel..", Ŀ��: "..TargetID..", ��ʼ֡: "..nStartFrame..", ��ǰ֡: "..nFrameCount)
	end
end

--NPC���볡��
function OnNpcEnter(NpcID, NpcName, NpcTemplateID, NpcModelID, EmployerID)
	if EmployerID == id() and NpcTemplateID == 201578 then
		print("OnNpcEnter->"..NpcName..", NPCID: "..NpcID..", ģ��ID: "..NpcTemplateID..", ����ID: "..NpcModelID)
	end
end
