--[[ ��Ѩ: [����][ѩ��][����][���][����][Ԩ��][����][���л�ת][�ٽ�][����][����][��·]
�ؼ�:
�Ǵ�	1���� 3�˺�
���	2��Ϣ 2�˺�
�ź��	3�˺� 1����
������	2��Ϣ 2�˺�
������	1���� 3�˺�
ն�޳�  2��Ϣ 2�˺�
Ѫ��	2��Ϣ 2����
��ڤ	1���� 2�˺� 1����

1�μ���, 3.5��������
��������Ҫ����Ŀ��3.5����, ��Ϊ�������º���8�߶�, ̫Զ�򲻵�
���º�, ���Ŀ��û��, �ǻ������ù�, �����������6-12��
��ľ׮����, ʵս���鲻�Ǻܺ�
--]]

--�ر��Զ�����
setglobal("�Զ�����", false)

--��ѡ��
addopt("����������", false)

--������
local v = {}
v["��¼��Ϣ"] = true

--������
local f = {}

--��ѭ��
function Main()
	--�����Զ����ݼ�1�ҷ�ҡ, ע���ǿ�ݼ��趨�������Ŀ�ݼ�1ָ���İ��������Ǽ����ϵ�1
	if keydown(1) then
		fcast("��ҡֱ��")
	end

	--��¼��������
	if casting("�ź��") and castleft() < 0.13 then
		settimer("�ź�Ķ�������")
	end
	if casting("������") and castleft() < 0.13 then
		settimer("�����Ƕ�������")
	end

	--��ʼ������
	local tSpeedXY, tSpeedZ = speed(tid())
	v["Ŀ�꾲ֹ"] = rela("�ж�") and tSpeedXY <= 0 and tSpeedZ <= 0
	v["GCD���"] = cdinterval(16)
	v["GCD"] = cdleft(16)
	v["���CD"] = scdtime("������")
	v["�ź�ĳ��ܴ���"] = cn("�ź��")
	v["�ź�ĳ���ʱ��"] = cntime("�ź��", true)
	v["�ź��CD"] = scdtime("�ź��")
	v["������CD"] = scdtime("������")
	v["������CD"] = scdtime("������")
	v["ն�޳�CD"] = scdtime("ն�޳�")
	v["Ѫ�����ܴ���"] = cn("Ѫ����Ȫ")
	v["Ѫ������ʱ��"] = cntime("Ѫ����Ȫ", true)
	v["����CD"] = scdtime("�����⹳")
	v["����CD"] = scdtime("���͹�")
	v["����CD"] = scdtime("���л�ת")
	v["�ź�Ķ���ʱ��"] = casttime("�ź��")
	v["�����Ƕ���ʱ��"] = casttime("������")
	v["ն�޳�����ʱ��"] = casttime("ն�޳�")

	v["Ŀ������ʱ��"] = tbufftime("����", id())
	v["��ǲ���"] = buffsn("26215")			--8��, 3��ʱ�ź�Ĵ�һ���˺�Ȼ��ɾ��
	v["���ʱ��"] = bufftime("26215")
	v["����ʱ��"] = bufftime("���͹�")	--buff 16596 ���Ļ�Ч����+15% ������6�� ����4����ͽ�����ɾ��, buff 24244 5�����������
	v["�ٽڲ���"] = buffsn("�ٽ�")			--6�� 3�� ʵ��Ч�� 15927 15928 15929, �Ӽ�����ն4�������˺� 10% 20% 30%
	v["�ٽ�ʱ��"] = bufftime("�ٽ�")
	v["����ʱ��"] = bufftime("����")		--10��, ����+25%
	v["����ʱ��"] = bufftime("����")		--10��, ���ӷ���+50%
	v["����������ʱ��"] = bufftime("24744")			--��·����������


	--Ŀ�겻�ǵ��� ֱ�ӽ���
	if not rela("�ж�") then return end

	--����������
	if getopt("����������") and dungeon() and nofight() then return end

	--�ȴ�״̬ͬ��
	if gettimer("�ź�Ķ�������") < 0.3 then
		--if cdleft(16) <= 0 then print("----------�ȴ��ź���ͷ�") end
		return
	end

	--�жϼ�������
	v["�ɷż���"] = false
	v["������Ҫʱ��"] = 0
	if v["�ٽ�ʱ��"] < v["�ź�Ķ���ʱ��"] then	--�������ˣ�����û�аٽ�
		if v["�ź�ĳ��ܴ���"] >= 3 and v["������CD"] <= v["�ź�Ķ���ʱ��"] * 3 then	--3�� + ��
			v["�ɷż���"] = "3�� + ��"
			v["������Ҫʱ��"] = v["�ź�Ķ���ʱ��"] * 3 + casttime("������")
		end
	else
		if v["�ź�ĳ��ܴ���"] + v["�ٽڲ���"] >= 3 then	--�ܴ�3�ٽ�
			if v["������CD"] <= (3 - v["�ٽڲ���"]) * v["�ź�Ķ���ʱ��"] then	--������CDС�ڴ�3�ٽ�ʱ��
				v["�ɷż���"] = format("%d�� + ��", 3 - v["�ٽڲ���"])
				v["������Ҫʱ��"] = v["�ź�Ķ���ʱ��"] * (3 - v["�ٽڲ���"]) + casttime("������")
			end
		end
	end

	--˫��ն�޳�����
	v["��ն�޳�"] = false
	if not v["�ɷż���"] and dis() < 4 and v["ն�޳�CD"] <= v["GCD"] then
		if v["�ź�ĳ���ʱ��"] > v["ն�޳�����ʱ��"] and v["�ٽ�ʱ��"] > v["ն�޳�����ʱ��"] + v["�ź�Ķ���ʱ��"] + 0.25 then
			v["��ն�޳�"] = true
		end
	end

	--��ն�޳�
	f["��ն"]()

	--�����⹳, ����� 0.5�� 8.75������, �����п���
	v["�ź�Ķ�������ʣ��"] = 0.625
	v["�ź�Ķ��������Ѷ�"] = v["�ź�Ķ���ʱ��"] - v["�ź�Ķ�������ʣ��"]
	if casting("�ź��") and castleft() <= v["�ź�Ķ�������ʣ��"] and dis() < 3.5 then
		--if v["�ٽ�ʱ��"] > castleft() + 0.1 and v["�ٽڲ���"] + v["�ź�ĳ��ܴ���"] >= 3 and v["������CD"] <= (3 - v["�ٽڲ���"]) * v["GCD���"] then
		if not v["��ն�޳�"] then
			if v["����ʱ��"] > 3 then
				aCastX("�����⹳")
			end
		end
	end

	--����������
	v["��������"] = false
	if (v["Ŀ�꾲ֹ"] or ttid() == id()) and dis() < 12 and face() < 90 then
		if v["GCD"] < 0.5 and v["������CD"] <= v["GCD"] then
			if v["�ٽڲ���"] >= 3 and v["�ٽ�ʱ��"] > v["�ź�Ķ���ʱ��"] + v["�����Ƕ���ʱ��"] + v["GCD"] + 0.3 then
				v["��������"] = true
			end
			
		end
	end

	if buff("����") or gettimer("Ѫ����Ȫ") < 0.3 then
		if gettimer("��ڤ����") > 0.3 then
			f["����"]()
		end
	end

	if nobuff("����") or gettimer("��ڤ����") < 0.3 then
		if gettimer("Ѫ����Ȫ") > 0.3 then
			f["˫��"]()
		end
	end

	--û�ż��ܼ�¼��Ϣ
	if fight() and rela("�ж�") and dis() < 12 and face() < 60 and cdleft(16) <= 0 and castleft() <= 0  and state("վ��|��·|�ܲ�|��Ծ") then
		if gettimer("��ڤ����") > 0.3 and gettimer("Ѫ����Ȫ") > 0.3 and gettimer("�ź��") > 0.3 and gettimer("�ź�Ķ�������") > 0.3 and gettimer("������") > 0.3 and gettimer("�����Ƕ�������") > 0.3 and gettimer("ն�޳�") > 0.3 then
			PrintInfo("---------- û�ż���")
		end
	end
