output("----------镇派----------")
output("2 2 3")
output("0 2 2 3")
output("1 0 2 2")
output("2 0 1 2")
output("1 2 0 0")
output("1 1")
output("0 2 3")
output("0 0 0 2")


--宏选项
addopt("副本防开怪", true)

--变量表
local v = {}
v["急曲目标"] = 0
v["月华前目标"] = 0


function Main(g_player)

	--月华读条
	if casting("月华倾泻") then return end

	--恢复月华前目标
	if v["月华前目标"] ~= 0 then
		settar(v["月华前目标"])
		v["月华前目标"] = 0
	end

	if nobuff("剑舞") then
		cast("名动四方")
	end

	if nofight() and nobuff("袖气") then
		cast("婆罗门", true)
	end

	v["急曲层数"] = tbuffsn("急曲", id())
	if v["急曲目标"] ~= 0 and tid() == v["急曲目标"] then		--上急曲的目标buff还没同步，就加1层
		v["急曲层数"] = v["急曲层数"] + 1
	end

	v["目标血量较多"] = rela("敌对") and tlifevalue() > lifemax() * 10


	--月华倾泻, 需要对当前目标释放才有效果
	if v["目标血量较多"] and dis() < 25 and cdtime("月华倾泻") <= 0 and v["急曲层数"] < 3 then
		--对应的buff等级和需要的目标内功
		v["月华buff等级"] = 1		--倾泄, 低于50%, 外功
		v["月华目标内功"] = "傲血战意|铁牢律|太虚剑意|惊羽诀|问水诀|山居剑意"
		if tlife() > 0.5 then
			v["月华buff等级"] = 2	--月华, 高于50%, 内功
			v["月华目标内功"] = "洗髓经|易筋经|花间游|离经易道|紫霞功|云裳心经|冰心诀|毒经|补天诀|天罗诡道|焚影圣诀|明尊琉璃体"
		end

		if not g_player.IsHaveBuff(50372, v["月华buff等级"]) then		--月华和倾泄时间到了不消失，时间为负, nobuff("月华") 这样判断有问题
			v["月华目标"] = party("没状态:重伤", "不是自己", "内功:"..v["月华目标内功"], "距离<18", "视线可达", "距离最近")
			if v["月华目标"] ~= 0 then
				v["月华前目标"] = tid()			--记录当前目标, 月华倾泻读条结束恢复
				if settar(v["月华目标"]) then
					cast("月华倾泻")
				end
			end
		end
	end


	--副本防开怪
	if getopt("副本防开怪") and dungeon() and nofight() then return end

	--打断
	if tbuffstate("可打断") then
		cast("剑心通明")
	end

	if fight() and buffsn("剑舞") < 3 then
		cast("满堂势")
	end

	--[[驱散
	if tbufftype("阴性气劲|阳性气劲|混元性气劲|毒性气劲") > 0 then
		cast("剑转流云")
	end
	--]]

	
	if v["急曲层数"] >= 3 then
		if v["目标血量较多"] and dis() < 19 and tstate("站立|被击倒|眩晕|定身|锁足|爬起") and state("站立") then
			if cast("繁音急节") then
				cast("龙池乐")
			end
		end
		cast("江海凝光")
	end


	if rela("敌对") and dis() < 9 and tstate("站立|被击倒|眩晕|定身|锁足|爬起") and nobuff("剑神无我") then
		cast("剑神无我")
	end


	_, v["目标8尺怪物数量"] = tnpc("关系:敌对", "距离<8", "可选中")
	if v["目标8尺怪物数量"] >= 3 then
		cast("剑破虚空")
	end

	_, v["目标10尺怪物数量"] = tnpc("关系:敌对", "距离<10", "可选中")
	if v["目标10尺怪物数量"] >= 3 then
		cast("剑灵寰宇")
	end

	
	cast("剑主天地")

	if v["急曲层数"] >= 2 then
		cast("剑气长江")
	end

	cast("玳弦急曲")


	--放不出玳弦急曲(可能在移动)
	cast("剑破虚空")
	cast("剑灵寰宇")

end


--释放技能
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		--目标buff同步延时太久, 这里记录上急曲的目标
		if SkillID == 3009 then
			v["急曲目标"] = TargetID
		end

		--[[
		if SkillID ~= 2341 then
			if TargetType == 2 then		--类型2 是指定位置, 类型 3 4 是指定的NPC和玩家
				print("OnCast->["..xname(CasterID).."] 释放:"..SkillName..", 技能ID:"..SkillID..", 技能等级:"..SkillLevel..", 目标位置:"..TargetID.."|"..PosY.."|"..PosZ..", 开始帧:"..StartFrame..", 当前帧:"..FrameCount)
			else
				print("OnCast->["..xname(CasterID).."] 释放:"..SkillName..", 技能ID:"..SkillID..", 技能等级:"..SkillLevel..", 目标ID:"..TargetID..", 开始帧:"..StartFrame..", 当前帧:"..FrameCount)
			end
		end
		--]]
	end
end

--更新buff列表
function OnBuffList(CharacterID)
	--如果更新的是自己上急曲的目标，急曲目标设为0, 不增加层数
	if CharacterID == v["急曲目标"] then
		v["急曲目标"] = 0
	end
end
