output("奇穴: [腾焰飞芒][净身明礼][诛邪镇魔][无明业火][明光恒照][辉耀红尘][超凡入圣][用晦而明][净体不畏][万念俱寂][寂灭劫灰][驱夷逐法]")

--变量表
local v = {}

--主循环
function Main(g_player)
	v["日灵"] = sun()
	v["月魂"] = moon()

	--打断
	if tbuffstate("可打断") then
		cast("寒月耀")
	end

	--驱夜断愁
	v["放驱夜断愁"] = true
	
	if v["日灵"] >= 80 and v["月魂"] >= 80 then
		v["放驱夜断愁"] = false
	end
	
	if v["日灵"] > 80 or v["月魂"] > 80 then
		v["放驱夜断愁"] = false
	end

	if v["日灵"] >= 80 and v["月魂"] < 60 then
		v["放驱夜断愁"] = false
	end
	if v["日灵"] < 60 and v["月魂"] >= 80 then
		v["放驱夜断愁"] = false
	end

	if nobuff("灵·日") and v["放驱夜断愁"] then
		cast("驱夜断愁")
	end

	--诛邪镇魔
	if v["日灵"] >= 60 and v["月魂"] >= 60 then
		cast("诛邪镇魔")
	end

	--净世破魔击
	cast("净世破魔击")

	--烈日斩
	if v["日灵"] < 60 then
		cast("烈日斩")
	end

	if v["日灵"] <= 60 and v["月魂"] >= 60 then
		cast("烈日斩")
	end

	--银月斩
	if v["月魂"] < 60 then
		cast("银月斩")
	end

	if v["月魂"] <= 60 and v["日灵"] >= 60 then
		cast("银月斩")
	end

	--轮
	if v["日灵"] < 60 then
		cast("赤日轮")
	end

	if v["月魂"] < 60 then
		cast("幽月轮")
	end

	if buff("灵·日") then
		cast("幽月轮")
	end
	
	cast("赤日轮")
end

--[[释放技能
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		--净世破魔击·日
		if SkillID == 4037 then
			print("----------日")
		end
		--净世破魔击·月
		if SkillID == 4038 then
			print("----------月")
		end
	end
end
--]]

--状态更新
function OnStateUpdate(nCurrentLife, nCurrentMana, nCurrentRage, nCurrentEnergy, nCurrentSunEnergy, nCurrentMoonEnergy)
	--输出日月灵变化情况
	--print("日灵: "..nCurrentSunEnergy / 100, "月魂: "..nCurrentMoonEnergy / 100)
end
