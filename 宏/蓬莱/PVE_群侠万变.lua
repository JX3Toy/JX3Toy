--[[ ��Ѩ: [Ԩ��][��ɣ][����][��Դ][����][���][����][���][�ݻ�][����][����][���]
�ؼ�:
��ˮ 1���� 3�˺�
ľ�� 1���� 3�˺�
���� 2��Ϣ 2����
��� 1���� 3�˺�
��� 1���� 2�˺� 1Ч��
Ծ�� 2��Ϣ 2����
���� 3���� 1Ч��
�ﻯ 3Ч�� 1����
���� 2���� 2�˺�
-]]

--��ѡ��
addopt("����������", false)

--������
local v = {}
v["�����Ϣ"] = true

--��ѭ��
function Main(g_player)
	if casting("��������") and castleft() < 0.13 then
		settimer("������������")
	end
	
	--��ʼ������
	v["Ծ��CD"] = scdtime("Ծ��ն��")
	v["����CD"] = scdtime("������ڤ")
	v["�麣CD"] = scdtime("�麣����")
	v["��CD"] = scdtime("������")
	v["����CD"] = scdtime("�������")
	v["ľ��CD"] = scdtime("ľ�����")
	local tSpeedXY, tSpeedZ = speed(tid())
	v["Ŀ�꾲ֹ"] = rela("�ж�") and tSpeedXY <= 0 and tSpeedZ <= 0
	v["����"] = buff("13475") and gettimer("�ͷ����") > 0.5
	v["�ﻯ"] = buff("13781")
	v["�۷�����ʱ��"] = bufftime("24192")
	v["���̲���"] = buffsn("24229")

	--Ŀ�겻�ǵжԽ���
	if not rela("�ж�") then return end
	--����������
	if getopt("����������") and dungeon() and nofight() then return end

	cast("���ͼ��")
	cast("�������")

	if gettimer("�ȴ�����ͬ��") < 0.5 or gettimer("�ȴ��ﻯͬ��") < 0.5 then
		--print("----------�ȴ�buffͬ��")
		return
	end

	-------------------------------------------------------����
	if v["����"] then		--����
		v["���"] = false
		if v["����CD"] > 1 and v["�麣CD"] > 1 and v["��CD"] > 1 then	--�Ʒ����������
			v["���"] = true
		end
		--���������5����4�����ܴ���, ��ע�͵����ֶ����������
		--if settimer("�ͷŸ���") > 5 then
		--	v["���"] = true
		--end

		if v["���"] then
			if CastX("������ء����") then
				settimer("�ȴ�����ͬ��")
				return
			end
		end

		if v["�ﻯ"] then
			if dis3() <= 4 then
				CastX("������ڤ")
			end
			if v["����CD"] > 0.5 then
				CastX("�麣����")
				CastX("������")
			end
		else
			if CastX("�ﻯ����") then
				settimer("�ȴ��ﻯͬ��")
				return
			end
		end

	-------------------------------------------------------����
	else
		v["�Լ�6���г۷�"] = npc("��ϵ:�Լ�", "ģ��ID:64696", "��ɫ����<6") ~= 0
		v["Ŀ��6���г۷�"] = xnpc(tid(), "��ϵ:�Լ�", "ģ��ID:64696", "ƽ�����<6") ~= 0

		--����
		if dis() < 6 and v["�Լ�6���г۷�"] and v["�۷�����ʱ��"] > 0 and v["����CD"] < 2 then
			if CastX("�������") then
				settimer("�ȴ�����ͬ��")
				return
			end
		end

		--��������ܽ���
		if cntime("��������", true) < cdinterval(16) then
			if gettimer("������������") > 0.5 and v["Ŀ�꾲ֹ"] and dis() < 5 then
				if CastX("��������") then
					settimer("��������")
				end
			end
		end

		--Ծ��
		if gettimer("������������") > 0.5 then
			CastX("Ծ��ն��")
		end

		--����
		if v["����CD"] > 3 then
			if dis3() <= 4 then
				CastX("������ڤ")
			end
		end

		--ľ��
		CastX("ľ�����")

		--�麣
		if v["����CD"] > 2.1875 then
			CastX("�麣����")
		end

		--����
		if gettimer("������������") > 0.5 and v["Ŀ�꾲ֹ"] and dis() < 5 then
			if CastX("��������") then
				settimer("��������")
			end
		end
		
		--��ˮ
		if dis() < 6 and face() < 60 then
			CastX("��ˮ��ǧ")
		end
	end

	if fight() and rela("�ж�") and dis() < 20 and cdleft(16) <= 0 and castleft() <= 0 and cdleft(1424) <= 0 and gettimer("��������") > 0.3 and state("վ��|�Ṧ") then
		PrintInfo("----------û����, ")
	end
end

--�����Ϣ
function PrintInfo(s)
	local szinfo = "ľ��CD:"..v["ľ��CD"]..", ����CD:"..cn("��������")..", "..cntime("��������", true)..", Ծ��CD:"..v["Ծ��CD"]..", ����CD:"..v["����CD"]..", �麣CD:"..scdtime("�麣����")..", ��CD:"..v["��CD"]..", ����CD:"..v["����CD"]..", �ﻯCD:"..cn("�ﻯ����")..", "..cntime("�ﻯ����", true)..", �۷�����ʱ��:"..v["�۷�����ʱ��"]..", ���̲���:"..v["���̲���"]
	if s then
		szinfo = s..szinfo
	end
	print(szinfo)
end

--ʹ�ü��ܲ������Ϣ
function CastX(szSkill)
	if cast(szSkill) then
		if v["�����Ϣ"] then
			PrintInfo()
		end
		return true
	end
	return false
end

--�ͷż���
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		if SkillID == 20944 then
			settimer("�ͷ����")
			return
		end
		if SkillID == 19828 then
			settimer("�ͷŸ���")
			return
		end
	end
end

local tBuff = {
[14083] = "ԭ��",	--̫Ϣ
[13475] = "ԭ��",	--����
[13781] = "�ﻯ",
}

--buff����
function OnBuff(CharacterID, BuffName, BuffID, BuffLevel, StackNum, SkillSrcID, StartFrame, EndFrame, FrameCount)
	if CharacterID == id() then
		if BuffID == 13475 then
			deltimer("�ȴ�����ͬ��")
		elseif BuffID == 13781 then
			deltimer("�ȴ��ﻯͬ��")
		end
		
		--[[���buff��ɾ��Ϣ
		local szName = tBuff[BuffID]
		if szName then
			if szName ~= "ԭ��" then
				BuffName = szName
			end
			if StackNum  > 0 then
				print("OnBuff->���buff: ".. BuffName..", ID: "..BuffID..", �ȼ�: "..BuffLevel..", ����: "..StackNum..", ԴID: "..SkillSrcID..", ��ʼ֡: "..StartFrame..", ��ǰ֡: "..FrameCount..", ����֡: "..EndFrame..", ʣ��ʱ��: "..(EndFrame-FrameCount)/16)
			else
				print("OnBuff->�Ƴ�buff: ".. BuffName..", ID: "..BuffID..", �ȼ�: "..BuffLevel..", ����: "..StackNum..", ԴID: "..SkillSrcID..", ��ʼ֡: "..StartFrame..", ��ǰ֡: "..FrameCount)
			end
		end
		--]]
	end
end

--ս��״̬�ı�
function OnFight(bFight)
	if not bFight then
		print("--------------------�뿪ս��")
	end
end
