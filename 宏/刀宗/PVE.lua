--输出不高，不用吃影子，站桩就行了
output("奇穴: [中峙][聚疏][雨积][放皓][威声][击懈][镇机][长溯][驭耀][强膂][斩颓][截辕]")

--宏选项
addopt("副本防开怪", true)

--关闭自动面向
setglobal("自动面向", false)

--变量表
local v = {}

--主循环
function Main(g_player)

	v["锐意"] = energy()
	v["单手"] = buff("24029") and gettimer("断云势") > 0.3 and gettimer("灭影追风") > 0.3
	v["双持"] = buff("24110") and gettimer("孤锋破浪") > 0.3

	--没进战打出识破
	if rela("敌对") and dis() < 30 and nofight() and nobuff("识破") and nobuff("切换标记") and miji("驰风八步", "《游风步·驰风八步》人偶图残页") then
		if cast("驰风八步") then
			return
		end
	end

	--副本防开怪
	if getopt("副本防开怪") and dungeon() and nofight() then return end

	--打断
	if tbuffstate("可打断") then
		cast("遏云势")
	end

	---------------------------------------------双持
	v["破浪距离"] = 6
	if qixue("急潮") then
		v["破浪距离"] = v["破浪距离"] + 2
	end

	--孤锋破浪
	if rela("敌对") and dis() < v["破浪距离"] and face() < 80 then
		if tbuffsn("长溯", id()) >= 3 then
			if cast("孤锋破浪") then
				settimer("孤锋破浪")
				return
			end
		end
	end

	--横云断浪
	if tbufftime("破绽", id()) > 6 then
		cast("横云断浪")
	end

	--沧浪三叠
	if rela("敌对") and dis() < v["破浪距离"] and face() < 80 then
		cast("沧浪三叠")
	end
	
	---------------------------------------------单手

	--留客雨, 减单手GCD 1秒, 决云势CD 4秒
	if cdleft(2436) >= 1 and cdleft(2425) > 2 then
		cast("留客雨")
	end

	--灭影追风
	if rela("敌对") and dis() < 6 then
		if v["单手"] and cdtime("决云势") > 2 and cdtime("停云势") > 2 and cdtime("留客雨") > 1 and v["锐意"] < 80 and tbufftime("破绽", id()) > 6 then
			if cast("灭影追风") then
				settimer("灭影追风")
				return
			end
		end
	end
	
	--断云势
	v["断云势距离"] = 4
	if miji("断云势", "《流云势法·断云势》真传绝章") then
		v["断云势距离"] = v["断云势距离"] + 4
	end
	if rela("敌对") and dis() < v["断云势距离"] and face() < 80 then
		if cast("断云势") then
			settimer("断云势")
			return
		end
	end
	
	if v["锐意"] < 93 then
		cast("决云势")
		cast("停云势")
	end

	cast("行云势")
end

--释放技能
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		--打断驰风八步
		if SkillID == 32140 then
			jump()
		end
	end
end
