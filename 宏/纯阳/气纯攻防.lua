output("奇穴: [雾锁][吐故纳新][抱一][抱元][玄德][跬步][万物][无我][霜寒][心眼][重光][规焉]")

--载入库
load("Macro/Lib_PVP.lua")

--变量表
local v = {}

--函数表
local f = {}

--主循环
function Main(g_player)
	--初始化
	g_func["初始化"]()

	--选目标
	f["切换目标"]()

	--镇山河
	if fight() and life() < 0.5 and height() < 3 then
		if nobuff("镇山河") and gettimer("镇山河") > 1 then
			if cast("镇山河", true) then
				settimer("镇山河")
				stopmove()
			end
		end
	end

	--凭虚御风
	if fight() and life() < 0.75 then
		cast("凭虚御风")
	end

	--紫气东来
	if rela("敌对") and g_var["目标没减伤"] and dis() < 20 and qidian() <= 3 and qjcount() >= 5 and bufftime("气剑") > 10 then
		if nobuff("紫气东来") and gettimer("紫气东来") > 0.3 then
			if cast("紫气东来") then
				settimer("紫气东来")
			end
		end
	end

	--生太极
	v["生太极距离"], v["生太极时间"] = qc("气场生太极", id(), id())
	if v["生太极距离"] > -1 or v["生太极时间"] < 1 then
		cast("生太极", true)
	end

	--坐忘无我
	if nobuff("坐忘无我") then
		cast("坐忘无我")
	end

	if g_var["目标可攻击"] then
		if qidian() >= 8 then
			cast("两仪化形")
		end
	end

	if qjcount() < 5 then
		cast("万世不竭")
	end

	if g_var["目标可攻击"] then
		cast("四象轮回")
		cast("太极无极")
	end

	--采集任务物品
	if nofight() then
		g_func["采集"](g_player)
	end
end

f["切换目标"] = function()
	v["20尺内敌人"] = enemy("距离<20", "视线可达", "没载具", "气血最少")
	if v["20尺内敌人"] ~= 0 then
		--没目标或不是敌对
		if not rela("敌对") then
			settar(v["20尺内敌人"])
			return
		end
		
		--当前目标挂了
		if tstate("重伤") then
			settar(v["20尺内敌人"])
			return
		end
		
		--距离太远
		if dis() > 20 then
			settar(v["20尺内敌人"])
			return
		end
		
		--视线不可达
		if tnovisible() then
			settar(v["20尺内敌人"])
			return
		end
		
		--比当前目标血量少
		if tlife() > 0.3 and xlife(v["20尺内敌人"]) < tlife() then
			settar(v["20尺内敌人"])
			return
		end
	end
end
