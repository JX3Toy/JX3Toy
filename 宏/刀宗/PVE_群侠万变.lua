--[[ 奇穴: [渊冲][聚疏][溃延][放皓][威声][观衅][界破][长溯][周流][强膂][流岚][截辕]
秘籍: 优先点效果和距离
行云  1会心 2伤害 1距离
停云  1伤害 1距离 2调息
决云  2伤害 2会心
断云  1会心 2伤害 1距离
驰风  3调息 1效果(吸收身形)
游风  2调息
沧浪  2会心 2伤害
横云  2会心 2伤害
孤锋  2会心 2伤害
留客  1会心 2伤害 1距离

自动吃影子, 吃完1影, 位置向目标和剩余任一影子之间稍微移动下, 能减少跑过去吃影子的时间, 3影如果驰风没冷却也同样操作, 自己看识破掌握时机，时机不对, 可能有反面效果
双持起手, 多打一个孤锋, 没进战周围没怪的时候运行下宏就会自动切双持, 木桩3分钟85破左右
--]]

--宏选项
addopt("手动吃影子", false)

--变量表
local v = {}
v["输出信息"] = true
v["放过决云"] = false
v["锐意"] = energy()

--函数表
local f = {}

--主循环
function Main()
	--初始化变量
	v["单手"] = buff("24029")
	v["双持"] = buff("24110")
	v["识破时间"] = bufftime("识破")	--24108
	v["目标破绽层数"] = tbuffsn("破绽", id())	--24056
	v["目标破绽时间"] = tbufftime("破绽", id())
	v["身形数量"] = 0
	v["身形时间"] = -100
	for i = 1, 3 do
		local nTime = bufftime("2410"..4 + i)	--24105 24106 24107
		v["身形"..i.."时间"] = nTime
		if nTime >= 0 then
			v["身形数量"] = v["身形数量"] + 1
			v["身形时间"] = nTime
		end
	end
	v["停云CD"] = scdtime("停云势")
	v["决云CD"] = cdleft(2425)
	v["留客CD"] = scdtime("留客雨")
	v["驰风CD"] = scdtime(32140)		--二段重名用ID
	v["灭影CD"] = scdtime("灭影追风")
	v["游风充能次数"] = cn("游风飘踪")
	v["游风充能时间"] = cntime("游风飘踪", true)
	v["横云CD"] = scdtime("横云断浪")

	--等待单双切换
	if gettimer("断云势") < 0.3 or gettimer("孤锋破浪") < 0.3 or gettimer("灭影追风") < 0.3 then
		--PrintInfo("----------等待单双切换, ")
		return
	end

	--等待决云冲刺结束
	if gettimer("决云势冲刺") < 0.3 and buff("23885") then
		PrintInfo("----------等待决云冲刺: "..state()..", ")
		if state("冲刺") then
			deltimer("决云势冲刺")
		end
		return
	end
	
	--等待驰风释放
	if gettimer("驰风八步") < 0.3 or gettimer("释放驰风八步") < 0.13 then
		--PrintInfo("----------等待驰风释放, ")
		return
	end

	--吃3影条件
	v["吃3影"] = v["身形数量"] == 1 and (v["决云CD"] > 1 or v["游风充能时间"] < 50 or v["身形时间"] < 1)

	--驰风八步
	if miji(32140, "《游风步·驰风八步》人偶图残页") and nobuff("23953") then	--有秘籍 没二段
		v["打驰风"] = false
		if rela("敌对") and dis() < 30 and nofight() and v["识破时间"] < 1 then
			v["打驰风"] = "没进战打出识破"
		end
		if v["识破时间"] < 0 and v["吃3影"] then
			v["打驰风"] = "吸收最后一个身形"
		end
		if v["打驰风"] then
			if CastX("驰风八步") then
				return
			end
		end
	end

	if v["单手"] then
		f["单手"]()
	end

	if v["双持"] then
		f["双持"]()
	end

	f["向目标移动"]()
end

f["单手"] = function()

	--留客雨 减单手GCD 2436 1秒, 决云势CD 2425 4秒
	if v["锐意"] > 99 then
		CastX("留客雨")
	end

	--灭影追风
	v["放灭影"] = false
	if nofight() and npc("关系:敌对", "距离<30", "可选中") == 0 then	--没进战, 周围30尺没敌人
		v["放灭影"] = "没进战切双"
	end
	if rela("敌对") and dis() < 8 and v["锐意"] >= 30 then
		--if v["放过决云"] or  then
			v["放灭影"] = "30锐意"
		--end
	end
	if v["放灭影"] then
		if cdtime("灭影追风") <= 0 then
			CastX("留客雨")
		end
		if CastX("灭影追风") then
			return
		end
	end

	--断云势
	if rela("敌对") and dis() < range("断云势") and face() < 90 then
		if CastX("断云势") then
			return
		end
	end

	if v["识破时间"] > 0 and v["锐意"] <= 80 then
		CastX("决云势")
	end

	--找身形
	if v["锐意"] < 80 then
		if v["身形数量"] > 1 or v["吃3影"] then
			f["找身形"]()
			return
		end
	end

	if v["锐意"] < 95 and v["身形数量"] <= 0 then
		CastX("停云势")
	end

	if v["锐意"] <= 80 then
		CastX("决云势")
	end

	if v["锐意"] < 95 then
		CastX("停云势")
	end

	if v["锐意"] < 100 then
		if v["锐意"] >= 90 and v["锐意"] < 95 and v["停云CD"] < 0.5 then return end		--90-94 等下停云CD
		CastX("行云势")
	end
end

f["双持"] = function()
	--孤锋破浪
	if rela("敌对") and dis() < 6 and face() < 90 then
		v["打孤锋"] = false
		if tbuffsn("长溯", id()) > 2 then
			v["打孤锋"] = "3层长溯"
		end
		if v["灭影CD"] < 1 and v["游风充能时间"] < 1 then
			v["打孤锋"] = "起手"
		end
		if v["打孤锋"] then
			if CastX("孤锋破浪") then
				return
			end
		end
	end

	--游风
	if rela("敌对") and dis() < 8 then
		if tbuffsn("长溯", id()) > 1 then
			if v["识破时间"] < 0 and v["身形数量"] <= 0 and v["灭影CD"] > 7 and v["锐意"] < 80 then
				CastX("游风飘踪")
			end
		end
	end

	--沧浪三叠
	if rela("敌对") and dis() < 6 and face() < 90 then
		CastX("沧浪三叠")
	end

	--横云断浪
	if cdleft(2436) > 0.5 then
		CastX("横云断浪")		--只触发和检查 GCD 16
	end

	--找身形
	if cdleft(16) > 1 then
		if v["身形数量"] > 1 or v["吃3影"] then
			f["找身形"]()
		end
	end
end

f["找身形"] = function()
	if getopt("手动吃影子") then return end

	if v["识破时间"] < 0 and v["身形数量"] > 0 and gettimer("驰风八步") > 0.5 and gettimer("释放驰风八步") > 1 then	--没识破 有身形
		--没在控制角色
		if not keydown("MOVEFORWARD") and not keydown("MOVEBACKWARD") and not keydown("TURNLEFT") and not keydown("TURNRIGHT") and not keydown("STRAFELEFT") and not keydown("STRAFERIGHT") and not keydown("JUMP") and state("站立") then
			v["身形"] = npc("模板ID:111366", "距离最近")	--离自己最近
			if v["身形"] ~= 0 then
				local x, y, z = point(v["身形"], 3, 0, v["身形"], id())	--身形到自己方向3尺
				if x > 0 then	--获取到正确坐标
					PrintInfo("----------找身形, ")
					moveto(x, y, z)
					return true
				end
			end
		end
	end
	return false
end

f["向目标移动"] = function()
	if getopt("手动吃影子") then return end
	--if v["识破时间"] < 28 then return end

	--优先处理按键操作 防止角色失去控制
	if keydown("MOVEFORWARD") then	--按下前 停止后
		moveb(false) return
	end
	if keydown("MOVEBACKWARD") then	--按下后 停止前
		movef(false) return
	end
	if keydown("STRAFELEFT") then	--按下左平移 停止右平移
		mover(false) return
	end
	if keydown("STRAFERIGHT") then	--按下右平移，停止左平移
		movel(false) return
	end

	if rela("敌对") then
		if not keydown("TURNLEFT") and not keydown("TURNRIGHT") and not keydown("JUMP") then	--没按下左转 右转 跳
			if v["识破时间"] > 0 or v["身形数量"] <= 0 then
				if dis() > 5 and gettimer("决云势") > 0.3 and gettimer("决云势冲刺") > 0.3 then
					turn()		--面向目标
					movef(true)	--向前移动
				end
			end

			if dis() < 4 then
				if face() > 60 then	--面向目标
					turn()
				end
				movef(false)	--停止向前
			end
		end
	end
