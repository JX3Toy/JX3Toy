output("----------����----------")
output("2 3 2")
output("2 2 0 1")
output("1 3 0 2")
output("1 2 3 0")
output("3 2 1")
output("1")
output("0 3 2")

--��ѭ��
function Main(g_player)
	cast("������ħ��")
	
	if rela("�ж�") and dis() < 4 and cdtime("��ҹ�ϳ�") > 4 and gettimer("�������") > 2 then
		if cast("������") then
			settimer("������")
		end
	end

	if tface() > 90 or buff("50986|51004") then
		if rela("�ж�") and dis() < 4 and cdtime("��ҹ�ϳ�") > 4 and gettimer("������") > 2 then	
			if cast("�������") then
				settimer("�������")
			end
		end

		cast("��ҹ�ϳ�")
	end

	cast("����ն")
	cast("������")
end
