--载入时输出信息
output("奇穴: [尻尾][无常][黯影][虫兽][桃僵][不鸣][嗜蛊][祭礼][啖灵][篾片蛊][荒息][蛇悉]")

--宏选项
addopt("副本防开怪", true)

--变量表
local v = {}
v["等待读条释放"]= false

--主循环
function Main(g_player)

	if fight() and life() < 0.5 then
		cast("玄水蛊")
	end
	
	--召宠物
	if nopet("灵蛇") then
		cast("灵蛇引")
	end

	cast("凤凰蛊", true)

	--目标不是敌对，结束
	if not rela("敌对") then return end

	--副本防开怪
	if getopt("副本防开怪") and dungeon() and nofight() then return end

	
	--宠物攻击
	if pet() then
		if pettid() ~= tid() then		--宠物的目标不是自己的目标
			cast("攻击")
		end

		cast("幻击")

		--蛊虫献祭
		if cdleft(16) < 0.5 then	--GCD快结束
			if rela("敌对") and dis() < 19 and tlifevalue() > lifemax() * 5 then
				cast("蛊虫献祭")
			end

			_, v["目标6尺敌对数量"] = tnpc("关系:敌对", "距离<6", "可选中")
			if v["目标6尺敌对数量"] >= 3 then
				cast("蛊虫献祭")
			end
		end
	end


	--等待读条结束
	if casting() and castleft() < 0.13 then
		v["等待读条释放"] = true
		settimer("读条结束")
	end
	if v["等待读条释放"] and gettimer("读条结束") < 0.3 then
		return
	end

	cast("灵蛊")

	--有破招buff
	if buff("24479") then
		cast("蝎心")
	end

	--篾片蛊
	if tlifevalue() > lifemax() then	--目标气血大于自己最大气血, 快挂了，就不用这个
		cast("篾片蛊")
	end

	cast("蛇影")
	cast("百足")
	cast("蟾啸")

	cast("蝎心")
	cast("千丝")
end


--释放技能
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	--如果释放技能的是自己
	if CasterID == id() then
		-- 蛇影 蝎心 释放，结束等待
		if SkillID == 13430 or SkillID == 2209 then
			v["等待读条释放"] = false
		end
	end
end