end

-------------------------------------------------------------------------------

f["����"] = function()
	--����������
	if v["��������"] and dis() > 6 then
		if f["����"]("��������") then
			return
		end
	end

	--����ն�޳�
	v["�ƶ���������"] = keydown("MOVEFORWARD") or keydown("MOVEBACKWARD") or keydown("STRAFELEFT") or keydown("STRAFERIGHT") or keydown("JUMP")
	if not v["�ƶ���������"] and dis() < 4 and cdtime("ն�޳�") <= 0 then
		if v["����CD"] <= v["ն�޳�����ʱ��"] / 8 * 5 + v["�ź�Ķ��������Ѷ�"] then
			if v["�ٽ�ʱ��"] > v["ն�޳�����ʱ��"] / 8 * 5 + v["�ź�Ķ���ʱ��"] + 0.3 then
				if f["����"]("��ն�޳�") then
					CastX("ն�޳�")
				end
			end
		end
	end
	
	--n�� + ��
	if v["�ɷż���"] then
		if v["���CD"] > 0 or v["����ʱ��"] > v["������Ҫʱ��"] then
			if dis() < 12 and cdtime("�ź��") <= 0 and f["����"](v["�ɷż���"]) then
				CastX("�ź��")
				return
			end
		end
	end

	--�����żź�ı��ٽ�
	if v["�ٽ�ʱ��"] > v["�ź�Ķ���ʱ��"] and v["�ٽ�ʱ��"] < 2.5 then
		if dis() < 12 and cdtime("�ź��") <= 0 then
			if f["����"]("�żź�ı��ٽ�") then
				CastX("�ź��")
			end
		end
	end

	--��� + �Ǵ� + �����ź�� + ����
	if v["����CD"] < v["GCD���"] * 2 + v["�ź�Ķ��������Ѷ�"] then
		if v["Ŀ������ʱ��"] > 0 then
			CastX("������")
		end
	end

	--��� + �����ź�� + ն�޳� + �ź�� + ����
	if v["ն�޳�CD"] <= v["GCD���"] + v["�ź�Ķ���ʱ��"] then
		if v["����CD"] < v["GCD���"] + v["�ź�Ķ���ʱ��"] + v["ն�޳�����ʱ��"] + v["�ź�Ķ��������Ѷ�"] then
			if v["Ŀ������ʱ��"] > 0 then
				CastX("������")
			end
		end
	end

	--�Ǵ�
	if v["���CD"] > 0 and dis() < 6 and face() < 90 then
		if v["�ź�ĳ���ʱ��"] > v["GCD���"] + v["�ź�Ķ���ʱ��"] and v["�ٽ�ʱ��"] > v["GCD���"] + v["�ź�Ķ���ʱ��"] + 0.3 then
			CastX("�Ǵ�ƽҰ")
		end
	end

	--�����ź��
	if cdleft(16) <= 0 and dis() < 12 and cdtime("�ź��") <= 0 then
		if v["���CD"] > 0 or v["Ŀ������ʱ��"] > 0 then
			if f["����"]("�żź��") then
				CastX("�ź��")
			end
		end
	end
