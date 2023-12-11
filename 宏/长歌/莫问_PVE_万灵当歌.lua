--[[ 奇穴: [飞帆][明津][弦风][流照][豪情][师襄][知止][刻梦][争鸣][云汉][参连][正律和鸣]
秘籍:
宫 2读条 1伤害 1会心
商 2会心 2伤害
徵 2会心 2伤害
羽 2会心 2伤害
--]]

--关闭自动面向
setglobal("自动面向", false)

--宏选项
addopt("副本防开怪", false)

--变量表
local v = {}
v["记录信息"] = true
v["变宫目标"] = 0

--函数表
local f = {}

--主循环
function Main(g_player)
	--按下自定义快捷键1挂扶摇, 注意是快捷键设定里面插件的快捷键1指定的按键，不是键盘上的1
	if keydown(1) then
		cast("扶摇直上")
	end

	if casting("宫|变宫") and castleft() < 0.13 then
		settimer("宫读条结束")
	end
	if casting("徵|变徵") and castleft() < 0.13 then
		settimer("徵读条结束")
	end

	--初始化变量
	v["徵充能次数"] = cn(14067)		--有重名用ID
	v["徵充能时间"] = cntime(14067, true)
	v["羽充能次数"] = cn("羽")
	v["羽充能时间"] = cntime("羽", true)
	v["疏影充能次数"] = cn("疏影横斜")
	v["疏影充能时间"] = cntime("疏影横斜", true)
	v["孤影CD"] = scdtime(14081)		--和回影子重名, 用ID
	v["正律CD"] = scdtime("正律和鸣")
	v["徵读条时间"] = casttime(14067)
	v["宫读条时间"] = casttime(14064)
	v["GCD间隔"] = cdinterval(16)

	v["高山流水"] = buff("9319")	--和主动技能buff重名，用ID
	v["阳春白雪"] = buff("9320")
	v["平沙落雁"] = buff("9322")
	v["目标商时间"] = tbufftime("商", id())
	v["目标角时间"] = tbufftime("角", id())
	v["曲风层数"] = buffsn("24327")
	v["明津时间"] = bufftime("明津")
	v["弦风层数"] = buffsn("弦风")		--24247 最大5层
	v["弦风时间"] = bufftime("弦风")
	v["流照层数"] = buffsn("流照")		--24754 最大32层
	v["流照时间"] = bufftime("流照")
	v["云汉层数"] = buffsn("12576")
	v["云汉时间"] = bufftime("12576")
	v["知音妙意时间"] = bufftime("知音妙意")
	v["影子数量"] = 0
	for i = 3, 8 do
		if buff("999"..i) then
			v["影子数量"] = v["影子数量"] + 1
		end
	end
	v["目标血量较多"] = rela("敌对") and tlifevalue() > lifemax() * 10	--目标当前血量大于自己最大血量10倍, 小怪不想开爆发，改这个系数

	
	--起手高山
	if nofight() and not v["高山流水"] and v["曲风层数"] == 0 and v["正律CD"] <= 0 then
		f["切换到高山流水"]()
	end

	--副本防开怪
	if getopt("副本防开怪") and dungeon() and nofight() then return end
	
	f["孤影化双回"]()

	f["疏影横斜"]()

	--等待宫释放, 曲风层数同步
	if gettimer("宫读条结束") < 0.5 then
		print("---------等待变宫释放", frame())
		return
	end

	--等待曲风切换
	if gettimer("曲风切换") < 0.3 then
		print("---------等待切换曲风", frame())
		return
	end

	--平A进战, 脱战曲风buff删除
	if nofight() then
		CastX("五音六律")
	end

	--徵读条 + 羽 + 宫读条
	v["dot判断时间"] = v["徵读条时间"] + v["GCD间隔"] + v["宫读条时间"] + 0.5

	if v["阳春白雪"] then
		f["阳春白雪曲"]()
	
	elseif bufftime("正律和鸣") > 0 then
		f["正律合奏"]()
	
	elseif v["高山流水"] then
		f["高山流水曲"]()
	
	elseif v["平沙落雁"] then
		f["平沙落雁曲"]()
	end

	--没放技能记录信息，用于排查问题
	if fight() and rela("敌对") and dis() < 20 and face() < 90 and cdleft(16) <= 0 and castleft() <= 0 and gettimer("宫") > 0.5 and gettimer("变宫") > 0.5 and gettimer("徵") > 0.5 and gettimer("变徵") > 0.5 and gettimer("徵读条结束") > 0.5 and state("站立") then
		PrintInfo("---------- 没放技能")
	end
