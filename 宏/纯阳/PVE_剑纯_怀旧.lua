output("----------镇派----------")
output("2 3 2")
output("2 2 0 3")
output("3 0 0 2")
output("2 0 2 2")
output("2 1 0 1")
output("1 0 1")
output("0 3 2")


--宏选项
addopt("副本防开怪", true)
addopt("留剑飞", true)

--变量表
local v = {}

--等待标志
local bWait = false

--主循环
function Main(g_player)
	if casting("碎星辰") and castleft() < 0.13 then
		settimer("碎星辰读条结束")
	end

	if nofight() then
		if nobuff("吐故纳新") then
			cast("吐故纳新")
		end
		if nobuff("坐忘无我") then
			cast("坐忘无我")
		end
	end

	--目标不是敌人，结束执行
	if not rela("敌对") then return end

	--碎星辰
	v["碎星辰"], v["碎星辰数量"] = tnpc("关系:自己", "名字:气场碎星辰", "距离<5.5", "自己距离<9.5")

	if v["碎星辰数量"] < 3 and qidian() < 8 then
		fcast("碎星辰")
	end

	--副本防开怪
	if getopt("副本防开怪") and dungeon() and nofight() then return end

	--打断
	if tbuffstate("可打断") then
		cast("剑飞惊天")
	end

	--等待气点同步
	if bWait then
		if gettimer("韬光养晦") < 0.3 then return end
		if gettimer("剑飞惊天") < 0.3 then return end
	end

	--剑飞插入GCD打伤害
	if not getopt("留剑飞") and cdleft(16) > 1 and qidian() < 8 and gettimer("韬光养晦") > 0.3 and nobuff("韬光养晦") then
		if cast("剑飞惊天") then
			bWait = true
			settimer("剑飞惊天")
			return
		end
	end


	--爆发
	if dis() < 4 and tlifevalue() > lifemax() * 5 then
		cast("猛虎下山")

		if qidian() < 2 and cdtime("人剑合一") > 5 then
			if cast("韬光养晦") then
				bWait = true
				settimer("韬光养晦")
				return
			end
		end

		if cdtime("碎星辰") > 8 and cdtime("人剑合一") < 5 then
			cast("转乾坤")
		end
	end

	if qidian() >= 8 and mana() < 0.3 then
		cast("抱元守缺")
	end


	if qidian() >= 8 then
		if fcast("无我无剑") then
			cast("凝神聚气")
			return
		end
	end

	if v["碎星辰"] ~= 0 then
	--if v["碎星辰数量"] >= 3 or (v["碎星辰"] ~= 0 and cdtime("碎星辰") > 3) then
		fcast("人剑合一")
	end

	if tbufftime("叠刃", id()) < 5 then
		if fcast("无我无剑") then
			cast("凝神聚气")
			return
		end
	end

	if tlife() > 0.4 and tlife() < 0.6 then
		fcast("八荒归元")
	end
	if tlife() < 0.4 and tbufftime("叠刃", id()) > 12.5 then
		fcast("八荒归元")
	end

	if tbuff("玄一|无相", id()) then
		fcast("天地无极")
	end

	fcast("三环套月")

	if gettimer("碎星辰读条结束") > 0.3 and qidian() < 8 then
		cast("凝神聚气")
	end
end

--气点更新
OnQidianUpdate = function()
	bWait = false
end

--释放技能
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	--[[
	if CasterID == id() then
		if TargetType == 2 then		--类型2 是指定位置, 类型 3 4 是指定的NPC和玩家
			print("OnCast->["..xname(CasterID).."] 释放:"..SkillName..", 技能ID:"..SkillID..", 技能等级:"..SkillLevel..", 目标位置:"..TargetID.."|"..PosY.."|"..PosZ..", 开始帧:"..StartFrame..", 当前帧:"..FrameCount)
		else
			print("OnCast->["..xname(CasterID).."] 释放:"..SkillName..", 技能ID:"..SkillID..", 技能等级:"..SkillLevel..", 目标ID:"..TargetID..", 开始帧:"..StartFrame..", 当前帧:"..FrameCount)
		end
	end
	--]]
end
