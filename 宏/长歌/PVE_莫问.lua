output("奇穴: [号钟][飞帆][弦风][流照][豪情][师襄][知止][刻梦][书离][云汉][参连][无尽藏]")

--变量表
local v = {}
v["等待宫释放"] = false
v["羽次数"] = 0

--主循环
function Main(g_player)

	--等待宫释放
	if casting("宫|变宫") and castleft() < 0.13 then
		settimer("宫读条结束")
		v["等待宫释放"] = true
	end
	if v["等待宫释放"] and gettimer("宫读条结束") < 0.3 then
		return
	end

	--没进战, 切高山流水
	if nofight() and nobuff("高山流水") then
		cast("高山流水")
		return
	end

	--打断
	if tbuffstate("可打断") then
		cast("清音长啸")
	end

	v["曲风层数"] = buffsn("曲风")
	v["商时间"] = tbufftime("商", id())
	v["角时间"] = tbufftime("角", id())

	if rela("敌对") then
		cast("疏影横斜")
	end

	if buff("高山流水") then
		if gettimer("释放变宫") < 2 then
			cast("阳春白雪")
			return
		end

		if v["商时间"] < 0.2 then
			cast("商")
		end

		if v["角时间"] < 0.2 then
			cast("角")
		end
		
		cast("变宫")
	end

	if buff("阳春白雪") then

		v["切高山"] = false

		if v["羽次数"] >= 2 then	--正常循环
			v["切高山"] = true
		end
		
		if v["商时间"] < 3.5 or v["角时间"] < 3.5 then	--保底判断
			v["切高山"] = true
		end

		if v["切高山"] then
			cast("高山流水")
			return
		end

		if v["曲风层数"] == 5 then
			cast("羽")
		end

		cast("徵")
	end
end


--释放技能
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		--宫
		if SkillID == 14064 then
			v["等待宫释放"] = false
		end

		--变宫
		if SkillID == 14298 then
			v["等待宫释放"] = false
			settimer("释放变宫")
		end

		--高山流水
		if SkillID == 14069 then
			v["羽次数"] = 0
		end

		--羽
		if SkillID == 14068 then
			v["羽次数"] = v["羽次数"] + 1
		end
	end
end
