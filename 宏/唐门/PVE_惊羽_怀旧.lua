output("----------����----------")
output("2 3 2")
output("3 2 2 0")
output("2 1 2 0")
output("1 1 2 0")
output("0 2 3 0")
output("1")
output("0 3 2")
output("0 0 0 2")


--��ѡ��
addopt("����������", true)
addopt("��׷", true)


--������
local v = {}
v["�ȴ����Ǽ��ͷ�"] = false
v["�ȴ��������ͷ�"] = false
v["���Ǽ��ͷ�Ŀ��"] = 0
v["��������"] = "50354"			--��������buffid
v["������Ǽ�"] = "50349"		--��������û�������buffid
v["�����ʯ��"] = "50351"		--��������û�����ʯ��buffid



function Main(g_player)
	--�����������������õȴ���־Ϊ��
	if casting("���Ǽ�") and castleft() < 0.13 then
		v["�ȴ����Ǽ��ͷ�"] = true
		settimer("���Ǽ���������")
	end
	if casting("������") and castleft() < 0.13 then
		v["�ȴ��������ͷ�"] = true
		settimer("�������������")
	end

	--�ȴ����Ǽ��ͷ����
	if v["�ȴ����Ǽ��ͷ�"] and gettimer("���Ǽ���������") < 0.35 then
		return
	end

	--�ȴ����Ǽ��ͷ����
	if v["�ȴ��������ͷ�"] and gettimer("�������������") < 0.35 then
		return
	end

	
	----------------------------------------��ʼ���

	if getopt("����������") and dungeon() and nofight() then return end


	--���
	if tbuffstate("�ɴ��") then
		cast("÷����")
	end

	--��ɢ
	if rela("�ж�") and tbufftype("��������|��������|��������|��Ԫ������") > 0 then
		cast("жԪ��")
	end


	v["���ֵ"] = energy()

	--����
	if rela("�ж�") and dis() < 24 then
		if cdleft(16) < 0.5 then		--GCD�����
			cast("�ͻ���ɽ")
		end

		if bufftime(v["��������"]) > 6 and tlifevalue() > lifemax() * 10 and cdleft(16) > 0.5 then	--������, Ŀ�굱ǰ��Ѫֵ�����Լ������Ѫֵ10��, GCD����0.5(���ֵͬ��)
			cast("��������")
		end
	end

	if tnobuff("��Ѫ��", id()) then
		cast("��Ѫ��")
	end

	--׷����
	if buff("׷������") and cdtime("׷����") < 0.5 then
		if rela("�ж�") and dis() < 23 and cdtime("׷����") <= 0 and v["���ֵ"] >= 45 and bufftime("׷������") > 5 and tlifevalue() > lifemax() * 2 then
			cast("������Ӱ")
		end
		cast("׷����")
		return
	end

	if buff("������Ӱ") and cdtime("׷����") < 1 then
		return
	end

	if buff(v["��������"]) then
		cast("���Ǽ�")
	end

	if buff(v["��������"]) and nobuff(v["�����ʯ��"]) then		--������, û�����ʯ��
		if buff("����") or v["���ֵ"] >= 80 or bufftime("��������") > 1 then				--�а���������ֵ�㹻
			cast("��ʯ��")
		end
	end

	if bufftime(v["��������"]) > casttime("���Ǽ�") and nobuff(v["������Ǽ�"]) then		--��������û�������
		cast("���Ǽ�")
	end

	if bufftime(v["��������"]) > casttime("������") then
		cast("������")
	end

	if bufftime(v["��������"]) > 1 then
		cast("������")
	end

	
	--if buffsn("����") >= 2 then
		cast("��ȸ��")
	--end

	--
	if nobuff("׷������") then
		cast("���Ǽ�")
	end
	--]]

	--[[�����滨��
	v["ǧ���ٿ�"] = false
	if tbufftime("ǧ���ٿ�", true) > 2 then
		v["ǧ���ٿ�"] = true
	end
	if tbuff("50335", true) and tid() == v["���Ǽ��ͷ�Ŀ��"] and gettimer("���Ǽ��ͷ�") < 0.5 then		--��[���Ʒ�ī]��ǣ��ն�Ŀ���ͷ��˶��Ǽ�
		v["ǧ���ٿ�"] = true
	end

	if v["ǧ���ٿ�"] then
		cast("�����滨��")
	end
	--]]

	if energy() >= 64 then 
		cast("���Ǽ�")
	end

end


--�ͷż���
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		if SkillName == "���Ǽ�" then
			v["�ȴ����Ǽ��ͷ�"] = false		--�ͷ����, �ȴ�����
			v["���Ǽ��ͷ�Ŀ��"] = TargetID	--��¼Ŀ��
			settimer("���Ǽ��ͷ�")
		end

		if SkillName == "������" then
			v["�ȴ��������ͷ�"] = false
		end
	
		--[[
		if SkillID == 64083 then
			if TargetType == 2 then		--����2 ��ָ��λ��, ���� 3 4 ��ָ����NPC�����
				print("OnCast->["..xname(CasterID).."] �ͷ�:"..SkillName..", ����ID:"..SkillID..", ���ܵȼ�:"..SkillLevel..", Ŀ��λ��:"..TargetID.."|"..PosY.."|"..PosZ..", ��ʼ֡:"..StartFrame..", ��ǰ֡:"..FrameCount)
			else
				print("OnCast->["..xname(CasterID).."] �ͷ�:"..SkillName..", ����ID:"..SkillID..", ���ܵȼ�:"..SkillLevel..", Ŀ��ID:"..TargetID..", ��ʼ֡:"..StartFrame..", ��ǰ֡:"..FrameCount)
			end
		end
		--]]
	end
end

--[[����buff
function OnBuff(CharacterID, BuffName, BuffID, BuffLevel, StackNum, SkillSrcID, StartFrame, EndFrame, FrameCount)
	if CharacterID == id() then
		if StackNum > 0 then
			print("���buff: "..BuffName, "ID: "..BuffID, "�ȼ�: "..BuffLevel, "����: "..StackNum, "ʣ��ʱ��:"..((EndFrame - FrameCount) / 16))
		else
			print("�Ƴ�buff: "..BuffName)
		end
	end
end
--]]
