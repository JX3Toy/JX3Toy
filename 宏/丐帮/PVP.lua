output("奇穴: [安患][御龙][洪荒][醉逍遥][烟霞][越渊][温酒][驯致][贞固][宽野][无咎][潜龙勿用]")
--可选奇穴: [流形][飞龙][留魄][腾龙][游君]

--载入库
load("Macro/Lib_PVP.lua")

--变量表
local v = {}

--函数表
local f = {}

f["酒中仙"] = function()
	if cast("酒中仙") then
		stopmove()			--停止移动
		nomove(true)		--禁止移动
		settimer("酒中仙")
		exit()
	end
end

f["笑醉狂"] = function()
	--防止空中放笑醉狂
	if height() > 2 then return end

	if cast("笑醉狂") then
		stopmove()			--停止移动
		nomove(true)		--禁止移动
		settimer("笑醉狂")
		exit()
	end
end

f["目标方向烟雨行"] = function()
	local t = {
		["前"] = 5505,
		["后"] = 5506,
		["左"] = 5507,
		["右"] = 5508,
		["未知方位"] = 5269,
	}

	if cast(t[xdir(tid())]) then
		settimer("烟雨行")
		exit()
	end
end


--主循环
function Main(g_player)
	--初始化
	g_func["初始化"]()

	--笑醉狂、酒中仙防打断
	if gettimer("笑醉狂") < 0.5 or gettimer("酒中仙") < 0.5 or casting("酒中仙|笑醉狂") then
		return
	else
		nomove(false)
	end

	f["规避伤害"]()

	--起手喝酒
	if g_var["附近敌人数量"] > 0 and nobuff("酣畅淋漓") then
		f["酒中仙"]()
	end

	--减伤
	if fight() then
		if buffstate("减伤效果") < 40 then
			--龙啸
			v["放龙啸九天"] = false
			
			if qixue("无咎") and life() < 0.6 then
				v["放龙啸九天"] = true
			end

			if life() < 0.5 then
				v["放龙啸九天"] = true
			end

			if v["放龙啸九天"] and cast("龙啸九天") then
				return
			end
		end

		if life() < 0.35 then
			f["笑醉狂"]()
		end
	end

	f["处理啸影"]()

	--打伤害
	if g_var["目标可攻击"] then
		--if not g_var["目标巨门北落"] and not g_var["目标高反伤"] then
		f["打伤害"]()
	end

	--乘龙戏水
	if g_var["附近敌人数量"] > 0 then
		cast("乘龙戏水")
	end

	--伤害技能没用出来, 喝酒免控
	if qixue("宽野") and g_var["附近敌人数量"] > 0 then
		f["酒中仙"]()
	end


	f["解控"]()

	--挂扶摇
	if jjc() then
		if cdleft(590) <= 0 or cdleft(590) > 0.35 then
			cast("扶摇直上")
		end
	end

	--采集任务物品
	if nofight() then
		g_func["采集"](g_player)
	end
end


