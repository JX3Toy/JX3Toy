--[[ ��Ѩ: [����][���][б�򹷱�][�޽�][���][ԽԨ][�¾�][����][����][����][����][�Ǹ�����]
�ؼ�:
�� 1���� 3�˺�
��Ȯ 2���� 2�˺�
���� 2���� 2�˺�
��ս 1���� 3�˺�
���� 1���� 2�˺� 1�������
��Ծ 2CD 1������ 1�˺�
���� 3�˺� 1Ŀ�����
��Х ��������
������ 2CD 2���� ����, ��Ȼѭ������������

ѭ��:
�Ⱦ� - ���� - ˫�� - ����(�Ǹ�) - ���� - ���� - ʱ�� - ����
�� - Ȯ�� - ���� - ��ս
��Ȯ - ���� - ˫�� - ���� - ���� - ���� - ʱ�� - ����
���� - ��Ծ - б�� - �Ⱦ�

��ľ׮���У�ʵսѭ�����ܻ���, �п���Ū, �ŵ���������в���ѭ��, վ׮����������ȥ
--]]

--������
local v = {}
v["�����Ϣ"] = true

--������
local f = {}

--ʹ�ü��ܣ����������Ϣ
local CastX = function(szSkill)
	if cast(szSkill) then
		if v["�����Ϣ"] then
			print("��:"..format("%0.3f",mana()), "��Ӱʱ��:"..v["��Ӱʱ��"], "����ʱ��:"..v["����ʱ��"], "�޽�ʱ��:"..v["�޽�ʱ��"], "ӯ��ʱ��:"..v["ӯ��ʱ��"], "��ʱ��:"..v["��ʱ��"], "��CD:"..scdtime("����·"), "��ȮCD:"..scdtime("��Ȯ����"), "����CD:"..scdtime("�����л�"), "��CD:"..scdtime("������"), "ʱ��CD:"..scdtime("ʱ������"))
		end
		return true
	end
	return false
end

f["������"] = function()
	if cast("������") then
		if v["�����Ϣ"] then
			print("��:"..format("%0.3f",mana()), "��Ӱʱ��:"..v["��Ӱʱ��"], "����ʱ��:"..v["����ʱ��"], "�޽�ʱ��:"..v["�޽�ʱ��"], "ӯ��ʱ��:"..v["ӯ��ʱ��"], "��ʱ��:"..v["��ʱ��"], "��CD:"..scdtime("����·"), "��ȮCD:"..scdtime("��Ȯ����"), "����CD:"..scdtime("�����л�"), "��CD:"..scdtime("������"), "ʱ��CD:"..scdtime("ʱ������"))
		end
		stopmove()			--ֹͣ�ƶ�
		nomove(true)		--��ֹ�ƶ�
		settimer("������")
		exit()
	end
end

--��ѭ��
function Main(g_player)
	--����
	if fight() and life() < 0.5 then
		cast("��Х����")
	end

	if casting("������") and castleft() < 0.13 then
		settimer("�����ɶ�������")
	end

	--�ȾƷ����
	if gettimer("������") < 0.5 or casting("������") then
		return
	else
		nomove(false)	--�����ƶ�
	end

	--��ʼ������
	v["��ʱ��"] = bufftime("��������")
	v["��Ӱʱ��"] = bufftime("25904")
	v["����ʱ��"] = bufftime("����������")
	v["�޽�ʱ��"] = bufftime("�޽�")
	v["ӯ��ʱ��"] = bufftime("ӯ��")
	v["������CD"] = scdtime("������")
	v["���е�"] = g_player.nSurplusPowerValue

	if not rela("�ж�") then return end		--Ŀ�겻�ǵжԽ���
	if gettimer("ʱ������") < 0.25 then return end	--ʱ��ûGCD����΢����
	if buff("22483") then return end	--�ȴ��Ǹ���̽���

	--�Ⱦƶ��������ȴ���ͬ��
	if gettimer("�����ɶ�������") < 0.5 and mana() < 0.85 then
		print("�Ⱦƺ�ȴ���ͬ��")
		return
	end

	if buff("��������") then
		f["�о�"]()
	else
		if mana() > 0.35 then
			f["������"]()
		end

		--û�о�buff, �ȴ������׶�һ��
		CastX("��������")
		CastX("�������")
		CastX("˫��ȡˮ")
		if mana() > 0.75 then
			CastX("��������")
		end
		
		--û�ƻ������ﲻ���Ⱦ�����
		CastX("������ͷ")
		CastX("���ع���")
		CastX("б�򹷱�")
	end
