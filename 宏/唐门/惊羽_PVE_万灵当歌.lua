--[[ 奇穴: [声若惊雷][千里无痕][寒江夜雨][摧心][狂风暴雨][聚精凝神][逐一击破][梨花带雨][秋风散影][白雨跳珠][妙手连环][百里追魂]
秘籍:
暴雨  1会心 2伤害 1气魄(必须)
夺魄  2读条 1伤害 1会心
追命  2调息 2效果(无视20%外防 伤害提高20$)
逐星  1效果(10神机) 3伤害
穿心  2调息 1伤害 1持续

推荐1级加速, 无法经常保持10尺外的场景 [秋风散影] 换成 [夺魄之威]
--]]

--关闭自动面向
setglobal("自动面向", false)

--宏选项
addopt("副本防开怪", false)

--变量表
local v = {}
v["记录信息"] = true
v["百里目标"] = 0

--函数表
local f = {}

--主循环
function Main(g_player)
	-- 按下自定义快捷键1交扶摇
	if keydown(1) then
		cast("扶摇直上")
	end

	--减伤
	if fight() and life() < 0.5 then
		cast("惊鸿游龙")
	end
	
	--等待读条技能释放 buff同步
	if casting("暴雨梨花针") and castleft() < 0.13 then
		settimer("暴雨读条结束")
	end
	if gettimer("暴雨读条结束") < 0.5 then return end

	if casting("穿心弩") and castleft() < 0.13 then
		settimer("穿心弩读条结束")
	end

	--初始化变量
	v["神机值"] = energy()
	local speedXY, speedZ = speed(tid())
	v["目标静止"] = rela("敌对") and speedXY <= 0 and speedZ <= 0
	v["目标血量较多"] = rela("敌对") and (target("boss") or tlifevalue() > lifemax() * 10)

	v["GCD间隔"] = cdinterval(16)
	v["暴雨充能次数"] = cn("暴雨梨花针")
	v["暴雨充能时间"] = cntime("暴雨梨花针", true)
	v["追命CD"] = scdtime("追命箭")
	v["逐星充能次数"] = cn("逐星箭")
	v["逐星充能时间"] = cntime("逐星箭", true)
	v["穿心充能次数"] = cn("穿心弩")
	v["穿心充能时间"] = cntime("穿心弩", true)
	v["心无CD"] = scdtime("心无旁骛")
	v["百里CD"] = scdtime("百里追魂")
	
	v["无声层数"] = buffsn("无声")
	v["目标穿心层数"] = tbuffsn("穿心", id())
	v["目标穿心时间"] = tbufftime("穿心", id())
	v["心无时间"] = bufftime("心无旁骛")
	v["注能标记"] = bufflv("26055")			--标记上次打过的注能技能
	v["命陨时间"] = bufftime("命陨")		--[千里无痕] 暴雨完整读条, 攻击+20% 15秒
	v["白雨层数"] = buffsn("白雨跳珠")
	v["白雨时间"] = bufftime("白雨跳珠")
	
	--目标不是敌人 直接结束
	if not rela("敌对") then return end

	--副本防开怪
	if getopt("副本防开怪") and dungeon() and nofight() then return end

	--橙武buff
	if buff("3487") and tbuffsn("星斗阑干", id()) < 3 then
		CastX("逐星箭")
	end

	--穿心弩 保dot
	if v["目标穿心时间"] <= casttime("暴雨梨花针") + v["GCD间隔"] + 0.5 then
		f["穿心弩"]()
	end

	--百里二段
	if casting("百里追魂") and v["百里目标"] ~= 0 then
		local speedXY, speedZ = speed(v["百里目标"])
		if speedXY > 0 or speedZ > 0 then	--目标动了打二段
			CastX(18673)
		end
	end

	--百里一段
	if v["目标静止"] and buff("气魄") then
		if CastX(18672) then
			v["百里目标"] = tid()	--记录一段目标
		end
	end

	--追命箭
	if buff("追命无声") and v["白雨时间"] >= 0 and v["注能标记"] ~= 1 then
		CastX("追命箭")
	end

	--逐星箭
	if v["白雨层数"] >= 2 then	--两层白羽
		f["逐星箭"]()
	end

	--暴雨梨花针
	v["移动键被按下"] = keydown("MOVEFORWARD") or keydown("MOVEBACKWARD") or keydown("STRAFELEFT") or keydown("STRAFERIGHT") or keydown("JUMP")
	if not v["移动键被按下"] and v["注能标记"] ~= 6 then
		--心无旁骛
		if v["目标血量较多"] and dis() < 23 then
			if cdtime("暴雨梨花针") <= 0 and v["神机值"] >= 50 and v["百里CD"] < 16 then	--暴雨前
				CastX("心无旁骛")
			end
		end
		CastX("暴雨梨花针")
	end

	--逐星穿心竞争白雨1层
	if v["追命CD"] > v["GCD间隔"] + 1 + casttime("暴雨梨花针") and v["无声层数"] == 0 then
		f["逐星箭"]()
	end

	if v["神机值"] >= 60 then
		f["穿心弩"]()
	end

	if bufftime("追命无声") > 1 and v["白雨时间"] > 1 and v["追命CD"] < 0.5 then
		--等追命
	else
		f["逐星箭"]()
	end
	
	--没放技能记录信息
	if casting("百里追魂") and castleft() < 0.13 then
		settimer("百里读条结束")
	end
	if fight() and dis() < 25 and state("站立") and cdleft(16) <= 0 and castleft() <= 0 and gettimer("穿心弩") > 0.3 and gettimer("暴雨梨花针") > 0.3 and gettimer(18672) > 0.3 and gettimer("百里读条结束") > 0.3 then
		PrintInfo("----------没放技能")
	end