end


f["˫��"] = function()
	--������
	if dis() > 6 and dis() < 12 and face() < 90 and v["����CD"] > 20 then
		 if v["�ٽڲ���"] >= 3 and v["�ٽ�ʱ��"] > 0 and v["����ʱ��"] >= 0 and v["����ʱ��"] >= 0 then
			aCastX("������")
		 end
	end
	v["����"] = npc("��ϵ:�Լ�", "ģ��ID:107305")
	if v["����"] ~= 0 and xdis(v["����"]) < 12 then
		aCastX("������", 0, v["����"])
	end

	--���л�ת
	if dis() < 12 and v["�ٽ�ʱ��"] >= v["GCD���"] + v["�ź�Ķ���ʱ��"] + 0.5 then
		if v["����������ʱ��"] >= 0 and v["����ʱ��"] > 7 then
			if CastX("���л�ת") then
				aCastX("������")
			end
		end
	end

	--���͹�
	v["��+�Ҷ���ʱ��"] = v["�ź�Ķ���ʱ��"] + v["�����Ƕ���ʱ��"] + 0.3
	if (v["Ŀ�꾲ֹ"] or ttid() == id()) and dis() > 6 and dis() < 12 then
		if v["�ٽڲ���"] >= 2 and v["�ٽ�ʱ��"] > casttime("�ź��") and v["����ʱ��"] > v["��+�Ҷ���ʱ��"] and v["����ʱ��"] > v["��+�Ҷ���ʱ��"] then
			if cdtime("�ź��") <= 0 and cdtime("���͹�") <= 0 then
				CastX("���͹�")
				CastX("�ź��")
			end
		end

		if v["����ʱ��"] > v["�����Ƕ���ʱ��"] and v["����ʱ��"] > v["�����Ƕ���ʱ��"] then
			if v["�ٽڲ���"] >= 3 and v["�ٽ�ʱ��"] > v["�ź�Ķ���ʱ��"] + v["�����Ƕ���ʱ��"] + v["GCD"] then
				if v["GCD"] < 0.5 and v["�ź�ĳ���ʱ��"] > 5 then
					CastX("���͹�")
				end
			end
		end
	end

	--������
	if v["��������"] then
		if v["����ʱ��"] > v["�����Ƕ���ʱ��"] or gettimer("��ڤ����") < 0.3 then
			aCastX("������")
		end
		if v["����ʱ��"] <= v["�����Ƕ���ʱ��"] and gettimer("��ڤ����") > 0.3 then
			f["����"]("������������")
		end
	end

	--ն�޳�
	if v["��ն�޳�"] then
		CastX("ն�޳�")
	end

	--����
	if v["GCD"] < 0.5 and v["���CD"] <= v["GCD"] and v["����CD"] <= v["GCD"] + v["GCD���"] * 2 + v["�ź�Ķ��������Ѷ�"] then
		if v["�ٽ�ʱ��"] > v["GCD"] + v["GCD���"] * 2 + v["�ź�Ķ���ʱ��"] then
			f["����"]("��� + �Ǵ� + �����ź�� + ����")
		end
	end
	
	if v["GCD"] < 0.5 and v["���CD"] <= v["GCD"] then
		if v["ն�޳�CD"] <= v["GCD"] + v["GCD���"] + v["�ź�Ķ���ʱ��"] then
			if v["����CD"] <= v["GCD"] + v["GCD���"] + v["�ź�Ķ���ʱ��"] + v["ն�޳�����ʱ��"] + v["�ź�Ķ��������Ѷ�"] then
				if v["�ٽ�ʱ��"] > v["GCD"] + v["GCD���"] + v["�ź�Ķ���ʱ��"] then
					f["����"]("��� + �����ź�� + ն�޳� + �ź�� + ����")
				end
			end
		end
	end

	--�ź��
	if v["�ź�ĳ��ܴ���"] >= 3 then	--����
		if CastX("�ź��") then
			print("���ּź��")
		end
	end

	if dis() < 12 and v["GCD"] < 0.5 and v["�ź��CD"] <= v["GCD"] then
		if v["����ʱ��"] <= v["�ź�Ķ���ʱ��"] then
			f["����"]("�ź��������")
		end
		CastX("�ź��")
	end
