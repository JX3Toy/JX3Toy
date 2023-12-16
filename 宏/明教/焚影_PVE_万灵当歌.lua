--[[ 奇穴:[腾焰飞芒][净身明礼][诛邪镇魔][无明业火][明光恒照][日月同辉][靡业报劫][用晦而明][净体不畏][降灵尊][悬象著明][日月齐光]
秘籍:
日轮	1会心 3伤害
日斩	1会心 2伤害 1静止目标伤害提高
生死劫	2伤害 2距离
破魔	1会心 2伤害 1回20月魂(必须)
月轮	2会心 2伤害
月斩	3会心 1距离或目标伤害降低 不要点5月魂
光明相	3减CD 1回血(或驱散) 不要点回灵
驱夜	2伤害 2会心(或距离)

尽量双100起手, 脱战时会自动隐身回灵到双100
--]]

--关闭自动面向
setglobal("自动面向", false)

--宏选项
addopt("副本防开怪", false)

--变量表
local v = {}
v["记录信息"] = true

--函数表
local f = {}

--主循环
function Main()
	--按下自定义快捷键1挂扶摇, 注意是快捷键设定里面插件的快捷键1指定的按键，不是键盘上的1
	if keydown(1) then
		cast("扶摇直上")
	end

	--减伤
	if fight() and life() < 0.5 and nobuff("贪魔体") then
		cast("贪魔体")
	end

	--初始化变量
	v["日灵"] = sun()
	v["月魂"] = moon()
	v["满日"] = sun_power()
	v["满月"] = moon_power()

	v["GCD间隔"] = cdinterval(503)
	v["日斩CD"] = scdtime("烈日斩")
	v["月斩CD"] = scdtime("银月斩")
	v["生死劫CD"] = scdtime("生死劫")
	v["暗尘CD"] = scdtime("暗尘弥散")
	v["悬象CD"] = scdtime("悬象著明")

	v["目标烈日时间"] = tbufftime("烈日")
	v["目标银月时间"] = tbufftime("银月斩")
	v["明光日"] = bufftime("25758")		--打过满日后添加, 满月加攻击, 1分钟, 放满月时删除
	v["明光月"] = bufftime("25759")		--打过满月后添加, 满日加会心, 1分钟, 放满日时删除
	v["日月灵魂层数"] = buffsn("日月灵魂")
	v["日月灵魂时间"] = bufftime("日月灵魂")	--20秒
	v["日月同辉层数"] = buffsn("日月同辉")		--35秒 3层
	v["日月同辉时间"] = bufftime("日月同辉")
	v["降灵尊时间"] = bufftime("25731")
	v["悬象层数"] = buffsn("25716")
	v["悬象时间"] = bufftime("25716")
	v["日月齐光等级"] = bufflv("25721")		--等级1 伤害+5%, 等级2 伤害+15%, 等级3 伤害+30%, 结束回日月灵 20/60/100
	v["日月齐光时间"] = bufftime("25721")
	
	v["目标血量较多"] = rela("敌对") and tlifevalue() > lifemax() * 10		--目标当前血量大于自己最大血量10倍, 小怪不想开爆发改这个系数

	-------------------------------------------------------
	
	--没进战隐身回灵
	if gettimer("隐身回灵") < 0.75 and v["日灵"] < 100 and v["月魂"] < 100 then
		--print("---------- 等待隐身回灵")
		return
	end

	if nofight() and nobuff("暗尘弥散|4908|11547|12492") then
		--隐身回灵
		if (v["日灵"] < 100 or v["月魂"] < 100) and cdleft(503) <= 0 then
			if CastX("暗尘弥散") then
				settimer("隐身回灵")
				return
			end
		end
		--起手隐身驱夜
		if rela("敌对") and dis() < 20 then
			CastX("暗尘弥散")
		end
	end

	--副本防开怪
	if getopt("副本防开怪") and dungeon() and nofight() then return end

	--打伤害
	if buff("悬象著明·日") then
		f["悬象阶段"]()
	else
		f["正常循环"]()
	end

	--没打技能记录信息
	if fight() and rela("敌对") and dis() < 4 and cdleft(503) <= 0 and nobuff("贪魔体") and state("站立") then
		PrintInfo("----------没打技能")
	end
end

-------------------------------------------------------------------------------

