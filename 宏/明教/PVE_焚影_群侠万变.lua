--[[ ��Ѩ:[�����â][��������][��а��ħ][����ҵ��][�������][����ͬ��][��ҵ����][�û޶���][���岻η][������][��������][�������]
�ؼ�:
����	1���� 3�˺�
��ն	1���� 2�˺� 1��ֹ�˺����
������	2�˺� 2����
��ħ	2���� 1�˺� 1��20�»�(����)
����	2���� 2�˺�
��ն	3���� 1�����Ŀ���˺����� ��Ҫ��5�»�
������	3��CD 1��Ѫ
��ҹ	2���� 2�˺�

����ǰ���һ����Ѩ��[���»�]�������»�Ū��˫100���л�[�������], ��������, �Ǳ���, �п����ټӸ��ֶ�����ѡ��, 0�����²���, ��������⣬��������ȴʣ��ʱ�����е���
--]]

--�ر��Զ�����
setglobal("�Զ�����", false)

--��ѡ��
addopt("����������", false)

--������
local v = {}
v["�����Ϣ"] = true

--��ѭ��
function Main(g_player)
	--����
	if fight() and life() < 0.4 and nobuff("̰ħ��") then
		cast("̰ħ��")
	end

	--��ʼ������
	v["����"] = sun()
	v["�»�"] = moon()
	v["����"] = sun_power()
	v["����"] = moon_power()

	v["������"] = buff("25758")		--������պ����, ���¼ӹ���, 1����, ������ʱɾ��
	v["������"] = buff("25759")		--������º����, ���ռӻ���, 1����, ������ʱɾ��, �����е����⣬��25758�ż�25759

	v["�������ʱ��"] = bufftime("�������")
	v["����������"] = buffsn("�������")
	v["����ͬ��ʱ��"] = bufftime("����ͬ��")
	v["����ͬ�Բ���"] = buffsn("����ͬ��")
	v["�������ʱ��"] = bufftime("25721")
	v["�������ȼ�"] = bufflv("25721")

	v["����CD"] = scdtime("������ɢ")
	v["������CD"] = scdtime("������")
	v["����CD"] = scdtime("��������")
	v["��նCD"] = scdtime("����ն")
	v["��նCD"] = scdtime("����ն")
	v["GCDʱ��"] = cdinterval(503)
	v["Ŀ��Ѫ���϶�"] = rela("�ж�") and tlifevalue() > lifemax() * 5

	--���˺�
	DPS()

	--Ŀ���ǵж�, 4����, û���������Ϣ
	if fight() and rela("�ж�") and dis() < 4 and cdleft(503) <= 0 and nobuff("̰ħ��") then
		PrintInfo("----------û����, ")
	end
end

--�����Ϣ
function PrintInfo(s)
	local szSun = v["����"] and "true" or "false"
	local szMoon = v["����"] and "true" or "false"
	if s then
		print(s, "����:"..v["����"], "�»�:"..v["�»�"], "����:"..szSun, "����:"..szMoon, "������:"..bufftime("25758"), "�������:"..v["����������"], v["�������ʱ��"], "�������:"..v["�������ȼ�"], v["�������ʱ��"], "������CD:"..v["������CD"], "����CD:"..v["����CD"], "����ͬ��:"..v["����ͬ�Բ���"], v["����ͬ��ʱ��"], "��նCD:"..scdtime("����ն"), "��նCD:"..scdtime("����ն"))
	else
		print("����:"..v["����"], "�»�:"..v["�»�"], "����:"..szSun, "����:"..szMoon, "������:"..bufftime("25758"), "�������:"..v["����������"], v["�������ʱ��"], "�������:"..v["�������ȼ�"], v["�������ʱ��"], "������CD:"..v["������CD"], "����CD:"..v["����CD"], "����ͬ��:"..v["����ͬ�Բ���"], v["����ͬ��ʱ��"], "��նCD:"..scdtime("����ն"), "��նCD:"..scdtime("����ն"))
	end
end

--ʹ�ü���
function CastX(szSkill)
	if cast(szSkill) then
		if v["�����Ϣ"] then
			PrintInfo()
		end
		return true
	end
	return false
end

