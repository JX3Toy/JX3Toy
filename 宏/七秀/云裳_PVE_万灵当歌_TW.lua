--[[ 奇穴: [朝露][盛夏][辭致][瑰姿][乞巧][散餘霞][晚晴][碎冰][妍姿][九微飛花][垂眉][左旋右轉]
秘籍:
翔鸾舞柳  2疗效 2距离
上元点鬟  1疗效 3距离
回雪飘摇  3疗效 1距离
王母挥袂  2会心 2疗效
天地低昂  2调息 1持续 1回蓝
繁音急节  3调息 1满堂
心鼓弦    3调息 1读条

作者本人不会玩奶秀, 奇穴秘籍自己看情况调整
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

	--减伤
	if fight() and life() < 0.6 then
		fcast("天地低昂", true)
	end

	--开剑舞
	if nobuff("劍舞") then
		cast("名動四方", true)
	end

	--初始化变量
	v["治疗量"] = charinfo("治疗量")	--如果想精确治疗，治疗量 * 技能系数 = 技能实际加血量
	v["治疗目标"] = f["获取治疗目标"]()
	v["治疗目标血量"] = xlife(v["治疗目标"])
	v["治疗目标是T"] = xmount("洗髓經|鐵牢律|明尊琉璃體|鐵骨衣", v["治疗目标"])
	v["风袖血线"] = 0.5			--可以根据当前版本和自己装分适当调整
	v["王母血线"] = 0.6
	if v["治疗目标是T"] then	--是T的话把血线定高一点
		v["风袖血线"] = 0.6
		v["王母血线"] = 0.7
	end

	--------------------------------------------- 加血

	--回雪第1跳不打断
	if casting("回雪飄搖") and castprog() < 0.34 then return end

	--风袖
	if fight() and v["治疗目标血量"] < v["风袖血线"] then
		xcast("風袖低昂", v["治疗目标"], true)
		xcast("九微飛花", v["治疗目标"], true)
	end

	--王母
	if v["治疗目标血量"] < v["王母血线"] then
		xcast("王母揮袂", v["治疗目标"], true)
	end

	--治疗目标是当前正在读条回雪的目标
	if casting("回雪飄搖") and v["治疗目标"] == casttarget() then
		return
	end

	--上元 翔鸾
	if v["治疗目标血量"] < 0.95 then
		if xbufftime("上元點鬟", v["治疗目标"], id()) < -1 then
			xcast("上元點鬟", v["治疗目标"], true)
		end
		if xbufftime("翔舞", v["治疗目标"], id()) < -1 then
			xcast("翔鸞舞柳", v["治疗目标"], true)
		end
		xcast("上元點鬟", v["治疗目标"], true)
	end
	
	--回雪
	if v["治疗目标血量"] < 0.8 then
		xcast("回雪飄搖", v["治疗目标"], true)
	end

	--脱战救人
	if casting("妙舞神揚") and castleft() < 0.13 then
		settimer("妙舞读条结束")
	end
	if nofight() and gettimer("妙舞读条结束") > 0.5 then
		xcast("妙舞神揚", party("有状态:重伤", "距离<20", "视线可达"))
	end

	--给T上hot
	xcast("上元點鬟", party("没状态:重伤", "距离<20", "内功:洗髓經|鐵牢律|明尊琉璃體|鐵骨衣", "视线可达", "我的buff时间:上元點鬟<-1"))
	xcast("翔鸞舞柳", party("没状态:重伤", "距离<20", "内功:洗髓經|鐵牢律|明尊琉璃體|鐵骨衣", "视线可达", "我的buff时间:翔舞<-1"))

	--没事干就给队友上hot
	xcast("翔鸞舞柳", party("没状态:重伤", "距离<20", "视线可达", "我的buff时间:翔舞<-1"))
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
