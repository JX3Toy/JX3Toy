--[[ ��Ѩ: [����][����][��Ұ][Ѫ��][����][����][ҵ�����][��ս][����][�ߺ�][����][���ƽ��]
�ؼ�:
�ܵ�  1���� 3�˺�
��ѹ  1��Ϣ 1���� 2�˺�
�ٵ�  1���� 2�˺� 1����
ն��  1���� 3�˺�
����  1���� 1�˺� 1��Ϣ 1Ч��
�ܷ�  2�˺� 2����
Ѫŭ  2��ŭ 2��Ѫ
--]]

--�ر��Զ�����
setglobal("�Զ�����", false)

--������
local v = {}
v["�����Ϣ"] = true
v["ŭ��"] = rage()

--��ѭ��
function Main(g_player)
	--����
	if fight() and life() < 0.6 then
		cast("�ܱ�")
	end

	--��ʼ������
	v["���Ʋ���"] = buffsn("����")
	v["�ܷ�ʱ��"] = bufftime("�ܷ�")
	v["ն��CD"] = cdleft(801)
	v["����CD"] = cdleft(800)
	v["Ѫŭ����"] = cntime("Ѫŭ", true)
	v["GCD"] = math.max(cdleft(16), cdleft(804))

	---------------------------------------------��
	if pose("���") then
		if gettimer("�ܷ�") < 0.5 then return end

		--ҵ��
		if (buff("��Ұ") and v["ŭ��"] < 10) or (v["ն��CD"] > cdinterval(16) + cdinterval(804) * 2 or v["����CD"] > cdinterval(16) * 2 + cdinterval(804) * 2) then
			if CastX("ҵ�����") then
				settimer("ҵ�����")
			end
		end

		--�ܷ�
		if gettimer("ҵ�����") > 1 then
			if v["ŭ��"] >= 25 and v["ն��CD"] < cdinterval(804) and v["����CD"] < cdinterval(804) + cdinterval(16) then
				if buff("26132") or nobuff("25939") then	--�л�ٻ�ûҵ��
					if CastX("�ܷ�") then		
						settimer("�ܷ�")
						return
					end
				end
			end
		end
		
		--��ŭ��
		if v["ŭ��"] < 15 or buff("25939") then		--ŭ��С��15����ҵ��
			if rela("�ж�") then
				CastX("��ѹ")
			end
			if cdtime("��ѹ") > 0 or dis() > 8 then
				CastX("����")
			end
		end
		CastX("�ܻ�")
		CastX("�ܵ�")
	end

	---------------------------------------------��
	if pose("�浶") then
		--����µ���ͬ�����
		if fight() and rela("�ж�") and dis() < 4 and cdleft(16) <= 0 and cdleft(804) <= 0 then
			if nobuff("8627") then
				print("--------------------����ûͬ��")
			end
		end

		if gettimer("�ܻ�") < 0.3 then return end

		v["û�����׻��Ѵ���"] = nobuff("�������") or buff("����")
		v["����û���CD"] = nobuff("8453") or bufftime("8453") > cdinterval(16) + 0.25	--buff 8453 ����, ����CD
		
		--���
		if buff("���") or buff("8474") then
			CastX("����")
		end

		--ն��
		if nobuff("���") and v["�ܷ�ʱ��"] > (cdinterval(16) + 0.125) * 3 and v["ŭ��"] >= 25 then
			CastX("ն��")
		end

		--����, 15��ŭ��
		if v["û�����׻��Ѵ���"] and v["����û���CD"] and nobuff("���") and v["ŭ��"] >= 25 and tbuff("��Ѫ", id()) and tnobuff("����", id()) then
			CastX("����")
		end

		--�ٵ�
		if nobuff("���") and buff("����") and v["����û���CD"] and bufftime("�������") > cdinterval(16) + 0.25 and v["ŭ��"] >= 15 then
			CastX("�ٵ�")
		end

		--����
		if nobuff("���") and v["�ܷ�ʱ��"] > (cdinterval(16) + 0.125) * 3 and bufftime("�������") < 0 then
			if v["���Ʋ���"] == 4 then
				if rela("�ж�") and dis() < 6 and face() < 50 then		--6*6 ����, �þ����ж�ģ�ʹ�Ĺ�������
					--local x, y = xxpos(id(), tid())
					--if x > 0 and x < 6 and y > -3 and y < 3 then
					if CastX("���ƽ��") then
						settimer("���ƽ��")
					end
				end
			end
		end

		--����
		if v["ն��CD"] > cdinterval(16) or v["ŭ��"] < 25 then
			CastX("����")
		end

		--����
		if nobuff("���") and v["�ܷ�ʱ��"] > (cdinterval(16) + 0.125) * 2 then
			if v["���Ʋ���"] >= 6 or v["ն��CD"] > cdinterval(16) + cdinterval(804) or v["����CD"] > cdinterval(16) * 2 + cdinterval(804) then
				if rela("�ж�") and dis() < 6 and face() < 50 then
					if CastX("���ƽ��") then
						settimer("���ƽ��")
					end
				end
			end
		end

		--��3
		if buff("22977") then
			CastX("��������")	--20�߳��
		end

		--��2
		if buff("22976") then
			if rela("�ж�") and dis() < 8 and face() < 90 then
				CastX("������Ӫ")	--8������
			end
		end

		--Ѫŭ
		if rela("�ж�") and (v["���Ʋ���"] < 4 or v["���Ʋ���"] == 5) and nobuff("22976|22977") then
			if v["ն��CD"] > cdinterval(16) + cdinterval(804) + v["GCD"] or v["����CD"] > cdinterval(16) * 2 + cdinterval(804) + v["GCD"] then
				if v["ŭ��"] < 10 and v["�ܷ�ʱ��"] > (cdinterval(16) + 0.125) * 3 + 0.5 then
					if CastX("Ѫŭ") then
						settimer("Ѫŭ")
					end
				end
			end
		end

		--�ٵ�
		if v["����CD"] > cdinterval(16) or v["ŭ��"] >= 15 then
			CastX("�ٵ�")
		end
	

		--�ն�
		if gettimer("Ѫŭ") > 1 and gettimer("���ƽ��") > 1 and nobuff("22976|22977") then
			if cdleft(16) <= 0.25 and cdleft(804) <= 0.25 then
				if v["ŭ��"] < 10 or v["����CD"] > cdinterval(16) then	--�򲻳�����
					if v["���Ʋ���"] < 4 or v["�ܷ�ʱ��"] < (cdinterval(16) + 0.125) * 2 then	--�򲻳�����
						if CastX("�ܻ�") then
							settimer("�ܻ�")
						end
					end
				end
			end
		end
	end

	--Ŀ���ǵж�, 4����, û���������Ϣ
	if fight() and rela("�ж�") and dis() < 4 and face() < 90 and cdleft(16) <= 0 and cdleft(804) <= 0 and visible() then
		PrintInfo("----------û����, ")
	end
