--[[ ��Ѩ: [��������][ǧ���޺�][����ҹ��][����][��籩��][�۾�����][��һ����][�滨����][���ɢӰ][��������][��������][����׷��]
�ؼ�:
����  1���� 2�˺� 1����(����)
����  2���� 1�˺� 1����
׷��  2��Ϣ 2Ч��(����20%��� �˺����20$)
����  1Ч��(10���) 3�˺�
����  2��Ϣ 1�˺� 1����

�Ƽ�1������, �޷���������10����ĳ��� [���ɢӰ] ���� [����֮��]
--]]

--�ر��Զ�����
setglobal("�Զ�����", false)

--��ѡ��
addopt("����������", false)

--������
local v = {}
v["��¼��Ϣ"] = true
v["����Ŀ��"] = 0

--������
local f = {}

--��ѭ��
function Main(g_player)
	-- �����Զ����ݼ�1����ҡ
	if keydown(1) then
		cast("��ҡֱ��")
	end

	--����
	if fight() and life() < 0.5 then
		cast("��������")
	end
	
	--�ȴ����������ͷ� buffͬ��
	if casting("�����滨��") and castleft() < 0.13 then
		settimer("�����������")
	end
	if gettimer("�����������") < 0.5 then return end

	if casting("������") and castleft() < 0.13 then
		settimer("�������������")
	end

	--��ʼ������
	v["���ֵ"] = energy()
	local speedXY, speedZ = speed(tid())
	v["Ŀ�꾲ֹ"] = rela("�ж�") and speedXY <= 0 and speedZ <= 0
	v["Ŀ��Ѫ���϶�"] = rela("�ж�") and (target("boss") or tlifevalue() > lifemax() * 10)

	v["GCD���"] = cdinterval(16)
	v["������ܴ���"] = cn("�����滨��")
	v["�������ʱ��"] = cntime("�����滨��", true)
	v["׷��CD"] = scdtime("׷����")
	v["���ǳ��ܴ���"] = cn("���Ǽ�")
	v["���ǳ���ʱ��"] = cntime("���Ǽ�", true)
	v["���ĳ��ܴ���"] = cn("������")
	v["���ĳ���ʱ��"] = cntime("������", true)
	v["����CD"] = scdtime("��������")
	v["����CD"] = scdtime("����׷��")
	
	v["��������"] = buffsn("����")
	v["Ŀ�괩�Ĳ���"] = tbuffsn("����", id())
	v["Ŀ�괩��ʱ��"] = tbufftime("����", id())
	v["����ʱ��"] = bufftime("��������")
	v["ע�ܱ��"] = bufflv("26055")			--����ϴδ����ע�ܼ���
	v["����ʱ��"] = bufftime("����")		--[ǧ���޺�] ������������, ����+20% 15��
	v["�������"] = buffsn("��������")
	v["����ʱ��"] = bufftime("��������")
	
	--Ŀ�겻�ǵ��� ֱ�ӽ���
	if not rela("�ж�") then return end

	--����������
	if getopt("����������") and dungeon() and nofight() then return end

	--����buff
	if buff("3487") and tbuffsn("�Ƕ�����", id()) < 3 then
		CastX("���Ǽ�")
	end

	--������ ��dot
	if v["Ŀ�괩��ʱ��"] <= casttime("�����滨��") + v["GCD���"] + 0.5 then
		f["������"]()
	end

	--�������
	if casting("����׷��") and v["����Ŀ��"] ~= 0 then
		local speedXY, speedZ = speed(v["����Ŀ��"])
		if speedXY > 0 or speedZ > 0 then	--Ŀ�궯�˴����
			CastX(18673)
		end
	end

	--����һ��
	if v["Ŀ�꾲ֹ"] and buff("����") then
		if CastX(18672) then
			v["����Ŀ��"] = tid()	--��¼һ��Ŀ��
		end
	end

	--׷����
	if buff("׷������") and v["����ʱ��"] >= 0 and v["ע�ܱ��"] ~= 1 then
		CastX("׷����")
	end

	--���Ǽ�
	if v["�������"] >= 2 then	--�������
		f["���Ǽ�"]()
	end

	--�����滨��
	v["�ƶ���������"] = keydown("MOVEFORWARD") or keydown("MOVEBACKWARD") or keydown("STRAFELEFT") or keydown("STRAFERIGHT") or keydown("JUMP")
	if not v["�ƶ���������"] and v["ע�ܱ��"] ~= 6 then
		--��������
		if v["Ŀ��Ѫ���϶�"] and dis() < 23 then
			if cdtime("�����滨��") <= 0 and v["���ֵ"] >= 50 and v["����CD"] < 16 then	--����ǰ
				CastX("��������")
			end
		end
		CastX("�����滨��")
	end

	--���Ǵ��ľ�������1��
	if v["׷��CD"] > v["GCD���"] + 1 + casttime("�����滨��") and v["��������"] == 0 then
		f["���Ǽ�"]()
	end

	if v["���ֵ"] >= 60 then
		f["������"]()
	end

	if bufftime("׷������") > 1 and v["����ʱ��"] > 1 and v["׷��CD"] < 0.5 then
		--��׷��
	else
		f["���Ǽ�"]()
	end
	
	--û�ż��ܼ�¼��Ϣ
	if casting("����׷��") and castleft() < 0.13 then
		settimer("�����������")
	end
	if fight() and dis() < 25 and state("վ��") and cdleft(16) <= 0 and castleft() <= 0 and gettimer("������") > 0.3 and gettimer("�����滨��") > 0.3 and gettimer(18672) > 0.3 and gettimer("�����������") > 0.3 then
		PrintInfo("----------û�ż���")
	end