f["打伤害"] = function()

	--烟雨行卡掉潜龙僵直
	if gettimer("释放潜龙勿用") < 0.5 then
		f["目标方向烟雨行"]()
	end

	--潜龙勿用
	if bufftime("12522") < 3.125 then	--12522驯致亢龙接潜龙
		cast(18678)	--[驯致]潜龙
	end

	--龙战于野
	v["龙战+亢龙需要内力"] = 0.5
	if qixue("越渊") and bufftime("酣畅淋漓") > 0.5 then
		v["龙战+亢龙需要内力"] = 0.375
	end

	if g_var["突进"] then
		if mana() >= v["龙战+亢龙需要内力"] then
			cast("龙战于野")
		end
	end

	--醉逍遥
	v["亢龙需要内力"] = 0.3
	if qixue("越渊") and bufftime("酣畅淋漓") > 0.5 then
		v["亢龙需要内力"] = 0.225
	end

	--亢龙前面放
	if dis() < 8 then
		if mana() >= v["亢龙需要内力"] then
			cast("醉逍遥")
		end
	end
	
	--时间快到了
	if bufftime("6433") <= 1 then
		cast("醉逍遥")
	end

	--亢龙有悔
	cast("亢龙有悔")

	
	--犬牙交错, 需要buff 6075
	if dis() < 6 then
		cast("犬牙交错")
	end

	--恶狗
	if dis() < 6 then
		if face() < 60 then
			cast("恶狗拦路")
		else
			acast("恶狗拦路")
		end
	end

	--温酒
	if dis() < 40 and qixue("温酒") and bufftime("温酒") < 0 then
		f["酒中仙"]()
	end

	--被缴械喝酒回蓝
	if buffstate("缴械时间") > 2 then
		f["酒中仙"]()

		--喝酒CD了，就起跳
		if buff("弹跳") then
			jump()
		end
	end

	--见龙时间快到了打伤害，没提升就注释掉
	if g_var["突进"] and bufftime("12422") < 1 then
		cast("见龙在田")
	end

	--拨狗朝天
	cast("拨狗朝天")
	cast("横打双獒")

	--蜀犬吠日, 回蓝60%
	if tbuffstate("可僵直") then
		cast("蜀犬吠日")
	end

	--棒打狗头, 回蓝20%
	if g_var["突进"] then
		cast("棒打狗头")
	end

	--龙跃于渊, 追人
	if g_var["突进"] then
		cast("龙跃于渊")
	end

	--龙战追人
	if g_var["突进"] then
		cast("龙战于野")
	end
end


f["解控"] = function()
	--蹑云解僵直
	if buffstate("僵直时间") > 0.5 then
		if cast("蹑云逐月") then
			return
		end
	end

	v["正面20尺敌人"] = enemy("距离<20", "角度<90", "距离最近")

	--棒打解锁足
	if buffstate("锁足时间") > 2 and qixue("安患") then
		if cast("棒打狗头") then
			return
		end
		if v["正面20尺敌人"] ~= 0 then
			xcast("棒打狗头", v["正面20尺敌人"])
		end
	end

	--烟雨行, 解锁足
	if buffstate("锁足时间") > 2 then
		f["目标方向烟雨行"]()
	end
	
	--见龙
	if buffstate("定身时间") > 2 or buffstate("眩晕时间") > 2 or buffstate("击倒时间") > 1.5 or buffstate("僵直时间") > 1 then
		--对目标用见龙
		if cast("见龙在田") then
			return
		end
		
		if qixue("接舆") then
			if v["正面20尺敌人"] ~= 0 then
				if xcast("见龙在田", v["正面20尺敌人"]) then
					return
				end
			end
		else
			v["正面20尺有破绽敌人"] = enemy("距离<20", "角度<90", "buff时间:12421>0.2", "距离最近")
			if v["正面20尺有破绽敌人"] ~= 0 then
				if xcast("见龙在田", v["正面20尺有破绽敌人"]) then
					return
				end
			end
		end
	end

	--龙啸九天
	if buffstate("定身时间") > 2 or buffstate("眩晕时间") > 2 or buffstate("击倒时间") > 1.5 or buffstate("僵直时间") > 1 then
		if cast("龙啸九天") then
			return
		end
	end

	--笑醉狂
	if buffstate("定身时间") > 2 or buffstate("眩晕时间") > 2 or buffstate("击倒时间") > 1.5 or buffstate("僵直时间") > 1 then
		f["笑醉狂"]()
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


local tBuff = {
--[20939] = "温酒",
--[5754] = "霸体|龙威",
--[24621] = "潜龙勿用·乾",
}

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

--释放技能
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		if SkillID == 8490 then
			settimer("释放亢龙有悔")
		end
		if SkillID == 18678 then
			settimer("释放潜龙勿用")
		end
	end
end

--[[状态更新
function OnStateUpdate(nCurrentLife, nCurrentMana, nCurrentRage, nCurrentEnergy, nCurrentSunEnergy, nCurrentMoonEnergy)
	--输出内力变动
	print("OnStateUpdate, 内力: ", nCurrentMana)
end
--]]

--[[门派相关数据
潜龙僵直28帧
亢龙一掌僵直34帧
--]]