end

f["�о�"] = function()
	--�Ǹ�, ��������Ȯ��
	if gettimer("�ͷſ����л�") < 1 or gettimer("�ͷ���Ȯ����") < 1 then
		CastX("�Ǹ�����")
	end

	--Ȯ��
	CastX("Ȯ������")

	--����
	if dis() < 5 then
		CastX("��������")
	end

	--����
	if mana() > 0.7 and buff("5986") then
		CastX("�����л�")
	end

	--����
	if gettimer("�ͷ�����2") < 1 or buff("5987") then	--����������δ��꣬����buff��ûͬ��
		CastX("��������")
		return
	end

	--����
	if buff("5986") then
		CastX("�������")
		return
	end

	--˫��
	if gettimer("�ͷ�˫��ȡˮ") > 1.5 and buff("5985") then
		CastX("˫��ȡˮ")
		return
	end

	--����
	if nobuff("5985|5986|5987") then	--û��234��buff
		if mana() >= 0.85 or (mana() >= 0.75 and gettimer("�����ɶ�������") < 0.5) then
			if v["��Ӱʱ��"] < 15 or v["������CD"] > 20 then
				CastX("��������")
			end
		end
		if mana() >= 0.3 and v["��Ӱʱ��"] < 8 then
			CastX("��������")
		end
	end
	
	--����
	if mana() > 0.7 then
		CastX("�����л�")
	end

	--ʱ��
	if mana() >= 0.225 and dis() < 5 and cdleft(590) <= 0 and nobuff("5985|5986|5987") then
		if CastX("ʱ������") then
			settimer("ʱ������")
			exit()
		end
	end

	--��
	--if dis() < 6 and face() < 60 and mana() < 0.85 and v["������CD"] > 12.5 then
	if dis() < 6 and mana() < 0.85 and v["������CD"] > 12.5 then
		if acast("����·") then
			if v["�����Ϣ"] then
				print("��:"..format("%0.3f",mana()), "��Ӱʱ��:"..v["��Ӱʱ��"], "����ʱ��:"..v["����ʱ��"], "�޽�ʱ��:"..v["�޽�ʱ��"], "ӯ��ʱ��:"..v["ӯ��ʱ��"], "��ʱ��:"..v["��ʱ��"], "��CD:"..scdtime("����·"), "��ȮCD:"..scdtime("��Ȯ����"), "����CD:"..scdtime("�����л�"), "��CD:"..scdtime("������"), "ʱ��CD:"..scdtime("ʱ������"))
			end
		end
	end

	--��ս
	--if gettimer("�ͷſ����л�") < 3.5 and nobuff("��ս��Ұ") and v["����ʱ��"] < 5 then
	if mana() > 0.6 and nobuff("5989|5985|5986|5987") and nobuff("��ս��Ұ") and v["����ʱ��"] < 5 then
		CastX("��ս��Ұ")
	end

	--��Ȯ
	if mana() < 0.85 and scdtime("����·") > 1 and v["������CD"] > 7 then
		CastX("��Ȯ����")
	end

	--�Ⱦ�
	if mana() >= 0.35 and nobuff("5989|5985|5986|5987") then	--û��ʱ��2��, ����234��
		--if scdtime("��Ȯ����") < 17.5 and scdtime("ʱ������") < 9.4375 then
		if scdtime("ʱ������") < 9.4375 then
			f["������"]()
		end
	end
	
	if v["������CD"] <= 0 and nobuff("5989|5985|5986|5987") then
		CastX("����ͷ")
		CastX("��Ծ��Ԩ")
	end
	
	CastX("б�򹷱�")

	--��������򣬱��û���
	CastX("������ͷ")
	CastX("���ع���")
end

--�ͷż���
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		if SkillID == 5367 then		--����
			if bufftime("25904") > -1 and bufftime("25904") < 6.5 then	--����Ӱ ʱ�䲻������һ�� ��ȡ��
				cbuff("25904")
				print("--------------------------ȡ����Ӱ")
			end
			return
		end
		if SkillID == 5638 then		--����
			settimer("�ͷſ����л�")
			return
		end
		if SkillID == 5257 then		--��Ȯ
			settimer("�ͷ���Ȯ����")
			return
		end
		if SkillID == 6363 then	--�����˺�2
			settimer("�ͷ�����2")
			return
		end
		if SkillID == 5368 then
			settimer("�ͷ�˫��ȡˮ")
			return
		end
	end
end
