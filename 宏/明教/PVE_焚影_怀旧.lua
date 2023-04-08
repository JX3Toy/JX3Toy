--主循环
function Main(g_player)
	cast("净世破魔击")
	
	if tface() > 90 or buff("50986|51004") then
		if rela("敌对") and dis() < 4 and cdtime("驱夜断愁") > 4 then
			if gettimer("光明相") > 1 and gettimer("生灭予夺") > 1 then
				if cast("光明相") then
					settimer("光明相")
				end
				
				if cast("生灭予夺") then
					settimer("生灭予夺")
				end
			end
		end

		cast("驱夜断愁")
	end

	cast("烈日斩")
	cast("赤日轮")
end
