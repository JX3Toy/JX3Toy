--����˼·: ��ʯ֮�����2������ָ, ��4dot

--����ʱ�������Ϣ
output("----------��Ѩ----------")
output("[��ָ][���][����][̤��][���][ѩ����][����][����][����][ѩ��][����][���]")
output("�����ؼ�")


--������
local v = {}

--�ȴ������ͷű�־
local bWait = false

--��ѭ��
function Main(g_player)
	--���ľ���
	if nofight() and nobuff("���ľ���") then
		cast("���ľ���", true)
	end

	--����
	if fight() and life() < 0.6 and buffstate("����Ч��") < 36 then
		cast("���໤��", true)
	end

	--���
	if tbuffstate("�ɴ��") then
		cast("����ָ")
	end

	--�ڶ����������
	if casting("����ָ|����ع��|��������") and castleft() < 0.13 then
		bWait = true
		settimer("��������")
		return
	end

	--�ȴ������ͷ�
	if bWait and gettimer("��������") < 0.3 then
		return
	end

	
	v["����ʱ��"] = tbufftime("����ָ", true)
	v["����ʱ��"] = tbufftime("����ع��", true)
	v["����ʱ��"] = tbufftime("��������", true)
	v["��ѩʱ��"] = tbufftime("��ѩʱ��", true)
	v["��4dot"] = gettimer("�̺�") > 1.2 and v["����ʱ��"] > 0 and v["����ʱ��"] > 0 and v["����ʱ��"] > 0 and v["��ѩʱ��"] > 0


	if rela("�ж�") and dis() < 19 and tlifevalue() > lifemax() * 5 then
		--[��¥��Ӱ], 10��ī��
		if rage() < 45 then
			cast("��¥��Ӱ")
		end

		--[ˮ���޼�], 20��ī��, [��ɢ] 1487
		if rage() < 35 and bufftime("��ɢ") <= 0 then
			cast("ˮ���޼�")
		end

		--[�������], ������ʯ, ��ʯ�˺����30%, ����ָ����������
		if buffsn("��ѩ") == 1 and (gettimer("�̺�3") < 1 or v["����ʱ��"] <= 0) and (gettimer("�̺�1") < 1 or v["����ʱ��"] <= 0) then
			cast("�������")
		end
	end


	--��ѩȺ��
	_, v["Ŀ�긽����������"] = tnpc("��ϵ:�ж�", "����<6", "��ѡ��")
	if v["Ŀ�긽����������"] >= 3 then
		cast("��ѩʱ��")
	end

	--��ѩ���[����]
	if buffsn("��ѩ") >= 2 then
		cast("��ѩʱ��")
	end


	--��4dot, ����ʯ
	if v["��4dot"] then
		--ܽ�ز���ˢ��dot, ��ʯ����
		if scdtime("��ʯ���") < 1 then
			cast("ܽ�ز���")
		end

		cast("��ʯ���")
	end

	

	--��������ָ
	if gettimer("�������") < 0.5 or buff("�������") then
		if gettimer("��������") > 11 then		--�ж��Ѿ��Ź���������, ��ֹ�ظ�������ָ
			cast("����ָ")
		end
	end

	--��������
	if gettimer("��������") > 1.2 then
		if gettimer("�̺�3") < 1 or v["����ʱ��"] <= 0 then
			cast("��������")
		end
	end

	--����ָ����ī�ⴥ��[ѩ����], �����ѩ
	if buff("ˮ��|����Ѫ") and buffsn("��ѩ") < 2 and buffsn("����") < 2 then
		cast("����ָ")
	end

	--����ع��
	if gettimer("��������") > 1.2 and gettimer("����ع���ͷ�") > 1.2 then
		if gettimer("�̺�1") < 1 or v["����ʱ��"] <= 0 then
			cast("����ع��")
		end
	end

	--����ָ
	if gettimer("�̺�2") < 1 or v["����ʱ��"] <= 0 then
		cast("����ָ")
	end

	--��[����ָ]��20��ī�⣬��������Ļ�
	if rage() < 20 then
		cast("����ָ")
	end

	--10���%60��
	if fight() and mana() < 0.45 then
		cast("��ˮ����", true)
	end

end


