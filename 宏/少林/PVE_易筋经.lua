--����ͬ����־
local bWait = false

--��ѭ��
function Main(g_player)
	if nobuff("��ħ") then
		cast("��ҵ��Ե")
	end

	--�ȴ�����ͬ��
	if bWait then
		if gettimer("������") < 0.3 or gettimer("�޺�����") < 0.3 then
			return
		end
	end

	if rela("�ж�") and dis() < 4 then
		if qidian() >= 3 then
			if cast("�޺�����") then
				settimer("�޺�����")
				bWait = true
				return
			end
		end
		if qidian() < 1 and bufftime("�޺�����") > 15 then
			if cast("������", true) then
				settimer("������")
				bWait = true
				return
			end
		end
	end

	
	if rela("�ж�") and dis() < 5.5 and tbufftime("��ɨ����", true) < 2 then
		cast("��ɨ����")
	end

	if qidian() >= 3 then
		cast("����ʽ")
		cast("Τ������")
	end

	if rela("�ж�") and dis() < 12 and qidian() < 3 and bufftime("�޺�����") > 0.3 then
		acast("�����ඥ")
	end

	cast("��ȱʽ")
	cast("�ն��ķ�")

	if dis() > 8 then
		cast("����ʽ")
	end

	if cdleft(16) > 0.6 and qidian() < 2 then
		cast("׽Ӱʽ")
	end

	if nobuff("������") then
		cast("������", true)
	end

end


--�������
OnQidianUpdate = function()
	bWait = false
end
