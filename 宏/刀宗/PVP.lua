output("��Ѩ: [Ԩ��][Ϯ��][����][����][����][����][���][ʶ��][����][����][ب��][��ԯ]")

--[[�ؼ�
���� 1����2�˺�1����
ͣ�� 1����2�˺�1����1CD
���� 2Ч��2�˺�
���� 1����2�˺�1����
���� 2�˺�2����

�۷� 2CD2Ч��
�η� 2CD2����

���� 1����3�˺�
���� 1����2�˺�1����(1���)
�·� 2����2�˺�

���� 1����2�˺�1����
��ʯ 2CD1Ч��1�˺�
--]]


--�����
load("Macro/Lib_PVP.lua")

--������
local v = {}
v["�ȴ���˫�л�"] = false

--������
local f = {}

--��ѭ��
function Main(g_player)
	--��ʼ��
	g_func["��ʼ��"]()

	--�ȴ�
	if v["�ȴ���˫�л�"] then
		if gettimer("������") < 0.3 or gettimer("�·�����") < 0.3 then
			print("�ȴ���˫�л�")
			return
		end
	end

	--��ʼ�������������
	v["����"] = energy()
	v["����"] = buff("24029")--and gettimer("������") > 0.3
	v["˫��"] = buff("24110")--and gettimer("�·�����") > 0.3
	v["��������"] = 0
	if buff("24105") then v["��������"] = v["��������"] + 1 end
	if buff("24106") then v["��������"] = v["��������"] + 1 end
	if buff("24107") then v["��������"] = v["��������"] + 1 end

	f["����˺�"]()

	--������
	if buff("23898") or gettimer("������") < 0.5 then
		f["������"]()
		return
	end

	if f["û���"] and cdtime("�η�Ʈ��") > 8 and enemy("����<30", "Ŀ������") ~= 0 then
		if nobuff("ʶ��") and v["����"] < 50 then
			if cast("������") then
				settimer("������")
				return
			end
		end
	end


	f["����ХӰ"]()

	f["�η�Ʈ��"]()
	f["��Ӱ׷��"]()

	f["�۷�˲�һ��"]()
	f["�۷�˲�����"]()

	--�����
	if g_var["Ŀ��ɿ���"] and target("player") then
		f["�����"]()
	end

	--���˺�
	if g_var["Ŀ��ɹ���"] then
		f["���˺�"]()
	end

	--������
	if v["˫��"] and dis() > 15 and nobuff("ʶ��") then
		f["������"]()
	end

	--����е
	f["����ϴ����"]()

	if buffstate("��еʱ��") > 2 then
		if cast("��ҡֱ��") then
			jump()
		end
	end

	--�ɼ�������Ʒ
	if nofight() then
		g_func["�ɼ�"](g_player)
	end
end

f["û���"] = function()
	return buffstate("�����ʱ��") <= 0 and gettimer("�۷�˲�һ��") > 0.25 and gettimer("������") > 0.25
end

f["�η�Ʈ��"] = function()
	if buffstate("����ʱ��") > 1.5 or buffstate("����ʱ��") > 1.5 or buffstate("ѣ��ʱ��") > 1.5 or buffstate("����ʱ��") > 1.5 or buffstate("��ֱʱ��") > 0.5 then
		cast("�η�Ʈ��")
	end

	--[[
	if f["û���"]() and enemy("����<30", "�����Լ�") ~= 0 then
		cast("�η�Ʈ��")
	end
	--]]
end

f["��Ӱ׷��"] = function()
	if enemy("����<30", "�����Լ�") ~= 0 then
		cast("��Ӱ׷��")
	end
end

f["�ͷų۷�˲�һ��"] = function(szLog, bStop)
	if cast(32140) then
		print("�۷�˲�һ��: "..szLog)
		v["��ֹ�۷�һ��"] = bStop
		settimer("�۷�˲�һ��")
		exit()
	end
end

