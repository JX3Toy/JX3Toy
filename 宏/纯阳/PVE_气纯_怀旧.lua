output("----------����----------")
output("2 3 2")
output("2 0 1 3")
output("3 0 0 2")
output("1 0 1 3")
output("1 2 0 1")
output("1 1")
output("0 3 2")
output("0 2 0 0")


--��ѡ��
addopt("����������", true)

--������
local v = {}

--�ȴ�����ͬ����־
local bWait = false

--������
local f = {}

f["û����"] = function()
	return gettimer("��������") > 0.5 and nobuff("��������")
end

--��ѭ��
function Main()

	if nofight() then
		if nobuff("��������") then
			cast("��������")
		end
		if nobuff("�¹�����") then
			cast("�¹�����")
		end
	end

	--��ɽ��
	if fight() and life() < 0.35 then
		if fcast("��ɽ��", true) then
			stopmove()
			bigtext("��ɽ��", 2, 2)
		end
	end

	--���Ϸ����
	if casting("���϶���") then return end


	--���ٲ��������
	if mana() < 0.3 and f["û����"]() and casting("�������") then
		return
	end

	--����������
	if getopt("����������") and dungeon() and nofight() then return end

	--���
	if tbuffstate("�ɴ��") and tcastleft() < 1 then
		cast("���Զ���")
	end
	
	--���Լ��Ʋ��
	local pcqdist, pcqtime = qc("�����Ʋ��", id(), id())		--�Լ���Χ�Լ����Ʋ��
	if rela("�ж�") and dis() < 20 then
		if pcqdist > -1 then		--û���Ʋ����߿��Ȧ��, �������Լ���������Ե�ľ��룬��Ȧ������������Ȧ���Ǹ���
			fcast("�Ʋ��", true)
		end
	end

	--������ͬ��
	if bWait and gettimer("躹�����") < 0.3 then
		return
	end

	--����
	if fight() and mana() < 0.35 and qidian() >= 8  then
		cast("��Ԫ��ȱ")
	end


	--����������
	if dungeon() and nofight() then return end

	--ƾ������
	if rela("�ж�") and dis() < 19 and cdtime("��������") > 60 then
		cast("ƾ������")
	end

	--����
	if rela("�ж�") and dis() < 19 and tstate("վ��|������|ѣ��|����|����|����") and tlifevalue() > lifemax() * 10 then
		if (pcqdist < -2 and pcqtime > 12) or cdtime("�Ʋ��") > 8 then		--���Ʋ�����棬�Ʋ��ʱ�����12�� ���߸շŹ��Ʋ��(���Ʋ�񷵽����������1�������ӳ�)
			if cdtime("���϶���") < 6 and qidian() >= 8 then		--���Ͽ���ȴ ���Ϸ�����
				if fcast("��������") then
					fcast("ƾ������")
					settimer("��������")
				end
			end
		end
	end

	--����������躹�
	v["��躹�"] = false
	if rela("�ж�") and dis() < 19 and (gettimer("��������") < 0.5 or bufftime("��������") > 2) and qidian() < 5 then
		v["��躹�"] = true
	end
	if v["��躹�"] then
		if fcast("躹�����") then
			bWait = true
			settimer("躹�����")
			return
		end
	end

	
	--����
	if qidian() >= 8 then
		if cast("���ǻ���") then
			--if cdtime("躹�����") > 0 or not v["��躹�"] then
				cast("�������")
			--end
		end
	end

	

	--Ŀ�굽�Լ�����5�߷�����
	local tSpeedXY, tSpeedZ = speed(tid())
	if rela("�ж�") and tSpeedXY <= 0 and tSpeedZ <=0 then	--Ŀ��û�ƶ�
		--castxyz("���϶���", point(tid(), 5, 0, tid(), id()))		--Ŀ��ǰ������

		if npc("����:��������", "����<3") ~= 0 then	--��Ϊ������������Ŀ���
			cast("���϶���")
		end
	end

	if fcast("�����ֻ�") then
		cast("�������")
	end

	if fcast("̫���޼�") then
		cast("�������")
	end

	if nobuff("��������") then
		cast("��������")
	end

	if nobuff("�¹�����") then
		cast("�¹�����")
	end
end


--�������
OnQidianUpdate = function()
	bWait = false
	--print("OnQidianUpdate", qidian())
end

--�ͷż���
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetID, nStartFrame, nFrameCount)
	if CasterID == id() then
		--print("OnCast -> ".."������: "..SkillName..", ID: "..SkillID..", �ȼ�: "..SkillLevel..", Ŀ��: "..TargetID..", ��ʼ֡: "..nStartFrame..", ��ǰ֡: "..nFrameCount)
	end
end


--������: ����������, ������̫��, �����Ʋ��, ����������, ������̫��, �������ǳ�, ����������, ������ɽ��
