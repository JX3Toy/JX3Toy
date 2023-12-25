--[[ 奇穴: [彈指 或 竭澤][煙霞 或 生息][青律 或 月華 或 秋肅][清疏 或 厥陰指][微潮][積勢][書離][漸催 或 池月][寒清 或 鋒末][清神][遙歸][落子無悔]
秘籍:
星楼  2调息 1消耗 1减伤
提针  2读条 1疗效 1回墨意
长针  1消耗 1距离 2疗效
商阳  1距离 3消耗

奇穴秘籍只是推荐，我也不太会玩，你是老手你自己看着点
如果需要打断点[厥陰指], 开启宏选项中的打断
没有特殊情况当前目标一直选中boss就行了
--]]

--宏选项
addopt("打断", false)

--变量表
local v = {}
v["记录信息"] = true

--函数表
local f = {}

--主循环
function Main()
	--按下自定义快捷键1挂扶摇, 注意是快捷键设定里面插件的快捷键1指定的按键，不是键盘上的1
	if keydown(1) then
		cast("扶搖直上")
	end

	--减伤
	if fight() and life() < 0.5 then
		cast("星樓月影")
	end

	--打断
	if getopt("打断") and tbuffstate("可打断") then
		cast("厥陰指")
	end

	--初始化变量
	v["墨意"] = rage()
	v["治疗量"] = charinfo("治疗量")	--如果想精确治疗，治疗量 * 技能系数 = 技能实际加血量
	v["治疗目标"] = f["获取治疗目标"]()
	v["治疗目标血量"] = xlife(v["治疗目标"])
	v["治疗目标是T"] = xmount("洗髓經|鐵牢律|明尊琉璃體|鐵骨衣", v["治疗目标"])

	---------------------------------------------

	--听风
	if fight() and v["治疗目标血量"] < 0.4 and life() > 0.8 then
		CastX("聽風吹雪")
	end

	--长针
	if v["治疗目标血量"] < 0.75 then
		--水月
		if fight() and v["墨意"] < 20 then
			cast("水月無間")
		end

		if buff("412|722|932|3458|6266") then	--有瞬发
			CastX("長針")
		end
	end

	--彼针

	--提针
	if v["治疗目标血量"] < 0.9 then		--加血
		CastX("提針")
	end
	if v["墨意"] < 30 then				--刷墨意
		CastX("提針")
	end

	--握针
	if rela("敌对") and ttid() ~= 0 and xrela("自己|友好|队友", ttid()) then	--目标的目标 boss的目标大概率就是下一个要奶的人
		if xbufftime("握針", ttid(), id()) < 3 then
			xcast("握針", ttid())
		end
	end

	--碧水
	if fight() and mana() < 0.45 then
		cast("碧水滔天", true)
	end

	--秋肃
	if fight() and target("boss") and face() < 80 and qixue("秋肅") and tbufftime("秋肅") < 3 then
		cast("商陽指")
	end

	--给T上握针
	xcast("握針", party("没状态:重伤", "距离<20", "内功:洗髓經|鐵牢律|明尊琉璃體|鐵骨衣", "视线可达", "我的buff时间:握針<3"))

	--脱战救人
	if casting("鋒針") and castleft() < 0.13 then
		settimer("锋针读条结束")
	end
	if nofight() and gettimer("锋针读条结束") > 0.5 then
		xcast("鋒針", party("有状态:重伤", "距离<20", "视线可达"))
	end
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
	t[#t+1] = "墨意:"..v["墨意"]
	t[#t+1] = "治疗目标:"..v["治疗目标"]
	t[#t+1] = "治疗目标血量:"..format("%0.2f", v["治疗目标血量"])
	print(table.concat(t, ", "))
end

--对治疗目标使用技能
function CastX(szSkill)
	if xcast(szSkill, v["治疗目标"]) then
		if v["记录信息"] then PrintInfo() end
		return true
	end
	return false
end
