--[[ ��Ѩ: [ѪӰ����][��缳��][�������][�������][���Ǹ���][�۾�����][��Ѫ����][ɱ���ϻ�][���ɢӰ][ȸ�����][��ɫ�ߺ�][���ڤ΢]
�ؼ�:
��ȸ��  3��Ϣ
����    1���� 2�˺� 1Ч��
ʴ����  2���� 2�˺�
���    3�˺� 1��Χ
����ɱ��  1���� 3�˺�

--]]

--������
local v = {}
v["�����Ϣ"] = true

--��ѡ��
addopt("����������", false)

function Main(g_player)
	-- �����Զ����ݼ�1����ҡ
	if keydown(1) then
		cast("��ҡֱ��")
	end
	
	--��ֹ��Ϲ�
	if gettimer("����") < 0.5 or lasttime("����") < 2 or casting("����") then
		if castprog() > 0.1 and puppet("����ǧ��������") and gettimer("�ͷ�����") > 5 then --���������������ʱ��
			fcast("������̬")
		end
		return
	else
		nomove(false)		--�����ƶ�
	end
	
	--����
	if fight() and life() < 0.5 then
		cast("��������")
	end

	if not rela("�ж�") then return end
	
	--��ʼ������
	local speedXY, speedZ = speed(tid())
	v["Ŀ�꾲ֹ"] = rela("�ж�") and speedXY <= 0 and speedZ <= 0
	
	v["GCD"] = cdleft(16)
	
	v["���ֵ"] = energy()
	
	
	v["��CD"] = scdtime("����")
	v["���CD"] = scdtime("�������")
	v["���ǳ��ܴ���"] = cn("���Ƕ�Ӱ")
	v["������ܴ���"] = cn("�����滨��")
	v["������ܴ���"] = cn("���ڤ΢")
	v["�����ǰ����ʱ��"] = cntime("���ڤ΢")
	v["���������ʱ��"] = cntime("���ڤ΢", true)
	
	v["����ʱ��"] = bufftime("��������")
	v["����˺�����buff"] = bufftime("27578")
	v["��Ѫ����ʱ��"] = tbufftime("��Ѫ", id())
	
	_, v["����ɱ������"] = tnpc("��ϵ:�Լ�", "����:���ذ���ɱ��", "����<6")
	_, v["�������"] = npc("��ϵ:�Լ�", "ģ��ID:15994")
	
	_, v["�������й������"] = npc("����:���ڤ΢")   -- �����κ���̬�Ĺ������
	_, v["ûCD�������"] = npc("����:���ڤ΢", "buffʱ��:24389 < -1") -- û������̬CD�Ĺ������
	_, v["����̬�������"] = npc("����:���ڤ΢", "buffʱ��:24389|24391 < -1") --û������̬CD��û����̬����Ĺ������
	
	v["Ŀ��Ѫ���϶�"] = rela("�ж�") and tlifevalue() > lifemax() * 10	--Ŀ�굱ǰѪ�������Լ����Ѫ��10��
	
	--����������
	if getopt("����������") and dungeon() and nofight() then
		return
	end
	
	--��
	if dis() < 20 and puppet("����ǧ��������") and gettimer("�ͷ�����") < 115 then   --����С��20��,������������ʣ��ʱ�����5��
		if xdis(pupid()) < 4 and v["Ŀ��Ѫ���϶�"] and v["���������ʱ��"] < 8 and v["����ɱ������"] >= 1 then --������ľ���С��4��,Ŀ��Ѫ���϶�(���Լ�����),���������ʱ��С��8��,������һ����
			if cast("����", true) then
				stopmove()			--ֹͣ�����ƶ�
				nomove(true)		--��ֹ�ƶ�
				settimer("����")
				exit()				--�жϽű�ִ��
			end
		end
	end
	
	--û�п���̬����ŵ�
	if gettimer("���ڤ΢") > 0.5 and gettimer("�ͷŹ��ڤ΢") > 2 and v["����̬�������"] <= 0 then
		if cast("����ɱ��") then
			settimer("����ɱ��")
		end
	end
	
	--����
	if dis() < 20 then
		if nopuppet() or xxdis(pupid(), tid()) > 25 or (xdis(pupid()) > 4 and v["��CD"] <= 2) then
			cast("ǧ����", true)
		end

		if puppet("����ǧ�������|����ǧ��������") then
			fcast("������̬")
		end

		if puppet("����ǧ��������") and gettimer("�ͷ�����") > 115 then
			fcast("������̬")
		end
	end
	
	-- ���ް󶨹�
	if gettimer("�ͷŹ�") < 5 then
		cast("��������")
	end
	
	-- ���ֿ��� �����
	if puppet("����ǧ��������|����ǧ��������") and v["��CD"] > 0 and scdtime("��������") > 0 and puptid() ~= tid() and xxdis(pupid(), tid()) < 25 and xxvisible(pupid(), tid()) then
		cast("����")
		cast("��ڷ�")
	end
	
	--��ȸ�󶨱���
	if v["����ɱ������"] <= 1 and gettimer("ͼ��ذ��") < 2 then
		if CastX("��ȸ��") then
			settimer("��ȸ��")
		end
	end
	
	
	--����ѭ��
	if (buff("����") and buff("��������")) or gettimer("�ͷŹ�") < 5 then
		-- ���
		if v["���CD"] <= 0 then
			if CastX("�������") then
				settimer("�������")
			end
		end
		
		--���
		if v["���CD"] > 0 and gettimer("���ڤ΢") > 2.5 and v["GCD"] <= 0 then --�������CD,GCDΪ��,2.5��û�������(��ֹ�������)
			if v["������ܴ���"] > 1 then
				if CastX("���ڤ΢") then
					settimer("���ڤ΢")
					return
				end
			end
			if v["������ܴ���"] > 0 and gettimer("�ͷ��������Ч��") > 0.5 and v["����˺�����buff"] <= 0.4 then --�����ж���Ϊ�˿�47��,�ɸ����Լ����ӳ����µ���
				if CastX("���ڤ΢") then
					settimer("���ڤ΢")
					return
				end
			end
		end
		
		--�����ޱ���
		if v["����ʱ��"] < 0.5 then 
			if CastX("ͼ��ذ��") then
				settimer("ͼ��ذ��")
			end
		end
		
		--����
		if v["���CD"] > 0 and v["������ܴ���"] <= 0 and v["�����ǰ����ʱ��"] > 5 and gettimer("�����滨��") > 3 and v["����ʱ��"] > 3 then --�����ڼ�����콻�������˺�,��ֹ�����Լ�����������ʱ��
			if CastX("�����滨��") then
				settimer("�����滨��")
			end
		end
		
		--���ǿ����
		if v["���ǳ��ܴ���"] > 0 and v["���CD"] > 0 and v["������ܴ���"] <= 0 and v["����˺�����buff"] <= 1 and v["���ֵ"] > 75 and gettimer("���Ƕ�Ӱ") > 1.5 then
			if CastX("���Ƕ�Ӱ") then
				settimer("���Ƕ�Ӱ")
			end
		end
		
		--����˺�
		if v["���CD"] > 0 and v["������ܴ���"] <= 1 and v["�����ǰ����ʱ��"] > 5 then
			if gettimer("��Ůɢ��") > 3 then
				if CastX("��Ůɢ��") then
					settimer("��Ůɢ��")
				end
			end
			if v["����ʱ��"] < 4 and v["����ʱ��"] > 2 then
				if CastX("��Ůɢ��") then
					settimer("��Ůɢ��")
				end
			end
		end
		return
	end
	
	--�Ǳ���ѭ��
	
	--���
	v["�����"] = false
	
	if v["���CD"] <= 0 and v["Ŀ�꾲ֹ"] and (v["��CD"] > 7 or gettimer("���ڤ΢") < 2 or not v["Ŀ��Ѫ���϶�"]) then --�������Ϲ�CD,��������а�
		
		if v["����̬�������"] > 1 then 
			v["�����"] = true
		end
		
		if v["����̬�������"] == 1 and v["ûCD�������"] == 1 then
			v["�����"] = true
		end
		
		if v["�������й������"] <= 0 then
			v["�����"] = true
		end
		
		if v["�����"] then
			if casting("�����滨��|ʴ����") and v["GCD"] <= 0 then --�������������϶���
				stopcasting()
				return
			end
			if v["���ֵ"] <= 55 and gettimer("���ڤ΢") > 3 then --Ԥ����������ֵ����
				return
			end
			if CastX("�������") then
				settimer("�������")
			end
		end
	end
	
	--���
	if v["���CD"] > 0 and gettimer("���ڤ΢") > 8 and v["GCD"] <= 0 and v["��CD"] < 42 and (v["��CD"] > 7 or gettimer("�������") < 3) then
		if gettimer("�ͷ����") < 3.5 and gettimer("�ͷ����") > 2.3 then --�����ж���Ϊ�˿�21��,�ɸ����Լ����ӳ����µ���
			if CastX("���ڤ΢") then
				settimer("���ڤ΢")
			end
			return
		end
	end
	
	--����
	if v["����ɱ������"] >= 3 then
		if v["�������"] <= 0 and v["���������ʱ��"] > 8 then
			if v["���CD"] > 4 then
				if CastX("ͼ��ذ��") then
					settimer("ͼ��ذ��")
				end
			end
			if scdtime("��ȸ��") <= 1.5 then
				if CastX("ͼ��ذ��") then
					settimer("ͼ��ذ��")
				end
			end
		end
		
		if v["�������"] > 1 and scdtime("��ȸ��") <= 1.5 then
			if gettimer("�ͷ����") < 1.5 then
				if CastX("ͼ��ذ��") then
					settimer("ͼ��ذ��")
				end
			end
			if v["����˺�����buff"] > 2 then
				if CastX("ͼ��ذ��") then
					settimer("ͼ��ذ��")
				end
			end
		end
	end
	
	-- ����˺� �����
	
	if gettimer("�������") > 2 and v["�������"] <= 0 and v["������ܴ���"] > 0 and gettimer("�����滨��") > 3.5 and v["���CD"] > 0 then
		if CastX("�����滨��") then
			settimer("�����滨��")
		end
	end
	
	if v["���ֵ"] > 70 and v["���CD"] > 0 then
		if gettimer("���ڤ΢") < 3 and gettimer("�ͷ����") < 1 then
			deltimer("�ͷ����")
		end
		
		if v["������ܴ���"] > 0 and gettimer("�ͷ����") < 3.5 then
			return
		end
		
		if state("վ��") and v["��Ѫ����ʱ��"] > 9 then
			CastX("ʴ����")
		end
		
		CastX("��Ůɢ��")
	end
	
