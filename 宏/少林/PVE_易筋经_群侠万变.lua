--[[ ��Ѩ: [����][����][���][����][��ħ�ɶ�][���ŭĿ][����][����][����][����][�������][ҵ��]
�ؼ�:
�ն�	2��Ϣ 2�˺�
Τ��	1���� 2�˺� 1Ч��
��ɨ	1�˺� 1���� 1���� 1Ŀ��
����	2��Ϣ 2�˺�
��ȱ	1���� 3�˺�
����	1Ч�� 3�˺�
ʨ�Ӻ�	3��Ϣ 1Ч��
����	2��Ϣ 1���� 1����

--ÿ�δ��ǧ��׹�����˵㣬��3�����Ҿ���
--]]

--�ر��Զ�����
setglobal("�Զ�����", false)

--������
local v = {}

--������
local f = {}

--�ͷ����Ǳ䶯����
local CastX = function(szSkill, szReason)
	if cast(szSkill) then
		--if szReason then print(szReason) end
		settimer("�ȴ�����ͬ��")
		exit()
	end
end

--��ѭ��
function Main()
	--����
	if fight() and life() < 0.5 and buffstate("����Ч��") < 40 then
		cast("�����")
	end

	--�ȴ�����ͬ��
	if gettimer("�ȴ�����ͬ��") < 0.3 then return end

	--��ʼ������
	v["����"] = qidian()
	v["��ʱ��"] = bufftime("21619") - 12
	v["��ȡʱ��"] = bufftime("23069")
	v["����ʱ��"] = bufftime("23070")
	v["���������"] = npc("��ϵ:�Լ�", "ģ��ID:107539")
	v["���ڵ�������"] = 0
	if v["���������"] ~= 0 then
		_, v["���ڵ�������"] = xnpc(v["���������"], "��ϵ:�ж�", "����<8", "��ѡ��")
	end
	v["��צ������"] = buffsn("24454")
	v["Ŀ��Ѫ���϶�"] = rela("�ж�") and tlifevalue() > lifemax() * 5
	v["û�Ե���"] = v["��ʱ��"] < 0 or nobuff("�������")

	---------------------------------------------��ʼ���
	v["����ȡ����"] = false

	--�޺�����
	if rela("�ж�") and dis() < 8 and v["����"] >= 3 and cdleft(16) < 1 then
		if cast("�޺�����") then
			v["����"] = 0
			v["����ȡ����"] = true
		end
	end

	--��ҵ��Ե_��ħ
	if rela("�ж�") and dis() < 5 and nobuff("24620") and v["����"] <= 1 then		--24620 ҵ���Ĵ���CD
		CastX(15166, "��ʱ��: "..v["��ʱ��"]..", ��ɨCD: "..scdtime("��ɨ����")..", ǧ��׹CD:"..scdtime("ǧ��׹"))
	end

	--����Τ��
	if v["����"] >= 3 then
		if cast("����ʽ") then
			v["����ȡ����"] = true
		end
		if cast("Τ������") then
			v["����ȡ����"] = true
		end
	end

	if v["����ȡ����"] then
		if v["��ȡʱ��"] >= 0 and v["��ȡʱ��"] < 6.5 then
			f["ǧ��׹����ȡ"]("��ȡ ����Τ�Ӻ���")
		end

		if v["����ʱ��"] >= 0 and v["����ʱ��"] < 6.5 and bufftime("21619") < 0 then
			f["ǧ��׹������"]("���� ����Τ�Ӻ���")
		end

		settimer("�ȴ�����ͬ��")
		exit()
	end

	f["ҵ���ɨ��ȱ"]()

	if v["��ȡʱ��"] > 0 then
		f["��ɨ����"]()
	
		if v["��ȡʱ��"] <= cdinterval(16) and cdleft(16) >= 1 then
			f["ǧ��׹����ȡ"]("ʱ��С��1CD")
		end
	end

	if v["����ʱ��"] > 0 then
		if v["����ʱ��"] <= cdinterval(16) * 2 or scdtime("��ɨ����") <= cdinterval(16) then
			if buff("21617") then
				if tbufftime("�ն�") <= cdinterval(16) * 4 then
					CastX("�ն��ķ�", "���ն�, ��ɨCD: "..scdtime("��ɨ����"))
				end
			end
		end
		
		if cdleft(16) >= 1 then
			if v["û�Ե���"] then
				f["ǧ��׹������"]("û�Ե���")
			end

			if v["����ʱ��"] <= cdinterval(16) then
				f["ǧ��׹������"]("ʱ��С��1CD")
			end
		end
	end

	if v["��ȡʱ��"] <= 0 and v["����ʱ��"] <= 0 and v["��ʱ��"] > 0 then
		--��ҵ��Ե_����
		if rela("�ж�") and dis() < 5 and face() < 60 and v["Ŀ��Ѫ���϶�"] then
			--if scdtime("��ɨ����") < cdleft(16) and cdtime("��ȱʽ") < cdinterval(16) * 2 and v["����"] < 3 then
			if v["����"] < 3 and v["��ʱ��"] > cdinterval(16) * 9 then
				if cast(15165) then
					CastX("������")
				end
			end
		end

		if v["��ʱ��"] <= cdinterval(16) * 2 then
			f["�ն��ķ�"]("��ʱ��쵽��")
			--CastX("�ն��ķ�", "��ʱ��쵽��")
		end

		if scdtime("ǧ��׹") < cdinterval(16) and scdtime("��ɨ����") < cdinterval(16) * 2 then
			f["�ն��ķ�"]("ǧ��׹�ͺ�ɨ��ȴ��")
			--CastX("�ն��ķ�", "ǧ��׹�ͺ�ɨ��ȴ��")
		end

		if v["��ʱ��"] > 12 - cdinterval(16) then
			f["��ɨ����"]()
		end
	end

	--ǧ��׹
	if rela("�ж�") and face() < 60 then
		if v["û�Ե���"] then
			CastX("ǧ��׹", "û�Ե���")
		end
		if scdtime("��ɨ����") < cdinterval(16) then
			CastX("ǧ��׹", "��ɨ��ȴ")
		end
	end

	---------------------------------------------

	--׽Ӱʽ
	if buff("����ʽ") and cdleft(16) >= 1 then
		if buff("������") and v["����"] < 2 or v["����"] < 3 then
			CastX("׽Ӱʽ")
		end
	end

	CastX("��ȱʽ")

	if buff("�������") then
		CastX("����ʽ")
	end

	--��ʨ�Ӻ� ������
	if v["����"] <= 1 and miji("��ʨ�Ӻ�", "�����ķ�ħ������ʨ�Ӻ���żͼ��ҳ") then
		_, v["6���ڵ�������"] = npc("��ϵ:�ж�", "����<6", "��ѡ��")
		if v["6���ڵ�������"] >= 3 then
			CastX("��ʨ�Ӻ�")
		end
	end

	--û���ܴ��˻�����
	if nobuff("������") then
		if v["����"] <= 1 then
			CastX("Ħڭ����")
		end
		if nobuff("�������") then
			CastX("�ն��ķ�", "������")
		end
	end
