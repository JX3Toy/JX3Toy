output("----------镇派----------")
output("2 3 1")
output("2 2 1 2")
output("2 1 2 3")
output("1 3 2 1")
output("2 3")
output("1")
output("0 0 2")


--宏选项, 是否幅T
addopt("副T", false)


--舍身
function SheShen()
	--法王窟_青翼蝠王_吸血大法_生命流逝
	if map("英雄法王窟") then
		if life() > 0.8 then
			xcast("舍身诀", party("buff时间:生命流逝>3"))
		end
	end

	--保奶
	if fight() and life() > 0.8 then
		xcast("舍身诀", party("没状态:重伤", "距离<20", "气血<0.4", "内功:离经易道|云裳心经|补天诀|相知|灵素", "视线可达"))
	end
end

local bWait = false

function Main(g_player)

	if nofight() and nobuff("般若诀") then
		cast("般若诀", true)
	end

	--副本处理
	local mapName = map()
	--print(mapName)
	local func = tMapFunc[mapName]
	if func then
		func(g_player)
	end

	--打断
	if tbuffstate("可打断") then
		cast("抢珠式")
	end

	--等气点同步
	if bWait and gettimer("擒龙诀") < 0.3  then
		return
	end

	--擒龙诀
	if rela("敌对") and dis() < 4 and qidian() < 1 and tlifevalue() > lifemax() * 10 then
		if cast("擒龙诀") then
			settimer("擒龙诀")
			bWait = true
			return
		end
	end

	--减伤
	if fight() and life() < 0.5 and buffstate("减伤效果") < 38 then
		cast("无相诀", true)
	end

	--舍身
	SheShen()

	
	--强仇
	local hateID, hate = hatred()		--获取当前目标仇恨最高的的玩家id和仇恨百分比
	if hateID ~= 0 and hateID ~= id() and hate > 1.15 then		--如果仇恨最高的不是自己, 仇恨值大于115%
		if gettimer("摩诃无量") > 2 and gettimer("归去来棍") > 2 and gettimer("万佛朝宗") > 2 then
			if cast("摩诃无量") then
				settimer("摩诃无量")
				bigtext("强仇 摩诃无量")
			end
			if cast("归去来棍") then
				settimer("归去来棍")
				bigtext("强仇 归去来棍")
			end
		end
	end
	
	--[[
	if rela("敌对") and ttid() ~= 0 and ttid() ~= id() then	--目标是敌对，目标有目标 不是自己
		cast("摩诃无量")
		cast("归去来棍")
	end
	--]]


	if rela("敌对") and dis() < 5.5 and qidian() <= 1 then
		cast("大狮子吼")
	end

	
	if qidian() >= 3 then
		if rela("敌对") and dis() < 4.5 then
			if tbufftime("立地成佛", id()) < 3.5 or tbuffsn("立地成佛", id()) < 5 then
				cast("立地成佛")
			end
		end

		if fight() and nobuff("袖纳乾坤") then
			cast("袖纳乾坤")
		end

		if rela("敌对") and tfight() and ttid() == id() then
			cast("灵山施雨")
		end

		if rela("敌对") and dis() < 4.5 then
			cast("立地成佛")
		end
	end

	--万佛朝宗
	if rela("敌对") and dis() < 5.5 then
		if cast("万佛朝宗") then
			settimer("万佛朝宗")
		end
	end

	if rela("敌对") and dis() < 4.5 then
		cast("横扫六合")
	end

	cast("普渡四方")


end

-------------------------------------------------副本处理
tMapFunc = {}

tMapFunc["英雄法王窟"] = function(g_player)
	--老1老2无敌buff, 不输出
	if tbuff("隐遁") then exit() end

	--老2 吸血大法 生命流逝
	--xcast("舍身诀", party("buff时间:生命流逝>3"))
end

tMapFunc["英雄无量宫"] = function(g_player)
	if npc("读条:星火坠") ~= 0 then
		bigtext("多多 开始读条 星火坠, 散开")
	end
end

