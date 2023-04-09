output("奇穴:[秋霁][雪覆][折意][兵戈][北阙][天堑][玄肃][承命][星返][泣血][殷炽][青山共我]")

--载入库
load("Macro/Lib_PVP.lua")

--变量表
local v = {}
v["自己的飞刃"] = 0
v["等待岀链"] = false
v["等待收链"] = false


--函数表
local f = {}

local tMainKong = { "血覆黄泉", "幽冥窥月", "崔嵬鬼步", "日月吴钩", "孤风飒踏", "铁马冰河" }
f["没免控"] = function()
	if buffstate("免击倒时间") >= 0 then return false end
	for k,v in ipairs(tMainKong) do
		if gettimer(v) <= 0.25 then
			return false
		end
	end
	return true
end

--主循环
function Main(g_player)
	if v["等待岀链"] and gettimer("血覆黄泉") <= 0.25 then
		print("等待岀链")
		return
	end
	if v["等待收链"] and gettimer("幽冥窥月") <= 0.25 then
		print("等待收链")
		return
	end
	if buff("十方玄机") or gettimer("十方玄机") < 0.5 then
		return
	end
	
	if state("冲刺") then
		deltimer("等待冲刺")
	end
	if gettimer("等待冲刺") < 0.25 then
		return
	end

	--先打明教
	v["附近明教"] = enemy("内功:焚影圣诀", "距离<10", "buff时间:贪魔体<-1")
	if v["附近明教"] ~= 0 then
		settar(v["附近明教"])
	end
	v["附近没被限制明教"] = enemy("内功:焚影圣诀", "距离<10", "buff状态:沉默时间<-1", "buff状态:封内时间<-1", "buff状态:缴械时间<-1", "buff状态:定身时间<-1", "buff状态:眩晕时间<-1", "buff状态:击倒时间<-1")

	--初始化
	g_func["初始化"]()

	v["单链"] = buff("15524")
	v["双链"] = buff("15565")
	v["双持"] = not v["单链"] and not v["双链"]
	v["链接"] = bufftime("16662", tid()) >= 0 or bufftime("16663", tid()) >= 0
	

	local tSpeedXY, tSpeedZ = speed(tid())
	v["目标不在快速移动"] = tSpeedXY < 400 and tSpeedZ <= 0

	v["目标是治疗"] = tmount(g_var["治疗心法"])
	v["目标是近战"] = tmount(g_var["近战心法"])
	v["目标是远程"] = tmount(g_var["远程心法"])

	f["处理啸影"]()
	f["规避伤害"]()
	f["乱天狼移动"]()

	v["乱天狼条件1"] = g_var["目标可攻击"] and visible() and height() < 2 and heightz() < 8 and v["目标不在快速移动"]
	v["乱天狼条件2"] =  dis() > 6 and dis() < 12
	

	f["隐风雷"]()

	--乱天狼 免缴械
	if v["附近没被限制明教"] ~= 0 then
		acast("乱天狼")
	end

	f["飞刃回转"]()

	f["青山共我"]()

	--骤雨寒江 打伤害
	if qixue("承命") and g_var["目标可攻击"] and g_var["目标单次免伤"] <= 0 then
		if cast("骤雨寒江") then
			settimer("骤雨寒江")
		end
	end

	--崔嵬鬼步
	local szReason = f["放崔嵬鬼步"]()
	if szReason then
		if cast("崔嵬鬼步") then
			print(szReason)
		end
	end

	--乱天狼 打伤害
	if v["双持"] and v["乱天狼条件1"] and v["乱天狼条件2"] then
		if acast("乱天狼") then
			stopmove()
			exit()
		end
	end

	--斩无常
	local szReason = f["放斩无常"]()
	if szReason then
		if cast("斩无常") then
			print(szReason)
			return
		end
	end
	
	--寂洪荒
	if g_var["目标可攻击"] and v["双持"] and dis() > 6 and dis() < 12 then
		cast("寂洪荒")
	end
	
	--骤雨寒江 打控制
	if not qixue("承命") and g_var["目标可控制"] and v["链接"] then
		if qixue("星返") then
			if tbuffstate("定身时间") < 1 and tbuffstate("眩晕时间") < 1 then
				if tbuffstate("可击倒") or (tbuffstate("击倒时间") > 0.125 and tbuffstate("击倒时间") < 1) then
					cast("骤雨寒江")
				end
			end
		else
			if tbuffstate("可击倒") and tbuffstate("定身时间") < 1 and tbuffstate("眩晕时间") < 1 then
				cast("骤雨寒江")
			end
		end
	end

	--金戈回澜 冲刺
	if g_var["目标可攻击"] and g_var["突进"] then
		if (v["目标是治疗"] or v["目标是远程"]) or (buff("16071") and tbuffstate("可眩晕")) or cdtime("骤雨寒江") < 1 then	--治疗和远程直接打，近战战可控才打
			if cast(22613) then
				settimer("等待冲刺")
				return
			end
		end
	end

	--金戈回澜 普通
	if g_var["目标可攻击"] then
		cast(22144)
	end
	
	--星垂平野
	if g_var["目标可攻击"] and visible() then
		if buff("15430") then	--三段
			local x, y = xxpos(id(), tid())
			if x > 0 and x < 7 and y > -2 and y < 2 and heightz() < 6 then
				cast("星垂平野")
			end
		else
			if dis() < 6 and face() < 90 then
				cast("星垂平野")
			end
		end
	end

	--孤风飒踏
	f["孤风飒踏"]()

	--十方玄机
	if fight() and life() < 0.5 then
		f["十方玄机"]()
	end
	
	g_func["处理刀宗缴械"]()

	if buffstate("缴械时间") > 2 then
		f["十方玄机"]()
	end

	--血覆黄泉
	if f["没免控"]() then
		if cast("血覆黄泉") then
			v["等待岀链"] = true
			settimer("血覆黄泉")
			print("--------------------岀链续免控")
			exit()
		end
	end

	f["幽冥窥月"]()
	

	--[[
	if v["乱天狼条件1"] and f["目标定点时间"](2) and dis2() < 3.5 then
		if cdtime("崔嵬鬼步") < 0.5 or cdtime("乱天狼") < 0.5 then
			if v["双持"] or cast("幽冥窥月") then
				if cast("日月吴钩") then
					settimer("等待冲刺")
					print("收链日月吴钩打乱天狼")
					exit()
				end
			end
		end
	end
	--]]

	--日月吴钩
	local szReason = f["放日月吴钩"]()
	if szReason then
		if cast("日月吴钩") then
			settimer("日月吴钩")
			print(szReason)
			return
		end
	end
	--]]

	--铁马冰河
	if f["放铁马冰河"]() then
		if cast("铁马冰河") then
			exit()
		end
	end

	--蹑云解僵直
	if buffstate("僵直时间") > 0.5 then
		cast("蹑云逐月")
	end

	--挂扶摇
	if jjc() and nobuff("弹跳") then
		cast("扶摇直上")
	end

	--采集任务物品
	if nofight() then
		g_func["采集"](g_player)
	end