end

f["��ն"] = function()
	local szBreakReason = nil
	if casting("ն�޳�") then
		v["6���ڵ���"] = npc("��ϵ:�ж�", "��ѡ��", "����<6")
		if v["6���ڵ���"] == 0 then
			szBreakReason = "6����û����"
		end
		if v["����������ʱ��"] >= 0 then
			if v["�ź�ĳ��ܴ���"] >= 1 and v["�ٽ�ʱ��"] > v["�ź�Ķ���ʱ��"] and v["�ٽ�ʱ��"] < v["�ź�Ķ���ʱ��"] + 0.3 then
				szBreakReason = "���ٽ�"
			end
			if v["����CD"] <= v["�ź�Ķ���ʱ��"] and v["�ź�ĳ��ܴ���"] >= 2 then
				szBreakReason = "�ŷ���"
			end
		end
	end

	if szBreakReason then
		stopcasting()
		PrintInfo("--��ն�޳�:"..szBreakReason)
	end
end

f["����"] = function(szReason)
	if gettimer("Ѫ����Ȫ") > 0.3 and CastX("Ѫ����Ȫ") then
		print("-------------------- ����:"..szReason, frame())
		exit()
	end
end

f["����"] = function(szReason)
	if gettimer("��ڤ����") > 0.3 and CastX("��ڤ����") then
		print("-------------------- ����:"..szReason, frame())
		return true
	end
	return false
end

-------------------------------------------------------------------------------

--��¼��Ϣ
function PrintInfo(s)
	local t = {}
	if s then t[#t+1] = s end
	
	--t[#t+1] = "Ŀ������:"..v["Ŀ������ʱ��"]
	t[#t+1] = "�ٽ�:"..v["�ٽڲ���"]..", "..v["�ٽ�ʱ��"]
	t[#t+1] = "����:"..v["����ʱ��"]
	t[#t+1] = "����:"..v["����ʱ��"]
	t[#t+1] = "����:"..v["����ʱ��"]
	t[#t+1] = "���:"..v["��ǲ���"]..", "..v["���ʱ��"]

	t[#t+1] = "�ź��CD:"..v["�ź�ĳ��ܴ���"]..", "..v["�ź�ĳ���ʱ��"]
	t[#t+1] = "������CD:"..v["������CD"]
	t[#t+1] = "����CD:"..v["����CD"]
	t[#t+1] = "���CD:"..v["���CD"]
	t[#t+1] = "����CD:"..v["����CD"]
	t[#t+1] = "ն�޳�CD:"..v["ն�޳�CD"]
	t[#t+1] = "����CD:"..v["����CD"]
	t[#t+1] = "������CD:"..v["������CD"]
	--t[#t+1] = "Ѫ��CD:"..v["Ѫ�����ܴ���"]..", "..v["Ѫ������ʱ��"]
	t[#t+1] = "����������:"..v["����������ʱ��"]
	t[#t+1] = "����:"..format("%.1f", dis())
	t[#t+1] = "GCD:"..v["GCD"]
	
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

function aCastX(szSkill)
	if acast(szSkill) then
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
		if BuffID == 15524 then		--����
			deltimer("Ѫ����Ȫ")
			deltimer("��ڤ����")
		end
		if BuffID == 26215 then	--�ź�ķ�Ǽ���
			if StackNum  > 0 then
				deltimer("�ź�Ķ�������")
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
