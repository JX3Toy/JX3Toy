output("----------镇派----------")
output("2 3 2")
output("0 2 2 3")
output("2 1 0 2")
output("0 2 3")
output("0 3 0")
output("1 1")
output("0 3 2")
output("2 0 0 0")


--宏选项
addopt("副本防开怪", true)

--变量表
local v = {}

--主循环
function Main(g_player)

	--防止打断鬼斧
	if gettimer("鬼斧神工") < 0.5 or lasttime("鬼斧神工") < 2 or casting("鬼斧神工") then
		return
	else
		nomove(false)		--允许移动
	end

	--读条结束, 等神机值同步设置为真
	if casting("千机变|蚀肌弹") and castleft() < 0.13 then
		v["等待神机值同步"] = true
		settimer("读条结束")
	end

	--防止重复放千机变
	if casting("千机变") and castleft() < 0.13 then
		settimer("千机变读条结束")
	end
	
	--减伤
	if fight() and life() < 0.5 then
		cast("惊鸿游龙")
	end

	--等待神机值同步
	if v["等待神机值同步"] and gettimer("读条结束") < 0.5 then
		--print("等待神机值同步")
		return
	end


	--放弩
	v["需要放千机变"] = false
	if rela("敌对") and dis() < 20 then
		if gettimer("千机变读条结束") > 2 and nopuppet() or xxdis(pupid(), tid()) > 25 then		--没有弩或者弩和目标超过25尺
			v["需要放千机变"] = true
			cast("千机变", true)
		end

		if puppet("机关千机变底座") then
			_, v["底座10尺内敌人数量"] = xnpc(pupid(), "关系:敌对", "距离<10", "可选中")
			if v["底座10尺内敌人数量"] >= 3 then
				cast("毒刹形态")
			end
			cast("重弩形态")
			--cast("连弩形态")
		end
	end

	--放蛋
	if rela("敌对") and tstate("站立|被击倒|眩晕|定身|锁足|爬起") and energy() >= 70 and cdleft(16) <= 1 then
		cast("暗藏杀机")
	end

	--副本防开怪
	if getopt("副本防开怪") and dungeon() and nofight() then return end

	---------------------------------------------开始输出

	--弩攻击
	if puppet("机关千机变连弩|机关千机变重弩") and puptid() ~= tid() and xxdis(pupid(), tid()) < 25 and xxvisible(pupid(), tid()) then
		cast("攻击")
	end

	--心无绑定鬼斧
	if lasttime("鬼斧神工") < 5 then
		cast("心无旁骛")
	end

	_, v["暗藏杀机数量"] = tnpc("关系:自己", "名字:机关暗藏杀机", "距离<6")

	--鬼斧
	if (puppet("机关千机变连弩") and lasttime("连弩形态") < 80) or (puppet("机关千机变重弩") and lasttime("重弩形态") < 80) then	--连弩或重弩，弩的剩余时间大于40秒
		if xdis(pupid()) < 4 and tlifevalue() > lifemax() * 10 and v["暗藏杀机数量"] >= 2 then		--自己和弩的距离小于4尺，目标当前生命值大于自己最大生命值10倍(目标还没快挂)
			if cast("鬼斧神工") then
				stopmove()			--停止所有移动
				nomove(true)		--禁止移动
				settimer("鬼斧神工")
				exit()				--中断脚本执行
			end
		end
	end
	
	--爆蛋
	if v["暗藏杀机数量"] >= 3 then
		cast("图穷匕见")
	end

	--化血镖
	if tnobuff("化血镖", id()) then
		cast("化血镖")
	end


	--天绝地灭
	v["放天绝地灭"] = false

	--[[对自己天绝
	_, v["周围6尺敌人数量"] =  npc("关系:敌对", "距离<6", "可选中")
	if v["周围6尺敌人数量"] >= 3 then
		v["放天绝地灭"] = true
		cast("天绝地灭", true)
	end
	--]]

	--对目标天绝
	if rela("敌对") and tstate("站立|被击倒|眩晕|定身|锁足|爬起") then
		v["放天绝地灭"] = true
		cast("天绝地灭")
	end

	--鲲鹏铁爪, 回10神机
	if energy() < 40 then
		cast("鲲鹏铁爪")
	end

	--天女散花
	_, v["目标9尺敌人数量"] = tnpc("关系:敌对", "距离<9", "可选中")
	if v["目标9尺敌人数量"] >= 3 then
		cast("天女散花")
	end

	--有奥妙，先打高消耗
	if bufftime("奥妙") > casttime("蚀肌弹") then		--奥妙时间大于蚀肌弹读条时间
		cast("蚀肌弹")
	end

	cast("孔雀翎")


	--[[暴雨回神机
	if nobuff("心无旁骛") then
		if nobuff("3286") or nobuff("3283") then
			cast("暴雨梨花针")
		end
	end
	--]]

	cast("暴雨梨花针")

	if energy() >= 50 and not v["放千机变"]  then		--防止蚀肌弹消耗神机，放不出天绝和弩
		cast("蚀肌弹")
	end
end


--自己状态更新
function OnStateUpdate(nCurrentLife, nCurrentMana, nCurrentRage, nCurrentEnergy, nCurrentSunEnergy, nCurrentMoonEnergy, n_UnKnow)
	v["等待神机值同步"] = false
end


local tSkill = {
[17] = "打坐",
[3121] = "罡风镖法",
[3298] = "奥妙无穷",
[3299] = "消耗奥妙",
[3169] = "回肠荡气",
}

function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if tSkill[SkillID] then return end

	--[[
	if CasterID == id() then
		if TargetType == 2 then		--类型2 是指定位置, 类型 3 4 是指定的NPC和玩家
			print("OnCast->["..xname(CasterID).."] 释放:"..SkillName..", 技能ID:"..SkillID..", 技能等级:"..SkillLevel..", 目标位置:"..TargetID.."|"..PosY.."|"..PosZ..", 开始帧:"..StartFrame..", 当前帧:"..FrameCount)
		else
			print("OnCast->["..xname(CasterID).."] 释放:"..SkillName..", 技能ID:"..SkillID..", 技能等级:"..SkillLevel..", 目标ID:"..TargetID..", 开始帧:"..StartFrame..", 当前帧:"..FrameCount)
		end
	end
	--]]
end


--[[更新buff
function OnBuff(CharacterID, BuffName, BuffID, BuffLevel, StackNum, SkillSrcID, StartFrame, EndFrame, FrameCount)
	if CharacterID == id() then
		if StackNum > 0 then
			print("添加buff: "..BuffName, "ID: "..BuffID, "等级: "..BuffLevel, "层数: "..StackNum, "剩余时间:"..((EndFrame - FrameCount) / 16))
		else
			print("移除buff: "..BuffName)
		end
	end
end
--]]

--机变类型: 机关千机变底座, 机关千机变连弩, 机关千机变重弩, 机关千机变火器
