--[[ ��Ѩ: [ˮӯ][����][˳ף][������][��ɽ][����][ب��][����][ӫ���][����][����][����]
�ؼ�:
������		1���� 3�˺�
������		1���� 3�˺�
�춷��		1��Ϣ 1���� 2�˺�
����		2��Ϣ 1Ч��
����		2��Ϣ 2Ч��
���ŷɹ�	1��Ϣ 2���� 1Ч��
���վ���	2��Ϣ 1Ч��(�Ƴ���ʱ���10��, ����)
--]]

--�ر��Զ�����
setglobal("�Զ�����", false)

--������
local v = {}
v["�����Ϣ"] = true
v["�������ӳ��������"] = 0

--��ѭ��
function Main(g_player)
	--�ȴ������濪ʼ����, ��������Ӽ��ܲ�����������, ����˲��������
	if gettimer("������") < 0.3 then print("----------�ȴ�����ʼ����") return end

	--����
	if fight() and life() < 0.6 then
		cast("���ű���")
	end

	---------------------------------------------��ʼ������
	v["����"] = rage()
	v["������CD"] = scdtime("������")
	v["�����м���"] = buffsn("24457")
	v["�춷�����ܴ���"] = cn("�춷��")
	v["�춷������ʱ��"] = cntime("�춷��", true)

	v["��1ʱ��"] = bufftime("17743")
	v["��2ʱ��"] = bufftime("17744")
	v["��3ʱ��"] = bufftime("17745")
	v["������"] = buff("18231")
	v["����ʱ��"] = math.min(v["��1ʱ��"], v["��2ʱ��"], v["��3ʱ��"])	--��̵�ʱ���������ʣ��ʱ��
	v["������"] = 0
	for i = 1, 3 do
		if v["��"..i.."ʱ��"] >= 0 then
			v["������"] = v["������"] + 1
		end
	end
	local tDeng = { 99569, 100085, 100086 }
	for i, nID in ipairs(tDeng) do			--��ȡ��ǿ������
		v["��"..i.."����"] = 0
		local deng = npc("��ϵ:�Լ�", "ģ��ID:"..nID)
		if deng ~= 0 then
			v["��"..i.."����"] = xbuffsn("24480", deng)
		end
	end
	v["����CD"] = scdtime("���վ���")

	v["ӫ���ʱ��"] = bufftime("ӫ���")	--��ÿ���ӳ� ���� ���� ���� ӫ���
	v["����"] = "����"
	v["����ʱ��"] = -100
	local tGX = { "ˮ��", "ɽ��", "����" }
	for i, szBuff in ipairs(tGX) do
		local nTime = bufftime(szBuff)
		v[szBuff.."ʱ��"] = nTime
		if nTime >= 0 then
			v["����"] = szBuff
			v["����ʱ��"] = nTime
		end
	end
	v["Ŀ�����ʱ��"] = tbufftime("17605", id())
	v["Ŀ����������"] = tbuffsn("����", id())
	v["Ŀ������ʱ��"] = tbufftime("����", id())
	v["����CD"] = scdtime("����")
	v["���Գ��ܴ���"] = cn("����")
	v["���Գ���ʱ��"] = cntime("����", true)

	local tSpeedXY, tSpeedZ = speed(tid())
	v["Ŀ�꾲ֹ"] = rela("�ж�") and tSpeedXY <= 0 and tSpeedZ <= 0

	---------------------------------------------�ȴ�buffͬ��
	if gettimer("���ŷɹ�") < 0.3 or gettimer("���վ���") < 0.3 then
		print("----------�ȴ���ͬ��")
		return
	end
	if gettimer("����") < 0.3 or gettimer("����") < 0.3 or gettimer("ף�ɡ�����") < 0.3 then
		print("----------�ȴ�����ͬ��")
		return
	end

	---------------------------------------------�����
	--С��3���ŵ�
	if rela("�ж�") and v["������"] < 3 then
		if CastX("���ŷɹ�") then return end
	end

	--���ù����µ�
	if rela("�ж�") and buff("24656") and gettimer("���ŷɹ�") >= 0.5 and gettimer("�ͷ����ŷɹ�") > 4 then
		if CastX("���ŷɹ�") then return end
	end

	--���շŵ�
	if rela("�ж�") and dis() < 20 and v["������"] < 3 then
		if CastX("���վ���") then return end
	end
	
	--������ʱ��
	if v["������"] >= 3 and v["����ʱ��"] < 3.5 then
		if nobuff("24656") and gettimer("������") >= 0.5 and v["��1����"] >= 3 and v["��2����"] >= 3 and v["��3����"] >= 3 then
			if CastX("���վ���") then return end
		end
	end

	--�Ƶ�
	if v["Ŀ�꾲ֹ"] and dis() < 20 and gettimer("���ŷɹ�") >= 0.5 then
		if v["������"] >= 3 or cn("���ŷɹ�") < 1 then	--��3���ƻ��߷Ų�����
			if tnpc("��ϵ:�Լ�", "ģ��ID:99569|100085|100086", "ƽ�����<5") == 0 then	--Ŀ��5����û���Լ��ĵ�
				for i = 1, 3 do
					if v["��"..i.."ʱ��"] > 0 then
						if cast(24857 + i) then
							break
						end
					end
				end
			end
		end
	end

	---------------------------------------------ƽA��ս
	if nofight() then
		CastX("���")
		return
	end

	---------------------------------------------��������
	v["Ŀ��û����"] = false
	if rela("�ж�") and dis() < 25 and v["Ŀ�����ʱ��"] < 0 and gettimer("ף�ɡ�����") >= 0.5 then
		v["Ŀ��û����"] = true
	end

	--����
	v["��Ҫ����"] = false

	--ˮ
	if v["ˮ��ʱ��"] >= 0 then
		if gettimer("ף�ɡ�ˮ��") > 0.3 then
			CastX("ף�ɡ�ˮ��", true)	--�������Լ�
		end
		v["��Ҫ����"] = "ˮ���"
	end
	
	--ɽ
	if v["ɽ��ʱ��"] >= 0 then
		if gettimer("ף�ɡ�ɽ��") > 0.3 then
			CastX("ף�ɡ�ɽ��")
		end

		if v["Ŀ��û����"] then
			v["��Ҫ����"] = "ɽ�����dot"
		end
	end

	--��
	if v["����ʱ��"] >= 0 then
		--������
		if gettimer("ף�ɡ�����") > 0.3 then
			local bCast = false
			if v["Ŀ�����ʱ��"] < 0 then	--Ŀ��û����
				bCast = true
			end
			if v["����CD"] < 0.25 then		---�������Ϻ�
				bCast = true
			end
			if v["����CD"] > 8 and v["���Գ��ܴ���"] > 0 then	--�ܱ�ɽ
				bCast = true
			end
			if bCast then
				if CastX("ף�ɡ�����") then return end
			end
		end
		
		--�Ź���������
		if nobuff("17825") and v["����CD"] > 7.5 then
			v["��Ҫ����"] = "���ɽ, �Ź�����"
		end
	end

	if v["��Ҫ����"] and gettimer("����") > 0.5 and gettimer("�ͷ�����") > 3 then
		if CastX("����") then
			print(v["��Ҫ����"])
			return
		end
	end

	--����
	v["��Ҫ����"] = false

	if fight() then
		if v["�����м���"] < 1 then
			v["��Ҫ����"] = "���в���С��1"
		elseif v["ˮ��ʱ��"] >= 0 then
			v["��Ҫ����"] = "ˮ��ֱ����"
		elseif v["����ʱ��"] >= 0 and nobuff("17825") then
			v["��Ҫ����"] = "�������������"
		elseif rela("�ж�") and v["Ŀ�����ʱ��"] < 3 then
			v["��Ҫ����"] = "Ŀ�����С��3��"
		end
	end

	if v["��Ҫ����"] then
		if CastX("����") then
			print(v["��Ҫ����"])
			return
		end
	end

	---------------------------------------------���־�

	--�������ðѶ�����
	if v["��1����"] >= 4 and v["��2����"] >= 4 and v["��3����"] >= 4 and v["����ʱ��"] > 3.5 then
		CastX("�춷��")
		CastX("������")
	end

	if v["����"] >= 70 then
		if v["������"] >= 3 or cn("���ŷɹ�") < 1 then
			CastX("������")
		end
	end

	if v["�춷������ʱ��"] < 3.5 then
		CastX("�춷��")
	end

	--���ӳ�����
	if v["�������ӳ��������"] < 3 and (nobuff("17825") or v["Ŀ�����ʱ��"] > 3) then
		if (v["ɽ��ʱ��"] > 0.5 and v["ɽ��ʱ��"] < v["����CD"] + 3) or (v["ӫ���ʱ��"] < v["����CD"] + 3) then
			if CastX("������") then
				print("----------���ӳ�����")
				return
			end
		end
	end

	--������������
	if v["Ŀ�����ʱ��"] > 3.5 and v["Ŀ����������"] < 10 then
		if CastX("������") then
			print("----------������������")
			return
		end
	end

	if v["�����м���"] > 0 then
		CastX("�춷��")
	end

	CastX("������")

	--if fight() and rela("�ж�") and dis() < 20 and face() < 90 and cdleft(16) <= 0 and castleft() <= 0 and gettimer("�춷��") > 0.3 and state("վ��|��·|�ܲ�|��Ծ") then
	--	PrintInfo("----------û����, ")
	--end
