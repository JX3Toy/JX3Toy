--����ʱ�����Ϣ
output("��Ѩ: [��β][�޳�][��Ӱ][����][�ҽ�][����][�ȹ�][����][���][��Ƭ��][��Ϣ][��Ϥ]")

--��ѡ��
addopt("����������", true)

--������
local v = {}
v["�ȴ������ͷ�"]= false

--��ѭ��
function Main(g_player)

	if fight() and life() < 0.5 then
		cast("��ˮ��")
	end
	
	--�ٳ���
	if nopet("����") then
		cast("������")
	end

	cast("��˹�", true)

	--Ŀ�겻�ǵжԣ�����
	if not rela("�ж�") then return end

	--����������
	if getopt("����������") and dungeon() and nofight() then return end

	
	--���﹥��
	if pet() then
		if pettid() ~= tid() then		--�����Ŀ�겻���Լ���Ŀ��
			cast("����")
		end

		cast("�û�")

		--�Ƴ��׼�
		if cdleft(16) < 0.5 then	--GCD�����
			if rela("�ж�") and dis() < 19 and tlifevalue() > lifemax() * 5 then
				cast("�Ƴ��׼�")
			end

			_, v["Ŀ��6�ߵж�����"] = tnpc("��ϵ:�ж�", "����<6", "��ѡ��")
			if v["Ŀ��6�ߵж�����"] >= 3 then
				cast("�Ƴ��׼�")
			end
		end
	end


	--�ȴ���������
	if casting() and castleft() < 0.13 then
		v["�ȴ������ͷ�"] = true
		settimer("��������")
	end
	if v["�ȴ������ͷ�"] and gettimer("��������") < 0.3 then
		return
	end

	cast("���")

	--������buff
	if buff("24479") then
		cast("Ы��")
	end

	--��Ƭ��
	if tlifevalue() > lifemax() then	--Ŀ����Ѫ�����Լ������Ѫ, ����ˣ��Ͳ������
		cast("��Ƭ��")
	end

	cast("��Ӱ")
	cast("����")
	cast("�Х")

	cast("Ы��")
	cast("ǧ˿")
end


--�ͷż���
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	--����ͷż��ܵ����Լ�
	if CasterID == id() then
		-- ��Ӱ Ы�� �ͷţ������ȴ�
		if SkillID == 13430 or SkillID == 2209 then
			v["�ȴ������ͷ�"] = false
		end
	end
end
