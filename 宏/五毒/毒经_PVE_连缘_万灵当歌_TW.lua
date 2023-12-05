--[[ 奇穴: [蝎毒][食髓][黯影][虫兽][桃僵][忘情][嗜蛊][曲致][荒息][篾片蛊][引魂][连缘蛊]
秘籍: 优先点调息
蝎心  2伤害 2会心
蛇影  1会心 1持续 2伤害
百足  3调息 1伤害
灵蛊  1距离 3伤害
献祭  2调息

如果你有额外回蓝手段, [桃僵]可以换[重蛊]
靠近15尺内打, 条件允许靠近目标4尺, 不然蛇跑向目标的时间会损失少许dps

蛇影 - 篾片 - 蟾啸 - 献祭 招蛇 蛇影 幻击 - 蛇影 - 百足 - 蝎心 - 连缘 - 蛇影 - 蝎心 ...
--]]

--关闭自动面向
setglobal("自动面向", false)

--宏选项
addopt("副本防开怪", false)
addopt("打断", false)
addopt("自动吃鼎", false)

--变量表
local v = {}
v["输出信息"] = true

--主循环
function Main()
	--按下自定义快捷键1挂扶摇, 注意是快捷键设定里面插件的快捷键1指定的按键，不是键盘上的1
	if keydown(1) then
		cast("扶摇直上")
	end

	--[[连缘防打断, 前0.5秒禁止移动, 影响躲技能先注释掉
	if gettimer("連緣蠱") < 0.5 then
		return
	else
		nomove(false)	--允许移动
	end
	--]]

	--初始化变量
	v["蝎心时间"] = tbufftime("蠍心", id())	--12秒
	v["蛇影时间"] = tbufftime("蛇影", id())	--18秒
	v["蛇影层数"] = tbuffsn("蛇影", id())
	v["百足时间"] = tbufftime("百足", id())	--18秒
	v["蟾啸时间"] = tbufftime("蟾嘯", id())	--14秒
	v["献祭时间"] = bufftime("靈蛇獻祭")	--12
	v["嗜蛊时间"] = bufftime("嗜蠱")	--15秒
	v["引魂时间"] = bufftime("引魂")	--10秒
	v["百足CD"] = scdtime("百足")
	v["蟾啸CD"] = scdtime("蟾嘯")
	v["灵蛇引CD"] = scdtime("靈蛇引")
	v["献祭CD"] = scdtime("蠱蟲獻祭")
	v["灵蛇&献祭CD"] = math.max(v["灵蛇引CD"], v["献祭CD"])
	v["篾片蛊CD"] = scdtime("篾片蠱")
	v["连缘蛊CD"] = scdtime("連緣蠱")
	v["幻击CD"] = scdtime(36292)
	v["GCD间隔"] = cdinterval(16)
	v["连缘蛊读条时间"] = casttime("连缘蛊")
	

	--减伤
	if fight() and pet() and life() < 0.6 then
		cast("玄水蠱")
	end

	--凤凰蛊
	if qixue("荒息") then
		if rela("敌对") and dis() < 30 then
			if nobuff("鳳凰蠱") or nofight() then
				CastX("鳳凰蠱")
			end
		end
	end

	--召蛇
	if nopet("靈蛇") then
		CastX("靈蛇引")
	end

	--副本防开怪
	if getopt("副本防开怪") and dungeon() and nofight() then return end

	---------------------------------------------

	--灵蛊
	if rela("敌对") then
		v["放灵蛊"] = false
		if qixue("重蠱") and tbufftime("奪命蠱") < 2 then
			v["放灵蛊"] = true
		end
		if cn("靈蠱") > 1 then
			v["放灵蛊"] = true
		end
		if getopt("打断") and tbuffstate("可打断") then
			v["放灵蛊"] = true
		end
		if v["放灵蛊"] then
			local bLog = setglobal("记录技能释放", false)
			cast("靈蠱")
			if bLog then setglobal("记录技能释放", true) end
		end
	end

	--宠物攻击
	if pet() and rela("敌对") then
		local bLog = setglobal("记录技能释放", false)
		cast("攻擊")
		if bLog then setglobal("记录技能释放", true) end
	end

	--幻击
	if pet() and v["蛇影层数"] >= 2 then
		if v["连缘蛊CD"] > 12 + v["GCD间隔"] * 3 then
			CastX("幻擊")
		end
	end

	--蛇影 献祭前
	if v["连缘蛊CD"] <= v["GCD间隔"] * 7 and v["蛇影时间"] < v["GCD间隔"] * 3 + 0.5  then	--v["献祭时间"]
		if CastX("蛇影") then
			print("---------- 献祭或连缘前")
		end
	end

	--篾片蛊 献祭前
	if rela("敌对") and dis() < 15 then
		if v["连缘蛊CD"] <= v["GCD间隔"] * 6 and v["灵蛇&献祭CD"] <= v["GCD间隔"] * 2  then	--献祭前
			CastX("篾片蠱")
		end
	end

	--蟾啸, 献祭前
	if dis() < 15 and v["连缘蛊CD"] <= v["GCD间隔"] * 5 and v["灵蛇&献祭CD"] <= v["GCD间隔"] then
		CastX("蟾嘯")
	end

	--献祭召蛇
	if pet() and rela("敌对") and dis() < 15 and v["连缘蛊CD"] <= v["GCD间隔"] * 4 then
		if cdtime("靈蛇引") <= 0 then
			if CastX("蠱蟲獻祭") then
				if CastX("靈蛇引") then
					self().ClearCDTime(16)
				end
			end
		end
	end

	--蛇影 幻击 献祭后
	if gettimer("蠱蟲獻祭") < 1 then
		if CastX("蛇影") then
			CastX("幻擊")
		end
	end

	--蛇影 连缘前
	if v["连缘蛊CD"] <= v["GCD间隔"] * 3 and v["蛇影时间"] <= v["GCD间隔"] * 3 + v["连缘蛊读条时间"] then
		if CastX("蛇影") then
			print("--------- 连缘前")
		end
	end

	--百足
	if rela("敌对") then
		if v["连缘蛊CD"] <= v["GCD间隔"] * 2 or v["连缘蛊CD"] > 15 + v["GCD间隔"] then
			CastX("百足")
			if v["百足CD"] < 0.5 then	--等百足CD
				if cdleft(16) <= 0 then
					PrintInfo("---------- 等百足CD")
				end
				return
			end
		end
	end

	--蝎心 连缘前
	if v["连缘蛊CD"] <= v["GCD间隔"] and v["蝎心时间"] <= v["GCD间隔"] + v["连缘蛊读条时间"] then
		CastX("蠍心")
	end

	--连缘蛊, 开始释放时判断dot数量, 每跳判断dot数量, buff 19513 等级代表dot数量
	v["移动键被按下"] = keydown("MOVEFORWARD") or keydown("MOVEBACKWARD") or keydown("STRAFELEFT") or keydown("STRAFERIGHT") or keydown("JUMP")
	if not v["移动键被按下"] then	--没在移动
		v["放连缘蛊"] = false

		v["最短dot时间"] = math.min(v["蝎心时间"], v["蛇影时间"], v["百足时间"], v["蟾啸时间"])
		if v["献祭时间"] > v["连缘蛊读条时间"] and v["最短dot时间"] > v["连缘蛊读条时间"] then
			v["放连缘蛊"] = true	--所有条件都满足
		end

		if v["献祭时间"] > 0 and v["献祭时间"] <= v["连缘蛊读条时间"] + v["GCD间隔"] * 2 then
			v["放连缘蛊"] = true	--献祭时间快到了, dot不满足也打
		end

		if v["放连缘蛊"] then
			if CastX("連緣蠱") then
				stopmove()		--停止移动
				--nomove(true)	--禁止移动
				exit()
			end
		end
	end

	--蝎心
	if bufftime("24479") > 0 then	--有破招
		CastX("蠍心")
	end
	
	--上1层蛇影
	if v["蛇影层数"] < 1 or v["蛇影时间"] < 2.5  then
		CastX("蛇影")
	end

	--蟾啸
	if v["连缘蛊CD"] > 12 + v["GCD间隔"] * 5  then
		CastX("蟾嘯")
	end

	if qixue("荒息") and rela("敌对") and dis() < 30 and nobuff("鳳凰蠱") then
		CastX("鳳凰蠱")
	end

	--蛇影
	CastX("蛇影")


	--吃鼎
	if getopt("自动吃鼎") and nobuff("蠱時") and cdleft(16) > 0.5 then
		if life() < 0.7 or mana() < 0.8 then
			interact("仙王蠱鼎")
		end
	end
