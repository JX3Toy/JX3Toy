--[[ ��Ѩ: [Ы��][ʳ��][��Ӱ][����][�ҽ�][����][�ȹ�][����][��Ϣ][��Ƭ��][����][��Ե��]
�ؼ�: ���ȵ��Ϣ
Ы��  2�˺� 2����
��Ӱ  1���� 1���� 2�˺�
����  3��Ϣ 1�˺�
���  1���� 3�˺�
�׼�  2��Ϣ

������ж�������ֶ�, [�ҽ�]���Ի�[�ع�]
����15���ڴ�, ����������Ŀ��4��, ��Ȼ������Ŀ���ʱ�����ʧ����dps

��Ӱ - ��Ƭ - �Х - �׼� ���� ��Ӱ �û� - ��Ӱ - ���� - Ы�� - ��Ե - ��Ӱ - Ы�� ...
--]]

--�ر��Զ�����
setglobal("�Զ�����", false)

--��ѡ��
addopt("����������", false)
addopt("���", false)
addopt("�Զ��Զ�", false)

--������
local v = {}
v["�����Ϣ"] = true

--��ѭ��
function Main()
	--�����Զ����ݼ�1�ҷ�ҡ, ע���ǿ�ݼ��趨�������Ŀ�ݼ�1ָ���İ��������Ǽ����ϵ�1
	if keydown(1) then
		cast("��ҡֱ��")
	end

	--[[��Ե�����, ǰ0.5���ֹ�ƶ�, Ӱ��㼼����ע�͵�
	if gettimer("��Ե��") < 0.5 then
		return
	else
		nomove(false)	--�����ƶ�
	end
	--]]

	--��ʼ������
	v["Ы��ʱ��"] = tbufftime("Ы��", id())	--12��
	v["��Ӱʱ��"] = tbufftime("��Ӱ", id())	--18��
	v["��Ӱ����"] = tbuffsn("��Ӱ", id())
	v["����ʱ��"] = tbufftime("����", id())	--18��
	v["�Хʱ��"] = tbufftime("�Х", id())	--14��
	v["�׼�ʱ��"] = bufftime("�����׼�")	--12
	v["�ȹ�ʱ��"] = bufftime("�ȹ�")	--15��
	v["����ʱ��"] = bufftime("����")	--10��
	v["����CD"] = scdtime("����")
	v["�ХCD"] = scdtime("�Х")
	v["������CD"] = scdtime("������")
	v["�׼�CD"] = scdtime("�Ƴ��׼�")
	v["����&�׼�CD"] = math.max(v["������CD"], v["�׼�CD"])
	v["��Ƭ��CD"] = scdtime("��Ƭ��")
	v["��Ե��CD"] = scdtime("��Ե��")
	v["�û�CD"] = scdtime(36292)
	v["GCD���"] = cdinterval(16)
	v["��Ե�ƶ���ʱ��"] = casttime("��Ե��")
	

	--����
	if fight() and pet() and life() < 0.6 then
		cast("��ˮ��")
	end

	--��˹�
	if qixue("��Ϣ") then
		if rela("�ж�") and dis() < 30 then
			if nobuff("��˹�") or nofight() then
				CastX("��˹�")
			end
		end
	end

	--����
	if nopet("����") then
		CastX("������")
	end

	--����������
	if getopt("����������") and dungeon() and nofight() then return end

	---------------------------------------------

	--���
	if rela("�ж�") then
		v["�����"] = false
		if qixue("�ع�") and tbufftime("������") < 2 then
			v["�����"] = true
		end
		if cn("���") > 1 then
			v["�����"] = true
		end
		if getopt("���") and tbuffstate("�ɴ��") then
			v["�����"] = true
		end
		if v["�����"] then
			local bLog = setglobal("��¼�����ͷ�", false)
			cast("���")
			if bLog then setglobal("��¼�����ͷ�", true) end
		end
	end

	--���﹥��
	if pet() and rela("�ж�") then
		local bLog = setglobal("��¼�����ͷ�", false)
		cast("����")
		if bLog then setglobal("��¼�����ͷ�", true) end
	end

	--�û�
	if pet() and v["��Ӱ����"] >= 2 then
		if v["��Ե��CD"] > 12 + v["GCD���"] * 3 then
			CastX("�û�")
		end
	end

	--��Ӱ �׼�ǰ
	if v["��Ե��CD"] <= v["GCD���"] * 7 and v["��Ӱʱ��"] < v["GCD���"] * 3 + 0.5  then	--v["�׼�ʱ��"]
		if CastX("��Ӱ") then
			print("---------- �׼�����Եǰ")
		end
	end

	--��Ƭ�� �׼�ǰ
	if rela("�ж�") and dis() < 15 then
		if v["��Ե��CD"] <= v["GCD���"] * 6 and v["����&�׼�CD"] <= v["GCD���"] * 2  then	--�׼�ǰ
			CastX("��Ƭ��")
		end
	end

	--�Х, �׼�ǰ
	if dis() < 15 and v["��Ե��CD"] <= v["GCD���"] * 5 and v["����&�׼�CD"] <= v["GCD���"] then
		CastX("�Х")
	end

	--�׼�����
	if pet() and rela("�ж�") and dis() < 15 and v["��Ե��CD"] <= v["GCD���"] * 4 then
		if cdtime("������") <= 0 then
			if CastX("�Ƴ��׼�") then
				if CastX("������") then
					self().ClearCDTime(16)
				end
			end
		end
	end

	--��Ӱ �û� �׼���
	if gettimer("�Ƴ��׼�") < 1 then
		if CastX("��Ӱ") then
			CastX("�û�")
		end
	end

	--��Ӱ ��Եǰ
	if v["��Ե��CD"] <= v["GCD���"] * 3 and v["��Ӱʱ��"] <= v["GCD���"] * 3 + v["��Ե�ƶ���ʱ��"] then
		if CastX("��Ӱ") then
			print("--------- ��Եǰ")
		end
	end

	--����
	if rela("�ж�") then
		if v["��Ե��CD"] <= v["GCD���"] * 2 or v["��Ե��CD"] > 15 + v["GCD���"] then
			CastX("����")
			if v["����CD"] < 0.5 then	--�Ȱ���CD
				if cdleft(16) <= 0 then
					PrintInfo("---------- �Ȱ���CD")
				end
				return
			end
		end
	end

	--Ы�� ��Եǰ
	if v["��Ե��CD"] <= v["GCD���"] and v["Ы��ʱ��"] <= v["GCD���"] + v["��Ե�ƶ���ʱ��"] then
		CastX("Ы��")
	end

	--��Ե��, ��ʼ�ͷ�ʱ�ж�dot����, ÿ���ж�dot����, buff 19513 �ȼ�����dot����
	v["�ƶ���������"] = keydown("MOVEFORWARD") or keydown("MOVEBACKWARD") or keydown("STRAFELEFT") or keydown("STRAFERIGHT") or keydown("JUMP")
	if not v["�ƶ���������"] then	--û���ƶ�
		v["����Ե��"] = false

		v["���dotʱ��"] = math.min(v["Ы��ʱ��"], v["��Ӱʱ��"], v["����ʱ��"], v["�Хʱ��"])
		if v["�׼�ʱ��"] > v["��Ե�ƶ���ʱ��"] and v["���dotʱ��"] > v["��Ե�ƶ���ʱ��"] then
			v["����Ե��"] = true	--��������������
		end

		if v["�׼�ʱ��"] > 0 and v["�׼�ʱ��"] <= v["��Ե�ƶ���ʱ��"] + v["GCD���"] * 2 then
			v["����Ե��"] = true	--�׼�ʱ��쵽��, dot������Ҳ��
		end

		if v["����Ե��"] then
			if CastX("��Ե��") then
				stopmove()		--ֹͣ�ƶ�
				--nomove(true)	--��ֹ�ƶ�
				exit()
			end
		end
	end

	--Ы��
	if bufftime("24479") > 0 then	--������
		CastX("Ы��")
	end
	
	--��1����Ӱ
	if v["��Ӱ����"] < 1 or v["��Ӱʱ��"] < 2.5  then
		CastX("��Ӱ")
	end

	--�Х
	if v["��Ե��CD"] > 12 + v["GCD���"] * 5  then
		CastX("�Х")
	end

	if qixue("��Ϣ") and rela("�ж�") and dis() < 30 and nobuff("��˹�") then
		CastX("��˹�")
	end

	--��Ӱ
	CastX("��Ӱ")


	--�Զ�
	if getopt("�Զ��Զ�") and nobuff("��ʱ") and cdleft(16) > 0.5 then
		if life() < 0.7 or mana() < 0.8 then
			interact("�����ƶ�")
		end
	end
