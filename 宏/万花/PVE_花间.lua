--基本思路: 玉石之间插入2个阳明指, 挂4dot

--载入时，输出信息
output("----------奇穴----------")
output("[弹指][青冠][倚天][踏歌][青歌][雪中行][清流][钟灵][流离][雪弃][焚玉][涓流]")
output("常规秘籍")


--变量表
local v = {}

--等待读条释放标志
local bWait = false

--主循环
function Main(g_player)
	--清心静气
	if nofight() and nobuff("清心静气") then
		cast("清心静气", true)
	end

	--减伤
	if fight() and life() < 0.6 and buffstate("减伤效果") < 36 then
		cast("春泥护花", true)
	end

	--打断
	if tbuffstate("可打断") then
		cast("厥阴指")
	end

	--在读条，快结束
	if casting("阳明指|钟林毓秀|兰摧玉折") and castleft() < 0.13 then
		bWait = true
		settimer("读条结束")
		return
	end

	--等待读条释放
	if bWait and gettimer("读条结束") < 0.3 then
		return
	end

	
	v["商阳时间"] = tbufftime("商阳指", true)
	v["钟林时间"] = tbufftime("钟林毓秀", true)
	v["兰摧时间"] = tbufftime("兰摧玉折", true)
	v["快雪时间"] = tbufftime("快雪时晴", true)
	v["有4dot"] = gettimer("吞海") > 1.2 and v["商阳时间"] > 0 and v["钟林时间"] > 0 and v["兰摧时间"] > 0 and v["快雪时间"] > 0


	if rela("敌对") and dis() < 19 and tlifevalue() > lifemax() * 5 then
		--[星楼月影], 10点墨意
		if rage() < 45 then
			cast("星楼月影")
		end

		--[水月无间], 20点墨意, [布散] 1487
		if rage() < 35 and bufftime("布散") <= 0 then
			cast("水月无间")
		end

		--[乱洒青荷], 重置玉石, 玉石伤害提高30%, 阳明指上兰摧钟林
		if buffsn("逢雪") == 1 and (gettimer("吞海3") < 1 or v["兰摧时间"] <= 0) and (gettimer("吞海1") < 1 or v["钟林时间"] <= 0) then
			cast("乱洒青荷")
		end
	end


	--快雪群怪
	_, v["目标附近敌人数量"] = tnpc("关系:敌对", "距离<6", "可选中")
	if v["目标附近敌人数量"] >= 3 then
		cast("快雪时晴")
	end

	--快雪打出[溅玉]
	if buffsn("逢雪") >= 2 then
		cast("快雪时晴")
	end


	--有4dot, 爆玉石
	if v["有4dot"] then
		--芙蓉并蒂刷新dot, 玉石增伤
		if scdtime("玉石俱焚") < 1 then
			cast("芙蓉并蒂")
		end

		cast("玉石俱焚")
	end

	

	--乱撒阳明指
	if gettimer("乱洒青荷") < 0.5 or buff("乱洒青荷") then
		if gettimer("乱洒兰摧") > 11 then		--判断已经放过乱洒兰摧, 防止重复放阳明指
			cast("阳明指")
		end
	end

	--兰摧玉折
	if gettimer("乱洒兰摧") > 1.2 then
		if gettimer("吞海3") < 1 or v["兰摧时间"] <= 0 then
			cast("兰摧玉折")
		end
	end

	--阳明指消耗墨意触发[雪中行], 打出逢雪
	if buff("水月|行气血") and buffsn("逢雪") < 2 and buffsn("溅玉") < 2 then
		cast("阳明指")
	end

	--钟林毓秀
	if gettimer("乱撒钟林") > 1.2 and gettimer("钟林毓秀释放") > 1.2 then
		if gettimer("吞海1") < 1 or v["钟林时间"] <= 0 then
			cast("钟林毓秀")
		end
	end

	--商阳指
	if gettimer("吞海2") < 1 or v["商阳时间"] <= 0 then
		cast("商阳指")
	end

	--用[商阳指]凑20点墨意，如果不够的话
	if rage() < 20 then
		cast("商阳指")
	end

	--10秒回%60蓝
	if fight() and mana() < 0.45 then
		cast("碧水滔天", true)
	end

end


