output("----------����----------")
output("2 3 1")
output("3 2 2 2")
output("2 0 3 1")
output("3 0 2 1")
output("0 0 0 2")
output("1")
output("0 2 3")
output("0 0 1 0")


--������û��ս���ż���
addopt("����������", true)

--����
function JianShang()
	if fight() and gettimer("Х�绢") > 0.5 and gettimer("��") > 0.5 and gettimer("����ɽ") > 0.5 and nobuff("Х�绢|��|����ɽ") then
		if cast("Х�绢") then
			settimer("Х�绢")
			return
		end

		if rela("�ж�") and ttid() == id() then
			if dis() < 4 or (tcasting() and tcastleft() < 1) then		--����С��4�� �� ����ʣ��ʱ��С��1��
				if cast("��") then
					settimer("��")
					return
				end
			end
		end

		if life() < 0.5 and buffstate("����Ч��") < 38 then
			if cast("����ɽ") then
				settimer("����ɽ")
				return
			end
		end
	end
end


function Main()

	--����������
	if getopt("����������") and dungeon() and nofight() then return end

	--���
	if tbuffstate("�ɴ��") and tcastleft() < 1 then
		cast("��")
	end

	--Ŀ���ǵ��ˣ�4����, ��û���
	if rela("�ж�") and dis() < 4 and tlifevalue() > lifemax() * 3 then
		cast("�ͻ���ɽ")
		cast("�����")
		cast("������", true)
		if fight() then
			if life() < 0.6 or mana() < 0.6 then
				cast("������")
			end
		end
	end


	--����
	JianShang()


	if tbuff("�²�", id()) then
		if tnobuff("�Ʒ�", id()) then
			cast("�Ʒ�")
		end
		cast("��")
	end

	if life() < 0.5 or tbufftime("�Ʒ�", id()) < 2 then
		cast("��")
	end

	cast("����")
	cast("����")
	cast("����")
	cast("����")

	cast("ͻ")

	cast("��ҡֱ��")

	--GCD�м�����ͻ
	if buff("����") and cdleft(16) > 1 and cdtime("ͻ") < 0.2 then
		jump()
	end

end
