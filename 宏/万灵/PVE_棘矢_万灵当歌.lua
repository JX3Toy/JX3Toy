--[[ ��Ѩ: [�سD][��ʸ][���][����][¹��][ɣ��][����][¬��][����][����][���][�������]
�ؼ�:
����	2���� 2�˺�
����	2��Ϣ 1���� 1����
����	3��Ϣ 1��Ѫ

����ǰ������������, ��Ȼ���ֳ��ɲ����, ������ͷ�ʱ���е����⵼���еĴ�ѭ����1�μ�ʸ����, ��ѭ������̫��ʵս���ٴ�����������
--]]

load("Macro/Lib_PVP.lua")

--�ر��Զ�����
setglobal("�Զ�����", false)

--��ѡ��
addopt("����������", false)

--������
local v= {}
v["�����Ϣ"] = true
v["ûʯ����"] = 0

--������
local f = {}

--��ѭ��
function Main()
	if casting("�����") and castleft() < 0.13 then
		settimer("����ض�������")
	end
	if gettimer("����ض�������") < 0.3 then return end

	--��ʼ������
	v["����"] = rage()
	v["����ӡ"] = beast()
	
	v["����CD"] = scdtime("�����")
	v["����CD"] = scdtime("��������")
	v["���ڳ��ܴ���"] = cn("���ڼ�׹")
	v["���ڳ���ʱ��"] = cntime("���ڼ�׹", true)
	v["����CD"] = scdtime("���绽��")
	v["����CD"] = scdtime("������Ұ")
	v["����CD"] = scdtime("�������")

	v["��������"] = buffsn("����")
	v["����ʱ��"] = bufftime("����")
	v["�ᴩ����"] = tbuffsn("�ᴩ", id())
	v["�ᴩʱ��"] = tbufftime("�ᴩ", id())
	v["��������"] = tbuffsn("����")
	v["����ʱ��"] = tbufftime("����", id())
	v["Ŀ��Ѫ���϶�"] = rela("�ж�") and tlifevalue() > lifemax() * 10


	--���ö���
	if not nextbeast("ӥ") then		--ֻ��ӥ
		setbeast( { "ӥ", "��", "��", "����", "Ұ��", "��" } )
	end

	--��������
	v["����ʱ��"] = math.max(buffstate("����ʱ��"), buffstate("ѣ��ʱ��"), buffstate("����ʱ��"))
	if v["����ʱ��"] - cdleft(16) > 1 then
		CastX("��������")
	end

	--Ӧ������
	if fight() and life() < 0.55 then
		CastX("Ӧ������")
	end

	--��������
	if v["����"] < 8 then
		if nofight() then		--û��ս�Ѽ�װ��
			CastX("��������")
		end

		if v["����"] < 1 then	--û����װ��, �Զ�װ�����GCD��1֡, �Լ�װ, ������ҲûӰ��, �����˻��ܿ�1֡
			CastX("��������")
		end
	end

	--����������
	if getopt("����������") and dungeon() and nofight() then return end

	--���ڼ�׹
	if v["����"] >= 8 then		--��������
		if rela("�ж�") and dis() < 30 then
			v["���һ֧��״̬"] = arrow(7)
			if v["���һ֧��״̬"] ~= 2 and v["���һ֧��״̬"] ~= 4 then	--���һ֧��û����
				CastX("���ڼ�׹")
			end
			
			if v["���ڳ��ܴ���"] >= 3 and bufftime("����") < 0 and v["����CD"] < 1 then	--��������û˲��
				CastX("���ڼ�׹")
			end
		end
	end

	--ûʯ����
	if buff("26862") then
		CastX("ûʯ����")
	end

	--��ʸ����
	if qixue("��ʸ") then
		if gettimer("�ͷ�ûʯ����") < 2 and v["����"] == 2 then	--ûʯ��Ѽ���1
			CastX("�����")
		end
	end

	--�����
	if v["����"] >= 8 and v["����ʱ��"] < 2.5 then	--���ִ����
		CastX("�����")
	end
	if v["����"] == 5 or v["����"] == 6 then	--ѭ����
		CastX("�����")
	end

	--�ڷ�����
	if buff("26861") and v["����"] >= 3 then
		if v["����"] == 3 then	--���3��
			CastX("�ڷ�����")
		end

		if v["����"] == 8 and v["����CD"] < 4.5 and v["����CD"] < cdinterval(16) then	--���С�ڴ�����
			CastX("�ڷ�����")
		end
	end

	--���绽��, ��Ŀ��Ľ�ɫ�������20�������Լ�������
	if fight() and rela("�ж�") and dis3() < 20 then
		CastX("���绽��")
	end
	
	--������Ұ
	if fight() and rela("�ж�") and dis3() < 20 then
		if v["��������"] < 5 and mana() > 0.8 then	--���ִ����
			CastX("������Ұ")
		end
	end

	--�������
	if v["Ŀ��Ѫ���϶�"] and v["����ʱ��"] > 12 and v["����"] < 5 then
		if gettimer("�ͷź�������") < 0.5 or v["����"] > 0 then	--GCD��ת��, �ų��ǿ�ʼ����, �Զ��ĺ��������Ų�����
			if v["����"] ~= 1 or gettimer("�ͷ�ûʯ����") > 2.5 or v["ûʯ����"] >= 3 then	--��ֹ����ûʯ����2��
				CastX("�������")
			end
		end
	end

	--�����
	if qixue("��ʸ") and v["����"] == 1 then	--���1֧��
		if gettimer("�ͷ�ûʯ����") > 1.75 or v["ûʯ����"] >= 2 then	--ûʯ2��֮��
			CastX("�����")
		end
	else
		CastX("�����")
	end


	if nofight() then
		g_func["�ɼ�"]()
	end
	--[[
	if fight() and rela("�ж�") and dis() < 25 and cdleft(16) <= 0 and castleft() <= 0 and gettimer("�������") > 0.5 and gettimer("�ڷ�����") > 0.5 then
		PrintInfo("---------- û����")
	end
	--]]
