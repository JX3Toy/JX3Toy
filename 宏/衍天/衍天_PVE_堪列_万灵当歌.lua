--[[ ��Ѩ: [ˮӯ][����][˳ף][������][��ɽ][����][ب��][����][ӫ���][����][����][����]
�ؼ�:
������		1���� 3�˺�
������		1���� 3�˺�
�춷��		1��Ϣ 1���� 2�˺�
����		2��Ϣ 1���� 1Ч��
����		1��Ϣ 3������
���ŷɹ�	2��Ϣ 2����
���վ���	2��Ϣ 1���� 1Ч��(���ӳ�10��, ����)
--]]

--�ر��Զ�����
setglobal("�Զ�����", false)

--��ѡ��
addopt("����������", false)

--������
local v = {}
v["��¼��Ϣ"] = true
v["�������ӳ��������"] = 0

--������
local f = {}

--��ѭ��
function Main(g_player)
	--�����Զ����ݼ�1�ҷ�ҡ, ע���ǿ�ݼ��趨�������Ŀ�ݼ�1ָ���İ��������Ǽ����ϵ�1
	if keydown(1) then
		cast("��ҡֱ��")
	end

	--�ȴ������濪ʼ����, ��������Ӽ��ܲ�����������, ����˲��������
	if gettimer("������") < 0.3 then return end

	--����
	if fight() and life() < 0.6 then
		cast("���ű���")
	end

	--��ʼ������
	v["����"] = rage()

	v["������"] = 0
	for i = 1, 3 do
		v["��"..i.."ʱ��"] = bufftime("1774"..i + 2)	--17743 17744 17745
		if v["��"..i.."ʱ��"] >= 0 then
			v["������"] = v["������"] + 1
		end
	end
	v["������"] = buff("18231")
	v["����ʱ��"] = math.min(v["��1ʱ��"], v["��2ʱ��"], v["��3ʱ��"])	--��̵�ʱ���������ʣ��ʱ��

	local tDeng = { 99569, 100085, 100086 }		--��123 ģ��ID
	for i, nID in ipairs(tDeng) do			--��ȡ��ǿ������
		v["��"..i.."����"] = 0
		local deng = npc("��ϵ:�Լ�", "ģ��ID:"..nID)
		if deng ~= 0 then
			v["��"..i.."����"] = xbuffsn("24480", deng)
		end
	end

	v["����"] = "����"
	v["����ʱ��"] = -100
	local tGX = { "ˮ��", "ɽ��", "����" }
	for i, szBuff in ipairs(tGX) do
		v[szBuff.."ʱ��"] = bufftime(szBuff)
		if v[szBuff.."ʱ��"] >= 0 then
			v["����"] = szBuff
			v["����ʱ��"] = v[szBuff.."ʱ��"]
		end
	end
	v["ӫ���ʱ��"] = bufftime("ӫ���")	--��ÿ���ӳ� ���� ���� ���� ӫ���
	v["Ŀ�����ʱ��"] = tbufftime("17605", id())
	v["Ŀ����������"] = tbuffsn("����", id())
	v["Ŀ������ʱ��"] = tbufftime("����", id())
	v["�����м���"] = buffsn("24457")	--���5��

	v["����CD"] = scdtime("����")
	v["���Գ��ܴ���"] = cn("����")
	v["���Գ���ʱ��"] = cntime("����", true)
	v["������CD"] = scdtime("������")
	v["�춷�����ܴ���"] = cn("�춷��")
	v["�춷������ʱ��"] = cntime("�춷��", true)
	v["����CD"] = scdtime("���վ���")

	local tSpeedXY, tSpeedZ = speed(tid())
	v["Ŀ�꾲ֹ"] = rela("�ж�") and tSpeedXY <= 0 and tSpeedZ <= 0

	--Ŀ�겻�ǵ���, ֱ�ӽ���
	if not rela("�ж�") then return end

	--����������
	if getopt("����������") and dungeon() and nofight() then return end

	f["�����"]()

	--ƽA��ս
	if nofight() then
		CastX("���")
		return
	end

	f["��������"]()
	f["���־�"]()
	

	--if fight() and rela("�ж�") and dis() < 20 and face() < 90 and cdleft(16) <= 0 and castleft() <= 0 and gettimer("�춷��") > 0.3 and state("վ��|��·|�ܲ�|��Ծ") then
	--	PrintInfo("----------û����")
	--end
end

-------------------------------------------------------------------------------