end

--ʹ�ü��ܲ������Ϣ
function CastX(szSkill)
	if cast(szSkill) then
		if v["�����Ϣ"] then 
			PrintInfo()
		end
		return true
	end
	return false
end

--�����Ϣ
function PrintInfo(s)
	local szinfo = "GCD:"..v["GCD"]..", ����˺�����buff:"..v["����˺�����buff"]..", ����ʱ��:"..v["����ʱ��"]..", ���ֵ:"..v["���ֵ"]..", ���CD:"..v["���CD"]..", ������ܴ���:"..v["������ܴ���"]..", ��CD:"..v["��CD"]..""
	if s then
		szinfo = s..szinfo
	end
	print(szinfo)
end


--�ͷż���
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		if SkillName == "���ڤ΢" then
			settimer("�ͷŹ��ڤ΢")
		end
		if SkillName == "������̬" then
			settimer("�ͷ�����")
		end
		
		if SkillName == "��������" then
			settimer("�ͷ���������")
			return
		end
		if SkillID == 3110 then
			settimer("�ͷŹ�")
			return
		end
		if SkillID == 3301 then
			settimer("�ͷ��������Ч��")
			return
		end
		if SkillID == 3108 then
			settimer("�ͷ����")
		end
		--print(xname(CasterID).. "�ͷż���:"..SkillName..", ����ID:"..SkillID..", ���ܵȼ�:"..SkillLevel..", Ŀ������"..TargetType..",Ŀ����˭"..TargetID..",����y"..PosY..",����z"..PosZ)
	end
end

--buff����
function OnBuff(CharacterID, BuffName, BuffID, BuffLevel, StackNum, SkillSrcID, StartFrame, EndFrame, FrameCount)
	if CharacterID == id() then
		if StackNum > 0 and BuffID == 25901 and bufflv("26055") == 6 then	--���buff ��������
			deltimer("�����������")
		end
		
		--print(xname(CharacterID).. "���buff:"..BuffName..", buffID:"..BuffID..", buff�ȼ�:"..BuffLevel..", Ŀ������"..StackNum)
	end
	
	
end
