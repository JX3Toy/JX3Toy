output("��Ѩ: [����][��Ԫ][��ǿ][�޽�][�˼�][ԽԨ][�¾�][ѱ��][���][ϢԪ][����][Ǳ������]")

--��ѡ��
addopt("����������", true)

--������
local v = {}
v["�ȴ���ͬ��"] = false

--��ѭ��
function Main(g_player)
	--�ȴ������ɶ�����������ͬ��, ��ûͬ�����򲻳��޽�
	if casting("������") then
		if castleft() < 0.13 then
			settimer("�����ɶ�������")
			v["�ȴ���ͬ��"] = true
		end
		return
	end
	if mana() >= 0.7 then
		v["�ȴ���ͬ��"] = false
	end
	if v["�ȴ���ͬ��"] and gettimer("�����ɶ�������") < 0.5 then
		print("����ͬ��")
		return
	end

	--Ŀ�겻�ǵжԽ���
	if not rela("�ж�") then return end

	--����������
	if getopt("����������") and dungeon() and nofight() then return end

	--����
	if fight() and life() < 0.5 then
		cast("��Х����")
	end

	--�Ⱦ�
	if nobuff("��������") or (bufftime("�޽�") < 2 and mana() > 0.2) then
		if cast("������") then
			stopmove()			--ֹͣ�ƶ�
			settimer("������")
			return
		end
	end

	--��Ծ��ս
	if buff("18082") then		--��Ԫ3����
		cast("��ս��Ұ")
		cast("��Ծ��Ԩ")
	end

	if nobuff("��Ԫ") and mana() > 0.375 and bufftime("��������") > 12 then
		if cdtime("��ս��Ұ") < 1 then
			cast("��Ծ��Ԩ")
		end
		if cdtime("��Ծ��Ԩ") < 1 then
			cast("��ս��Ұ")
		end
	end

	--����
	cast("�����л�")

	if bufftime("��Ԫ") > 1 then
		cast("��������")
	else
		--Ǳ��
		--if buffsn("Ǳ�����á�Ǭ") >= 7 and bufftime("Ǳ�����á�Ǭ") > 1.8 then
		--	cast(18678)		--[ѱ��]Ǳ������, �������е�����
		--end
		if bufftime("Ǳ�����á�Ǭ") > 1.75 then
			if buffsn("Ǳ�����á�Ǭ") >= 7 or (buffsn("Ǳ�����á�Ǭ") >= 6 and bufftime("12522") < 3.125) then
				cast(18678)
			end
		end

		--��
		if dis() < 6 and face() < 90 then
			cast("����·")
		end

		--Ȯ��
		if dis() < 6 then
			cast("Ȯ������")
		end

		--���׻���
		cast("��������")
		cast("���˫��")
	end

	--����

end

--[[
local tBuff = {
[5754] = "����|����"
--[6385] = "����������",
[6377] = "�޽�",
[18083] = "��Ԫ",
}

--�Լ��Ͷ���buff����
function OnBuff(CharacterID, BuffName, BuffID, BuffLevel, StackNum, SkillSrcID, StartFrame, EndFrame, FrameCount)
	--����Լ�buff��Ϣ
	if CharacterID == id() then 
		if tBuff[BuffID] then
			if StackNum  > 0 then
				print("���buff: ".. BuffName..", ID: "..BuffID..", �ȼ�: "..BuffLevel..", ����: "..StackNum..", ԴID: "..SkillSrcID..", ��ʼ֡: "..StartFrame..", ��ǰ֡: "..FrameCount..", ����֡: "..EndFrame..", ʣ��ʱ��: "..(EndFrame-FrameCount)/16)
			else
				print("�Ƴ�buff: ".. BuffName..", ID: "..BuffID..", �ȼ�: "..BuffLevel..", ����: "..StackNum..", ԴID: "..SkillSrcID..", ��ʼ֡: "..StartFrame..", ��ǰ֡: "..FrameCount)
			end
		end
	end
end
--]]
