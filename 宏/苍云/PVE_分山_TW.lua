--[[ 奇穴: [刀魂][絕返][分野][血魄][鋒鳴][割裂][業火麟光][戀戰][從容][憤恨][蔑視][陣雲結晦]
秘籍:
盾刀  1会心 3伤害
盾压  1调息 1会心 2伤害
劫刀  1会心 2伤害 1消耗
斩刀  1会心 3伤害
绝刀  1会心 1伤害 1调息 1效果
盾飞  2伤害 2持续
血怒  2回怒 2回血
--]]

--关闭自动面向
setglobal("自动面向", false)

--变量表
local v = {}
v["输出信息"] = true
v["怒气"] = rage()

--主循环
function Main(g_player)
	--减伤
	if fight() and life() < 0.6 then
		cast("盾壁")
	end

	--初始化变量
	v["阵云层数"] = buffsn("陣雲")
	v["盾飞时间"] = bufftime("盾飛")
	v["斩刀CD"] = cdleft(801)
	v["绝刀CD"] = cdleft(800)
	v["血怒充能"] = cntime("血怒", true)
	v["GCD"] = math.max(cdleft(16), cdleft(804))

	---------------------------------------------盾
	if pose("擎盾") then
		if gettimer("盾飞") < 0.5 then return end

		--业火
		if (buff("分野") and v["怒气"] < 10) or (v["斩刀CD"] > cdinterval(16) + cdinterval(804) * 2 or v["绝刀CD"] > cdinterval(16) * 2 + cdinterval(804) * 2) then
			if CastX("業火麟光") then
				settimer("业火麟光")
			end
		end

		--盾飞
		if gettimer("业火麟光") > 1 then
			if v["怒气"] >= 25 and v["斩刀CD"] < cdinterval(804) and v["绝刀CD"] < cdinterval(804) + cdinterval(16) then
				if buff("26132") or nobuff("25939") then	--有火劫或没业火
					if CastX("盾飛") then		
						settimer("盾飞")
						return
					end
				end
			end
		end
		
		--回怒气
		if v["怒气"] < 15 or buff("25939") then		--怒气小于15或有业火
			if rela("敌对") then
				CastX("盾壓")
			end
			if cdtime("盾壓") > 0 or dis() > 8 then
				CastX("盾猛")
			end
		end
		CastX("盾擊")
		CastX("盾刀")
	end

	---------------------------------------------刀
	if pose("擎刀") then
		--输出下刀魂同步情况
		if fight() and rela("敌对") and dis() < 4 and cdleft(16) <= 0 and cdleft(804) <= 0 then
			if nobuff("8627") then
				print("--------------------刀魂没同步")
			end
		end

		if gettimer("盾回") < 0.3 then return end

		v["没有麟光甲或已触发"] = nobuff("麟光玄甲") or buff("麟黯")
		v["绝刀没快进CD"] = nobuff("8453") or bufftime("8453") > cdinterval(16) + 0.25	--buff 8453 结束绝刀CD
		
		--狂绝
		if buff("狂絕") or buff("8474") then
			CastX("絕刀")
		end

		--斩刀
		if nobuff("狂絕") and v["盾飞时间"] > (cdinterval(16) + 0.125) * 3 and v["怒气"] >= 25 then
			CastX("斬刀")
		end

		--闪刀, 15点怒气
		if v["没有麟光甲或已触发"] and v["绝刀没快进CD"] and nobuff("狂絕") and v["怒气"] >= 25 and tbuff("流血", id()) and tnobuff("割裂", id()) then
			CastX("閃刀")
		end

		--劫刀
		if nobuff("狂絕") and buff("麟黯") and v["绝刀没快进CD"] and bufftime("麟光玄甲") > cdinterval(16) + 0.25 and v["怒气"] >= 15 then
			CastX("劫刀")
		end

		--阵云
		if nobuff("狂絕") and v["盾飞时间"] > (cdinterval(16) + 0.125) * 3 and bufftime("麟光玄甲") < 0 then
			if v["阵云层数"] == 4 then
				if rela("敌对") and dis() < 6 and face() < 50 then		--6*6 矩形, 用矩形判断模型大的怪有问题
					--local x, y = xxpos(id(), tid())
					--if x > 0 and x < 6 and y > -3 and y < 3 then
					if CastX("陣雲結晦") then
						settimer("阵云结晦")
					end
				end
			end
		end

		--绝刀
		if v["斩刀CD"] > cdinterval(16) or v["怒气"] < 25 then
			CastX("絕刀")
		end

		--阵云
		if nobuff("狂絕") and v["盾飞时间"] > (cdinterval(16) + 0.125) * 2 then
			if v["阵云层数"] >= 6 or v["斩刀CD"] > cdinterval(16) + cdinterval(804) or v["绝刀CD"] > cdinterval(16) * 2 + cdinterval(804) then
				if rela("敌对") and dis() < 6 and face() < 50 then
					if CastX("陣雲結晦") then
						settimer("阵云结晦")
					end
				end
			end
		end

		--云3
		if buff("22977") then
			CastX("雁門迢遞")	--20尺冲刺
		end

		--云2
		if buff("22976") then
			if rela("敌对") and dis() < 8 and face() < 90 then
				CastX("月照連營")	--8尺正面
			end
		end

		--血怒
		if rela("敌对") and (v["阵云层数"] < 4 or v["阵云层数"] == 5) and nobuff("22976|22977") then
			if v["斩刀CD"] > cdinterval(16) + cdinterval(804) + v["GCD"] or v["绝刀CD"] > cdinterval(16) * 2 + cdinterval(804) + v["GCD"] then
				if v["怒气"] < 10 and v["盾飞时间"] > (cdinterval(16) + 0.125) * 3 + 0.5 then
					if CastX("血怒") then
						settimer("血怒")
					end
				end
			end
		end

		--劫刀
		if v["绝刀CD"] > cdinterval(16) or v["怒气"] >= 15 then
			CastX("劫刀")
		end
	

		--收盾
		if gettimer("血怒") > 1 and gettimer("阵云结晦") > 1 and nobuff("22976|22977") then
			if cdleft(16) <= 0.25 and cdleft(804) <= 0.25 then
				if v["怒气"] < 10 or v["绝刀CD"] > cdinterval(16) then	--打不出绝刀
					if v["阵云层数"] < 4 or v["盾飞时间"] < (cdinterval(16) + 0.125) * 2 then	--打不出阵云
						if CastX("盾回") then
							settimer("盾回")
						end
					end
				end
			end
		end
	end

	--目标是敌对, 4尺内, 没打技能输出信息
	if fight() and rela("敌对") and dis() < 4 and face() < 90 and cdleft(16) <= 0 and cdleft(804) <= 0 and visible() then
		PrintInfo("----------没打技能, ")
	end
