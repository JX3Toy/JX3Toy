output("奇穴: [明法][幻身][身意][缩地][降魔渡厄][金刚怒目][净果][三生][众嗔][华香][佛果][业因]")

--变量表
local v = {}
v["等待气点同步"] = false


--主循环
function Main(g_player)

	--等待气点同步
	if v["等待气点同步"] and gettimer("等待气点同步") < 0.5 then
		return
	end

	--目标不是敌对结束
	if not rela("敌对") then return end

	--打断
	if tbuffstate("可打断") then
		cast("抢珠式")
	end

	v["禅那"] = qidian()

	--罗汉金身
	if rela("敌对") and dis() < 4 and v["禅那"] >= 3 then
		if cast("罗汉金身") then
			settimer("等待气点同步")
			v["等待气点同步"] = true
			return
		end
	end

	--二业依缘
	if dis() < 4 and cdleft(16) > 0.5 then
		if nobuff("袈裟") then
			--袈裟
			if cn("守缺式") > 0 and tbufftime("横扫六合", id()) > 6 then
				cast("二业依缘")
			end
		else
			--伏魔
			if nobuff("24620") then		--业因四次无CD
				if cast("二业依缘") then
					v["等待气点同步"] = true
					settimer("等待气点同步")
				end
			end
		end
	end

	--擒龙诀
	if dis() < 4 and buffsn("果报") >= 3 and v["禅那"] < 2 then
		cast("擒龙诀")
	end

	--业因四次无CD
	if buff("24620") then
		if qidian() >= 3 then
			cast("拿云式")
		end
		cast("守缺式")
		return
	end

	if rela("敌对") and dis() < 5.5 and tbufftime("横扫六合", id()) < 2 then
		cast("横扫六合")
	end

	if qidian() >= 3 then
		cast("拿云式")
		cast("韦陀献杵")
	end

	cast("守缺式")

	if rela("敌对") and dis() < 5.5 then
		cast("横扫六合")
	end

	cast("守缺式")
	cast("普渡四方")

	if dis() > 8 then
		cast("捕风式")
	end

	--捉影式, 插入GCD回豆
	if cdleft(16) > 0.6 and qidian() < 2 then
		cast("捉影式")
	end

	if nobuff("般若诀") then
		cast("般若诀", true)
	end

end


--气点更新
OnQidianUpdate = function()
	v["等待气点同步"] = false
end