f["�۷�˲�һ��"] = function()
	--û��ս���ȴ��ʶ��
	if v["����"] and nofight() and nobuff("ʶ��") and enemy("����<40") ~= 0 then
		f["�ͷų۷�˲�һ��"]("û��ս��ʶ��", true)
	end

	--��������
	if v["����"] and nobuff("ʶ��") and v["��������"] > 0 then
		f["�ͷų۷�˲�һ��"]("��������", true)
	end
end

f["�۷�˲�����"] = function()
	if gettimer("�۷�˲�����") < 0.3 then return end

	--׷��
	if g_var["Ŀ��ɹ���"] and g_var["ͻ��"] and canmove(id(), tid(), id(), 25)  then

		if v["����"] then
			if dis() > 25 or (nobuff("ʶ��") and dis() > 18)  then
				if acast(32141) then
					print("�۷�˲�����, ����׷��")
					settimer("�۷�˲�����")
					exit()
				end
			end
		end

		if v["˫��"] then
			if dis() > 15 then
				if acast(32141) then
					print("�۷�˲�����, ˫��׷��")
					settimer("�۷�˲�����")
					exit()
				end
			end
		end
	end
end

f["�����"] = function()
	--ϴ����, ��е
	if tmounttype("�ڹ�|�⹦|����") and tbuffstate("�ɽ�е") and tbuffstate("��еʱ��") < 0 then
		cast("ϴ����")
	end

	--��ʯ��
	if v["����"] and g_var["ͻ��"] and nobuff("ʶ��") and tbuffstate("�ɻ���") and dis() > 10 then
		if cast("��ʯ��") then
			exit()
		end
	end
end


f["���˺�"] = function()
	---------------------------------------------����
	if v["����"] then
		--�����ơ��Ʒ�
		cast("�����ơ��Ʒ�")
		
		--������
		if cdleft(2436) >= 1 then
			cast("������")
		end

		--������
		if dis() < range("������", true) then
			if face() < 60 then
				if cast("������") then
					settimer("������")
					v["�ȴ���˫�л�"] = true
					exit()
				end
			else
				if acast("������") then
					settimer("������")
					v["�ȴ���˫�л�"] = true
					return
				end
			end
		end

		--������
		if g_var["ͻ��"] and buff("ʶ��") and canmove(id(), tid(), id()) then
			if cast("������") then
				settimer("������")
			end
		end

		--��������
		if bufflv("23877") >= 2 or buff("24553") then
			if cast("������") then
				print("��������")
			end
		end

		if gettimer("�۷�˲�һ��") > 0.25 and nobuff("ʶ��") then
			--ͣ����, 10������
			if v["����"] <= 40 or (v["����"] > 50 and v["����"] <= 90) then
				cast("ͣ����")
			end

			--������
			if cast("������") then
				print("��ͨ����", "��������", v["��������"])
			end
		end

	end

	---------------------------------------------˫��
	if v["˫��"] then
		v["���˾���"] = 6
		if qixue("����") then
			v["���˾���"] = v["���˾���"] + 2
		end

		--���ƶ���
		cast("���ƶ���")

		--�·�����
		if dis() < v["���˾���"] and visible() then
			if cdtime("�·�����") <= 0 then
				cast("��Ӱ׷��")
			end
			if acast("�·�����") then
				settimer("�·�����")
				v["�ȴ���˫�л�"] = true
				exit()
			end
		end

		--��������
		if dis() < v["���˾���"] then
			if face() < 60 then
				cast("��������")
			else
				acast("��������")
			end
		end

	end
end

f["������"] = function()
	--��ʶ�Ʋ�������
	if buff("ʶ��") then return end
	
	--�ƶ�������
	v["�����������"] = npc("ģ��ID:111366", "�������")
	if v["�����������"] ~= 0 and xdis(v["�����������"]) < 15 then
		bigtext("������", 0.5)
		print("������")
		stopmove()
		moveto(xpos(v["�����������"]))
		return
	end
end

f["����ϴ����"] = function()
	if bufftime("ϴ����") > 1 then
		local x, y, z, dist, id = doodad(9810)	--��ȡ�����������, �����ɱ���ID��ͬ
		if x > 0 then
			stopmove()
			moveto(x, y, z)	--��ָ��λ���ƶ�
			exit()
		end
	end
