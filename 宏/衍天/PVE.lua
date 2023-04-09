output("奇穴: [水盈][天网][顺祝][枭神][重山][鬼遁][祝祷][连断][荧入白][征凶][灵器][增卜]")


--处理卦象
local guaxiang = function()
	
	--如果破招还没打，不起卦变卦
	if buff("24457") then return end

	--主动技能
	if gettimer("祝由·火离") > 0.3 then
		if cast("祝由·火离") then
			settimer("祝由·火离")
		end
	end

	if gettimer("祝由·水坎") > 0.3 and rela("敌对") then
		if xcast("祝由·水坎", ttid()) then
			settimer("祝由·水坎")
		end
	end

	if gettimer("卦象计时器") < 0.5 then return end

	--变卦
	local biangua = false

	if rela("敌对") and dis() < 20 then
		if buff("水坎") and mana() > 0.6 then
			biangua = true
		end
		if buff("山艮") and tbufftime("祝由·火离", id()) < 1 then
			biangua = true
		end
		if buff("火离") and nobuff("17825") then
			biangua = true
		end
	end

	if biangua then
		if fcast("变卦") then
			settimer("卦象计时器")
			return
		end
	end

	--起卦
	local qigua = false

	if mana() < 0.19 then
		qigua = true
	end

	if nobuff("水坎|山艮|火离") then
		qigua = true
	end

	if rela("敌对") and dis() < 20 and tbufftime("祝由·火离", id()) < 1 and nobuff("17825") then
		qigua = true
	end

	if biangua or qigua then
		if cast("起卦") then
			settimer("卦象计时器")
		end
	end
end

--处理灯
local deng = function()

	--放灯
	if rela("敌对") then
		--当前灯的数量
		local lampCount = dengcount()

		--没有灯，返闭惊魂放第一个灯
		if lampCount == 0 and dis() < 15 then
			if cast("返闭惊魂") then
				return
			end
		end
		
		--有1个灯，放第二个
		if lampCount == 1 then
			tfangdeng()
		end
		
		--有2个灯，放第3个，距离目标5.5尺内
		if lampCount == 2 then
			tfangdeng(5.5)
		end
	end

	--移灯
	if ljtime() > 8 then
		if npc("关系:自己", "buff时间:22960>0") == 0 then		--没天网
			tmovedeng(5.5)
		end
	end

	--连局时间快到了爆灯
	if lianju() and ljtime() < 2 then
		fcast("鬼星开穴")
	end

	--放灯条件满足
	if lianju() and cn("奇门飞宫") >= 2 and cdtime("返闭惊魂") < 4 then
		--没鬼遁，或者目标不在连局里面, 爆灯
		if bufftime("鬼遁") < 1 or xnolianju(tid()) then
			fcast("鬼星开穴")
		end
		--补火
		if tbufftime("祝由·火离", id()) < 1 and xinlianju(tid()) and bufftime("火离") > 0.5 then
			fcast("鬼星开穴")
		end
	end
end

--主循环
function Main(g_player)
	if casting("天斗旋") and castleft() < 0.13 then
		settimer("天斗旋读条结束")
	end


	--打断
	if tbuffstate("可打断") then
		cast("神皆寂")
	end

	--处理卦象
	guaxiang()

	--处理灯
	deng()
	
	if buff("归一") then
		fcast("天斗旋")
	end

	if tbufftime("祝由·火离", id()) > 1 and tbuffsn("增卜", id()) < 10 then
		cast("兵主逆")
	end

	--[[
	if bufftime("山艮") > 1.5 then
		cast("天斗旋")
	end
	--]]

	if buff("24457") and gettimer("天斗旋读条结束") > 0.5 then
		cast("天斗旋")
	end
	
	cast("兵主逆")
	
	if gettimer("天斗旋读条结束") > 0.5 then
		cast("天斗旋")
	end

	cast("三星临")
end
