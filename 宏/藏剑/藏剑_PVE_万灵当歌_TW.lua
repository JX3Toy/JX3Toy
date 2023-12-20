--[[ 奇穴: [淘盡][清風][岱宗][景行][映波鎖瀾][憐光][層雲][撼嶽][霧鎖][碧歸][如風][飛來聞蹤]
秘籍:
九溪  2伤害 2范围
黄龙  2伤害 2效果(剑气)
云飞  2读条 1伤害 1会心
夕照  1读条 2伤害 1会心
风来  3伤害 1会心
听雷  2会心 2伤害
啸日  1效果(剑气) 3持续
云栖松 2调息 1效果(剑气) 1回血

5尺外开打, 起手玉虹
--]]

--关闭自动面向
setglobal("自动面向", false)

--宏选项
addopt("副本防开怪", false)

--变量表
local v = {}
v["记录信息"] = true

--函数表
local f = {}

--主循环
function Main()
	--按下自定义快捷键1挂扶摇, 注意是快捷键设定里面插件的快捷键1指定的按键，不是键盘上的1
	if keydown(1) then
		cast("扶搖直上")
	end

	--减伤
	if fight() and life() < 0.5 then
		cast("泉凝月")
	end
	
	--记录读条结束
	if casting("雲飛玉皇") and castleft() < 0.13 then
		settimer("云飞读条结束")
	end
	if casting("風來吳山") and castleft() < 0.13 then
		settimer("风来吴山读条结束")
	end

	--初始化变量
	v["剑气"] = rage()

	v["GCD间隔"] = cdinterval(16)
	v["九溪CD"] = scdtime("九溪彌煙")
	v["黄龙CD"] = scdtime("黃龍吐翠")
	v["啸日充能次数"] = cn("嘯日")
	v["啸日充能时间"] = cntime("嘯日", true)
	v["云飞CD"] = scdtime("雲飛玉皇")
	v["风车CD"] = scdtime("風來吳山")
	v["莺鸣充能次数"] = cn("鶯鳴柳")
	v["莺鸣充能时间"] = cntime("鶯鳴柳", true)
	v["云栖CD"] = scdtime("雲棲鬆")
	v["飞来CD"] = scdtime("飛來聞蹤")

	v["凤鸣层数"] = buffsn("鳳鳴")		--听雷命中后, 夕照 云飞 会心&伤害+15% 10秒 2层
	v["凤鸣时间"] = bufftime("鳳鳴")
	v["雾锁时间"] = bufftime("霧鎖")	--夕照命中后, 无视防御60% 5秒
	v["岱宗层数"] = buffsn("岱宗")		--云飞命中后, 会效+8% 15秒 3层
	v["岱宗时间"] = bufftime("岱宗")
	v["目标惊雷时间"] = tbufftime("驚雷", id())	--听雷命中后, 风车额外伤害 10秒
	v["碧归层数"] = buffsn("碧歸")		--风车每2次加1层, 云飞 夕照 鹤归 伤害+30%, 9秒 最大4层
	v["碧归时间"] = bufftime("碧歸")
	v["如风时间"] = bufftime("如風")	--啸日切重剑后, 加速+8%, 10秒, 每次会心延长5秒
	v["闻踪时间"] = bufftime("聞蹤")	--会心+10% 断潮伤害+40%
	
	v["风来吴山"] = npc("关系:自己", "模板ID:57739")
	v["有风来吴山"] = v["风来吴山"] ~= 0 and xnpc(v["风来吴山"], "关系:敌对", "距离<10", "可选中") ~= 0
	v["剑阵"] = npc("关系:自己", "模板ID:122728", "角色距离<8")		--飞来闻踪剑阵
	
	local tSpeedXY, tSpeedZ = speed(tid())
	v["目标静止"] = rela("敌对") and tSpeedXY <= 0 and tSpeedZ <= 0
	v["目标血量较多"] = rela("敌对") and tlifevalue() > lifemax() * 10


	--等待内功切换
	if gettimer("嘯日") < 0.3 then return end

	--脱战切轻剑
	if nofight() and mount("山居劍意") and v["剑气"] < 30 then
		f["啸日"]("脱战切轻剑")
	end

	--目标不是敌人 直接结束
	if not rela("敌对") then return end

	--副本防开怪
	if getopt("副本防开怪") and dungeon() and nofight() then return end
	
	--打伤害
	if mount("問水訣") then
		f["轻剑"]()
	end
	if mount("山居劍意") then
		f["重剑"]()
	end

	--没放技能记录信息
	if fight() and dis() < 4 and state("站立") and cdleft(16) <= 0 and castleft() <= 0 and gettimer("夕照雷峰") > 0.3 and gettimer("雲飛玉皇") > 0.3 and gettimer("風來吳山") > 0.3 then
		PrintInfo("----------没放技能")
	end