f["�����"] = function()
	--�ŵ�
	if v["������"] < 3 then
		if v["������"] < 2 or gettimer("���վ���") > 0.3 then
			CastX("���ŷɹ�")
		end
		if v["������"] < 2 or gettimer("���ŷɹ�") > 0.3 then
			CastX("���վ���")
		end
	end

	--���ù����µ�
	if buff("24656") and gettimer("���ŷɹ�") > 0.3 and gettimer("���ŷɹ�") > 0.3 and gettimer("���ɻ��") > 5 then
		CastX("���ŷɹ�")
	end

	--������ʱ��
	if v["������"] >= 3 and v["����ʱ��"] < 2 then
		if nobuff("24656") and gettimer("������") >= 0.5 and v["��1����"] >= 3 and v["��2����"] >= 3 and v["��3����"] >= 3 then
			CastX("���վ���")
		end
	end

	--�Ƶ�
	if v["Ŀ�꾲ֹ"] and dis() < 20 and gettimer("���ŷɹ�") > 0.3 and gettimer("���ɻ��") > 0.3 then
		if tnpc("��ϵ:�Լ�", "ģ��ID:99569|100085|100086", "ƽ�����<5") == 0 then	--Ŀ��5����û���Լ��ĵ�
			local tSkillID = { 24858, 24859, 24860 }	--��123��Ӧ���ݺ����ż���ID
			local nIndex = 0
			local nTime = 0
			for i = 1, 3 do
				if v["��"..i.."ʱ��"] > nTime then	--ʣ��ʱ����ĵ�
					nTime = v["��"..i.."ʱ��"]
					nIndex = i
				end
			end
			if nTime > 5 then
				cast(tSkillID[nIndex])
			end
		end
	end
end

f["��������"] = function()
	
	--����ͬ��
	if gettimer("����") < 0.3 or gettimer("����") < 0.3 or gettimer("ף�ɡ�����") < 0.3 then
		print("----------�ȴ�����ͬ��")
		return
	end

	v["Ŀ��û����"] = false
	if rela("�ж�") and dis() < 25 and v["Ŀ�����ʱ��"] < 0 and gettimer("ף�ɡ�����") >= 0.5 then
		v["Ŀ��û����"] = true
	end

	--����
	v["��Ҫ����"] = false

	--ˮ
	if v["ˮ��ʱ��"] >= 0 then
		if gettimer("ף�ɡ�ˮ��") > 0.3 then
			CastX("ף�ɡ�ˮ��", true)	--�������Լ�
		end
		v["��Ҫ����"] = "ˮ���"
	end
	
	--ɽ
	if v["ɽ��ʱ��"] >= 0 then
		if gettimer("ף�ɡ�ɽ��") > 0.3 then
			CastX("ף�ɡ�ɽ��")
		end

		if v["Ŀ��û����"] then
			v["��Ҫ����"] = "ɽ�����dot"
		end
	end

	--��
	if v["����ʱ��"] >= 0 then
		--������
		if gettimer("ף�ɡ�����") > 0.3 then
			local bCast = false
			if v["Ŀ�����ʱ��"] < 0 then	--Ŀ��û����
				bCast = true
			end
			if v["����CD"] < 0.25 then		---�������Ϻ�
				bCast = true
			end
			if v["����CD"] > 8 and v["���Գ��ܴ���"] > 0 then	--�ܱ�ɽ
				bCast = true
			end
			if bCast then
				CastX("ף�ɡ�����")
			end
		end
		
		--�Ź���������
		if nobuff("17825") and v["����CD"] > 7.5 then
			v["��Ҫ����"] = "���ɽ, �Ź�����"
		end
	end

	if v["��Ҫ����"] and gettimer("����") >= 0.5 and gettimer("�ͷ�����") > 3 then
		if CastX("����") then
			print(v["��Ҫ����"])
			exit()
		end
	end

	--����
	v["��Ҫ����"] = false

	if fight() then
		if v["�����м���"] < 1 then
			v["��Ҫ����"] = "���в���С��1"
		elseif v["ˮ��ʱ��"] >= 0 then
			v["��Ҫ����"] = "ˮ��ֱ����"
		elseif v["����ʱ��"] >= 0 and nobuff("17825") then
			v["��Ҫ����"] = "�������������"
		elseif rela("�ж�") and v["Ŀ�����ʱ��"] < 3 then
			v["��Ҫ����"] = "Ŀ�����С��3��"
		end
	end

	if v["��Ҫ����"] then
		if CastX("����") then
			print(v["��Ҫ����"])
			exit()
		end
	end
