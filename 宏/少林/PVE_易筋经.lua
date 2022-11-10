--气点同步标志
local bWait = false

--主循环
function Main(g_player)
	if nobuff("伏魔") then
		cast("二业依缘")
	end

	--等待气点同步
	if bWait then
		if gettimer("擒龙诀") < 0.3 or gettimer("罗汉金身") < 0.3 then
			return
		end
	end

	if rela("敌对") and dis() < 4 then
		if qidian() >= 3 then
			if cast("罗汉金身") then
				settimer("罗汉金身")
				bWait = true
				return
			end
		end
		if qidian() < 1 and bufftime("罗汉金身") > 15 then
			if cast("擒龙诀", true) then
				settimer("擒龙诀")
				bWait = true
				return
			end
		end
	end

	
	if rela("敌对") and dis() < 5.5 and tbufftime("横扫六合", true) < 2 then
		cast("横扫六合")
	end

	if qidian() >= 3 then
		cast("拿云式")
		cast("韦陀献杵")
	end

	if rela("敌对") and dis() < 12 and qidian() < 3 and bufftime("罗汉金身") > 0.3 then
		acast("醍醐灌顶")
	end

	cast("守缺式")
	cast("普渡四方")

	if dis() > 8 then
		cast("捕风式")
	end

	if cdleft(16) > 0.6 and qidian() < 2 then
		cast("捉影式")
	end

	if nobuff("般若诀") then
		cast("般若诀", true)
	end

end


--气点更新
OnQidianUpdate = function()
	bWait = false
end
