output("��Ѩ: [����][����][���][����ң][��ϼ][ԽԨ][�¾�][ѱ��][���][��Ұ][�޾�][Ǳ������]")
--��ѡ��Ѩ: [����][����][����][����][�ξ�]

--�����
load("Macro/Lib_PVP.lua")

--������
local v = {}

--������
local f = {}

f["������"] = function()
	if cast("������") then
		stopmove()			--ֹͣ�ƶ�
		nomove(true)		--��ֹ�ƶ�
		settimer("������")
		exit()
	end
end

f["Ц���"] = function()
	--��ֹ���з�Ц���
	if height() > 2 then return end

	if cast("Ц���") then
		stopmove()			--ֹͣ�ƶ�
		nomove(true)		--��ֹ�ƶ�
		settimer("Ц���")
		exit()
	end
end

f["Ŀ�귽��������"] = function()
	local t = {
		["ǰ"] = 5505,
		["��"] = 5506,
		["��"] = 5507,
		["��"] = 5508,
		["δ֪��λ"] = 5269,
	}

	if cast(t[xdir(tid())]) then
		settimer("������")
		exit()
	end
end


--��ѭ��
function Main(g_player)
	--��ʼ��
	g_func["��ʼ��"]()

	--Ц��񡢾����ɷ����
	if gettimer("Ц���") < 0.5 or gettimer("������") < 0.5 or casting("������|Ц���") then
		return
	else
		nomove(false)
	end

	f["����˺�"]()

	--���ֺȾ�
	if g_var["������������"] > 0 and nobuff("��������") then
		f["������"]()
	end

	--����
	if fight() then
		if buffstate("����Ч��") < 40 then
			--��Х
			v["����Х����"] = false
			
			if qixue("�޾�") and life() < 0.6 then
				v["����Х����"] = true
			end

			if life() < 0.5 then
				v["����Х����"] = true
			end

			if v["����Х����"] and cast("��Х����") then
				return
			end
		end

		if life() < 0.35 then
			f["Ц���"]()
		end
	end

	f["����ХӰ"]()

	--���˺�
	if g_var["Ŀ��ɹ���"] then
		--if not g_var["Ŀ����ű���"] and not g_var["Ŀ��߷���"] then
		f["���˺�"]()
	end

	--����Ϸˮ
	if g_var["������������"] > 0 then
		cast("����Ϸˮ")
	end

	--�˺�����û�ó���, �Ⱦ����
	if qixue("��Ұ") and g_var["������������"] > 0 then
		f["������"]()
	end


	f["���"]()

	--�ҷ�ҡ
	if jjc() then
		if cdleft(590) <= 0 or cdleft(590) > 0.35 then
			cast("��ҡֱ��")
		end
	end

	--�ɼ�������Ʒ
	if nofight() then
		g_func["�ɼ�"](g_player)
	end
end


