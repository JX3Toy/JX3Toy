output("----------����----------")
output("2 3 2")
output("0 2 2 3")
output("3 2 0 1")
output("2 2 0 2")
output("3 2 0 1")
output("1 1 0")
output("0 0 2")

--�ر��Զ�����
setglobal("�Զ�����", false)

--������û��ս������, �ڹ����ؾ�Ҫ�ر�
addopt("����������", false)

--�ȴ�����ָ�ͷű�־
local bWait = false

--���������ڴ�����ı���
local v = {}

--��ѭ��, ÿ��ִ��ʮ����
function Main(g_player)
	--[[���Լ�������, ̫�����ˣ���ע�͵����ֶ���
	if nofight() and nobuff("���ľ���") then
		cast("���ľ���", true)
	end
	--]]

	--��������Ѫ
	if fight() and rela("�ж�") and dis() < 4 and ttid() == id() then
		cast("����", true)
	end

	--����
	if fight() and life() < 0.6 and buffstate("����Ч��") < 36 then
		cast("���໤��", true)
	end

	--6���32%Ѫ
	if fight() and life() < 0.65 then
		cast("��������", true)
	end

	--��������ʱ�����ܻ�û���ͷţ�Ҫ�ȵ��ͷŲ�֪����û�д���[���][����]֮���Ч��
	if casting("����ָ") and castleft() < 0.13 then
		bWait = true
		settimer("����ָ��������")
	end

	--Ŀ��buffͬ�����ӳ�, ��ֹ�ظ�����
	if casting("��������") and castleft() < 0.13 then
		settimer("���ݶ�������")
	end
	if casting("����ع��") and castleft() < 0.13 then
		settimer("���ֶ�������")
	end

	--���
	if tbuffstate("�ɴ��") then
		cast("����ָ")
	end

	--��������
	local mapName = map()
	--print(mapName)
	local func = tMapFunc[mapName]
	if func then
		func(g_player)
	end

	--�ȴ�����ָ�ͷ�
	if bWait and gettimer("����ָ��������") < 0.3 then
		return
	end

	--Ŀ�겻�ǵж�, ����
	if not rela("�ж�") then return end

	--�ޱ��޵�, ����
	if tbuff("����") then return end

	--����������, �ڸ���û��ս, ����
	if getopt("����������") and dungeon() and nofight() then return end

	-------------------------------------------------------��ʼ���

	v["Ŀ��Ѫ���϶�"] = tlifevalue() > 20 * 10000		--Ŀ��Ѫ������20��ŷ�ˮ������

	--ˮ���޼�
	if rela("�ж�") and v["Ŀ��Ѫ���϶�"] and dis() < 18 and mana() < 0.9 then
		cast("ˮ���޼�")
	end

	--��ȡĿ��3dot��Ϣ
	v["����ָʱ��"] = tbufftime("����ָ", id())
	v["����ʱ��"] = tbufftime("����ع��", id())
	v["����ʱ��"] = tbufftime("��������", id())
	v["��3dot"] = v["����ָʱ��"] > 0 and v["����ʱ��"] > 0 and v["����ʱ��"] > 0

	v["���ʱ��"] = v["����ָʱ��"]
	if v["����ʱ��"] < v["���ʱ��"] then
		v["���ʱ��"] = v["����ʱ��"]
	end
	if v["����ʱ��"] < v["���ʱ��"] then
		v["���ʱ��"] = v["����ʱ��"]
	end

	--�������
	if rela("�ж�") and v["Ŀ��Ѫ���϶�"] and dis() < 18 and v["����ָʱ��"] <= 0 and v["����ʱ��"] <= 0 and v["����ʱ��"] <= 0 then
		if cdtime("��ʯ���") > 15 then	--������ʯ
			cast("�������")
		end
	end

	--��3dot
	if gettimer("�̺�") > 2 and v["��3dot"] then
		--��̵�һ������16�룬�ͱ�, ���ʱ����ݼ��ٵ���
		if v["���ʱ��"] > 16 then
			cast("��ʯ���")
		end

		--ܽ�ز���ˢ��dot
		if scdtime("��ʯ���") < 1 or (buff("��ѩ") and buffsn("��ѩ") >= 2) then
			if v["���ʱ��"] > 0.1 and v["���ʱ��"] < 10 then
				cast("ܽ�ز���")
			end
		end
	end

	--����
	if gettimer("����") > 2 and gettimer("���ݶ�������") > 0.3 then
		if gettimer("�̺�") < 1 or v["����ʱ��"] <= 0 then
			cast("��������")
		end
	end

	--����
	if gettimer("���ֶ�������") > 0.3 then
		if gettimer("�̺�") < 1 or v["����ʱ��"] <= 0 then
			cast("����ع��")
		end
	end

	--����
	if gettimer("�̺�") < 1 or v["����ָʱ��"] <= 0 then
		cast("����ָ")
	end

	--��ѩ
	if buff("��ѩ") and buffsn("��ѩ") >= 2 then
		cast("��ѩʱ��")
	end

	--10���%60��
	if fight() and mana() < 0.45 then
		cast("��ˮ����", true)
	end
	
	cast("����ָ")
end

--�ͷż���ʱִ��
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	--����ͷż��ܵ����Լ�
	if CasterID == id() then
		--�ͷ�����ָ, �ȴ�����
		if SkillName == "����ָ" then
			bWait = false
		end

		--����ָ����[����]����Ŀ��������
		if SkillID == 3037 then
			print("----------����")
			settimer("����")
		end

		--����[���]����ָ����3dot
		if SkillName == "�̺�" then
			print("----------�׺�")
			settimer("�̺�")
		end
		
		--[[�����¼�����ڵ���
		if TargetType == 2 then		--����2 ������λ��, ���� 3 4 �ǵ�NPC�����
			print("OnCast->["..xname(CasterID).."] �ͷ�:"..SkillName..", ����ID:"..SkillID..", ���ܵȼ�:"..SkillLevel..", Ŀ��λ��:"..TargetID.."|"..PosY.."|"..PosZ..", ��ʼ֡:"..StartFrame..", ��ǰ֡:"..FrameCount)
		else
			print("OnCast->["..xname(CasterID).."] �ͷ�:"..SkillName..", ����ID:"..SkillID..", ���ܵȼ�:"..SkillLevel..", Ŀ��ID:"..TargetID..", ��ʼ֡:"..StartFrame..", ��ǰ֡:"..FrameCount)
		end
		--]]
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
		settimer("�ء���а����")
		bigtext("�� �ء���а� ����, ����")
	end
end

-------------------------------------------------��������
tMapFunc = {}

tMapFunc["Ӣ�۷�����"] = function(g_player)
	--��1��2�޵�buff, �����
	if tbuff("����") then exit() end
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
	--��ɢ2��debuff
	xcast("��紹¶", party("û״̬:����", "����<20", "���߿ɴ�", "buff����ʱ��:���Բ���Ч��|��Ԫ�Բ���Ч��|���Բ���Ч��|��Ѩ����Ч��|���Բ���Ч��>1"))
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

	--�����ף�ֻ������ָ
	if tname("����") then
		cast("����ָ")
		exit()
	end

	--ѡ�ж�Ӧ��������
	for k,v in pairs(tWuXing) do
		if buff(k) then
			settar(npc("����:"..v))
			break
		end
	end

	--ƽA
	if tname("���С�����|���С�ľ��|���С�ˮ��|���С�����|���С�����") then
		cast("�йٱʷ�")
		exit()
	end

	--���� ������
	local hantang = npc("����:������")
	if hantang ~= 0 and xcastpass(hantang) > 2 then
		jump()
	end
end
