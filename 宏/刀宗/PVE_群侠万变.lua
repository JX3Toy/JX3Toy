--[[ ��Ѩ: [Ԩ��][����][����][���][����][����][����][����][����][ǿ��][���][��ԯ]
�ؼ�: ���ȵ�Ч���;���
����  1���� 2�˺� 1����
ͣ��  1�˺� 1���� 2��Ϣ
����  2�˺� 2����
����  1���� 2�˺� 1����
�۷�  3��Ϣ 1Ч��(��������)
�η�  2��Ϣ
����  2���� 2�˺�
����  2���� 2�˺�
�·�  2���� 2�˺�
����  1���� 2�˺� 1����

�Զ���Ӱ��, ����1Ӱ, λ����Ŀ���ʣ����һӰ��֮����΢�ƶ���, �ܼ����ܹ�ȥ��Ӱ�ӵ�ʱ��, 3Ӱ����۷�û��ȴҲͬ������, �Լ���ʶ������ʱ����ʱ������, �����з���Ч��
˫������, ���һ���·�, û��ս��Χû�ֵ�ʱ�������º�ͻ��Զ���˫��, ľ׮3����85������
--]]

--��ѡ��
addopt("�ֶ���Ӱ��", false)

--������
local v = {}
v["�����Ϣ"] = true
v["�Ź�����"] = false
v["����"] = energy()

--������
local f = {}

--��ѭ��
function Main()
	--��ʼ������
	v["����"] = buff("24029")
	v["˫��"] = buff("24110")
	v["ʶ��ʱ��"] = bufftime("ʶ��")	--24108
	v["Ŀ����������"] = tbuffsn("����", id())	--24056
	v["Ŀ������ʱ��"] = tbufftime("����", id())
	v["��������"] = 0
	v["����ʱ��"] = -100
	for i = 1, 3 do
		local nTime = bufftime("2410"..4 + i)	--24105 24106 24107
		v["����"..i.."ʱ��"] = nTime
		if nTime >= 0 then
			v["��������"] = v["��������"] + 1
			v["����ʱ��"] = nTime
		end
	end
	v["ͣ��CD"] = scdtime("ͣ����")
	v["����CD"] = cdleft(2425)
	v["����CD"] = scdtime("������")
	v["�۷�CD"] = scdtime(32140)		--����������ID
	v["��ӰCD"] = scdtime("��Ӱ׷��")
	v["�η���ܴ���"] = cn("�η�Ʈ��")
	v["�η����ʱ��"] = cntime("�η�Ʈ��", true)
	v["����CD"] = scdtime("���ƶ���")

	--�ȴ���˫�л�
	if gettimer("������") < 0.3 or gettimer("�·�����") < 0.3 or gettimer("��Ӱ׷��") < 0.3 then
		--PrintInfo("----------�ȴ���˫�л�, ")
		return
	end

	--�ȴ����Ƴ�̽���
	if gettimer("�����Ƴ��") < 0.3 and buff("23885") then
		PrintInfo("----------�ȴ����Ƴ��: "..state()..", ")
		if state("���") then
			deltimer("�����Ƴ��")
		end
		return
	end
	
	--�ȴ��۷��ͷ�
	if gettimer("�۷�˲�") < 0.3 or gettimer("�ͷų۷�˲�") < 0.13 then
		--PrintInfo("----------�ȴ��۷��ͷ�, ")
		return
	end

	--��3Ӱ����
	v["��3Ӱ"] = v["��������"] == 1 and (v["����CD"] > 1 or v["�η����ʱ��"] < 50 or v["����ʱ��"] < 1)

	--�۷�˲�
	if miji(32140, "���η粽���۷�˲�����żͼ��ҳ") and nobuff("23953") then	--���ؼ� û����
		v["��۷�"] = false
		if rela("�ж�") and dis() < 30 and nofight() and v["ʶ��ʱ��"] < 1 then
			v["��۷�"] = "û��ս���ʶ��"
		end
		if v["ʶ��ʱ��"] < 0 and v["��3Ӱ"] then
			v["��۷�"] = "�������һ������"
		end
		if v["��۷�"] then
			if CastX("�۷�˲�") then
				return
			end
		end
	end

	if v["����"] then
		f["����"]()
	end

	if v["˫��"] then
		f["˫��"]()
	end

	f["��Ŀ���ƶ�"]()
end