end

f["轻剑"] = function()
	--切重剑
	if dis() < 8 then
		if v["剑气"] >= 90 then
			f["啸日"]("切重剑, 剑气满了")
		end
		if v["九溪CD"] > 1 and v["黄龙CD"] > 1 then
			f["啸日"]("切重剑, 九溪黄龙打完了")
		end
	end

	--等待冲刺
	if gettimer("黃龍吐翠") < 0.3 or gettimer("玉虹貫日") < 0.3 then
		if state("衝刺") then
			deltimer("黃龍吐翠")
			deltimer("玉虹貫日")
		else
			return
		end
	end

	--九溪弥烟
	if dis() < 4 then
		CastX("九溪彌煙")
	end

	--听雷
	if v["九溪CD"] > 0 then
		CastX("聽雷")
	end

	--黄龙吐翠
	if cdleft(16) >= 0.5 and face() < 80 then
		if aCastX("黃龍吐翠", 180) then
			return
		end
	end

	--玉虹贯日
	if face() < 80 then
		CastX("玉虹貫日")
	end
end

f["重剑"] = function()
	--云飞玉皇
	if gettimer("云飞读条结束") > 0.3 and v["雾锁时间"] > casttime("雲飛玉皇") then
		CastX("雲飛玉皇")
	end

	--回剑气 云飞之后或者剑气小于30
	if gettimer("云飞读条结束") < 0.3 or gettimer("释放云飞玉皇") < 1 or v["剑气"] < 30 then
		f["回剑气"]()
	end

	--有碧归打夕照
	if v["有风来吴山"] or bufftime("碧歸") < casttime("夕照雷峰") + 0.5 then
		if bufftime("碧歸") > casttime("夕照雷峰") then
			CastX("夕照雷峰")
		end
	end

	--听雷补凤鸣
	if bufftime("鳳鳴") < casttime("夕照雷峰") then
		CastX("聽雷")
	end

	--夕照
	CastX("夕照雷峰")

	--备胎
	CastX("聽雷")

	--[[风来吴山群攻, 先去掉
	_, v["10尺内敌人数量"] = npc("关系:敌对", "距离<9", "可选中")
	if v["10尺内敌人数量"] >= 3 then
		CastX("風來吳山")
	end
	--]]
end

