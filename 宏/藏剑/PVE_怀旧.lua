--����ʱ�����������ɺ��ؼ�
output("----------����----------")
output("[����]2  [Ѱ��]3  [����]2")
output("[����]2  [����]2  [����]3  [��ѩ]1")
output("[̤ѩѰ÷]1  [ŭ��]1  [����]2")
output("[�Ծ�]3  [��Ȥ]2  [��ʯ]1")
output("[ɽ��ˮ��]3")
output("[����Ӱ]1")
output("[ɽɫ]2  [����]3")
output("[���]2")


--��ѡ��
--addopt("����������", true)
addopt("��T̽÷", false)


--������
local v = {}
v["�ȴ��ڹ��л�"] = false


--��ѭ��
function Main(g_player)

	if casting("�Ʒ����") and castleft() < 0.13 then
		settimer("�Ʒ����")
	end

	---------------------------------------------�л��ڹ�

	if v["�ȴ��ڹ��л�"] and gettimer("Х��") < 0.5 then
		return
	end

	v["�л��ڹ�"] = false

	if mount("��ˮ��") then
		--3����Ȥ���ؽ�
		if buffsn("��Ȥ") >= 3 then
			v["�л��ڹ�"] = true
		end
	end

	if mount("ɽ�ӽ���") then
		--��ս���ὣ
		if nofight() then
			v["�л��ڹ�"] = true
		end
		
		--����������һ������
		if rage() < 15 then
			v["�л��ڹ�"] = true
		end

		--Х�ղ�������һ������
		--if bufftime("Х��") < cdinterval(16) and bufftime("����Ӱ") < cdinterval(16) and nobuff("��Ȥ") then
		if bufftime("Х��") < cdinterval(16) and nobuff("��Ȥ") and (nobuff("����") or cdtime("�ϳ�") > 1) then
			v["�л��ڹ�"] = true
		end
	end

	if v["�л��ڹ�"] then
		if cast("Х��") then
			v["�ȴ��ڹ��л�"] = true
			settimer("Х��")
			return
		end
	end


	if mount("��ˮ��") and bufftime("÷����") < 21 then
		cast("÷����")
	end

	
	--����������
	--if getopt("����������") and dungeon() and nofight() then return end

	--���
	if tbuffstate("�ɴ��") then
		if gettimer("������") > 1 and cast("ժ��") then
			settimer("ժ��")
		end
		if gettimer("ժ��") > 1 and cast("������") then
			settimer("������")
		end
	end


	--����
	if rela("�ж�") and dis() < 8 and cdleft(16) < 0.5 then		--Ŀ��ʱ����, ����С��8��, GCD�����
		if tlifevalue() > lifemax() * 3 then		--Ŀ�굱ǰѪ�����Լ����Ѫ��3��
			cast("�ͻ���ɽ")
		end
		if mount("ɽ�ӽ���") and bufftime("Х��") > 10 and tlifevalue() > lifemax() * 10 then
			cast("����Ӱ")
		end
	end


	---------------------------------------------�ὣ
	if mount("��ˮ��") then
		--��T̽÷
		if getopt("��T̽÷") and rela("�ж�") then
			v["̽÷����"] = 5
			if gettimer("������") > 1 and cdtime("������") < 0.1 then
				v["̽÷����"] = 19
			end
			xcast("̽÷", tparty("û״̬:����", "�ڹ�:ϴ�辭|������|����������|������", "����<"..v["̽÷����"], "���߿ɴ�", "�������"))
		end

		if buff("÷����") and cdtime("Х��") > 2 then
			cast("�ϳ�")
		end

		if cdtime("Х��") > 8 then
			cast("��Ȫ����")
		end

		cast("̤ѩѰ÷")
		
		if acast("�����´�", 180) then
			return
		end

		cast("����")
		--cast("ƽ������")


		if dis() > 8 then
			if cast("������") then
				settimer("������")
			end
		end
	end

	---------------------------------------------�ؽ�
	if mount("ɽ�ӽ���") then
		if bufftime("Х��") > 3 and rage() < 50 then
			cast("ѩ����")
		end

		_, v["6���ڹ�������"] = npc("��ϵ:�ж�", "����<6", "��ѡ��")
		if v["6���ڹ�������"] >= 3 then
			cast("������ɽ")
		end
		
		cast("�ϳ�")
		if gettimer("�Ʒ����") > 0.3 then
			cast("�Ʒ����")
		end
		cast("Ϧ���׷�")

		if rela("�ж�") and dis() > 13 and dis() < 20 then
			acast("�׹��ɽ")
		end
	end

end

--���ڹ�ʱ����
function OnMountKungFu(KungFu, Level)
	v["�ȴ��ڹ��л�"] = false
end


local tSkill = {
[1686] = "÷������buff",
[13] = "���񽣷�",
[1797] = "��ͨ�������л���",
}

--�ͷż���
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if tSkill[SkillID] then return end

	if CasterID == id() then
		--[[
		if TargetType == 2 then		--����2 ��ָ��λ��, ���� 3 4 ��ָ����NPC�����
			print("OnCast->["..xname(CasterID).."] �ͷ�:"..SkillName..", ����ID:"..SkillID..", ���ܵȼ�:"..SkillLevel..", Ŀ��λ��:"..TargetID.."|"..PosY.."|"..PosZ..", ��ʼ֡:"..StartFrame..", ��ǰ֡:"..FrameCount)
		else
			print("OnCast->["..xname(CasterID).."] �ͷ�:"..SkillName..", ����ID:"..SkillID..", ���ܵȼ�:"..SkillLevel..", Ŀ��ID:"..TargetID..", ��ʼ֡:"..StartFrame..", ��ǰ֡:"..FrameCount)
		end
		--]]

	end
end
--]]


local tBuff = {
[1739] = "��÷",
}

--[[����buff
function OnBuff(CharacterID, BuffName, BuffID, BuffLevel, StackNum, SkillSrcID, StartFrame, EndFrame, FrameCount)
	if tBuff[BuffID] then return end

	if CharacterID == id() then
		if StackNum > 0 then
			print("���buff: "..BuffName, "ID: "..BuffID, "�ȼ�: "..BuffLevel, "����: "..StackNum, "ʣ��ʱ��:"..((EndFrame - FrameCount) / 16))
		else
			print("�Ƴ�buff: "..BuffName)
		end
	end
end
--]]
