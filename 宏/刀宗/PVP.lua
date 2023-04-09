output("奇穴: [渊冲][袭伐][雾灭][急潮][电逝][观衅][镇机][识意][周流][辞霈][亘绝][截辕]")

--[[秘籍
行云 1会心2伤害1距离
停云 1会心2伤害1距离1CD
绝云 2效果2伤害
断云 1会心2伤害1距离
凝云 2伤害2距离

驰风 2CD2效果
游风 2CD2持续

沧浪 1会心3伤害
横云 1会心2伤害1距离(1冲刺)
孤风 2会心2伤害

留客 1会心2伤害1距离
触石 2CD1效果1伤害
--]]


--载入库
load("Macro/Lib_PVP.lua")

--变量表
local v = {}
v["等待单双切换"] = false

--函数表
local f = {}

--主循环
function Main(g_player)
	--初始化
	g_func["初始化"]()

	--等待
	if v["等待单双切换"] then
		if gettimer("断云势") < 0.3 or gettimer("孤锋破浪") < 0.3 then
			print("等待单双切换")
			return
		end
	end

	--初始化门派相关数据
	v["锐意"] = energy()
	v["单手"] = buff("24029")--and gettimer("断云势") > 0.3
	v["双持"] = buff("24110")--and gettimer("孤锋破浪") > 0.3
	v["身形数量"] = 0
	if buff("24105") then v["身形数量"] = v["身形数量"] + 1 end
	if buff("24106") then v["身形数量"] = v["身形数量"] + 1 end
	if buff("24107") then v["身形数量"] = v["身形数量"] + 1 end

	f["规避伤害"]()

	--凝云势
	if buff("23898") or gettimer("凝云势") < 0.5 then
		f["找身形"]()
		return
	end

	if f["没免控"] and cdtime("游风飘踪") > 8 and enemy("距离<30", "目标是我") ~= 0 then
		if nobuff("识破") and v["锐意"] < 50 then
			if cast("凝云势") then
				settimer("凝云势")
				return
			end
		end
	end


	f["处理啸影"]()

	f["游风飘踪"]()
	f["灭影追风"]()

	f["驰风八步一段"]()
	f["驰风八步二段"]()

	--打控制
	if g_var["目标可控制"] and target("player") then
		f["打控制"]()
	end

	--打伤害
	if g_var["目标可攻击"] then
		f["打伤害"]()
	end

	--找身形
	if v["双持"] and dis() > 15 and nobuff("识破") then
		f["找身形"]()
	end

	--被缴械
	f["处理洗兵雨"]()

	if buffstate("缴械时间") > 2 then
		if cast("扶摇直上") then
			jump()
		end
	end

	--采集任务物品
	if nofight() then
		g_func["采集"](g_player)
	end
end

f["没免控"] = function()
	return buffstate("免击倒时间") <= 0 and gettimer("驰风八步一段") > 0.25 and gettimer("凝云势") > 0.25
end

f["游风飘踪"] = function()
	if buffstate("锁足时间") > 1.5 or buffstate("定身时间") > 1.5 or buffstate("眩晕时间") > 1.5 or buffstate("击倒时间") > 1.5 or buffstate("僵直时间") > 0.5 then
		cast("游风飘踪")
	end

	--[[
	if f["没免控"]() and enemy("距离<30", "可视自己") ~= 0 then
		cast("游风飘踪")
	end
	--]]
end

f["灭影追风"] = function()
	if enemy("距离<30", "可视自己") ~= 0 then
		cast("灭影追风")
	end
end

f["释放驰风八步一段"] = function(szLog, bStop)
	if cast(32140) then
		print("驰风八步一段: "..szLog)
		v["终止驰风一段"] = bStop
		settimer("驰风八步一段")
		exit()
	end
end

