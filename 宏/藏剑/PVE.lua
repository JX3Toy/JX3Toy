output("��Ѩ: [�Ծ�][���][ҹ��][����][ӳ������][����][ƾ��][Σ��][����][��ѩ][���][��������]")

--������
local v = {}
v["�ȴ��ڹ��л�"] = false
v["�ȴ���������"] = false


--��ѭ��
function Main(g_player)

	--�������ٷ����
	if casting("��������") then
		return
	else
		nomove(false)
	end

	--�ȴ���������
	if casting() and castleft() < 0.13 then
		v["�ȴ���������"] = true
		settimer("��������")
	end

	if v["�ȴ���������"] and gettimer("��������") < 0.3 then
		return
	end

	if v["�ȴ��ڹ��л�"] and gettimer("Х��") < 0.5 then
		return
	end


	v["����"] = rage()

	-------------------------------------------------------�ὣ
	if mount("��ˮ��") then

		if cdtime("��Ϫ����") > 2 and  rage() >= 90 then
			cast("Х��")
		end


		cast("������")
		
		if acast("�����´�", 180) then
			return
		end
		
		if rela("�ж�") and dis() < 5 then
			cast("��Ϫ����")
		end
		
		cast("����")
	end

	-------------------------------------------------------�ؽ�
	if mount("ɽ�ӽ���") then
		
		if nobuff("����") and cntime("Х��", true) < 3 then
			cast("Х��")
			return
		end

		if bufftime("����") > 10 and v["����"] < 30 then
			cast("ݺ����")
		end

		if nobuff("����") then
			cast("����")
		end

		if rela("�ж�") and dis() < 10 and nobuff("ҹ��") and cdtime("�Ʒ����") <= 0 and v["����"] >= 30 then
			if cast("����ƾ�") then
				settimer("����ƾ�")
			end
		end

		if gettimer("����ƾ�") < 0.5 or buff("�ƾ�") or dis() < 4 then
			cast("�Ʒ����")
		end

		if rela("�ж�") and dis() < 10 and v["����"] < 30 then
			cast("��������")
		end

		cast("Ϧ���׷�")

		cast("����")
	end

end


--�л��ڹ�
function OnMountKungFu(KungFu, Level)
	v["�ȴ��ڹ��л�"] = false
end


--�ͷż���
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		--[Ϧ���׷�][�Ʒ����][������ɽ]
		if SkillID == 1600 or SkillID == 1593 or SkillID == 18333 then
			v["�ȴ���������"] = false
		end
	end
end