end

-------------------------------------------------

--输出信息
function PrintInfo(s)
	local t = {}
	if s then t[#t+1] = s end
	t[#t+1] = "蝎心:"..v["蝎心时间"]
	t[#t+1] = "蛇影:"..v["蛇影层数"]..", "..v["蛇影时间"]
	t[#t+1] = "百足:"..v["百足时间"]
	t[#t+1] = "蟾啸:"..v["蟾啸时间"]
	t[#t+1] = "引魂:"..v["引魂时间"]
	t[#t+1] = "献祭:"..v["献祭时间"]
	t[#t+1] = "嗜蛊:"..v["嗜蛊时间"]

	t[#t+1] = "灵蛇&献祭CD:"..v["灵蛇&献祭CD"]
	t[#t+1] = "百足CD:"..v["百足CD"]
	t[#t+1] = "蟾啸CD:"..v["蟾啸CD"]
	t[#t+1] = "幻击CD:"..v["幻击CD"]
	t[#t+1] = "连缘蛊CD:"..v["连缘蛊CD"]

	print(table.concat(t, ", "))
end

--使用技能并输出信息
function CastX(szSkill, bSelf)
	if cast(szSkill, bSelf) then
		settimer(szSkill)
		if v["输出信息"] then PrintInfo() end
		return true
	end
	return false
end

-------------------------------------------------

--释放技能
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		if SkillID == 2226 then
			print("------------------------------ 蛊虫献祭")	--打印分割线方便查看每个循环技能释放情况
		end

		if SkillID == 29573 then	--篾片蛊
			if SkillID < 5 or v["引魂时间"] <= 0 then
				print("----------篾片蛊不是5级或没在引魂期间", SkillName, SkillID, SkillLevel)
			end
		end
	end
end

--战斗状态改变, 日志记录一下用于分析数据
function OnFight(bFight)
	if bFight then
		print("--------------------进入战斗")
	else
		print("--------------------离开战斗")
	end
end
