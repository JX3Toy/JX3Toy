--[[
奇穴:[騰焰飛芒][淨身明禮][誅邪鎮魔][無明業火][明光恆照][日月同輝][靡業報劫][用晦而明][淨體不畏][降靈尊][懸象著明][日月齊光]
秘籍:
日轮	1会心 3伤害
日斩	1会心 2伤害 1静止伤害提高
生死劫	2伤害 2距离
破魔	2会心 1伤害 1回20月魂(必须)
月轮	2会心 2伤害
月斩	3会心 1距离或目标伤害降低 不要点5月魂
光明相	3减CD 1随便
驱夜	2会心 2伤害

开打前最后一重奇穴切[日月晦]把日灵月魂弄到双100再切回[日月齐光], 懒就算了, 非必须, 有空了再加个手动爆发选项, 0加速下测试, 如果有问题，个别技能冷却剩余时间自行调整
--]]

--关闭自动面向
setglobal("自动面向", false)

--宏选项
addopt("副本防开怪", false)

--变量表
local v = {}
v["输出信息"] = true

--主循环
function Main(g_player)
	--减伤
	if fight() and life() < 0.4 and nobuff("貪魔體") then
		cast("貪魔體")
	end

	--初始化变量
	v["日灵"] = sun()
	v["月魂"] = moon()
	v["满日"] = sun_power()
	v["满月"] = moon_power()

	v["明光日"] = buff("25758")		--打过满日后添加, 满月加攻击, 1分钟, 放满月时删除
	v["明光月"] = buff("25759")		--打过满月后添加, 满日加会心, 1分钟, 放满日时删除, 月破有点问题，有25758才加25759

	v["日月灵魂时间"] = bufftime("日月靈魂")
	v["日月灵魂层数"] = buffsn("日月靈魂")
	v["日月同辉时间"] = bufftime("日月同輝")
	v["日月同辉层数"] = buffsn("日月同輝")
	v["日月齐光时间"] = bufftime("25721")
	v["日月齐光等级"] = bufflv("25721")

	v["隐身CD"] = scdtime("暗塵彌散")
	v["生死劫CD"] = scdtime("生死劫")
	v["悬象CD"] = scdtime("懸象著明")
	v["日斩CD"] = scdtime("烈日斬")
	v["月斩CD"] = scdtime("銀月斬")
	v["GCD时间"] = cdinterval(503)
	v["目标血量较多"] = rela("敌对") and tlifevalue() > lifemax() * 5

	--打伤害
	DPS()

	--目标是敌对, 4尺内, 没打技能输出信息
	if fight() and rela("敌对") and dis() < 4 and cdleft(503) <= 0 and nobuff("貪魔體") then
		PrintInfo("----------没打技能, ")
	end
end

--输出信息
function PrintInfo(s)
	local szSun = v["满日"] and "true" or "false"
	local szMoon = v["满月"] and "true" or "false"
	if s then
		print(s, "日灵:"..v["日灵"], "月魂:"..v["月魂"], "满日:"..szSun, "满月:"..szMoon, "明光日:"..bufftime("25758"), "日月灵魂:"..v["日月灵魂层数"], v["日月灵魂时间"], "日月齐光:"..v["日月齐光等级"], v["日月齐光时间"], "生死劫CD:"..v["生死劫CD"], "隐身CD:"..v["隐身CD"], "日月同辉:"..v["日月同辉层数"], v["日月同辉时间"], "日斩CD:"..scdtime("烈日斬"), "月斩CD:"..scdtime("銀月斬"))
	else
		print("日灵:"..v["日灵"], "月魂:"..v["月魂"], "满日:"..szSun, "满月:"..szMoon, "明光日:"..bufftime("25758"), "日月灵魂:"..v["日月灵魂层数"], v["日月灵魂时间"], "日月齐光:"..v["日月齐光等级"], v["日月齐光时间"], "生死劫CD:"..v["生死劫CD"], "隐身CD:"..v["隐身CD"], "日月同辉:"..v["日月同辉层数"], v["日月同辉时间"], "日斩CD:"..scdtime("烈日斬"), "月斩CD:"..scdtime("銀月斬"))
	end
end

--使用技能
function CastX(szSkill)
	if cast(szSkill) then
		if v["输出信息"] then
			PrintInfo()
		end
		return true
	end
	return false
end

