--������ߣ����ó�Ӱ�ӣ�վ׮������
output("��Ѩ: [����][����][���][���][����][��и][���][����][Ԧҫ][ǿ��][ն��][��ԯ]")

--��ѡ��
addopt("����������", true)

--�ر��Զ�����
setglobal("�Զ�����", false)

--������
local v = {}

--��ѭ��
function Main(g_player)

	v["����"] = energy()
	v["����"] = buff("24029") and gettimer("������") > 0.3 and gettimer("��Ӱ׷��") > 0.3
	v["˫��"] = buff("24110") and gettimer("�·�����") > 0.3

	--û��ս���ʶ��
	if rela("�ж�") and dis() < 30 and nofight() and nobuff("ʶ��") and nobuff("�л����") and miji("�۷�˲�", "���η粽���۷�˲�����żͼ��ҳ") then
		if cast("�۷�˲�") then
			return
		end
	end

	--����������
	if getopt("����������") and dungeon() and nofight() then return end

	--���
	if tbuffstate("�ɴ��") then
		cast("������")
	end

	---------------------------------------------˫��
	v["���˾���"] = 6
	if qixue("����") then
		v["���˾���"] = v["���˾���"] + 2
	end

	--�·�����
	if rela("�ж�") and dis() < v["���˾���"] and face() < 80 then
		if tbuffsn("����", id()) >= 3 then
			if cast("�·�����") then
				settimer("�·�����")
				return
			end
		end
	end

	--���ƶ���
	if tbufftime("����", id()) > 6 then
		cast("���ƶ���")
	end

	--��������
	if rela("�ж�") and dis() < v["���˾���"] and face() < 80 then
		cast("��������")
	end
	
	---------------------------------------------����

	--������, ������GCD 1��, ������CD 4��
	if cdleft(2436) >= 1 and cdleft(2425) > 2 then
		cast("������")
	end

	--��Ӱ׷��
	if rela("�ж�") and dis() < 6 then
		if v["����"] and cdtime("������") > 2 and cdtime("ͣ����") > 2 and cdtime("������") > 1 and v["����"] < 80 and tbufftime("����", id()) > 6 then
			if cast("��Ӱ׷��") then
				settimer("��Ӱ׷��")
				return
			end
		end
	end
	
	--������
	v["�����ƾ���"] = 4
	if miji("������", "�������Ʒ��������ơ��洫����") then
		v["�����ƾ���"] = v["�����ƾ���"] + 4
	end
	if rela("�ж�") and dis() < v["�����ƾ���"] and face() < 80 then
		if cast("������") then
			settimer("������")
			return
		end
	end
	
	if v["����"] < 93 then
		cast("������")
		cast("ͣ����")
	end

	cast("������")
end

--�ͷż���
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		--��ϳ۷�˲�
		if SkillID == 32140 then
			jump()
		end
	end
end
