output("----------����----------")
output("2 2 3")
output("0 2 2 3")
output("1 0 2 2")
output("2 0 1 2")
output("1 2 0 0")
output("1 1")
output("0 2 3")
output("0 0 0 2")


--��ѡ��
addopt("����������", true)

--������
local v = {}
v["����Ŀ��"] = 0
v["�»�ǰĿ��"] = 0


function Main(g_player)

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

	v["��������"] = tbuffsn("����", id())
	if v["����Ŀ��"] ~= 0 and tid() == v["����Ŀ��"] then		--�ϼ�����Ŀ��buff��ûͬ�����ͼ�1��
		v["��������"] = v["��������"] + 1
	end

	v["Ŀ��Ѫ���϶�"] = rela("�ж�") and tlifevalue() > lifemax() * 10


	--�»���к, ��Ҫ�Ե�ǰĿ���ͷŲ���Ч��
	if v["Ŀ��Ѫ���϶�"] and dis() < 25 and cdtime("�»���к") <= 0 and v["��������"] < 3 then
		--��Ӧ��buff�ȼ�����Ҫ��Ŀ���ڹ�
		v["�»�buff�ȼ�"] = 1		--��й, ����50%, �⹦
		v["�»�Ŀ���ڹ�"] = "��Ѫս��|������|̫�齣��|�����|��ˮ��|ɽ�ӽ���"
		if tlife() > 0.5 then
			v["�»�buff�ȼ�"] = 2	--�»�, ����50%, �ڹ�
			v["�»�Ŀ���ڹ�"] = "ϴ�辭|�׽|������|�뾭�׵�|��ϼ��|�����ľ�|���ľ�|����|�����|���޹��|��Ӱʥ��|����������"
		end

		if not g_player.IsHaveBuff(50372, v["�»�buff�ȼ�"]) then		--�»�����йʱ�䵽�˲���ʧ��ʱ��Ϊ��, nobuff("�»�") �����ж�������
			v["�»�Ŀ��"] = party("û״̬:����", "�����Լ�", "�ڹ�:"..v["�»�Ŀ���ڹ�"], "����<18", "���߿ɴ�", "�������")
			if v["�»�Ŀ��"] ~= 0 then
				v["�»�ǰĿ��"] = tid()			--��¼��ǰĿ��, �»���к���������ָ�
				if settar(v["�»�Ŀ��"]) then
					cast("�»���к")
				end
			end
		end
	end


	--����������
	if getopt("����������") and dungeon() and nofight() then return end

	--���
	if tbuffstate("�ɴ��") then
		cast("����ͨ��")
	end

	if fight() and buffsn("����") < 3 then
		cast("������")
	end

	--[[��ɢ
	if tbufftype("��������|��������|��Ԫ������|��������") > 0 then
		cast("��ת����")
	end
	--]]

	
	if v["��������"] >= 3 then
		if v["Ŀ��Ѫ���϶�"] and dis() < 19 and tstate("վ��|������|ѣ��|����|����|����") and state("վ��") then
			if cast("��������") then
				cast("������")
			end
		end
		cast("��������")
	end


	if rela("�ж�") and dis() < 9 and tstate("վ��|������|ѣ��|����|����|����") and nobuff("��������") then
		cast("��������")
	end


	_, v["Ŀ��8�߹�������"] = tnpc("��ϵ:�ж�", "����<8", "��ѡ��")
	if v["Ŀ��8�߹�������"] >= 3 then
		cast("�������")
	end

	_, v["Ŀ��10�߹�������"] = tnpc("��ϵ:�ж�", "����<10", "��ѡ��")
	if v["Ŀ��10�߹�������"] >= 3 then
		cast("�������")
	end

	
	cast("�������")

	if v["��������"] >= 2 then
		cast("��������")
	end

	cast("���Ҽ���")


	--�Ų������Ҽ���(�������ƶ�)
	cast("�������")
	cast("�������")

end


--�ͷż���
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		--Ŀ��buffͬ����ʱ̫��, �����¼�ϼ�����Ŀ��
		if SkillID == 3009 then
			v["����Ŀ��"] = TargetID
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
