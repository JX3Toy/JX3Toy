output("----------镇派----------")
output("2 3 2")
output("3 2 2 0")
output("2 0 3 1")
output("0 2 3 0")
output("1 2 3 1")
output("0 1")
output("0 3 1")


--宏选项
addopt("副本防开怪", true)
addopt("蟾躁", false)


function Main(g_player)

	--没进战，先招个蝎子
	if nofight() and nopet("圣蝎") then
		cast("圣蝎引")
	end
	
	if nopet() then
		cast("灵蛇引")
		cast("圣蝎引")
		if cdtime("灵蛇引") > 3 and cdtime("圣蝎引") > 3 then
			cast("玉蟾引")
		end
	end

	--减伤
	if fight() then
		if life() < 0.2 then
			cast("化蝶")
		end
		if life() < 0.6 and pet() then
			cast("玄水蛊")
		end
	end

	--目标不是敌人, 结束
	if not rela("敌对") then return end

	--副本防开怪
	if getopt("副本防开怪") and dungeon() and nofight() then return end

	
	--狂暴给蛇，插入到献祭中间
	if pet("灵蛇") and xxdis(petid(), tid()) < 4 and lasttime("蛊虫献祭") > 2 and lasttime("蛊虫献祭") < 10 then
		cast("蛊虫狂暴")
	end


	--献祭, 宠物攻击
	if pet() then
		if cast("蛊虫献祭") then
			settimer("蛊虫献祭")
		end

		if gettimer("蛊虫献祭") > 0.5 then
			if pettid() ~= tid() then		--宠物的目标不是自己的目标
				cast("攻击")
			end
			cast("幻击")

			if getopt("蟾躁") and xxdis(petid(), tid()) < 5.5 then
				cast("蟾躁")
			end
		end
	end

	--目标有不是自己的夺命蛊, 就用其它两种
	if tbufftime("夺命蛊") > 16 and tnobuff("夺命蛊", id()) then
		cast("枯残蛊")
		cast("迷心蛊")
	end
	cast("夺命蛊")

	

	cast("百足")
	cast("蟾啸")
	if tbufftime("蛇影", id()) < 4 then
		cast("蛇影")
	end
	cast("蝎心")
	cast("千丝")
end


--[[释放技能
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		if TargetType == 2 then		--类型2 是指定位置, 类型 3 4 是指定的NPC和玩家
			print("OnCast->["..xname(CasterID).."] 释放:"..SkillName..", 技能ID:"..SkillID..", 技能等级:"..SkillLevel..", 目标位置:"..TargetID.."|"..PosY.."|"..PosZ..", 开始帧:"..StartFrame..", 当前帧:"..FrameCount)
		else
			print("OnCast->["..xname(CasterID).."] 释放:"..SkillName..", 技能ID:"..SkillID..", 技能等级:"..SkillLevel..", 目标ID:"..TargetID..", 开始帧:"..StartFrame..", 当前帧:"..FrameCount)
		end
	end
end
--]]


--宠物名: 圣蝎, 风蜈, 天蛛, 灵蛇, 玉蟾, 碧蝶
