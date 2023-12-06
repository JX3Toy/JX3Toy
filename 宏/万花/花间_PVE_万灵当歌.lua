--[[ 奇穴: [弹指][青冠][倚天][踏歌][青歌][雪中行][清流][钟灵][流离][雪弃][焚玉][涓流]
秘籍:
星楼  2调息 1消耗 1减伤
阳明  2伤害 2会心
商阳  1持续 1距离 2消耗
钟林  3读条 1持续
芙蓉  1会心 2伤害 1效果
快雪  3伤害 1消耗
兰摧  2调息 1读条 1持续

0段和1段加速下测试，更高加速自己试有没有问题
--]]

--关闭自动面向
setglobal("自动面向", false)

--宏选项
addopt("副本防开怪", false)
addopt("自动吃鼎", false)

--变量表
local v = {}
v["记录信息"] = true
v["钟林目标"] = 0
v["兰摧目标"] = 0
v["商阳目标"] = 0
v["吞海目标"] = 0

--函数表
local f = {}

--主循环
function Main(g_player)
	--按下自定义快捷键1挂扶摇, 注意是快捷键设定里面插件的快捷键1指定的按键，不是键盘上的1
	if keydown(1) then
		cast("扶摇直上")
	end

	--减伤
	if fight() and life() < 0.6 then
		cast("春泥护花", true)
	end

	--等待阳明指读条
	if casting("阳明指") and castleft() < 0.13 then
		settimer("阳明指读条结束")
	end
	if gettimer("阳明指读条结束") < 0.3 then
		return
	end

	--钟林读条结束记录目标
	if casting("钟林毓秀") and castleft() < 0.13 then
		v["钟林目标"] = casttarget()
		settimer("钟林读条结束")
	end

	--兰摧读条结束记录目标
	if casting("兰摧玉折") and castleft() < 0.13 then
		v["兰摧目标"] = casttarget()
		settimer("兰摧读条结束")
	end

	--初始化变量
	v["目标钟林时间"] = tbufftime("钟林毓秀", id())
	v["目标商阳时间"] = tbufftime("商阳指", id())
	v["目标兰摧时间"] = tbufftime("兰摧玉折", id())
	v["目标快雪时间"] = tbufftime("快雪时晴", id())
	v["目标有钟林"] = f["目标有钟林"]()
	v["目标有商阳"] = f["目标有商阳"]()
	v["目标有兰摧"] = f["目标有兰摧"]()
	v["目标有快雪"] = f["目标有快雪"]()
	v["目标dot数量"] = f["目标dot数量"]()
	v["布散时间"] = bufftime("布散")
	v["畅和时间"] = bufftime("布散畅和")

	v["有布散"] = buff("布散")
	v["踏歌标记"] = buff("26416")

	v["芙蓉CD"] = scdtime("芙蓉并蒂")
	v["玉石CD"] = scdtime("玉石俱焚")
	v["水月CD"] = scdtime("水月无间")
	v["乱撒CD"] = scdtime("乱洒青荷")
	v["GCD间隔"] = cdinterval(16)

	--副本防开怪
	if getopt("副本防开怪") and dungeon() and nofight() then return end

	--乱撒, 起手打一次后面不打会卡芙蓉
	if rela("敌对") and dis() < 20 and face() < 80 and v["玉石CD"] > 11 and cdleft(16) >= 0.5 and cdleft(16) <= 1 and not v["踏歌标记"] then
		CastX("乱洒青荷")
	end

	--水月
	if rela("敌对") and dis() < 20 and face() < 80 and gettimer("吞海") < 0.5 then	--吞海后
		cast("水月无间")
	end

	--芙蓉
	if v["目标dot数量"] >= 4 and v["玉石CD"] <= v["GCD间隔"] and v["踏歌标记"] then
		CastX("芙蓉并蒂")
	end

	--玉石
	if v["布散时间"] < 0 and v["畅和时间"] < 0 and v["目标dot数量"] >= 3 and v["乱撒CD"] < 0.1 and v["芙蓉CD"] < 5.5 and not v["踏歌标记"] then	--起手打布散
		CastX("玉石俱焚")
	end
	if v["目标dot数量"] >= 4 then	--爆4dot
		CastX("玉石俱焚")
	end

	--碧水
	if fight() and mana() < 0.5 then
		CastX("碧水滔天", true)
	end
	
	--兰摧
	if buff("乱洒青荷") and not v["乱撒后放过阳明指"] then

	else
		if not v["目标有兰摧"] then
			CastX("兰摧玉折")
		end
	end
	
	--快雪
	if not v["目标有快雪"] or buffsn("溅玉") < 3 then
		CastX("快雪时晴")
	end

	--阳明指
	if buff("乱洒青荷") and not v["乱撒后放过阳明指"] then	--乱撒后阳明指上兰摧钟林
		CastX("阳明指")
	end

	if not v["玉石后放过阳明指"] and v["玉石CD"] > v["GCD间隔"] * 2 then	--每小节打1次
		CastX("阳明指")
	end

	--钟林
	if not v["目标有钟林"] then
		CastX("钟林毓秀")
	end

	--商阳
	if not v["目标有商阳"] then
		CastX("商阳指")
	end

	--吃鼎
	if getopt("自动吃鼎") and nobuff("蛊时") and cdleft(16) > 0.5 then
		if life() < 0.7 or mana() < 0.8 then
			interact("仙王蛊鼎")
		end
	end

	--[[测试
	if casting("快雪时晴") and castleft() < 0.13 then
		settimer("快雪读条结束")
	end
	if rela("敌对") and dis() < 20 and cdleft(16) <= 0 and castleft() <= 0 and gettimer("快雪时晴") > 0.3 and gettimer("钟林毓秀") > 0.3 and gettimer("兰摧玉折") > 0.3 and gettimer("快雪读条结束") > 0.3 then
		PrintInfo("---------- 没打技能")
	end
	--]]
