output("奇穴:[渊壑][扶桑][羽彰][清源][游仙][风驰][鸿轨][怅归][溯徊][驰行][梦悠][濯流]")

--宏选项
addopt("副本防开怪", true)

--变量表
local v = {}
v["等待定波释放"] = false
v["物化次数"] = 0
v["上升次数"] = 0

--主循环
function Main(g_player)
	
	--读条定波
	if casting("定波砥澜") then
		--调整面向
		if face() > 80 then
			turn()
		end
		--中断定波读条
		if castpass() >= 1.1875 then
			stopcasting()
			settimer("定波砥澜读条结束")
		end
	end

	--目标不是敌对，结束
	if not rela("敌对") then return end

	--副本防开怪
	if getopt("副本防开怪") and dungeon() and nofight() then return end


	cast("翼绝云天")
	cast("振翅图南")
	

	v["有驰风震域"] = npc("关系:自己", "模板ID:64696", "角色距离<5.5") ~= 0 or gettimer("定波砥澜读条结束") < 0.5

	-------------------------------------------------------天上
	if buff("14540") then		--浮游天地, 有重名，用ID
		--落地和上升
		if scdtime("溟海御波") > 2 and scdtime("海运南冥") > 2 and scdtime("逐波灵游") > 2 then
			if bufftime("鸿轨") < 3 then
				--上升
				if scdtime("逐波灵游") > 2 and gettimer("物化天行·上升") > 0.3 and cast("物化天行·上升") then
					settimer("物化天行·上升")
				end
			else
				--落地
				if gettimer("浮游天地·落地") > 0.3 and cast("浮游天地·落地") then
					settimer("浮游天地·落地")
				end
			end
		end

		--加一个次数判断，偶尔网络延迟三掌有一个没打出，上面的落地逻辑就有问题
		if v["上升次数"] >= 2 then
			--落地
			if gettimer("浮游天地·落地") > 0.3 and cast("浮游天地·落地") then
				settimer("浮游天地·落地")
			end
		end
		
		--13781, 物化天行标记
		if buff("13781") then
			cast("溟海御波")
			
			if dis3() < 4 then
				cast("海运南冥")
			end

			--第二次再放逐波灵游(或者用鸿轨时间判断), 打了几分钟木桩貌似没提升, 也可以用鸿轨时间判断
			--if v["物化次数"] > 1 then
				cast("逐波灵游")
			--end
		else
			cast("物化天行")
		end

	-------------------------------------------------------地面
	else
		if v["有驰风震域"] and scdtime("溟海御波") < 1.5 and scdtime("海运南冥") < 1.5 and scdtime("物化天行") < 1.5 then
			if scdtime("跃潮斩波") > 2 then
				cast("浮游天地")
				return
			end
		end

		if dis() < 5.5 and gettimer("定波砥澜读条结束") > 0.3 then
			cast("定波砥澜")
		end

		cast("跃潮斩波")

		cast("木落雁归")

		if dis() < 6 then
			acast("击水三千")
		end
	end
end


--释放技能
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		--[[定波
		if SkillID == 20733 then
			v["等待定波释放"] = false
		end
		--]]

		--浮游天地
		if SkillID == 19828 then		
			v["物化次数"] = 0	--物化次数置0
			v["上升次数"] = 0
		end

		--物化天行 20049
		if SkillID == 20049 then
			v["物化次数"] = v["物化次数"] + 1
		end

		--物化上升
		if SkillID == 20051 then
			v["上升次数"] = v["上升次数"] + 1
		end
	end
end
