--[[����
[��]2 [��ѩ]2 [����]3
[����]2 [����]2 [����]3
[���Ҽ���]1 [������]2 [���]2
[˪��]2 [����ҹ]1 [���]2
[����]1 [���]2
[�������]1 [����]1
[��¶]2 [����]3
[����]2
--]]

--�ر��Զ�����
setglobal("�Զ�����", false)

--��ѡ��
addopt("����������", false)

--������
local v = {}
v["����Ŀ��"] = 0
v["�»�ǰĿ��"] = 0

--��ѭ��
function Main(g_player)
	--�������ܴ���
	if map("�����ؾ�") then
		if tcasting("����") then
			stopcasting()
			if castleft() < 0.5 then
				cast("��������")
				cast("ӭ�����")
				cast("������ʤ")
				cast("��̨���")
			end
			return
		end
	end

	--�»�����
	if casting("�»���к") then return end

	--�ָ��»�ǰĿ��
	if v["�»�ǰĿ��"] ~= 0 then
		settar(v["�»�ǰĿ��"])
		v["�»�ǰĿ��"] = 0
	end

	if nobuff("����") then
		cast("�����ķ�")
	end

	if nofight() and nobuff("����") then
		cast("������", true)
	end

	--����
	if fight() and life() < 0.6 and buffstate("����Ч��") < 40 then
		cast("��صͰ�")
	end

	--����������
	if getopt("����������") and dungeon() and nofight() then return end

	if tbuff("����") then
		bigtext("Ŀ���޵�", 0.5)
		return
	end

	--��ʼ������
	v["Ŀ�꼱������"] = tbuffsn("����", id())
	if v["����Ŀ��"] ~= 0 and tid() == v["����Ŀ��"] then	--�ϼ�����Ŀ��buff��ûͬ�����ͼ�1��
		v["Ŀ�꼱������"] = v["Ŀ�꼱������"] + 1
	end
	local tSpeedXY, tSpeedZ = speed(tid())
	v["Ŀ�꾲ֹ"] = tSpeedXY == 0 and tSpeedZ == 0		--xy�ٶȺ�Z�ٶȶ�Ϊ0
	v["Ŀ��Ѫ���϶�"] = rela("�ж�") and tlifevalue() > lifemax() * 10		--Ŀ��Ѫ�������Լ����Ѫ��10��

	--�»���к, ��Ҫ�Ե�ǰĿ���ͷŲ���Ч��
	if v["Ŀ��Ѫ���϶�"] and dis() < 25 and cdtime("�»���к") <= 0 and v["Ŀ�꼱������"] < 3 then
		--��Ӧ��buff�ȼ�����Ҫ��Ŀ���ڹ�
		v["�»�buff�ȼ�"] = 1		--��й, ����50%, �⹦
		v["��Ҫ�ķ�"] = "�ڹ�:��Ѫս��|������|̫�齣��|�����|��ˮ��|ɽ�ӽ���|Ц����"
		if tlife() > 0.5 then
			v["�»�buff�ȼ�"] = 2	--�»�, ����50%, �ڹ�
			v["��Ҫ�ķ�"] = "�����ڹ�:��Ѫս��|������|̫�齣��|�����|��ˮ��|ɽ�ӽ���|Ц����"
		end

		if not g_player.IsHaveBuff(50372, v["�»�buff�ȼ�"]) then		--�»�����йʱ�䵽�˲���ʧ��ʱ��Ϊ��, nobuff("�»�") �����ж�������
			v["�»�Ŀ��"] = party("û״̬:����", "�����Լ�", v["��Ҫ�ķ�"], "����<18", "���߿ɴ�", "�������")
			if v["�»�Ŀ��"] ~= 0 then
				v["�»�ǰĿ��"] = tid()			--��¼��ǰĿ��, �»���к���������ָ�
				if settar(v["�»�Ŀ��"]) then
					cast("�»���к")
				end
			end
		end
	end

	--���
	if tbuffstate("�ɴ��") then
		cast("����ͨ��")
	end

	--������
	if fight() and buffsn("����") <= 3 then
		cast("������")
	end

	--������
	if fight() and rela("�ж�") and dis() < 19 then
		cast("������")
	end

	--[[��ת���� ��ɢ ��GCD��ȥ��
	if tbufftype("��������|��������|��Ԫ������|��������") > 0 then
		fcast("��ת����")
	end
	--]]

	--����������
	if tbufftime("����", id()) < 3 then
		cast("�������")
	end

	--������
	if v["Ŀ�꼱������"] >= 3 then
		if tbufftime("����", id()) > 9 or (v["����Ŀ��"] ~= 0 and tid() == v["����Ŀ��"]) then
			cast("��������")
		end
	end

	--��������
	if rela("�ж�") and dis() < 9 and v["Ŀ�꾲ֹ"] and state("վ��") and nobuff("��������") then
		cast("��������")
	end

	if v["Ŀ�꼱������"] < 3 then
		cast("�������")
	end

	if v["Ŀ�꼱������"] >= 2 then
		--�������
		_, v["Ŀ��10�߹�������"] = tnpc("��ϵ:�ж�", "����<10", "��ѡ��")
		if v["Ŀ��10�߹�������"] >= 2 then
			cast("�������")
		end
		
		--��������
		if v["Ŀ��Ѫ���϶�"] and dis() < 19 and v["Ŀ�꾲ֹ"] and state("վ��") and cdtime("��������") <= 0 then
			cast("��������")
			
		end

		cast("��������")
	end
	
	cast("�������")
	cast("���Ҽ���")

	--�Ų������Ҽ���(�������ƶ�)
	cast("�������")
	cast("��������")
	cast("�������")
end


--�ͷż���
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		if SkillID == 3009 then
			v["����Ŀ��"] = TargetID	--��¼�ϼ�����Ŀ��
		end

		--[[
		if SkillID ~= 2341 then
			if TargetType == 2 then		--����2 ��ָ��λ��, ���� 3 4 ��ָ����NPC�����
				print("OnCast->["..xname(CasterID).."] �ͷ�:"..SkillName..", ����ID:"..SkillID..", ���ܵȼ�:"..SkillLevel..", Ŀ��λ��:"..TargetID.."|"..PosY.."|"..PosZ..", ��ʼ֡:"..StartFrame..", ��ǰ֡:"..FrameCount)
			else
				print("OnCast->["..xname(CasterID).."] �ͷ�:"..SkillName..", ����ID:"..SkillID..", ���ܵȼ�:"..SkillLevel..", Ŀ��ID:"..TargetID..", ��ʼ֡:"..StartFrame..", ��ǰ֡:"..FrameCount)
			end
		end
		--]]
	end
end

--����buff�б�
function OnBuffList(CharacterID)
	--������µ����Լ��ϼ�����Ŀ�꣬����Ŀ����Ϊ0, �����Ӳ���
	if CharacterID == v["����Ŀ��"] then
		v["����Ŀ��"] = 0
	end
end