--���˺�
function DPS()
	--û��ս������
	if nofight() and rela("�ж�") and dis() < 20 and nobuff("������ɢ|4908|11547|12492") then
		CastX("������ɢ")
	end

	--����������
	if getopt("����������") and dungeon() and nofight() then return end
		
	--������
	if buff("������������") then
		if bufftime("��а��ħ") <= v["GCDʱ��"] + 0.125 then
			CastX("��а��ħ")
		end
		CastX("������")
		CastX("��а��ħ")		--12������
		if bufftime("��а��ħ") < 0 then
			CastX("������ħ��")
		end
		if v["�»�"] < 60 then
			CastX("��ҹ�ϳ�")
		end
		if dis() < 4 then
			CastX("����ն")
		end
		return
	end

	--����
	if v["����"] and v["�»�"] == 80 then
		if v["�������ʱ��"] > 0 and v["�������ȼ�"] == 1 then
			if v["�������ʱ��"] > 0  or v["����ͬ��ʱ��"] > 4 then
				if v["����CD"] <= 0 then
					if rela("�ж�") and dis() < 4 and face() < 60 then
						if cdtime("��������") <= 0 then
							CastX("������ɢ")
							CastX("��������")
						end
					end
					return	--����������룬������������
				end
			end
		end
	end
	
	--��аʱ��쵽��
	if bufftime("��а��ħ") < v["GCDʱ��"] + 0.25 then
		CastX("��а��ħ")
	end
	
	--������
	if v["����CD"] > 13 then
		--�������
		if v["�������ʱ��"] > v["GCDʱ��"] + 0.25 and v["�������ȼ�"] >= 3 and v["������CD"] < v["GCDʱ��"] then
			if v["����"] or v["����"] then
				if rela("�ж�") and dis() < range("������") and cdtime("������") <= 0 then
					cast("������")
				end
				CastX("������")
				return	--��������CD
			end
		end

		if v["�������ʱ��"] > 0 or (v["����"] and bufftime("������⡤��") > 0) or (v["����"] and bufftime("������⡤��") > 0) then
			CastX("������")
		end
	end

	--׼��������
	if v["�������ʱ��"] > 2 and v["�������ȼ�"] == 1 and (v["�������ʱ��"] > 8 or v["����ͬ��ʱ��"] > 12) and v["����CD"] < 5 then
		if rela("�ж�") and dis() < 4 and cdleft(503) <= 0 then
			print("--------------------������������")
		end

		if buff("12850") and bufflv("12850") == 1 then	--��ս��������ҹ
			if v["�»�"] <= 20 then
				CastX("��ҹ�ϳ�")
			end
		end

		if v["����"] < 60 or v["�»�"] == 80 then
			CastX("����ն")
		end

		if v["�»�"] <= 40 then
			CastX("����ն")
		end

		if v["����CD"] < v["GCDʱ��"] and v["�»�"] <= 20 then
			if v["�������ʱ��"] > 2 or v["����ͬ�Բ���"] >= 2 then
				CastX("��ҹ�ϳ�")
			end
		end

		if v["����"] < 60 then
			CastX("������")
		end

		if v["�»�"] < 80 then
			CastX("������")
		end

		if v["�»�"] == 80 then
			CastX("������")
		end

		return
	end

	--��а
	if scdtime("����ն") > 0 and scdtime("����ն") > 0 then		--����ն������ȴ
		CastX("��а��ħ")
	end
	if v["����"] or v["����"] then		--��һ����ǰ
		CastX("��а��ħ")
	end

	--��ħ
	if v["����"] and v["����CD"] < 8 and cdtime("������ħ��") <= 0 then
		if cbuff("25721") then
			print("ȡ��������⣬׼��������")
		end
	end
	CastX("������ħ��")

	--��ͨѭ������
	if v["������"] then	--�Ź����գ����»�

		CastX("����ն")

		if buff("12850") and bufflv("12850") == 1 then	--��ս��������ҹ
			if v["����"] < 40 then
				CastX("��ҹ�ϳ�")
			end
		end

		if v["����"] < 20 and v["�»�"] <= 40 then
			CastX("��ҹ�ϳ�")
		end

		if v["����"] < 60 then
			CastX("����ն")
		end
		
		if v["�»�"] < 60 then
			CastX("������")
		end

		if v["����"] < 60 then
			CastX("������")
		end

		CastX("������")
		
	else	--û�Ź����գ�������

		CastX("����ն")

		if buff("12850") and bufflv("12850") == 1 then	--��ս��������ҹ
			if v["�»�"] < 40 then
				CastX("��ҹ�ϳ�")
			end
		end

		if v["�»�"] < 60 and v["��նCD"] > 0 then
			CastX("����ն")
		end

		if v["����"] < 60 then
			CastX("������")
		end

		if v["�»�"] < 60  then
			CastX("������")
		end

		CastX("������")
	end
end

local tBuff = {
[25731] = "������",
[25716] = "ԭ��",	--��������
[25721] = "ԭ��",	--�������
[25722] = "ԭ��",	--���������
}

--buff����
function OnBuff(CharacterID, BuffName, BuffID, BuffLevel, StackNum, SkillSrcID, StartFrame, EndFrame, FrameCount)
	--����Լ�buff��Ϣ
	if CharacterID == id() then
		local szName = tBuff[BuffID]
		if szName then
			if szName ~= "ԭ��" then
				BuffName = szName
			end
			if StackNum  > 0 then
				print("OnBuff->���buff: ".. BuffName..", ID: "..BuffID..", �ȼ�: "..BuffLevel..", ����: "..StackNum..", ԴID: "..SkillSrcID..", ��ʼ֡: "..StartFrame..", ��ǰ֡: "..FrameCount..", ����֡: "..EndFrame..", ʣ��ʱ��: "..(EndFrame-FrameCount)/16)
			else
				print("OnBuff->�Ƴ�buff: ".. BuffName..", ID: "..BuffID..", �ȼ�: "..BuffLevel..", ����: "..StackNum..", ԴID: "..SkillSrcID..", ��ʼ֡: "..StartFrame..", ��ǰ֡: "..FrameCount)
			end
		end
	end
end
