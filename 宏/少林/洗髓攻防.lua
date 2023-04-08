--攻防混分摆烂
--奇穴: [不垢][取法][无尘][固法][生缘][立地成佛][无想][明王身][明心][真如][独觉][摩咭]

--载入库
load("Macro/Lib_PVP.lua")

--变量表
local v = {}

--主循环
function Main(g_player)

	if fight() then
		if life() < 0.3 then
			cast("锻骨诀")
		end

		if nobuff("无相诀") and life() < 0.7 then
			cast("无相诀·无色")
		end
	end

	if rela("敌对") and dis() < 5 and qidian() < 2 then
		cast("擒龙诀")
	end

	if qidian() >= 3 then
		cast("罗汉金身")
		cast("韦陀献杵")
	end

	if target("player") and tbuffstate("可击倒")  then
		cast("摩诃无量")
	end

	--重置无相诀
	if cdtime("无相诀·无色") > 15 then
		v["距离最近队友"] = party("没状态:重伤", "不是自己", "没载具", "视线可达", "距离最近")
		if v["距离最近队友"] ~= 0 then
			xcast("舍身诀", v["距离最近队友"])
		end
	end

	if rela("敌对") and dis() < 6 then
		cast("横扫六合")
	end

	cast("普渡四方")

	if nobuff("般若诀") then
		cast("般若诀")
	end

	if nofight() and nobuff("调息") then
		if life() < 0.95 or mana() < 0.95 then
			cast("打坐")
		end
	end

	--采集任务物品
	if nofight() then
		g_func["采集"](g_player)
	end

end
