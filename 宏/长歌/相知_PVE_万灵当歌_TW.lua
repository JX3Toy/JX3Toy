--[[ 奇穴: [蔚風][秋鴻][爭簇][綠綺 或 一指回鸞][謫仙][音塵][共潮生][行雲][流霜][不器][擲杯][無盡藏]
秘籍:
宫  2读条 1会心 1疗效
商  2疗效 2会心
徵  2会心 2疗效
羽  1会心 1减伤 2疗效
杯水  3读条 1减伤

没有特殊情况当前目标一直选中boss
--]]

--变量表
local v = {}
v["记录信息"] = true

--函数表
local f = {}

--主循环
function Main()
	--按下自定义快捷键1挂扶摇, 注意是快捷键设定里面插件的快捷键1指定的按键，不是键盘上的1
	if keydown(1) then
		fcast("扶搖直上")
	end

	--记录读条结束
	if casting("宮") and castleft() < 0.13 then
		settimer("宫读条结束")
	end

	--初始化变量
	v["治疗量"] = charinfo("治疗量")
	v["治疗目标"] = f["获取治疗目标"]()
	v["治疗目标血量"] = xlife(v["治疗目标"])
	v["影子数量"] = 0
	for i = 3, 8 do
		if buff("999"..i) then
			v["影子数量"] = v["影子数量"] + 1
		end
	end

	---------------------------------------------
	
	--切换到阳春白雪
	if nobuff("9320") then
		cast("陽春白雪")
	end
	
	--对目标放影子
	if v["影子数量"] < 6 and fight() and rela("敌对") and cn("疏影橫斜") > 2 then
		cast("疏影橫斜")
	end

	--驱散
	v["需要驱散队友"] = party("没状态:重伤", "距离<20", "视线可达", "buff类型时间:阳性不利效果|混元性不利效果|阴性不利效果|毒性不利效果>1")
	if v["需要驱散队友"] ~= 0  then
		xcast("一指回鸞", v["需要驱散队友"], true)
	end

	--是否中断徵读条
	local bBreak = false
	if casting("徵") then
		v["徵读条目标"] = casttarget()
		if v["徵读条目标"] ~= v["治疗目标"] or xlife(v["徵读条目标"]) > 0.98 then	--徵读条目标不是血量最少队友 或 已经满血
			bBreak = true
		end
	end

	--羽
	--if fight() and qixue("綠綺") and nobuff("綠綺") then
	--	CastX("羽", bBreak)
	--end
	if fight() and v["治疗目标血量"] < 0.7 then
		CastX("羽", bBreak)
	end

	--宫
	if v["治疗目标血量"] < 0.9 and gettimer("宫读条结束") > 0.5 and xbufftime("音塵", v["治疗目标"], id()) < 2 then
		CastX("宮", bBreak)
	end

	--徵
	if v["治疗目标血量"] < 0.9 then
		CastX("徵", bBreak)
	end

	--角 商
	if v["治疗目标血量"] < 0.95 then
		if xbufftime("角", v["治疗目标"], id()) < -1 then
			CastX("角", bBreak)
		end
		if xbufftime("商", v["治疗目标"], id()) < -1 then
			CastX("商", bBreak)
		end
	end

	--目标的目标
	if fight() and rela("敌对") then
		v["目标的目标"] = ttid()
		if v["目标的目标"] ~= 0 then
			--音尘
			if gettimer("宫读条结束") > 0.5 and xbufftime("音塵", v["目标的目标"], id()) < 2 then
				xcast("宮", v["目标的目标"], bBreak)
			end
			--hot
			if xbufftime("角", v["目标的目标"], id()) < -1 then
				xcast("角", v["目标的目标"], bBreak)
			end
			if xbufftime("商", v["目标的目标"], id()) < -1 then
				xcast("商", v["目标的目标"], bBreak)
			end
		end
	end

	--脱战救人
	if casting("歌盡影生") and castleft() < 0.13 then
		settimer("歌尽读条结束")
	end
	if nofight() and gettimer("歌尽读条结束") > 1 then
		xcast("歌盡影生", party("有状态:重伤", "距离<20", "视线可达"))
	end

	--给T上hot
	xcast("角", party("没状态:重伤", "距离<20", "内功:洗髓經|鐵牢律|明尊琉璃體|鐵骨衣", "视线可达", "我的buff时间:角<-1"))
	xcast("商", party("没状态:重伤", "距离<20", "内功:洗髓經|鐵牢律|明尊琉璃體|鐵骨衣", "视线可达", "我的buff时间:商<-1"))

	--给其他队友上hot
	xcast("角", party("没状态:重伤", "距离<20", "视线可达", "我的buff时间:角<-1"))
	xcast("商", party("没状态:重伤", "距离<20", "视线可达", "我的buff时间:商<-1"))
end

-------------------------------------------------------------------------------

f["获取治疗目标"] = function()
	local targetID = id()	--治疗目标先设置为自己, 不在队伍或者团队中时 party 返回 0
	local partyID = party("没状态:重伤", "不是自己", "距离<20", "视线可达", "没载具", "气血最少")	--获取血量最少队友
	if partyID ~= 0 and partyID ~= targetID and xlife(partyID) < life() then	--有血量最少队友且比自己血量少
		targetID = partyID	--把他指定为治疗目标
	end
	return targetID
end

--记录信息
function PrintInfo(s)
	local t = {}
	if s then t[#t+1] = s end
	t[#t+1] = "治疗目标:"..v["治疗目标"]
	t[#t+1] = "治疗目标血量:"..format("%0.2f", v["治疗目标血量"])
	print(table.concat(t, ", "))
end

--对治疗目标使用技能
function CastX(szSkill, bf)
	if xcast(szSkill, v["治疗目标"], bf) then
		if v["记录信息"] then PrintInfo() end
		return true
	end
	return false
end
