output("----------镇派----------")
output("2 2 3")
output("3 2 1 2")
output("3 1 1 1")
output("3 0 2")
output("2 3")
output("1")
output("0 3 1")


--变量表
local v = {}

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

		if life() < 0.5 and buffstate("减伤效果") < 45 then
			if cast("守如山") then
				settimer("守如山")
				return
			end
		end

		if life() < 0.4 then
			cast("昂如岳")
			return
		end
	end
end

--主循环
function Main(g_player)
	
	if nobuff("撼如雷") then
		cast("撼如雷", true)
	end

	if rela("敌对") then
		if ttid() ~= 0 and ttid() ~= id() then		--目标有目标，不是自己
			cast("定军")
		end

		if dis() < 4 and mana() < 0.4 then
			cast("徐如林")
		end
	end

	if cdtime("定军") > 5 then
		cast("掠如火")
	end

	--打断
	if tbuffstate("可打断") and tcastleft() < 1 then
		cast("崩")
	end

	--渊
	if map("英雄法王窟") then
		if life() > 0.7 then
			xcast("渊", party("buff时间:生命流逝>5"))		--法王窟_青翼蝠王_吸血大法_生命流逝
		end
	end
	if fight() and life() > 0.8 then
		xcast("渊", party("没状态:重伤", "距离<20", "气血<0.4", "内功:离经易道|云裳心经|补天诀|相知|灵素", "视线可达"))		--低血量奶妈
	end

	--减伤
	JianShang()


	_, v["目标周围敌人数量"] = tnpc("关系:敌对", "距离<8", "可选中")
	if v["目标周围敌人数量"] >= 2 then
		cast("穿")
	end
	cast("灭")
	cast("破风")
end
