--[[ ��Ѩ:[����][�ɷ�][�ҷ�][����][����][ʦ��][ֹ֪][����][����][�ƺ�][����][���ɺ���]
�ؼ�:
�� 2���� 1�˺� 1����
�� 2���� 2�˺�
�� 2���� 2�˺�
�� 2���� 2�˺�

ѭ��  ���������� - ��ɽ - �乬 - ���� - ����������
--]]

--�ر��Զ�����
setglobal("�Զ�����", false)

--������
local v = {}
v["�����Ϣ"] = true
v["�乬Ŀ��"] = 0

--������
local f = {}

--��ѭ��
function Main(g_player)
	if casting("�乬") and castleft() < 0.13 then
		settimer("�乬��������")
	end
	if casting("��|����") and castleft() < 0.13 then
		settimer("���������")
	end

	--��ʼ������
	v["�������"] = buffsn("24327")
	v["Ӱ������"] = 0
	for i = 3, 8 do
		if buff("999"..i) then
			v["Ӱ������"] = v["Ӱ������"] + 1
		end
	end
	v["Ŀ����ʱ��"] = tbufftime("��", id())
	v["Ŀ���ʱ��"] = tbufftime("��", id())
	v["����CD"] = scdtime("���ɺ���")
	v["��ӰCD"] = cdtime(14081)	--�ͻ�Ӱ������, ��ID
	v["Ŀ��Ѫ���϶�"] = rela("�ж�") and tlifevalue() > lifemax() * 5	--С�ֲ��뿪�����������ϵ��

	--��Ӱ��
	f["��Ӱ��˫��"]()

	--��Ӱ
	f["��Ӱ��б"]()

	--�ȴ�����buffͬ��, ��������buffûͬ������������ж�������
	if gettimer("�乬��������") < 0.5 then
		--print("---------�ȴ��������ͬ��")
		return
	end
	if gettimer("������ѩ") < 0.5 or gettimer("��ɽ��ˮ") < 0.5 then
		print("---------�ȴ��л�����")
		return
	end

	--���ָ�ɽ
	if nofight() and v["�������"] == 0 and v["����CD"] <= 0 and nobuff("��ɽ��ˮ") then
		f["��ɽ��ˮ"]()
	end

	--û��ս��ƽA
	if nofight() then
		CastX("��������")
	end

	--����� + �� + �乬���� ʱ��
	local nTime = casttime("��") + cdinterval(16) + casttime("�乬") + 0.5

	--------------------������ѩ--------------------
	if buff("9320") then
		if v["�������"] == 0 then
			if v["Ŀ����ʱ��"] < nTime or v["Ŀ���ʱ��"] < nTime then
				f["��ɽ��ˮ"]()
			end
		end

		if v["�������"] == 0 or v["�������"] == 4 then
			if CastX("��") then
				settimer("��")
			end
		end

		if v["�������"] == 0 or v["�������"] == 5 then
			CastX("��")
		end
	end

	--------------------��ɽ��ˮ--------------------
	if buff("9319") then
		--����
		if buff("���ɺ���") then
			f["���ɺ���"]()
			return
		end

		--�������ɺ���
		if fight() and v["Ŀ��Ѫ���϶�"] and dis() < 20 and nobuff("���ɺ���|֪������") then
			if cdtime("���ɺ���") < 0.5 then
				f["��Ӱ��˫"]()
				if v["��ӰCD"] > 1 then
					f["��ɽ��ˮ����"]()
				end
				if v["��ӰCD"] > 1 and scdtime(14229) > 1 then 
					if CastX("���ɺ���") then
						settimer("���ɺ���")
					end
				end
				return
			end
		end

		--�л�����
		if v["Ŀ����ʱ��"] > nTime and v["Ŀ���ʱ��"] > nTime then
			if gettimer("���ɺ���") > 0.5 and gettimer("��Ӱ��˫") > 0.5 then
				if v["�������"] == 0 or v["�������"] == 4 or v["�������"] == 5 then
					f["������ѩ"]()
				end
			end
		end

		if v["�乬Ŀ��"] ~= 0 and v["�乬Ŀ��"] == tid() then
			--print("----------�乬��ȴ�Ŀ��buffˢ��")
			return
		end
		
		if fight() and gettimer("��Ӱ��˫") > 0.5 then
			--if v["Ŀ����ʱ��"] <= casttime("�乬") or v["�������"] == 2 or v["�������"] == 6 then
			if v["Ŀ����ʱ��"] <= casttime("�乬") or v["�������"] == 2 then
				CastX("��")
			end

			--if v["Ŀ���ʱ��"] <= casttime("�乬") or v["�������"] == 3 or v["�������"] == 7 then
			if v["Ŀ���ʱ��"] <= casttime("�乬") or v["�������"] == 3 then
				CastX("��")
			end

			if v["�������"] == 0 or v["�������"] >= 5 then	--����5���ñ乬����
				if CastX("�乬") then
					settimer("�乬")
				end
			end
			
			if v["�������"] == 4 then
				CastX("��")
			end
		end
	end

	f["û�ż���"]()
