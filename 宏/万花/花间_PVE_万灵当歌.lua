--[[ ��Ѩ: [��ָ][���][����][̤��][���][ѩ����][����][����][����][ѩ��][����][���]
�ؼ�:
��¥  2��Ϣ 1���� 1����
����  2�˺� 2����
����  1���� 1���� 2����
����  3���� 1����
ܽ��  1���� 2�˺� 1Ч��
��ѩ  3�˺� 1����
����  2��Ϣ 1���� 1����

0�κ�1�μ����²��ԣ����߼����Լ�����û������
--]]

--�ر��Զ�����
setglobal("�Զ�����", false)

--��ѡ��
addopt("����������", false)
addopt("�Զ��Զ�", false)

--������
local v = {}
v["��¼��Ϣ"] = true
v["����Ŀ��"] = 0
v["����Ŀ��"] = 0
v["����Ŀ��"] = 0
v["�̺�Ŀ��"] = 0

--������
local f = {}

--��ѭ��
function Main(g_player)
	--�����Զ����ݼ�1�ҷ�ҡ, ע���ǿ�ݼ��趨�������Ŀ�ݼ�1ָ���İ��������Ǽ����ϵ�1
	if keydown(1) then
		cast("��ҡֱ��")
	end

	--����
	if fight() and life() < 0.6 then
		cast("���໤��", true)
	end

	--�ȴ�����ָ����
	if casting("����ָ") and castleft() < 0.13 then
		settimer("����ָ��������")
	end
	if gettimer("����ָ��������") < 0.3 then
		return
	end

	--���ֶ���������¼Ŀ��
	if casting("����ع��") and castleft() < 0.13 then
		v["����Ŀ��"] = casttarget()
		settimer("���ֶ�������")
	end

	--���ݶ���������¼Ŀ��
	if casting("��������") and castleft() < 0.13 then
		v["����Ŀ��"] = casttarget()
		settimer("���ݶ�������")
	end

	--��ʼ������
	v["Ŀ������ʱ��"] = tbufftime("����ع��", id())
	v["Ŀ������ʱ��"] = tbufftime("����ָ", id())
	v["Ŀ������ʱ��"] = tbufftime("��������", id())
	v["Ŀ���ѩʱ��"] = tbufftime("��ѩʱ��", id())
	v["Ŀ��������"] = f["Ŀ��������"]()
	v["Ŀ��������"] = f["Ŀ��������"]()
	v["Ŀ��������"] = f["Ŀ��������"]()
	v["Ŀ���п�ѩ"] = f["Ŀ���п�ѩ"]()
	v["Ŀ��dot����"] = f["Ŀ��dot����"]()
	v["��ɢʱ��"] = bufftime("��ɢ")
	v["����ʱ��"] = bufftime("��ɢ����")

	v["�в�ɢ"] = buff("��ɢ")
	v["̤����"] = buff("26416")

	v["ܽ��CD"] = scdtime("ܽ�ز���")
	v["��ʯCD"] = scdtime("��ʯ���")
	v["ˮ��CD"] = scdtime("ˮ���޼�")
	v["����CD"] = scdtime("�������")
	v["GCD���"] = cdinterval(16)

	--����������
	if getopt("����������") and dungeon() and nofight() then return end

	--����, ���ִ�һ�κ��治��Ῠܽ��
	if rela("�ж�") and dis() < 20 and face() < 80 and v["��ʯCD"] > 11 and cdleft(16) >= 0.5 and cdleft(16) <= 1 and not v["̤����"] then
		CastX("�������")
	end

	--ˮ��
	if rela("�ж�") and dis() < 20 and face() < 80 and gettimer("�̺�") < 0.5 then	--�̺���
		cast("ˮ���޼�")
	end

	--ܽ��
	if v["Ŀ��dot����"] >= 4 and v["��ʯCD"] <= v["GCD���"] and v["̤����"] then
		CastX("ܽ�ز���")
	end

	--��ʯ
	if v["��ɢʱ��"] < 0 and v["����ʱ��"] < 0 and v["Ŀ��dot����"] >= 3 and v["����CD"] < 0.1 and v["ܽ��CD"] < 5.5 and not v["̤����"] then	--���ִ�ɢ
		CastX("��ʯ���")
	end
	if v["Ŀ��dot����"] >= 4 then	--��4dot
		CastX("��ʯ���")
	end

	--��ˮ
	if fight() and mana() < 0.5 then
		CastX("��ˮ����", true)
	end
	
	--����
	if buff("�������") and not v["������Ź�����ָ"] then

	else
		if not v["Ŀ��������"] then
			CastX("��������")
		end
	end
	
	--��ѩ
	if not v["Ŀ���п�ѩ"] or buffsn("����") < 3 then
		CastX("��ѩʱ��")
	end

	--����ָ
	if buff("�������") and not v["������Ź�����ָ"] then	--����������ָ����������
		CastX("����ָ")
	end

	if not v["��ʯ��Ź�����ָ"] and v["��ʯCD"] > v["GCD���"] * 2 then	--ÿС�ڴ�1��
		CastX("����ָ")
	end

	--����
	if not v["Ŀ��������"] then
		CastX("����ع��")
	end

	--����
	if not v["Ŀ��������"] then
		CastX("����ָ")
	end

	--�Զ�
	if getopt("�Զ��Զ�") and nobuff("��ʱ") and cdleft(16) > 0.5 then
		if life() < 0.7 or mana() < 0.8 then
			interact("�����ƶ�")
		end
	end

	--[[����
	if casting("��ѩʱ��") and castleft() < 0.13 then
		settimer("��ѩ��������")
	end
	if rela("�ж�") and dis() < 20 and cdleft(16) <= 0 and castleft() <= 0 and gettimer("��ѩʱ��") > 0.3 and gettimer("����ع��") > 0.3 and gettimer("��������") > 0.3 and gettimer("��ѩ��������") > 0.3 then
		PrintInfo("---------- û����")
	end
	--]]
