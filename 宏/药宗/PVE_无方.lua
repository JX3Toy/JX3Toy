output("奇穴: [川谷][鸩羽][结草][灵荆][苦苛][坚阴][相使][凄骨][疾根][紫伏][甘遂][应理与药]")

--变量表
local v = {}
v["逆乱目标"] = 0
v["逆乱次数"] = 0

--函数表
local f = {}

f["千枝绽蕊"] = function()
	if cast("千枝绽蕊") then
		settimer("千枝绽蕊")
	end
end

f["有千枝绽蕊"] = function()
	return buff("千枝绽蕊") or gettimer("千枝绽蕊") < 1
end

--主循环
function Main(g_player)

	v["逆乱层数"] = tbuffsn("逆乱", id())
	if v["逆乱目标"] ~= 0 and tid() == v["逆乱目标"] then		--上逆乱的目标buff还没同步，增加层数
		v["逆乱层数"] = v["逆乱层数"] + v["逆乱次数"]
	end
	if v["逆乱层数"] > 8 then
		v["逆乱层数"] = 8
	end

	v["逆乱时间"] = tbufftime("逆乱", id())
	v["破招次数"] = buffsn("24469")
	v["药性绝对值"] = math.abs(yaoxing())
	v["是敌对没移动"]  = rela("敌对") and tstate("站立|被击倒|眩晕|定身|锁足|爬起")

	---------------------------------------------有破招

	--绿野蔓生, 下一刀带破招
	if dis() < 6 and cdtime("银光照雪") <= 0 then	--能打银光
		if cast("绿野蔓生") then
			settimer("绿野蔓生")
		end
	end

	if buff("24458") or gettimer("绿野蔓生") < 1 then
		f["千枝绽蕊"]()
	end

	--银光照雪, 6尺, 没GCD, 10秒CD, 
	cast("银光照雪")

	--飞叶满襟, 没GCD, 正面180, 10尺, 1 破招
	if face() < 180 and dis() < 10 and v["逆乱层数"] >= 8 then
		if buff("20071") then
			f["千枝绽蕊"]()
		end
		if f["有千枝绽蕊"]() then
			cast("飞叶满襟")
		end
	end
	
	--含锋破月, 20秒CD, 正面120, 6尺, 1 破招
	if face() < 120 and dis() < 6 and v["逆乱层数"] >= 8 then
		if cdtime("含锋破月") < 0.5 then
			f["千枝绽蕊"]()
		end
		if f["有千枝绽蕊"]() then
			cast("含锋破月")
		end
	end

	--且待时休, 4 破招
	if dis() < 13 and v["逆乱层数"] >= 4 and v["逆乱时间"] >= casttime("且待时休") + 0.1 and (v["破招次数"] < 1 or v["药性绝对值"] >= 5) then
		if cdtime("且待时休") < 0.5 then
			f["千枝绽蕊"]()
		end
		
		if f["有千枝绽蕊"]() then
			cast("且待时休")
		end
	end

	--川乌射罔, 10秒CD, 2.5秒引导, 4 温性, 1 破招
	if bufftime("凄骨") < 3 then
		cast("川乌射罔")
	end
	
	---------------------------------------------

	--沾衣未妨, 20秒CD,  5 寒性
	if scdtime("苍棘缚地") > 20 then
		cast("沾衣未妨")
	end

	--苍棘缚地
	if cast("苍棘缚地") then
		cast("沾衣未妨")
	end

	--紫叶沉疴
	if v["是敌对没移动"] then
		cast("紫叶沉疴")
	end


	--绿野蔓生

	--钩吻断肠, 1 温性
	if bufftime("相使") < 2 then
		cast("钩吻断肠")
	end

	--商陆缀寒, 1 寒性 (无药性 3 寒性)
	cast("商陆缀寒")
end

--释放技能
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		--目标buff同步延时太久, 这里记录上逆乱的目标
		if SkillID == 27560 then
			v["逆乱目标"] = TargetID
			v["逆乱次数"] = v["逆乱次数"] + 1
		end
	end
end

--更新buff列表
function OnBuffList(CharacterID)
	--如果更新的是自己上逆乱的目标，目标buff已经同步, 逆乱目标设为0, 不增加层数
	if CharacterID == v["逆乱目标"] then
		v["逆乱目标"] = 0
		v["逆乱次数"] = 0
	end
end
