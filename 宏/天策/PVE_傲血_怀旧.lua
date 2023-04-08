output("----------镇派----------")
output("2 3 1")
output("3 2 2 2")
output("2 0 3 1")
output("3 0 2 1")
output("0 0 0 2")
output("1")
output("0 2 3")
output("0 0 1 0")


--副本中没进战不放技能
addopt("副本防开怪", true)

--减伤
function JianShang()
	if fight() and gettimer("啸如虎") > 0.5 and gettimer("御") > 0.5 and gettimer("守如山") > 0.5 and nobuff("啸如虎|御|守如山") then
		if cast("啸如虎") then
			settimer("啸如虎")
			return
		end

		if rela("敌对") and ttid() == id() then
			if dis() < 4 or (tcasting() and tcastleft() < 1) then		--距离小于4尺 或 读条剩余时间小于1秒
				if cast("御") then
					settimer("御")
					return
				end
			end
		end

		if life() < 0.5 and buffstate("减伤效果") < 38 then
			if cast("守如山") then
				settimer("守如山")
				return
			end
		end
	end
end


function Main()

	--副本防开怪
	if getopt("副本防开怪") and dungeon() and nofight() then return end

	--打断
	if tbuffstate("可打断") and tcastleft() < 1 then
		cast("崩")
	end

	--目标是敌人，4尺内, 还没快挂
	if rela("敌对") and dis() < 4 and tlifevalue() > lifemax() * 3 then
		cast("猛虎下山")
		cast("疾如风")
		cast("撼如雷", true)
		if fight() then
			if life() < 0.6 or mana() < 0.6 then
				cast("徐如林")
			end
		end
	end


	--减伤
	JianShang()


	if tbuff("致残", id()) then
		if tnobuff("破风", id()) then
			cast("破风")
		end
		cast("灭")
	end

	if life() < 0.5 or tbufftime("破风", id()) < 2 then
		cast("灭")
	end

	cast("龙牙")
	cast("龙吟")
	cast("霹雳")
	cast("穿云")

	cast("突")

	cast("扶摇直上")

	--GCD中间起跳突
	if buff("弹跳") and cdleft(16) > 1 and cdtime("突") < 0.2 then
		jump()
	end

end
