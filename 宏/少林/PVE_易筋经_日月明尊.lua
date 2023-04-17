--[[镇派
[身意]2[断灭]3
[无量]2[无执]2[苦厄]3
[金刚诀]1[心棍]2[横眉]2
[深行]2[弱水]2[诸行]1
[降魔渡厄]2[独觉]1[净果]2[镇魔]1
[捣虚式]1
[业力]2[千眼]3
[幻身]2
--]]

--关闭自动面向
setglobal("自动面向", false)

--等待气点同步标志
local bWait = false

--变量表
local v = {}

--主循环
function Main(g_player)
	--捉影式读条结束计时器
	if casting("捉影式") and castleft() < 0.13 then
		settimer("捉影式读条结束")
	end

	--般若诀
	if nofight() and nobuff("般若诀") then
		cast("般若诀", true)
	end

	--减伤
	if fight() then
		if life() < 0.6 and buffstate("减伤效果") < 40 then
			cast("无相诀")
		end
		if life() < 0.4 then
			cast("锻骨诀")
		end
	end

	--打断
	if tbuffstate("可打断") then
		cast("抢珠式")
	end

	--目标不是敌人，结束
	if not rela("敌对") then return end

	--等待气点同步
	if bWait and gettimer("等待禅那同步") <= 0.25 then return end

	local speedXY, speedZ = speed(tid())
	v["目标静止"] = speedXY == 0 and speedZ == 0		--xy速度和Z速度都为0
	v["目标血量较多"] = tlifevalue() > lifemax() * 5	--目标当前血量是自己最大血量5倍

	--佛心诀
	if dis() < 4 then
		cast("佛心诀")
	end

	--擒龙诀
	if dis() < 4 and qidian() < 1 and v["目标血量较多"] then
		if cast("擒龙诀") then
			SetWait()
		end
	end

	--捉影式, 目标静止 2点气 有金刚怒目
	if gettimer("捉影式读条结束") > 0.5 and v["目标静止"] and v["目标血量较多"] and qidian() >= 2 and bufftime("金刚怒目") > 2 and cdleft(16) > 0.8 then
		--在矩形范围内
		local x, y  = xxpos(id(), tid())
		if x > 0 and x < 4 and y > -2 and y < 2 then
			--能放拿云, [诸行]棍和爪各一半几率
			if tlife() < 0.3 or buff("净果") then
				if cast("捉影式") then
					SetWait()
				end
			end
		end
	end

	--诸行
	if buff("诸行") then
		if bufflv("诸行") == 1 then
			if cast("韦陀献杵") then
				SetWait()
			end
		end
		if bufflv("诸行") == 2 then
			if cast("拿云式") then
				SetWait()
			end
		end
		return
	end

	--金刚怒目
	if qidian() >= 3 and dis() < 4 and cdleft(16) < 0.5 then
		if cast("金刚怒目") then
			SetWait()
		end
	end

	--拿云式
	if qidian() >= 3 then
		if cast("拿云式") then
			SetWait()
		end
	end

	--韦陀献杵
	if qidian() >= 3 then
		if cast("韦陀献杵") then
			SetWait()
		end
	end

	--横扫六合
	if dis() < 4.5 then
		if cast("横扫六合") then
			SetWait()
		end
	end

	if bufftime("捣虚") < 2 then
		if cast("捣虚式") then
			SetWait()
		end
	end

	if cast("守缺式") then		--没捣虚伤害高，但可以触发拿云
		SetWait()
	end

	if cast("捣虚式") then
		SetWait()
	end
	
	if cast("普渡四方") then
		SetWait()
	end

	if dis() > 10 then
		cast("捕风式")
	end

end

--设置气点等待标志, 如果需要比较精确的判断气点, 释放后气点有变动的技能调用
function SetWait()
	bWait = true
	settimer("等待禅那同步")
	exit()
end

--气点更新
function OnQidianUpdate()
	bWait = false
end
