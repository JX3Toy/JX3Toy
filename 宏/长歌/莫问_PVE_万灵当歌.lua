--[[ ��Ѩ: [�ɷ�][����][�ҷ�][����][����][ʦ��][ֹ֪][����][����][�ƺ�][����][���ɺ���]
�ؼ�:
�� 2���� 1�˺� 1����
�� 2���� 2�˺�
�� 2���� 2�˺�
�� 2���� 2�˺�
--]]

--�ر��Զ�����
setglobal("�Զ�����", false)

--��ѡ��
addopt("����������", false)

--������
local v = {}
v["��¼��Ϣ"] = true
v["�乬Ŀ��"] = 0

--������
local f = {}

--��ѭ��
function Main(g_player)
	--�����Զ����ݼ�1�ҷ�ҡ, ע���ǿ�ݼ��趨�������Ŀ�ݼ�1ָ���İ��������Ǽ����ϵ�1
	if keydown(1) then
		cast("��ҡֱ��")
	end

	if casting("��|�乬") and castleft() < 0.13 then
		settimer("����������")
	end
	if casting("��|����") and castleft() < 0.13 then
		settimer("���������")
	end

	--��ʼ������
	v["����ܴ���"] = cn(14067)		--��������ID
	v["�����ʱ��"] = cntime(14067, true)
	v["����ܴ���"] = cn("��")
	v["�����ʱ��"] = cntime("��", true)
	v["��Ӱ���ܴ���"] = cn("��Ӱ��б")
	v["��Ӱ����ʱ��"] = cntime("��Ӱ��б", true)
	v["��ӰCD"] = scdtime(14081)		--�ͻ�Ӱ������, ��ID
	v["����CD"] = scdtime("���ɺ���")
	v["�����ʱ��"] = casttime(14067)
	v["������ʱ��"] = casttime(14064)
	v["GCD���"] = cdinterval(16)

	v["��ɽ��ˮ"] = buff("9319")	--����������buff��������ID
	v["������ѩ"] = buff("9320")
	v["ƽɳ����"] = buff("9322")
	v["Ŀ����ʱ��"] = tbufftime("��", id())
	v["Ŀ���ʱ��"] = tbufftime("��", id())
	v["�������"] = buffsn("24327")
	v["����ʱ��"] = bufftime("����")
	v["�ҷ����"] = buffsn("�ҷ�")		--24247 ���5��
	v["�ҷ�ʱ��"] = bufftime("�ҷ�")
	v["���ղ���"] = buffsn("����")		--24754 ���32��
	v["����ʱ��"] = bufftime("����")
	v["�ƺ�����"] = buffsn("12576")
	v["�ƺ�ʱ��"] = bufftime("12576")
	v["֪������ʱ��"] = bufftime("֪������")
	v["Ӱ������"] = 0
	for i = 3, 8 do
		if buff("999"..i) then
			v["Ӱ������"] = v["Ӱ������"] + 1
		end
	end
	v["Ŀ��Ѫ���϶�"] = rela("�ж�") and tlifevalue() > lifemax() * 10	--Ŀ�굱ǰѪ�������Լ����Ѫ��10��, С�ֲ��뿪�����������ϵ��

	
	--���ָ�ɽ
	if nofight() and not v["��ɽ��ˮ"] and v["�������"] == 0 and v["����CD"] <= 0 then
		f["�л�����ɽ��ˮ"]()
	end

	--����������
	if getopt("����������") and dungeon() and nofight() then return end
	
	f["��Ӱ��˫��"]()

	f["��Ӱ��б"]()

	--�ȴ����ͷ�, �������ͬ��
	if gettimer("����������") < 0.5 then
		print("---------�ȴ��乬�ͷ�", frame())
		return
	end

	--�ȴ������л�
	if gettimer("�����л�") < 0.3 then
		print("---------�ȴ��л�����", frame())
		return
	end

	--ƽA��ս, ��ս����buffɾ��
	if nofight() then
		CastX("��������")
	end

	--����� + �� + ������
	v["dot�ж�ʱ��"] = v["�����ʱ��"] + v["GCD���"] + v["������ʱ��"] + 0.5

	if v["������ѩ"] then
		f["������ѩ��"]()
	
	elseif bufftime("���ɺ���") > 0 then
		f["���ɺ���"]()
	
	elseif v["��ɽ��ˮ"] then
		f["��ɽ��ˮ��"]()
	
	elseif v["ƽɳ����"] then
		f["ƽɳ������"]()
	end

	--û�ż��ܼ�¼��Ϣ�������Ų�����
	if fight() and rela("�ж�") and dis() < 20 and face() < 90 and cdleft(16) <= 0 and castleft() <= 0 and gettimer("��") > 0.5 and gettimer("�乬") > 0.5 and gettimer("��") > 0.5 and gettimer("����") > 0.5 and gettimer("���������") > 0.5 and state("վ��") then
		PrintInfo("---------- û�ż���")
	end
