--[[ 奇穴:[龍息][歸酣][陽關][霜天][含風][見塵][分疆][星火][楚歌][絕期][重煙][降麒式]
秘籍:
项王  1会心 2伤害 1回狂意
破釜  1会心 3伤害
上将  2会心 2伤害
擒龙  2伤害 2效果
刀啸  2会心 2伤害
--]]

--关闭自动面向
setglobal("自动面向", false)
addopt("副本防开怪", false)

--变量表
local v = {}
v["记录信息"] = true

--函数表
local f = {}

--主循环
function Main(g_player)
	
	-- 按下自定义快捷键1交扶摇
	if keydown(1) then
		cast("扶搖直上")
	end

	if casting("刀嘯風吟") and castleft() < 0.13 then
		settimer("刀啸读条结束")
	end

	if gettimer("刀啸读条结束") <= 0.25 then
		return
	end

	--初始化变量
	v["刀魂"] = energy()
	v["狂意"] = rage()
	v["气劲"] = qijin()
	v["破釜CD"] = odtime("破釜沉舟")
	v["上将CD"] = scdtime("上將軍印")
	if qixue("龍息") then
		v["擒龙CD"] = odtime("擒龍六斬")
	else
		v["擒龙CD"] = scdtime("擒龍六斬")
	end
	v["坚壁CD"] = scdtime("堅壁清野")
	v["闹须弥CD"] = scdtime("鬧須彌")
	v["GCD"] = cdleft(16)
	v["GCD间隔"] = cdinterval(16)
	v["含风时间"] = bufftime("含風", id())
	v["含风层数"] = buffsn("含風", id())
	v["降麒层数"] = buffsn("15253")
	local tSpeedXY, tSpeedZ = speed(tid())
	v["目标静止"] = rela("敌对") and tSpeedXY <= 0 and tSpeedZ <= 0
	
	if nofight() then v["擒龙计数"] = 0 v["双擒标志"] = false end
	
	if not rela("敌对") then return end
	if gettimer("体态切换") < 0.3 then return end
	
	if getopt("副本防开怪") and dungeon() and nofight() then 
		return
	end
	
	if v["气劲"] >= 5 and v["含风时间"] <= 2 and cdleft(16) < 0.25 and nobuff("雪絮金屏") then
		f["切换体态"]("雪絮金屏")
		return
	end
	
	--先上闹
	if v["刀魂"] >= 10 and v["闹须弥CD"] <= 0 and tnobuff("鬧須彌", id()) and v["含风时间"] > 2 and nobuff("松煙竹霧") then
		f["切换体态"]("松煙竹霧")
		return
	end
	
	if (tbuff("鬧須彌", id()) or v["闹须弥CD"] > 1) and v["含风时间"] > 5 and v["气劲"] >= 10 and v["坚壁CD"] <= v["GCD"] and cdleft(16) < 0.25 and v["含风层数"] < 2 then
		f["切换体态"]("雪絮金屏")
	end
	
	if buff("15098") and bufftime("15098") < 1.5 and nobuff("雪絮金屏") then
		f["切换体态"]("松煙竹霧")
		return
	end
	
	if dis() > 10 and fight() and (tbuff("鬧須彌", id()) or v["闹须弥CD"] > 1) then
		f["切换体态"]("雪絮金屏")
	end
	
	--------------------------------------------- 大刀
	if buff("秀明塵身") then
		--[[if v["狂意"] < 25 and v["上将CD"] > v["GCD"] + 0.25 then
			f["切换体态"]("松煙竹霧")
		end--]]
		
		if v["上将CD"] > v["GCD"] + 0.25 and od("破釜沉舟") < 1 and v["坚壁CD"] <= v["GCD"] + 0.25 and cdleft(16) < 0.24 and (od("擒龍六斬") > 4 or v["擒龙CD"] < v["GCD"] + 0.25) then
			f["切换体态"]("松煙竹霧")
			return
		end
		
		if v["含风层数"] < 2 and v["上将CD"] > v["GCD"] and od("破釜沉舟") < 1 and cdleft(16) < 0.25 then
			f["切换体态"]("雪絮金屏")
		end
		
		if v["上将CD"] > v["GCD"] + 0.25 and od("破釜沉舟") < 2 and v["含风时间"] > 3.5 and cdleft(16) < 0.24 and (od("擒龍六斬") > 5 or v["擒龙CD"] < v["GCD"]) then
			f["切换体态"]("松煙竹霧")
		end
		
		if v["上将CD"] > v["GCD"] + 0.25 and od("破釜沉舟") < 1 and v["含风时间"] > 3.5 and v["含风时间"] < 9 and cdleft(16) < 0.24 and (od("擒龍六斬") > 5 or v["擒龙CD"] < v["GCD"] + 0.25) then
			f["切换体态"]("松煙竹霧")
		end
		
		if v["上将CD"] > v["GCD"] + 0.25 and od("破釜沉舟") < 1 and v["含风时间"] > 0 and v["含风时间"] < 3.5 and cdleft(16) < 0.24 then
			f["切换体态"]("雪絮金屏")
		end
		
		if v["上将CD"] > v["GCD"] + 0.25 and od("破釜沉舟") < 1 and v["坚壁CD"] <= v["GCD"] and cdleft(16) < 0.24 and od("擒龍六斬") < 6 and v["擒龙CD"] > v["GCD"] then
			f["切换体态"]("雪絮金屏")
		end
		
		if v["上将CD"] > v["GCD"] + 0.25 and od("破釜沉舟") < 1 and v["含风时间"] <= 15.5 and cdleft(16) < 0.24 and od("擒龍六斬") < 6 and v["擒龙CD"] > v["GCD"] then
			f["切换体态"]("雪絮金屏")
		end
		
		if v["上将CD"] > v["GCD"] + 0.25 and od("破釜沉舟") < 1 and v["含风时间"] <= 15.5 and cdleft(16) < 0.24 and od("擒龍六斬") > 5 then
			if v["含风时间"] > 3.5 then
				f["切换体态"]("松煙竹霧")
			elseif v["含风时间"] < 3.5 then
				f["切换体态"]("雪絮金屏")
			end
		end
		
		if v["上将CD"] > v["GCD"] + 0.25 and od("破釜沉舟") < 1 and v["含风时间"] > 15.5 and cdleft(16) < 0.24 and od("擒龍六斬") > 5 then
			f["切换体态"]("松煙竹霧")
		end
		
		if v["上将CD"] > v["GCD"] + 0.25 and od("破釜沉舟") < 2 and gettimer("破釜沉舟") < 2 and v["含风时间"] > 15.5 and cdleft(16) < 0.24 and od("擒龍六斬") > 5 then
			f["切换体态"]("松煙竹霧")
		end
		
		if v["上将CD"] > v["GCD"] + 0.25 and od("破釜沉舟") < 1 and v["含风时间"] > 15.5 and cdleft(16) < 0.24 and od("擒龍六斬") < 6 and v["擒龙CD"] > v["GCD"] then
			f["切换体态"]("雪絮金屏")
		end
		
		--[[if v["上将CD"] > v["GCD"] + 0.25 and od("破釜沉舟") < 2 and v["破釜CD"] > v["GCD"] + 0.25 and v["坚壁CD"] <= v["GCD"] and cdleft(16) < 0.24 and v["上将CD"] > 2 then
			f["切换体态"]("雪絮金屏")
		end--]]
		
		if od("破釜沉舟") > 1 and dis() < 6 and face() < 90 then
			if CastX("破釜沉舟") then
				settimer("破釜沉舟")
			end
		end
		
		if dis() < 5 then
			if aCastX("上將軍印") then
				settimer("上将军印")
			end
		end
		
		if dis() < 6 and face() < 90 then
			if CastX("破釜沉舟") then
				settimer("破釜沉舟")
			end
		end
		
		CastX("雷走風切")
		
	end
	
	--------------------------------------------- 鞘刀
	
	if buff("雪絮金屏") then
	
		if gettimer("堅壁清野") < 3 and dis() < 6 then
			if v["上将CD"] <= v["GCD"] + 0.25 and v["狂意"] >= 25 then
				f["切换体态"]("秀明塵身")
			end
			
			if (od("破釜沉舟") > 0 or v["破釜CD"] <= v["GCD"] + 0.25) and v["狂意"] >= 25 then
				f["切换体态"]("秀明塵身")
			end
			
			if ((v["上将CD"] > v["GCD"] + 0.25 and od("破釜沉舟") < 1 and v["破釜CD"] > v["GCD"] + 0.25) or (v["狂意"] < 25)) and (od("擒龍六斬") > 5 or v["擒龙CD"] < v["GCD"] + 0.25) then
				f["切换体态"]("松煙竹霧")
			end
		end
		
		if v["含风时间"] > 15 and (v["含风层数"] > 1 or gettimer("堅壁清野") < 3) and v["坚壁CD"] > v["GCD"] + 0.25 and dis() < 6 then
			if v["上将CD"] <= v["GCD"]+ 0.25 and v["狂意"] >= 25 then
				f["切换体态"]("秀明塵身")
			end
			
			if (od("破釜沉舟") > 0 or v["破釜CD"] <= v["GCD"] + 0.25) and v["狂意"] >= 25 then
				f["切换体态"]("秀明塵身")
			end
			
			if ((v["上将CD"] > v["GCD"] + 0.25 and od("破釜沉舟") < 1 and v["破釜CD"] > v["GCD"] + 0.25) or (v["狂意"] < 25)) and (od("擒龍六斬") > 5 or v["擒龙CD"] < v["GCD"] + 0.25) then
				f["切换体态"]("松煙竹霧")
			end
		end
		
		if dis() < 6 and fight() and v["含风时间"] > 2 then
			if aCastX("堅壁清野") then
				settimer("堅壁清野")
				return
			end
				
		end
		
		if (v["含风时间"] < 15 or v["狂意"] < 25 or gettimer("刀嘯風吟") > 3 or dis() > 10 or (v["坚壁CD"] > v["GCD"] + 0.25 and (v["上将CD"] > v["GCD"] + 0.25 and od("破釜沉舟") < 1 and v["破釜CD"] > v["GCD"] + 0.25))) and gettimer("刀嘯風吟") > 0.5 then
			CastX("刀嘯風吟")
		end
		
	end
	
	--------------------------------------------- 双刀
	
	if buff("松煙竹霧") then
		
		if gettimer("降麒式") > 0.3 and (dis() < 6 or (buff("15098") and bufftime("15098") < 3)) then
			if CastX("降麒式") then
				settimer("降麒式")
			end
		end
		
		if gettimer("擒龍六斬") < 3 and v["含风时间"] < 6 and gettimer("擒龍六斬") > 0.3 then
			f["切换体态"]("雪絮金屏")
		end
		
		if gettimer("擒龍六斬") < 3 and v["上将CD"] <= v["GCD"] + 0.25 and nobuff("15098") and v["狂意"] >= 25 and gettimer("擒龍六斬") > 0.3 and dis() < 6 then
			f["切换体态"]("秀明塵身")
		end
		
		if gettimer("擒龍六斬") < 3 and (od("破釜沉舟") > 0 or v["破釜CD"] <= v["GCD"] + 0.25) and nobuff("15098") and v["狂意"] >= 25 and gettimer("擒龍六斬") > 0.3 and dis() < 6 then
			f["切换体态"]("秀明塵身")
		end
		
		if gettimer("擒龍六斬") < 3 and v["上将CD"] > v["GCD"] + 0.25 and od("破釜沉舟") < 1 and v["坚壁CD"] <= v["GCD"] and nobuff("15098") and gettimer("擒龍六斬") > 0.3 and cdleft(16) < 0.8 then
			f["切换体态"]("雪絮金屏")
		end
		
		if gettimer("擒龍六斬") < 3 and v["上将CD"] > v["GCD"] + 0.25 and od("破釜沉舟") < 1 and v["双擒标志"] and nobuff("15098") and gettimer("擒龍六斬") > 0.3 and cdleft(16) < 0.8 then
			f["切换体态"]("雪絮金屏")
		end
		
		if od("擒龍六斬") <= 4 and v["上将CD"] > v["GCD"] + 0.25 and od("破釜沉舟") < 1 then
			f["切换体态"]("雪絮金屏")
		end
		
		--[[if gettimer("擒龍六斬") < 3 and v["上将CD"] > v["GCD"] + 0.25 and od("破釜沉舟") < 1 and v["坚壁CD"] > 9 then
			f["切换体态"]("雪絮金屏")
		end--]]
			
		if tnobuff("鬧須彌", id()) then
			if CastX("鬧須彌") then
				settimer("闹须弥")
			end
		end
		
		if od("擒龍六斬") > 4 then
			if CastX("擒龍六斬") then
				settimer("擒龍六斬")
			end
		end
		
		if od("擒龍六斬") > 4 then
			if CastX("逐鷹式") then
				settimer("擒龍六斬")
			end
		end
		
		if od("擒龍六斬") < 5 and v["狂意"] < 25 then
			CastX("龍驤虎步")
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

--记录信息
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
		if v["记录信息"] then
			PrintInfo()
		end
		return true
	end
	return false
end

--面向目标后使用技能
function aCastX(szSkill)
	if acast(szSkill) then
		if v["记录信息"] then
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

v["擒龙计数"] = 0
v["双擒标志"] = false

function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		if SkillID == 16027 then
			settimer("刀嘯風吟")
			return
		end
		
		if SkillID == 16166 then
			settimer("松烟计时")
			return
		end
		
		if SkillID == 16871 then
			v["擒龙计数"] = 1
		end
		
		if SkillID == 16621 and v["双擒标志"] then
			v["双擒标志"] = false
			v["擒龙计数"] = 0
		end
		
		if SkillID == 16621 and v["擒龙计数"] == 1 then
			v["双擒标志"] = true
		end
		
	end
end
