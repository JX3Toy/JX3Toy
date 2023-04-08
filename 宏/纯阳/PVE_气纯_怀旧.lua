output("----------镇派----------")
output("2 3 2")
output("2 0 1 3")
output("3 0 0 2")
output("1 0 1 3")
output("1 2 0 1")
output("1 1")
output("0 3 2")
output("0 2 0 0")


--宏选项
addopt("副本防开怪", true)

--变量表
local v = {}

--等待气点同步标志
local bWait = false

--函数表
local f = {}

f["没紫气"] = function()
	return gettimer("紫气东来") > 0.5 and nobuff("紫气东来")
end

--主循环
function Main()

	if nofight() then
		if nobuff("坐忘无我") then
			cast("坐忘无我")
		end
		if nobuff("吐故纳新") then
			cast("吐故纳新")
		end
	end

	--镇山河
	if fight() and life() < 0.35 then
		if fcast("镇山河", true) then
			stopmove()
			bigtext("镇山河", 2, 2)
		end
	end

	--六合防打断
	if casting("六合独尊") then return end


	--蓝少不打断凝神
	if mana() < 0.3 and f["没紫气"]() and casting("凝神聚气") then
		return
	end

	--副本防开怪
	if getopt("副本防开怪") and dungeon() and nofight() then return end

	--打断
	if tbuffstate("可打断") and tcastleft() < 1 then
		cast("八卦洞玄")
	end
	
	--对自己破苍穹
	local pcqdist, pcqtime = qc("气场破苍穹", id(), id())		--自己周围自己的破苍穹
	if rela("敌对") and dis() < 20 then
		if pcqdist > -1 then		--没有破苍穹或者快出圈了, 距离是自己到气场边缘的距离，在圈外是正数，在圈内是负数
			fcast("破苍穹", true)
		end
	end

	--等气点同步
	if bWait and gettimer("韬光养晦") < 0.3 then
		return
	end

	--回蓝
	if fight() and mana() < 0.35 and qidian() >= 8  then
		cast("抱元守缺")
	end


	--副本防开怪
	if dungeon() and nofight() then return end

	--凭虚御风
	if rela("敌对") and dis() < 19 and cdtime("紫气东来") > 60 then
		cast("凭虚御风")
	end

	--紫气
	if rela("敌对") and dis() < 19 and tstate("站立|被击倒|眩晕|定身|锁足|爬起") and tlifevalue() > lifemax() * 10 then
		if (pcqdist < -2 and pcqtime > 12) or cdtime("破苍穹") > 8 then		--在破苍穹里面，破苍穹时间大于12秒 或者刚放过破苍穹(放破苍穹到气场出现有1秒左右延迟)
			if cdtime("六合独尊") < 6 and qidian() >= 8 then		--六合快冷却 马上放两仪
				if fcast("紫气东来") then
					fcast("凭虚御风")
					settimer("紫气东来")
				end
			end
		end
	end

	--有紫气，放韬光
	v["放韬光"] = false
	if rela("敌对") and dis() < 19 and (gettimer("紫气东来") < 0.5 or bufftime("紫气东来") > 2) and qidian() < 5 then
		v["放韬光"] = true
	end
	if v["放韬光"] then
		if fcast("韬光养晦") then
			bWait = true
			settimer("韬光养晦")
			return
		end
	end

	
	--两仪
	if qidian() >= 8 then
		if cast("两仪化形") then
			--if cdtime("韬光养晦") > 0 or not v["放韬光"] then
				cast("凝神聚气")
			--end
		end
	end

	

	--目标到自己方向5尺放六合
	local tSpeedXY, tSpeedZ = speed(tid())
	if rela("敌对") and tSpeedXY <= 0 and tSpeedZ <=0 then	--目标没移动
		--castxyz("六合独尊", point(tid(), 5, 0, tid(), id()))		--目标前方六尺

		if npc("名字:无形气场", "距离<3") ~= 0 then	--改为有无形气场对目标放
			cast("六合独尊")
		end
	end

	if fcast("四象轮回") then
		cast("凝神聚气")
	end

	if fcast("太极无极") then
		cast("凝神聚气")
	end

	if nobuff("坐忘无我") then
		cast("坐忘无我")
	end

	if nobuff("吐故纳新") then
		cast("吐故纳新")
	end
end


--气点更新
OnQidianUpdate = function()
	bWait = false
	--print("OnQidianUpdate", qidian())
end

--释放技能
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetID, nStartFrame, nFrameCount)
	if CasterID == id() then
		--print("OnCast -> ".."技能名: "..SkillName..", ID: "..SkillID..", 等级: "..SkillLevel..", 目标: "..TargetID..", 开始帧: "..nStartFrame..", 当前帧: "..nFrameCount)
	end
end


--气场名: 气场化三清, 气场生太极, 气场破苍穹, 气场冲阴阳, 气场凌太虚, 气场碎星辰, 气场吞日月, 气场镇山河