end

-------------------------------------------------------------------------------

f["穿心弩"] = function()
	if gettimer("穿心弩读条结束") > 0.3 and v["注能标记"] ~= 4 then
		CastX("穿心弩")
	end
end

f["逐星箭"] = function()
	if v["白雨时间"] >= 0 and v["注能标记"] ~= 3 then
		CastX("逐星箭")
	end
end

-------------------------------------------------------------------------------

--记录信息
function PrintInfo(s)
	local t = {}
	if s then t[#t+1] = s end
	t[#t+1] = "神机值:"..v["神机值"]
	t[#t+1] = "无声:"..v["无声层数"]
	t[#t+1] = "穿心:"..v["目标穿心层数"]..", "..v["目标穿心时间"]
	t[#t+1] = "心无:"..v["心无时间"]
	t[#t+1] = "注能:"..v["注能标记"]
	--t[#t+1] = "命陨:"..v["命陨时间"]
	t[#t+1] = "白雨:"..v["白雨层数"]..", "..v["白雨时间"]
	t[#t+1] = "暴雨CD:"..v["暴雨充能次数"]..", "..v["暴雨充能时间"]
	t[#t+1] = "追命CD:"..v["追命CD"]
	t[#t+1] = "逐星CD:"..v["逐星充能次数"]..", "..v["逐星充能时间"]
	t[#t+1] = "穿心CD:"..v["穿心充能次数"]..", "..v["穿心充能时间"]
	t[#t+1] = "百里CD:"..v["百里CD"]
	t[#t+1] = "心无CD:"..v["心无CD"]
	print(table.concat(t, ", "))
end

--使用技能并记录信息
function CastX(szSkill, bSelf)
	if cast(szSkill, bSelf) then
		settimer(szSkill)
		if v["记录信息"] then PrintInfo() end
		return true
	end
	return false
end

-------------------------------------------------------------------------------

--buff更新
function OnBuff(CharacterID, BuffName, BuffID, BuffLevel, StackNum, SkillSrcID, StartFrame, EndFrame, FrameCount)
	if CharacterID == id() then
		if StackNum > 0 then
			if BuffID == 7659 then	--命陨
				deltimer("暴雨读条结束")
			end
			if BuffID == 26055 then
				if BuffLevel == 4 then
					deltimer("穿心弩读条结束")
				end
				if BuffLevel == 5 then
					deltimer("夺魄读条结束")
				end
			end
		end
	end
end

--记录战斗状态改变
function OnFight(bFight)
	if gettimer("进战脱战") > 5 then
		settimer("进战脱战")
		if bFight then
			print("--------------------进入战斗")
		else
			print("--------------------离开战斗")
		end
	end
end

--[[ 备忘
--注能标记buff 26055 对应等级
local tZhuNeng = {
["追命箭"] = 1,
["裂石弩"] = 2,
["逐星箭"] = 3,
["穿心弩"] = 4,
["夺魄箭"] = 5,
["暴雨梨花针"] = 6,
["孔雀翎"] = 7,
["百里追魂"] = 8,
}
--]]