f["回剑气"] = function()
	--刚放过莺鸣柳
	if gettimer("鶯鳴柳") < 0.5 or gettimer("释放莺鸣柳") < 2 then
		return
	end

	--在剑阵内
	if gettimer("飛來聞蹤") < 0.5 or gettimer("释放飞来闻踪") < 1.5 or v["剑阵"] ~= 0 or buff("飛來") then
		return
	end

	--有风车
	if gettimer("风来吴山读条结束") < 0.5 or gettimer("释放风来吴山") < 1 or v["有风来吴山"] then
		return
	end

	--刚放过云栖松
	if gettimer("雲棲鬆") < 0.5 or buff("青松") then
		return
	end

	--飞来闻踪
	if v["目标静止"] and dis() < 6 and v["剑气"] < 60 then
		if CastX("飛來聞蹤") then
			return
		end
	end

	--风来吴山
	if v["目标静止"] and v["目标血量较多"] and dis() < 6 then
		if v["剑气"] < 60 or (v["闻踪时间"] > 8 and v["剑气"] < 80) then
			if v["岱宗层数"] >= 3 and v["岱宗时间"] > 5 then
				if v["莺鸣充能时间"] < 100 and cdtime("風來吳山") <= 0 then
					CastX("鶯鳴柳")
				end
				if CastX("風來吳山") then
					return
				end
			end
		end
	end

	--切轻剑回剑气
	if v["九溪CD"] < 1 and v["啸日充能时间"] < 1 and v["剑气"] < 60 then
		f["啸日"]("切轻剑回剑气")
	end

	--莺鸣柳
	if cdleft(16) <= 0 and v["飞来CD"] > 0 and v["九溪CD"] > 0 and v["剑气"] < 60 and dis() < 8 then
		if CastX("鶯鳴柳") then
			return
		end
	end

	--云栖松
	if dis() < 8 and v["剑气"] < 60 then
		CastX("雲棲鬆")
	end
end

f["啸日"] = function(szReason)
	if CastX("嘯日") then
		print("------------------------------ "..szReason)	--分隔线 切换原因
		exit()
	end
end

-------------------------------------------------------------------------------

--记录信息
function PrintInfo(s)
	local t = {}
	if s then t[#t+1] = s end
	t[#t+1] = "剑气:"..v["剑气"]
	t[#t+1] = "距离:".. format("%0.1f", dis())

	t[#t+1] = "凤鸣:"..v["凤鸣层数"]..", "..v["凤鸣时间"]
	t[#t+1] = "雾锁:"..v["雾锁时间"]
	t[#t+1] = "岱宗:"..v["岱宗层数"]..", "..v["岱宗时间"]
	t[#t+1] = "碧归:"..v["碧归层数"]..", "..v["碧归时间"]
	t[#t+1] = "惊雷:"..v["目标惊雷时间"]
	t[#t+1] = "闻踪:"..v["闻踪时间"]

	t[#t+1] = "九溪CD:"..v["九溪CD"]
	t[#t+1] = "啸日CD:"..v["啸日充能次数"]..", "..v["啸日充能时间"]
	t[#t+1] = "云飞CD:"..v["云飞CD"]
	t[#t+1] = "风车CD:"..v["风车CD"]
	t[#t+1] = "莺鸣CD:"..v["莺鸣充能次数"]..", "..v["莺鸣充能时间"]
	t[#t+1] = "云栖CD:"..v["云栖CD"]
	t[#t+1] = "飞来CD:"..v["飞来CD"]

	print(table.concat(t, ", "))
end

--使用技能并记录信息
function CastX(szSkill, bSelf)
	if cast(szSkill, bSelf) then
		settimer(szSkill)
		if v["记录信息"] then PrintInfo() end
		return true
	end
	return false
end

function aCastX(szSkill, nAngle)
	if acast(szSkill, nAngle) then
		settimer(szSkill)
		if v["记录信息"] then PrintInfo() end
		return true
	end
	return false
end

-------------------------------------------------------------------------------

--切换内功
function OnMountKungFu(KungFu, Level)
	deltimer("嘯日")
end

--释放技能
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		if SkillID == 1593 then		--云飞
			settimer("释放云飞玉皇")
		end
		if SkillID == 1663 then		--莺鸣柳
			settimer("释放莺鸣柳")
		end
		if SkillID == 25070 then	--飞来闻踪
			settimer("释放飞来闻踪")
		end
		if SkillID == 18333 then	--风来吴山
			settimer("释放风来吴山")
		end
	end
end

--记录战斗状态改变
function OnFight(bFight)
	if bFight then
		print("--------------------进入战斗")
	else
		print("--------------------离开战斗")
	end
end
