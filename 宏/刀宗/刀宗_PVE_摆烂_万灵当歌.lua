--[[ ��Ѩ: [Ԩ��][Ϯ��][���][���][����][��и][����][����][����][��ب][����][���]
�ؼ�:
����  1���� 3�˺� 
ͣ��  1���� 2�˺� 1��Ϣ
����  2�˺� 2����
����  1���� 2�˺� 1����
����  2���� 2�˺�
����  2���� 2�˺�
�·�  2���� 2�˺�
����  1���� 2�˺� 1����

����Ŀ��4����һ�������������
--]]


--�ر��Զ�����
setglobal("�Զ�����", false)

--��ѡ��
addopt("����������", false)

--������
local v = {}
v["�����Ϣ"] = true

--������
local f = {}

--��ѭ��
function Main()
	--�����Զ����ݼ�1�ҷ�ҡ, ע���ǿ�ݼ��趨�������Ŀ�ݼ�1ָ���İ��������Ǽ����ϵ�1
	if keydown(1) then
		cast("��ҡֱ��")
	end

	--��ʼ������
	v["����"] = energy()
	v["����"] = buff("24029")
	v["˫��"] = buff("24110")
	v["ʶ��ʱ��"] = bufftime("ʶ��")	--24108
	v["Ŀ����������"] = tbuffsn("����", id())	--24056
	v["Ŀ������ʱ��"] = tbufftime("����", id())
	v["��������"] = 0
	v["����ʱ��"] = -100
	for i = 1, 3 do
		local nTime = bufftime("2410"..4 + i)	--24105 24106 24107
		v["����"..i.."ʱ��"] = nTime
		if nTime >= 0 then
			v["��������"] = v["��������"] + 1
			v["����ʱ��"] = nTime
		end
	end
	v["꨷�ʱ��"] = bufftime("꨷�")	--24557

	v["ͣ��CD"] = scdtime("ͣ����")
	v["����CD"] = scdtime("������")
	v["�۷�CD"] = scdtime(32140)		--����������ID
	v["��ӰCD"] = scdtime("��Ӱ׷��")
	v["�η���ܴ���"] = cn("�η�Ʈ��")
	v["�η����ʱ��"] = cntime("�η�Ʈ��", true)
	v["����CD"] = scdtime("���ƶ���")
	v["����CD"] = cdtime("������")
	
	--�ȴ���˫�л�
	if gettimer("������") < 0.3 or gettimer("�·�����") < 0.3 or (qixue("����") and gettimer("��Ӱ׷��") < 0.3) then
		PrintInfo("----------�ȴ���˫�л�, ")
		return
	end

	--����������
	if getopt("����������") and dungeon() and nofight() then return end

	if v["����"] then
		f["����"]()
	end

	if v["˫��"] then
		f["˫��"]()
	end

end

f["����"] = function()
	--������
	if cdleft(2436) >= 1 or v["����"] >= 100 then
		CastX("������")
	end

	--������
	if rela("�ж�") and dis() < range("������", true) and face() < 90 then
		if CastX("������") then
			return
		end
	end

	--������
	if v["����"] <= 15 then
		CastX("������")
	end

	--��3
	if qixue("����") and buff("��Ӱ׷��") then
		CastX("������")
	end
	
	--ͣ����
	if v["����"] <= 45 then
		CastX("ͣ����")
	end

	CastX("������")
end

f["˫��"] = function()
	--�·�����
	if rela("�ж�") and dis() < 6 and face() < 90 then
		if tbuffsn("����", id()) > 2 then
			CastX("��Ӱ׷��")
			if CastX("�·�����") then
				return
			end
		end
	end

	--��������
	if rela("�ж�") and dis() < 6 and face() < 90 then
		CastX("��������")
	end

	--���ƶ���
	CastX("���ƶ���")
end

-------------------------------------------------------------------------------

--�����Ϣ
function PrintInfo(s)
	local t = {}
	if s then t[#t+1] = s end
	t[#t+1] = "����:"..v["����"]
	t[#t+1] = "��Ӱ:"..bufftime("��Ӱ׷��")
	t[#t+1] = "ͣ��CD:"..v["ͣ��CD"]
	t[#t+1] = "����CD:"..v["����CD"]
	t[#t+1] = "����CD:"..v["����CD"]
	t[#t+1] = "����CD:"..v["����CD"]
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

-------------------------------------------------------------------------------

--�ͷż���
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		if SkillID == 36118 then	--��硤Я��
			print("OnCast->�ͷ�:"..SkillName..", ����ID:"..SkillID..", ���ܵȼ�:"..SkillLevel..", Ŀ��ID:"..TargetID..", ��ʼ֡:"..StartFrame..", ��ǰ֡:"..FrameCount)
		end
		
	end
end

--buff����
function OnBuff(CharacterID, BuffName, BuffID, BuffLevel, StackNum, SkillSrcID, StartFrame, EndFrame, FrameCount)
	if CharacterID == id() then
		if StackNum  > 0 then		
			if BuffID == 24110 then		--˫��
				deltimer("������")
				deltimer("��Ӱ׷��")
				print("-------------------- ˫��")
			end
			if BuffID == 24029 then		--����
				deltimer("�·�����")
				print("-------------------- ����")
			end
		end
	end
end
