output("��Ѩ: [����][�ɷ�][�ҷ�][����][����][ʦ��][ֹ֪][����][����][�ƺ�][����][�޾���]")

--������
local v = {}
v["�ȴ����ͷ�"] = false
v["�����"] = 0

--��ѭ��
function Main(g_player)

	--�ȴ����ͷ�
	if casting("��|�乬") and castleft() < 0.13 then
		settimer("����������")
		v["�ȴ����ͷ�"] = true
	end
	if v["�ȴ����ͷ�"] and gettimer("����������") < 0.3 then
		return
	end

	--û��ս, �и�ɽ��ˮ
	if nofight() and nobuff("��ɽ��ˮ") then
		cast("��ɽ��ˮ")
		return
	end

	--���
	if tbuffstate("�ɴ��") then
		cast("������Х")
	end

	v["�������"] = buffsn("����")
	v["��ʱ��"] = tbufftime("��", id())
	v["��ʱ��"] = tbufftime("��", id())

	if rela("�ж�") then
		cast("��Ӱ��б")
	end

	if buff("��ɽ��ˮ") then
		if gettimer("�ͷű乬") < 2 then
			cast("������ѩ")
			return
		end

		if v["��ʱ��"] < 0.2 then
			cast("��")
		end

		if v["��ʱ��"] < 0.2 then
			cast("��")
		end
		
		cast("�乬")
	end

	if buff("������ѩ") then

		v["�и�ɽ"] = false

		if v["�����"] >= 2 then	--����ѭ��
			v["�и�ɽ"] = true
		end
		
		if v["��ʱ��"] < 3.5 or v["��ʱ��"] < 3.5 then	--�����ж�
			v["�и�ɽ"] = true
		end

		if v["�и�ɽ"] then
			cast("��ɽ��ˮ")
			return
		end

		if v["�������"] == 5 then
			cast("��")
		end

		cast("��")
	end
end


--�ͷż���
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		--��
		if SkillID == 14064 then
			v["�ȴ����ͷ�"] = false
		end

		--�乬
		if SkillID == 14298 then
			v["�ȴ����ͷ�"] = false
			settimer("�ͷű乬")
		end

		--��ɽ��ˮ
		if SkillID == 14069 then
			v["�����"] = 0
		end

		--��
		if SkillID == 14068 then
			v["�����"] = v["�����"] + 1
		end
	end
end