--打伤害
function DPS()
	--没进战先隐身
	if nofight() and rela("敌对") and dis() < 20 and nobuff("暗塵彌散|4908|11547|12492") then
		CastX("暗塵彌散")
	end

	--副本防开怪
	if getopt("副本防开怪") and dungeon() and nofight() then return end
		
	--有日悬
	if buff("懸象著明·日") then
		if bufftime("誅邪鎮魔") <= v["GCD时间"] + 0.125 then
			CastX("誅邪鎮魔")
		end
		CastX("生死劫")
		CastX("誅邪鎮魔")		--12尺正面
		if bufftime("誅邪鎮魔") < 0 then
			CastX("淨世破魔擊")
		end
		if v["月魂"] < 60 then
			CastX("驅夜斷愁")
		end
		if dis() < 4 then
			CastX("銀月斬")
		end
		return
	end

	--悬象
	if v["满日"] and v["月魂"] == 80 then
		if v["日月齐光时间"] > 0 and v["日月齐光等级"] == 1 then
			if v["日月灵魂时间"] > 0  or v["日月同辉时间"] > 4 then
				if v["悬象CD"] <= 0 then
					if rela("敌对") and dis() < 4 and face() < 60 then
						if cdtime("懸象著明") <= 0 then
							CastX("暗塵彌散")
							CastX("懸象著明")
						end
					end
					return	--除了面向距离，其他条件满足
				end
			end
		end
	end
	
	--诛邪时间快到了
	if bufftime("誅邪鎮魔") < v["GCD时间"] + 0.25 then
		CastX("誅邪鎮魔")
	end
	
	--生死劫
	if v["隐身CD"] > 13 then
		--悬象后面
		if v["日月齐光时间"] > v["GCD时间"] + 0.25 and v["日月齐光等级"] >= 3 and v["生死劫CD"] < v["GCD时间"] then
			if v["满日"] or v["满月"] then
				if rela("敌对") and dis() < range("生死劫") and cdtime("生死劫") <= 0 then
					cast("光明相")
				end
				CastX("生死劫")
				return	--等生死劫CD
			end
		end

		if v["日月齐光时间"] > 0 or (v["满日"] and bufftime("日月齊光·月") > 0) or (v["满月"] and bufftime("日月齊光·日") > 0) then
			CastX("生死劫")
		end
	end

	--准备打悬象
	if v["日月齐光时间"] > 2 and v["日月齐光等级"] == 1 and (v["日月灵魂时间"] > 8 or v["日月同辉时间"] > 12) and v["隐身CD"] < 5 then
		if rela("敌对") and dis() < 4 and cdleft(503) <= 0 then
			print("--------------------悬象条件满足")
		end

		if buff("12850") and bufflv("12850") == 1 then	--非战斗隐身驱夜
			if v["月魂"] <= 20 then
				CastX("驅夜斷愁")
			end
		end

		if v["日灵"] < 60 or v["月魂"] == 80 then
			CastX("烈日斬")
		end

		if v["月魂"] <= 40 then
			CastX("銀月斬")
		end

		if v["隐身CD"] < v["GCD时间"] and v["月魂"] <= 20 then
			if v["日月灵魂时间"] > 2 or v["日月同辉层数"] >= 2 then
				CastX("驅夜斷愁")
			end
		end

		if v["日灵"] < 60 then
			CastX("赤日輪")
		end

		if v["月魂"] < 80 then
			CastX("幽月輪")
		end

		if v["月魂"] == 80 then
			CastX("赤日輪")
		end

		return
	end

	--诛邪
	if scdtime("烈日斬") > 0 and scdtime("銀月斬") > 0 then		--日月斩还在冷却
		CastX("誅邪鎮魔")
	end
	if v["满日"] or v["满月"] then		--下一个破前
		CastX("誅邪鎮魔")
	end

	--破魔
	if v["满日"] and v["隐身CD"] < 8 and cdtime("淨世破魔擊") <= 0 then
		if cbuff("25721") then
			print("取消日月齐光，准备进悬象")
		end
	end
	CastX("淨世破魔擊")

	--普通循环回灵
	if v["明光日"] then	--放过满日，打月魂

		CastX("銀月斬")

		if buff("12850") and bufflv("12850") == 1 then	--非战斗隐身驱夜
			if v["日灵"] < 40 then
				CastX("驅夜斷愁")
			end
		end

		if v["日灵"] < 20 and v["月魂"] <= 40 then
			CastX("驅夜斷愁")
		end

		if v["日灵"] < 60 then
			CastX("烈日斬")
		end
		
		if v["月魂"] < 60 then
			CastX("幽月輪")
		end

		if v["日灵"] < 60 then
			CastX("赤日輪")
		end

		CastX("幽月輪")
		
	else	--没放过满日，打日灵

		CastX("烈日斬")

		if buff("12850") and bufflv("12850") == 1 then	--非战斗隐身驱夜
			if v["月魂"] < 40 then
				CastX("驅夜斷愁")
			end
		end

		if v["月魂"] < 60 and v["日斩CD"] > 0 then
			CastX("銀月斬")
		end

		if v["日灵"] < 60 then
			CastX("赤日輪")
		end

		if v["月魂"] < 60  then
			CastX("幽月輪")
		end

		CastX("赤日輪")
	end
end

local tBuff = {
[25731] = "降灵尊",
[25716] = "原名",	--悬象著明
[25721] = "原名",	--日月齐光
[25722] = "原名",	--日月齐光标记
}

--buff更新
function OnBuff(CharacterID, BuffName, BuffID, BuffLevel, StackNum, SkillSrcID, StartFrame, EndFrame, FrameCount)
	--输出自己buff信息
	if CharacterID == id() then
		local szName = tBuff[BuffID]
		if szName then
			if szName ~= "原名" then
				BuffName = szName
			end
			if StackNum  > 0 then
				print("OnBuff->添加buff: ".. BuffName..", ID: "..BuffID..", 等级: "..BuffLevel..", 层数: "..StackNum..", 源ID: "..SkillSrcID..", 开始帧: "..StartFrame..", 当前帧: "..FrameCount..", 结束帧: "..EndFrame..", 剩余时间: "..(EndFrame-FrameCount)/16)
			else
				print("OnBuff->移除buff: ".. BuffName..", ID: "..BuffID..", 等级: "..BuffLevel..", 层数: "..StackNum..", 源ID: "..SkillSrcID..", 开始帧: "..StartFrame..", 当前帧: "..FrameCount)
			end
		end
	end
end
