output("��Ѩ: [����][����][����][����][��ħ�ɶ�][���ŭĿ][����][����][����][����][���][ҵ��]")

--������
local v = {}
v["�ȴ�����ͬ��"] = false


--��ѭ��
function Main(g_player)

	--�ȴ�����ͬ��
	if v["�ȴ�����ͬ��"] and gettimer("�ȴ�����ͬ��") < 0.5 then
		return
	end

	--Ŀ�겻�ǵжԽ���
	if not rela("�ж�") then return end

	--���
	if tbuffstate("�ɴ��") then
		cast("����ʽ")
	end

	v["����"] = qidian()

	--�޺�����
	if rela("�ж�") and dis() < 4 and v["����"] >= 3 then
		if cast("�޺�����") then
			settimer("�ȴ�����ͬ��")
			v["�ȴ�����ͬ��"] = true
			return
		end
	end

	--��ҵ��Ե
	if dis() < 4 and cdleft(16) > 0.5 then
		if nobuff("����") then
			--����
			if cn("��ȱʽ") > 0 and tbufftime("��ɨ����", id()) > 6 then
				cast("��ҵ��Ե")
			end
		else
			--��ħ
			if nobuff("24620") then		--ҵ���Ĵ���CD
				if cast("��ҵ��Ե") then
					v["�ȴ�����ͬ��"] = true
					settimer("�ȴ�����ͬ��")
				end
			end
		end
	end

	--������
	if dis() < 4 and buffsn("����") >= 3 and v["����"] < 2 then
		cast("������")
	end

	--ҵ���Ĵ���CD
	if buff("24620") then
		if qidian() >= 3 then
			cast("����ʽ")
		end
		cast("��ȱʽ")
		return
	end

	if rela("�ж�") and dis() < 5.5 and tbufftime("��ɨ����", id()) < 2 then
		cast("��ɨ����")
	end

	if qidian() >= 3 then
		cast("����ʽ")
		cast("Τ������")
	end

	cast("��ȱʽ")

	if rela("�ж�") and dis() < 5.5 then
		cast("��ɨ����")
	end

	cast("��ȱʽ")
	cast("�ն��ķ�")

	if dis() > 8 then
		cast("����ʽ")
	end

	--׽Ӱʽ, ����GCD�ض�
	if cdleft(16) > 0.6 and qidian() < 2 then
		cast("׽Ӱʽ")
	end

	if nobuff("������") then
		cast("������", true)
	end

end


--�������
OnQidianUpdate = function()
	v["�ȴ�����ͬ��"] = false
end
