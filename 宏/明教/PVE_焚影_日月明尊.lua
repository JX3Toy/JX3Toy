--[[����
[�����â]2 [�����ۻ�]3 [���Ĳ���]2
[���賤��]2 [��������]2 [��������]1
[������Ӱ]1 [����ٻ�]3 [�����¾]1
[�޼�Ӱ��]1 [��ҫ�쳾]2 [����ͬ��]3
[Ѫ�����]3 [��ԭ�һ�]2 [�ϳ�]1
[�������]1
[�����]3 [��������]2
--]]

--�ر��Զ�����
setglobal("�Զ�����", false)

--��ѡ��
addopt("����������", false)

--������
local v = {}
v["�����ն"] = false
v["�����ն"] = false

--��ѭ��
function Main(g_player)
	--��������
	local mapName = map()
	local func = tMapFunc[mapName]
	if func then
		func(g_player)
	end

	v["����"] = sun()
	v["����"] = sun_power()
	v["�»�"] = moon()
	v["����"] = moon_power()
	v["Ŀ��Ѫ���϶�"] = rela("�ж�") and tlifevalue() > lifemax() * 10	--Ŀ��Ѫ�������Լ����Ѫ��10��
	local tSpeedXY, tSpeedZ = speed(tid())
	v["Ŀ�꾲ֹ"] = tSpeedXY == 0 and tSpeedZ == 0		--xy�ٶȺ�Z�ٶȶ�Ϊ0


	--����������
	if getopt("����������") and dungeon() and nofight() then return end

	--[[���
	if tbuffstate("�ɴ��") then
		cast("����ҫ")
	end
	--]]

	if v["Ŀ��Ѫ���϶�"] and dis() < 4 and face() < 60 then
		if buff("����ͬ��") then
			cast("������")
		end
		
		if fight() and v["Ŀ�꾲ֹ"] and state("վ��") and cdleft(503) <= 0.25 and (tface() > 90 or buff("50986|51004|��������")) and cdtime("��ҹ�ϳ�") > 1 then
			if not v["����"] and not v["����"] and nobuff("�������|����ͬ��") then
				cast("�������")
			end
		end
	end

	if tface() > 90 or buff("50986|51004|��������") then
		cast("��ҹ�ϳ�")
	end

	cast("������ħ��")

	if not v["�����ն"] and not v["�����ն"] or (cdtime("����ն") <= 0 and  cdtime("����ն") <= 0) then
		cast("����ն")
		cast("����ն")
	end

	if v["�»�"] > v["����"] then
		cast("������")
	end
	
	cast("������")

	cast("����ն")
end

--�ͷż���
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		--print("OnCast->:"..SkillName..", ����ID:"..SkillID..", ���ܵȼ�:"..SkillLevel..", Ŀ��ID:"..TargetID..", ��ʼ֡:"..StartFrame..", ��ǰ֡:"..FrameCount)

		--����ն
		if SkillID == 3960 then
			v["�����ն"] = true
			return
		end

		--����ն
		if SkillID == 3963 then
			v["�����ն"] = true
			return
		end

		--������ħ��
		if SkillID == 3967 then
			v["�����ն"] = false
			v["�����ն"] = false
			return
		end
	end
end

-------------------------------------------------��������
tMapFunc = {}

tMapFunc["�����ؾ�"] = function(g_player)
	--����
	if tcasting("����") and dis() < 10 and tcastleft() < 1.5 then
		stopcasting()
		if tcastleft() < 0.5 then
			cast("��������")
			cast("ӭ�����")
		end
		exit()
	end

	--����
	if tcasting("����") and tcastleft() < 0.5 then
		settimer("Ŀ���������")
	end
	if gettimer("Ŀ���������") < 2 or tbuff("4147") then	--���� �����˺�
		turn(180)			--����Ŀ��
		exit()
	else
		if tname("��") and face() > 60 then
			turn()		--����Ŀ��
		end
	end

	--����
	if tcasting("����(��͸)") and dis() < 10 and tcastleft() < 1.5 then
		if tcastleft() < 1 then
			acast2("��������", tid(), 11)
			castxyz("�ùⲽ", point(tid(), 12, 0, tid(), id()))
		end
		exit()
	end
end