end

--�����Ϣ
function PrintInfo(s)
	local szinfo = "����:"..v["����"]..", ������:"..v["�����м���"]..", ������CD:"..v["������CD"]..", �춷��CD:"..v["�춷�����ܴ���"]..", "..v["�춷������ʱ��"]..", ӫ���:"..v["ӫ���ʱ��"]..", ����:"..v["����"]..", "..v["����ʱ��"]..", ����:"..v["Ŀ�����ʱ��"]..", ����:"..v["Ŀ����������"]..", "..v["Ŀ������ʱ��"]..", ����:"..v["����CD"]..", ����:"..v["���Գ��ܴ���"]..", "..v["���Գ���ʱ��"]..", ��:"..v["������"]..", "..v["����ʱ��"]..", ��ǿ��:"..v["��1����"]..", "..v["��2����"]..", "..v["��3����"]..", ����CD:"..v["����CD"]
	if s then
		szinfo = s..szinfo
	end
	print(szinfo)
end

--ʹ�ü��ܲ������Ϣ
function CastX(szSkill, bSelf)
	if cast(szSkill, bSelf) then
		settimer(szSkill)
		if v["�����Ϣ"] then PrintInfo() end
		return true
	end
	return false
end

--�����ͷ�
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		if SkillID == 24831 then	--ˮ
			settimer("����_ˮ��")
			print("----------����_ˮ��")
			return
		end
		if SkillID == 24832 then	--ɽ
			settimer("����_ɽ��")
			print("----------����_ɽ��")
			return
		end
		if SkillID == 24833 then	--��
			settimer("����_����")
			print("----------����_����")
			return
		end
		if SkillID == 24375 then	--����
			deltimer("����")
			settimer("�ͷ�����")
			return
		end
		if SkillID == 24378 then	--�ŵ�
			settimer("�ͷ����ŷɹ�")
			return
		end
		if SkillID == 32791 then	--������
			deltimer("������")
			return
		end
		if SkillID == 24410 or SkillID == 24744 or SkillID == 24745 then 	--������ ˮ ɽ ��
			v["�������ӳ��������"] = v["�������ӳ��������"] + 1
			return
		end
	end
