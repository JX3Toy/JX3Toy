--[[����
[����]2[����]3
[����]2[��ִ]2[���]3
[��վ�]1[�Ĺ�]2[��ü]2
[����]2[��ˮ]2[����]1
[��ħ�ɶ�]2[����]1[����]2[��ħ]1
[����ʽ]1
[ҵ��]2[ǧ��]3
[����]2
--]]

--�ر��Զ�����
setglobal("�Զ�����", false)

--�ȴ�����ͬ����־
local bWait = false

--������
local v = {}

--��ѭ��
function Main(g_player)
	--׽Ӱʽ����������ʱ��
	if casting("׽Ӱʽ") and castleft() < 0.13 then
		settimer("׽Ӱʽ��������")
	end

	--������
	if nofight() and nobuff("������") then
		cast("������", true)
	end

	--����
	if fight() then
		if life() < 0.6 and buffstate("����Ч��") < 40 then
			cast("�����")
		end
		if life() < 0.4 then
			cast("�͹Ǿ�")
		end
	end

	--���
	if tbuffstate("�ɴ��") then
		cast("����ʽ")
	end

	--Ŀ�겻�ǵ��ˣ�����
	if not rela("�ж�") then return end

	--�ȴ�����ͬ��
	if bWait and gettimer("�ȴ�����ͬ��") <= 0.25 then return end

	local speedXY, speedZ = speed(tid())
	v["Ŀ�꾲ֹ"] = speedXY == 0 and speedZ == 0		--xy�ٶȺ�Z�ٶȶ�Ϊ0
	v["Ŀ��Ѫ���϶�"] = tlifevalue() > lifemax() * 5	--Ŀ�굱ǰѪ�����Լ����Ѫ��5��

	--���ľ�
	if dis() < 4 then
		cast("���ľ�")
	end

	--������
	if dis() < 4 and qidian() < 1 and v["Ŀ��Ѫ���϶�"] then
		if cast("������") then
			SetWait()
		end
	end

	--׽Ӱʽ, Ŀ�꾲ֹ 2���� �н��ŭĿ
	if gettimer("׽Ӱʽ��������") > 0.5 and v["Ŀ�꾲ֹ"] and v["Ŀ��Ѫ���϶�"] and qidian() >= 2 and bufftime("���ŭĿ") > 2 and cdleft(16) > 0.8 then
		--�ھ��η�Χ��
		local x, y  = xxpos(id(), tid())
		if x > 0 and x < 4 and y > -2 and y < 2 then
			--�ܷ�����, [����]����צ��һ�뼸��
			if tlife() < 0.3 or buff("����") then
				if cast("׽Ӱʽ") then
					SetWait()
				end
			end
		end
	end

	--����
	if buff("����") then
		if bufflv("����") == 1 then
			if cast("Τ������") then
				SetWait()
			end
		end
		if bufflv("����") == 2 then
			if cast("����ʽ") then
				SetWait()
			end
		end
		return
	end

	--���ŭĿ
	if qidian() >= 3 and dis() < 4 and cdleft(16) < 0.5 then
		if cast("���ŭĿ") then
			SetWait()
		end
	end

	--����ʽ
	if qidian() >= 3 then
		if cast("����ʽ") then
			SetWait()
		end
	end

	--Τ������
	if qidian() >= 3 then
		if cast("Τ������") then
			SetWait()
		end
	end

	--��ɨ����
	if dis() < 4.5 then
		if cast("��ɨ����") then
			SetWait()
		end
	end

	if bufftime("����") < 2 then
		if cast("����ʽ") then
			SetWait()
		end
	end

	if cast("��ȱʽ") then		--û�����˺��ߣ������Դ�������
		SetWait()
	end

	if cast("����ʽ") then
		SetWait()
	end
	
	if cast("�ն��ķ�") then
		SetWait()
	end

	if dis() > 10 then
		cast("����ʽ")
	end

end

--��������ȴ���־, �����Ҫ�ȽϾ�ȷ���ж�����, �ͷź������б䶯�ļ��ܵ���
function SetWait()
	bWait = true
	settimer("�ȴ�����ͬ��")
	exit()
end

--�������
function OnQidianUpdate()
	bWait = false
end