end

--���ż��������Ϣ����������������
f["û�ż���"] = function()
	if fight() and rela("�ж�") and dis() < 20 and face() < 90 and cdleft(16) <= 0 and castleft() <= 0 and gettimer("�乬") > 0.5 and gettimer("��") > 0.5 and gettimer("���������") > 0.5 and state("վ��") then
		PrintInfo("----------û����, ")
	end
end

f["���ɺ���"] = function()
	if v["�������"] == 6 then
		CastX("��")
	end
	if v["�������"] == 5 then
		if CastX("�乬") then
			settimer("�乬")
		end
	end
	if v["�������"] == 4 then
		if buffsn("֪������") == 4 then	--���һ�κ���
			f["������ѩ"]()
		else
			CastX("��")
		end
	end
	if v["�������"] == 3 then
		if CastX("����") then
			settimer("��")
		end
	end
	if v["�������"] == 2 then
		CastX("��")
	end

	f["û�ż���"]()
end

f["������ѩ"] = function()
	if CastX(14070) then
		settimer("������ѩ")
		exit()
	end
end

f["��ɽ��ˮ"] = function()
	if CastX(14069) then
		settimer("��ɽ��ˮ")
		exit()
	end
end

f["��ɽ��ˮ����"] = function()
	cast(14229)
end

f["��Ӱ��˫"] = function()
	if cast(14081) then
		settimer("��Ӱ��˫")
	end
end

f["��Ӱ��˫��"] = function()
	if casting("��|����") and bufftime("��Ӱ��˫") < 0.5 then	--�������ʱ��쵽�ˣ����
		fcast(14162)
		return
	end
	if bufftime("��Ӱ��˫") <= casttime("�乬") then	--С��һ���乬����
		cast(14162)
		return
	end
	if scdtime(14229) > 1 and v["����CD"] > 1 then		--��ɽ�����������ù���
		if v["Ӱ������"] >= 6 or cn("��Ӱ��б") < 1 then	--Ӱ�����˻���Ӱ��б������
			cast(14162)
		end
	end
end

f["��Ӱ��б"] = function()
	if v["Ӱ������"] < 6 then
		if buff("���ɺ���|��Ӱ��˫") then
			cast("��Ӱ��б")
		end
	end
end

--�����Ϣ
function PrintInfo(s)
	local szinfo = "�������:"..v["�������"]..", Ŀ����:"..v["Ŀ����ʱ��"]..", Ŀ���:"..v["Ŀ���ʱ��"]..", ��Ӱ����:"..cn("��Ӱ��б")..", "..cntime("��Ӱ��б", true)..", �����:"..cn("��")..", �����"..cn("��")..", ����CD:"..v["����CD"]
	if s then
		szinfo = s..szinfo
	end
	print(szinfo)
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

--�ͷż��ܻص�
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		if SkillID == 14298 then	--�乬
			v["�乬Ŀ��"] = TargetID	--��¼Ŀ��ID
			return
		end
		if SkillID == 34676 then	--֪���˾�, ��������ȼ���21���˺����
			print("OnCast->�ͷ�:"..SkillName..", ����ID:"..SkillID..", ���ܵȼ�:"..SkillLevel..", Ŀ��ID:"..TargetID..", ��ʼ֡:"..StartFrame..", ��ǰ֡:"..FrameCount)
			return
		end
	end
end

--�������ָ��buff������Ƴ����
local tBuff = {
--[24247] = "ԭ��",	--�ҷ�
--[24754] = "ԭ��",	--����
--[24327] = "����",
--[9495] = "ԭ��",	--����
--[12576] = "�ƺ�",
--[9430] = "������ѩ��������",
}

--buff���»ص�
function OnBuff(CharacterID, BuffName, BuffID, BuffLevel, StackNum, SkillSrcID, StartFrame, EndFrame, FrameCount)
	if CharacterID == id() then
		--[[
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
		if StackNum  > 0 then
			if BuffID == 9319 then
				deltimer("��ɽ��ˮ")
				return
			end
			if BuffID == 9320 then
				deltimer("������ѩ")
				return
			end
			if BuffID == 24327 then	--����
				deltimer("�乬��������")
				return
			end
		end
	end
end

--����buff�б�ص�
function OnBuffList(CharacterID)
	if CharacterID == v["�乬Ŀ��"] then
		v["�乬Ŀ��"] = 0
	end
end

--ս��״̬�ص�
function OnFight(bFight)
	if bFight then
		print("--------------------����ս��")
	else
		print("--------------------�뿪ս��")
	end
end

--[[
	��	��
��	5	6
��	4	5
��	3	4
��	2	3
��	1	2
--]]