f["����"] = function()

	--������ ������GCD 2436 1��, ������CD 2425 4��
	if v["����"] > 99 then
		CastX("������")
	end

	--��Ӱ׷��
	v["����Ӱ"] = false
	if nofight() and npc("��ϵ:�ж�", "����<30", "��ѡ��") == 0 then	--û��ս, ��Χ30��û����
		v["����Ӱ"] = "û��ս��˫"
	end
	if rela("�ж�") and dis() < 8 and v["����"] >= 30 then
		--if v["�Ź�����"] or  then
			v["����Ӱ"] = "30����"
		--end
	end
	if v["����Ӱ"] then
		if cdtime("��Ӱ׷��") <= 0 then
			CastX("������")
		end
		if CastX("��Ӱ׷��") then
			return
		end
	end

	--������
	if rela("�ж�") and dis() < range("������") and face() < 90 then
		if CastX("������") then
			return
		end
	end

	if v["ʶ��ʱ��"] > 0 and v["����"] <= 80 then
		CastX("������")
	end

	--������
	if v["����"] < 80 then
		if v["��������"] > 1 or v["��3Ӱ"] then
			f["������"]()
			return
		end
	end

	if v["����"] < 95 and v["��������"] <= 0 then
		CastX("ͣ����")
	end

	if v["����"] <= 80 then
		CastX("������")
	end

	if v["����"] < 95 then
		CastX("ͣ����")
	end

	if v["����"] < 100 then
		if v["����"] >= 90 and v["����"] < 95 and v["ͣ��CD"] < 0.5 then return end		--90-94 ����ͣ��CD
		CastX("������")
	end
end

f["˫��"] = function()
	--�·�����
	if rela("�ж�") and dis() < 6 and face() < 90 then
		v["��·�"] = false
		if tbuffsn("����", id()) > 2 then
			v["��·�"] = "3�㳤��"
		end
		if v["��ӰCD"] < 1 and v["�η����ʱ��"] < 1 then
			v["��·�"] = "����"
		end
		if v["��·�"] then
			if CastX("�·�����") then
				return
			end
		end
	end

	--�η�
	if rela("�ж�") and dis() < 8 then
		if tbuffsn("����", id()) > 1 then
			if v["ʶ��ʱ��"] < 0 and v["��������"] <= 0 and v["��ӰCD"] > 7 and v["����"] < 80 then
				CastX("�η�Ʈ��")
			end
		end
	end

	--��������
	if rela("�ж�") and dis() < 6 and face() < 90 then
		CastX("��������")
	end

	--���ƶ���
	if cdleft(2436) > 0.5 then
		CastX("���ƶ���")		--ֻ�����ͼ�� GCD 16
	end

	--������
	if cdleft(16) > 1 then
		if v["��������"] > 1 or v["��3Ӱ"] then
			f["������"]()
		end
	end
end

f["������"] = function()
	if getopt("�ֶ���Ӱ��") then return end

	if v["ʶ��ʱ��"] < 0 and v["��������"] > 0 and gettimer("�۷�˲�") > 0.5 and gettimer("�ͷų۷�˲�") > 1 then	--ûʶ�� ������
		--û�ڿ��ƽ�ɫ
		if not keydown("MOVEFORWARD") and not keydown("MOVEBACKWARD") and not keydown("TURNLEFT") and not keydown("TURNRIGHT") and not keydown("STRAFELEFT") and not keydown("STRAFERIGHT") and not keydown("JUMP") and state("վ��") then
			v["����"] = npc("ģ��ID:111366", "�������")	--���Լ����
			if v["����"] ~= 0 then
				local x, y, z = point(v["����"], 3, 0, v["����"], id())	--���ε��Լ�����3��
				if x > 0 then	--��ȡ����ȷ����
					PrintInfo("----------������, ")
					moveto(x, y, z)
					return true
				end
			end
		end
	end
	return false
end

f["��Ŀ���ƶ�"] = function()
	if getopt("�ֶ���Ӱ��") then return end
	--if v["ʶ��ʱ��"] < 28 then return end

	--���ȴ��������� ��ֹ��ɫʧȥ����
	if keydown("MOVEFORWARD") then	--����ǰ ֹͣ��
		moveb(false) return
	end
	if keydown("MOVEBACKWARD") then	--���º� ֹͣǰ
		movef(false) return
	end
	if keydown("STRAFELEFT") then	--������ƽ�� ֹͣ��ƽ��
		mover(false) return
	end
	if keydown("STRAFERIGHT") then	--������ƽ�ƣ�ֹͣ��ƽ��
		movel(false) return
	end

	if rela("�ж�") then
		if not keydown("TURNLEFT") and not keydown("TURNRIGHT") and not keydown("JUMP") then	--û������ת ��ת ��
			if v["ʶ��ʱ��"] > 0 or v["��������"] <= 0 then
				if dis() > 5 and gettimer("������") > 0.3 and gettimer("�����Ƴ��") > 0.3 then
					turn()		--����Ŀ��
					movef(true)	--��ǰ�ƶ�
				end
			end

			if dis() < 4 then
				if face() > 60 then	--����Ŀ��
					turn()
				end
				movef(false)	--ֹͣ��ǰ
			end
		end
	end
