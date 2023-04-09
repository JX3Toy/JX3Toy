--买好鱼饵，背包留足够空间, 在帮会池塘边开始运行

function Main(g_player)
	--收杆
	if buff("11967") then
		if gettimer("收杆") > 3 then
			actionclick(1, 2)
			settimer("收杆")
			print("收杆")
		end
		return
	end

	--判断鱼饵数量
	if g_player.GetItemAmountInPackage(5, 7843) < 1 then
		bigtext("没鱼饵啦", 0.5)
		return
	end

	--开始钓鱼
	if nobuff("钓鱼") then
		if gettimer("交互鱼篓") > 2 then
			interact("帮会鱼篓")
			settimer("交互鱼篓")
			print("交互鱼篓")
		end
		return
	end

	--放杆
	if nobuff("11966") and gettimer("放杆") > 6 and gettimer("交互鱼篓") > 3 then
		actionclick(1, 1)
		settimer("放杆")
		print("放杆")
	end
end