end

-------------------------------------------------------------------------------

f["目标有钟林"] = function()
	if v["吞海目标"] ~= 0 and v["吞海目标"] == tid() and gettimer("吞海1") < 0.5 then return false end		--被吞了没有
	if v["钟林目标"] ~= 0 and v["钟林目标"] == tid() then
		if gettimer("释放钟林毓秀") < 0.5 or gettimer("钟林读条结束") < 0.5 then return true end	--刚放过有
	end
	return v["目标钟林时间"] > 0
end

f["目标有商阳"] = function()
	if v["吞海目标"] ~= 0 and v["吞海目标"] == tid() and gettimer("吞海2") < 0.5 then return false end
	if v["商阳目标"] ~= 0 and v["商阳目标"] == tid() and gettimer("释放商阳指") < 0.5 then return true end
	return v["目标商阳时间"] > 0
end

f["目标有兰摧"] = function()
	if v["吞海目标"] ~= 0 and v["吞海目标"] == tid() and gettimer("吞海3") < 0.5 then return false end
	if v["兰摧目标"] ~= 0 and v["兰摧目标"] == tid() then
		if gettimer("释放兰摧玉折") < 0.5 or gettimer("兰摧读条结束") < 0.5 then return true end
	end
	return v["目标兰摧时间"] > 0
end

f["目标有快雪"] = function()
	if v["吞海目标"] ~= 0 and v["吞海目标"] == tid() and gettimer("吞海0") < 0.5 then return false end
	return v["目标快雪时间"] > 0
end

f["目标dot数量"] = function()
	local nDot = 0
	if v["目标有钟林"] then nDot = nDot + 1 end
	if v["目标有商阳"] then nDot = nDot + 1 end
	if v["目标有兰摧"] then nDot = nDot + 1 end
	if v["目标有快雪"] then nDot = nDot + 1 end
	return nDot
end

-------------------------------------------------------------------------------

--记录信息到日志窗口
function PrintInfo(s)
	local t = {}
	if s then t[#t+1] = s end
	t[#t+1] = "兰摧:"..v["目标兰摧时间"]
	t[#t+1] = "快雪:"..v["目标快雪时间"]
	t[#t+1] = "钟林:"..v["目标钟林时间"]
	t[#t+1] = "商阳:"..v["目标商阳时间"]
	t[#t+1] = "布散:"..v["布散时间"]
	t[#t+1] = "畅和:"..v["畅和时间"]
	t[#t+1] = "玉石CD:"..v["玉石CD"]
	t[#t+1] = "芙蓉CD:"..v["芙蓉CD"]
	t[#t+1] = "水月CD:"..v["水月CD"]
	t[#t+1] = "乱撒CD:"..v["乱撒CD"]

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

-------------------------------------------------------------------------------

--释放技能
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then	--如果释放技能的是自己

		if SkillID == 179 then		--阳明指
			deltimer("阳明指读条结束")
			v["乱撒后放过阳明指"] = true
			v["玉石后放过阳明指"] = true
			return
		end

		if SkillID == 180 then		--商阳指
			v["商阳目标"] = TargetID
			settimer("释放商阳指")
			return
		end

		if SkillID == 189 then		--钟林毓秀
			v["钟林目标"] = TargetID
			settimer("释放钟林毓秀")
			return
		end
		
		if SkillID == 190 then		--兰摧玉折
			v["兰摧目标"] = TargetID
			settimer("释放兰摧玉折")
			return
		end

		if SkillID == 601 then		--吞海, 阳明指 触发 踏歌 吞噬dot, 取余后 等级 1 钟林, 2 商阳, 3 兰摧, 0 快雪
			local level = SkillLevel % 4
			settimer("吞海"..level)		--设置对应技能计时器
			settimer("吞海")
			v["吞海目标"] = TargetID

			print("----------", SkillName, SkillID, SkillLevel)

		end

		if SkillID == 2645 then		--乱撒
			v["乱撒后放过阳明指"] = false
			return
		end

		if SkillID == 13847 then	--乱撒 阳明指 附带钟林
			v["钟林目标"] = TargetID
			settimer("释放钟林毓秀")
			return
		end

		if SkillID == 13848 then	--乱撒 阳明指 附带兰摧
			v["兰摧目标"] = TargetID
			settimer("释放兰摧玉折")
			return
		end

		if SkillID == 182 then		--玉石俱焚
			v["玉石后放过阳明指"] = false
			print("------------------------------ 分隔线")
		end
	end
end
