output("----------镇派----------")
output("2 3 2")
output("3 2 2 0")
output("1 2 2 3")
output("2 2 1 1")
output("2 1 1")
output("1 1")
output("0 0 2")


--变量表
local v = {}

--主循环
function Main(g_player)
	if nofight() and nobuff("清心静气") then
		cast("清心静气", true)
	end

	--打断
	if tbuffstate("可打断") then
		cast("厥阴指")
	end

	--确定治疗目标
	v["治疗目标"] = id()
	v["血量最少队友"] = party("没状态:重伤", "不是自己", "距离<20", "视线可达", "没载具", "气血最少")
	if v["血量最少队友"] ~= 0 and xlife(v["血量最少队友"]) < life() then
		v["治疗目标"] = v["血量最少队友"]
	end

	v["目标血量"] = xlife(v["治疗目标"])
	v["目标是T"] = xmount("洗髓经|铁牢律|明尊琉璃体|铁骨衣", v["治疗目标"])

	--听风
	if fight() and v["治疗目标"] ~= id() then		--战斗中，不是自己
		if v["目标血量"] < 0.3 and life() > 0.9 then
			xcast("听风吹雪", v["治疗目标"])
		end
	end

	--长针
	if v["目标血量"] < 0.4 or (v["目标是T"] and v["目标血量"] < 0.6) then
		if buff("行气血|水月无间") then
			xcast("长针", v["治疗目标"])
		else
			if cdtime("长针") <= 0 then
				if cast("水月无间", true) then
					xcast("长针", v["治疗目标"])
				end
			end
		end
	end

	--春泥
	if fight() and v["目标是T"] and v["目标血量"] < 0.5 and xbuffstate("减伤效果", v["治疗目标"]) < 40 then		--T血量下50%，没减伤，前面长针没加上，上春泥
		xcast("春泥护花", v["治疗目标"])
	end

	--驱散
	xcast("清风垂露", party("没状态:重伤", "距离<20", "视线可达", "buff类型时间:阳性不利效果|混元性不利效果|阴性不利效果|点穴不利效果|毒性不利效果>1"))

	--彼针
	_, v["10尺内不满血队友数量"] = party("没状态:重伤", "距离<10", "视线可达", "气血<0.7")
	if v["10尺内不满血队友数量"] > 3 then
		cast("彼针")
	end

	--局针
	if v["目标血量"] < 0.8 or (v["目标是T"] and v["目标血量"] < 0.9) then
		xcast("局针", v["治疗目标"])
	end
	
	if fight() then
		if buffsn("生苏") < 4 or bufftime("生苏") < 5 or bufftime("行气血") < 5 then
			local tank = party("没状态:重伤", "距离<20", "内功:洗髓经|铁牢律|明尊琉璃体|铁骨衣", "视线可达")
			if tank ~= 0 then
				xcast("局针", tank)
			else
				cast("局针", true)
			end
		end
	end

	--握针
	if v["目标血量"] < 0.9 and xbufftime("握针", v["治疗目标"]) < -1 then		--少量掉血，上个握针
		xcast("握针", v["治疗目标"])
	end
	xcast("握针", party("没状态:重伤", "距离<20", "内功:洗髓经|铁牢律|明尊琉璃体|铁骨衣", "视线可达", "buff时间:握针<-1"))		--给T上握针


	--回蓝
	if nobuff("碧水滔天") and life() > 0.9 and mana() < 0.7 then
		cast("大针")
	end

	if mana() < 0.4 then
		cast("碧水滔天", true)
	end

	--这个放到后面, 移动中放不出读条技能，给自己回血
	if life() < 0.7 then
		cast("花语酥心", true)
	end
end
