output("奇穴: [淘尽][清风][夜雨][景行][映波锁澜][怜光][凭风][危峦][雾锁][残雪][如风][飞来闻踪]")

--变量表
local v = {}
v["等待内功切换"] = false
v["等待读条结束"] = false


--主循环
function Main(g_player)

	--飞来闻踪防打断
	if casting("飞来闻踪") then
		return
	else
		nomove(false)
	end

	--等待读条结束
	if casting() and castleft() < 0.13 then
		v["等待读条结束"] = true
		settimer("读条结束")
	end

	if v["等待读条结束"] and gettimer("读条结束") < 0.3 then
		return
	end

	if v["等待内功切换"] and gettimer("啸日") < 0.5 then
		return
	end


	v["剑气"] = rage()

	-------------------------------------------------------轻剑
	if mount("问水诀") then

		if cdtime("九溪弥烟") > 2 and  rage() >= 90 then
			cast("啸日")
		end


		cast("玉虹贯日")
		
		if acast("黄龙吐翠", 180) then
			return
		end
		
		if rela("敌对") and dis() < 5 then
			cast("九溪弥烟")
		end
		
		cast("听雷")
	end

	-------------------------------------------------------重剑
	if mount("山居剑意") then
		
		if nobuff("闻踪") and cntime("啸日", true) < 3 then
			cast("啸日")
			return
		end

		if bufftime("闻踪") > 10 and v["剑气"] < 30 then
			cast("莺鸣柳")
		end

		if nobuff("凤鸣") then
			cast("听雷")
		end

		if rela("敌对") and dis() < 10 and nobuff("夜雨") and cdtime("云飞玉皇") <= 0 and v["剑气"] >= 30 then
			if cast("峰插云景") then
				settimer("峰插云景")
			end
		end

		if gettimer("峰插云景") < 0.5 or buff("云景") or dis() < 4 then
			cast("云飞玉皇")
		end

		if rela("敌对") and dis() < 10 and v["剑气"] < 30 then
			cast("飞来闻踪")
		end

		cast("夕照雷峰")

		cast("听雷")
	end

end


--切换内功
function OnMountKungFu(KungFu, Level)
	v["等待内功切换"] = false
end


--释放技能
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		--[夕照雷峰][云飞玉皇][风来吴山]
		if SkillID == 1600 or SkillID == 1593 or SkillID == 18333 then
			v["等待读条结束"] = false
		end
	end
end
