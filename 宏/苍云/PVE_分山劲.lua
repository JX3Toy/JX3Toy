output("��Ѩ:[����][����][��Ұ][��Į][����][����][����][��ս][����][�ߺ�][����][���ƽ��]")

local v = {}

function Main(g_player)
	v["ŭ��"] = rage()
	v["���Ʋ���"] = buffsn("����")

	if rela("�ж�") and dis() < 15 then
		cast("Ѫŭ")
	end

	if pose("���") then
		v["ն��CD"] = cdleft(801)
		v["�浶GCD���"] = cdinterval(16)

		if v["���Ʋ���"] >= 4 then
			v["ն��CD"] = v["ն��CD"] - v["�浶GCD���"]
		end

		if v["ŭ��"] >= 25 and v["ն��CD"] < 1 then
			if cast("�ܷ�") then
				return
			end
		end

		cast("�ܻ�")
		cast("��ѹ")
		cast("����")
		cast("�ܵ�")
	end

	if pose("�浶") then
		if v["ŭ��"] < 10 then
			cast("�ܻ�")
			return
		end

		if buff("���") then	--����ͳ���buff
			cast("����")
		end

		--ն��
		if nobuff("���") then
			cast("ն��")
		end

		--����, 15��ŭ��
		if v["ŭ��"] >= 25 and tbuff("��Ѫ", id()) and tnobuff("����", id()) then		--Ŀ������Ѫû��ǿ
			cast("����")
		end

		cast("��������")
		cast("������Ӫ")

		if bufftime("�ܷ�") > 10 and cntime("�ܻ�", true) > 2  then
			cast("���ƽ��")
		end

		cast("����")

		--�ٵ��� 10ŭ��
		if v["ŭ��"] >= 20 and v["ն��CD"] > 6 then
			cast("�ٵ�")
		end
	end
end
