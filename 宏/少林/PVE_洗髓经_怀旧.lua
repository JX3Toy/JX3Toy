output("----------����----------")
output("2 3 1")
output("2 2 1 2")
output("2 1 2 3")
output("1 3 2 1")
output("2 3")
output("1")
output("0 0 2")


--��ѡ��, �Ƿ��T
addopt("��T", false)


--����
function SheShen()
	--������_��������_��Ѫ��_��������
	if map("Ӣ�۷�����") then
		if life() > 0.8 then
			xcast("�����", party("buffʱ��:��������>3"))
		end
	end

	--����
	if fight() and life() > 0.8 then
		xcast("�����", party("û״̬:����", "����<20", "��Ѫ<0.4", "�ڹ�:�뾭�׵�|�����ľ�|�����|��֪|����", "���߿ɴ�"))
	end
end

local bWait = false

function Main(g_player)

	if nofight() and nobuff("������") then
		cast("������", true)
	end

	--��������
	local mapName = map()
	--print(mapName)
	local func = tMapFunc[mapName]
	if func then
		func(g_player)
	end

	--���
	if tbuffstate("�ɴ��") then
		cast("����ʽ")
	end

	--������ͬ��
	if bWait and gettimer("������") < 0.3  then
		return
	end

	--������
	if rela("�ж�") and dis() < 4 and qidian() < 1 and tlifevalue() > lifemax() * 10 then
		if cast("������") then
			settimer("������")
			bWait = true
			return
		end
	end

	--����
	if fight() and life() < 0.5 and buffstate("����Ч��") < 38 then
		cast("�����", true)
	end

	--����
	SheShen()

	
	--ǿ��
	local hateID, hate = hatred()		--��ȡ��ǰĿ������ߵĵ����id�ͳ�ްٷֱ�
	if hateID ~= 0 and hateID ~= id() and hate > 1.15 then		--��������ߵĲ����Լ�, ���ֵ����115%
		if gettimer("Ħڭ����") > 2 and gettimer("��ȥ����") > 2 and gettimer("�����") > 2 then
			if cast("Ħڭ����") then
				settimer("Ħڭ����")
				bigtext("ǿ�� Ħڭ����")
			end
			if cast("��ȥ����") then
				settimer("��ȥ����")
				bigtext("ǿ�� ��ȥ����")
			end
		end
	end
	
	--[[
	if rela("�ж�") and ttid() ~= 0 and ttid() ~= id() then	--Ŀ���ǵжԣ�Ŀ����Ŀ�� �����Լ�
		cast("Ħڭ����")
		cast("��ȥ����")
	end
	--]]


	if rela("�ж�") and dis() < 5.5 and qidian() <= 1 then
		cast("��ʨ�Ӻ�")
	end

	
	if qidian() >= 3 then
		if rela("�ж�") and dis() < 4.5 then
			if tbufftime("���سɷ�", id()) < 3.5 or tbuffsn("���سɷ�", id()) < 5 then
				cast("���سɷ�")
			end
		end

		if fight() and nobuff("����Ǭ��") then
			cast("����Ǭ��")
		end

		if rela("�ж�") and tfight() and ttid() == id() then
			cast("��ɽʩ��")
		end

		if rela("�ж�") and dis() < 4.5 then
			cast("���سɷ�")
		end
	end

	--�����
	if rela("�ж�") and dis() < 5.5 then
		if cast("�����") then
			settimer("�����")
		end
	end

	if rela("�ж�") and dis() < 4.5 then
		cast("��ɨ����")
	end

	cast("�ն��ķ�")


end

-------------------------------------------------��������
tMapFunc = {}

tMapFunc["Ӣ�۷�����"] = function(g_player)
	--��1��2�޵�buff, �����
	if tbuff("����") then exit() end

	--��2 ��Ѫ�� ��������
	--xcast("�����", party("buffʱ��:��������>3"))
end

tMapFunc["Ӣ��������"] = function(g_player)
	if npc("����:�ǻ�׹") ~= 0 then
		bigtext("��� ��ʼ���� �ǻ�׹, ɢ��")
	end
end

tMapFunc["Ӣ�ۼ�����"] = function(g_player)
	if npc("����:������") ~= 0 then
		bigtext("���� ���ڶ��� ������")
		cast("��ҡֱ��")
	end
