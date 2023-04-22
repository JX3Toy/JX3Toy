--[[镇派
[毒感]2 [尻尾]3 [无常]2
[秋幕]3 [蛇眼]2 [不鸣]2
[蜿蜒]2 [生发]3 [祭灵]1
[虫兽]2 [祭礼]3
[蛇涎]1 [桃僵]2 [暗影]3 [分澜]1
[蛊虫狂暴]1
[纳精]3
--]]
--推荐1段加速
--宠物名: 圣蝎, 风蜈, 天蛛, 灵蛇, 玉蟾, 碧蝶

--关闭自动面向
setglobal("自动面向", false)

--宏选项
addopt("副本防开怪", false)
addopt("蟾躁", false)

--变量表
local v = {}

--主循环
function Main(g_player)
	--副本处理
	local mapName = map()
	local func = tMapFunc[mapName]
	if func then
		func(g_player)
	end

	--[[没进战，先招个蝎子
	if nofight() and nopet("圣蝎") then
		cast("圣蝎引")
	end
	--]]
	
	--召宠物
	if nopet() then
		cast("灵蛇引")
		cast("圣蝎引")
	end

	--减伤
	if fight() then
		if life() < 0.2 then
			cast("化蝶")
		end
		if life() < 0.6 and pet() then
			cast("玄水蛊")
		end
	end

	--目标不是敌人, 结束
	if not rela("敌对") then return end

	--副本防开怪
	if getopt("副本防开怪") and dungeon() and nofight() then return end

	if tbuff("隐遁") then
		bigtext("目标无敌", 0.5)
		return
	end

	v["目标血量较多"] = rela("敌对") and tlifevalue() > lifemax() * 10		--目标血量大于自己最大血量10倍

	--狂暴给蛇，插入到献祭中间
	if v["目标血量较多"] and pet("灵蛇") and xxdis(petid(), tid()) < 4 and lasttime("蛊虫献祭") > 2 and lasttime("蛊虫献祭") < 10 then
		cast("蛊虫狂暴")
	end

	--处理宠物
	if pet() then
		if v["目标血量较多"] and dis() < 20 then
			if cdtime("灵蛇引") < 2  or cdtime("圣蝎引") < 2 then
				if cast("蛊虫献祭") then
					settimer("蛊虫献祭")
				end
			end
		end

		if gettimer("蛊虫献祭") > 0.5 then
			if pettid() ~= tid() then		--宠物的目标不是自己的目标
				cast("攻击")
			end
			cast("幻击")

			if getopt("蟾躁") and xxdis(petid(), tid()) < 5.5 then
				cast("蟾躁")
			end
		end
	end

	--目标有不是自己的夺命蛊, 就用其它两种
	if tbufftime("夺命蛊") > 16 and tnobuff("夺命蛊", id()) then
		cast("枯残蛊")
		cast("迷心蛊")
	end
	cast("夺命蛊")

	if tnobuff("百足", id()) then
		cast("百足")
	end

	if tbufftime("蛇影", id()) < 3 then
		cast("蛇影")
	end
	
	if tnobuff("蟾啸", id()) then
		cast("蟾啸")
	end

	cast("蝎心")
	cast("千丝")
end

-------------------------------------------------副本处理
tMapFunc = {}

tMapFunc["归墟秘境"] = function(g_player)
	--击飞
	if tcasting("击飞") then
		stopcasting()
		if tcastleft() < 0.5 then
			cast("蹑云逐月")
			cast("迎风回浪")
			cast("凌霄揽胜")
			cast("瑶台枕鹤")
		end
		exit()
	end

	--护体
	if tcasting("护体") and tcastleft() < 0.5 then
		settimer("目标读条护体")
	end
	if gettimer("目标读条护体") < 1 or tbuff("4147") then	--护体 反弹伤害
		stopcasting()
		exit()
	end
end
