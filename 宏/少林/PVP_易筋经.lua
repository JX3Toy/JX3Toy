output("��Ѩ: [����][����][����ʽ][����][��ħ�ɶ�][ϵ��][����][����][��Ϣ][Ե��][����][�����ඥ]")

--�����
load("Macro/Lib_PVP.lua")

--������
local v = {}
v["�ȴ�����ͬ��"] = false

--������
local f = {}

--��ѭ��
function Main(g_player)
	--��ʼ��
	g_func["��ʼ��"]()

	--���
	f["���"]()

	--�ȴ�����ͬ��
	if v["�ȴ�����ͬ��"] and gettimer("�ȴ�����ͬ��") < 0.5 then return end
	v["����"] = qidian()


	--jjcĿ��һ���ȴ��˺�
	if jjc() and g_var["Ŀ��һ��"] then
		f["���˺�"]()
	end

	--�����
	if g_var["Ŀ��ɿ���"] and target("player") then
		--����ʽ
		if mounttype("�ڹ�|����") and tbuffstate("�ɷ���") and tbuffstate("����ʱ��") < 0 then
			cast("����ʽ")
		end
		
		if tbuffstate("����ʱ��") < 0 and tbuffstate("ѣ��ʱ��") < 0 and tbuffstate("����ʱ��") < 0 then
			f["�����"]()
		end
	end

	--����
	if fight() then
		if life() < 0.6 then
			cast("�����", true)
		end
		if life() < 0.3 then
			cast("�͹Ǿ�", true)
		end
	end

	--���˺�
	if g_var["Ŀ��ɹ���"] then
		f["���˺�"]()
	end

	--�ҷ�ҡ
	cast("��ҡֱ��")


	if nobuff("������") then
		cast("������", true)
	end

	--�ɼ�������Ʒ
	if nofight() then
		g_func["�ɼ�"](g_player)
	end
end

--�������
OnQidianUpdate = function()
	v["�ȴ�����ͬ��"] = false
end

--�Լ��Ͷ���buff����
function OnBuff(CharacterID, BuffName, BuffID, BuffLevel, StackNum, SkillSrcID, StartFrame, EndFrame, FrameCount)
	if CharacterID == id()  then
		if buffis(BuffID, BuffLevel, "���⹦") then
			bigtext("����Ĭ")
		end
		if buffis(BuffID, BuffLevel, "������") then
			bigtext("������")
		end
		if buffis(BuffID, BuffLevel, "��е") then
			bigtext("����е")
		end
	end
end


f["���"] = function()
	--��ֹ�ظ��Ž��
	if gettimer("��ҵ��Ե") <  0.5 or gettimer("�͹Ǿ�") < 0.5 then return end


	if qixue("�") and buffstate("����ʱ��") > 1 and g_var["ͻ��"] then
		cast("ǧ��׹")
	end

	
	if buffstate("����ʱ��") > 1 or buffstate("ѣ��ʱ��") > 1 or buffstate("����ʱ��") > 1 then
		--��ҵ��Ե
		if cast("��ҵ��Ե", true) then
			settimer("��ҵ��Ե")
			return
		end

		--�͹Ǿ�
		if cast("�͹Ǿ�", true) then
			settimer("�͹Ǿ�")
			return
		end
	end
end


f["���˺�"] = function()

	--������
	if dis() < 6 and nobuff("������|����") and gettimer("������") > 0.5 then
		if cast("������") then
			settimer("������")
			settimer("�ȴ�����ͬ��")
			v["�ȴ�����ͬ��"] = true
			exit()
		end
	end

	if v["����"] >=3 then
		--����ʽ
		if qixue("Ե��") then
			if g_var["ͻ��"] then
				cast("����ʽ")
			end
		else
			cast("����ʽ")
		end

		--Τ������
		cast("Τ������")

		--�޺�����
		if cast("�޺�����") then
			settimer("�ȴ�����ͬ��")
			v["�ȴ�����ͬ��"] = true
			exit()
		end
	end

	if dis() < 5.5 then
		cast("��ɨ����")
	end

	if dis() < 11 then
		acast("�����ඥ")
	end

	cast("��ȱʽ")
	cast("�ն��ķ�")
	cast("����ʽ")
end


f["�����"] = function()

	if dis() < 5 and tbuffstate("��ѣ��") then
		cast("��ʨ�Ӻ�")
	end

	if tbuffstate("�ɻ���") then
		cast("Ħڭ����")
	end

	if g_var["ͻ��"] and tbuffstate("��ѣ��") then
		cast("ǧ��׹")
	end
end
