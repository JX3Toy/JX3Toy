--[[ 奇穴: [揚戈][神勇][大漠][擊水 or 龍馭][馳騁][牧雲][風虎][戰心][淵][夜徵][龍血][虎賁]
秘籍:
穿云  1调息 1会心 2伤害
龙吟  1调息 3伤害
龙牙  1会心 3伤害
突    1消耗 1距离 2伤害
灭    1调息 1会心 2伤害
战八方 1目标个数 1范围 2伤害
断魂刺 2调息 2伤害

如果点了[龍馭], 上马之后龙驭不到3层就动起来, 到3层站桩打
--]]

--宏选项
addopt("乘龙箭打断", false)
addopt("副本防开怪", false)

--变量表
local v = {}
v["战意"] = rage()

--主循环
function Main(g_player)
	-- 按下自定义快捷键1交扶摇
	if keydown(1) and scdtime("扶搖直上") <= 0 then
		if cast("扶搖直上") then
			settimer("扶搖直上")
		end
		if buff("騎禦") then
			cbuff("騎禦")
		end
	end
	
	--减伤
	if fight() then
		cast("嘯如虎")

		if life() < 0.55 then
			cast("守如山")
		end
	end

	--目标不是敌对, 结束
	if not rela("敌对") then return end
	if gettimer("冲刺") < 0.3 then return end
	
	if getopt("副本防开怪") and dungeon() and nofight() then 
		return
	end

	--等待任驰骋释放
	if casting("任馳騁") and castleft() < 0.13 then
		settimer("任驰骋读条结束")
	end
	if gettimer("任驰骋读条结束") < 0.3 then return end
	

	--初始化变量
	--v["目标流血时间"] = tbufftime("流血", id())
	--v["龙驭层数"] = buffsn("龍馭")
	--v["驰骋"] = bufftime("馳騁")
	--v["牧云"] = bufftime("牧雲")
	--v["渊"] = bufftime("2778")
	--v["在马上"] = buff("騎禦")
	--v["有队伍"] = g_player.IsInParty()

	--下马
	if buff("騎禦") and nobuff("馳騁") and cn("任馳騁") > 0 and qixue("龍馭") then
		--if cdleft(16) >= 1 and v["战意"] < 5 and scdtime("撼如雷") < 1.5 then
		if scdtime("撼如雷") < 1 then
			cbuff("騎禦")
			settimer("冲刺") exit()
		end
	end
	
	if buff("騎禦") and (cn("任馳騁") > 0 or (nobuff("牧雲") and scdtime("突") <= 0) or scdtime("淵") <= 1.5) and not qixue("龍馭") then
		cbuff("騎禦")
		settimer("冲刺") exit()
	end

	--渊
	v["目标附近队友"] = tparty("没状态:重伤", "不是自己", "自己距离>6", "自己距离<20", "距离<25","不是内功:洗髓经|铁牢律|明尊琉璃体|铁骨衣", "视线可达", "距离最近")
	if v["目标附近队友"] ~= 0 and nobuff("騎禦") and qixue("淵") and scdtime("淵") <= 0 then
		if xcast("淵", v["目标附近队友"]) then
			settimer("冲刺") exit()
		end
		return
	end

	--突
	--if cdleft(16) > 0.5 or nobuff("牧雲") then
	if cast("突") then
		settimer("冲刺") exit()
	end

	--撼如雷
	if rela("敌对") and dis() < 8 and cdleft(16) < 0.5 then
		if qixue("龍馭") then
			if bufftime("馳騁") > 9 then
				cast("撼如雷", true)
			end
		elseif bufftime("淵") > 6 then
			cast("撼如雷", true)
		elseif bufftime("馳騁") > 9 then
			cast("撼如雷", true)
		end
	end

	--断魂刺
	if v["战意"] <= 2 or dis() > 8 then
		if cast("斷魂刺") then
			settimer("冲刺") exit()
		end
	end

	---------------------------------------------

	if getopt("乘龙箭打断") and tbuffstate("可打断") then
		cast("乘龍箭")
	end

	--任驰骋
	if qixue("龍馭") then
		if buff("牧雲") then
			cast("任馳騁")
		end
	end
	
	if not qixue("龍馭")and nobuff("馳騁") then
		if buff("牧雲") then
			cast("任馳騁")
		end
	end

	--保流血
	if tbufftime("流血", id()) < cdinterval(16) * 2 then
		if v["战意"] <= 2 then
			cast("滅")
		end
		cast("龍吟")
		cast("滅")
	end

	--龙牙
	if v["战意"] >= 5 then
		cast("龍牙")
	end

	--战八方
	_, v["6尺内敌人数量"] = npc("关系:敌对", "距离<6", "可选中")
	if v["6尺内敌人数量"] >= 3 then
		cast("戰八方")
	end

	--灭
	if v["战意"] <= 2 then
		cast("滅")
	end

	--龙吟
	if v["战意"] <= 3 then
		cast("龍吟")
	end

	--穿云
	cast("穿雲")
end

--释放技能
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		if SkillID == 428  then	--断魂刺
			v["战意"] = v["战意"] + 3
		end
		if SkillID == 433 then	--任驰骋
			deltimer("任驰骋读条结束")
		end
	end
end

--状态更新
function OnStateUpdate(nCurrentLife, nCurrentMana, nCurrentRage, nCurrentEnergy, nCurrentSunEnergy, nCurrentMoonEnergy)
	--print("OnStateUpdate, 战意: "..nCurrentRage)
	v["战意"] = nCurrentRage
end
