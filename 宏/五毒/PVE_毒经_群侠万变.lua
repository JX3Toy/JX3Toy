--[[ ��Ѩ: [��β][�޳�][��Ӱ][����][�ҽ�][����][�ȹ�][����][��Ϣ][��Ƭ��][���][��Ϥ]
�ؼ�:
Ы��  2���� 2�˺�
��Ӱ  1���� 1���� 2�˺�
����  1��Ϣ 3�˺�
���  1���� 3�˺�
�׼�  2��Ϣ
--]]

--��ϵ�Զ�����
setglobal("�Զ�����", false)

--��ѡ��
addopt("����������", false)
addopt("���", false)

--��ѭ��
function Main()
	--����
	if fight() and pet() and life() < 0.5 then
		if cast("��ˮ��") then
			settimer("��ˮ��")
		end
	end

	--��˹�
	if qixue("��Ϣ") then
		if rela("�ж�") and dis() < 30 then
			if nobuff("��˹�") or nofight() then
				cast("��˹�")
			end
		end
	end

	--�ٱ���
	if nopet("����") or (buff("23063") and not qixue("����")) then		--23063, �׼����б�����GCD
		cast("������")
	end

	--Ŀ�겻�ǵжԣ�����
	if not rela("�ж�") then return end

	--����������
	if getopt("����������") and dungeon() and nofight() then return end

	--���
	if tnobuff("���Ĺ�|�ݲй�|������", id()) or cn("���") > 1 then
		cast("���")
	end
	if getopt("���") and tbuffstate("�ɴ��") then
		cast("���")
	end

	--�г���
	if pet() then
		cast("����")
		cast("�û�")

		--�Ƴ��׼�
		if rela("�ж�") and dis() < 20 and cdleft(16) <= 1 and cdleft(16) >= 0.5 then 
			if qixue("����") or (scdtime("������") <= 0 and nobuff("��ˮ��") and gettimer("��ˮ��") > 0.5) then
				if qixue("��Ϣ") then
					if buff("��˹�", id()) then
						cast("�Ƴ��׼�")
					end
				else
					cast("�Ƴ��׼�")
				end
			end
		end
	end

	--�ȴ���������
	if casting() and castleft() < 0.13 then settimer("�ȴ���������") end
	if gettimer("�ȴ���������") < 0.3 then return end

	
	--Ŀ��û��Ӱ
	if tbufftime("��Ӱ", id()) <= 1.625 then	--1.625��û��ʲô���⺬�壬���ִ�Ĵ���һ��GCD
		cast("��Ӱ")
	end

	--��Ƭ��
	cast("��Ƭ��")

	--������buff
	if buff("24479") then
		cast("Ы��")
	end

	--��Ӱ����ܽ���
	if cntime("��Ӱ", true) < 3 then
		cast("��Ӱ")
	end
	
	--����
	cast("����")

	if tbufftime("�Х", id()) <= 1.625 then
		cast("�Х")
	end

	cast("��Ӱ")
	cast("�Х")
	cast("��˹�")
	cast("Ы��")
end

--�ͷż���
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	--����ͷż��ܵ����Լ�
	if CasterID == id() then
		if SkillID == 13430 then	--��Ӱ
			deltimer("�ȴ���������")
			return
		end

		if SkillID == 2209 then		--Ы��
			deltimer("�ȴ���������")
			return
		end

		if SkillID == 29573 then	--��Ƭ��
			print("OnCast", SkillName, SkillID, SkillLevel)	--���ڲ鿴����Ǽ���
			return
		end
	end
end