--[[��ʼ����
function OnPrepare(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, Frame, StartFrame, FrameCount)
	if CasterID == id() then
		if TargetType == 2 then
			print("OnPrepare->["..xname(CasterID).."] ��ʼ����:"..SkillName..", ����ID:"..SkillID..", ���ܵȼ�:"..SkillLevel..", Ŀ��λ��:"..TargetID.."|"..PosY.."|"..PosZ..", ����֡��:"..Frame..", ��ʼ֡:"..StartFrame..", ��ǰ֡:"..FrameCount)
		else
			print("OnPrepare->["..xname(CasterID).."] ��ʼ����:"..SkillName..", ����ID:"..SkillID..", ���ܵȼ�:"..SkillLevel..", Ŀ��ID:"..TargetID..", ����֡��:"..Frame..", ��ʼ֡:"..StartFrame..", ��ǰ֡:"..FrameCount)
		end
	end
end
--]]


local tSkill = {
[17] = "����",
[18730] = "�������۵�һĿ��",
[285] = "����ع��_����DOT",
[6693] = "��_����ָ",
[14644] = "����ж�Ŀ����Ѫ���ӻ���Ч��",
[18722] = "���ݱ�Ǵ�����ѨЧ��",
[14941] = "��������ָ�˺�",
[6126] = "",
[6128] = "",
[6129] = "",
}

--�ͷż���
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	--����ͷż��ܵ����Լ�
	if CasterID == id() then
		--[����ָ][����ع��][��������]
		if SkillID == 179 or SkillID == 189 or SkillID == 190 then
			bWait = false		--�����ȴ�
			settimer(SkillName.."�ͷ�")		--��¼�ͷ�ʱ��, �����жϷ�ֹ�ظ�����
		end

		--[����ָ]����[̤��]����dot, ȡ��� �ȼ� 1 ����, 2 ����, 3 ����, 0 ��ѩ, Ŀ��buffͬ������������ж�Ŀ��û�ж�Ӧ��buff
		if SkillName == "�̺�" then
			local level = SkillLevel % 4
			settimer("�̺�"..level)		--���ö�Ӧ���ܼ�ʱ��
			settimer("�̺�")			--����ȼ��̺����ж�4dot��ȫ
		end

		if SkillID == 13847 then		--[����ָ]��������
			settimer("��������")
		end

		if SkillID == 13848 then		--[����ָ]��������
			settimer("��������")
		end
	end

	--[[���������Ϣ
	if CasterID == id() then
		--���˵�����Ҫ�ļ���
		if tSkill[SkillID] then return end
		
		if TargetType == 2 then
			print("OnCast->["..xname(CasterID).."] �ͷ�:"..SkillName..", ����ID:"..SkillID..", ���ܵȼ�:"..SkillLevel..", Ŀ��λ��:"..TargetID.."|"..PosY.."|"..PosZ..", ��ʼ֡:"..StartFrame..", ��ǰ֡:"..FrameCount)
		else
			print("OnCast->["..xname(CasterID).."] �ͷ�:"..SkillName..", ����ID:"..SkillID..", ���ܵȼ�:"..SkillLevel..", Ŀ��ID:"..TargetID..", ��ʼ֡:"..StartFrame..", ��ǰ֡:"..FrameCount)
		end
	end
	--]]

end
--]]


local tBuff = {
[103] = "��Ϣ",
[24277] = "��_��ս������ʧ",
[24281] = "��_��ս������ʧ_ս��ά��",
[23390] = "NPC��ս����buff",
[11809] = "����",
[16756] = "�����������CD",
[12725] = "���ݼ��",
[12727] = "���ּ��A",
[12728] = "����ָ��ر��A",
[12588] = "�����ݱ��Ŀ���˺����",
[6266] = "����Ѫ",		--[����ָ]˲��
}

--[[�Լ��Ͷ���buff����
function OnBuff(CharacterID, BuffName, BuffID, BuffLevel, StackNum, SkillSrcID, StartFrame, EndFrame, FrameCount)
	--���˵�����Ҫ��buff
	if tBuff[BuffID] then return end

	--����Լ�buff
	if CharacterID == id() then
		if StackNum  > 0 then
			print("["..xname(CharacterID).."] ���buff: ".. BuffName..", ID: "..BuffID..", �ȼ�: "..BuffLevel..", ����: "..StackNum..", ԴID: "..SkillSrcID..", ��ʼ֡: "..StartFrame..", ��ǰ֡: "..FrameCount..", ����֡: "..EndFrame..", ʣ��ʱ��: "..(EndFrame-FrameCount)/16)
		else
			print("["..xname(CharacterID).."] �Ƴ�buff: ".. BuffName..", ID: "..BuffID..", �ȼ�: "..BuffLevel..", ����: "..StackNum..", ԴID: "..SkillSrcID..", ��ʼ֡: "..StartFrame..", ��ǰ֡: "..FrameCount)
		end
	end
end
--]]