f["悬象阶段"] = function()
	CastX("生死劫")

	if buff("诛邪镇魔") then
		CastX("诛邪镇魔")	--12尺正面, 不消耗悬象
	end
	
	if v["日灵"] < 100 and v["月魂"] < 100 then
		if v["月魂"] < 60 then
			CastX("驱夜断愁")
		end
		CastX("银月斩")
	end

	if bufftime("诛邪镇魔") < 0 then
		CastX("净世破魔击")
	end

	if CastX("幽月轮") then		--正常应该不会打, 加上防止卡在悬象阶段
		print("------------------------------ 悬象中打幽月轮")
	end
end

f["正常循环"] = function()
	if v["目标血量较多"] then

	--悬象著明
	if v["满日"] and v["月魂"] >= 80 then
		if v["日月齐光时间"] > 0 and v["日月齐光等级"] == 1 then
			if (v["日月灵魂时间"] > 0 and v["日月灵魂层数"] >= 2)  or v["日月同辉时间"] > (v["GCD间隔"] + 0.25) * 3 then
				if v["悬象CD"] < v["GCD间隔"] and v["暗尘CD"] < v["GCD间隔"] then
					if rela("敌对") and dis() < 4 and face() < 80 then
						if cdtime("悬象著明") <= 0 and cdtime("暗尘弥散") <= 0 then
							CastX("暗尘弥散")
							CastX("悬象著明")
						end
					end
					return	--除了面向距离，其他条件满足, 先卡在这
				end
			end
		end
	end

	--起手进悬象
	if v["日月齐光等级"] == 1 and v["日月齐光时间"] > v["GCD间隔"] + 0.5 then
		if (v["日月灵魂时间"] > v["GCD间隔"] + 0.5 and v["日月灵魂层数"] >= 2) or v["日月同辉时间"] > (v["GCD间隔"] + 0.25) * 4 then
			if v["日灵"] == 60 and v["月魂"] == 80 and v["暗尘CD"] <= v["GCD间隔"] then
				CastX("烈日斩")
			end
		end
	end

	--准备进悬象, 这里不是很完美, 应该每个月破之后判断进不进悬象, 有空再改
	if v["明光日"] < 0 and v["日灵"] < 100 and v["月魂"] < 100 and v["暗尘CD"] < v["GCD间隔"] * 2 then
		if v["日月齐光等级"] == 1 and v["日月齐光时间"] > v["GCD间隔"] * 2 + 0.5 then
			if (v["日月灵魂时间"] > v["GCD间隔"] * 2 + 0.5 and v["日月灵魂层数"] >= 2) or v["日月同辉时间"] > (v["GCD间隔"] + 0.25) * 4 then
				if rela("敌对") and dis() < 4 and cdleft(503) <= 0 then
					print("--------------------悬象条件满足")
				end

				if v["月魂"] <= 20 then
					f["起手隐身驱夜"]()
					if v["日月同辉层数"] >= 2 then
						CastX("驱夜断愁")
					end
				end

				if v["日灵"] < 60 or v["月魂"] == 80 then
					CastX("烈日斩")
				end

				if v["月魂"] <= 40 then
					CastX("银月斩")
				end

				if v["日灵"] < 60 or v["月魂"] == 80 then
					CastX("赤日轮")
				end

				if v["月魂"] < 80 then
					CastX("幽月轮")
				end

				return
			end
		end
	end

	end

	--斩
	if v["日灵"] < 100 and v["月魂"] < 100 then

		if v["日灵"] < 40 and v["月魂"] < 40 then	--起手隐身驱夜
			f["起手隐身驱夜"]()
		end

		if v["明光日"] > 0 then			--打过满日优先打月
			if v["月魂"] <= 60 then
				CastX("银月斩")
			end
			if v["日灵"] < 60 then
				CastX("烈日斩")
			end
			if v["日月同辉层数"] >= 3 then
				if v["日灵"] <= 20 and v["月魂"] <= 60 and v["暗尘CD"] > 4 then
					CastX("驱夜断愁")
				end
			end
		else							--没打过满日优先打日
			if v["日灵"] <= 60 then
				CastX("烈日斩")
			end
			if v["月魂"] < 60 then
				CastX("银月斩")
			end
			if v["日月同辉层数"] >= 3 then
				if v["月魂"] <= 20 and v["日灵"] <= 60 and v["暗尘CD"] > 4 then
					CastX("驱夜断愁")
				end
			end
		end
	end

	--诛邪镇魔
	if buff("诛邪镇魔") then
		CastX("诛邪镇魔")
	end

	--生死劫
	if  v["日月齐光时间"] > 0 and v["日月齐光等级"] >= 3 then	--悬象后齐光三
		if rela("敌对") and dis() < range("生死劫") and cdtime("生死劫") <= 0 then
			CastX("光明相")
		end
		CastX("生死劫")
	end
	
	if buff("灵·日|魂·月") and v["暗尘CD"] > 13 then	--破魔后
		CastX("生死劫")
	end

	--净世破魔击
	if v["满日"] and cdtime("净世破魔击") <= 0 and rela("敌对") and dis() < 15 then	
		if v["暗尘CD"] < 8 then		--这个时间有待测试
			if cbuff("日月齐光·壹") then
				print("---------- 取消齐光一")
			end
		end
	end
	CastX("净世破魔击")

	--轮
	if v["日灵"] < 100 and v["月魂"] < 100 then
		if v["明光日"] > 0 then		--打过满日
			if v["月魂"] < 60 or v["月魂"] >= 80  then
				CastX("幽月轮")
			end
			if v["日灵"] < 60 then
				CastX("赤日轮")
			end
			CastX("幽月轮")
		else						--没打过满日
			if v["日灵"] < 60 or v["日灵"] >= 80 then
				CastX("赤日轮")
			end
			if v["月魂"] < 60 then
				CastX("幽月轮")
			end
			CastX("赤日轮")
		end
	end