tMapFunc["英雄寂灭厅"] = function(g_player)
	if npc("读条:剑流云") ~= 0 then
		bigtext("剑心 正在读条 剑流云")
		cast("扶摇直上")
	end
end

tMapFunc["英雄毒神殿"] = function(g_player)
	--毒神殿2号读条 炸裂拍击
	if npc("读条:炸裂拍击") ~= 0 then
		bigtext("[鲍穆侠] 正在读条 炸裂拍击")
		--有减伤，不处理
		if buffstate("减伤效果") > 38 then
			return
		end
		--放减伤
		if cast("无相诀") then
			return
		end
		--没减伤，扶摇 跳
		cast("扶摇直上")
		if buff("弹跳") then
			jump()
		end
	end
end

local tWuXing = {
["五行·青木"] = "五行·金珠",
["五行·后土"] = "五行·木珠",
["五行·炎火"] = "五行·水珠",
["五行·砺金"] = "五行·火珠",
["五行·若水"] = "五行·土珠",
}

tMapFunc["唐门密室"] = function(g_player)
	--选中16尺内距离最近的天雷
	settar(npc("名字:天雷", "距离<16", "距离最近"))

	--选中对应的五行珠
	for k,v in pairs(tWuXing) do
		if buff(k) then
			print(k, "名字:"..v)
			settar(npc("名字:"..v))
			break
		end
	end

	if tname("五行·金珠|五行·木珠|五行·水珠|五行·火珠|五行·土珠") then
		cast("六合棍")
		exit()
	end

	--汉唐 大地震颤
	local hantang = npc("读条:大地震颤")
	if hantang ~= 0 and xcastpass(hantang) > 2 then
		jump()
	end
end


-------------------------------------------------副本数据记录

--是否记录
local bLog = false

--判断对象是否Boss, 血量大于100万的NPC当作是Boss
local IsBoss = function(CharacterID)
	if CharacterID >= 0x40000000 and xlifemax(CharacterID) > 100 * 10000 then
		return true
	end
	return false
end

--释放技能
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if bLog and dungeon() and IsBoss(CasterID) then
		if TargetType == 2 then		--类型2 是指定位置, 类型 3 4 是指定的NPC和玩家
			print("OnCast->["..xname(CasterID).."] 释放:"..SkillName..", 技能ID:"..SkillID..", 技能等级:"..SkillLevel..", 目标位置:"..TargetID.."|"..PosY.."|"..PosZ..", 开始帧:"..StartFrame..", 当前帧:"..FrameCount)
		else
			print("OnCast->["..xname(CasterID).."] 释放:"..SkillName..", 技能ID:"..SkillID..", 技能等级:"..SkillLevel..", 目标ID:"..TargetID..", 开始帧:"..StartFrame..", 当前帧:"..FrameCount)
		end
	end
end

--开始读条
function OnPrepare(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, Frame, StartFrame, FrameCount)
	if bLog and dungeon() and IsBoss(CasterID) then
		if TargetType == 2 then
			print("OnPrepareXYZ->["..xname(CasterID).."] 开始读条:"..SkillName..", 技能ID:"..SkillID..", 技能等级:"..SkillLevel..", 目标位置:"..TargetID.."|"..PosY.."|"..PosZ..", 读条帧数:"..Frame..", 开始帧:"..StartFrame..", 当前帧:"..FrameCount)
		else
			print("OnPrepare->["..xname(CasterID).."] 开始读条:"..SkillName..", 技能ID:"..SkillID..", 技能等级:"..SkillLevel..", 目标ID:"..TargetID..", 读条帧数:"..Frame..", 开始帧:"..StartFrame..", 当前帧:"..FrameCount)
		end
	end
end

--警告信息
function OnWarning(Text)
	if bLog and dungeon() then
		print("OnWarning->"..Text)
	end
end

--npc喊话
function OnSay(Name, SayText, CharacterID)
	if bLog and dungeon() and IsBoss(CharacterID) then
		print("OnSay->["..Name.."]说:"..SayText)
	end
end

--系统消息
function OnMessage(Text, Type)
	if bLog and dungeon() then
		print("OnMessage->"..Text, Type)
	end
end
