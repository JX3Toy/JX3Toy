output("奇穴: [孤漠][归酣][冥鼔][化蛟][含风][临江][斩纷][星火][惊鸿][绝期][砺锋][心镜]")

--变量表
local v = {}
v["等待体态同步"] = false

--函数表
local f = {}

f["切换体态"] = function(SkillName)
	--等待上将僵直同步
	if gettimer("上将军印") < 0.5 then return end

	if nobuff(SkillName) then
		if cast(SkillName) then
			settimer("体态切换")
			v["等待体态同步"] = true
			exit()
		end
	end
end

--主循环
function Main(g_player)
	if casting("醉斩白蛇") then return end

	if casting("刀啸风吟") then
		if castleft() <= 0.125 then
			settimer("刀啸风吟读条结束")
		end
		return
	end

	--等待体态同步
	if v["等待体态同步"] and gettimer("体态切换") < 0.3 then
		return
	end

	--没进战, 切双刀
	if nofight() then
		f["切换体态"]("松烟竹雾")
	end


	v["刀魂"] = energy()
	v["狂意"] = rage()
	v["气劲"] = qijin()
	v["有破釜破招buff"] = gettimer("刀啸风吟读条结束") < 1 or bufftime("25049") > 5
	v["GCD间隔"] = cdinterval(16)


	--v["切大刀"] = scdtime("上将军印") < v["GCD间隔"] and scdtime("破釜沉舟") < v["GCD间隔"] and v["有破釜破招buff"]
	--v["切大刀"] = scdtime("上将军印") < v["GCD间隔"] and odtime("破釜沉舟") < 8 and v["有破釜破招buff"]
	v["切大刀"] = scdtime("上将军印") < v["GCD间隔"] and v["有破釜破招buff"] and v["狂意"] >= 25


	---------------------------------------------大刀
	if buff("秀明尘身") then
		if scdtime("破釜沉舟") > 2 and scdtime("上将军印") > 2 then
			if scdtime("擒龙六斩") < 1 then
				f["切换体态"]("松烟竹雾")
			end
			f["切换体态"]("雪絮金屏")
		end

		if dis() < 6 then
			if od("破釜沉舟") >= 2 then
				acast("破釜沉舟")
			end

			if dis() < 5 then
				if acast("上将军印") then
					settimer("上将军印")
				end
			end

			if v["刀魂"] < 30 and v["气劲"] < 30 then
				cast("龙骧虎步")
			end


			acast("破釜沉舟")
		end
	end

	---------------------------------------------拔刀
	if buff("雪絮金屏") then
		if v["切大刀"] then
			if scdtime("擒龙六斩") < 1 then
				f["切换体态"]("松烟竹雾")
			end
			f["切换体态"]("秀明尘身")
		end
		
		if tstate("站立|被击倒|眩晕|定身|锁足|爬起") and dis() < 16 then
			acast("坚壁清野")
		end

		if buff("19244") then
			cast("醉斩白蛇")
		end

		cast("刀啸风吟")
	end

	---------------------------------------------双刀
	if buff("松烟竹雾") then
		if tbufftime("闹须弥", id()) < 1 then
			cast("闹须弥")
		end

		if cast("擒龙六斩") then
			if v["切大刀"] then
				f["切换体态"]("秀明尘身")
			else
				f["切换体态"]("雪絮金屏")
			end
		end
	end

end


--释放技能
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		if SkillName == "秀明尘身" or SkillName == "松烟竹雾" or SkillName == "雪絮金屏" then
			v["等待体态同步"] = false
		end
	end
end
