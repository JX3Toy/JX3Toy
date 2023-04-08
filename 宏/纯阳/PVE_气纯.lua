output("奇穴: [白虹][心固][化三清][归元][同尘][跬步][万物][抱阳][浮生][破势][重光][固本]")

--变量表
local v = {}
v["等待四象释放"] = false
v["气点"] = qidian()

function Main(g_player)
	--等待四象释放
	if casting("四象轮回") and castleft() < 0.13 then
		v["等待四象释放"] = true
		settimer("四象轮回读条结束")
	end
	if v["等待四象释放"] and gettimer("四象轮回读条结束") < 0.3 then
		return
	end

	if qixue("破势") then
		cast("镇山河")
	end

	--自己周围自己的破苍穹
	local pcqdist, pcqtime = qc("气场破苍穹", id(), id())

	--目标5尺自己的六合
	v["目标5尺自己的六合"] = tnpc("关系:自己", "模板ID:58295", "距离<5")

	--紫气东来
	if rela("敌对") and dis() < 19 and tstate("站立|被击倒|眩晕|定身|锁足|爬起") then
		if pcqdist < -5 and pcqtime > 10 and qjcount() >= 5 and bufftime("气剑") > 10 and v["目标5尺自己的六合"] ~= 0 and gettimer("释放六合独尊") < 2 then
			cast("紫气东来")
		end
	end
	
	--对自己破苍穹
	if rela("敌对") and dis() < 20 then
		if pcqdist > -1 then		--没有破苍穹或者快出圈了, 距离是自己到气场边缘的距离，在圈外是正数，在圈内是负数
			cast("破苍穹", true)
		end
	end

	--两仪化形
	if v["气点"] >= 9 then
		cast("两仪化形")
	end

	--万世不竭
	if qjcount() < 5 then
		cast("万世不竭")
	end

	--六合独尊
	if rela("敌对") and tstate("站立|被击倒|眩晕|定身|锁足|爬起") then
		cast("六合独尊")
	end

	--化三清
	if fight() and mana() < 0.4 then
		cast("化三清", true)
	end

	--四象轮回
	if v["气点"] <= 7 then
		cast("四象轮回")
		cast("太极无极")
	end

	if nobuff("坐忘无我") then
		cast("坐忘无我")
	end
end


--气点更新
OnQidianUpdate = function()
	v["气点"] = qidian()
end


--释放技能
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		--四象
		if SkillID == 367 then
			v["等待四象释放"] = false
		end
		--六合
		if SkillID == 18668 then
			settimer("释放六合独尊")
		end
	end
end
