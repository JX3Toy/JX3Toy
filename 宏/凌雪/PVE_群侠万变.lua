--[[ ��Ѩ: [����][ѩ��][����][���][����][Ԩ��][����][���л�ת][�ٽ�][����][����][��ɽ����]
�ؼ�:
�Ǵ�	1���� 3�˺�
���	2���� 2�˺�
�ź��	3�˺�
������	2��Ϣ 2�˺�
������	1���� 3�˺�
Ѫ��	2��Ϣ 2����
��ڤ	2�˺� 2���Ļ�1����1����
--]]

--�ر��Զ�����
setglobal("�Զ�����", false)

--��ѡ��
addopt("����������", false)

--������
local v = {}
v["�����Ϣ"] = true
v["�Ź�������"] = false

--��ѭ��
function Main(g_player)
	if casting("�ź��") and castleft() < 0.13 then
		settimer("�ź�Ķ�������")
	end
	if casting("������") and castleft() < 0.13 then
		settimer("�����Ƕ�������")
	end

	--��ʼ������
	v["���CD"] = scdtime("������")
	v["�ź�ĳ�����ʱ��"] = cntime("�ź��", true)
	v["�ź�ĳ��ܴ���"] = cn("�ź��")
	v["������CD"] = scdtime("������")
	v["�����⹳CD"] = scdtime("�����⹳")
	v["��CD"] = scdtime("���͹�")
	v["����CD"] = scdtime("���л�ת")
	v["��ɽCD"] = scdtime("��ɽ����")
	v["��ʱ��"] = bufftime("���͹�")	--���Ļ�Ч�����������15%, 4��
	v["��������ʱ��"] = bufftime("24244")	--���������� 5��
	v["��ǲ���"] = buffsn("26215")
	v["���ʱ��"] = bufftime("26215")		--8��
	v["�ٽڲ���"] = buffsn("�ٽ�")			--ʵ��Ч�� 15927 15928 15929
	v["�ٽ�ʱ��"] = bufftime("�ٽ�")		--5��
	v["����ʱ��"] = bufftime("����")		--10��
	v["����ʱ��"] = bufftime("����")		--10��
	v["����"] = buff("15524")
	v["˫��"] = buff("15565")
	v["˫��"] = nobuff("15524|15565")
	local tSpeedXY, tSpeedZ = speed(tid())
	v["Ŀ�꾲ֹ"] = rela("�ж�") and tSpeedXY <= 0 and tSpeedZ <= 0
	v["�ź�Ķ���ʱ��"] = casttime("�ź��")

	--Ŀ�겻�ǵж�, ����
	if not rela("�ж�") then return end
	--���� û��ս ѡ���, ����
	if getopt("����������") and dungeon() and nofight() then return end

	--�ȴ�״̬ͬ��
	if gettimer("�ȴ�����") < 0.3 then print("--------------------�ȴ�����") return end
	if gettimer("�ȴ�����") < 0.3 then print("--------------------�ȴ�����") return end
	if gettimer("�ź�Ķ�������") < 0.3 then
		--print("----------�ȴ��ź���ͷ�")
		return
	end

	--�������Ʒ���
	v["����"] = npc("��ϵ:�Լ�", "ģ��ID:107305", "����<12")
	if v["����"] ~= 0 then
		aCastX("������", 0, v["����"])
	end

	--�����⹳
	if dis() < 5 and v["����ʱ��"] > 9 then
		if aCastX("�����⹳") then
			settimer("�����⹳")
		end
	end

	---------------------------------------------

	if v["˫��"] then
		--������
		if dis() > 6 and dis() < 12 and face() < 60 and v["����CD"] > 20 then
			 if v["�ٽڲ���"] >= 3 and v["�ٽ�ʱ��"] > 0 and v["����ʱ��"] > 0 and v["����ʱ��"] > 0 then
				CastX("������")
			 end
		end

		--��
		if dis() < 12 and v["�ź�ĳ�����ʱ��"] > 4.5  and v["������CD"] > 8 and v["����ʱ��"] > 8 then
			if CastX("���͹�") then
				settimer("���͹�")
			end
		end

		--����
		v["����"] = false

		if v["����ʱ��"] < 2 then
			v["����"] = "����, ����ʱ��쵽��"
		elseif v["�ٽڲ���"] < 3 and v["����ʱ��"] < 3 then
			v["����"] = "����, û3��ٽ�����ʱ��С��3��"
		elseif v["�Ź�������"] then
			v["����"] = "����, �Ź�������"
		end

		if v["����"] then
			if CastX("Ѫ����Ȫ") then
				settimer("�ȴ�����")
				print(v["����"])
				return
			end
		end

		--����
		if dis() < 12 and gettimer("�����⹳") > 0.3 and v["����ʱ��"] > 7 then
			CastX("���л�ת")
		end

		--�ź��
		if v["�ٽڲ���"] < 3 or v["�ٽ�ʱ��"] < 2.5 or v["��ʱ��"] > 3 then
			if CastX("�ź��") then
				settimer("�ź��")	--����п���
			end
		end

		--������
		if dis() < 12 and face() < 60 then
			if v["�ٽڲ���"] >= 3 or v["��ʱ��"] > 1 then
				if aCastX("������") then
					settimer("������")
				end
			end
		end
	end

	---------------------------------------------

	if v["����"] then
		--����
		local nTime = (v["�ź�Ķ���ʱ��"] + 0.0625) * 2 + 0.25
		if v["����CD"] < 1 then
			nTime = nTime + cdinterval(16)
		end

		v["����"] = false
		if dis() < 5 and v["�ź�ĳ�����ʱ��"] <= nTime then	--�ܴ�3����
			v["����"] = "����, ��� * 3 + ��"
			cbuff("�ٽ�")
		elseif dis() > 6 and dis() < 12 and v["Ŀ�꾲ֹ"] and v["��CD"] < 0.1 and v["�ź�ĳ��ܴ���"] >= 1 and v["�ź�ĳ�����ʱ��"] > 5 and v["������CD"] > 8.5 then
			v["����"] = "����, ��� + �� + ��"
		end

		if v["����"] then
			if CastX("��ڤ����") then
				settimer("�ȴ�����")
				print(v["����"])
				return
			end
		end

		--CastX("�������")
		
		--���
		CastX("������")

		--��ɽ
		if v["Ŀ�꾲ֹ"] and v["���CD"] > 0 then
			CastX("��ɽ����")
		end
		
		--�Ǵ�
		if v["���CD"] > 0 and dis() < 6 and face() < 90 then
			CastX("�Ǵ�ƽҰ")
		end
	end

	---------------------------------------------

	if fight() and rela("�ж�") and dis() < 12 and face() < 60 and cdleft(16) <= 0 and castleft() <= 0  and gettimer("�ź��") > 0.3 and gettimer("������") > 0.3 and state("վ��|��·|�ܲ�|��Ծ") then
		PrintInfo("----------û����, ")
	end
