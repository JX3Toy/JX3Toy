--[[ ��Ѩ: [��÷��][ǧ�����][��ױ][��÷][����][������][����][����][ӯ��][����][ҹ��][����]
�ؼ�:
����  3�˺� 1����
����  2��Ϣ 1���� 1Ч��(�ϼ�������CD)
����  2���� 2�˺�
���  2��Ϣ 1���� 1Ч��
����  3��Ϣ 1Ч��(����)
--]]

--�ر��Զ�����
setglobal("�Զ�����", false)

--��ѡ��
addopt("����������", false)
addopt("���", false)

--������
local v = {}

--������
local f = {}

--��ѭ��
function Main(g_player)
	if fight() and life() < 0.6 then
		cast("��صͰ�")
	end

	if nobuff("����") then
		cast("�����ķ�")
	end

	if qixue("����") and nobuff("����") then
		cast("�Ĺ���", true)
	end

	if gettimer("��Ӱ����") < 0.3 then return end

	--����������
	if getopt("����������") and dungeon() and nofight() then return end

	--���
	if getopt("���") and tbuffstate("�ɴ��") then
		fcast("����ͨ��")
	end

	--�������
	local CY_Buffs = {
	"23190",	--��Ӱ
	"23191",	--����
	"23192",	--����
	"22695",	--����
	"26240",	--����
	}

	v["�������"] = 0
	for key, buffid in ipairs(CY_Buffs) do
		if buff(buffid) then
			v["�������"] = v["�������"] + 1
		end
	end

	v["Ŀ��Ѫ���϶�"] = rela("�ж�") and tlifevalue() > lifemax() * 5	--Ŀ�굱ǰѪ�������Լ����Ѫ��5��

	--����
	if v["Ŀ��Ѫ���϶�"] and dis() < 20 and face() < 60 and cdleft(16) < 0.5 and v["�������"] == 2 then
		cast("��������")
	end
	
	--��Ӱ
	if nobuff("22695") then
		if cast("��Ӱ����") then
			settimer("��Ӱ����")
			return
		end
	end

	--�����������
	if buff("25902") and buff("25910") then
		f["���Ҽ���"]()
	end

	f["�������"]()
	f["��������"]()
	f["��������"]()
	f["���Ҽ���"]()
end

f["�������"] = function()
	if nobuff("23192") then
		cast("�������")
	end
end

f["��������"] = function()
	if nobuff("23191") then
		cast("��������")
	end
end

f["��������"] = function()
	if nobuff("26240") then
		cast("��������")
	end
end

f["���Ҽ���"] = function()
	if nobuff("22695") then
		--�����°�����
		if rela("�ж�") and dis() < 25 and cdtime("���Ҽ���") <= 0 then
			cast("������")
		end
		cast("���Ҽ���")
	end
end

--�ͷż���
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		if SkillID == 546 then		--��Ӱ����
			deltimer("��Ӱ����")
		end
		if SkillID == 34611 then	--���ࡤ��
			print("OnCast: "..SkillName, SkillID, SkillLevel)
		end
		--if SkillID == 34613 then	--����
		--	print("OnCast: "..SkillName, SkillID, SkillLevel)
		--end
	end
end