end

f["幽冥窥月"] = function()
	if buff("15583") then
		if f["没免控"]() then
			if cast("幽冥窥月") then
				v["等待收链"] = true
				settimer("幽冥窥月")
				print("--------------------收链续免控")
				exit()
			end
		end
	end
end

f["目标定点时间"] = function(nTime)
	if tbuffstate("锁足时间") > nTime then return true end
	if tbuffstate("定身时间") > nTime then return true end
	if tbuffstate("眩晕时间") > nTime then return true end
	if tbuffstate("击倒时间") > nTime - 0.5 then return true end
	return false
end

f["放日月吴钩"] = function()
	if v["双持"] and v["乱天狼条件1"] and f["目标定点时间"](2) and dis2() < 3.5 then
		if cdtime("崔嵬鬼步") < 0.5 or cdtime("乱天狼") < 0.5 then
			return "调整距离打乱天狼"
		end
	end
	return false
end

f["放崔嵬鬼步"] = function()
	if v["双持"] and v["乱天狼条件1"] and v["乱天狼条件2"] and f["目标定点时间"](1.5) and cdtime("乱天狼") <= 0 then
		return "崔嵬鬼步爆发打定点乱天狼"
	end
	if f["没免控"]() and cdtime("血覆黄泉") > 4 and nobuff("15583") then
		return "崔嵬鬼步续免控"
	end
	return false
end