end

--输出信息
function PrintInfo(s)
	local szPose = buff("24029") and "单手" or "双持"
	local szinfo = "锐意:"..v["锐意"]..", 体态:"..szPose..", 识破:"..v["识破时间"]..", 身形: "..v["身形数量"]..", "..v["身形时间"]..", 停云:"..v["停云CD"]..", 决云:"..v["决云CD"]..", 留客:"..v["留客CD"]..", 驰风:"..v["驰风CD"]..", 灭影:"..v["灭影CD"]..", 游风:"..v["游风充能次数"]..", "..v["游风充能时间"]..", 横云:"..v["横云CD"]..", 单手GCD:"..cdleft(2436)..", 双持GCD:"..cdleft(16)..", 当前帧:"..frame()
	if s then
		szinfo = s..szinfo
	end
	print(szinfo)
end

--使用技能并输出信息
function CastX(szSkill, bSelf)
	if cast(szSkill, bSelf) then
		settimer(szSkill)
		if v["输出信息"] then PrintInfo() end
		return true
	end
	return false
end

--释放技能
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then

		if SkillID == 32140 then	--驰风八步
			stopmove()
			jump()	--跳, 打断驰风八步
			deltimer("驰风八步")
			settimer("释放驰风八步")
		end
		
		if SkillID == 32134 then	--决云势
			v["放过决云"] = true
			deltimer("决云势")

			if self().IsHaveBuff(24108, 1) then		--有识破加50 没识破加20
				v["锐意"] = v["锐意"] + 50
			else
				v["锐意"] = v["锐意"] + 20
			end
		end
		
		if SkillID == 32166 then	--决云势冲刺
			settimer("决云势冲刺")
		end
		
		if SkillID == 32149 or SkillID == 32150 or SkillID == 32151 then	--行云123段
			v["锐意"] = v["锐意"] + 5
		end
		
		if SkillID == 32153 then	--停云伤害子技能
			v["锐意"] = v["锐意"] + 10
		end
		
		if SkillID == 32135 then	--断云势
			v["锐意"] = 0
		end
		
		if SkillID == 32145 then	--孤锋破浪
			v["放过决云"] = false
		end

		if v["锐意"] > 100 then
			v["锐意"] = 100
		end
	end
end

local tBuff = {
[23885] = "决云冲刺",
[24108] = "原名",
}

--buff更新
function OnBuff(CharacterID, BuffName, BuffID, BuffLevel, StackNum, SkillSrcID, StartFrame, EndFrame, FrameCount)
	if CharacterID == id() then
		if StackNum  > 0 then
			if BuffID == 24110 then		--双持
				deltimer("断云势")
				deltimer("灭影追风")
			end
			if BuffID == 24029 then		--单手
				deltimer("孤锋破浪")
			end
			if BuffID == 24172 then
				deltimer("游风飘踪")
			end
		end

		--[[输出buff增删信息
		local szName = tBuff[BuffID]
		if szName then
			if szName ~= "原名" then
				BuffName = szName
			end
			if StackNum  > 0 then
				print("OnBuff->添加: ".. BuffName..", ID: "..BuffID..", 等级: "..BuffLevel..", 层数: "..StackNum..", 源ID: "..SkillSrcID..", 开始帧: "..StartFrame..", 当前帧: "..FrameCount..", 结束帧: "..EndFrame..", 剩余时间: "..(EndFrame-FrameCount)/16)
			else
				print("OnBuff->移除: ".. BuffName..", ID: "..BuffID..", 等级: "..BuffLevel..", 层数: "..StackNum..", 源ID: "..SkillSrcID..", 开始帧: "..StartFrame..", 当前帧: "..FrameCount)
			end
		end
		--]]
	end
end

--状态更新
function OnStateUpdate(nCurrentLife, nCurrentMana, nCurrentRage, nCurrentEnergy, nCurrentSunEnergy, nCurrentMoonEnergy)
	if nCurrentEnergy ~= v["锐意"] then
		print("--------------------OnStateUpdate, 预置锐意错误, 锐意: "..nCurrentEnergy..", 当前:"..v["锐意"]..", "..frame())
	end
	v["锐意"] = nCurrentEnergy
end

--战斗状态改变
function OnFight(bFight)
	if bFight then
		print("--------------------进入战斗")
	else
		print("--------------------离开战斗")
	end
end
