--[[ ��Ѩ:[��Ϣ][�麨][ڤ��][˪��][����][����][�ֽ�][�ǻ�][����][����][����][����ʽ]
�ؼ�:
�Ƹ� 1���� 3�˺�
�Ͻ� 2���� 2�˺�
���� 2�˺� 2����
��Х 2���� 2�˺�
--]]

--�ر��Զ�����
setglobal("�Զ�����", false)

--������
local v = {}
v["�����Ϣ"] = true

--������
local f = {}

--��ѭ��
function Main(g_player)
	if casting("��Х����") and castleft() < 0.13 then
		settimer("��Х��������")
	end

	--��ʼ������
	v["����"] = energy()
	v["����"] = rage()
	v["����"] = qijin()
	v["�Ƹ�CD"] = scdtime("�Ƹ�����")
	v["�Ͻ�CD"] = scdtime("�Ͻ���ӡ")
	if qixue("��Ϣ") then
		v["����CD"] = odtime("������ն")
	else
		v["����CD"] = scdtime("������ն")
	end
	v["���CD"] = scdtime("�����Ұ")
	v["������CD"] = scdtime("������")
	v["GCD"] = cdleft(16)
	v["GCD���"] = cdinterval(16)
	v["����ʱ��"] = bufftime("����")
	v["�������"] = buffsn("����")
	v["�������"] = buffsn("15253")
	local tSpeedXY, tSpeedZ = speed(tid())
	v["Ŀ�꾲ֹ"] = rela("�ж�") and tSpeedXY <= 0 and tSpeedZ <= 0

	if not rela("�ж�") then return end
	if gettimer("��̬�л�") < 0.3 then return end

	--������
	if v["����"] >= 10 and v["������CD"] <= 0 and tnobuff("������", id()) then
		f["�л���̬"]("��������")
	end

	--------------------------------------------- ��
	if buff("��������") then
		if v["�Ƹ�CD"] > v["GCD���"] and v["�Ͻ�CD"] > v["GCD���"] then
			f["�л���̬"]("ѩ������")
		end

		if dis() > 10 then
			f["�л���̬"]("ѩ������")
		end
		
		if od("�Ƹ�����") < 2 then
			if v["Ŀ�꾲ֹ"] and dis() < 5 then
				if aCastX("�Ͻ���ӡ") then
					settimer("�Ͻ���ӡ")
				end
			end
		end

		if dis() < 6 and face() < 90 then
			CastX("�Ƹ�����")
		end
	end

	--------------------------------------------- �ʵ�
	if buff("ѩ������") then
		if v["���CD"] > 1 and dis() < 10 then
			if v["�Ƹ�CD"] < v["GCD"] + 0.1 then
				f["�л���̬"]("��������")
			end
			if v["����CD"] < 0.1 and v["�Ƹ�CD"] < v["GCD"] + v["GCD���"] + 0.125 then
				f["�л���̬"]("��������")
			end
		end

		if v["Ŀ�꾲ֹ"] and dis() < 16 then
			aCastX("�����Ұ")
		end

		if CastX("��Х����") then
			settimer("��Х����")
		end
	end

	--------------------------------------------- ˫��
	if buff("��������") then
		if tbuff("������", id()) or v["������CD"] > 1 then
			if v["GCD"] < 0.5 and nobuff("15098") then
				if v["�Ƹ�CD"] < 0.1 and v["����"] >= 25 then
					f["�л���̬"]("��������")
				end
			end
		end

		if tnobuff("������", id()) then
			if CastX("������") then
				settimer("������")
			end
		end

		if gettimer("����ʽ") > 0.3 and dis() < 6 then
			if CastX("����ʽ") then
				settimer("����ʽ")
			end
		end

		CastX("������ն")
		
		if v["����CD"] > 1 and (gettimer("����ʽ") > 0.3 or v["����"] < 25) then
			CastX("��������")
		end
	end

	if fight() and rela("�ж�") and dis() < 4 and face() < 90 and cdleft(16) <= 0 and castleft() <= 0 and state("վ��") and gettimer("��Х����") > 0.5 then
		PrintInfo("----------û����, ")
	end
end

f["�л���̬"] = function(SkillName)
	if gettimer("�Ͻ���ӡ") < 0.3 or gettimer("������") < 0.3 then return end
	if nobuff(SkillName) then
		if CastX(SkillName) then
			settimer("��̬�л�")
			exit()
		end
	end
end

--�����Ϣ
function PrintInfo(s)
	local szinfo = "����:"..v["����"]..", ����:"..v["����"]..", ����"..v["����"]..", GCD:"..v["GCD"]..", �Ƹ�CD:"..v["�Ƹ�CD"]..", �Ͻ�CD:"..v["�Ͻ�CD"]..", ���CD:"..v["���CD"]..", ����CD:"..v["����CD"]..", ����:"..v["�������"]..", "..v["����ʱ��"]
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
--����Ŀ���ʹ�ü���
function aCastX(szSkill)
	if acast(szSkill) then
		if v["�����Ϣ"] then
			PrintInfo()
		end
		return true
	end
	return false
end

--buff���»ص�
function OnBuff(CharacterID, BuffName, BuffID, BuffLevel, StackNum, SkillSrcID, StartFrame, EndFrame, FrameCount)
	if CharacterID == id() then
		if StackNum  > 0 then
			if BuffID == 10814 or BuffID == 10815 or BuffID == 10816 then	--3��̬buff
				deltimer("��̬�л�")
			end
		end
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
