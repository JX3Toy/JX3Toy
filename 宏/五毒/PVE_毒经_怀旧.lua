output("----------����----------")
output("2 3 2")
output("3 2 2 0")
output("2 0 3 1")
output("0 2 3 0")
output("1 2 3 1")
output("0 1")
output("0 3 1")


--��ѡ��
addopt("����������", true)
addopt("���", false)


function Main(g_player)

	--û��ս�����и�Ы��
	if nofight() and nopet("ʥЫ") then
		cast("ʥЫ��")
	end
	
	if nopet() then
		cast("������")
		cast("ʥЫ��")
		if cdtime("������") > 3 and cdtime("ʥЫ��") > 3 then
			cast("�����")
		end
	end

	--����
	if fight() then
		if life() < 0.2 then
			cast("����")
		end
		if life() < 0.6 and pet() then
			cast("��ˮ��")
		end
	end

	--Ŀ�겻�ǵ���, ����
	if not rela("�ж�") then return end

	--����������
	if getopt("����������") and dungeon() and nofight() then return end

	
	--�񱩸��ߣ����뵽�׼��м�
	if pet("����") and xxdis(petid(), tid()) < 4 and lasttime("�Ƴ��׼�") > 2 and lasttime("�Ƴ��׼�") < 10 then
		cast("�Ƴ��")
	end


	--�׼�, ���﹥��
	if pet() then
		if cast("�Ƴ��׼�") then
			settimer("�Ƴ��׼�")
		end

		if gettimer("�Ƴ��׼�") > 0.5 then
			if pettid() ~= tid() then		--�����Ŀ�겻���Լ���Ŀ��
				cast("����")
			end
			cast("�û�")

			if getopt("���") and xxdis(petid(), tid()) < 5.5 then
				cast("���")
			end
		end
	end

	--Ŀ���в����Լ��Ķ�����, ������������
	if tbufftime("������") > 16 and tnobuff("������", id()) then
		cast("�ݲй�")
		cast("���Ĺ�")
	end
	cast("������")

	

	cast("����")
	cast("�Х")
	if tbufftime("��Ӱ", id()) < 4 then
		cast("��Ӱ")
	end
	cast("Ы��")
	cast("ǧ˿")
end


--[[�ͷż���
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		if TargetType == 2 then		--����2 ��ָ��λ��, ���� 3 4 ��ָ����NPC�����
			print("OnCast->["..xname(CasterID).."] �ͷ�:"..SkillName..", ����ID:"..SkillID..", ���ܵȼ�:"..SkillLevel..", Ŀ��λ��:"..TargetID.."|"..PosY.."|"..PosZ..", ��ʼ֡:"..StartFrame..", ��ǰ֡:"..FrameCount)
		else
			print("OnCast->["..xname(CasterID).."] �ͷ�:"..SkillName..", ����ID:"..SkillID..", ���ܵȼ�:"..SkillLevel..", Ŀ��ID:"..TargetID..", ��ʼ֡:"..StartFrame..", ��ǰ֡:"..FrameCount)
		end
	end
end
--]]


--������: ʥЫ, ����, ����, ����, ���, �̵�
