--[[ 奇穴: [尻尾][无常][黯影][虫兽][桃僵][不鸣][嗜蛊][祭礼][荒息][篾片蛊][啖灵][蛇悉]
秘籍:
蝎心  2读条 2伤害
蛇影  1会心 1持续 2伤害
百足  1调息 3伤害
灵蛊  1距离 3伤害
献祭  2调息
--]]

--关系自动面向
setglobal("自动面向", false)

--宏选项
addopt("副本防开怪", false)
addopt("打断", false)

--主循环
function Main()
	--减伤
	if fight() and pet() and life() < 0.5 then
		if cast("玄水蛊") then
			settimer("玄水蛊")
		end
	end

	--凤凰蛊
	if qixue("荒息") then
		if rela("敌对") and dis() < 30 then
			if nobuff("凤凰蛊") or nofight() then
				cast("凤凰蛊")
			end
		end
	end

	--召宝宝
	if nopet("灵蛇") or (buff("23063") and not qixue("祭礼")) then		--23063, 献祭后招宝宝无GCD
		cast("灵蛇引")
	end

	--目标不是敌对，结束
	if not rela("敌对") then return end

	--副本防开怪
	if getopt("副本防开怪") and dungeon() and nofight() then return end

	--灵蛊
	if tnobuff("迷心蛊|枯残蛊|夺命蛊", id()) or cn("灵蛊") > 1 then
		cast("灵蛊")
	end
	if getopt("打断") and tbuffstate("可打断") then
		cast("灵蛊")
	end

	--有宠物
	if pet() then
		cast("攻击")
		cast("幻击")

		--蛊虫献祭
		if rela("敌对") and dis() < 20 and cdleft(16) <= 1 and cdleft(16) >= 0.5 then 
			if qixue("祭礼") or (scdtime("灵蛇引") <= 0 and nobuff("玄水蛊") and gettimer("玄水蛊") > 0.5) then
				if qixue("荒息") then
					if buff("凤凰蛊", id()) then
						cast("蛊虫献祭")
					end
				else
					cast("蛊虫献祭")
				end
			end
		end
	end

	--等待读条结束
	if casting() and castleft() < 0.13 then settimer("等待读条结束") end
	if gettimer("等待读条结束") < 0.3 then return end

	
	--目标没蛇影
	if tbufftime("蛇影", id()) <= 1.625 then	--1.625并没有什么特殊含义，随手打的大于一个GCD
		cast("蛇影")
	end

	--篾片蛊
	cast("篾片蛊")

	--有破招buff
	if buff("24479") then
		cast("蝎心")
	end

	--蛇影快充能结束
	if cntime("蛇影", true) < 3 then
		cast("蛇影")
	end
	
	--百足
	cast("百足")

	if tbufftime("蟾啸", id()) <= 1.625 then
		cast("蟾啸")
	end

	cast("蛇影")
	cast("蟾啸")
	cast("凤凰蛊")
	cast("蝎心")
end

--释放技能
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	--如果释放技能的是自己
	if CasterID == id() then
		if SkillID == 13430 then	--蛇影
			deltimer("等待读条结束")
			return
		end

		if SkillID == 2209 then		--蝎心
			deltimer("等待读条结束")
			return
		end

		if SkillID == 29573 then	--篾片蛊
			print("OnCast", SkillName, SkillID, SkillLevel)	--用于查看打的是几级
			return
		end
	end
end
