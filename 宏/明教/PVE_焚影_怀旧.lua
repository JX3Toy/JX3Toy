--��ѭ��
function Main(g_player)
	cast("������ħ��")
	
	if tface() > 90 or buff("50986|51004") then
		if rela("�ж�") and dis() < 4 and cdtime("��ҹ�ϳ�") > 4 then
			if gettimer("������") > 1 and gettimer("�������") > 1 then
				if cast("������") then
					settimer("������")
				end
				
				if cast("�������") then
					settimer("�������")
				end
			end
		end

		cast("��ҹ�ϳ�")
	end

	cast("����ն")
	cast("������")
end