end

---------------------------------------------------------------------------------

f["���ɺ���"] = function()	--ǰ4�� 2, 3, 5, 6 ���, ����һ�α�Ϊ4
	if v["����CD"] > 59 then
		CastX(14229, true)	--��ɽ����, �͸�ɽ��ˮ��0.5��GCD, ǰ�����û�ų���
	end

	if v["�������"] == 6 then
		CastX("��")		-- +3
	end

	if v["�������"] == 5 then
		CastX("�乬")	-- +4
	end

	if v["�������"] == 4 then
		if buff("25957") then
			f["�л���������ѩ"]()
		else
			CastX("��")	-- +5
		end
	end

	if v["�������"] == 3 then
		CastX("����")	-- +6
	end

	if v["�������"] == 2 then
		CastX("��")		-- +2
	end

	--���������ߵ���, ���������·;��
	CastX("�乬")

end

f["��ɽ��ˮ��"] = function()
	--�������ɺ���, ��Ӱ -> ��ɽ���� -> ����
	if fight() and v["Ŀ��Ѫ���϶�"] and dis() < 20 and nobuff("���ɺ���") then	--v["�������"] <= 0
		if v["����ܴ���"] > 0 or cntime(14067) <= v["GCD���"] then
			if v["����CD"] < 0.5 then
				CastX(14081)		--��Ӱ��˫
				if v["��ӰCD"] > 1 then	--��Ӱ��
					CastX(14229, true)	--��ɽ����
					CastX("���ɺ���")
				end
				return	--������ȴ�˾ͱ��������
			end
		end
	end

	--�л���������ѩ
	if v["Ŀ����ʱ��"] > v["dot�ж�ʱ��"] and v["Ŀ���ʱ��"] > v["dot�ж�ʱ��"] then
		if gettimer("���ɺ���") > 0.5 and gettimer("��Ӱ��˫") > 0.5 then
			if v["�������"] == 0 or v["�������"] == 4 or v["�������"] == 5 then
				f["�л���������ѩ"]()
			end
		end
	end
	
	--�ȴ��乬�ͷź�Ŀ��buffˢ��
	if gettimer("�ͷű乬") < 0.5 and v["�乬Ŀ��"] ~= 0 and v["�乬Ŀ��"] == tid() then
		print("----------�乬��ȴ�Ŀ��buffˢ��", frame())
		return
	end
		
	if fight() and gettimer("���ɺ���") > 0.5 and gettimer("��Ӱ��˫") > 0.5 then
		if v["Ŀ����ʱ��"] <= v["������ʱ��"] or v["�������"] == 2 then	--��dot ������
			CastX("��")		-- +3
		end
		if v["Ŀ���ʱ��"] <= v["������ʱ��"] or v["�������"] == 3 then	--��dot ������
			CastX("��")		-- +2
		end

		if v["�������"] == 0 or v["�������"] == 1 or v["�������"] >= 5 then	--����5���ñ乬����
			CastX("�乬")	-- +4
		end

		if v["�������"] == 4 then
			CastX("��")		-- +5
		end
	end
end

f["������ѩ��"] = function()
	if v["Ŀ��Ѫ���϶�"] and dis() < 20 and v["����CD"] < v["GCD���"] and nobuff("���ɺ���") and v["����ܴ���"] > 0  then	--�и�ɽ, ������
		f["�л�����ɽ��ˮ"]()
	end

	if v["�������"] == 0 then
		if v["Ŀ����ʱ��"] < v["dot�ж�ʱ��"] or v["Ŀ���ʱ��"] < v["dot�ж�ʱ��"] then	--�и�ɽ, �乬ˢ��dot
			f["�л�����ɽ��ˮ"]()
		end

		if v["����CD"] <= v["�����ʱ��"] + v["GCD���"] and v["�����ʱ��"] > 13 then	--���ɿ���ȴ����ܲ��㣬�ȴ���
			CastX("��")
		end
		CastX("��")
		CastX("��")
	end

	if v["�������"] == 4 then
		CastX("��")		-- +5
	end

	if v["�������"] == 5 then
		CastX("��")		-- +4
	end

	--�������������Ӧ�þ��� 0 4 5 ����, ��ֹ�����ӳ��󴥵�����¼Ӹ�����ֹ�����ⲻ����
	CastX("��")		--+3
end

f["ƽɳ������"] = function()
	f["�л�����ɽ��ˮ"]()		--PVE����ƽɳ, ����ֶ��󴥽���ƽɳֱ���и�ɽ
end

f["�л���������ѩ"] = function()
	if CastX(14070) then	--������������ID
		settimer("�����л�")
		exit()
	end
end

