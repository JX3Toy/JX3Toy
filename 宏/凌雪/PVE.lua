output("��Ѩ:[����][ѩ��][����][���][����][Ԩ��][����][���л�ת][�ٽ�][����][����][��·]")

--��ѡ��
addopt("����������", true)

--������
local v = {}
v["�ȴ��ź�Ķ�������"] = false

--��ѭ��
function Main(g_player)

	--�ȴ��ź�Ķ�������
	if casting("�ź��") and castleft() < 0.13 and cn("�ź��") <= 1 then
		settimer("�ź�Ķ�������")
		v["�ȴ��ź�Ķ�������"] = true
	end
	if v["�ȴ��ź�Ķ�������"] and gettimer("�ź�Ķ�������") < 0.5 then
		return
	end

	--�������⹳���
	if gettimer("�����⹳") < 0.3 then return end

	--Ŀ�겻�ǵжԽ���
	if not rela("�ж�") then return end

	--����������
	if getopt("����������") and dungeon() and nofight() then return end

	v["�ź�Ķ���ʱ��"] = casttime("�ź��")

	--����
	v["����"] = false

	--12����
	if dis() > 12 then
		v["����"] = "12����"
	end

	--3����
	if dis() > 3 and bufftime("����") < 1 and cdtime("������") <= 0 and cdtime("�����⹳") < 1 then
		v["����"] = "3����"
	end

	--�Ź�������
	if dis() > 6 and v["������CD"] then
		v["����"] = "�Ź�������"
	end

	if v["����"] and gettimer("Ѫ����Ȫ") > 1 then
		if cast("Ѫ����Ȫ") then
			--�������ԭ��
			print(v["����"])
			settimer("Ѫ����Ȫ")
		end
	end

	--�������˴��
	if dis() < 3 and cntime("�ź��", true) < v["�ź�Ķ���ʱ��"] * 2 + 0.5 and cdtime("������") < v["�ź�Ķ���ʱ��"] * 3 + 0.5  then
		if cdtime("�����⹳") <= 0 then
			cast("��ڤ����")
			if nobuff("����|˫��") then
				if cast("�����⹳") then
					settimer("�����⹳")
					return
				end
			end
		end
	end

	--������
	if tbufftime("����", id()) > 0.1 then
		cast("������")
	end

	--���л�ת
	if (gettimer("�����⹳") < 1 or bufftime("����") > 6) and bufftime("24744") > 1 then		--24744 ��·����������
		if cdtime("���л�ת") <= 0 then
			cast("���л�ת")
			return
		end
	end

	--ն�޳�
	if dis() < 3 and cdtime("�����⹳") < 6 then
		if cdtime("ն�޳�") <= 0 then
			cast("��ڤ����")
		end
		cast("ն�޳�")
	end

	--��
	--if dis() > 6 and dis() < 12 and gettimer("Ѫ����Ȫ") > 0.5 and nobuff("����|˫��") then
	if dis() < 12 and gettimer("Ѫ����Ȫ") > 0.5 and nobuff("����|˫��") then

		--������
		v["��������"] = false
			
		--���л�תCD��������CD��
		if face() < 60 and bufftime("�ٽ�") > 0.1 and buffsn("�ٽ�") >= 3 and bufftime("����") > 0.1 then
			if cdtime("���л�ת") > 16 then
				v["��������"] = true
			end
			
			if bufftime("24744") > 0.1 then
				print(cdtime("���л�ת"), bufftime("24744"))
			end

			if bufftime("24744") > 0.1 and cdtime("���л�ת") > bufftime("24744") then
				v["��������"] = true
			end
		end

		--�з���
		if npc("��ϵ:�Լ�", "ģ��ID:107305", "����<12", "�Ƕ�<60") ~= 0 then
			v["��������"] = true
		end

		if v["��������"] then
			cast("������")
		end

		--������
		if buffsn("�ٽ�") >= 3 then
			--���͹�, ��������
			if bufftime("�ٽ�") > 3.5 and buffsn("�ٽ�") >= 3 and bufftime("����") > 3.5 and cdtime("������") <= 0 then
				cast("���͹�")
			end

			acast("������")
		end

		--�ź��
		cast("�ź��")

		acast("������")
	end


	if dis() < 6 then
		cast("�Ǵ�ƽҰ")
	end

end


--�ͷż���
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		--�ź��
		if SkillID == 22327 then
			v["�ȴ��ź�Ķ�������"] = false
		end
		--Ѫ����Ȫ
		if SkillID == 22274 then
			v["������CD"] = false
		end
	end
end

--��ʼ������������(������)
function OnChannel(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, Frame, StartFrame, FrameCount)
	if CasterID == id() then
		--������
		if SkillID == 22320 and cdtime("������") > 3 then
			v["������CD"] = true
		end
	end
end
