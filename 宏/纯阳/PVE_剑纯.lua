output("奇穴: [心固][环月][化三清][无意][风逝][叠刃][长生][裂云][故长][期声][虚极][玄门]")

--变量表
local v = {}

--主循环
function Main(g_player)

	if nofight() and nobuff("坐忘无我") then
		cast("坐忘无我")
	end

	--减伤
	if fight() and life() < 0.5 and buffstate("减伤效果") < 38 and gettimer("坐忘无我") > 0.5 and gettimer("转乾坤") > 0.5 then
		if cast("坐忘无我") then
			settimer("坐忘无我")
			return
		end
		if cast("转乾坤") then
			settimer("转乾坤")
			return
		end
	end

	if casting("碎星辰") and castleft() < 0.13 then
		settimer("碎星辰读条结束")
	end

	--目标不是敌对，直接结束
	if not rela("敌对") then return end


	--紫气
	if dis() < 6 and nobuff("紫气东来") and gettimer("碎星辰读条结束") < 1 and bufftime("14983") > 5 and bufftime("14984") > 5 then
		if cast("紫气东来") then
			cast("凭虚御风")
		end
	end

	--打断
	if dis() < 6 and tbuffstate("可打断") then
		cast("万剑归宗")
	end

	
	_, v["气场数量"] = npc("关系:自己", "名字:气场生太极|气场碎星辰|气场吞日月", "距离<13")
	v["化三清"] = npc("关系:自己", "名字:气场化三清", "距离<15")
	v["碎星辰"] = npc("关系:自己", "名字:气场碎星辰", "距离<13")


	--人剑
	if dis() < 5 and v["气场数量"] >= 3 and v["化三清"] == 0 and cdtime("碎星辰") < 2 then
		cast("人剑合一")
	end

	if v["碎星辰"] == 0 or gettimer("释放人剑合一") < 2 then
		cast("碎星辰")
	end


	if tbuffsn("叠刃", id()) < 7 then
		if qidian() >= 8 then
			cast("无我无剑")
		end
	end

	cast("三环套月")

	if v["气场数量"] < 3 then
		cast("吞日月")
		cast("生太极")
	end

	if qidian() >= 6 then
		cast("无我无剑")
	end

	if mana() < 0.3 then
		cast("化三清", true)
	end

	_, v["周围8尺敌对数量"] = npc("关系:敌对", "距离<8", "可选中")
	if v["周围8尺敌对数量"] >= 3 then
		cast("万剑归宗")
	end

	cast("八荒归元")
end


function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	--如果释放技能的是自己
	if CasterID == id() then
		if SkillID == 588 then
			settimer("释放人剑合一")
		end
	end
end
