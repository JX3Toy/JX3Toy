--[[ ��Ѩ: [��÷��][ǧ�����][��ױ][��÷][����][������][����][����][ӯ��][����][ҹ��][����]
�ؼ�:
����  3�˺� 1����
����  2��Ϣ 1�˺� 1Ч��(�ϼ�������CD)
����  2���� 2�˺�
����  3��Ϣ 1Ч��(����)
���  2��Ϣ 1���� 1���� ����Ѫ����

��ʮһ����ѨҲ���Գ���[����]
--]]

--�ر��Զ�����
setglobal("�Զ�����", false)

--��ѡ��
addopt("����������", false)
addopt("���", false)

--������
local v = {}
v["��¼��Ϣ"] = true

--������
local f = {}

--��ѭ��
function Main(g_player)
	--�����Զ����ݼ�1�ҷ�ҡ, ע���ǿ�ݼ��趨�������Ŀ�ݼ�1ָ���İ��������Ǽ����ϵ�1
	if keydown(1) then
		cast("��ҡֱ��")
	end

	--����
	if fight() and life() < 0.6 then
		cast("��صͰ�")
	end

	--������
	if nobuff("����") then
		cast("�����ķ�")
	end

	--����
	if qixue("����") and rela("�ж�") and dis() < 30 then
		if nobuff("����") or nofight() then
			cast("�Ĺ���", true)
		end
	end

	--��ʼ������
	v["Ŀ�꼱������"] = tbuffsn("����", id())
	v["Ŀ�꼱��ʱ��"] = tbufftime("����", id())
	v["����ʱ��"] = bufftime("��������")
	
	v["����CD"] = scdtime("��������")
	v["����CD"] = scdtime("�������")
	v["��ӰCD"] = scdtime("��Ӱ����")	
	v["����CD"] = scdtime("��������")
	v["����CD"] = scdtime("��������")
	v["������CD"] = scdtime("������")
	
	v["����û����"] = nobuff("22695")
	v["����û��Ӱ"] = nobuff("23190")
	v["����û����"] = nobuff("23191")
	v["����û����"] = nobuff("23192")
	v["����û����"] = nobuff("26240")
	v["�������"] = buffsn("����")	--26287, 6��, �����Ǵ���, ����ʱɾ������buff
	v["����ʱ��"] = bufftime("25910")

	v["Ŀ��Ѫ���϶�"] = rela("�ж�") and tlifevalue() > lifemax() * 10	--Ŀ�굱ǰѪ�������Լ����Ѫ��5��
	local tSpeedXY, tSpeedZ = speed(tid())
	v["Ŀ�꾲ֹ"] = rela("�ж�") and tSpeedXY <= 0 and tSpeedZ <= 0		--Ŀ��û�ƶ�

	--------------------------------------------- ��ʼ���˺�

	--����������
	if getopt("����������") and dungeon() and nofight() then return end

	--���
	if getopt("���") and tbuffstate("�ɴ��") then
		fcast("����ͨ��")
	end
	
	--�ȴ���Ӱ�ͷ�
	if gettimer("��Ӱ����") < 0.3 then return end

	--����
	if v["Ŀ��Ѫ���϶�"] and dis() < 20 and face() < 80 and cdleft(16) < 0.5 and v["�������"] == 2 then
		CastX("��������")
	end

	--����
	if qixue("����") and v["Ŀ�꾲ֹ"] and dis() < 9 then
		v["�ƶ���������"] = keydown("MOVEFORWARD") or keydown("MOVEBACKWARD") or keydown("STRAFELEFT") or keydown("STRAFERIGHT") or keydown("JUMP")
		if not v["�ƶ���������"] and state("վ��") and nobuff("��������") and v["����û����"] and v["����û��Ӱ"] and v["����û����"] and v["����û����"] and v["����û����"] then
			CastX("������")
		end
	end

	f["��������"]()
	
	--��Ӱ����
	if v["����û��Ӱ"] and v["����û����"] and cdleft(16) >= 0.5 and cdleft(16) < 1 then
		if CastX("��Ӱ����") then
			return
		end
	end

	--�������ȴ�����
	if v["����ʱ��"] > 1 then
		f["���Ҽ���"]()
	end

	--Ŀ����������6��
	if tbuffsn("����", id()) > 6 then
		f["��������"]()
	end

	f["�������"]()
	f["���Ҽ���"]()
	f["��������"]()
end

f["�������"] = function()
	if v["����û����"] then
		CastX("�������")
	end
end

f["��������"] = function()
	if v["����û����"] then
		CastX("��������")
	end
end

f["��������"] = function()
	if v["����û����"] then
		CastX("��������")
	end
end

f["���Ҽ���"] = function()
	if v["����û����"] then
		--�����°�����
		if rela("�ж�") and dis() < 25 and cdtime("���Ҽ���") <= 0 then
			CastX("������")
		end
		CastX("���Ҽ���")
	end
end

-------------------------------------------------------------------------------

--��¼��Ϣ����־����
function PrintInfo(s)
	local t = {}
	if s then t[#t+1] = s end
	t[#t+1] = "����:"..v["����ʱ��"]
	t[#t+1] = "����CD:"..v["����CD"]
	t[#t+1] = "����CD"..v["����CD"]
	t[#t+1] = "��ӰCD:"..v["��ӰCD"]
	t[#t+1] = "����CD:"..v["����CD"]
	t[#t+1] = "����CD:"..v["����CD"]
	t[#t+1] = "������CD:"..v["������CD"]
	
	print(table.concat(t, ", "))
end

--ʹ�ü��ܲ���¼��Ϣ
function CastX(szSkill, bSelf)
	if cast(szSkill, bSelf) then
		settimer(szSkill)
		if v["��¼��Ϣ"] then PrintInfo() end
		return true
	end
	return false
end

-------------------------------------------------------------------------------

--�ͷż���
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		if SkillID == 546 then		--��Ӱ����
			deltimer("��Ӱ����")
			return
		end

		if SkillID == 34611 then	--���ࡤ��
			print("------------------------------", SkillName, SkillID, SkillLevel)
		end
	end
end
