output("----------镇派----------")
output("2 3 2")
output("1 2 3 2")
output("2 1 2 2")
output("0 3 2")
output("0 1 2 3")
output("0 1")
output("0 0 2")


local v = {}

function Main(g_player)
	--千蝶读条保护
	if gettimer("千蝶吐瑞") < 0.5 or casting("千蝶吐瑞") then
		nomove(true)
		return
	else
		nomove(false)	--没读条千蝶，允许移动
	end

	if casting("仙王蛊鼎") and castleft() < 0.13 then
		settimer("吃鼎读条结束")
	end

	--驱散
	if pet("碧蝶") then
		v["需要驱散队友"] = xparty(petid(), "没状态:重伤", "距离<38", "视线可达", "buff类型时间:阳性不利效果|混元性不利效果|阴性不利效果|毒性不利效果>1")		--蝴蝶周围40尺内, 视线可达, 有指定不利效果
		if v["需要驱散队友"] ~= 0 and cdleft(460) < 1 then		--获取宠物技能CD有点问题, 用cdleft
			if settar(v["需要驱散队友"]) then		--蝶鸾只作用于当前目标
				if cast("蝶鸾") then
					print("驱散 "..xname(v["需要驱散队友"]))
				end
			end
		end
	end

	--千蝶
	_, v["低血量队友数量"] = party("没状态:重伤", "距离<20", "视线可达", "气血<0.6")
	if v["低血量队友数量"] >= 4 then
		if cast("千蝶吐瑞") then
			stopmove()			--停止移动
			nomove(true)		--禁止移动
			settimer("千蝶吐瑞")
			return
		end
	end

	--把单体治疗目标初始化为自己
	v["治疗目标"] = id()

	--查找团队中血量最少的队友，如果比自己的血量低，就把治疗目标设置为他
	v["血量最少队友"] = party("没状态:重伤", "不是自己", "距离<20", "视线可达", "气血最少")
	if v["血量最少队友"] ~= 0 and xlife(v["血量最少队友"]) < life() then		--找到了，并且血量小于自己的血量
		v["治疗目标"] = v["血量最少队友"]		--治疗目标就设置为他
	end

	v["目标血量"] = xlife(v["治疗目标"])
	v["目标是T"] = xmount("洗髓经|铁牢律|明尊琉璃体|铁骨衣", v["治疗目标"])

	--圣手
	if v["目标血量"] < 0.5 or (v["目标是T"] and v["目标血量"] < 0.65) then
		if xcast("圣手织天", v["治疗目标"], true) then
			xcast("醉舞九天", v["治疗目标"], true)		--这个考虑对着boss放
		end
	end

	--冰蚕
	if v["目标血量"] < 0.7 or (v["目标是T"] and v["目标血量"] < 0.85) then
		if xcast("冰蚕牵丝", v["治疗目标"], true) then
			xcast("醉舞九天", v["治疗目标"], true)
		end
	end

	--给T上蛊惑
	xcast("蛊惑众生", party("没状态:重伤", "距离<20", "内功:洗髓经|铁牢律|明尊琉璃体|铁骨衣", "视线可达", "buff时间:蛊惑众生<1"))

	--吃鼎
	if mana() < 0.7 or life() < 0.7 then
		if gettimer("吃鼎读条结束") > 1 and nobuff("蛊时") then
			interact("仙王蛊鼎")
		end
	end

	--醉舞九天
	if v["目标血量"] < 0.9 then
		xcast("醉舞九天", v["治疗目标"])
	end

	--开打前手动招大蝴蝶, [灵蛇引] -> 等 [碧蝶引] 冷却 -> [蛊虫献祭] -> [女娲补天] -> [碧蝶引]
	if fight() and nopet("碧蝶") then	--战斗中没蝴蝶就招
		cast("碧蝶引")
	end

	--团里有毒经, 没事就给目标上个枯残
	if party("内功:毒经") ~= 0 then
		cast("枯残蛊")
	end

end