end

f["���־�"] = function()
	--�������ðѶ�����
	if v["��1����"] >= 4 and v["��2����"] >= 4 and v["��3����"] >= 4 and v["����ʱ��"] > 3.5 then
		CastX("�춷��")
		CastX("������")
	end

	if v["����"] >= 70 or not v["��Ҫ����"] then
		if v["������"] >= 3 or cn("���ŷɹ�") < 1 then
			CastX("������")
		end
	end

	if v["�����м���"] > 0 then
		CastX("�춷��")
	end

	if v["�춷������ʱ��"] < 3.5 then
		CastX("�춷��")
	end

	if v["������"] < 3 or v["����ʱ��"] > 5 then
		CastX("������")
	end

	CastX("�춷��")

	CastX("������")
end

-------------------------------------------------------------------------------

--��¼��Ϣ
function PrintInfo(s)
	local t = {}
	if s then t[#t+1] = s end
	t[#t+1] = "����:"..v["����"]
	t[#t+1] = "������:"..v["������"]
	t[#t+1] = "����ʱ��:"..v["����ʱ��"]
	t[#t+1] = "��ǿ��:"..v["��1����"]..", "..v["��2����"]..", "..v["��3����"]
	t[#t+1] = "����:"..v["����"]..", "..v["����ʱ��"]
	t[#t+1] = "ӫ���:"..v["ӫ���ʱ��"]
	t[#t+1] = "����:"..v["Ŀ�����ʱ��"]
	t[#t+1] = "����:"..v["Ŀ����������"]..", "..v["Ŀ������ʱ��"]
	t[#t+1] = "������:"..v["�����м���"]
	t[#t+1] = "����CD:"..v["����CD"]
	t[#t+1] = "����CD:"..v["���Գ��ܴ���"]..", "..v["���Գ���ʱ��"]
	t[#t+1] = "������CD:"..v["������CD"]
	t[#t+1] = "�춷��CD:"..v["�춷�����ܴ���"]..", "..v["�춷������ʱ��"]
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

--�����ͷ�
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		if SkillID == 24831 then	--ˮ
			settimer("����_ˮ��")
			print("----------����_ˮ��")
			return
		end
		if SkillID == 24832 then	--ɽ
			settimer("����_ɽ��")
			print("----------����_ɽ��")
			return
		end
		if SkillID == 24833 then	--��
			settimer("����_����")
			print("----------����_����")
			return
		end
		if SkillID == 24375 then	--����
			deltimer("����")
			settimer("�ͷ�����")
			return
		end
		if SkillID == 24378 then	--�ŵ�
			settimer("�ͷ����ŷɹ�")
			return
		end
		if SkillID == 32791 then	--������
			deltimer("������")
			return
		end
		if SkillID == 24410 or SkillID == 24744 or SkillID == 24745 then 	--������ ˮ ɽ ��
			v["�������ӳ��������"] = v["�������ӳ��������"] + 1
			return
		end
	end
end

--��ʼ����
function OnChannel(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, Frame, StartFrame, FrameCount)
	if CasterID == id() then
		if SkillID == 24409 or SkillID == 24410 or SkillID == 24744 or SkillID == 24745 then	--�����������Ӽ���, ���Ժ�3������
			deltimer("������")
		end
	end
end

--buff����
function OnBuff(CharacterID, BuffName, BuffID, BuffLevel, StackNum, SkillSrcID, StartFrame, EndFrame, FrameCount)
	if CharacterID == id() then
		if StackNum  > 0 then
			if BuffID == 17588 or BuffID == 17801 or BuffID == 17802 then	--3������buff
				deltimer("����_ˮ��")
				deltimer("����_ɽ��")
				deltimer("����_����")
				deltimer("����")
				deltimer("�ͷ�����")
				v["�������ӳ��������"] = 0
			end

			if BuffID == 17743 or BuffID == 17744 or BuffID == 17745 then	--3����buff
				settimer("���ɻ��")
				deltimer("���ŷɹ�")
				deltimer("���վ���")
			end

			if BuffID == 24656 then
				print("------------------------------ �ָ���, ����������")
			end
		else
			if BuffID == 17825 then	--������buff
				deltimer("ף�ɡ�����")
			end
		end
	end
end

--��¼ս��״̬�ı�
function OnFight(bFight)
	if bFight then
		print("--------------------����ս��")
	else
		print("--------------------�뿪ս��")
	end
end