end

--�����Ϣ
function PrintInfo(s)
	local szPose = buff("24029") and "����" or "˫��"
	local szinfo = "����:"..v["����"]..", ��̬:"..szPose..", ʶ��:"..v["ʶ��ʱ��"]..", ����: "..v["��������"]..", "..v["����ʱ��"]..", ͣ��:"..v["ͣ��CD"]..", ����:"..v["����CD"]..", ����:"..v["����CD"]..", �۷�:"..v["�۷�CD"]..", ��Ӱ:"..v["��ӰCD"]..", �η�:"..v["�η���ܴ���"]..", "..v["�η����ʱ��"]..", ����:"..v["����CD"]..", ����GCD:"..cdleft(2436)..", ˫��GCD:"..cdleft(16)..", ��ǰ֡:"..frame()
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

--�ͷż���
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then

		if SkillID == 32140 then	--�۷�˲�
			stopmove()
			jump()	--��, ��ϳ۷�˲�
			deltimer("�۷�˲�")
			settimer("�ͷų۷�˲�")
		end
		
		if SkillID == 32134 then	--������
			v["�Ź�����"] = true
			deltimer("������")

			if self().IsHaveBuff(24108, 1) then		--��ʶ�Ƽ�50 ûʶ�Ƽ�20
				v["����"] = v["����"] + 50
			else
				v["����"] = v["����"] + 20
			end
		end
		
		if SkillID == 32166 then	--�����Ƴ��
			settimer("�����Ƴ��")
		end
		
		if SkillID == 32149 or SkillID == 32150 or SkillID == 32151 then	--����123��
			v["����"] = v["����"] + 5
		end
		
		if SkillID == 32153 then	--ͣ���˺��Ӽ���
			v["����"] = v["����"] + 10
		end
		
		if SkillID == 32135 then	--������
			v["����"] = 0
		end
		
		if SkillID == 32145 then	--�·�����
			v["�Ź�����"] = false
		end

		if v["����"] > 100 then
			v["����"] = 100
		end
	end
end

local tBuff = {
[23885] = "���Ƴ��",
[24108] = "ԭ��",
}

--buff����
function OnBuff(CharacterID, BuffName, BuffID, BuffLevel, StackNum, SkillSrcID, StartFrame, EndFrame, FrameCount)
	if CharacterID == id() then
		if StackNum  > 0 then
			if BuffID == 24110 then		--˫��
				deltimer("������")
				deltimer("��Ӱ׷��")
			end
			if BuffID == 24029 then		--����
				deltimer("�·�����")
			end
			if BuffID == 24172 then
				deltimer("�η�Ʈ��")
			end
		end

		--[[���buff��ɾ��Ϣ
		local szName = tBuff[BuffID]
		if szName then
			if szName ~= "ԭ��" then
				BuffName = szName
			end
			if StackNum  > 0 then
				print("OnBuff->���: ".. BuffName..", ID: "..BuffID..", �ȼ�: "..BuffLevel..", ����: "..StackNum..", ԴID: "..SkillSrcID..", ��ʼ֡: "..StartFrame..", ��ǰ֡: "..FrameCount..", ����֡: "..EndFrame..", ʣ��ʱ��: "..(EndFrame-FrameCount)/16)
			else
				print("OnBuff->�Ƴ�: ".. BuffName..", ID: "..BuffID..", �ȼ�: "..BuffLevel..", ����: "..StackNum..", ԴID: "..SkillSrcID..", ��ʼ֡: "..StartFrame..", ��ǰ֡: "..FrameCount)
			end
		end
		--]]
	end
end

--״̬����
function OnStateUpdate(nCurrentLife, nCurrentMana, nCurrentRage, nCurrentEnergy, nCurrentSunEnergy, nCurrentMoonEnergy)
	if nCurrentEnergy ~= v["����"] then
		print("--------------------OnStateUpdate, Ԥ���������, ����: "..nCurrentEnergy..", ��ǰ:"..v["����"]..", "..frame())
	end
	v["����"] = nCurrentEnergy
end

--ս��״̬�ı�
function OnFight(bFight)
	if bFight then
		print("--------------------����ս��")
	else
		print("--------------------�뿪ս��")
	end
end