end

--�����Ϣ
function PrintInfo(s)
	local szinfo = "���CD:"..v["���CD"]..", �ź��CD:"..v["�ź�ĳ��ܴ���"]..", "..v["�ź�ĳ�����ʱ��"]..", ������CD:"..v["������CD"]..", �����⹳CD:"..v["�����⹳CD"]..", ��CD:"..v["��CD"]..", ����CD:"..v["����CD"]..", ��ɽCD:"..v["��ɽCD"]..", ���:"..v["��ǲ���"]..", "..v["���ʱ��"]..", �ٽ�:"..v["�ٽڲ���"]..", "..v["�ٽ�ʱ��"]..", ����:"..v["����ʱ��"]..", ����:"..v["����ʱ��"]..", ��:" ..v["��ʱ��"]..", "..v["��������ʱ��"]
	if s then
		szinfo = s..szinfo
	end
	print(szinfo)
end

--ʹ�ü��ܲ������Ϣ
function CastX(szSkill)
	if cast(szSkill) then
		if v["�����Ϣ"] then PrintInfo() end
		return true
	end
	return false
end

function aCastX(szSkill)
	if acast(szSkill) then
		if v["�����Ϣ"] then PrintInfo() end
		return true
	end
	return false
end

--�����ͷ�
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		if SkillID == 22327 then	--�ź��
			deltimer("�ź�Ķ�������")
			return
		end
		if SkillID == 22361 then	--��ڤ����
			v["�Ź�������"] = false
			return
		end
		if SkillID == 22320 then	--������
			v["�Ź�������"] = true
			return
		end
	end
end

--buff����
function OnBuff(CharacterID, BuffName, BuffID, BuffLevel, StackNum, SkillSrcID, StartFrame, EndFrame, FrameCount)
	if CharacterID == id() then
		if BuffID == 15524 then	--����
			if StackNum  > 0 then
				deltimer("�ȴ�����")
			else
				deltimer("�ȴ�����")
			end
		end
	end
end

--û�ã��������Ϣ
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
