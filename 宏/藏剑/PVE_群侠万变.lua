--[[ 奇穴: [淘尽][清风][岱宗][景行][映波锁澜][怜光][层云][撼岳][雾锁][碧归][如风][飞来闻踪]
秘籍:
九溪  2伤害 2范围
黄龙  2伤害 2效果(剑气)
云飞  2读条 1伤害 1会心
夕照  1读条 2伤害 1会心
风来  3伤害 1会心
听雷  2会心 2伤害
啸日  1效果(剑气) 3持续
云栖松 2调息 1效果(回剑气)
--]]

--关闭自动面向
setglobal("自动面向", false)

--变量表
local v = {}

--函数表
local f = {}

--主循环
function Main(g_player)
	--减伤
	if fight() and life() < 0.5 then
		cast("泉凝月")
	end
	
	if casting("云飞玉皇") and castleft() < 0.13 then
		settimer("云飞读条结束")
	end

	if gettimer("切换内功") < 0.3 then return end
	if gettimer("冲刺") < 0.3 then return end

	--初始化变量
	v["剑气"] = rage()
	v["九溪啸日冷却"] = scdtime("九溪弥烟") < 0.125 and cntime("啸日", true) < 0.25
	v["九溪啸日没冷却"] = scdtime("九溪弥烟") > 3 or cntime("啸日", true) > 3
	v["风来吴山NPC"] = npc("关系:自己", "模板ID:57739")
	v["有风来吴山"] = v["风来吴山NPC"] ~= 0 and xnpc(v["风来吴山NPC"], "关系:敌对", "距离<10", "可选中") ~= 0
	v["没风来吴山"] = v["风来吴山NPC"] == 0 or xnpc(v["风来吴山NPC"], "关系:敌对", "距离<10", "可选中") == 0
	local speedXY, speedZ = speed(tid())
	v["目标静止"] = rela("敌对") and speedXY <= 0 and speedZ <= 0
	v["目标血量较多"] = rela("敌对") and tlifevalue() > lifemax() * 5
	v["飞来CD"] = cdleft(1832)	--scdtime("飞来闻踪") 切换内功完成瞬间极少情况下会报错, 直接用CooldownID
	
	--------------------------------------------- 轻剑
	if mount("问水诀") then
		if rela("敌对") and dis() < 6 then
			if v["剑气"] >= 90 then
				f["啸日"]()
			end

			if scdtime("九溪弥烟") > 1 and scdtime("黄龙吐翠") > 1 then
				f["啸日"]()
			end
		end

		if rela("敌对") and dis2() < 5 then
			cast("九溪弥烟")
		end

		if scdtime("九溪弥烟") > 0 then
			cast("听雷")
		end

		if cdleft(16) >= 0.5 then
			if acast("黄龙吐翠", 180) then
				settimer("冲刺")
				exit()
			end
		end

		if cast("玉虹贯日") then
			settimer("冲刺")
			exit()
		end
	end

	--------------------------------------------- 重剑
	if mount("山居剑意") then
		--保底切轻剑
		if v["九溪啸日冷却"] and v["剑气"] < 15 then
			f["啸日"]("剑气小于15点")
		end

		--风来吴山群攻
		_, v["10尺内敌人数量"] = npc("关系:敌对", "距离<9", "可选中")
		if v["10尺内敌人数量"] >= 3 then
			cast("风来吴山")
		end

		--云飞
		if gettimer("云飞读条结束") > 0.25 and bufftime("雾锁") > casttime("云飞玉皇") then
			cast("云飞玉皇")
		end

		--轻剑回剑气
		if v["九溪啸日冷却"] and v["剑气"] < 35 then
			f["啸日"]("切轻剑回剑气")
		end

		--回剑气
		f["回剑气"]()
		
		--听雷补惊雷
		if rela("敌对") and v["风来吴山NPC"] ~= 0 and xdis(v["风来吴山NPC"], tid()) < 10 then
			if tbufftime("惊雷", id()) < xbufftime("12340", v["风来吴山NPC"]) + 0.25 then
				cast("听雷")
			end
		end

		--有碧归打夕照
		if bufftime("碧归") > casttime("夕照雷峰") then
			cast("夕照雷峰")
		end

		--听雷补凤鸣
		if bufftime("凤鸣") < casttime("夕照雷峰") then
			cast("听雷")
		end

		--夕照
		cast("夕照雷峰")

		--备胎
		cast("听雷")
	end

end

f["啸日"] = function(szReason)
	if cast("啸日") then
		if szReason then print("啸日: "..szReason) end
		settimer("切换内功")
		exit()
	end
end

f["回剑气"] = function()
	if rela("敌对") and dis() < 6 then
		if v["九溪啸日没冷却"] and gettimer("莺鸣柳") > 0.75 and v["剑气"] < 60 then
			if gettimer("风来吴山") > 1 and gettimer("飞来闻踪") > 0.5 and gettimer("云栖松") > 0.5 then
				if nobuff("青松|26053") and v["没风来吴山"] then	--buff 26053 有飞来
				
					--风来吴山
					if v["目标静止"] and v["目标血量较多"] then
						if cntime("莺鸣柳", true) < 8 and cdtime("风来吴山") <= 0 then
							if cast("莺鸣柳") then
								settimer("莺鸣柳")
							end
						end
						if cast("风来吴山") then
							settimer("风来吴山")
							return
						end
					end

					--飞来闻踪
					if cast("飞来闻踪") then
						settimer("飞来闻踪")
						return
					end

					--莺鸣柳
					if v["飞来CD"] > 1 and scdtime("风来吴山") > 1 then
						if cast("莺鸣柳") then
							settimer("莺鸣柳")
							return
						end
					end

					--云栖松
					if cast("云栖松") then
						settimer("云栖松")
						return
					end

				end
			end
		end
	end
end

--切换内功
function OnMountKungFu(KungFu, Level)
	deltimer("切换内功")
	
	if KungFu == 10145 then		--切换到山居剑意, 这两个变量暂时没用
		v["放过风来吴山"] = false
		v["放过飞来闻踪"] = false
	end
end

--状态更新
function OnStateUpdate(nCurrentLife, nCurrentMana, nCurrentRage, nCurrentEnergy, nCurrentSunEnergy, nCurrentMoonEnergy)
	--输出剑气变动情况
	--print("OnStateUpdate, 剑气: "..nCurrentRage, "当前帧: ".. frame())
end

--释放技能
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		if SkillID == 18333 then	--风来吴山
			v["放过风来吴山"] = true
		end
		if SkillID == 25070 then	--飞来闻踪
			v["放过飞来闻踪"] = true
		end
	end
end