end

-------------------------------------------------

--�����Ϣ
function PrintInfo(s)
	local t = {}
	if s then t[#t+1] = s end
	t[#t+1] = "Ы��:"..v["Ы��ʱ��"]
	t[#t+1] = "��Ӱ:"..v["��Ӱ����"]..", "..v["��Ӱʱ��"]
	t[#t+1] = "����:"..v["����ʱ��"]
	t[#t+1] = "�Х:"..v["�Хʱ��"]
	t[#t+1] = "����:"..v["����ʱ��"]
	t[#t+1] = "�׼�:"..v["�׼�ʱ��"]
	t[#t+1] = "�ȹ�:"..v["�ȹ�ʱ��"]

	t[#t+1] = "����&�׼�CD:"..v["����&�׼�CD"]
	t[#t+1] = "����CD:"..v["����CD"]
	t[#t+1] = "�ХCD:"..v["�ХCD"]
	t[#t+1] = "�û�CD:"..v["�û�CD"]
	t[#t+1] = "��Ե��CD:"..v["��Ե��CD"]

	print(table.concat(t, ", "))
end

--ʹ�ü��ܲ������Ϣ
function CastX(szSkill, bSelf)
	if cast(szSkill, bSelf) then
		settimer(szSkill)
		if v["�����Ϣ"] then PrintInfo() end
		return true
	end
	return false
end

-------------------------------------------------

--�ͷż���
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		if SkillID == 2226 then
			print("------------------------------ �Ƴ��׼�")	--��ӡ�ָ��߷���鿴ÿ��ѭ�������ͷ����
		end

		if SkillID == 29573 then	--��Ƭ��
			if SkillID < 5 or v["����ʱ��"] <= 0 then
				print("----------��Ƭ�Ʋ���5����û�������ڼ�", SkillName, SkillID, SkillLevel)
			end
		end
	end
end

--ս��״̬�ı�, ��־��¼һ�����ڷ�������
function OnFight(bFight)
	if bFight then
		print("--------------------����ս��")
	else
		print("--------------------�뿪ս��")
	end
end
