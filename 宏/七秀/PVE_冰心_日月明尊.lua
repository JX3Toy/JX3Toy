--[[镇派
[大寒]2 [融雪]2 [阴日]3
[丰年]2 [空吟]2 [冰肌]3
[玳弦急曲]1 [蝉伴月]2 [倾城]2
[霜风]2 [风聆夜]1 [碎冰]2
[镜花]1 [玉骨]2
[剑破虚空]1 [化骨]1
[朝露]2 [化蝶]3
[翔天]2
--]]

--关闭自动面向
setglobal("自动面向", false)

--宏选项
addopt("副本防开怪", false)

--变量表
local v = {}
v["急曲目标"] = 0
v["月华前目标"] = 0

--主循环
function Main(g_player)
	--副本技能处理
	if map("归墟秘境") then
		if tcasting("击飞") then
			stopcasting()
			if castleft() < 0.5 then
				cast("蹑云逐月")
				cast("迎风回浪")
				cast("凌霄揽胜")
				cast("瑶台枕鹤")
			end
			return
		end
	end

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

	--减伤
	if fight() and life() < 0.6 and buffstate("减伤效果") < 40 then
		cast("天地低昂")
	end

	--副本防开怪
	if getopt("副本防开怪") and dungeon() and nofight() then return end

	if tbuff("隐遁") then
		bigtext("目标无敌", 0.5)
		return
	end

	--初始化变量
	v["目标急曲层数"] = tbuffsn("急曲", id())
	if v["急曲目标"] ~= 0 and tid() == v["急曲目标"] then	--上急曲的目标buff还没同步，就加1层
		v["目标急曲层数"] = v["目标急曲层数"] + 1
	end
	local tSpeedXY, tSpeedZ = speed(tid())
	v["目标静止"] = tSpeedXY == 0 and tSpeedZ == 0		--xy速度和Z速度都为0
	v["目标血量较多"] = rela("敌对") and tlifevalue() > lifemax() * 10		--目标血量大于自己最大血量10倍

	--月华倾泻, 需要对当前目标释放才有效果
	if v["目标血量较多"] and dis() < 25 and cdtime("月华倾泻") <= 0 and v["目标急曲层数"] < 3 then
		--对应的buff等级和需要的目标内功
		v["月华buff等级"] = 1		--倾泄, 低于50%, 外功
		v["需要心法"] = "内功:傲血战意|铁牢律|太虚剑意|惊羽诀|问水诀|山居剑意|笑尘诀"
		if tlife() > 0.5 then
			v["月华buff等级"] = 2	--月华, 高于50%, 内功
			v["需要心法"] = "不是内功:傲血战意|铁牢律|太虚剑意|惊羽诀|问水诀|山居剑意|笑尘诀"
		end

		if not g_player.IsHaveBuff(50372, v["月华buff等级"]) then		--月华和倾泄时间到了不消失，时间为负, nobuff("月华") 这样判断有问题
			v["月华目标"] = party("没状态:重伤", "不是自己", v["需要心法"], "距离<18", "视线可达", "距离最近")
			if v["月华目标"] ~= 0 then
				v["月华前目标"] = tid()			--记录当前目标, 月华倾泻读条结束恢复
				if settar(v["月华目标"]) then
					cast("月华倾泻")
				end
			end
		end
	end

	--打断
	if tbuffstate("可打断") then
		cast("剑心通明")
	end

	--满堂势
	if fight() and buffsn("剑舞") <= 3 then
		cast("满堂势")
	end

	--龙池乐
	if fight() and rela("敌对") and dis() < 19 then
		cast("龙池乐")
	end

	--[[剑转流云 驱散 有GCD先去掉
	if tbufftype("阴性气劲|阳性气劲|混元性气劲|毒性气劲") > 0 then
		fcast("剑转流云")
	end
	--]]

	--剑主续急曲
	if tbufftime("急曲", id()) < 3 then
		cast("剑主天地")
	end

	--爆急曲
	if v["目标急曲层数"] >= 3 then
		if tbufftime("急曲", id()) > 9 or (v["急曲目标"] ~= 0 and tid() == v["急曲目标"]) then
			cast("江海凝光")
		end
	end

	--剑神无我
	if rela("敌对") and dis() < 9 and v["目标静止"] and state("站立") and nobuff("剑神无我") then
		cast("剑神无我")
	end

	if v["目标急曲层数"] < 3 then
		cast("剑破虚空")
	end

	if v["目标急曲层数"] >= 2 then
		--剑灵寰宇
		_, v["目标10尺怪物数量"] = tnpc("关系:敌对", "距离<10", "可选中")
		if v["目标10尺怪物数量"] >= 2 then
			cast("剑灵寰宇")
		end
		
		--繁音急节
		if v["目标血量较多"] and dis() < 19 and v["目标静止"] and state("站立") and cdtime("剑气长江") <= 0 then
			cast("繁音急节")
			
		end

		cast("剑气长江")
	end
	
	cast("剑主天地")
	cast("玳弦急曲")

	--放不出玳弦急曲(可能在移动)
	cast("剑破虚空")
	cast("剑气长江")
	cast("剑灵寰宇")
end


--释放技能
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		if SkillID == 3009 then
			v["急曲目标"] = TargetID	--记录上急曲的目标
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