end

--��ʼ����
function OnChannel(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, Frame, StartFrame, FrameCount)
	if CasterID == id() then
		if SkillID == 24409 or SkillID == 24410 or SkillID == 24744 or SkillID == 24745 then	--�����������Ӽ���
			deltimer("������")
		end
	end
end

local tBuff = {
[24656] = "�����ù����",
}

--buff����
function OnBuff(CharacterID, BuffName, BuffID, BuffLevel, StackNum, SkillSrcID, StartFrame, EndFrame, FrameCount)
	if CharacterID == id() then
		if StackNum  > 0 then
			if BuffID == 17588 or BuffID == 17801 or BuffID == 17802 then	--3������buff
				deltimer("����_ˮ��")
				deltimer("����_ɽ��")
				deltimer("����_����")
				deltimer("����")
				deltimer("�ͷ�����")
				v["�������ӳ��������"] = 0
			end
			if BuffID == 17743 or BuffID == 17744 or BuffID == 17745 then	--3����buff
				deltimer("���ŷɹ�")
				deltimer("���վ���")
			end
		else
			if BuffID == 17825 then	--������buff
				deltimer("ף�ɡ�����")
			end
		end

		--���buff��ɾ��Ϣ
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
	end
end

--ս��״̬�ı�
function OnFight(bFight)
	if bFight then
		print("--------------------����ս��")
	else
		print("--------------------�뿪ս��")
	end
end
