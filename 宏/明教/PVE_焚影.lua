output("��Ѩ: [�����â][��������][��а��ħ][����ҵ��][�������][��ҫ�쳾][������ʥ][�û޶���][���岻η][������][����ٻ�][������]")

--������
local v = {}

--��ѭ��
function Main(g_player)
	v["����"] = sun()
	v["�»�"] = moon()

	--���
	if tbuffstate("�ɴ��") then
		cast("����ҫ")
	end

	--��ҹ�ϳ�
	v["����ҹ�ϳ�"] = true
	
	if v["����"] >= 80 and v["�»�"] >= 80 then
		v["����ҹ�ϳ�"] = false
	end
	
	if v["����"] > 80 or v["�»�"] > 80 then
		v["����ҹ�ϳ�"] = false
	end

	if v["����"] >= 80 and v["�»�"] < 60 then
		v["����ҹ�ϳ�"] = false
	end
	if v["����"] < 60 and v["�»�"] >= 80 then
		v["����ҹ�ϳ�"] = false
	end

	if nobuff("�顤��") and v["����ҹ�ϳ�"] then
		cast("��ҹ�ϳ�")
	end

	--��а��ħ
	if v["����"] >= 60 and v["�»�"] >= 60 then
		cast("��а��ħ")
	end

	--������ħ��
	cast("������ħ��")

	--����ն
	if v["����"] < 60 then
		cast("����ն")
	end

	if v["����"] <= 60 and v["�»�"] >= 60 then
		cast("����ն")
	end

	--����ն
	if v["�»�"] < 60 then
		cast("����ն")
	end

	if v["�»�"] <= 60 and v["����"] >= 60 then
		cast("����ն")
	end

	--��
	if v["����"] < 60 then
		cast("������")
	end

	if v["�»�"] < 60 then
		cast("������")
	end

	if buff("�顤��") then
		cast("������")
	end
	
	cast("������")
end

--[[�ͷż���
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		--������ħ������
		if SkillID == 4037 then
			print("----------��")
		end
		--������ħ������
		if SkillID == 4038 then
			print("----------��")
		end
	end
end
--]]

--״̬����
function OnStateUpdate(nCurrentLife, nCurrentMana, nCurrentRage, nCurrentEnergy, nCurrentSunEnergy, nCurrentMoonEnergy)
	--���������仯���
	--print("����: "..nCurrentSunEnergy / 100, "�»�: "..nCurrentMoonEnergy / 100)
end
