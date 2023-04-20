--[[镇派
[隐机]2 [心固]3 [保身]2 
[雨集]2 [解牛]2 [经首]3
[捉影]3 [五方行尽]1 [八荒六合]2
[浮生]1 [雾外江山]1
[期声]1 [全生]2 [羽化]1 [虚实]1
[固本]1 [紫气东来]1
[白虹]3 [无我]2
[相如]1 [临风]1
--]]

--****************************最少1段加速, 1段以上加速1个GCD凝神可以稳定3跳

--关闭自动面向
setglobal("自动面向", false)

--副本中没进战不打技能, 在归墟秘境要关闭
addopt("副本防开怪", false)

--变量表
local v = {}
v["浮生次数"] = 0
v["等待气点同步"] = false

--主循环
function Main()
	--减伤
	if fight() then
		--坐忘无我
		if life() < 0.6 and buffstate("减伤效果") < 40 and nobuff("无我") then
			fcast("坐忘无我")
		end

		--镇山河
		if life() < 0.35 then
			if fcast("镇山河", true) then
				stopmove()
				bigtext("镇山河", 2, 2)
			end
		end
	end

	--归墟秘境
	if tcasting("护体") and castleft() < 0.5 then
		settimer("目标读条护体")
	end
	if gettimer("目标读条护体") < 1 or tbuff("4147") then	--护体 反弹伤害
		stopcasting()
		return
	end

	--八卦洞玄
	if tbuffstate("可打断") and tcastleft() < 1 then
		fcast("八卦洞玄")
	end

	--六合防打断
	if casting("六合独尊") then
		if castleft() < 0.13 then
			settimer("六合独尊读条结束")
		end
		return
	end

	--初始化
	v["气点"] = qidian()
	v["浮生阵眼"] = npc("名字:无形气场", "角色距离<3")
	v["阵眼剩余时间"] = bufftime("51072") - 8
	local tSpeedXY, tSpeedZ = speed(tid())
	v["目标静止"] = tSpeedXY == 0 and tSpeedZ == 0		--xy速度和Z速度都为0
	v["破苍穹距离"], v["破苍穹时间"] = qc("气场破苍穹", id(), id())		--自己周围自己的破苍穹


	--四象读条结束，设置等待气点同步
	if casting("四象轮回") and castleft() < 0.13 and v["气点"] == 7 then
		SetWait()
	end

	--破苍穹
	if rela("敌对") and dis() < 20 then
		if v["破苍穹距离"] > -1 or v["破苍穹时间"] < 1 then		--没有破苍穹或者快出圈了, 距离是自己到气场边缘的距离，在圈外是正数，在圈内是负数
			fcast("破苍穹", true)
		end
	end

	--等待气点同步
	if v["等待气点同步"] and gettimer("等待气点同步") <= 0.25 then
		print("等待气点同步")
		return
	end

	--副本防开怪
	if getopt("副本防开怪") and dungeon() and nofight() then return end

	if tbuff("隐遁") then
		bigtext("目标无敌", 0.5)
		return
	end

	--九转归一, 蹭点伤害
	if cdleft(16) > 0.5 then
		cast("九转归一")
	end

	--凭虚御风
	if fight() and rela("敌对") and dis() < 20 then
		cast("凭虚御风")
	end

	--抱元守缺
	if fight() and mana() < 0.45 and v["气点"] >= 9 then
		if fcast("抱元守缺") then
			fcast("凝神聚气")
		end
	end

	--韬光养晦
	if rela("敌对") and dis() < 20 and bufftime("紫气东来") > 7.5 and cdleft(16) < 0.5 then
		fcast("韬光养晦")
	end

	--两仪化形
	if v["气点"] >= 8 then
		if fcast("两仪化形") then
			fcast("凝神聚气")
		end
	end
	
	--六合独尊
	if rela("敌对") and v["浮生阵眼"] ~= 0 and gettimer("六合独尊读条结束") > 0.5 then
		if v["破苍穹距离"] < -1 and v["破苍穹时间"] > 3 and (v["目标静止"] or v["阵眼剩余时间"] < 5) then
			--紫气东来
			if v["目标静止"] and dis2() < 19.5 and visible() and cdleft(16) <= 0 then	--放六合条件
				if v["浮生次数"] == 0 and v["阵眼剩余时间"] > 3 then		--还能打3次浮生
					if buffsn("经首") >= 5 and bufftime("经首") > 3 then	--5层经首, 觉得没必要就注释掉
						fcast("紫气东来")
					end
				end
			end

			fcast("六合独尊")
		end
	end

	--四象轮回
	if fcast("四象轮回") then
		if buff("雨集") then
			fcast("凝神聚气")
		end
	end

	--太极无极
	if cast("太极无极") then
		cast("凝神聚气")
	end

	--凝神聚气, 1.5秒CD不受加速影响
	if cdleft(16) > 1 then
		cast("凝神聚气")
	end
end

--设置气点等待标志
function SetWait()
	v["等待气点同步"] = true
	settimer("等待气点同步")
	exit()
end

--气点更新
function OnQidianUpdate()
	v["等待气点同步"] = false
	--print("OnQidianUpdate", qidian())
end

--buff更新
function OnBuff(CharacterID, BuffName, BuffID, BuffLevel, StackNum, SkillSrcID, StartFrame, EndFrame, FrameCount)
	if CharacterID == id() and StackNum  > 0 then	--自己 添加
		if BuffID == 51072 then	--每次出现浮生阵眼会添加这个buff
			v["浮生次数"] = 0
		end
	end
end

--释放技能
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetID, nStartFrame, nFrameCount)
	if CasterID == id() then
		if SkillID == 64144 then	--六合独尊·浮生, 每次浮生阵眼出现只生效3次
			v["浮生次数"] = v["浮生次数"] + 1
		end
		--print("OnCast -> ".."技能名: "..SkillName..", ID: "..SkillID..", 等级: "..SkillLevel..", 目标: "..TargetID..", 开始帧: "..nStartFrame..", 当前帧: "..nFrameCount)
	end
end

--NPC进入场景
function OnNpcEnter(NpcID, NpcName, NpcTemplateID, NpcModelID, EmployerID)
	if EmployerID == id() and NpcTemplateID == 201578 then
		print("OnNpcEnter->"..NpcName..", NPCID: "..NpcID..", 模板ID: "..NpcTemplateID..", 表现ID: "..NpcModelID)
	end
end
