output("��Ѩ: [ѪӰ����][��缳��][�������][ǧ��֮��][���Ǹ���][�۾�����][��Ѫ����][ɱ���ϻ�][���ɢӰ][�����ѷ�][��ɫ�ߺ�][���ڤ΢]")

--������
local v = {}

function Main(g_player)
	--��ֹ��Ϲ�
	if gettimer("����") < 0.5 or lasttime("����") < 2 or casting("����") then
		return
	else
		nomove(false)		--�����ƶ�
	end
	
	--����
	if fight() and life() < 0.5 then
		cast("��������")
	end

	if not rela("�ж�") then return end

	--���
	if tbuffstate("�ɴ��") then
		fcast("÷����")
	end

	--����
	if dis() < 20 then
		if nopuppet() or xxdis(pupid(), tid()) > 25 then		--û����������Ŀ�곬��25��
			cast("ǧ����", true)
		end

		--��ɲȺ��
		if puppet("����ǧ�������|����ǧ��������|����ǧ��������") then
			_, v["��10�ߵ�������"] = xnpc(pupid(), "��ϵ:�ж�", "����<10", "��ѡ��")
			if v["��10�ߵ�������"] >= 3 then
				cast("��ɲ��̬")
			end
		end

		--����
		if puppet("����ǧ�������|����ǧ��������") then
			cast("������̬")
		end

		--ʱ��쵽�ˣ�������
		if puppet("����ǧ��������") and gettimer("�ͷ�����") > 115 then
			cast("������̬")
		end
	end

	--�󹥻�
	if puppet("����ǧ��������|����ǧ��������") and puptid() ~= tid() and xxdis(pupid(), tid()) < 25 and xxvisible(pupid(), tid()) then
		cast("����")
	end

	--���ް󶨹�
	if gettimer("�ͷŹ�") < 5 then
		cast("��������")
	end

	--��
	if puppet("����ǧ��������") and gettimer("�ͷ�����") < 80 then	--���ʣ��ʱ�����40��
		if xdis(pupid()) < 4 and tlifevalue() > lifemax() * 10 then		--�Լ�����ľ���С��4�ߣ�Ŀ�굱ǰ����ֵ�����Լ��������ֵ10��(Ŀ�껹û���)
			if cast("����") then
				stopmove()			--ֹͣ�����ƶ�
				nomove(true)		--��ֹ�ƶ�
				settimer("����")
				exit()				--�жϽű�ִ��
			end
		end
	end


	v["���1ʱ��"] = bufftime("24383")
	v["���2ʱ��"] = bufftime("24384")


	--û������, û����CD�Ĺ��
	_, v["����̬�������"] = npc("����:���ڤ΢", "buffʱ��:24389|24391 < -1")	--24389 ������, 24391 10��CD, 3342 ��ɰ���ɱ��(���buff�е�����)
	--print(v["����̬�������"])


	v["����ɱ������"] = 0
	if buff("����ɱ��A") then
		v["����ɱ������"] = v["����ɱ������"] + 1
	end
	if buff("����ɱ��B") then
		v["����ɱ������"] = v["����ɱ������"] + 1
	end
	if buff("����ɱ��C") then
		v["����ɱ������"] = v["����ɱ������"] + 1
	end


	if tstate("վ��|������|ѣ��|����|����|����") then
		if v["����ɱ������"] >= 3 then
			--�����������
			if cn("���ڤ΢") >= 2 or gettimer("�ͷŹ��ڤ΢") < 2 then
				if cast("���ڤ΢") then
					settimer("���ڤ΢")
				end
				return
			end
		end
		
		--û�п���̬����ŵ�
		if gettimer("���ڤ΢") > 0.5 and gettimer("�ͷŹ��ڤ΢") > 2 and v["����̬�������"] <= 0 then
			if cast("����ɱ��") then
				settimer("����ɱ��")
			end
		end

		--������������
		if v["���2ʱ��"] > 10 and v["����̬�������"] >= 2 then
			cast("�������")
		end

		--û�й�������
		if v["���2ʱ��"] < 0 and cntime("���ڤ΢") > 8 and cn("���Ƕ�Ӱ") > 0 then
			cast("�������")
		end
	end

	
	--�Լ��������
	_, v["�������"] = npc("��ϵ:�Լ�|�Ѻ�", "����ID:26112")

	--����
	_, v["����ɱ������"] = tnpc("��ϵ:�Լ�", "����:���ذ���ɱ��", "����<6")
	if gettimer("���ڤ΢") > 0.5 and gettimer("�ͷŹ��ڤ΢") > 2 and v["����ɱ������"] >= 3 and v["�������"] <= 0 and cntime("���ڤ΢") > 8 then
		cast("ͼ��ذ��")
	end

	--�����������
	if buff("����") and gettimer("��Ӱ") > 0.5 then
		if cast(17587) then
			settimer("��Ӱ")
		end
	end

	if nobuff("����") and gettimer("���Ƕ�Ӱ") > 0.5 and cn("���ڤ΢") >= 1 and cntime("���ڤ΢") < 6 and cdtime("�������") > 6 then
		if cast("���Ƕ�Ӱ") then
			settimer("���Ƕ�Ӱ")
		end
		return
	end

	_, v["Ŀ��10�ߵ�������"] = tnpc("��ϵ:�ж�", "����<10", "��ѡ��")
	if tnobuff("��Ѫ", id()) or (v["Ŀ��10�ߵ�������"] >= 3 and energy() > 95) then
		cast("��Ůɢ��")
	end

	if cdtime("����ɱ��") > casttime("�����滨��") then
		if cdtime("�������") > casttime("�����滨��") or (gettimer("���ڤ΢") > 0 and v["���2ʱ��"] < 0) then
			cast("�����滨��")
		end
	end

	if energy() > 80 then
		if cdtime("�������") > casttime("ʴ����") or (gettimer("���ڤ΢") > 0 and v["���2ʱ��"] < 0) then
			cast("ʴ����")
		end
	end
end


--�ͷż���
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		if SkillName == "���ڤ΢" then
			settimer("�ͷŹ��ڤ΢")
		end
		if SkillName == "������̬" then
			settimer("�ͷ�����")
		end
		if SkillID == 3110 then
			settimer("�ͷŹ�")
		end
	end
end
