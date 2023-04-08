output("----------镇派----------")
output("2 3 2")
output("2 2 0 1")
output("1 3 0 2")
output("1 2 3 0")
output("3 2 1")
output("1")
output("0 3 2")

--主循环
function Main(g_player)
	cast("净世破魔击")
	
	if rela("敌对") and dis() < 4 and cdtime("驱夜断愁") > 4 and gettimer("生灭予夺") > 2 then
		if cast("光明相") then
			settimer("光明相")
		end
	end

	if tface() > 90 or buff("50986|51004") then
		if rela("敌对") and dis() < 4 and cdtime("驱夜断愁") > 4 and gettimer("光明相") > 2 then	
			if cast("生灭予夺") then
				settimer("生灭予夺")
			end
		end

		cast("驱夜断愁")
	end

	cast("烈日斩")
	cast("赤日轮")
end
