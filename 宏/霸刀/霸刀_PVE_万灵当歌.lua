--[[ ��Ѩ:[��Ϣ][�麨][����][˪��][����][����][�ֽ�][�ǻ�][����][����][����][����ʽ]
�ؼ�:
����  1���� 2�˺� 1�ؿ���
�Ƹ�  1���� 3�˺�
�Ͻ�  2���� 2�˺�
����  2�˺� 2Ч��
��Х  2���� 2�˺�
--]]

--�ر��Զ�����
setglobal("�Զ�����", false)
addopt("����������", false)

--������
local v = {}
v["��¼��Ϣ"] = true

--������
local f = {}

--��ѭ��
function Main(g_player)
	
	-- �����Զ����ݼ�1����ҡ
	if keydown(1) then
		cast("��ҡֱ��")
	end

	if casting("��Х����") and castleft() < 0.13 then
		settimer("��Х��������")
	end

	if gettimer("��Х��������") <= 0.25 then
		return
	end

	--��ʼ������
	v["����"] = energy()
	v["����"] = rage()
	v["����"] = qijin()
	v["�Ƹ�CD"] = odtime("�Ƹ�����")
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
	v["����ʱ��"] = bufftime("����", id())
	v["�������"] = buffsn("����", id())
	v["�������"] = buffsn("15253")
	local tSpeedXY, tSpeedZ = speed(tid())
	v["Ŀ�꾲ֹ"] = rela("�ж�") and tSpeedXY <= 0 and tSpeedZ <= 0
	
	if nofight() then v["��������"] = 0 v["˫�ܱ�־"] = false end
	
	if not rela("�ж�") then return end
	if gettimer("��̬�л�") < 0.3 then return end
	
	if getopt("����������") and dungeon() and nofight() then 
		return
	end
	
	if v["����"] >= 5 and v["����ʱ��"] <= 2 and cdleft(16) < 0.25 and nobuff("ѩ������") then
		f["�л���̬"]("ѩ������")
		return
	end
	
	--������
	if v["����"] >= 10 and v["������CD"] <= 0 and tnobuff("������", id()) and v["����ʱ��"] > 2 and nobuff("��������") then
		f["�л���̬"]("��������")
		return
	end
	
	if (tbuff("������", id()) or v["������CD"] > 1) and v["����ʱ��"] > 5 and v["����"] >= 10 and v["���CD"] <= v["GCD"] and cdleft(16) < 0.25 and v["�������"] < 2 then
		f["�л���̬"]("ѩ������")
	end
	
	if buff("15098") and bufftime("15098") < 1.5 and nobuff("ѩ������") then
		f["�л���̬"]("��������")
		return
	end
	
	if dis() > 10 and fight() and (tbuff("������", id()) or v["������CD"] > 1) then
		f["�л���̬"]("ѩ������")
	end
	
	--------------------------------------------- ��
	if buff("��������") then
		--[[if v["����"] < 25 and v["�Ͻ�CD"] > v["GCD"] + 0.25 then
			f["�л���̬"]("��������")
		end--]]
		
		if v["�Ͻ�CD"] > v["GCD"] + 0.25 and od("�Ƹ�����") < 1 and v["���CD"] <= v["GCD"] + 0.25 and cdleft(16) < 0.24 and (od("������ն") > 4 or v["����CD"] < v["GCD"] + 0.25) then
			f["�л���̬"]("��������")
			return
		end
		
		if v["�������"] < 2 and v["�Ͻ�CD"] > v["GCD"] and od("�Ƹ�����") < 1 and cdleft(16) < 0.25 then
			f["�л���̬"]("ѩ������")
		end
		
		if v["�Ͻ�CD"] > v["GCD"] + 0.25 and od("�Ƹ�����") < 2 and v["����ʱ��"] > 3.5 and cdleft(16) < 0.24 and (od("������ն") > 5 or v["����CD"] < v["GCD"]) then
			f["�л���̬"]("��������")
		end
		
		if v["�Ͻ�CD"] > v["GCD"] + 0.25 and od("�Ƹ�����") < 1 and v["����ʱ��"] > 3.5 and v["����ʱ��"] < 9 and cdleft(16) < 0.24 and (od("������ն") > 5 or v["����CD"] < v["GCD"] + 0.25) then
			f["�л���̬"]("��������")
		end
		
		if v["�Ͻ�CD"] > v["GCD"] + 0.25 and od("�Ƹ�����") < 1 and v["����ʱ��"] > 0 and v["����ʱ��"] < 3.5 and cdleft(16) < 0.24 then
			f["�л���̬"]("ѩ������")
		end
		
		if v["�Ͻ�CD"] > v["GCD"] + 0.25 and od("�Ƹ�����") < 1 and v["���CD"] <= v["GCD"] and cdleft(16) < 0.24 and od("������ն") < 6 and v["����CD"] > v["GCD"] then
			f["�л���̬"]("ѩ������")
		end
		
		if v["�Ͻ�CD"] > v["GCD"] + 0.25 and od("�Ƹ�����") < 1 and v["����ʱ��"] <= 15.5 and cdleft(16) < 0.24 and od("������ն") < 6 and v["����CD"] > v["GCD"] then
			f["�л���̬"]("ѩ������")
		end
		
		if v["�Ͻ�CD"] > v["GCD"] + 0.25 and od("�Ƹ�����") < 1 and v["����ʱ��"] <= 15.5 and cdleft(16) < 0.24 and od("������ն") > 5 then
			if v["����ʱ��"] > 3.5 then
				f["�л���̬"]("��������")
			elseif v["����ʱ��"] < 3.5 then
				f["�л���̬"]("ѩ������")
			end
		end
		
		if v["�Ͻ�CD"] > v["GCD"] + 0.25 and od("�Ƹ�����") < 1 and v["����ʱ��"] > 15.5 and cdleft(16) < 0.24 and od("������ն") > 5 then
			f["�л���̬"]("��������")
		end
		
		if v["�Ͻ�CD"] > v["GCD"] + 0.25 and od("�Ƹ�����") < 2 and gettimer("�Ƹ�����") < 2 and v["����ʱ��"] > 15.5 and cdleft(16) < 0.24 and od("������ն") > 5 then
			f["�л���̬"]("��������")
		end
		
		if v["�Ͻ�CD"] > v["GCD"] + 0.25 and od("�Ƹ�����") < 1 and v["����ʱ��"] > 15.5 and cdleft(16) < 0.24 and od("������ն") < 6 and v["����CD"] > v["GCD"] then
			f["�л���̬"]("ѩ������")
		end
		
		--[[if v["�Ͻ�CD"] > v["GCD"] + 0.25 and od("�Ƹ�����") < 2 and v["�Ƹ�CD"] > v["GCD"] + 0.25 and v["���CD"] <= v["GCD"] and cdleft(16) < 0.24 and v["�Ͻ�CD"] > 2 then
			f["�л���̬"]("ѩ������")
		end--]]
		
		if od("�Ƹ�����") > 1 and dis() < 6 and face() < 90 then
			if CastX("�Ƹ�����") then
				settimer("�Ƹ�����")
			end
		end
		
		if dis() < 5 then
			if aCastX("�Ͻ���ӡ") then
				settimer("�Ͻ���ӡ")
			end
		end
		
		if dis() < 6 and face() < 90 then
			if CastX("�Ƹ�����") then
				settimer("�Ƹ�����")
			end
		end
		
		CastX("���߷���")
		
	end
	
	--------------------------------------------- �ʵ�
	
	if buff("ѩ������") then
	
		if gettimer("�����Ұ") < 3 and dis() < 6 then
			if v["�Ͻ�CD"] <= v["GCD"] + 0.25 and v["����"] >= 25 then
				f["�л���̬"]("��������")
			end
			
			if (od("�Ƹ�����") > 0 or v["�Ƹ�CD"] <= v["GCD"] + 0.25) and v["����"] >= 25 then
				f["�л���̬"]("��������")
			end
			
			if ((v["�Ͻ�CD"] > v["GCD"] + 0.25 and od("�Ƹ�����") < 1 and v["�Ƹ�CD"] > v["GCD"] + 0.25) or (v["����"] < 25)) and (od("������ն") > 5 or v["����CD"] < v["GCD"] + 0.25) then
				f["�л���̬"]("��������")
			end
		end
		
		if v["����ʱ��"] > 15 and (v["�������"] > 1 or gettimer("�����Ұ") < 3) and v["���CD"] > v["GCD"] + 0.25 and dis() < 6 then
			if v["�Ͻ�CD"] <= v["GCD"]+ 0.25 and v["����"] >= 25 then
				f["�л���̬"]("��������")
			end
			
			if (od("�Ƹ�����") > 0 or v["�Ƹ�CD"] <= v["GCD"] + 0.25) and v["����"] >= 25 then
				f["�л���̬"]("��������")
			end
			
			if ((v["�Ͻ�CD"] > v["GCD"] + 0.25 and od("�Ƹ�����") < 1 and v["�Ƹ�CD"] > v["GCD"] + 0.25) or (v["����"] < 25)) and (od("������ն") > 5 or v["����CD"] < v["GCD"] + 0.25) then
				f["�л���̬"]("��������")
			end
		end
		
		if dis() < 6 and fight() and v["����ʱ��"] > 2 then
			if aCastX("�����Ұ") then
				settimer("�����Ұ")
				return
			end
				
		end
		
		if (v["����ʱ��"] < 15 or v["����"] < 25 or gettimer("��Х����") > 3 or dis() > 10 or (v["���CD"] > v["GCD"] + 0.25 and (v["�Ͻ�CD"] > v["GCD"] + 0.25 and od("�Ƹ�����") < 1 and v["�Ƹ�CD"] > v["GCD"] + 0.25))) and gettimer("��Х����") > 0.5 then
			CastX("��Х����")
		end
		
	end
	
	--------------------------------------------- ˫��
	
	if buff("��������") then
		
		if gettimer("����ʽ") > 0.3 and (dis() < 6 or (buff("15098") and bufftime("15098") < 3)) then
			if CastX("����ʽ") then
				settimer("����ʽ")
			end
		end
		
		if gettimer("������ն") < 3 and v["����ʱ��"] < 6 and gettimer("������ն") > 0.3 then
			f["�л���̬"]("ѩ������")
		end
		
		if gettimer("������ն") < 3 and v["�Ͻ�CD"] <= v["GCD"] + 0.25 and nobuff("15098") and v["����"] >= 25 and gettimer("������ն") > 0.3 and dis() < 6 then
			f["�л���̬"]("��������")
		end
		
		if gettimer("������ն") < 3 and (od("�Ƹ�����") > 0 or v["�Ƹ�CD"] <= v["GCD"] + 0.25) and nobuff("15098") and v["����"] >= 25 and gettimer("������ն") > 0.3 and dis() < 6 then
			f["�л���̬"]("��������")
		end
		
		if gettimer("������ն") < 3 and v["�Ͻ�CD"] > v["GCD"] + 0.25 and od("�Ƹ�����") < 1 and v["���CD"] <= v["GCD"] and nobuff("15098") and gettimer("������ն") > 0.3 and cdleft(16) < 0.8 then
			f["�л���̬"]("ѩ������")
		end
		
		if gettimer("������ն") < 3 and v["�Ͻ�CD"] > v["GCD"] + 0.25 and od("�Ƹ�����") < 1 and v["˫�ܱ�־"] and nobuff("15098") and gettimer("������ն") > 0.3 and cdleft(16) < 0.8 then
			f["�л���̬"]("ѩ������")
		end
		
		if od("������ն") <= 4 and v["�Ͻ�CD"] > v["GCD"] + 0.25 and od("�Ƹ�����") < 1 then
			f["�л���̬"]("ѩ������")
		end
		
		--[[if gettimer("������ն") < 3 and v["�Ͻ�CD"] > v["GCD"] + 0.25 and od("�Ƹ�����") < 1 and v["���CD"] > 9 then
			f["�л���̬"]("ѩ������")
		end--]]
			
		if tnobuff("������", id()) then
			if CastX("������") then
				settimer("������")
			end
		end
		
		if od("������ն") > 4 then
			if CastX("������ն") then
				settimer("������ն")
			end
		end
		
		if od("������ն") > 4 then
			if CastX("��ӥʽ") then
				settimer("������ն")
			end
		end
		
		if od("������ն") < 5 and v["����"] < 25 then
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

--��¼��Ϣ
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
		if v["��¼��Ϣ"] then
			PrintInfo()
		end
		return true
	end
	return false
end

--����Ŀ���ʹ�ü���
function aCastX(szSkill)
	if acast(szSkill) then
		if v["��¼��Ϣ"] then
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

v["��������"] = 0
v["˫�ܱ�־"] = false

function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		if SkillID == 16027 then
			settimer("��Х����")
			return
		end
		
		if SkillID == 16166 then
			settimer("���̼�ʱ")
			return
		end
		
		if SkillID == 16871 then
			v["��������"] = 1
		end
		
		if SkillID == 16621 and v["˫�ܱ�־"] then
			v["˫�ܱ�־"] = false
			v["��������"] = 0
		end
		
		if SkillID == 16621 and v["��������"] == 1 then
			v["˫�ܱ�־"] = true
		end
		
	end
end
