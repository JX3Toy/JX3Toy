output("----------����----------")
output("2 3 0")
output("2 2 3 0")
output("0 1 2 2")
output("2 2 0 1")
output("2 1 2 1")
output("0 1 0")
output("2 3 0")
output("0 2 0 0")


addopt("����������", true)

local bWait = false		--�ȴ�����ͬ����־

function Main(g_player)

	--׽Ӱʽ����������ʱ��
	if casting("׽Ӱʽ") and castleft() < 0.13 then
		settimer("׽Ӱʽ")
	end

	--������
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

	--����������
	if getopt("����������") and dungeon() and nofight() then return end


	--���
	if tbuffstate("�ɴ��") then
		cast("����ʽ")
	end

	-----------------------------------------���

	--������ͬ��
	if bWait then
		if gettimer("������") < 0.3 or gettimer("�������") < 0.3 or gettimer("���ŭĿ") < 0.3 then
			return
		end
	end

	--������
	if rela("�ж�") and dis() < 4 and qidian() < 1 and tlifevalue() > lifemax() * 3 then
		if cast("������") then
			settimer("������")
			bWait = true
			return
		end
	end

	--���ľ�
	if rela("�ж�") and dis() < 4 and bufftime("���ŭĿ") > 10 then
		cast("���ľ�")
	end

	--�������
	if fight() and mana() < 0.3  and qidian() < 3 then
		if cast("�������") then
			settimer("�������")
			bWait = true
			return
		end
	end

	
	if fight() and life() < 0.45 then
		cast("�����")
	end


	if qidian() >= 3 then
		if rela("�ж�") and dis() < 4 then
			if cast("���ŭĿ") then
				settimer("���ŭĿ")
				bWait = true
				return
			end
		end

		cast("����ʽ")
		cast("Τ������")
	end

	if rela("�ж�") and dis() < 4 and tlifevalue() > lifemax() * 5 and bufftime("���ŭĿ") > 10 then
		cast("��վ�")
	end

	if rela("�ж�") and dis() < 4.5 then
		cast("��ɨ����")
	end

	cast("����ʽ")
	cast("��ȱʽ")
	cast("��ӽ�ɳ")
	cast("�ն��ķ�")

	if dis() > 8 then
		cast("����ʽ")
	end

	if qidian() < 3 and gettimer("׽Ӱʽ") > 0.5 and dis() < 8 then
		if buff("����ʽ") then		--����Ҫ������ûGCDֱ�ӷ�
			cast("׽Ӱʽ")
		end
		if cdleft(16) > 0.7 then	--��Ҫ����������GCD�м�
			cast("׽Ӱʽ")
		end
	end
end

--���Ǹ���
OnQidianUpdate = function()
	bWait = false
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
		bigtext("��� ���ڶ��� �ǻ�׹, ɢ��")
	end
end

tMapFunc["Ӣ�ۼ�����"] = function(g_player)
	if npc("����:������") ~= 0 then
		bigtext("���� ���ڶ��� ������")
		cast("��ҡֱ��")
	end
end

tMapFunc["Ӣ�۶����"] = function(g_player)
	--ը���Ļ�, ����ID:2303, ���ܵȼ�:2, Ŀ��ID:1074285037, ����֡��:32, ��ʼ֡:3667361, ��ǰ֡:3667362
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
	--�����2�Ŷ���
	if SkillID == 2303 then
		bigtext("[������] ��ʼ����:ը���Ļ�, �ƶ��������")
	end

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
	--��������1����, 5���ͷһ��
	if Name == "����" and SayText:find(name()) then
		settimer("�����ߺ�������")
		bigtext("����������")
	end

	--��������1����
	if Name == "�ء���а�" and SayText:find(name()) then
		bigtext("�� �ء���а� ����, ����")
	end

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