end

--����ּ���
f["����˺�"] = function()
	--�ؽ� ������ɽ
	v["����������ɽ����"] = enemy("ƽ�����<10", "����:������ɽ")
	if v["����������ɽ����"] ~= 0 then
		if acast2("��������", v["����������ɽ����"], 12) then
			bigtext("�������ɽ����")
			return
		end
	end
	v["�жԷ�����ɽNpc"] = npc("��ϵ:�ж�", "ƽ�����<10", "ģ��ID:57739")
	if v["�жԷ�����ɽNpc"] ~= 0 then
		if acast2("��������", v["�жԷ�����ɽNpc"], 12) then
			bigtext("�������ɽNpc")
			return
		end
	end

	--���� ˪�콣��
	v["˪�콣��Դ��ɫ"] = buffsrc("˪�콣��")
	if v["˪�콣��Դ��ɫ"] ~= 0 then
		if acast2("��������", v["˪�콣��Դ��ɫ"], 17) then
			bigtext("����˪�콣��")
			return
		end
	end

end

--����ХӰ, ���˺�֮ǰ����
f["����ХӰ"] = function()
	v["ХӰԴ��ɫ"] = buffsrc("ХӰ")
	if v["ХӰԴ��ɫ"] ~= 0 then
		v["ХӰNPC"] = npc("ģ��ID:58636", "����:"..v["ХӰԴ��ɫ"])
		if v["ХӰNPC"] ~= 0 then
			acast2("��������", v["ХӰNPC"], 16)
		end
		bigtext("��ХӰ")
		exit()
	end
end


--�ͷż���
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		--��ϳ۷�˲�
		if SkillID == 32140 then
			if v["��ֹ�۷�һ��"] then
				jump()
				print("��ֹ�۷�һ��")
			end
			return
		end
		--������ �·����� �ȴ�����
		if SkillID == 32135 or SkillID == 32145 then
			v["�ȴ���˫�л�"] = false
			return
		end
	end
end

local tBuff = {}

--���buff�䶯���
function OnBuff(CharacterID, BuffName, BuffID, BuffLevel, StackNum, SkillSrcID, StartFrame, EndFrame, FrameCount)
	if CharacterID == id()  then
		if StackNum  > 0 then
			local bPrint = false
			if buffis(BuffID, BuffLevel, "���⹦") then
				print("����Ĭ")
				bigtext("����Ĭ")
				bPrint = true
			end
			if buffis(BuffID, BuffLevel, "��е") then
				print("����е")
				bigtext("����е")
				bPrint = true
			end
			if buffis(BuffID, BuffLevel, "����") then
				print("������")
				bigtext("������")
				bPrint = true
			end
			if buffis(BuffID, BuffLevel, "����") then
				print("������")
				bigtext("������")
				bPrint = true
			end
			if buffis(BuffID, BuffLevel, "ѣ��") then
				print("��ѣ��")
				bigtext("��ѣ��")
				bPrint = true
			end
			if buffis(BuffID, BuffLevel, "����") then
				bigtext("������")
				bPrint = true
			end

			if tBuff[BuffID] or bPrint then
				print("���buff: ".. BuffName..", ID: "..BuffID..", �ȼ�: "..BuffLevel..", ����: "..StackNum..", ԴID: "..SkillSrcID..", ��ʼ֡: "..StartFrame..", ��ǰ֡: "..FrameCount..", ����֡: "..EndFrame..", ʣ��ʱ��: "..(EndFrame-FrameCount)/16)
			end
		else
			if tBuff[BuffID] then
				print("�Ƴ�buff: ".. BuffName..", ID: "..BuffID..", �ȼ�: "..BuffLevel..", ����: "..StackNum..", ԴID: "..SkillSrcID..", ��ʼ֡: "..StartFrame..", ��ǰ֡: "..FrameCount)
			end
		end
	end
end