end

---------------------------------------------------------------------------------

f["正律合奏"] = function()	--前4次 2, 3, 5, 6 随机, 最有一次必为4
	if v["正律CD"] > 59 then
		CastX(14229, true)	--高山主动, 和高山流水有0.5秒GCD, 前面可能没放出来
	end

	if v["曲风层数"] == 6 then
		CastX("商")		-- +3
	end

	if v["曲风层数"] == 5 then
		CastX("变宫")	-- +4
	end

	if v["曲风层数"] == 4 then
		if buff("25957") then
			f["切换到阳春白雪"]()
		else
			CastX("羽")	-- +5
		end
	end

	if v["曲风层数"] == 3 then
		CastX("变徵")	-- +6
	end

	if v["曲风层数"] == 2 then
		CastX("角")		-- +2
	end

	--正常不会走到这, 出错或者跑路途中
	CastX("变宫")

end

f["高山流水曲"] = function()
	--进入正律合奏, 孤影 -> 高山主动 -> 正律
	if fight() and v["目标血量较多"] and dis() < 20 and nobuff("正律和鸣") then	--v["曲风层数"] <= 0
		if v["徵充能次数"] > 0 or cntime(14067) <= v["GCD间隔"] then
			if v["正律CD"] < 0.5 then
				CastX(14081)		--孤影化双
				if v["孤影CD"] > 1 then	--孤影后
					CastX(14229, true)	--高山主动
					CastX("正律和鸣")
				end
				return	--正律冷却了就必须进正律
			end
		end
	end

	--切换到阳春白雪
	if v["目标商时间"] > v["dot判断时间"] and v["目标角时间"] > v["dot判断时间"] then
		if gettimer("正律和鸣") > 0.5 and gettimer("孤影化双") > 0.5 then
			if v["曲风层数"] == 0 or v["曲风层数"] == 4 or v["曲风层数"] == 5 then
				f["切换到阳春白雪"]()
			end
		end
	end
	
	--等待变宫释放后目标buff刷新
	if gettimer("释放变宫") < 0.5 and v["变宫目标"] ~= 0 and v["变宫目标"] == tid() then
		print("----------变宫后等待目标buff刷新", frame())
		return
	end
		
	if fight() and gettimer("正律和鸣") > 0.5 and gettimer("孤影化双") > 0.5 then
		if v["目标商时间"] <= v["宫读条时间"] or v["曲风层数"] == 2 then	--上dot 凑曲风
			CastX("商")		-- +3
		end
		if v["目标角时间"] <= v["宫读条时间"] or v["曲风层数"] == 3 then	--上dot 凑曲风
			CastX("角")		-- +2
		end

		if v["曲风层数"] == 0 or v["曲风层数"] == 1 or v["曲风层数"] >= 5 then	--大于5都用变宫修正
			CastX("变宫")	-- +4
		end

		if v["曲风层数"] == 4 then
			CastX("羽")		-- +5
		end
	end
end

f["阳春白雪曲"] = function()
	if v["目标血量较多"] and dis() < 20 and v["正律CD"] < v["GCD间隔"] and nobuff("正律和鸣") and v["徵充能次数"] > 0  then	--切高山, 打正律
		f["切换到高山流水"]()
	end

	if v["曲风层数"] == 0 then
		if v["目标商时间"] < v["dot判断时间"] or v["目标角时间"] < v["dot判断时间"] then	--切高山, 变宫刷新dot
			f["切换到高山流水"]()
		end

		if v["正律CD"] <= v["徵读条时间"] + v["GCD间隔"] and v["徵充能时间"] > 13 then	--正律快冷却徵充能不足，先打羽
			CastX("羽")
		end
		CastX("徵")
		CastX("羽")
	end

	if v["曲风层数"] == 4 then
		CastX("徵")		-- +5
	end

	if v["曲风层数"] == 5 then
		CastX("羽")		-- +4
	end

	--正常情况阳春下应该就是 0 4 5 三种, 防止网络延迟误触等情况下加个宫防止卡在这不打技能
	CastX("宫")		--+3
end

f["平沙落雁曲"] = function()
	f["切换到高山流水"]()		--PVE不打平沙, 如果手动误触进入平沙直接切高山
end

f["切换到阳春白雪"] = function()
	if CastX(14070) then	--和主动重名用ID
		settimer("曲风切换")
		exit()
	end
end