end

f["��ɨ����"] = function(szReason)
	if rela("�ж�") and dis() < 5.5 then
		CastX("��ɨ����", szReason)
	end
end

f["�ն��ķ�"] = function(szReason)
	if buff("21617") and v["���ڵ�������"] > 0 then	--21617, �����ɨ
		CastX("�ն��ķ�", "�ն�, ����")
	end
		
	if tbufftime("�ն�") <= cdinterval(16) * 4 then
		CastX("�ն��ķ�", "�ն�, ���ն�")
	end
end

f["ҵ���ɨ��ȱ"] = function()
	if buff("24620") then		--ҵ���Ĵ���CD
		if tbufftime("��ɨ����") < 3.5 then
			f["��ɨ����"]("ҵ���ɨ")
		end
		
		if v["��צ������"] < 2 then
			if buffsn("24294") < 2 then
				f["��ɨ����"]("ҵ���ɨ")
			end
			if buffsn("24292") < 2 then
				CastX("��ȱʽ","ҵ����ȱ")
			end
		else
			if buffsn("24292") < 2 then
				CastX("��ȱʽ","ҵ����ȱ")
			end
			if buffsn("24294") < 2 then
				f["��ɨ����"]("ҵ���ɨ")
			end
		end
		exit()
	end
end

f["ǧ��׹����ȡ"] = function(szReason)
	if rela("�ж�") and dis() < 5 and face() < 60 then
		CastX("ǧ��׹����ȡ", szReason)
	end
end

f["ǧ��׹������"] = function(szReason)
	if rela("�ж�") and dis() < 5 and face() < 60 then
		CastX("ǧ��׹������", szReason)
	end
end

--�������
function OnQidianUpdate()
	--print("OnQidianUpdate, ����: "..math.min(qidian(), 3))
	deltimer("�ȴ�����ͬ��")
end

--�ͷż���
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		if SkillID == 29516 then
			print("�������������")
			return
		end
	end
end

local tBuff = {
[23069] = "��ȡ",
[23070] = "����",
[21619] = "��",
}

--buff����
function OnBuff(CharacterID, BuffName, BuffID, BuffLevel, StackNum, SkillSrcID, StartFrame, EndFrame, FrameCount)
	--����Լ�buff��Ϣ
	if CharacterID == id() then
		local szName = tBuff[BuffID]
		if szName then
			if StackNum  > 0 then
				print("OnBuff->���buff: ".. szName..", ID: "..BuffID..", �ȼ�: "..BuffLevel..", ����: "..StackNum..", ԴID: "..SkillSrcID..", ��ʼ֡: "..StartFrame..", ��ǰ֡: "..FrameCount..", ����֡: "..EndFrame..", ʣ��ʱ��: "..(EndFrame-FrameCount)/16)
			else
				print("OnBuff->�Ƴ�buff: ".. szName..", ID: "..BuffID..", �ȼ�: "..BuffLevel..", ����: "..StackNum..", ԴID: "..SkillSrcID..", ��ʼ֡: "..StartFrame..", ��ǰ֡: "..FrameCount)
			end
		end
	end
end