--[[开始读条
function OnPrepare(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, Frame, StartFrame, FrameCount)
	if CasterID == id() then
		if TargetType == 2 then
			print("OnPrepare->["..xname(CasterID).."] 开始读条:"..SkillName..", 技能ID:"..SkillID..", 技能等级:"..SkillLevel..", 目标位置:"..TargetID.."|"..PosY.."|"..PosZ..", 读条帧数:"..Frame..", 开始帧:"..StartFrame..", 当前帧:"..FrameCount)
		else
			print("OnPrepare->["..xname(CasterID).."] 开始读条:"..SkillName..", 技能ID:"..SkillID..", 技能等级:"..SkillLevel..", 目标ID:"..TargetID..", 读条帧数:"..Frame..", 开始帧:"..StartFrame..", 当前帧:"..FrameCount)
		end
	end
end
--]]


local tSkill = {
[17] = "打坐",
[18730] = "兰摧玉折单一目标",
[285] = "钟林毓秀_正常DOT",
[6693] = "万花_商阳指",
[14644] = "涓流判定目标气血叠加会心效果",
[18722] = "兰摧标记触发奇穴效果",
[14941] = "正常阳明指伤害",
[6126] = "",
[6128] = "",
[6129] = "",
}

--释放技能
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	--如果释放技能的是自己
	if CasterID == id() then
		--[阳明指][钟林毓秀][兰摧玉折]
		if SkillID == 179 or SkillID == 189 or SkillID == 190 then
			bWait = false		--结束等待
			settimer(SkillName.."释放")		--记录释放时间, 用来判断防止重复读条
		end

		--[阳明指]触发[踏歌]吞噬dot, 取余后 等级 1 钟林, 2 商阳, 3 兰摧, 0 快雪, 目标buff同步慢，用这个判断目标没有对应的buff
		if SkillName == "吞海" then
			local level = SkillLevel % 4
			settimer("吞海"..level)		--设置对应技能计时器
			settimer("吞海")			--任意等级吞海，判断4dot不全
		end

		if SkillID == 13847 then		--[阳明指]附带钟林
			settimer("乱撒钟林")
		end

		if SkillID == 13848 then		--[阳明指]附带兰摧
			settimer("乱洒兰摧")
		end
	end

	--[[输出调试信息
	if CasterID == id() then
		--过滤掉不重要的技能
		if tSkill[SkillID] then return end
		
		if TargetType == 2 then
			print("OnCast->["..xname(CasterID).."] 释放:"..SkillName..", 技能ID:"..SkillID..", 技能等级:"..SkillLevel..", 目标位置:"..TargetID.."|"..PosY.."|"..PosZ..", 开始帧:"..StartFrame..", 当前帧:"..FrameCount)
		else
			print("OnCast->["..xname(CasterID).."] 释放:"..SkillName..", 技能ID:"..SkillID..", 技能等级:"..SkillLevel..", 目标ID:"..TargetID..", 开始帧:"..StartFrame..", 当前帧:"..FrameCount)
		end
	end
	--]]

end
--]]


local tBuff = {
[103] = "调息",
[24277] = "万花_脱战能量流失",
[24281] = "万花_脱战能量流失_战斗维持",
[23390] = "NPC助战能量buff",
[11809] = "倚天",
[16756] = "倚天回蓝内置CD",
[12725] = "兰摧监控",
[12727] = "钟林监控A",
[12728] = "商阳指监控标记A",
[12588] = "对兰摧标记目标伤害提高",
[6266] = "行气血",		--[阳明指]瞬发
}

--[[自己和队友buff更新
function OnBuff(CharacterID, BuffName, BuffID, BuffLevel, StackNum, SkillSrcID, StartFrame, EndFrame, FrameCount)
	--过滤掉不重要的buff
	if tBuff[BuffID] then return end

	--输出自己buff
	if CharacterID == id() then
		if StackNum  > 0 then
			print("["..xname(CharacterID).."] 添加buff: ".. BuffName..", ID: "..BuffID..", 等级: "..BuffLevel..", 层数: "..StackNum..", 源ID: "..SkillSrcID..", 开始帧: "..StartFrame..", 当前帧: "..FrameCount..", 结束帧: "..EndFrame..", 剩余时间: "..(EndFrame-FrameCount)/16)
		else
			print("["..xname(CharacterID).."] 移除buff: ".. BuffName..", ID: "..BuffID..", 等级: "..BuffLevel..", 层数: "..StackNum..", 源ID: "..SkillSrcID..", 开始帧: "..StartFrame..", 当前帧: "..FrameCount)
		end
	end
end
--]]