end

-------------------------------------------------------------------------------

f["������"] = function()
	if gettimer("�������������") > 0.3 and v["ע�ܱ��"] ~= 4 then
		CastX("������")
	end
end

f["���Ǽ�"] = function()
	if v["����ʱ��"] >= 0 and v["ע�ܱ��"] ~= 3 then
		CastX("���Ǽ�")
	end
end

-------------------------------------------------------------------------------

--��¼��Ϣ
function PrintInfo(s)
	local t = {}
	if s then t[#t+1] = s end
	t[#t+1] = "���ֵ:"..v["���ֵ"]
	t[#t+1] = "����:"..v["��������"]
	t[#t+1] = "����:"..v["Ŀ�괩�Ĳ���"]..", "..v["Ŀ�괩��ʱ��"]
	t[#t+1] = "����:"..v["����ʱ��"]
	t[#t+1] = "ע��:"..v["ע�ܱ��"]
	--t[#t+1] = "����:"..v["����ʱ��"]
	t[#t+1] = "����:"..v["�������"]..", "..v["����ʱ��"]
	t[#t+1] = "����CD:"..v["������ܴ���"]..", "..v["�������ʱ��"]
	t[#t+1] = "׷��CD:"..v["׷��CD"]
	t[#t+1] = "����CD:"..v["���ǳ��ܴ���"]..", "..v["���ǳ���ʱ��"]
	t[#t+1] = "����CD:"..v["���ĳ��ܴ���"]..", "..v["���ĳ���ʱ��"]
	t[#t+1] = "����CD:"..v["����CD"]
	t[#t+1] = "����CD:"..v["����CD"]
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

--buff����
function OnBuff(CharacterID, BuffName, BuffID, BuffLevel, StackNum, SkillSrcID, StartFrame, EndFrame, FrameCount)
	if CharacterID == id() then
		if StackNum > 0 then
			if BuffID == 7659 then	--����
				deltimer("�����������")
			end
			if BuffID == 26055 then
				if BuffLevel == 4 then
					deltimer("�������������")
				end
				if BuffLevel == 5 then
					deltimer("���Ƕ�������")
				end
			end
		end
	end
end

--��¼ս��״̬�ı�
function OnFight(bFight)
	if gettimer("��ս��ս") > 5 then
		settimer("��ս��ս")
		if bFight then
			print("--------------------����ս��")
		else
			print("--------------------�뿪ս��")
		end
	end
end

--[[ ����
--ע�ܱ��buff 26055 ��Ӧ�ȼ�
local tZhuNeng = {
["׷����"] = 1,
["��ʯ��"] = 2,
["���Ǽ�"] = 3,
["������"] = 4,
["���Ǽ�"] = 5,
["�����滨��"] = 6,
["��ȸ��"] = 7,
["����׷��"] = 8,
}
--]]
