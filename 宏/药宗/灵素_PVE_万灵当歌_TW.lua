--[[ 奇穴: [反佐][月見][不染][韶時][暢和][忘憂][決明][飄黃][配伍][同夢][蓮池][衛矛]
秘籍:
白芷  2会心 1疗效 1效果
赤芍  2调息 1效果 1疗效
龙葵  1会心 1疗效 2效果
七情  2调息 2效果
银光  2会心 2疗效
枯木  3调息 1效果(回血)
逐云  3调息 1效果(气血提高)

不会玩这个职业, 随便写的, 打个大战还是没问题, 当前目标选中boss就行了 (其实你选谁都无所谓, 选中boss作为目标是要在目标位置放青川濯莲)
--]]

--宏选项
addopt("手动逐云寒蕊", false)
addopt("手动青川濯莲", false)

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

	--初始化变量
	v["治疗量"] = charinfo("治疗量")
	v["药性"] = yaoxing()
	v["治疗目标"] = f["获取治疗目标"]()
	v["治疗目标血量"] = xlife(v["治疗目标"])
	local tSpeedXY, tSpeedZ = speed(tid())
	v["目标静止"] = rela("敌对") and tSpeedXY <= 0 and tSpeedZ <= 0


	--逐云寒蕊
	if not getopt("手动逐云寒蕊") and fight() and v["目标静止"] and target("boss") and dis() < 10 then
		v["逐云寒蕊"] = npc("模板ID:106623")
		if v["逐云寒蕊"] == 0 then
			_, v["没落黄队友数量"] = party("没状态:重伤", "平面距离<10", "buff时间:落黃<-1")
			if v["没落黄队友数量"] >= 4 then
				cast("逐雲寒蕊")
			end
		end
	end

	--青川濯莲
	if not getopt("手动青川濯莲") and fight() and v["目标静止"] and target("boss") then
		cast("青川濯蓮")
	end

	--银光照雪
	if v["治疗目标血量"] < 0.7 and xdis(v["治疗目标"]) < 6 and xxface(id(), v["治疗目标"]) < 130 then
		cast("銀光照雪")
	end
	
	---------------------------------------------

	--龙葵自苦
	if fight() and v["治疗目标血量"] < 0.4 then
		CastX("龍葵自苦")
	end

	--七情和合
	if fight() and v["治疗目标血量"] < 0.6 then
		CastX("七情和合")
	end

	--当归四逆
	if v["治疗目标血量"] < 0.8 then
		CastX("當歸四逆")
	end

	--赤芍寒香
	if v["治疗目标血量"] < 0.95 then
		CastX("赤芍寒香")
	end

	--白芷含芳
	if v["治疗目标血量"] < 0.95 then
		CastX("白芷含芳")
	end
end

-------------------------------------------------------------------------------

f["获取治疗目标"] = function()
	local targetID = id()	--治疗目标先设置为自己, 不在队伍或者团队中时 party 返回 0
	local partyID = party("没状态:重伤", "不是自己", "距离<20", "视线可达", "没载具", "气血最少")	--获取血量最少队友
	if partyID ~= 0 and partyID ~= targetID and xlife(partyID) < life() then	--有血量最少队友且别比自己血量少
		targetID = partyID	--把他指定为治疗目标
	end
	return targetID
end

--对治疗目标使用技能
function CastX(szSkill)
	if xcast(szSkill, v["治疗目标"]) then
		if v["记录信息"] then PrintInfo() end
		return true
	end
	return false
end

--记录信息
function PrintInfo(s)
	local t = {}
	if s then t[#t+1] = s end
	t[#t+1] = "药性:"..v["药性"]
	t[#t+1] = "治疗目标:"..v["治疗目标"]
	t[#t+1] = "治疗目标血量:"..format("%0.2f", v["治疗目标血量"])

	print(table.concat(t, ", "))
end

--记录战斗状态改变
function OnFight(bFight)
	if bFight then
		print("--------------------进入战斗")
	else
		print("--------------------离开战斗")
	end
end
