--[[ 奇穴:[龙息][归酣][冥鼔][霜天][含风][见尘][分疆][星火][惊鸿][绝期][重烟][降麒式]
秘籍:
破釜 1会心 3伤害
上将 2会心 2伤害
擒龙 2伤害 2回气
刀啸 2会心 2伤害
--]]

--关闭自动面向
setglobal("自动面向", false)

--变量表
local v = {}
v["输出信息"] = true

--函数表
local f = {}

--主循环
function Main(g_player)
	if casting("刀啸风吟") and castleft() < 0.13 then
		settimer("刀啸读条结束")
	end

	--初始化变量
	v["刀魂"] = energy()
	v["狂意"] = rage()
	v["气劲"] = qijin()
	v["破釜CD"] = scdtime("破釜沉舟")
	v["上将CD"] = scdtime("上将军印")
	if qixue("龙息") then
		v["擒龙CD"] = odtime("擒龙六斩")
	else
		v["擒龙CD"] = scdtime("擒龙六斩")
	end
	v["坚壁CD"] = scdtime("坚壁清野")
	v["闹须弥CD"] = scdtime("闹须弥")
	v["GCD"] = cdleft(16)
	v["GCD间隔"] = cdinterval(16)
	v["含风时间"] = bufftime("含风")
	v["含风层数"] = buffsn("含风")
	v["降麒层数"] = buffsn("15253")
	local tSpeedXY, tSpeedZ = speed(tid())
	v["目标静止"] = rela("敌对") and tSpeedXY <= 0 and tSpeedZ <= 0

	if not rela("敌对") then return end
	if gettimer("体态切换") < 0.3 then return end

	--先上闹
	if v["刀魂"] >= 10 and v["闹须弥CD"] <= 0 and tnobuff("闹须弥", id()) then
		f["切换体态"]("松烟竹雾")
	end

	--------------------------------------------- 大刀
	if buff("秀明尘身") then
		if v["破釜CD"] > v["GCD间隔"] and v["上将CD"] > v["GCD间隔"] then
			f["切换体态"]("雪絮金屏")
		end

		if dis() > 10 then
			f["切换体态"]("雪絮金屏")
		end
		
		if od("破釜沉舟") < 2 then
			if v["目标静止"] and dis() < 5 then
				if aCastX("上将军印") then
					settimer("上将军印")
				end
			end
		end

		if dis() < 6 and face() < 90 then
			CastX("破釜沉舟")
		end
	end

	--------------------------------------------- 鞘刀
	if buff("雪絮金屏") then
		if v["坚壁CD"] > 1 and dis() < 10 then
			if v["破釜CD"] < v["GCD"] + 0.1 then
				f["切换体态"]("秀明尘身")
			end
			if v["擒龙CD"] < 0.1 and v["破釜CD"] < v["GCD"] + v["GCD间隔"] + 0.125 then
				f["切换体态"]("松烟竹雾")
			end
		end

		if v["目标静止"] and dis() < 16 then
			aCastX("坚壁清野")
		end

		if CastX("刀啸风吟") then
			settimer("刀啸风吟")
		end
	end

	--------------------------------------------- 双刀
	if buff("松烟竹雾") then
		if tbuff("闹须弥", id()) or v["闹须弥CD"] > 1 then
			if v["GCD"] < 0.5 and nobuff("15098") then
				if v["破釜CD"] < 0.1 and v["狂意"] >= 25 then
					f["切换体态"]("秀明尘身")
				end
			end
		end

		if tnobuff("闹须弥", id()) then
			if CastX("闹须弥") then
				settimer("闹须弥")
			end
		end

		if gettimer("降麒式") > 0.3 and dis() < 6 then
			if CastX("降麒式") then
				settimer("降麒式")
			end
		end

		CastX("擒龙六斩")
		
		if v["擒龙CD"] > 1 and (gettimer("降麒式") > 0.3 or v["狂意"] < 25) then
			CastX("龙骧虎步")
		end
	end

	if fight() and rela("敌对") and dis() < 4 and face() < 90 and cdleft(16) <= 0 and castleft() <= 0 and state("站立") and gettimer("刀啸风吟") > 0.5 then
		PrintInfo("----------没打技能, ")
	end
end

f["切换体态"] = function(SkillName)
	if gettimer("上将军印") < 0.3 or gettimer("闹须弥") < 0.3 then return end
	if nobuff(SkillName) then
		if CastX(SkillName) then
			settimer("体态切换")
			exit()
		end
	end
end

--输出信息
function PrintInfo(s)
	local szinfo = "狂意:"..v["狂意"]..", 气劲:"..v["气劲"]..", 刀魂"..v["刀魂"]..", GCD:"..v["GCD"]..", 破釜CD:"..v["破釜CD"]..", 上将CD:"..v["上将CD"]..", 坚壁CD:"..v["坚壁CD"]..", 擒龙CD:"..v["擒龙CD"]..", 含风:"..v["含风层数"]..", "..v["含风时间"]
	if s then
		szinfo = s..szinfo
	end
	print(szinfo)
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
--面向目标后使用技能
function aCastX(szSkill)
	if acast(szSkill) then
		if v["输出信息"] then
			PrintInfo()
		end
		return true
	end
	return false
end

--buff更新回调
function OnBuff(CharacterID, BuffName, BuffID, BuffLevel, StackNum, SkillSrcID, StartFrame, EndFrame, FrameCount)
	if CharacterID == id() then
		if StackNum  > 0 then
			if BuffID == 10814 or BuffID == 10815 or BuffID == 10816 then	--3体态buff
				deltimer("体态切换")
			end
		end
	end
end

--战斗状态回调
function OnFight(bFight)
	if bFight then
		print("--------------------进入战斗")
	else
		print("--------------------离开战斗")
	end
end
