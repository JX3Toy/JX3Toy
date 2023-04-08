--载入时输出需求的镇派和秘籍
output("----------镇派----------")
output("[花明]2  [寻芳]3  [雷音]2")
output("[云体]2  [龙池]2  [急电]3  [残雪]1")
output("[踏雪寻梅]1  [怒涛]1  [奔浪]2")
output("[淘尽]3  [声趣]2  [云石]1")
output("[山重水复]3")
output("[香疏影]1")
output("[山色]2  [怜光]3")
output("[厌高]2")


--宏选项
--addopt("副本防开怪", true)
addopt("给T探梅", false)


--变量表
local v = {}
v["等待内功切换"] = false


--主循环
function Main(g_player)

	if casting("云飞玉皇") and castleft() < 0.13 then
		settimer("云飞玉皇")
	end

	---------------------------------------------切换内功

	if v["等待内功切换"] and gettimer("啸日") < 0.5 then
		return
	end

	v["切换内功"] = false

	if mount("问水诀") then
		--3层声趣切重剑
		if buffsn("声趣") >= 3 then
			v["切换内功"] = true
		end
	end

	if mount("山居剑意") then
		--脱战切轻剑
		if nofight() then
			v["切换内功"] = true
		end
		
		--剑气不够打一个技能
		if rage() < 15 then
			v["切换内功"] = true
		end

		--啸日不够读条一个技能
		--if bufftime("啸日") < cdinterval(16) and bufftime("香疏影") < cdinterval(16) and nobuff("声趣") then
		if bufftime("啸日") < cdinterval(16) and nobuff("声趣") and (nobuff("剑鸣") or cdtime("断潮") > 1) then
			v["切换内功"] = true
		end
	end

	if v["切换内功"] then
		if cast("啸日") then
			v["等待内功切换"] = true
			settimer("啸日")
			return
		end
	end


	if mount("问水诀") and bufftime("梅隐香") < 21 then
		cast("梅隐香")
	end

	
	--副本防开怪
	--if getopt("副本防开怪") and dungeon() and nofight() then return end

	--打断
	if tbuffstate("可打断") then
		if gettimer("玉虹贯日") > 1 and cast("摘星") then
			settimer("摘星")
		end
		if gettimer("摘星") > 1 and cast("玉虹贯日") then
			settimer("玉虹贯日")
		end
	end


	--爆发
	if rela("敌对") and dis() < 8 and cdleft(16) < 0.5 then		--目标时敌人, 距离小于8尺, GCD快好了
		if tlifevalue() > lifemax() * 3 then		--目标当前血量是自己最大血量3倍
			cast("猛虎下山")
		end
		if mount("山居剑意") and bufftime("啸日") > 10 and tlifevalue() > lifemax() * 10 then
			cast("香疏影")
		end
	end


	---------------------------------------------轻剑
	if mount("问水诀") then
		--给T探梅
		if getopt("给T探梅") and rela("敌对") then
			v["探梅距离"] = 5
			if gettimer("玉虹贯日") > 1 and cdtime("玉虹贯日") < 0.1 then
				v["探梅距离"] = 19
			end
			xcast("探梅", tparty("没状态:重伤", "内功:洗髓经|铁牢律|明尊琉璃体|铁骨衣", "距离<"..v["探梅距离"], "视线可达", "距离最近"))
		end

		if buff("梅隐香") and cdtime("啸日") > 2 then
			cast("断潮")
		end

		if cdtime("啸日") > 8 then
			cast("梦泉虎跑")
		end

		cast("踏雪寻梅")
		
		if acast("黄龙吐翠", 180) then
			return
		end

		cast("听雷")
		--cast("平湖断月")


		if dis() > 8 then
			if cast("玉虹贯日") then
				settimer("玉虹贯日")
			end
		end
	end

	---------------------------------------------重剑
	if mount("山居剑意") then
		if bufftime("啸日") > 3 and rage() < 50 then
			cast("雪断桥")
		end

		_, v["6尺内怪物数量"] = npc("关系:敌对", "距离<6", "可选中")
		if v["6尺内怪物数量"] >= 3 then
			cast("风来吴山")
		end
		
		cast("断潮")
		if gettimer("云飞玉皇") > 0.3 then
			cast("云飞玉皇")
		end
		cast("夕照雷峰")

		if rela("敌对") and dis() > 13 and dis() < 20 then
			acast("鹤归孤山")
		end
	end

end

--换内功时调用
function OnMountKungFu(KungFu, Level)
	v["等待内功切换"] = false
end


local tSkill = {
[1686] = "梅隐香上buff",
[13] = "三柴剑法",
[1797] = "普通攻击命中回气",
}

--释放技能
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if tSkill[SkillID] then return end

	if CasterID == id() then
		--[[
		if TargetType == 2 then		--类型2 是指定位置, 类型 3 4 是指定的NPC和玩家
			print("OnCast->["..xname(CasterID).."] 释放:"..SkillName..", 技能ID:"..SkillID..", 技能等级:"..SkillLevel..", 目标位置:"..TargetID.."|"..PosY.."|"..PosZ..", 开始帧:"..StartFrame..", 当前帧:"..FrameCount)
		else
			print("OnCast->["..xname(CasterID).."] 释放:"..SkillName..", 技能ID:"..SkillID..", 技能等级:"..SkillLevel..", 目标ID:"..TargetID..", 开始帧:"..StartFrame..", 当前帧:"..FrameCount)
		end
		--]]

	end
end
--]]


local tBuff = {
[1739] = "香梅",
}

--[[更新buff
function OnBuff(CharacterID, BuffName, BuffID, BuffLevel, StackNum, SkillSrcID, StartFrame, EndFrame, FrameCount)
	if tBuff[BuffID] then return end

	if CharacterID == id() then
		if StackNum > 0 then
			print("添加buff: "..BuffName, "ID: "..BuffID, "等级: "..BuffLevel, "层数: "..StackNum, "剩余时间:"..((EndFrame - FrameCount) / 16))
		else
			print("移除buff: "..BuffName)
		end
	end
end
--]]