f["隐风雷"] = function()
	--推飞刃
	v["飞刃"] = npc("关系:自己", "模板ID:107305", "距离<12")
	if v["飞刃"] ~= 0 then
		if acast("隐风雷", 0, v["飞刃"]) then
			print("隐风雷推飞刃")
			return
		end
	end

	--给飞刃留CD
	if qixue("飞刃回转") and cdtime("飞刃回转") < 20 then
		return
	end

	--目标有重置buff不打
	if tbuff("青山共我", id()) then return end
	
	--打断读条
	if g_var["目标可控制"] and visible() and dis() < 12 and tbuffstate("可推") then
		local szSkill = tcasting()
		if szSkill and tcastleft() > 0.125 and tcastleft() <= 0.5 then
			if acast("隐风雷") then
				print("隐风雷打断读条: " .. szSkill)
				return
			end
		end
	end
end

f["放斩无常"] = function()
	--减伤, 格挡远程技能
	--远程爆发 ****

	if v["双持"] and cdtime("乱天狼") > 4 then
		return "斩无常 乱天狼CD"
	end

	--续免控
	if f["没免控"]() and cdtime("血覆黄泉") > 4 and nobuff("15583") then
		return "斩无常续免控"
	end
	--if f["没免控"]() and 

	if v["附近没被限制明教"] ~= 0 then
		return "斩无常免缴械"
	end
	return false
end


f["放铁马冰河"] = function()
	--周围有己方NPC不拉
	if tnpc("关系:自己|队友", "模板ID:67632", "平面距离<4") ~= 0 then return false end	--龙胄 血海冰暴
	if tnpc("关系:自己|队友", "模板ID:107305", "平面距离<8") ~= 0 then return false end	--飞刃回转
	if tnpc("关系:自己|队友", "模板ID:67665", "平面距离<3") ~= 0 then return false end	--青山共我
	if tnpc("关系:自己|队友", "模板ID:101122", "平面距离<9") ~= 0 then return false end --彼岸花
	

	if gettimer("青山共我") < 0.5 or gettimer("骤雨寒江") < 0.5 then
		return false
	end

	--目标被链接, 距离小于15尺, 视线可达, 没无敌, 没免拉, 没被铁马(buff 15603), 不在冲刺或在物化天行
	if v["链接"] and g_var["目标没减伤"] and g_var["目标单次免伤"] <= 0 and dis() < 14 and visible() and tbuffstate("免拉时间") < -1 and tbufftime("15603") < -1 and (tnostate("冲刺") or tbuff("13781")) then
		if qixue("承命") and cdtime("骤雨寒江") > 1 then
			return true
		end
	end
	return false
end

f["孤风飒踏"] = function()
	local bResult = false
	if buffstate("锁足时间") > 2 and buffstate("定身时间") > 2 or buffstate("眩晕时间") > 2 or buffstate("击倒时间") > 1.5 or buffstate("僵直时间") > 0.5 then
		if castxyz("孤风飒踏", point(tid(), 11, 180)) then
			bResult = true
		elseif castxyz("孤风飒踏", point(tid(), 11, 90)) then
			bResult = true
		elseif castxyz("孤风飒踏", point(tid(), 11, -90)) then
			bResult = true
		elseif castxyz("孤风飒踏", point(tid(), 11, 0)) then
			bResult = true
		elseif cast("孤风飒踏", true) then
			bResult = true
		end
	end
	if bResult then
		settimer("等待冲刺")
		exit()
	end
end

f["孤风飒踏二段"] = function()
	--目标背后8尺
	--castxy(22616, )
end

f["孤风飒踏三段"] = function()
	--cast("25306")
end


f["十方玄机"] = function()
	if cast("十方玄机") then
		settimer("十方玄机")
		exit()
	end
	
	if cdtime("十方玄机") <= 0 then
		local enemyID = enemy("距离<20", "视线可达", "距离最近")
		if enemyID ~= 0 then
			if xcast("十方玄机", enemyID) then
				settimer("十方玄机")
				exit()
			end
		end
	end
end

f["飞刃回转"] = function()
	if g_var["目标没减伤"] and dis() < 11 and theight() < 6 and v["目标不在快速移动"] and cdtime("隐风雷") <= 0 then
		cast("飞刃回转")
	end
end

