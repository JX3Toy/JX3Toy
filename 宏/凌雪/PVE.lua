output("奇穴:[秋霁][雪覆][折意][风骨][北阙][渊岳][玄肃][飞刃回转][百节][忘断][徵逐][孤路]")

--宏选项
addopt("副本防开怪", true)

--变量表
local v = {}
v["等待寂洪荒读条结束"] = false

--主循环
function Main(g_player)

	--等待寂洪荒读条结束
	if casting("寂洪荒") and castleft() < 0.13 and cn("寂洪荒") <= 1 then
		settimer("寂洪荒读条结束")
		v["等待寂洪荒读条结束"] = true
	end
	if v["等待寂洪荒读条结束"] and gettimer("寂洪荒读条结束") < 0.5 then
		return
	end

	--等日月吴钩冲刺
	if gettimer("日月吴钩") < 0.3 then return end

	--目标不是敌对结束
	if not rela("敌对") then return end

	--副本防开怪
	if getopt("副本防开怪") and dungeon() and nofight() then return end

	v["寂洪荒读条时间"] = casttime("寂洪荒")

	--岀链
	v["出链"] = false

	--12尺外
	if dis() > 12 then
		v["出链"] = "12尺外"
	end

	--3尺外
	if dis() > 3 and bufftime("忘断") < 1 and cdtime("金戈回澜") <= 0 and cdtime("日月吴钩") < 1 then
		v["出链"] = "3尺外"
	end

	--放过乱天狼
	if dis() > 6 and v["乱天狼CD"] then
		v["出链"] = "放过乱天狼"
	end

	if v["出链"] and gettimer("血覆黄泉") > 1 then
		if cast("血覆黄泉") then
			--输出出链原因
			print(v["出链"])
			settimer("血覆黄泉")
		end
	end

	--收链后退打鞭
	if dis() < 3 and cntime("寂洪荒", true) < v["寂洪荒读条时间"] * 2 + 0.5 and cdtime("乱天狼") < v["寂洪荒读条时间"] * 3 + 0.5  then
		if cdtime("日月吴钩") <= 0 then
			cast("幽冥窥月")
			if nobuff("单链|双链") then
				if cast("日月吴钩") then
					settimer("日月吴钩")
					return
				end
			end
		end
	end

	--金戈回澜
	if tbufftime("链接", id()) > 0.1 then
		cast("金戈回澜")
	end

	--飞刃回转
	if (gettimer("日月吴钩") < 1 or bufftime("忘断") > 6) and bufftime("24744") > 1 then		--24744 孤路额外隐风雷
		if cdtime("飞刃回转") <= 0 then
			cast("飞刃回转")
			return
		end
	end

	--斩无常
	if dis() < 3 and cdtime("日月吴钩") < 6 then
		if cdtime("斩无常") <= 0 then
			cast("幽冥窥月")
		end
		cast("斩无常")
	end

	--鞭
	--if dis() > 6 and dis() < 12 and gettimer("血覆黄泉") > 0.5 and nobuff("单链|双链") then
	if dis() < 12 and gettimer("血覆黄泉") > 0.5 and nobuff("单链|双链") then

		--隐风雷
		v["放隐风雷"] = false
			
		--飞刃回转CD比隐风雷CD久
		if face() < 60 and bufftime("百节") > 0.1 and buffsn("百节") >= 3 and bufftime("忘断") > 0.1 then
			if cdtime("飞刃回转") > 16 then
				v["放隐风雷"] = true
			end
			
			if bufftime("24744") > 0.1 then
				print(cdtime("飞刃回转"), bufftime("24744"))
			end

			if bufftime("24744") > 0.1 and cdtime("飞刃回转") > bufftime("24744") then
				v["放隐风雷"] = true
			end
		end

		--有飞刃
		if npc("关系:自己", "模板ID:107305", "距离<12", "角度<60") ~= 0 then
			v["放隐风雷"] = true
		end

		if v["放隐风雷"] then
			cast("隐风雷")
		end

		--乱天狼
		if buffsn("百节") >= 3 then
			--崔嵬鬼步, 绑定乱天狼
			if bufftime("百节") > 3.5 and buffsn("百节") >= 3 and bufftime("忘断") > 3.5 and cdtime("乱天狼") <= 0 then
				cast("崔嵬鬼步")
			end

			acast("乱天狼")
		end

		--寂洪荒
		cast("寂洪荒")

		acast("乱天狼")
	end


	if dis() < 6 then
		cast("星垂平野")
	end

end


--释放技能
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		--寂洪荒
		if SkillID == 22327 then
			v["等待寂洪荒读条结束"] = false
		end
		--血覆黄泉
		if SkillID == 22274 then
			v["乱天狼CD"] = false
		end
	end
end

--开始读条引导技能(倒读条)
function OnChannel(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, Frame, StartFrame, FrameCount)
	if CasterID == id() then
		--乱天狼
		if SkillID == 22320 and cdtime("乱天狼") > 3 then
			v["乱天狼CD"] = true
		end
	end
end