f["�л�����ɽ��ˮ"] = function()
	if CastX(14069) then	--������������ID
		settimer("�����л�")
		exit()
	end
end

f["��Ӱ��˫��"] = function()
	if casting("��|����") and bufftime("��Ӱ��˫") < 0.5 then	--������� ʱ��쵽�ˣ����
		if fcast(14162) then
			settimer("��Ӱ��˫��")
		end
		return
	end

	if bufftime("��Ӱ��˫") <= v["������ʱ��"] then	--С��һ���乬����
		if cast(14162) then
			settimer("��Ӱ��˫��")
		end
		return
	end

	if scdtime(14229) > bufftime("��Ӱ��˫") and v["����CD"] > bufftime("��Ӱ��˫") then		--��ɽ�����������ù���
		if v["Ӱ������"] >= 6 or cn("��Ӱ��б") < 1 then	--Ӱ�����˻���Ӱ��б������
			if cast(14162) then
				settimer("��Ӱ��˫��")
			end
		end
	end
end

f["��Ӱ��б"] = function()
	if rela("�ж�") and v["Ӱ������"] < 6 then
		local bCast = false
		if gettimer("��Ӱ��˫��") > 0.5 and bufftime("��Ӱ��˫") > 0 then	--��Ӱ��
			bCast = true
		end
		if buff("���ɺ���") then	--������
			bCast = true
		end
		if v["��Ӱ���ܴ���"] >= 3 then	--��������
			bCast = true
		end
		if bCast then
			CastX("��Ӱ��б")
		end
	end
end

-------------------------------------------------------------------------------

--��¼��Ϣ
function PrintInfo(s)
	local t = {}
	if s then t[#t+1] = s end
	t[#t+1] = "Ŀ����:"..v["Ŀ����ʱ��"]
	t[#t+1] = "Ŀ���:"..v["Ŀ���ʱ��"]
	t[#t+1] = "�������:"..v["�������"]
	t[#t+1] = "����ʱ��:"..bufftime("���ɺ���")
	--t[#t+1] = "�ҷ�:"..v["�ҷ����"]..", "..v["�ҷ�ʱ��"]
	--t[#t+1] = "����:"..v["���ղ���"]..", "..v["����ʱ��"]
	t[#t+1] = "֪������:"..v["֪������ʱ��"]
	t[#t+1] = "Ӱ������:"..v["Ӱ������"]
	
	t[#t+1] = "��CD:"..v["����ܴ���"]..", "..v["�����ʱ��"]
	t[#t+1] = "��CD:"..v["����ܴ���"]..", "..v["�����ʱ��"]
	t[#t+1] = "��ӰCD:"..v["��Ӱ���ܴ���"]..", "..v["��Ӱ����ʱ��"]
	t[#t+1] = "����CD:"..v["����CD"]
	t[#t+1] = "��ӰCD:"..v["��ӰCD"]

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

--�ͷż��ܻص�
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		if SkillID == 18860 then	--�乬�Ӽ���
			v["�乬Ŀ��"] = TargetID	--�ͷ�ʱĿ��buff��ûˢ��, ��¼Ŀ��ID
			settimer("�ͷű乬")
			deltimer("����������")
		end

		if SkillID == 14474 then	--���Ӽ���
			deltimer("����������")
		end

		if SkillID == 34676 then	--֪���˾�, ��¼�ͷ���Ϣ, ���ڲ鿴�ǲ�����ߵȼ���21���˺����
			print("--------------------"..SkillName..", ����ID:"..SkillID..", ���ܵȼ�:"..SkillLevel..", Ŀ��ID:"..TargetID..", ��ʼ֡:"..StartFrame..", ��ǰ֡:"..FrameCount)
		end
	end
end

--buff���»ص�
function OnBuff(CharacterID, BuffName, BuffID, BuffLevel, StackNum, SkillSrcID, StartFrame, EndFrame, FrameCount)
	if CharacterID == id() and StackNum  > 0 then	--���Լ����buff
		if BuffID == 9319 or BuffID == 9320 or BuffID == 9322 then	--3����buff
			deltimer("�����л�")
		end

		if BuffID == 26001 then
			print("--------------------��������")
		end
	end
end

--buff�б���»ص�
function OnBuffList(CharacterID)
	if CharacterID == v["�乬Ŀ��"] then
		v["�乬Ŀ��"] = 0	--�ͷű乬��Ŀ��buffˢ����, ��0�����ȴ�
	end
end

--��¼ս��״̬
function OnFight(bFight)
	if bFight then
		print("--------------------����ս��")
	else
		print("--------------------�뿪ս��")
	end
end

--[[ ѭ��
���ɺ��� ��ȷ�������
��Ӱ��б [�ƺ�]���˸���֪������
Ŀ���̽ǲ���
�����ɺ���ʱѭ��  ���������� - �и�ɽ - �乬 - ������ - ����������
--]]