f["青山共我"] = function()
	if g_var["目标没减伤"] and g_var["目标单次免伤"] <= 1 and theight() < 2 and v["目标不在快速移动"] then
		--重置 骤雨寒江
		if qixue("承命") then
			if dis() < 5 and cdtime("骤雨寒江") < cdinterval(16) then
				if cast("青山共我") then
					settimer("青山共我")
					stopmove()
					print("青山共我 重置 骤雨寒江")
				end
			end
			return
		end
		
		--重置 铁马冰河
		if v["放铁马冰河"] and cdtime("铁马冰河") <= 0.5 then
			if cast("青山共我") then
				settimer("青山共我")
				print("青山共我 重置 铁马冰河")
			end
		end
	end
end

f["乱天狼移动"] = function()
	if casting("乱天狼") then
		if tid() ~= 0 then
			local x, y = xxpos(id(), tid())
			if x > 10 then
				movef(true)
			end
			if x < 7 then
				moveb(true)
			end
			if y  > 2 then
				movel(true)
			end
			if y < -2 then
				mover(true)
			end
		end
		exit()
	else
		if not keydown("MOVEFORWARD") then
			movef(false)
		end
		if not keydown("MOVEBACKWARD") then
			moveb(false)
		end
		if not keydown("STRAFELEFT") then
			movel(false)
		end
		if not keydown("STRAFERIGHT") then
			mover(false)
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


--释放技能
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		if SkillID == 22274 then
			v["等待岀链"] = false
			return
		end
		if SkillID == 22361 then
			v["等待收链"] = false
			return
		end

		--[[
		if SkillID == 22398 then
			settimer("铁马冰河伤害")
		end
		if SkillID == 29166 then
			settimer("释放飞刃回转")
		end
		--]]
	end
end


local tBuff = {}

--buff更新
function OnBuff(CharacterID, BuffName, BuffID, BuffLevel, StackNum, SkillSrcID, StartFrame, EndFrame, FrameCount)
	--飞刃 buff 21310 等级1 2 3
	if CharacterID == v["自己的飞刃"] and StackNum  > 0 then
		print("OnBuff->飞刃 添加buff: ".. BuffName..", ID: "..BuffID..", 等级: "..BuffLevel..", 层数: "..StackNum..", 源ID: "..SkillSrcID..", 开始帧: "..StartFrame..", 当前帧: "..FrameCount..", 结束帧: "..EndFrame..", 剩余时间: "..(EndFrame-FrameCount)/16)
		return
	end

	if CharacterID == id() then
		if StackNum  > 0 then
			local bPrintAdd = false
			if buffis(BuffID, BuffLevel, "封外功") then
				print("被沉默")
				bigtext("被沉默")
				bPrintAdd = true
			end

			if buffis(BuffID, BuffLevel, "缴械") then
				print("被缴械")
				bigtext("被缴械")
				bPrintAdd = true
			end

			if buffis(BuffID, BuffLevel, "锁足") then
			 	print("被锁足")
				bigtext("被锁足")
				bPrintAdd = true
			end

			if buffis(BuffID, BuffLevel, "定身") then
				print("被定身")
				bigtext("被定身")
				bPrintAdd = true
			end

			if buffis(BuffID, BuffLevel, "眩晕") then
				print("被眩晕")
				bigtext("被眩晕")
				bPrintAdd = true
			end
		
			if buffis(BuffID, BuffLevel, "击倒") then
				print("被击倒")
				bigtext("被击倒")
				bPrintAdd = true
			end

			if tBuff[BuffID] or bPrintAdd then
				print("添加buff: ".. BuffName..", ID: "..BuffID..", 等级: "..BuffLevel..", 层数: "..StackNum..", 源ID: "..SkillSrcID..", 开始帧: "..StartFrame..", 当前帧: "..FrameCount..", 结束帧: "..EndFrame..", 剩余时间: "..(EndFrame-FrameCount)/16)
			end
		else
			if tBuff[BuffID] then
				print("移除buff: ".. BuffName..", ID: "..BuffID..", 等级: "..BuffLevel..", 层数: "..StackNum..", 源ID: "..SkillSrcID..", 开始帧: "..StartFrame..", 当前帧: "..FrameCount)
			end
		end
	end
end

--NPC进入场景
function OnNpcEnter(NpcID, NpcName, NpcTemplateID, NpcModelID, EmployerID)
	if EmployerID == id() and NpcTemplateID == 107305 then
		v["自己的飞刃"] = NpcID		--记录下自己的飞刃ID
	end
end
