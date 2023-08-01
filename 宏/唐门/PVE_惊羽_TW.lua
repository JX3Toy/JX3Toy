--[[ 奇穴: [聲若驚雷][千里無痕][寒江夜雨][摧心][狂風暴雨][聚精凝神][逐一擊破][梨花帶雨][秋風散影][白雨跳珠][妙手連環][百里追魂]
秘籍:
暴雨  1会心 2伤害 1效果
夺魄  2读条 1伤害 1会心
追命  2调息 2效果(无视20%外功防御 伤害提高20$)
逐星  1效果(10神机) 3伤害
穿心  1调息 2伤害 1持续
--]]

--关闭自动面向
setglobal("自动面向", false)

--变量表
local v = {}
v["百里目标"] = 0

--函数表
local f = {}

--主循环
function Main(g_player)
	--减伤
	if fight() and life() < 0.5 then
		cast("驚鴻游龍")
	end

	--等待读条技能释放 buff同步
	if casting("奪魄箭") and castleft() < 0.13 then
		settimer("夺魄读条结束")
	end
	if gettimer("夺魄读条结束") < 0.3 then return end

	if casting("暴雨梨花針") and castleft() < 0.13 then
		settimer("暴雨读条结束")
	end
	if gettimer("暴雨读条结束") < 0.35 then return end

	if casting("穿心弩") and castleft() < 0.13 then
		settimer("穿心弩读条结束")
	end
	if gettimer("穿心弩读条结束") < 0.3 then return end
	
	--初始化变量
	local speedXY, speedZ = speed(tid())
	v["目标静止"] = rela("敌对") and speedXY <= 0 and speedZ <= 0
	v["神机值"] = energy()
	v["注能"] = bufflv("26055")	--上次打过的注能技能
	v["目标血量较多"] = rela("敌对") and tlifevalue() > lifemax() * 5

	--心无
	if v["目标静止"] and v["目标血量较多"] and dis() < 25 and cdleft(16) < 0.5 and scdtime(18672) < 15 then		--18672 百里一段
		cast("心無旁騖")
	end

	--起手暴雨
	if nobuff("命隕") then
		f["暴雨梨花针"]()
	end

	--保穿心
	v["目标穿心时间"] = tbufftime("穿心", id())
	if v["目标穿心时间"] > cdinterval(16) + 0.2 and v["目标穿心时间"] < 5 then
		f["穿心弩"]()
	end
	
	f["百里二段"]()
	f["百里一段"]()

	f["追命箭"]()

	if bufftime("心無旁騖") > casttime("暴雨梨花針") or v["神机值"] >= 70 then
		f["暴雨梨花针"]()
	end

	if v["神机值"] >= 70 then
		if tbuffsn("穿心", id()) < 3 or v["目标穿心时间"] < 8.5 then
			f["穿心弩"]()
		end
	end
	
	f["夺魄箭"]()
	f["暴雨梨花针"]()
	f["逐星箭"]()
	f["穿心弩"]()
end

f["百里一段"] = function()
	if v["目标静止"] then
		if cast(18672) then
			v["百里目标"] = tid()	--记录一段目标
		end
	end
end

f["百里二段"] = function()
	if casting("百里追魂") and v["百里目标"] ~= 0 then
		local speedXY, speedZ = speed(v["百里目标"])
		if speedXY > 0 or speedZ > 0 then	--目标动了打二段
			cast(18673)
		end
	end
end

f["暴雨梨花针"] = function()
	if v["注能"] ~= 6 then
		cast("暴雨梨花針")
	end
end

f["追命箭"] = function()
	if buff("追命無聲") and v["注能"] ~= 1 then
		cast("追命箭")
	end
end

f["夺魄箭"] = function()
	if buff("白雨跳珠") and v["注能"] ~= 5 then
		cast("奪魄箭")
	end
end

f["穿心弩"] = function()
	if v["注能"] ~= 4 then
		cast("穿心弩")
	end
end

f["逐星箭"] = function()
	if v["注能"] ~= 3 then
		cast("逐星箭")
	end
end

--释放技能
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	--如果释放技能的是自己
	if CasterID == id() then
		if SkillID == 3095 then		--夺魄箭
			deltimer("夺魄读条结束")
			return
		end
		if SkillID == 3098 then		--穿心弩
			deltimer("穿心弩读条结束")
			return
		end
	end
end

--buff更新
function OnBuff(CharacterID, BuffName, BuffID, BuffLevel, StackNum, SkillSrcID, StartFrame, EndFrame, FrameCount)
	if CharacterID == id() then
		if StackNum > 0 and BuffID == 25901 then	--添加buff 白雨跳珠
			deltimer("暴雨读条结束")
		end
	end
end
