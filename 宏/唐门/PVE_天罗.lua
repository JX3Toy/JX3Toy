output("奇穴: [血影留痕][天风汲雨][弩击急骤][千机之威][流星赶月][聚精凝神][化血迷心][杀机断魂][秋风散影][积重难返][曙色催寒][诡鉴冥微]")

--变量表
local v = {}

function Main(g_player)
	--防止打断鬼斧
	if gettimer("鬼斧神工") < 0.5 or lasttime("鬼斧神工") < 2 or casting("鬼斧神工") then
		return
	else
		nomove(false)		--允许移动
	end
	
	--减伤
	if fight() and life() < 0.5 then
		cast("惊鸿游龙")
	end

	if not rela("敌对") then return end

	--打断
	if tbuffstate("可打断") then
		fcast("梅花针")
	end

	--放弩
	if dis() < 20 then
		if nopuppet() or xxdis(pupid(), tid()) > 25 then		--没有弩或者弩和目标超过25尺
			cast("千机变", true)
		end

		--毒刹群攻
		if puppet("机关千机变底座|机关千机变连弩|机关千机变重弩") then
			_, v["弩10尺敌人数量"] = xnpc(pupid(), "关系:敌对", "距离<10", "可选中")
			if v["弩10尺敌人数量"] >= 3 then
				cast("毒刹形态")
			end
		end

		--连弩
		if puppet("机关千机变底座|机关千机变重弩") then
			cast("连弩形态")
		end

		--时间快到了，换重弩
		if puppet("机关千机变连弩") and gettimer("释放连弩") > 115 then
			cast("重弩形态")
		end
	end

	--弩攻击
	if puppet("机关千机变连弩|机关千机变重弩") and puptid() ~= tid() and xxdis(pupid(), tid()) < 25 and xxvisible(pupid(), tid()) then
		cast("攻击")
	end

	--心无绑定鬼斧
	if gettimer("释放鬼斧") < 5 then
		cast("心无旁骛")
	end

	--鬼斧
	if puppet("机关千机变连弩") and gettimer("释放连弩") < 80 then	--弩的剩余时间大于40秒
		if xdis(pupid()) < 4 and tlifevalue() > lifemax() * 10 then		--自己和弩的距离小于4尺，目标当前生命值大于自己最大生命值10倍(目标还没快挂)
			if cast("鬼斧神工") then
				stopmove()			--停止所有移动
				nomove(true)		--禁止移动
				settimer("鬼斧神工")
				exit()				--中断脚本执行
			end
		end
	end


	v["诡鉴1时间"] = bufftime("24383")
	v["诡鉴2时间"] = bufftime("24384")


	--没变成天绝, 没进入CD的诡鉴
	_, v["可拟态诡鉴数量"] = npc("名字:诡鉴冥微", "buff时间:24389|24391 < -1")	--24389 变成天绝, 24391 10秒CD, 3342 变成暗藏杀机(这个buff有点问题)
	--print(v["可拟态诡鉴数量"])


	v["暗藏杀机数量"] = 0
	if buff("暗藏杀机A") then
		v["暗藏杀机数量"] = v["暗藏杀机数量"] + 1
	end
	if buff("暗藏杀机B") then
		v["暗藏杀机数量"] = v["暗藏杀机数量"] + 1
	end
	if buff("暗藏杀机C") then
		v["暗藏杀机数量"] = v["暗藏杀机数量"] + 1
	end


	if tstate("站立|被击倒|眩晕|定身|锁足|爬起") then
		if v["暗藏杀机数量"] >= 3 then
			--连放两个诡鉴
			if cn("诡鉴冥微") >= 2 or gettimer("释放诡鉴冥微") < 2 then
				if cast("诡鉴冥微") then
					settimer("诡鉴冥微")
				end
				return
			end
		end
		
		--没有可拟态诡鉴放蛋
		if gettimer("诡鉴冥微") > 0.5 and gettimer("释放诡鉴冥微") > 2 and v["可拟态诡鉴数量"] <= 0 then
			if cast("暗藏杀机") then
				settimer("暗藏杀机")
			end
		end

		--两个诡鉴放天绝
		if v["诡鉴2时间"] > 10 and v["可拟态诡鉴数量"] >= 2 then
			cast("天绝地灭")
		end

		--没有诡鉴放天绝
		if v["诡鉴2时间"] < 0 and cntime("诡鉴冥微") > 8 and cn("飞星遁影") > 0 then
			cast("天绝地灭")
		end
	end

	
	--自己天绝数量
	_, v["天绝数量"] = npc("关系:自己|友好", "表现ID:26112")

	--爆弹
	_, v["暗藏杀机数量"] = tnpc("关系:自己", "名字:机关暗藏杀机", "距离<6")
	if gettimer("诡鉴冥微") > 0.5 and gettimer("释放诡鉴冥微") > 2 and v["暗藏杀机数量"] >= 3 and v["天绝数量"] <= 0 and cntime("诡鉴冥微") > 8 then
		cast("图穷匕见")
	end

	--飞星重置天绝
	if buff("连星") and gettimer("遁影") > 0.5 then
		if cast(17587) then
			settimer("遁影")
		end
	end

	if nobuff("连星") and gettimer("飞星遁影") > 0.5 and cn("诡鉴冥微") >= 1 and cntime("诡鉴冥微") < 6 and cdtime("天绝地灭") > 6 then
		if cast("飞星遁影") then
			settimer("飞星遁影")
		end
		return
	end

	_, v["目标10尺敌人数量"] = tnpc("关系:敌对", "距离<10", "可选中")
	if tnobuff("化血", id()) or (v["目标10尺敌人数量"] >= 3 and energy() > 95) then
		cast("天女散花")
	end

	if cdtime("暗藏杀机") > casttime("暴雨梨花针") then
		if cdtime("天绝地灭") > casttime("暴雨梨花针") or (gettimer("诡鉴冥微") > 0 and v["诡鉴2时间"] < 0) then
			cast("暴雨梨花针")
		end
	end

	if energy() > 80 then
		if cdtime("天绝地灭") > casttime("蚀肌弹") or (gettimer("诡鉴冥微") > 0 and v["诡鉴2时间"] < 0) then
			cast("蚀肌弹")
		end
	end
end


--释放技能
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		if SkillName == "诡鉴冥微" then
			settimer("释放诡鉴冥微")
		end
		if SkillName == "连弩形态" then
			settimer("释放连弩")
		end
		if SkillID == 3110 then
			settimer("释放鬼斧")
		end
	end
end