end

-------------------------------------------------------------------------------

f["Ŀ��������"] = function()
	if v["�̺�Ŀ��"] ~= 0 and v["�̺�Ŀ��"] == tid() and gettimer("�̺�1") < 0.5 then return false end		--������û��
	if v["����Ŀ��"] ~= 0 and v["����Ŀ��"] == tid() then
		if gettimer("�ͷ�����ع��") < 0.5 or gettimer("���ֶ�������") < 0.5 then return true end	--�շŹ���
	end
	return v["Ŀ������ʱ��"] > 0
end

f["Ŀ��������"] = function()
	if v["�̺�Ŀ��"] ~= 0 and v["�̺�Ŀ��"] == tid() and gettimer("�̺�2") < 0.5 then return false end
	if v["����Ŀ��"] ~= 0 and v["����Ŀ��"] == tid() and gettimer("�ͷ�����ָ") < 0.5 then return true end
	return v["Ŀ������ʱ��"] > 0
end

f["Ŀ��������"] = function()
	if v["�̺�Ŀ��"] ~= 0 and v["�̺�Ŀ��"] == tid() and gettimer("�̺�3") < 0.5 then return false end
	if v["����Ŀ��"] ~= 0 and v["����Ŀ��"] == tid() then
		if gettimer("�ͷ���������") < 0.5 or gettimer("���ݶ�������") < 0.5 then return true end
	end
	return v["Ŀ������ʱ��"] > 0
end

f["Ŀ���п�ѩ"] = function()
	if v["�̺�Ŀ��"] ~= 0 and v["�̺�Ŀ��"] == tid() and gettimer("�̺�0") < 0.5 then return false end
	return v["Ŀ���ѩʱ��"] > 0
end

f["Ŀ��dot����"] = function()
	local nDot = 0
	if v["Ŀ��������"] then nDot = nDot + 1 end
	if v["Ŀ��������"] then nDot = nDot + 1 end
	if v["Ŀ��������"] then nDot = nDot + 1 end
	if v["Ŀ���п�ѩ"] then nDot = nDot + 1 end
	return nDot
end

-------------------------------------------------------------------------------

--��¼��Ϣ����־����
function PrintInfo(s)
	local t = {}
	if s then t[#t+1] = s end
	t[#t+1] = "����:"..v["Ŀ������ʱ��"]
	t[#t+1] = "��ѩ:"..v["Ŀ���ѩʱ��"]
	t[#t+1] = "����:"..v["Ŀ������ʱ��"]
	t[#t+1] = "����:"..v["Ŀ������ʱ��"]
	t[#t+1] = "��ɢ:"..v["��ɢʱ��"]
	t[#t+1] = "����:"..v["����ʱ��"]
	t[#t+1] = "��ʯCD:"..v["��ʯCD"]
	t[#t+1] = "ܽ��CD:"..v["ܽ��CD"]
	t[#t+1] = "ˮ��CD:"..v["ˮ��CD"]
	t[#t+1] = "����CD:"..v["����CD"]

	print(table.concat(t, ", "))
end

--ʹ�ü��ܲ���¼��Ϣ
function CastX(szSkill, bSelf)
	if cast(szSkill, bSelf) then
		settimer(szSkill)
		if v["��¼��Ϣ"] then PrintInfo() end
		return true
	end
	return false
end

-------------------------------------------------------------------------------

--�ͷż���
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then	--����ͷż��ܵ����Լ�

		if SkillID == 179 then		--����ָ
			deltimer("����ָ��������")
			v["������Ź�����ָ"] = true
			v["��ʯ��Ź�����ָ"] = true
			return
		end

		if SkillID == 180 then		--����ָ
			v["����Ŀ��"] = TargetID
			settimer("�ͷ�����ָ")
			return
		end

		if SkillID == 189 then		--����ع��
			v["����Ŀ��"] = TargetID
			settimer("�ͷ�����ع��")
			return
		end
		
		if SkillID == 190 then		--��������
			v["����Ŀ��"] = TargetID
			settimer("�ͷ���������")
			return
		end

		if SkillID == 601 then		--�̺�, ����ָ ���� ̤�� ����dot, ȡ��� �ȼ� 1 ����, 2 ����, 3 ����, 0 ��ѩ
			local level = SkillLevel % 4
			settimer("�̺�"..level)		--���ö�Ӧ���ܼ�ʱ��
			settimer("�̺�")
			v["�̺�Ŀ��"] = TargetID

			print("----------", SkillName, SkillID, SkillLevel)

		end

		if SkillID == 2645 then		--����
			v["������Ź�����ָ"] = false
			return
		end

		if SkillID == 13847 then	--���� ����ָ ��������
			v["����Ŀ��"] = TargetID
			settimer("�ͷ�����ع��")
			return
		end

		if SkillID == 13848 then	--���� ����ָ ��������
			v["����Ŀ��"] = TargetID
			settimer("�ͷ���������")
			return
		end

		if SkillID == 182 then		--��ʯ���
			v["��ʯ��Ź�����ָ"] = false
			print("------------------------------ �ָ���")
		end
	end
end
