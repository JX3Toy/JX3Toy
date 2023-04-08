output("----------镇派----------")
output("2 3 0")
output("2 2 3 0")
output("0 1 2 2")
output("2 2 0 1")
output("2 1 2 1")
output("0 1 0")
output("2 3 0")
output("0 2 0 0")


addopt("副本防开怪", true)

local bWait = false		--等待气点同步标志

function Main(g_player)

	--捉影式读条结束计时器
	if casting("捉影式") and castleft() < 0.13 then
		settimer("捉影式")
	end

	--般若诀
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

	--副本防开怪
	if getopt("副本防开怪") and dungeon() and nofight() then return end


	--打断
	if tbuffstate("可打断") then
		cast("抢珠式")
	end

	-----------------------------------------输出

	--等气点同步
	if bWait then
		if gettimer("擒龙诀") < 0.3 or gettimer("亦枯亦荣") < 0.3 or gettimer("金刚怒目") < 0.3 then
			return
		end
	end

	--擒龙诀
	if rela("敌对") and dis() < 4 and qidian() < 1 and tlifevalue() > lifemax() * 3 then
		if cast("擒龙诀") then
			settimer("擒龙诀")
			bWait = true
			return
		end
	end

	--佛心诀
	if rela("敌对") and dis() < 4 and bufftime("金刚怒目") > 10 then
		cast("佛心诀")
	end

	--亦枯亦荣
	if fight() and mana() < 0.3  and qidian() < 3 then
		if cast("亦枯亦荣") then
			settimer("亦枯亦荣")
			bWait = true
			return
		end
	end

	
	if fight() and life() < 0.45 then
		cast("无相诀")
	end


	if qidian() >= 3 then
		if rela("敌对") and dis() < 4 then
			if cast("金刚怒目") then
				settimer("金刚怒目")
				bWait = true
				return
			end
		end

		cast("拿云式")
		cast("韦陀献杵")
	end

	if rela("敌对") and dis() < 4 and tlifevalue() > lifemax() * 5 and bufftime("金刚怒目") > 10 then
		cast("金刚诀")
	end

	if rela("敌对") and dis() < 4.5 then
		cast("横扫六合")
	end

	cast("捣虚式")
	cast("守缺式")
	cast("恒河劫沙")
	cast("普渡四方")

	if dis() > 8 then
		cast("捕风式")
	end

	if qidian() < 3 and gettimer("捉影式") > 0.5 and dis() < 8 then
		if buff("捕风式") then		--不需要读条，没GCD直接放
			cast("捉影式")
		end
		if cdleft(16) > 0.7 then	--需要读条，插入GCD中间
			cast("捉影式")
		end
	end
end

--禅那更新
OnQidianUpdate = function()
	bWait = false
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
		bigtext("多多 正在读条 星火坠, 散开")
	end
end

tMapFunc["英雄寂灭厅"] = function(g_player)
	if npc("读条:剑流云") ~= 0 then
		bigtext("剑心 正在读条 剑流云")
		cast("扶摇直上")
	end
end

tMapFunc["英雄毒神殿"] = function(g_player)
	--炸裂拍击, 技能ID:2303, 技能等级:2, 目标ID:1074285037, 读条帧数:32, 开始帧:3667361, 当前帧:3667362
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
	--毒神殿2号读条
	if SkillID == 2303 then
		bigtext("[鲍穆侠] 开始读条:炸裂拍击, 移动到他身后")
	end

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
	--法王窟老1点名, 5秒后当头一锄
	if Name == "胡鞑" and SayText:find(name()) then
		settimer("法王窟胡鞑点名")
		bigtext("被胡鞑点名")
	end

	--寂灭厅老1点名
	if Name == "藏·剑邪鸠" and SayText:find(name()) then
		bigtext("被 藏·剑邪鸠 点名, 快跑")
	end

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
