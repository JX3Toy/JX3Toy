--[[ ��Ѩ: [����][����][���][����][��ħ�ɶ�][���ŭĿ][����][����][����][��ִ][�������][��ں]
�ؼ�: 
�ն�  2��Ϣ 2�˺�
Τ��  1���� 2�˺� 1Ч��
��ɨ  1�˺� 1���� 1���� 1Ŀ�����
����  2��Ϣ 2�˺�
��ȱ  1���� 3�˺�
����  1Ч�� 3�˺�

ÿ��ǧ��׹֮��������һ�㣬��Ŀ��3������
--]]

setglobal("�Զ�����", false)

addopt("����������", false)

local v = {}
v["����������"] = false

local f = {}

function Main(g_player)
	-- �����Զ����ݼ�1�ҷ�ҡ
	if keydown(1) then
		cast("��ҡֱ��")
	end

	if fight() and life() < 0.5 then
		cast("�����")
	end

	if nobuff("������") and nofight() then
		cast("������", true)
	end
	
	if nobuff("��ħ") then
		cast("��ҵ��Ե", true)
	end

	if buff("25882") then
		cbuff("25882")
	end
	
	if not rela("�ж�") then return end

	if getopt("����������") and dungeon() and nofight() then return end

	if gettimer("�ȴ�����ͬ��") < 0.3 then return end
	
	if qidian() > 2 and dis() < 6 then
		CastX("�޺�����")
	end
	
	f["��ɨ����"]()
	
	f["ǧ��׹"]()
	
	f["���"]()
	
	if fight() and buffsn("̰��") >= 2 and buffsn("24454") < 3 then
		cast("�͹Ǿ�")
	end
	
	if buff("����") and qidian() > 2 and buff("�������") then
		CastX("����ʽ")
	end
	
	if buff("����") and qidian() > 2 and nobuff("�������") and scdtime("ǧ��׹") >= 14 and bufftime("23069", id()) <= 0 and bufftime("23070", id()) <= 0 then
		CastX("����ʽ")
	end

	if qidian() > 2 and nobuff("����") then
		CastX("Τ������")
	end
	
	if (cdleft(16) > 0.5 or dis() > 8) and qidian() < 2 and buff("����ʽ") and dis() > 4 then
		CastX("׽Ӱʽ")
	end
	
	CastX("��ȱʽ")
	
	if buff("�������") and qidian() < 3 then
		CastX("����ʽ")
	end
	
	if qidian() < 2 and nobuff("������") then
		CastX("Ħڭ����")
	end
	
	if qidian() < 3 and nobuff("������") and (nobuff("21617") or scdtime("ǧ��׹") <= cdinterval(16) or bufftime("23069", id()) > 0 or bufftime("23070", id()) > 0) then
		CastX("�ն��ķ�")
	end
end

-------------------------------------------------------------------------------

CastX = function(szSkill)
	if cast(szSkill) then
		settimer("�ȴ�����ͬ��")
		exit()
	end
end

f["ǧ��׹"] = function()
	if face() < 60 and nobuff("�������") then
		CastX("ǧ��׹")
	end
	if face() < 60 and dis() < 8 and scdtime("�޺�����") > 0 and scdtime("��ɨ����") <= cdinterval(16) then
		CastX("ǧ��׹")
	end
end

f["���"] = function()
	if dis() > 5.5 then return end

	v["���������"] = npc("��ϵ:�Լ�", "ģ��ID:107539", "����<8")
	v["���ڵ�������"] = 0
	if v["���������"] ~= 0 then
		_, v["���ڵ�������"] = xnpc(v["���������"], "��ϵ:�ж�", "����<8", "��ѡ��")
	end
	
	if v["���ڵ�������"] > 0 and bufftime("23069", id()) > 0 and bufftime("23069", id()) < 1.5 and nobuff("21617") and qidian() < 3 and cdleft(16) <= 0 then
		if cast("�ն��ķ�") then
			CastX("ǧ��׹����ȡ")
		end
	end
	
	if v["���ڵ�������"] > 0 and bufftime("23069", id()) > 0 and bufftime("23069", id()) < 1.5 then
		CastX("ǧ��׹����ȡ")
	end
	
	if v["����������"] and bufftime("23069", id()) > 0 then
		CastX("ǧ��׹����ȡ")
	end
	
	if v["���������"] <= 0 and gettimer("ǧ��׹") > 1.5 and bufftime("23069", id()) > 0 then
		CastX("ǧ��׹����ȡ")
	end
	
	if v["���ڵ�������"] > 0 and bufftime("23070", id()) > 0 and bufftime("23070", id()) < 1.5 then
		CastX("ǧ��׹������")
	end
	
	if v["����������"] and bufftime("23070", id()) > 0 then
		CastX("ǧ��׹������")
	end
	
	if v["���������"] <= 0 and gettimer("ǧ��׹����ȡ") > 1.5 and bufftime("23070", id()) > 0 then
		CastX("ǧ��׹������")
	end
end

f["��ɨ����"] = function()
	if dis() > 5.5 then return end
	
	if cdtime("��ɨ����") > 0 then
		return
	end
	
	if bufftime("�޺�����", id()) <= 6 then
		return
	end
	
	if buff("21616") and buff("�������") and (scdtime("ǧ��׹") <= cdinterval(16) or bufftime("23069", id()) > 0 or bufftime("23070", id()) > 0) then
		if scdtime("������") > 0 then
			CastX("��ɨ����")
		end
		
		if scdtime("������") <= 0 then
			CastX("������")
		end
	end
	
	if buff("21616") and nobuff("�������") and scdtime("ǧ��׹") >= 14 and bufftime("23069", id()) <= 0 and bufftime("23070", id()) <= 0 then
		CastX("��ɨ����")
	end
	
	if nobuff("21616") and buff("�������") then
		if scdtime("������") > 0 then
			CastX("��ɨ����")
		end
		
		if scdtime("������") <= 0 then
			CastX("������")
		end
	end
	
	if nobuff("21616") and nobuff("�������") and scdtime("ǧ��׹") >= 14 and bufftime("23069", id()) <= 0 and bufftime("23070", id()) <= 0 then
		CastX("��ɨ����")
	end
end

-------------------------------------------------------------------------------

function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		if SkillName == "�������" then
			v["����������"] = true
			settimer("�������")
			return
		end
		
		if SkillName == "ǧ��׹" then
			v["����������"] = false
			settimer("ǧ��׹")
			return
		end
		
		if SkillName == "ǧ��׹����ȡ" then
			v["����������"] = false
			settimer("ǧ��׹����ȡ")
			return
		end
	end
end

--�������
function OnQidianUpdate()
	deltimer("�ȴ�����ͬ��")
end
