output("----------镇派----------")
output("2 3 2")
output("3 2 2 0")
output("2 1 2 0")
output("1 1 2 0")
output("0 2 3 0")
output("1")
output("0 3 2")
output("0 0 0 2")


--宏选项
addopt("副本防开怪", true)
addopt("隐追", true)


--变量表
local v = {}
v["等待夺魄箭释放"] = false
v["等待穿心弩释放"] = false
v["夺魄箭释放目标"] = 0
v["妙手连环"] = "50354"			--妙手连环buffid
v["打过夺魄箭"] = "50349"		--妙手连环没打过夺魄buffid
v["打过裂石弩"] = "50351"		--妙手连环没打过裂石弩buffid



function Main(g_player)
	--读条即将结束，设置等待标志为真
	if casting("夺魄箭") and castleft() < 0.13 then
		v["等待夺魄箭释放"] = true
		settimer("夺魄箭读条结束")
	end
	if casting("穿心弩") and castleft() < 0.13 then
		v["等待穿心弩释放"] = true
		settimer("穿心弩读条结束")
	end

	--等待夺魄箭释放完成
	if v["等待夺魄箭释放"] and gettimer("夺魄箭读条结束") < 0.35 then
		return
	end

	--等待夺魄箭释放完成
	if v["等待穿心弩释放"] and gettimer("穿心弩读条结束") < 0.35 then
		return
	end

	
	----------------------------------------开始输出

	if getopt("副本防开怪") and dungeon() and nofight() then return end


	--打断
	if tbuffstate("可打断") then
		cast("梅花针")
	end

	--驱散
	if rela("敌对") and tbufftype("阴性气劲|阳性气劲|毒性气劲|混元性气劲") > 0 then
		cast("卸元箭")
	end


	v["神机值"] = energy()

	--爆发
	if rela("敌对") and dis() < 24 then
		if cdleft(16) < 0.5 then		--GCD快好了
			cast("猛虎下山")
		end

		if bufftime(v["妙手连环"]) > 6 and tlifevalue() > lifemax() * 10 and cdleft(16) > 0.5 then	--有妙手, 目标当前气血值大于自己最大气血值10倍, GCD大于0.5(神机值同步)
			cast("心无旁骛")
		end
	end

	if tnobuff("化血镖", id()) then
		cast("化血镖")
	end

	--追命箭
	if buff("追命无声") and cdtime("追命箭") < 0.5 then
		if rela("敌对") and dis() < 23 and cdtime("追命箭") <= 0 and v["神机值"] >= 45 and bufftime("追命无声") > 5 and tlifevalue() > lifemax() * 2 then
			cast("浮光掠影")
		end
		cast("追命箭")
		return
	end

	if buff("浮光掠影") and cdtime("追命箭") < 1 then
		return
	end

	if buff(v["妙手连环"]) then
		cast("逐星箭")
	end

	if buff(v["妙手连环"]) and nobuff(v["打过裂石弩"]) then		--有连环, 没打过裂石弩
		if buff("奥妙") or v["神机值"] >= 80 or bufftime("心无旁骛") > 1 then				--有奥妙或者神机值足够
			cast("裂石弩")
		end
	end

	if bufftime(v["妙手连环"]) > casttime("夺魄箭") and nobuff(v["打过夺魄箭"]) then		--有连环，没打过夺魄
		cast("夺魄箭")
	end

	if bufftime(v["妙手连环"]) > casttime("穿心弩") then
		cast("穿心弩")
	end

	if bufftime(v["妙手连环"]) > 1 then
		cast("连环弩")
	end

	
	--if buffsn("无声") >= 2 then
		cast("孔雀翎")
	--end

	--
	if nobuff("追命无声") then
		cast("夺魄箭")
	end
	--]]

	--[[暴雨梨花针
	v["千疮百孔"] = false
	if tbufftime("千疮百孔", true) > 2 then
		v["千疮百孔"] = true
	end
	if tbuff("50335", true) and tid() == v["夺魄箭释放目标"] and gettimer("夺魄箭释放") < 0.5 then		--有[黑云翻墨]标记，刚对目标释放了夺魄箭
		v["千疮百孔"] = true
	end

	if v["千疮百孔"] then
		cast("暴雨梨花针")
	end
	--]]

	if energy() >= 64 then 
		cast("夺魄箭")
	end

end


--释放技能
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		if SkillName == "夺魄箭" then
			v["等待夺魄箭释放"] = false		--释放完成, 等待结束
			v["夺魄箭释放目标"] = TargetID	--记录目标
			settimer("夺魄箭释放")
		end

		if SkillName == "穿心弩" then
			v["等待穿心弩释放"] = false
		end
	
		--[[
		if SkillID == 64083 then
			if TargetType == 2 then		--类型2 是指定位置, 类型 3 4 是指定的NPC和玩家
				print("OnCast->["..xname(CasterID).."] 释放:"..SkillName..", 技能ID:"..SkillID..", 技能等级:"..SkillLevel..", 目标位置:"..TargetID.."|"..PosY.."|"..PosZ..", 开始帧:"..StartFrame..", 当前帧:"..FrameCount)
			else
				print("OnCast->["..xname(CasterID).."] 释放:"..SkillName..", 技能ID:"..SkillID..", 技能等级:"..SkillLevel..", 目标ID:"..TargetID..", 开始帧:"..StartFrame..", 当前帧:"..FrameCount)
			end
		end
		--]]
	end
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
