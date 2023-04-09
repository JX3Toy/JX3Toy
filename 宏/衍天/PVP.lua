--奇穴: [水盈][望旗][顺祝][列宿游][重山][神遁][亘天][连断][休囚][征凶][灵器][增卜]

--载入库
load("Macro/Lib_PVP.lua")

--变量表
local v = {}

--函数表
local f = {}

--主循环
function Main(g_player)
	--初始化
	g_func["初始化"]()

	v["星运"] = rage()
	v["连局剩余时间"] = ljtime()
	v["自己在连局内"] = xinlianju(id())
	--v["需要爆连局"] = v["连局剩余时间"] < 25

	--读条的时候面向目标
	if casting("兵主逆|天斗旋") then
		turn()
	end


	f["处理卦象"]()

	f["处理灯"]()

	--巨门北落
	if fight() then
		if life() < 0.6 then
			cast("巨门北落")
		end

		--if life() < 0.9 then
			--藏剑 风来吴山
			v["读条风来吴山敌人"] = enemy("平面距离<10", "读条:风来吴山")
			if v["读条风来吴山敌人"] ~= 0 then
				if cast("巨门北落") then
					bigtext("有风车开巨门")
				end
			end
			v["敌对风来吴山Npc"] = npc("关系:敌对", "平面距离<10", "模板ID:57739")
			if v["敌对风来吴山Npc"] ~= 0 then
				if cast("巨门北落") then
					bigtext("有风车开巨门")
				end
			end
		--end
	end


	--打伤害
	if g_var["目标可攻击"] then
		if v["星运"] >= 70 then
			cast("列宿游")
		end

		if xinlianju(tid()) and dis() < 8 then
			cast("杀星在尾")
		end

		if bufftime("17996") > 0.1 then
			cast("天斗旋")
		end

		--读条技能
		if v["自己在连局内"] and gettimer("水变火") > 0.25 and gettimer("山变火") > 0.25 then
			if gettimer("释放起卦") < 0.5 or gettimer("起卦_火离") > 3 then
				cast("兵主逆")
			end
			
			--if gettim起卦") > 3er("释放起卦") < 0.5 or gettimer("释放 then
				cast("天斗旋")
			--end
		end

		cast("往者定")

		cast("三星临")
	end

	--返闭惊魂
	if buffstate("锁足时间") > 1.5 or buffstate("定身时间") > 1.5 or buffstate("眩晕时间") > 1.5 or buffstate("击倒时间") > 1.5 or buffstate("僵直时间") > 0.5 then
		cast("返闭惊魂")
	end

	--被缴械
	if buffstate("缴械时间") > 2 then
		if buff("弹跳") then
			jump()
		else
			if cast("扶摇直上") then
				jump()
			end
		end
	end

	--踏星行
	if buffstate("封内时间") > 2 then
		cast("踏星行")
	end


	--竞技场挂扶摇
	if jjc() then
		cast("扶摇直上")
	end

	--采集任务物品
	if nofight() then
		g_func["采集"](g_player)
	end
end


f["变卦"] = function(info)
	--需要爆连局不变卦
	--if v["需要爆连局"] then return end

	if gettimer("起卦") > 0.5 and gettimer("释放起卦") > 3 then
		if cast("变卦") then
			v["星运"] = v["星运"] - 20
			bigtext(info)
			print(info)
			settimer(info)
		end
	end
end

f["处理卦象"] = function()
	v["目标在范围内"] = rela("敌对") and dis() < 25

	--起卦, 2.5秒后出卦象
	if g_var["附近敌人数量"] > 0 or v["目标在范围内"] then
		if cast("起卦") then
			settimer("起卦")
			return
		end
	end
		
	--水卦
	if buff("水坎") then
		if buff("17824") then
			if gettimer("祝由·水坎") > 0.25 and cast("祝由·水坎", true) then
				settimer("祝由·水坎")
			end
		else
			--变卦打火卦
			if v["目标在范围内"] and tbufftime("祝由·火离", id()) < 2 then
				f["变卦"]("水变火")
				return
			end

			--时间不够打一个技能
			if cdleft(16) > bufftime("17826") then
				f["变卦"]("水变火")
				return
			end
		end
		return
	end

	--山卦
	if buff("山艮") then
		if buff("17823") then
			if g_func["目标可控制"] then
				if gettimer("祝由·山艮") > 0.25 and cast("祝由·山艮") then
					settimer("祝由·山艮")
				end
			end
		else
			--变卦打火卦
			if v["目标在范围内"] and tbufftime("祝由·火离", id()) < 2 then
				f["变卦"]("山变火")
				return
			end

			if cdleft(16) > bufftime("17826") then	--卦象快结束
				if v["目标在范围内"] and cdtime("起卦") > 9 then
					f["变卦"]("山变火")
					return
				end
			end


		end
		return
	end

	--火卦
	if buff("火离") then
		if buff("17825") then
			if g_func["目标可控制"] and tbufftime("祝由·火离", id()) < 8 then
				if gettimer("祝由·火离") > 0.25 and cast("祝由·火离") then
					settimer("祝由·火离")
				end
			end
		else
			--变山，提高伤害
			if v["目标在范围内"] and cdtime("起卦") > 10 then
				f["变卦"]("火变山")
			end
		end
		return
	end
end

f["处理灯"] = function()
	
	--放灯	
	if enemy("距离<50") ~= 0 or (rela("敌对") and dis() < 25) then
		if cdtime("奇门飞宫") <= 0 and nobuff("18231") then
			fangdeng(10)
		end
	end

	--[[爆灯, 不爆了，继续放灯就行了
	if v["需要爆连局"] and buffstate("免击倒时间") > 5 then
		if cast("鬼星开穴") then
			settimer("鬼星开穴")
		end
	end
	--]]
end


--释放技能
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		if SkillID == 24831 then
			settimer("起卦_水坎")
			print("起卦_水坎")
			return
		end
		if SkillID == 24832 then
			settimer("起卦_山艮")
			print("起卦_山艮")
			return
		end
		if SkillID == 24833 then
			settimer("起卦_火离")
			print("起卦_火离")
			return
		end
		
		if SkillID == 24375 then
			settimer("释放起卦")
		end
	end
end



local tBuff = {
--[17588] = "水坎",
--[17824] = "卦象_水坎解卦需求",
--[17801] = "山艮",
--[17823] = "卦象_山艮解卦需求",
--[17802] = "火离",
--[17825] = "卦象_火离解卦需求",
--[17826] = "变卦需求",
--[17996] = "三星|虎遁_斗瞬发",
}

--输出buff变动情况
function OnBuff(CharacterID, BuffName, BuffID, BuffLevel, StackNum, SkillSrcID, StartFrame, EndFrame, FrameCount)
	if CharacterID == id() then
		if StackNum  > 0 then
			local bPrint = false
			if  BuffID ~= 17584 then
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
				if buffis(BuffID, BuffLevel, "封混元") then
					print("被封内")
					bigtext("被封内")
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
					print("被击倒")
					bigtext("被击倒")
					bPrint = true
				end
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

--状态更新
function OnStateUpdate(nCurrentLife, nCurrentMana, nCurrentRage, nCurrentEnergy, nCurrentSunEnergy, nCurrentMoonEnergy)
	--print("星运: "..nCurrentRage)
end