end

-------------------------------------------------------------------------------

--�����Ϣ
function PrintInfo(s)
	local t = {}
	if s then t[#t+1] = s end
	t[#t+1] = "����:"..v["����"]
	t[#t+1] = "����:"..mana()
	--t[#t+1] = "����ӡ:"..v["����ӡ"]

	t[#t+1] = "����:"..v["��������"]..", "..v["����ʱ��"]
	t[#t+1] = "�ᴩ:"..v["�ᴩ����"]..", "..v["�ᴩʱ��"]
	t[#t+1] = "����:"..v["��������"]..", "..v["����ʱ��"]
	
	t[#t+1] = "����CD:"..v["����CD"]
	t[#t+1] = "����CD:"..v["����CD"]
	t[#t+1] = "����CD:"..v["����CD"]
	--t[#t+1] = "����CD:"..v["����CD"]
	t[#t+1] = "����CD:"..v["����CD"]
	t[#t+1] = "����CD:"..v["���ڳ��ܴ���"]..", "..v["���ڳ���ʱ��"]

	print(table.concat(t, ", "))
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

-------------------------------------------------------------------------------

--�ͷż���
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		if SkillID == 35665 then	--ûʯ����
			v["ûʯ����"] = 0
			settimer("�ͷ�ûʯ����")
		end

		if SkillID == 35987 then	--ûʯÿ���Ӽ���
			v["ûʯ����"] = v["ûʯ����"] + 1
		end

		if SkillID == 36165 then
			print("----------��ʸ����")
		end

		if	SkillID == 35695 then	--���绽��
			settimer("�ͷ����绽��")
		end

		if SkillID == 35669 then	--��������
			settimer("�ͷź�������")
			print("----------------------------------------������������")
		end

		if SkillID == 35661 then	--�����
			deltimer("����ض�������")
		end
	end
end

--ս��״̬�ı�, ��־��¼һ�����ڷ�������
function OnFight(bFight)
	if bFight then
		print("--------------------����ս��")
	else
		print("--------------------�뿪ս��")
	end
end
