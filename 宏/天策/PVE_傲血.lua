output("奇穴: [扬戈][神勇][大漠][龙驭][驰骋][牧云][风虎][战心][渊][夜征][龙血][虎贲]")

--变量表
local v = {}

--主循环
function Main(g_player)

	--减伤
	if fight() then
		cast("啸如虎")

		if life() < 0.55 then
			cast("守如山")
		end
	end

	--目标不是敌对, 结束
	if not rela("敌对") then return end

	--渊
	v["目标附近队友"] = tparty("没状态:重伤", "不是自己", "距离>6", "距离<20", "不是内功:洗髓经|铁牢律|明尊琉璃体|铁骨衣", "视线可达", "距离最近")
	--if v["目标附近队友"] ~= 0 and bufftime("驰骋") > 10 then
	if v["目标附近队友"] ~= 0 then
		xcast("渊", v["目标附近队友"])
	end

	--突
	if bufftime("牧云") < 38 then
		cast("突")
	end

	--撼如雷
	if rela("敌对") and dis() < 8 then
		cast("撼如雷", true)
	end

	--任驰骋
	if nobuff("驰骋") and cn("任驰骋") > 0 then
		if cdleft(16) > 1 and bufftime("牧云") < 1 then
			cbuff("骑御")
		end

		if bufftime("牧云") > 38 then
			cast("任驰骋")
		end
	end

	if rage() >= 5 then
		cast("龙牙")
	end

	cast("龙吟")

	if rage() <= 2 then
		cast("灭")
	end

	cast("穿云")
end
