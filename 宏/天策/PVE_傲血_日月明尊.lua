--[[镇派
[击水]2 [烽火]3 [避荒]1
[埋骨]3 [神勇]2 [激雷]2 [长征]2
[英灵]2 [豪魄]3 [飞将]1
[白羽]3 [夜征]2 [破楼兰]1
[挫锐]2
[霹雳]1
[巨细]2 [勤王]3
[林虎]1
--]]

--关闭自动面向
setglobal("自动面向", false)

--添加选项, 副本中没进战不放技能, 默认关闭
addopt("副本防开怪", false)

--变量表
local v = {}

--函数表
local f = {}

--主循环
function Main()
	--减伤
	f["减伤"]()

	--副本防开怪
	if getopt("副本防开怪") and dungeon() and nofight() then return end

	--打断
	if tbuffstate("可打断") and tcastleft() < 1 then
		cast("崩")
	end

	v["目标血量较多"] = tlifevalue() > lifemax() * 5		--目标当前血量大于自己最大血量5倍

	if rela("敌对") and dis() < 4 and v["目标血量较多"] and cdleft(16) < 0.5 then
		--徐如林
		if fight() and cdleft(16) < 0.5 then
			if life() < 0.8 or mana() < 0.8 then
				cast("徐如林")
			end
		end
		
		--猛虎下山
		cast("猛虎下山")

		--疾如风
		if bufftime("烈雷") > 3 then
			cast("疾如风")
		end

		--撼如雷
		if bufftime("背水") > 3 then
			cast("撼如雷")
		end
	end

	--上流血
	if tbuff("致残", id()) then
		if tnobuff("流血", id()) then
			cast("破风")
		end

		if tbuff("流血", id()) then
			cast("灭")
		end
	end

	--[[
	if buffsn("龙魂") >= 5 and bufftime("龙魂") > 6 and tbufftime("流血", id()) > 6 then
		cast("霹雳")	
	end
	--]]

	cast("龙牙")
	cast("龙吟")
	cast("霹雳")

	cast("穿云")


	--渊
	v["适合渊的队友"] = tparty("没状态:重伤", "不是内功:洗髓经|铁牢律|明尊琉璃体|铁骨衣", "距离>10", "距离<25", "自己距离>6", "自己距离<20")
	if rela("敌对") and cdtime("突") < 0.5 and nobuff("弹跳") and gettimer("扶摇直上") > 0.5 then
		if cdleft(16) > 1 or cdleft(16) <= 0 then
			if v["适合渊的队友"] ~= 0 then
				xcast("渊", v["适合渊的队友"])
			end
		end
	end

	--突
	if state("跳跃") then
		cast("突")
	end

	--跳
	if rela("敌对") and dis() < range("突") and cdtime("突") < 0.5 and nostate("跳跃") then
		local bJump = false
		if dis() > 8 then
			bJump = true
		end
		if buff("弹跳") and (cdleft(16) > 1 or cdleft(16) <= 0) then
			bJump = true
		end
		if bJump then
			jump()
			settimer("跳")
		end
	end

	--扶摇
	if rela("敌对") and gettimer("跳") > 0.5 and dis() < 8 then
		if v["适合渊的队友"] == 0 or cdtime("渊") > 1 then
			if cast("扶摇直上") then
				settimer("扶摇直上")
			end
		end
	end

end

--减伤
f["减伤"] = function()
	--没进战不用减伤技能
	if nofight() then return end

	--啸如虎
	cast("啸如虎")

	--御
	if gettimer("守如山") > 0.3 and nobuff("守如山") and rela("敌对") and ttid() == id() then
		if dis() < 4 or (tcasting() and tcastleft() < 1) then		--距离小于4尺 或 读条剩余时间小于1秒
			if cast("御") then
				settimer("御")
				return
			end
		end
	end

	--守如山
	if gettimer("御") > 0.3 and nobuff("御") then
		if life() < 0.5 then
			if cast("守如山") then
				settimer("守如山")
				return
			end
		end
	end
end
