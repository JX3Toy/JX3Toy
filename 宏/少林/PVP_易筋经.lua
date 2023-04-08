output("奇穴: [秉心][抱残][抢珠式][缩地][降魔渡厄][系珠][独觉][三生][尘息][缘觉][明澈][醍醐灌顶]")

--载入库
load("Macro/Lib_PVP.lua")

--变量表
local v = {}
v["等待气点同步"] = false

--函数表
local f = {}

--主循环
function Main(g_player)
	--初始化
	g_func["初始化"]()

	--解控
	f["解控"]()

	--等待气点同步
	if v["等待气点同步"] and gettimer("等待气点同步") < 0.5 then return end
	v["禅那"] = qidian()


	--jjc目标一刀先打伤害
	if jjc() and g_var["目标一刀"] then
		f["打伤害"]()
	end

	--打控制
	if g_var["目标可控制"] and target("player") then
		--抢珠式
		if mounttype("内功|治疗") and tbuffstate("可封内") and tbuffstate("封内时间") < 0 then
			cast("抢珠式")
		end
		
		if tbuffstate("定身时间") < 0 and tbuffstate("眩晕时间") < 0 and tbuffstate("击倒时间") < 0 then
			f["打控制"]()
		end
	end

	--减伤
	if fight() then
		if life() < 0.6 then
			cast("无相诀", true)
		end
		if life() < 0.3 then
			cast("锻骨诀", true)
		end
	end

	--打伤害
	if g_var["目标可攻击"] then
		f["打伤害"]()
	end

	--挂扶摇
	cast("扶摇直上")


	if nobuff("般若诀") then
		cast("般若诀", true)
	end

	--采集任务物品
	if nofight() then
		g_func["采集"](g_player)
	end
end

--气点更新
OnQidianUpdate = function()
	v["等待气点同步"] = false
end

--自己和队友buff更新
function OnBuff(CharacterID, BuffName, BuffID, BuffLevel, StackNum, SkillSrcID, StartFrame, EndFrame, FrameCount)
	if CharacterID == id()  then
		if buffis(BuffID, BuffLevel, "封外功") then
			bigtext("被沉默")
		end
		if buffis(BuffID, BuffLevel, "封阳性") then
			bigtext("被封内")
		end
		if buffis(BuffID, BuffLevel, "缴械") then
			bigtext("被缴械")
		end
	end
end


f["解控"] = function()
	--防止重复放解控
	if gettimer("二业依缘") <  0.5 or gettimer("锻骨诀") < 0.5 then return end


	if qixue("妙法") and buffstate("锁足时间") > 1 and g_var["突进"] then
		cast("千斤坠")
	end

	
	if buffstate("定身时间") > 1 or buffstate("眩晕时间") > 1 or buffstate("击倒时间") > 1 then
		--二业依缘
		if cast("二业依缘", true) then
			settimer("二业依缘")
			return
		end

		--锻骨诀
		if cast("锻骨诀", true) then
			settimer("锻骨诀")
			return
		end
	end
end


f["打伤害"] = function()

	--擒龙诀
	if dis() < 6 and nobuff("擒龙诀|禅意") and gettimer("擒龙诀") > 0.5 then
		if cast("擒龙诀") then
			settimer("擒龙诀")
			settimer("等待气点同步")
			v["等待气点同步"] = true
			exit()
		end
	end

	if v["禅那"] >=3 then
		--拿云式
		if qixue("缘觉") then
			if g_var["突进"] then
				cast("拿云式")
			end
		else
			cast("拿云式")
		end

		--韦陀献杵
		cast("韦陀献杵")

		--罗汉金身
		if cast("罗汉金身") then
			settimer("等待气点同步")
			v["等待气点同步"] = true
			exit()
		end
	end

	if dis() < 5.5 then
		cast("横扫六合")
	end

	if dis() < 11 then
		acast("醍醐灌顶")
	end

	cast("守缺式")
	cast("普渡四方")
	cast("捕风式")
end


f["打控制"] = function()

	if dis() < 5 and tbuffstate("可眩晕") then
		cast("大狮子吼")
	end

	if tbuffstate("可击倒") then
		cast("摩诃无量")
	end

	if g_var["突进"] and tbuffstate("可眩晕") then
		cast("千斤坠")
	end
end