end

--输出信息
function PrintInfo(s)
	if s then
		print(s, "怒气:"..v["怒气"], "阵云层数:"..v["阵云层数"], "盾飞时间:"..v["盾飞时间"], "斩刀CD:"..v["斩刀CD"], "绝刀CD:"..v["绝刀CD"], "盾飞:"..cn("盾飛"), cntime("盾飛", true), "血怒:"..cn("血怒"), cntime("血怒"))
	else
		print("怒气:"..v["怒气"], "阵云层数:"..v["阵云层数"], "盾飞时间:"..v["盾飞时间"], "斩刀CD:"..v["斩刀CD"], "绝刀CD:"..v["绝刀CD"], "盾飞:"..cn("盾飛"), cntime("盾飛", true), "血怒:"..cn("血怒"), cntime("血怒"))
	end
end

--使用技能
function CastX(szSkill)
	if cast(szSkill) then
		if v["输出信息"] then
			PrintInfo()
		end
		return true
	end
	return false
end

--技能释放回调表
local tFunc = {}

tFunc[13044] = function()	--盾刀
	v["怒气"] = v["怒气"] + 5
end

tFunc[13046] = function()	--盾猛
	v["怒气"] = v["怒气"] + 15
end

tFunc[13047] = function()	--盾击
	v["怒气"] = v["怒气"] + 10
end

tFunc[13045] = function()	--盾压
	v["怒气"] = v["怒气"] + 15
end

--释放技能
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		local func = tFunc[SkillID]
		if func then
			func()
		end
	end
end

local tBuff = {
[8627] = "刀魂",
[26132] = "火劫",
[25939] = "业火",
[25941] = "麟光玄甲",
[8451] = "狂绝",
[8453] = "绝刀走CD",
}

--buff更新
function OnBuff(CharacterID, BuffName, BuffID, BuffLevel, StackNum, SkillSrcID, StartFrame, EndFrame, FrameCount)
	--输出自己buff信息
	if CharacterID == id() then
		local szName = tBuff[BuffID]
		if szName then
			if StackNum  > 0 then
				if BuffID ~= 8627 or nobuff("8627") then
					print("OnBuff->添加buff: ".. szName..", ID: "..BuffID..", 等级: "..BuffLevel..", 层数: "..StackNum..", 源ID: "..SkillSrcID..", 开始帧: "..StartFrame..", 当前帧: "..FrameCount..", 结束帧: "..EndFrame..", 剩余时间: "..(EndFrame-FrameCount)/16)
				end
			else
				print("OnBuff->移除buff: ".. szName..", ID: "..BuffID..", 等级: "..BuffLevel..", 层数: "..StackNum..", 源ID: "..SkillSrcID..", 开始帧: "..StartFrame..", 当前帧: "..FrameCount)
			end
		end
	end
end

--状态更新
function OnStateUpdate(nCurrentLife, nCurrentMana, nCurrentRage, nCurrentEnergy, nCurrentSunEnergy, nCurrentMoonEnergy)
	--print("OnStateUpdate, 怒气: "..v["怒气"], nCurrentRage, "当前帧: ".. frame())
	v["怒气"] = nCurrentRage
end