f["切换到高山流水"] = function()
	if CastX(14069) then	--和主动重名用ID
		settimer("曲风切换")
		exit()
	end
end

f["孤影化双回"] = function()
	if casting("徵|变徵") and bufftime("孤影化双") < 0.5 then	--徵读条中 时间快到了，打断
		if fcast(14162) then
			settimer("孤影化双回")
		end
		return
	end

	if bufftime("孤影化双") <= v["宫读条时间"] then	--小于一个变宫读条
		if cast(14162) then
			settimer("孤影化双回")
		end
		return
	end

	if scdtime(14229) > bufftime("孤影化双") and v["正律CD"] > bufftime("孤影化双") then		--高山主动和正律用过了
		if v["影子数量"] >= 6 or cn("疏影横斜") < 1 then	--影子满了或疏影横斜用完了
			if cast(14162) then
				settimer("孤影化双回")
			end
		end
	end
end

f["疏影横斜"] = function()
	if rela("敌对") and v["影子数量"] < 6 then
		local bCast = false
		if gettimer("孤影化双回") > 0.5 and bufftime("孤影化双") > 0 then	--孤影中
			bCast = true
		end
		if buff("正律和鸣") then	--正律中
			bCast = true
		end
		if v["疏影充能次数"] >= 3 then	--充能满了
			bCast = true
		end
		if bCast then
			CastX("疏影横斜")
		end
	end
end

-------------------------------------------------------------------------------

--记录信息
function PrintInfo(s)
	local t = {}
	if s then t[#t+1] = s end
	t[#t+1] = "目标商:"..v["目标商时间"]
	t[#t+1] = "目标角:"..v["目标角时间"]
	t[#t+1] = "曲风层数:"..v["曲风层数"]
	t[#t+1] = "正律时间:"..bufftime("正律和鸣")
	--t[#t+1] = "弦风:"..v["弦风层数"]..", "..v["弦风时间"]
	--t[#t+1] = "流照:"..v["流照层数"]..", "..v["流照时间"]
	t[#t+1] = "知音妙意:"..v["知音妙意时间"]
	t[#t+1] = "影子数量:"..v["影子数量"]
	
	t[#t+1] = "徵CD:"..v["徵充能次数"]..", "..v["徵充能时间"]
	t[#t+1] = "羽CD:"..v["羽充能次数"]..", "..v["羽充能时间"]
	t[#t+1] = "疏影CD:"..v["疏影充能次数"]..", "..v["疏影充能时间"]
	t[#t+1] = "正律CD:"..v["正律CD"]
	t[#t+1] = "孤影CD:"..v["孤影CD"]

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

--释放技能回调
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		if SkillID == 18860 then	--变宫子技能
			v["变宫目标"] = TargetID	--释放时目标buff还没刷新, 记录目标ID
			settimer("释放变宫")
			deltimer("宫读条结束")
		end

		if SkillID == 14474 then	--宫子技能
			deltimer("宫读条结束")
		end

		if SkillID == 34676 then	--知音兴尽, 记录释放信息, 用于查看是不是最高等级，21级伤害最高
			print("--------------------"..SkillName..", 技能ID:"..SkillID..", 技能等级:"..SkillLevel..", 目标ID:"..TargetID..", 开始帧:"..StartFrame..", 当前帧:"..FrameCount)
		end
	end
end

--buff更新回调
function OnBuff(CharacterID, BuffName, BuffID, BuffLevel, StackNum, SkillSrcID, StartFrame, EndFrame, FrameCount)
	if CharacterID == id() and StackNum  > 0 then	--是自己添加buff
		if BuffID == 9319 or BuffID == 9320 or BuffID == 9322 then	--3曲风buff
			deltimer("曲风切换")
		end

		if BuffID == 26001 then
			print("--------------------曲动九州")
		end
	end
end

--buff列表更新回调
function OnBuffList(CharacterID)
	if CharacterID == v["变宫目标"] then
		v["变宫目标"] = 0	--释放变宫的目标buff刷新了, 置0结束等待
	end
end

--记录战斗状态
function OnFight(bFight)
	if bFight then
		print("--------------------进入战斗")
	else
		print("--------------------离开战斗")
	end
end

--[[ 循环
正律和鸣 正确打出合奏
疏影横斜 [云汉]增伤覆盖知音妙意
目标商角不断
非正律合奏时循环  徵徵羽徵羽 - 切高山 - 变宫 - 切阳春 - 徵徵羽徵羽
--]]
