--��Ѩ: [ˮӯ][����][˳ף][������][��ɽ][���][ب��][����][����][����][����][����]

--�����
load("Macro/Lib_PVP.lua")

--������
local v = {}

--������
local f = {}

--��ѭ��
function Main(g_player)
	--��ʼ��
	g_func["��ʼ��"]()

	v["����"] = rage()
	v["����ʣ��ʱ��"] = ljtime()
	v["�Լ���������"] = xinlianju(id())
	--v["��Ҫ������"] = v["����ʣ��ʱ��"] < 25

	--������ʱ������Ŀ��
	if casting("������|�춷��") then
		turn()
	end


	f["��������"]()

	f["�����"]()

	--���ű���
	if fight() then
		if life() < 0.6 then
			cast("���ű���")
		end

		--if life() < 0.9 then
			--�ؽ� ������ɽ
			v["����������ɽ����"] = enemy("ƽ�����<10", "����:������ɽ")
			if v["����������ɽ����"] ~= 0 then
				if cast("���ű���") then
					bigtext("�з糵������")
				end
			end
			v["�жԷ�����ɽNpc"] = npc("��ϵ:�ж�", "ƽ�����<10", "ģ��ID:57739")
			if v["�жԷ�����ɽNpc"] ~= 0 then
				if cast("���ű���") then
					bigtext("�з糵������")
				end
			end
		--end
	end


	--���˺�
	if g_var["Ŀ��ɹ���"] then
		if v["����"] >= 70 then
			cast("������")
		end

		if xinlianju(tid()) and dis() < 8 then
			cast("ɱ����β")
		end

		if bufftime("17996") > 0.1 then
			cast("�춷��")
		end

		--��������
		if v["�Լ���������"] and gettimer("ˮ���") > 0.25 and gettimer("ɽ���") > 0.25 then
			if gettimer("�ͷ�����") < 0.5 or gettimer("����_����") > 3 then
				cast("������")
			end
			
			--if gettim����") > 3er("�ͷ�����") < 0.5 or gettimer("�ͷ� then
				cast("�춷��")
			--end
		end

		cast("���߶�")

		cast("������")
	end

	--���վ���
	if buffstate("����ʱ��") > 1.5 or buffstate("����ʱ��") > 1.5 or buffstate("ѣ��ʱ��") > 1.5 or buffstate("����ʱ��") > 1.5 or buffstate("��ֱʱ��") > 0.5 then
		cast("���վ���")
	end

	--����е
	if buffstate("��еʱ��") > 2 then
		if buff("����") then
			jump()
		else
			if cast("��ҡֱ��") then
				jump()
			end
		end
	end

	--̤����
	if buffstate("����ʱ��") > 2 then
		cast("̤����")
	end


	--�������ҷ�ҡ
	if jjc() then
		cast("��ҡֱ��")
	end

	--�ɼ�������Ʒ
	if nofight() then
		g_func["�ɼ�"](g_player)
	end
end


f["����"] = function(info)
	--��Ҫ�����ֲ�����
	--if v["��Ҫ������"] then return end

	if gettimer("����") > 0.5 and gettimer("�ͷ�����") > 3 then
		if cast("����") then
			v["����"] = v["����"] - 20
			bigtext(info)
			print(info)
			settimer(info)
		end
	end
end

f["��������"] = function()
	v["Ŀ���ڷ�Χ��"] = rela("�ж�") and dis() < 25

	--����, 2.5��������
	if g_var["������������"] > 0 or v["Ŀ���ڷ�Χ��"] then
		if cast("����") then
			settimer("����")
			return
		end
	end
		
	--ˮ��
	if buff("ˮ��") then
		if buff("17824") then
			if gettimer("ף�ɡ�ˮ��") > 0.25 and cast("ף�ɡ�ˮ��", true) then
				settimer("ף�ɡ�ˮ��")
			end
		else
			--���Դ����
			if v["Ŀ���ڷ�Χ��"] and tbufftime("ף�ɡ�����", id()) < 2 then
				f["����"]("ˮ���")
				return
			end

			--ʱ�䲻����һ������
			if cdleft(16) > bufftime("17826") then
				f["����"]("ˮ���")
				return
			end
		end
		return
	end

	--ɽ��
	if buff("ɽ��") then
		if buff("17823") then
			if g_func["Ŀ��ɿ���"] then
				if gettimer("ף�ɡ�ɽ��") > 0.25 and cast("ף�ɡ�ɽ��") then
					settimer("ף�ɡ�ɽ��")
				end
			end
		else
			--���Դ����
			if v["Ŀ���ڷ�Χ��"] and tbufftime("ף�ɡ�����", id()) < 2 then
				f["����"]("ɽ���")
				return
			end

			if cdleft(16) > bufftime("17826") then	--��������
				if v["Ŀ���ڷ�Χ��"] and cdtime("����") > 9 then
					f["����"]("ɽ���")
					return
				end
			end


		end
		return
	end

	--����
	if buff("����") then
		if buff("17825") then
			if g_func["Ŀ��ɿ���"] and tbufftime("ף�ɡ�����", id()) < 8 then
				if gettimer("ף�ɡ�����") > 0.25 and cast("ף�ɡ�����") then
					settimer("ף�ɡ�����")
				end
			end
		else
			--��ɽ������˺�
			if v["Ŀ���ڷ�Χ��"] and cdtime("����") > 10 then
				f["����"]("���ɽ")
			end
		end
		return
	end
end

f["�����"] = function()
	
	--�ŵ�	
	if enemy("����<50") ~= 0 or (rela("�ж�") and dis() < 25) then
		if cdtime("���ŷɹ�") <= 0 and nobuff("18231") then
			fangdeng(10)
		end
	end

	--[[����, �����ˣ������ŵƾ�����
	if v["��Ҫ������"] and buffstate("�����ʱ��") > 5 then
		if cast("���ǿ�Ѩ") then
			settimer("���ǿ�Ѩ")
		end
	end
	--]]
end


--�ͷż���
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		if SkillID == 24831 then
			settimer("����_ˮ��")
			print("����_ˮ��")
			return
		end
		if SkillID == 24832 then
			settimer("����_ɽ��")
			print("����_ɽ��")
			return
		end
		if SkillID == 24833 then
			settimer("����_����")
			print("����_����")
			return
		end
		
		if SkillID == 24375 then
			settimer("�ͷ�����")
		end
	end
end



local tBuff = {
--[17588] = "ˮ��",
--[17824] = "����_ˮ����������",
--[17801] = "ɽ��",
--[17823] = "����_ɽ�޽�������",
--[17802] = "����",
--[17825] = "����_�����������",
--[17826] = "��������",
--[17996] = "����|����_��˲��",
}

--���buff�䶯���
function OnBuff(CharacterID, BuffName, BuffID, BuffLevel, StackNum, SkillSrcID, StartFrame, EndFrame, FrameCount)
	if CharacterID == id() then
		if StackNum  > 0 then
			local bPrint = false
			if  BuffID ~= 17584 then
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
				if buffis(BuffID, BuffLevel, "���Ԫ") then
					print("������")
					bigtext("������")
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
					print("������")
					bigtext("������")
					bPrint = true
				end
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

--״̬����
function OnStateUpdate(nCurrentLife, nCurrentMana, nCurrentRage, nCurrentEnergy, nCurrentSunEnergy, nCurrentMoonEnergy)
	--print("����: "..nCurrentRage)
end