end

tMapFunc["Ӣ�۶����"] = function(g_player)
	--�����2�Ŷ��� ը���Ļ�
	if npc("����:ը���Ļ�") ~= 0 then
		bigtext("[������] ���ڶ��� ը���Ļ�")
		--�м��ˣ�������
		if buffstate("����Ч��") > 38 then
			return
		end
		--�ż���
		if cast("�����") then
			return
		end
		--û���ˣ���ҡ ��
		cast("��ҡֱ��")
		if buff("����") then
			jump()
		end
	end
end

local tWuXing = {
["���С���ľ"] = "���С�����",
["���С�����"] = "���С�ľ��",
["���С��׻�"] = "���С�ˮ��",
["���С��½�"] = "���С�����",
["���С���ˮ"] = "���С�����",
}

tMapFunc["��������"] = function(g_player)
	--ѡ��16���ھ������������
	settar(npc("����:����", "����<16", "�������"))

	--ѡ�ж�Ӧ��������
	for k,v in pairs(tWuXing) do
		if buff(k) then
			print(k, "����:"..v)
			settar(npc("����:"..v))
			break
		end
	end

	if tname("���С�����|���С�ľ��|���С�ˮ��|���С�����|���С�����") then
		cast("���Ϲ�")
		exit()
	end

	--���� ������
	local hantang = npc("����:������")
	if hantang ~= 0 and xcastpass(hantang) > 2 then
		jump()
	end
end


-------------------------------------------------�������ݼ�¼

--�Ƿ��¼
local bLog = false

--�ж϶����Ƿ�Boss, Ѫ������100���NPC������Boss
local IsBoss = function(CharacterID)
	if CharacterID >= 0x40000000 and xlifemax(CharacterID) > 100 * 10000 then
		return true
	end
	return false
end

--�ͷż���
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if bLog and dungeon() and IsBoss(CasterID) then
		if TargetType == 2 then		--����2 ��ָ��λ��, ���� 3 4 ��ָ����NPC�����
			print("OnCast->["..xname(CasterID).."] �ͷ�:"..SkillName..", ����ID:"..SkillID..", ���ܵȼ�:"..SkillLevel..", Ŀ��λ��:"..TargetID.."|"..PosY.."|"..PosZ..", ��ʼ֡:"..StartFrame..", ��ǰ֡:"..FrameCount)
		else
			print("OnCast->["..xname(CasterID).."] �ͷ�:"..SkillName..", ����ID:"..SkillID..", ���ܵȼ�:"..SkillLevel..", Ŀ��ID:"..TargetID..", ��ʼ֡:"..StartFrame..", ��ǰ֡:"..FrameCount)
		end
	end
end

--��ʼ����
function OnPrepare(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, Frame, StartFrame, FrameCount)
	if bLog and dungeon() and IsBoss(CasterID) then
		if TargetType == 2 then
			print("OnPrepareXYZ->["..xname(CasterID).."] ��ʼ����:"..SkillName..", ����ID:"..SkillID..", ���ܵȼ�:"..SkillLevel..", Ŀ��λ��:"..TargetID.."|"..PosY.."|"..PosZ..", ����֡��:"..Frame..", ��ʼ֡:"..StartFrame..", ��ǰ֡:"..FrameCount)
		else
			print("OnPrepare->["..xname(CasterID).."] ��ʼ����:"..SkillName..", ����ID:"..SkillID..", ���ܵȼ�:"..SkillLevel..", Ŀ��ID:"..TargetID..", ����֡��:"..Frame..", ��ʼ֡:"..StartFrame..", ��ǰ֡:"..FrameCount)
		end
	end
end

--������Ϣ
function OnWarning(Text)
	if bLog and dungeon() then
		print("OnWarning->"..Text)
	end
end

--npc����
function OnSay(Name, SayText, CharacterID)
	if bLog and dungeon() and IsBoss(CharacterID) then
		print("OnSay->["..Name.."]˵:"..SayText)
	end
end

--ϵͳ��Ϣ
function OnMessage(Text, Type)
	if bLog and dungeon() then
		print("OnMessage->"..Text, Type)
	end
end