f["驰风八步一段"] = function()
	--没进战，先打出识破
	if v["单手"] and nofight() and nobuff("识破") and enemy("距离<40") ~= 0 then
		f["释放驰风八步一段"]("没进战打识破", true)
	end

	--吸收身形
	if v["单手"] and nobuff("识破") and v["身形数量"] > 0 then
		f["释放驰风八步一段"]("吸收身形", true)
	end
end

f["驰风八步二段"] = function()
	if gettimer("驰风八步二段") < 0.3 then return end

	--追人
	if g_var["目标可攻击"] and g_var["突进"] and canmove(id(), tid(), id(), 25)  then

		if v["单手"] then
			if dis() > 25 or (nobuff("识破") and dis() > 18)  then
				if acast(32141) then
					print("驰风八步二段, 单手追人")
					settimer("驰风八步二段")
					exit()
				end
			end
		end

		if v["双持"] then
			if dis() > 15 then
				if acast(32141) then
					print("驰风八步二段, 双手追人")
					settimer("驰风八步二段")
					exit()
				end
			end
		end
	end
end

f["打控制"] = function()
	--洗兵雨, 缴械
	if tmounttype("内功|外功|天罗") and tbuffstate("可缴械") and tbuffstate("缴械时间") < 0 then
		cast("洗兵雨")
	end

	--触石雨
	if v["单手"] and g_var["突进"] and nobuff("识破") and tbuffstate("可击倒") and dis() > 10 then
		if cast("触石雨") then
			exit()
		end
	end
end


f["打伤害"] = function()
	---------------------------------------------单手
	if v["单手"] then
		--凝云势·破锋
		cast("凝云势·破锋")
		
		--留客雨
		if cdleft(2436) >= 1 then
			cast("留客雨")
		end

		--断云势
		if dis() < range("断云势", true) then
			if face() < 60 then
				if cast("断云势") then
					settimer("断云势")
					v["等待单双切换"] = true
					exit()
				end
			else
				if acast("断云势") then
					settimer("断云势")
					v["等待单双切换"] = true
					return
				end
			end
		end

		--决云势
		if g_var["突进"] and buff("识破") and canmove(id(), tid(), id()) then
			if cast("决云势") then
				settimer("决云势")
			end
		end

		--三段行云
		if bufflv("23877") >= 2 or buff("24553") then
			if cast("行云势") then
				print("三段行云")
			end
		end

		if gettimer("驰风八步一段") > 0.25 and nobuff("识破") then
			--停云势, 10点锐意
			if v["锐意"] <= 40 or (v["锐意"] > 50 and v["锐意"] <= 90) then
				cast("停云势")
			end

			--行云势
			if cast("行云势") then
				print("普通行云", "身形数量", v["身形数量"])
			end
		end

	end

	---------------------------------------------双持
	if v["双持"] then
		v["破浪距离"] = 6
		if qixue("急潮") then
			v["破浪距离"] = v["破浪距离"] + 2
		end

		--横云断浪
		cast("横云断浪")

		--孤锋破浪
		if dis() < v["破浪距离"] and visible() then
			if cdtime("孤锋破浪") <= 0 then
				cast("灭影追风")
			end
			if acast("孤锋破浪") then
				settimer("孤锋破浪")
				v["等待单双切换"] = true
				exit()
			end
		end

		--沧浪三叠
		if dis() < v["破浪距离"] then
			if face() < 60 then
				cast("沧浪三叠")
			else
				acast("沧浪三叠")
			end
		end

	end
end

f["找身形"] = function()
	--有识破不找身形
	if buff("识破") then return end
	
	--移动找身形
	v["距离最近身形"] = npc("模板ID:111366", "距离最近")
	if v["距离最近身形"] ~= 0 and xdis(v["距离最近身形"]) < 15 then
		bigtext("找身形", 0.5)
		print("找身形")
		stopmove()
		moveto(xpos(v["距离最近身形"]))
		return
	end
end

