--[[ ��Ѩ: [��ָ][���][����][̤��][���][ѩ����][����][����][����][ѩ��][����][���]
�ؼ�:
����  3��Ϣ 1����
��¥  2��Ϣ 1����
����  2���� 2�˺�
����  1���� 1���� 2������
����  3���� 1����
ܽ��  1���� 2�˺� 1Ч��
��ѩ  3�˺� 1����
����  2��Ϣ 1���� 1����
--]]

--�ر��Զ�����
setglobal("�Զ�����", false)

--������
local v = {}
v["����Ŀ��"] = 0
v["����Ŀ��"] = 0
v["����Ŀ��"] = 0
v["�̺�Ŀ��"] = 0

--������
local f = {}

--��ѭ��
function Main()
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
	v["ܽ��CD"] = scdtime("ܽ�ز���")
	v["��ʯCD"] = scdtime("��ʯ���")
	v["������"] = buff("�������")
	v["�в�ɢ"] = buff("��ɢ")
	v["̤����"] = buff("26416")
	v["��ȫbuff��Ҫʱ��"] = f["��ȫbuff��Ҫʱ��"]()


	--����
	if rela("�ж�") and dis() < 20 and face() < 60 and v["��ʯCD"] > 10 and cdleft(16) >= 0.5 and cdleft(16) <= 1 and not v["̤����"] then
		cast("�������")
	end

	--ܽ��
	--if v["Ŀ��dot����"] >= 4 and v["��ʯCD"] < cdinterval(16) and v["��ʯCD"] > 0 then
	if v["Ŀ��dot����"] >= 4 and v["��ʯCD"] < cdinterval(16) then
		cast("ܽ�ز���")
	end

	--��ʯ
	if not v["�в�ɢ"] and v["Ŀ��dot����"] >= 3 and scdtime("�������") < 0.1 and not v["̤����"] then
		cast("��ʯ���")
	end
	if v["Ŀ��dot����"] >= 4 then	
		cast("��ʯ���")
	end
	
	--����
	if v["������"] and not v["������Ź�����ָ"] then

	else
		if not v["Ŀ��������"] then
			cast("��������")
		end
	end
	
	--��ѩ
	if not v["Ŀ���п�ѩ"] or buffsn("����") < 3 then
		cast("��ѩʱ��")
	end

	--����ָ
	if v["������"] and not v["������Ź�����ָ"] then
		cast("����ָ")
	end
	if v["��ʯCD"] - v["��ȫbuff��Ҫʱ��"] > 1 then
		cast("����ָ")
	end

	--����
	if not v["Ŀ��������"] then
		cast("����ع��")
	end

	--����
	if not v["Ŀ��������"] then
		cast("����ָ")
	end

	--��ˮ
	if fight() and mana() < 0.5 then
		cast("��ˮ����", true)
	end
end


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

f["��ȫbuff��Ҫʱ��"] = function()
	local nTime = 0
	if not v["Ŀ��������"] then
		nTime = nTime + cdinterval(16)
	end
	if not v["Ŀ��������"] then
		nTime = nTime + cdinterval(16)
	end
	if v["ܽ��CD"] < v["��ʯCD"] then
		nTime = nTime + cdinterval(16)
	end
	return nTime
end

--�ͷż���
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	--����ͷż��ܵ����Լ�
	if CasterID == id() then
		--����ָ
		if SkillID == 179 then
			deltimer("����ָ��������")
			v["������Ź�����ָ"] = true
			return
		end

		--����ָ
		if SkillID == 180 then
			v["����Ŀ��"] = TargetID
			settimer("�ͷ�����ָ")
			return
		end

		--����ع��
		if SkillID == 189 then
			v["����Ŀ��"] = TargetID
			settimer("�ͷ�����ع��")
			return
		end

		--��������
		if SkillID == 190 then
			v["����Ŀ��"] = TargetID
			settimer("�ͷ���������")
			return
		end

		--�̺�, ����ָ ���� ̤�� ����dot, ȡ��� �ȼ� 1 ����, 2 ����, 3 ����, 0 ��ѩ
		if SkillID == 601 then
			local level = SkillLevel % 4
			settimer("�̺�"..level)		--���ö�Ӧ���ܼ�ʱ��
			v["�̺�Ŀ��"] = TargetID

			--ˮ��
			if rela("�ж�") and dis() < 20 and face() < 60 then
				cast("ˮ���޼�")
			end
		end

		--����
		if SkillID == 2645 then
			v["������Ź�����ָ"] = false
		end

		--���� ����ָ ��������
		if SkillID == 13847 then
			v["����Ŀ��"] = TargetID
			settimer("�ͷ�����ع��")
			return
		end

		--���� ����ָ ��������
		if SkillID == 13848 then
			v["����Ŀ��"] = TargetID
			settimer("�ͷ���������")
			return
		end
	end
end
