output("��Ѩ: [��÷��][ǧ�����][��ױ][��÷][����][������][����][Ԫ��][ӯ��][����][����][˪��]")

--��ѡ��
addopt("����������", true)


--��ѭ��
function Main(g_player)

	if fight() and life() < 0.5 then
		cast("��صͰ�")	
	end

	cast("�Ĺ���")

	--����������
	if getopt("����������") and dungeon() and nofight() then return end

	if tbuffstate("�ɴ��") then
		fcast("����ͨ��")
	end

	if tbuffsn("����", id()) >= 3 and tbufftime("����", id()) > 6 and dis() < 20 then
		if cast("������") and tlifevalue() > lifemax() * 5 then
			cast("��������")
		end
	end

	if tbuffsn("����", id()) < 3 or tbufftime("����", id()) < casttime(2707) + 0.2 then
		cast("�������")
		cast("��������")
	end

	--���Ҽ���, �������Ų������ü���ID
	cast(2707)

	cast("��������")
	cast("�������")
	cast("��������")
end