end

f["起手隐身驱夜"] = function()
	if buff("12850") and nobuff("日月同辉") then
		CastX("驱夜断愁")
	end
end

-------------------------------------------------------------------------------

--记录信息
function PrintInfo(s)
	local t = {}
	if s then t[#t+1] = s end
	t[#t+1] = "满日:"..(v["满日"] and "true" or "false")
	t[#t+1] = "满月:"..(v["满月"] and "true" or "false")
	t[#t+1] = "日灵:"..v["日灵"]
	t[#t+1] = "月魂:"..v["月魂"]
	t[#t+1] = "距离:"..format("%0.1f", dis())
	
	t[#t+1] = "日斩CD:"..v["日斩CD"]
	t[#t+1] = "月斩CD:"..v["月斩CD"]
	t[#t+1] = "生死劫CD:"..v["生死劫CD"]
	t[#t+1] = "暗尘CD:"..v["暗尘CD"]
	t[#t+1] = "悬象CD:"..v["悬象CD"]

	--t[#t+1] = "目标烈日:"..v["目标烈日时间"]
	--t[#t+1] = "目标银月:"..v["目标银月时间"]
	t[#t+1] = "明光日:"..v["明光日"]
	t[#t+1] = "明光月:"..v["明光月"]
	t[#t+1] = "日月灵魂:"..v["日月灵魂层数"]..", "..v["日月灵魂时间"]
	t[#t+1] = "日月同辉:"..v["日月同辉层数"]..", "..v["日月同辉时间"]
	t[#t+1] = "降灵尊:"..v["降灵尊时间"]
	t[#t+1] = "悬象:"..v["悬象层数"]..", "..v["悬象时间"]
	t[#t+1] = "日月齐光:"..v["日月齐光等级"]..", "..v["日月齐光时间"]
	
	print(table.concat(t, ", "))
end

--使用技能并记录信息
function CastX(szSkill, bSelf)
	if cast(szSkill, bSelf) then
		settimer(szSkill)
		if v["记录信息"] then
			PrintInfo()
			if szSkill == "净世破魔击" then
				if v["满日"] then
					print("-------------------- 日破")
				else
					print("-------------------- 月破")
				end
				if cdtime("暗尘弥散") <= 0 then
					print("---------------------------------------- 暗尘冷却")
				end
			end
			if szSkill == "生死劫" then
				if v["满日"] then
					print("-------------------- 日劫")
				else
					print("-------------------- 月劫")
				end
			end
			if szSkill == "悬象著明" then
				if v["满日"] then
					print("-------------------- 日悬")
				else
					print("-------------------- 月悬")
				end
			end
		end
		return true
	end
	return false
end

-------------------------------------------------------------------------------

--记录战斗状态改变
function OnFight(bFight)
	if bFight then
		print("--------------------进入战斗")
	else
		print("--------------------离开战斗")
	end
end

--[[ --------- 备忘
同时100 100 先给满月
[光明相] 必会心对生死劫dot有效
[明光恒照] 对生死劫dot有效
[明光恒照] 有Bug, 要打过满日有buff 25758(满月加伤害) 打满月才给buff 25759(满日加会心), 没有 25758 打满月不给 25759
[净体不畏] 伤害部分, 判断目标烈日时谁上的都行, 银月斩要自己上的才有效果, 没什幺影响反正银月斩都要打
[日月齐光] 3种类型, 1破魔 buff 25928, 2生死劫 buff 25929, 3悬象 buff 25930, 有表示没打过
--]]
