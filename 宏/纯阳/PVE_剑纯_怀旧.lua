output("----------����----------")
output("2 3 2")
output("2 2 0 3")
output("3 0 0 2")
output("2 0 2 2")
output("2 1 0 1")
output("1 0 1")
output("0 3 2")


--��ѡ��
addopt("����������", true)
addopt("������", true)

--������
local v = {}

--�ȴ���־
local bWait = false

--��ѭ��
function Main(g_player)
	if casting("���ǳ�") and castleft() < 0.13 then
		settimer("���ǳ���������")
	end

	if nofight() then
		if nobuff("�¹�����") then
			cast("�¹�����")
		end
		if nobuff("��������") then
			cast("��������")
		end
	end

	--Ŀ�겻�ǵ��ˣ�����ִ��
	if not rela("�ж�") then return end

	--���ǳ�
	v["���ǳ�"], v["���ǳ�����"] = tnpc("��ϵ:�Լ�", "����:�������ǳ�", "����<5.5", "�Լ�����<9.5")

	if v["���ǳ�����"] < 3 and qidian() < 8 then
		fcast("���ǳ�")
	end

	--����������
	if getopt("����������") and dungeon() and nofight() then return end

	--���
	if tbuffstate("�ɴ��") then
		cast("���ɾ���")
	end

	--�ȴ�����ͬ��
	if bWait then
		if gettimer("躹�����") < 0.3 then return end
		if gettimer("���ɾ���") < 0.3 then return end
	end

	--���ɲ���GCD���˺�
	if not getopt("������") and cdleft(16) > 1 and qidian() < 8 and gettimer("躹�����") > 0.3 and nobuff("躹�����") then
		if cast("���ɾ���") then
			bWait = true
			settimer("���ɾ���")
			return
		end
	end


	--����
	if dis() < 4 and tlifevalue() > lifemax() * 5 then
		cast("�ͻ���ɽ")

		if qidian() < 2 and cdtime("�˽���һ") > 5 then
			if cast("躹�����") then
				bWait = true
				settimer("躹�����")
				return
			end
		end

		if cdtime("���ǳ�") > 8 and cdtime("�˽���һ") < 5 then
			cast("תǬ��")
		end
	end

	if qidian() >= 8 and mana() < 0.3 then
		cast("��Ԫ��ȱ")
	end


	if qidian() >= 8 then
		if fcast("�����޽�") then
			cast("�������")
			return
		end
	end

	if v["���ǳ�"] ~= 0 then
	--if v["���ǳ�����"] >= 3 or (v["���ǳ�"] ~= 0 and cdtime("���ǳ�") > 3) then
		fcast("�˽���һ")
	end

	if tbufftime("����", id()) < 5 then
		if fcast("�����޽�") then
			cast("�������")
			return
		end
	end

	if tlife() > 0.4 and tlife() < 0.6 then
		fcast("�˻Ĺ�Ԫ")
	end
	if tlife() < 0.4 and tbufftime("����", id()) > 12.5 then
		fcast("�˻Ĺ�Ԫ")
	end

	if tbuff("��һ|����", id()) then
		fcast("����޼�")
	end

	fcast("��������")

	if gettimer("���ǳ���������") > 0.3 and qidian() < 8 then
		cast("�������")
	end
end

--�������
OnQidianUpdate = function()
	bWait = false
end

--�ͷż���
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	--[[
	if CasterID == id() then
		if TargetType == 2 then		--����2 ��ָ��λ��, ���� 3 4 ��ָ����NPC�����
			print("OnCast->["..xname(CasterID).."] �ͷ�:"..SkillName..", ����ID:"..SkillID..", ���ܵȼ�:"..SkillLevel..", Ŀ��λ��:"..TargetID.."|"..PosY.."|"..PosZ..", ��ʼ֡:"..StartFrame..", ��ǰ֡:"..FrameCount)
		else
			print("OnCast->["..xname(CasterID).."] �ͷ�:"..SkillName..", ����ID:"..SkillID..", ���ܵȼ�:"..SkillLevel..", Ŀ��ID:"..TargetID..", ��ʼ֡:"..StartFrame..", ��ǰ֡:"..FrameCount)
		end
	end
	--]]
end