f["处理洗兵雨"] = function()
	if bufftime("洗兵雨") > 1 then
		local x, y, z, dist, id = doodad(9810)	--获取掉落兵器坐标, 各门派表现ID不同
		if x > 0 then
			stopmove()
			moveto(x, y, z)	--向指定位置移动
			exit()
		end
	end
end

--躲各种技能
f["规避伤害"] = function()
	--藏剑 风来吴山
	v["读条风来吴山敌人"] = enemy("平面距离<10", "读条:风来吴山")
	if v["读条风来吴山敌人"] ~= 0 then
		if acast2("蹑云逐月", v["读条风来吴山敌人"], 12) then
			bigtext("躲风来吴山读条")
			return
		end
	end
	v["敌对风来吴山Npc"] = npc("关系:敌对", "平面距离<10", "模板ID:57739")
	if v["敌对风来吴山Npc"] ~= 0 then
		if acast2("蹑云逐月", v["敌对风来吴山Npc"], 12) then
			bigtext("躲风来吴山Npc")
			return
		end
	end

	--七秀 霜天剑泠
	v["霜天剑泠源角色"] = buffsrc("霜天剑泠")
	if v["霜天剑泠源角色"] ~= 0 then
		if acast2("蹑云逐月", v["霜天剑泠源角色"], 17) then
			bigtext("拉断霜天剑泠")
			return
		end
	end

end

--处理啸影, 打伤害之前调用
f["处理啸影"] = function()
	v["啸影源角色"] = buffsrc("啸影")
	if v["啸影源角色"] ~= 0 then
		v["啸影NPC"] = npc("模板ID:58636", "主人:"..v["啸影源角色"])
		if v["啸影NPC"] ~= 0 then
			acast2("蹑云逐月", v["啸影NPC"], 16)
		end
		bigtext("被啸影")
		exit()
	end
end


--释放技能
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		--打断驰风八步
		if SkillID == 32140 then
			if v["终止驰风一段"] then
				jump()
				print("终止驰风一段")
			end
			return
		end
		--断云势 孤锋破浪 等待结束
		if SkillID == 32135 or SkillID == 32145 then
			v["等待单双切换"] = false
			return
		end
	end
end

local tBuff = {}

--输出buff变动情况
function OnBuff(CharacterID, BuffName, BuffID, BuffLevel, StackNum, SkillSrcID, StartFrame, EndFrame, FrameCount)
	if CharacterID == id()  then
		if StackNum  > 0 then
			local bPrint = false
			if buffis(BuffID, BuffLevel, "封外功") then
				print("被沉默")
				bigtext("被沉默")
				bPrint = true
			end
			if buffis(BuffID, BuffLevel, "缴械") then
				print("被缴械")
				bigtext("被缴械")
				bPrint = true
			end
			if buffis(BuffID, BuffLevel, "锁足") then
				print("被锁足")
				bigtext("被锁足")
				bPrint = true
			end
			if buffis(BuffID, BuffLevel, "定身") then
				print("被定身")
				bigtext("被定身")
				bPrint = true
			end
			if buffis(BuffID, BuffLevel, "眩晕") then
				print("被眩晕")
				bigtext("被眩晕")
				bPrint = true
			end
			if buffis(BuffID, BuffLevel, "击倒") then
				bigtext("被击倒")
				bPrint = true
			end

			if tBuff[BuffID] or bPrint then
				print("添加buff: ".. BuffName..", ID: "..BuffID..", 等级: "..BuffLevel..", 层数: "..StackNum..", 源ID: "..SkillSrcID..", 开始帧: "..StartFrame..", 当前帧: "..FrameCount..", 结束帧: "..EndFrame..", 剩余时间: "..(EndFrame-FrameCount)/16)
			end
		else
			if tBuff[BuffID] then
				print("移除buff: ".. BuffName..", ID: "..BuffID..", 等级: "..BuffLevel..", 层数: "..StackNum..", 源ID: "..SkillSrcID..", 开始帧: "..StartFrame..", 当前帧: "..FrameCount)
			end
		end
	end
end
