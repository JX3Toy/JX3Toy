--���������������㹻�ռ�, �ڰ������߿�ʼ����

function Main(g_player)
	--�ո�
	if buff("11967") then
		if gettimer("�ո�") > 3 then
			actionclick(1, 2)
			settimer("�ո�")
			print("�ո�")
		end
		return
	end

	--�ж��������
	if g_player.GetItemAmountInPackage(5, 7843) < 1 then
		bigtext("û�����", 0.5)
		return
	end

	--��ʼ����
	if nobuff("����") then
		if gettimer("������¨") > 2 then
			interact("�����¨")
			settimer("������¨")
			print("������¨")
		end
		return
	end

	--�Ÿ�
	if nobuff("11966") and gettimer("�Ÿ�") > 6 and gettimer("������¨") > 3 then
		actionclick(1, 1)
		settimer("�Ÿ�")
		print("�Ÿ�")
	end
end
