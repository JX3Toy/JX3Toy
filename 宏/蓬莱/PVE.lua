output("��Ѩ:[Ԩ��][��ɣ][����][��Դ][����][���][���][���][�ݻ�][����][����][���]")

--��ѡ��
addopt("����������", true)

--������
local v = {}
v["�ȴ������ͷ�"] = false
v["�ﻯ����"] = 0
v["��������"] = 0

--��ѭ��
function Main(g_player)
	
	--��������
	if casting("��������") then
		--��������
		if face() > 80 then
			turn()
		end
		--�ж϶�������
		if castpass() >= 1.1875 then
			stopcasting()
			settimer("����������������")
		end
	end

	--Ŀ�겻�ǵжԣ�����
	if not rela("�ж�") then return end

	--����������
	if getopt("����������") and dungeon() and nofight() then return end


	cast("�������")
	cast("���ͼ��")
	

	v["�г۷�����"] = npc("��ϵ:�Լ�", "ģ��ID:64696", "��ɫ����<5.5") ~= 0 or gettimer("����������������") < 0.5

	-------------------------------------------------------����
	if buff("14540") then		--�������, ����������ID
		--��غ�����
		if scdtime("�麣����") > 2 and scdtime("������ڤ") > 2 and scdtime("������") > 2 then
			if bufftime("���") < 3 then
				--����
				if scdtime("������") > 2 and gettimer("�ﻯ���С�����") > 0.3 and cast("�ﻯ���С�����") then
					settimer("�ﻯ���С�����")
				end
			else
				--���
				if gettimer("������ء����") > 0.3 and cast("������ء����") then
					settimer("������ء����")
				end
			end
		end

		--��һ�������жϣ�ż�������ӳ�������һ��û��������������߼���������
		if v["��������"] >= 2 then
			--���
			if gettimer("������ء����") > 0.3 and cast("������ء����") then
				settimer("������ء����")
			end
		end
		
		--13781, �ﻯ���б��
		if buff("13781") then
			cast("�麣����")
			
			if dis3() < 4 then
				cast("������ڤ")
			end

			--�ڶ����ٷ�������(�����ú��ʱ���ж�), ���˼�����ľ׮ò��û����, Ҳ�����ú��ʱ���ж�
			--if v["�ﻯ����"] > 1 then
				cast("������")
			--end
		else
			cast("�ﻯ����")
		end

	-------------------------------------------------------����
	else
		if v["�г۷�����"] and scdtime("�麣����") < 1.5 and scdtime("������ڤ") < 1.5 and scdtime("�ﻯ����") < 1.5 then
			if scdtime("Ծ��ն��") > 2 then
				cast("�������")
				return
			end
		end

		if dis() < 5.5 and gettimer("����������������") > 0.3 then
			cast("��������")
		end

		cast("Ծ��ն��")

		cast("ľ�����")

		if dis() < 6 then
			acast("��ˮ��ǧ")
		end
	end
end


--�ͷż���
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		--[[����
		if SkillID == 20733 then
			v["�ȴ������ͷ�"] = false
		end
		--]]

		--�������
		if SkillID == 19828 then		
			v["�ﻯ����"] = 0	--�ﻯ������0
			v["��������"] = 0
		end

		--�ﻯ���� 20049
		if SkillID == 20049 then
			v["�ﻯ����"] = v["�ﻯ����"] + 1
		end

		--�ﻯ����
		if SkillID == 20051 then
			v["��������"] = v["��������"] + 1
		end
	end
end
