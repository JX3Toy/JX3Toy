output("----------镇派----------")
output("2 2 3")
output("0 0 2 1")
output("1 1 3 2")
output("0 2 3 0")
output("0 3 3 0")
output("0 1")
output("2 0 3")
output("0 2 0 0")


--变量表
local v = {}
v["回雪读条目标"] = 0

--主循环函数, 每秒调用10+次
function Main(g_player)
	
	--防打断读条
	if casting("玲珑箜篌|左旋右转") then return end
	if casting("回雪飘摇") and castprog() < 0.34 then return end

	--开剑舞
	if nobuff("剑舞") then
		cast("名动四方", true)
	end

	--战斗中才用的辅助技能
	if fight() then
		--回蓝, 减仇恨
		if mana() < 0.83 then
			cast("龙池乐", true)
		end
		--剑舞加满10层
		if buffsn("剑舞") < 3 then
			cast("满堂势", true)
		end
		--重置龙池乐
		if cdtime("龙池乐") > 20 and mana() < 0.6 then
			cast("邻里曲", true)
		end
		--屈柘枝, 会心20% 5层
	end

	if nofight() and nobuff("袖气") then
		cast("婆罗门", true)
	end

	--把治疗目标初始化为自己
	v["治疗目标"] = id()

	--查找团队中血量最少的队友，如果比自己的血量低，就把治疗目标设置为他
	v["血量最少队友"] = party("没状态:重伤", "不是自己", "距离<20", "视线可达", "气血最少")
	if v["血量最少队友"] ~= 0 and xlife(v["血量最少队友"]) < life() then		--找到了，并且血量小于自己的血量
		v["治疗目标"] = v["血量最少队友"]		--治疗目标就设置为他
	end

	--回雪大于1跳，才断
	if castprog() > 0.34 then
		v["断回雪"] = true
	end
	
	--低血量血线
	v["低血量"] = 0.5
	if xmount("洗髓经|铁牢律|明尊琉璃体|铁骨衣", v["治疗目标"]) then
		v["低血量"] = 0.65		--是T的话把血线定高一点
	end

	v["目标血量"] = xlife(v["治疗目标"])

	if v["目标血量"] < v["低血量"] then
		xcast("王母挥袂", v["治疗目标"], true)
		xcast("玲珑箜篌", v["治疗目标"], true)
		xcast("风袖低昂", v["治疗目标"], true)
	end

	_, v["10尺内不满血队友数量"] = party("没状态:重伤", "距离<10", "视线可达", "气血<0.65")
	if v["10尺内不满血队友数量"] > 3 then
		fcast("左旋右转")
	end

	--治疗目标是当前正在读条回血的目标
	if casting("回雪飘摇") and v["治疗目标"] == casttarget() then
		return
	end

	if v["目标血量"] < 0.9 then
		if xbufftime("翔舞", v["治疗目标"]) <= 0 then
			xcast("翔鸾舞柳", v["治疗目标"], true)
		end
	end
	
	if v["目标血量"] < 0.8 then
		if xbufftime("上元点鬟", v["治疗目标"]) <= 0 then
			xcast("上元点鬟", v["治疗目标"], true)
		end
		xcast("回雪飘摇", v["治疗目标"], true)
	end

	

	--给T上持续
	xcast("上元点鬟", party("没状态:重伤", "距离<20", "内功:洗髓经|铁牢律|明尊琉璃体|铁骨衣", "视线可达", "我的buff时间:上元点鬟<0"))
	xcast("翔鸾舞柳", party("没状态:重伤", "距离<20", "内功:洗髓经|铁牢律|明尊琉璃体|铁骨衣", "视线可达", "我的buff时间:翔舞<0"))

	--给T上雨霖铃
	if party("我的buff时间:雨霖铃>0") == 0 then		--团队中没有自己上过雨霖铃的队友, 不加这个判断就会不停刷雨霖铃
		xcast("雨霖铃", party("没状态:重伤", "距离<20", "内功:洗髓经|铁牢律|明尊琉璃体|铁骨衣", "视线可达", "buff时间:雨霖铃<0"))		--把雨霖铃上给还没有雨霖铃的T
	end

	--[[脱战拉人
	if nofight() then
		xcast("妙舞神扬", party("有状态:重伤", "距离<20", "视线可达"))
	end
	--]]
end

----------------------------------------------------------------副本数据记录
local bLog = false

--判断对象是否Boss, 血量大于100万的NPC当作是Boss
local IsBoss = function(CharacterID)
	if CharacterID >= 0x40000000 and xlifemax(CharacterID) > 100 * 10000 then
		return true
	end
	return false
end

--释放技能
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if bLog and dungeon() and IsBoss(CasterID) then
		if TargetType == 2 then
			print("OnCast->["..xname(CasterID).."] 释放:"..SkillName..", 技能ID:"..SkillID..", 技能等级:"..SkillLevel..", 目标位置:"..TargetID.."|"..PosY.."|"..PosZ..", 开始帧:"..StartFrame..", 当前帧:"..FrameCount)
		else
			print("OnCast->["..xname(CasterID).."] 释放:"..SkillName..", 技能ID:"..SkillID..", 技能等级:"..SkillLevel..", 目标ID:"..TargetID..", 开始帧:"..StartFrame..", 当前帧:"..FrameCount)
		end
	end
end

--开始读条
function OnPrepare(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, Frame, StartFrame, FrameCount)
	if bLog and dungeon() and IsBoss(CasterID) then
		if TargetType == 2 then
			print("OnPrepareXYZ->["..xname(CasterID).."] 开始读条:"..SkillName..", 技能ID:"..SkillID..", 技能等级:"..SkillLevel..", 目标位置:"..TargetID.."|"..PosY.."|"..PosZ..", 读条帧数:"..Frame..", 开始帧:"..StartFrame..", 当前帧:"..FrameCount)
		else
			print("OnPrepare->["..xname(CasterID).."] 开始读条:"..SkillName..", 技能ID:"..SkillID..", 技能等级:"..SkillLevel..", 目标ID:"..TargetID..", 读条帧数:"..Frame..", 开始帧:"..StartFrame..", 当前帧:"..FrameCount)
		end
	end
end

--警告信息
function OnWarning(szText)
	if bLog and dungeon() then
		print("OnWarning->"..szText)
	end
end

--npc喊话
function OnSay(Name, SayText, CharacterID)
	if bLog and dungeon() and IsBoss(CharacterID) then
		print("OnSay->["..Name.."]说:"..SayText)
	end
end