f["���˺�"] = function()

	--�����п���Ǳ����ֱ
	if gettimer("�ͷ�Ǳ������") < 0.5 then
		f["Ŀ�귽��������"]()
	end

	--Ǳ������
	if bufftime("12522") < 3.125 then	--12522ѱ�¿�����Ǳ��
		cast(18678)	--[ѱ��]Ǳ��
	end

	--��ս��Ұ
	v["��ս+������Ҫ����"] = 0.5
	if qixue("ԽԨ") and bufftime("��������") > 0.5 then
		v["��ս+������Ҫ����"] = 0.375
	end

	if g_var["ͻ��"] then
		if mana() >= v["��ս+������Ҫ����"] then
			cast("��ս��Ұ")
		end
	end

	--����ң
	v["������Ҫ����"] = 0.3
	if qixue("ԽԨ") and bufftime("��������") > 0.5 then
		v["������Ҫ����"] = 0.225
	end

	--����ǰ���
	if dis() < 8 then
		if mana() >= v["������Ҫ����"] then
			cast("����ң")
		end
	end
	
	--ʱ��쵽��
	if bufftime("6433") <= 1 then
		cast("����ң")
	end

	--�����л�
	cast("�����л�")

	
	--Ȯ������, ��Ҫbuff 6075
	if dis() < 6 then
		cast("Ȯ������")
	end

	--��
	if dis() < 6 then
		if face() < 60 then
			cast("����·")
		else
			acast("����·")
		end
	end

	--�¾�
	if dis() < 40 and qixue("�¾�") and bufftime("�¾�") < 0 then
		f["������"]()
	end

	--����е�Ⱦƻ���
	if buffstate("��еʱ��") > 2 then
		f["������"]()

		--�Ⱦ�CD�ˣ�������
		if buff("����") then
			jump()
		end
	end

	--����ʱ��쵽�˴��˺���û������ע�͵�
	if g_var["ͻ��"] and bufftime("12422") < 1 then
		cast("��������")
	end

	--��������
	cast("��������")
	cast("���˫��")

	--��Ȯ����, ����60%
	if tbuffstate("�ɽ�ֱ") then
		cast("��Ȯ����")
	end

	--����ͷ, ����20%
	if g_var["ͻ��"] then
		cast("����ͷ")
	end

	--��Ծ��Ԩ, ׷��
	if g_var["ͻ��"] then
		cast("��Ծ��Ԩ")
	end

	--��ս׷��
	if g_var["ͻ��"] then
		cast("��ս��Ұ")
	end
end


f["���"] = function()
	--���ƽ⽩ֱ
	if buffstate("��ֱʱ��") > 0.5 then
		if cast("��������") then
			return
		end
	end

	v["����20�ߵ���"] = enemy("����<20", "�Ƕ�<90", "�������")

	--���������
	if buffstate("����ʱ��") > 2 and qixue("����") then
		if cast("����ͷ") then
			return
		end
		if v["����20�ߵ���"] ~= 0 then
			xcast("����ͷ", v["����20�ߵ���"])
		end
	end

	--������, ������
	if buffstate("����ʱ��") > 2 then
		f["Ŀ�귽��������"]()
	end
	
	--����
	if buffstate("����ʱ��") > 2 or buffstate("ѣ��ʱ��") > 2 or buffstate("����ʱ��") > 1.5 or buffstate("��ֱʱ��") > 1 then
		--��Ŀ���ü���
		if cast("��������") then
			return
		end
		
		if qixue("����") then
			if v["����20�ߵ���"] ~= 0 then
				if xcast("��������", v["����20�ߵ���"]) then
					return
				end
			end
		else
			v["����20������������"] = enemy("����<20", "�Ƕ�<90", "buffʱ��:12421>0.2", "�������")
			if v["����20������������"] ~= 0 then
				if xcast("��������", v["����20������������"]) then
					return
				end
			end
		end
	end

	--��Х����
	if buffstate("����ʱ��") > 2 or buffstate("ѣ��ʱ��") > 2 or buffstate("����ʱ��") > 1.5 or buffstate("��ֱʱ��") > 1 then
		if cast("��Х����") then
			return
		end
	end

	--Ц���
	if buffstate("����ʱ��") > 2 or buffstate("ѣ��ʱ��") > 2 or buffstate("����ʱ��") > 1.5 or buffstate("��ֱʱ��") > 1 then
		f["Ц���"]()
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


local tBuff = {
--[20939] = "�¾�",
--[5754] = "����|����",
--[24621] = "Ǳ�����á�Ǭ",
}

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

--�ͷż���
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		if SkillID == 8490 then
			settimer("�ͷſ����л�")
		end
		if SkillID == 18678 then
			settimer("�ͷ�Ǳ������")
		end
	end
end

--[[״̬����
function OnStateUpdate(nCurrentLife, nCurrentMana, nCurrentRage, nCurrentEnergy, nCurrentSunEnergy, nCurrentMoonEnergy)
	--��������䶯
	print("OnStateUpdate, ����: ", nCurrentMana)
end
--]]

--[[�����������
Ǳ����ֱ28֡
����һ�ƽ�ֱ34֡
--]]
