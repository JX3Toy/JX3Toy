output("��Ѩ: [��Į][�麨][ڤ��][����][����][�ٽ�][ն��][�ǻ�][����][����][�·�][�ľ�]")

--������
local v = {}
v["�ȴ���̬ͬ��"] = false

--������
local f = {}

f["�л���̬"] = function(SkillName)
	--�ȴ��Ͻ���ֱͬ��
	if gettimer("�Ͻ���ӡ") < 0.5 then return end

	if nobuff(SkillName) then
		if cast(SkillName) then
			settimer("��̬�л�")
			v["�ȴ���̬ͬ��"] = true
			exit()
		end
	end
end

--��ѭ��
function Main(g_player)
	if casting("��ն����") then return end

	if casting("��Х����") then
		if castleft() <= 0.125 then
			settimer("��Х������������")
		end
		return
	end

	--�ȴ���̬ͬ��
	if v["�ȴ���̬ͬ��"] and gettimer("��̬�л�") < 0.3 then
		return
	end

	--û��ս, ��˫��
	if nofight() then
		f["�л���̬"]("��������")
	end


	v["����"] = energy()
	v["����"] = rage()
	v["����"] = qijin()
	v["���Ƹ�����buff"] = gettimer("��Х������������") < 1 or bufftime("25049") > 5
	v["GCD���"] = cdinterval(16)


	--v["�д�"] = scdtime("�Ͻ���ӡ") < v["GCD���"] and scdtime("�Ƹ�����") < v["GCD���"] and v["���Ƹ�����buff"]
	--v["�д�"] = scdtime("�Ͻ���ӡ") < v["GCD���"] and odtime("�Ƹ�����") < 8 and v["���Ƹ�����buff"]
	v["�д�"] = scdtime("�Ͻ���ӡ") < v["GCD���"] and v["���Ƹ�����buff"] and v["����"] >= 25


	---------------------------------------------��
	if buff("��������") then
		if scdtime("�Ƹ�����") > 2 and scdtime("�Ͻ���ӡ") > 2 then
			if scdtime("������ն") < 1 then
				f["�л���̬"]("��������")
			end
			f["�л���̬"]("ѩ������")
		end

		if dis() < 6 then
			if od("�Ƹ�����") >= 2 then
				acast("�Ƹ�����")
			end

			if dis() < 5 then
				if acast("�Ͻ���ӡ") then
					settimer("�Ͻ���ӡ")
				end
			end

			if v["����"] < 30 and v["����"] < 30 then
				cast("��������")
			end


			acast("�Ƹ�����")
		end
	end

	---------------------------------------------�ε�
	if buff("ѩ������") then
		if v["�д�"] then
			if scdtime("������ն") < 1 then
				f["�л���̬"]("��������")
			end
			f["�л���̬"]("��������")
		end
		
		if tstate("վ��|������|ѣ��|����|����|����") and dis() < 16 then
			acast("�����Ұ")
		end

		if buff("19244") then
			cast("��ն����")
		end

		cast("��Х����")
	end

	---------------------------------------------˫��
	if buff("��������") then
		if tbufftime("������", id()) < 1 then
			cast("������")
		end

		if cast("������ն") then
			if v["�д�"] then
				f["�л���̬"]("��������")
			else
				f["�л���̬"]("ѩ������")
			end
		end
	end

end


--�ͷż���
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		if SkillName == "��������" or SkillName == "��������" or SkillName == "ѩ������" then
			v["�ȴ���̬ͬ��"] = false
		end
	end
end