end

--�����Ϣ
function PrintInfo(s)
	if s then
		print(s, "ŭ��:"..v["ŭ��"], "���Ʋ���:"..v["���Ʋ���"], "�ܷ�ʱ��:"..v["�ܷ�ʱ��"], "ն��CD:"..v["ն��CD"], "����CD:"..v["����CD"], "�ܷ�:"..cn("�ܷ�"), cntime("�ܷ�", true), "Ѫŭ:"..cn("Ѫŭ"), cntime("Ѫŭ"))
	else
		print("ŭ��:"..v["ŭ��"], "���Ʋ���:"..v["���Ʋ���"], "�ܷ�ʱ��:"..v["�ܷ�ʱ��"], "ն��CD:"..v["ն��CD"], "����CD:"..v["����CD"], "�ܷ�:"..cn("�ܷ�"), cntime("�ܷ�", true), "Ѫŭ:"..cn("Ѫŭ"), cntime("Ѫŭ"))
	end
end

--ʹ�ü���
function CastX(szSkill)
	if cast(szSkill) then
		if v["�����Ϣ"] then
			PrintInfo()
		end
		return true
	end
	return false
end

--�����ͷŻص���
local tFunc = {}

tFunc[13044] = function()	--�ܵ�
	v["ŭ��"] = v["ŭ��"] + 5
end

tFunc[13046] = function()	--����
	v["ŭ��"] = v["ŭ��"] + 15
end

tFunc[13047] = function()	--�ܻ�
	v["ŭ��"] = v["ŭ��"] + 10
end

tFunc[13045] = function()	--��ѹ
	v["ŭ��"] = v["ŭ��"] + 15
end

--�ͷż���
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		local func = tFunc[SkillID]
		if func then
			func()
		end
	end
end

local tBuff = {
[8627] = "����",
[26132] = "���",
[25939] = "ҵ��",
[25941] = "�������",
[8451] = "���",
[8453] = "������CD",
}

--buff����
function OnBuff(CharacterID, BuffName, BuffID, BuffLevel, StackNum, SkillSrcID, StartFrame, EndFrame, FrameCount)
	--����Լ�buff��Ϣ
	if CharacterID == id() then
		local szName = tBuff[BuffID]
		if szName then
			if StackNum  > 0 then
				if BuffID ~= 8627 or nobuff("8627") then
					print("OnBuff->���buff: ".. szName..", ID: "..BuffID..", �ȼ�: "..BuffLevel..", ����: "..StackNum..", ԴID: "..SkillSrcID..", ��ʼ֡: "..StartFrame..", ��ǰ֡: "..FrameCount..", ����֡: "..EndFrame..", ʣ��ʱ��: "..(EndFrame-FrameCount)/16)
				end
			else
				print("OnBuff->�Ƴ�buff: ".. szName..", ID: "..BuffID..", �ȼ�: "..BuffLevel..", ����: "..StackNum..", ԴID: "..SkillSrcID..", ��ʼ֡: "..StartFrame..", ��ǰ֡: "..FrameCount)
			end
		end
	end
end

--״̬����
function OnStateUpdate(nCurrentLife, nCurrentMana, nCurrentRage, nCurrentEnergy, nCurrentSunEnergy, nCurrentMoonEnergy)
	--print("OnStateUpdate, ŭ��: "..v["ŭ��"], nCurrentRage, "��ǰ֡: ".. frame())
	v["ŭ��"] = nCurrentRage
end
