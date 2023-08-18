--[[ 奇穴: [弹指][青冠][倚天][踏歌][青歌][雪中行][清流][钟灵][流离][雪弃][焚玉][涓流]
秘籍:
春泥  3调息 1减伤
星楼  2调息 1减伤
阳明  2读条 2伤害
商阳  1持续 1距离 2减消耗
钟林  3读条 1持续
芙蓉  1会心 2伤害 1效果
快雪  3伤害 1消耗
兰摧  2调息 1读条 1持续
--]]

--关闭自动面向
setglobal("自动面向", false)

--变量表
local v = {}
v["钟林目标"] = 0
v["兰摧目标"] = 0
v["商阳目标"] = 0
v["吞海目标"] = 0

--函数表
local f = {}

--主循环
function Main()
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
	v["芙蓉CD"] = scdtime("芙蓉并蒂")
	v["玉石CD"] = scdtime("玉石俱焚")
	v["有乱撒"] = buff("乱洒青荷")
	v["有布散"] = buff("布散")
	v["踏歌标记"] = buff("26416")
	v["补全buff需要时间"] = f["补全buff需要时间"]()


	--乱撒
	if rela("敌对") and dis() < 20 and face() < 60 and v["玉石CD"] > 10 and cdleft(16) >= 0.5 and cdleft(16) <= 1 and not v["踏歌标记"] then
		cast("乱洒青荷")
	end

	--芙蓉
	--if v["目标dot数量"] >= 4 and v["玉石CD"] < cdinterval(16) and v["玉石CD"] > 0 then
	if v["目标dot数量"] >= 4 and v["玉石CD"] < cdinterval(16) then
		cast("芙蓉并蒂")
	end

	--玉石
	if not v["有布散"] and v["目标dot数量"] >= 3 and scdtime("乱洒青荷") < 0.1 and not v["踏歌标记"] then
		cast("玉石俱焚")
	end
	if v["目标dot数量"] >= 4 then	
		cast("玉石俱焚")
	end
	
	--兰摧
	if v["有乱撒"] and not v["乱撒后放过阳明指"] then

	else
		if not v["目标有兰摧"] then
			cast("兰摧玉折")
		end
	end
	
	--快雪
	if not v["目标有快雪"] or buffsn("溅玉") < 3 then
		cast("快雪时晴")
	end

	--阳明指
	if v["有乱撒"] and not v["乱撒后放过阳明指"] then
		cast("阳明指")
	end
	if v["玉石CD"] - v["补全buff需要时间"] > 1 then
		cast("阳明指")
	end

	--钟林
	if not v["目标有钟林"] then
		cast("钟林毓秀")
	end

	--商阳
	if not v["目标有商阳"] then
		cast("商阳指")
	end

	--碧水
	if fight() and mana() < 0.5 then
		cast("碧水滔天", true)
	end
end


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

f["补全buff需要时间"] = function()
	local nTime = 0
	if not v["目标有钟林"] then
		nTime = nTime + cdinterval(16)
	end
	if not v["目标有商阳"] then
		nTime = nTime + cdinterval(16)
	end
	if v["芙蓉CD"] < v["玉石CD"] then
		nTime = nTime + cdinterval(16)
	end
	return nTime
end

--释放技能
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	--如果释放技能的是自己
	if CasterID == id() then
		--阳明指
		if SkillID == 179 then
			deltimer("阳明指读条结束")
			v["乱撒后放过阳明指"] = true
			return
		end

		--商阳指
		if SkillID == 180 then
			v["商阳目标"] = TargetID
			settimer("释放商阳指")
			return
		end

		--钟林毓秀
		if SkillID == 189 then
			v["钟林目标"] = TargetID
			settimer("释放钟林毓秀")
			return
		end

		--兰摧玉折
		if SkillID == 190 then
			v["兰摧目标"] = TargetID
			settimer("释放兰摧玉折")
			return
		end

		--吞海, 阳明指 触发 踏歌 吞噬dot, 取余后 等级 1 钟林, 2 商阳, 3 兰摧, 0 快雪
		if SkillID == 601 then
			local level = SkillLevel % 4
			settimer("吞海"..level)		--设置对应技能计时器
			v["吞海目标"] = TargetID

			--水月
			if rela("敌对") and dis() < 20 and face() < 60 then
				cast("水月无间")
			end
		end

		--乱撒
		if SkillID == 2645 then
			v["乱撒后放过阳明指"] = false
		end

		--乱撒 阳明指 附带钟林
		if SkillID == 13847 then
			v["钟林目标"] = TargetID
			settimer("释放钟林毓秀")
			return
		end

		--乱撒 阳明指 附带兰摧
		if SkillID == 13848 then
			v["兰摧目标"] = TargetID
			settimer("释放兰摧玉折")
			return
		end
	end
end
