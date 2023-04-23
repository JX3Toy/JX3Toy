--[[镇派
[雷奔云谲]2 [狂风化血]3 [惊心裂胆]2
[回肠荡气]3 [鹰扬虎视]2 [迅电流光]2
[裂石穿云]2 [逐星箭]1 [穷尽九泉]2
[浴血沁骨]1 [战不旋踵]2
[追命无声]2 [妙手连环]3 [河桥养箭]1
[连环弩]1
[毒手尊拳]3 [龙翰凤翼]2
[奥妙无穷]2
--]]

--关闭自动面向
setglobal("自动面向", false)

--宏选项
addopt("副本防开怪", false)
addopt("隐追", true)
addopt("卸元箭驱散", false)

--变量表
local v = {}
v["神机值"] = energy()
v["等待读条释放"] = false

--函数表
local f ={}

--主循环
function Main(g_player)
	--读条即将结束，设置等待标志为真
	if casting("夺魄箭|穿心弩") and castleft() < 0.13 then
		v["等待读条释放"] = true
		settimer("等待读条释放")
	end

	--减伤
	if fight() and life() < 0.6 then
		cast("惊鸿游龙")
	end

	--副本处理
	local mapName = map()
	local func = tMapFunc[mapName]
	if func then
		func(g_player)
	end
	----------------------------------------开始输出
	
	--等待读条技能释放
	if v["等待读条释放"] and gettimer("等待读条释放") <= 0.25 then
		return
	end

	--副本防开怪
	if getopt("副本防开怪") and dungeon() and nofight() then return end

	--目标不是敌人, 结束
	if not rela("敌对") then return end

	if tbuff("隐遁") then
		bigtext("目标无敌", 0.5)
		return
	end

	--梅花针
	if tbuffstate("可打断") then
		cast("梅花针")
	end

	--卸元箭
	if getopt("卸元箭驱散") and tbufftype("阴性气劲|阳性气劲|毒性气劲|混元性气劲") > 0 then
		cast("卸元箭")
	end

	--初始化变量
	local tSpeedXY, tSpeedZ = speed(tid())
	v["目标静止"] = tSpeedXY == 0 and tSpeedZ == 0		--xy速度和Z速度都为0
	v["目标血量较多"] = tlifevalue() > lifemax() * 10	--目标血量大于自己最大血量10倍
	v["没打过裂石弩"] = nobuff("50351")
	v["没打过夺魄箭"] = nobuff("50349")

	--爆发
	if dis() < 25 and face() < 60 and v["目标血量较多"] and v["目标静止"] and state("站立") then
		if cdleft(16) < 0.5 then	--GCD快好了
			cast("猛虎下山")
		end

		--if bufftime("妙手连环") > 6 and cdleft(16) >= 0.5 and cdleft(16) <= 1 and v["神机值"] < 45 then
		if cdleft(16) >= 0.5 and cdleft(16) <= 1 and v["神机值"] < 45 then
			cast("心无旁骛")
		end

		if getopt("隐追") and dis() < 24 and cdtime("追命箭") <= 0.25 and v["神机值"] >= 45 and bufftime("追命无声") > 5 then
			if cast("浮光掠影") then
				settimer("浮光掠影")
			end
		end
	end

	--有妙手
	if bufftime("妙手连环") > 0 then
		--追命箭
		f["追命箭"]()

		if dis() > 20 then
			cast("逐星箭")
		end

		if cdtime("追命箭") < 2 and nobuff("追命无声") then
			if bufftime("妙手连环") > casttime("夺魄箭") and v["没打过夺魄箭"] then
				f["夺魄箭"]()
			end
		end

		--有奥妙，先打高神机技能
		if buff("奥妙") then
			f["裂石弩"]()
		end

		cast("逐星箭")

		if bufftime("妙手连环") > casttime("穿心弩") then
			cast("穿心弩")
		end

		if bufftime("妙手连环") > casttime("夺魄箭") and v["没打过夺魄箭"] then
			f["夺魄箭"]()
		end

		if bufflv("妙手连环") >= 4 or v["神机值"] >= 80 then
			f["裂石弩"]()
		end

		if cdtime("逐星箭") > bufftime("妙手连环") then
			if bufflv("妙手连环") >= 3 and bufftime("妙手连环") > casttime("连环弩") / 3 + 0.0625 then
				cast("连环弩")
			end
		end
	end

	--化血镖
	if tnobuff("化血镖", id()) then
		cast("化血镖")
	end

	--孔雀翎
	if buffsn("无声") >= 2 or buff("追命无声") then
		cast("孔雀翎")
	else
		f["夺魄箭"]()
	end
	
	f["释放夺魄箭"]()
end

f["夺魄箭"] = function()
	if (buff("奥妙") and v["神机值"] >= 12) or v["神机值"] >= 29 then
		cast("夺魄箭")
	end
end

f["释放夺魄箭"] = function()
	if cdtime("逐星箭") < cdleft(16) and bufftime("妙手连环") > cdleft(16) then return end
	--if cdtime("穿心弩") < cdleft(16) and bufftime("妙手连环") > cdleft(16) + casttime("穿心弩") then return end
	if cdtime("孔雀翎") >= 1 and v["神机值"] >= 74 then
		f["夺魄箭"]()
	end
end

f["追命箭"] = function()
	if buff("追命无声") then
		if (buff("奥妙") and v["神机值"] >= 18) or v["神机值"] >= 45 then
			cast("追命箭")
		end
	end
end

f["裂石弩"] = function()
	if v["没打过裂石弩"] then
		if (buff("奥妙") and v["神机值"] >= 18) or v["神机值"] >= 45 then
			cast("裂石弩")
		end
	end
end


--释放技能
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		--print("OnCast->:"..SkillName..", 技能ID:"..SkillID..", 技能等级:"..SkillLevel..", 目标ID:"..TargetID..", 开始帧:"..StartFrame..", 当前帧:"..FrameCount)

		--夺魄箭
		if SkillID == 3095 then
			v["神机值"] = v["神机值"] - 29
			v["等待读条释放"] = false
			return
		end

		--穿心弩
		if SkillID == 3098 then
			v["神机值"] = v["神机值"] - 30
			v["等待读条释放"] = false
			return
		end

		--连环
		if SkillID == 64083 then
			print("连环")
			return
		end
	end
end


--更新buff
local tBuff = {
[3278] = "奥妙",
[50354] = "妙手连环",
}
function OnBuff(CharacterID, BuffName, BuffID, BuffLevel, StackNum, SkillSrcID, StartFrame, EndFrame, FrameCount)
	--[[
	if CharacterID == id() and tBuff[BuffID] then
		if StackNum > 0 then
			print("添加buff: "..BuffName, "ID: "..BuffID, "等级: "..BuffLevel, "层数: "..StackNum, "剩余时间:"..((EndFrame - FrameCount) / 16))
		else
			print("移除buff: "..BuffName, "ID: "..BuffID, "等级: "..BuffLevel)
		end
	end
	--]]
end

--状态更新
function OnStateUpdate(nCurrentLife, nCurrentMana, nCurrentRage, nCurrentEnergy, nCurrentSunEnergy, nCurrentMoonEnergy)
	v["神机值"] = nCurrentEnergy
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
	if gettimer("目标读条护体") < 2 or tbuff("4147") then	--护体 反弹伤害
		stopcasting()
		exit()
	end
end

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
	if gettimer("目标读条护体") < 2 or tbuff("4147") then	--护体 反弹伤害
		stopcasting()		--停止读条
		turn(180)			--背对目标
		exit()
	else
		if tname("午") and face() > 60 then
			turn()
		end
	end
end
