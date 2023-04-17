output("----------镇派----------")
output("2 3 2")
output("0 2 2 3")
output("3 2 0 1")
output("2 2 0 2")
output("3 2 0 1")
output("1 1 0")
output("0 0 2")

--关闭自动面向
setglobal("自动面向", false)

--副本中没进战不打技能, 在归墟秘境要关闭
addopt("副本防开怪", false)

--等待阳明指释放标志
local bWait = false

--变量表，用于存放中文变量
local v = {}

--主循环, 每秒执行十几次
function Main(g_player)
	--[[给自己上清心, 太费蓝了，先注释掉，手动放
	if nofight() and nobuff("清心静气") then
		cast("清心静气", true)
	end
	--]]

	--被攻击回血
	if fight() and rela("敌对") and dis() < 4 and ttid() == id() then
		cast("毫针", true)
	end

	--减伤
	if fight() and life() < 0.6 and buffstate("减伤效果") < 36 then
		cast("春泥护花", true)
	end

	--6秒回32%血
	if fight() and life() < 0.65 then
		cast("花语酥心", true)
	end

	--读条结束时，技能还没有释放，要等到释放才知道有没有触发[皓月][寒碧]之类的效果
	if casting("阳明指") and castleft() < 0.13 then
		bWait = true
		settimer("阳明指读条结束")
	end

	--目标buff同步有延迟, 防止重复读条
	if casting("兰摧玉折") and castleft() < 0.13 then
		settimer("兰摧读条结束")
	end
	if casting("钟林毓秀") and castleft() < 0.13 then
		settimer("钟林读条结束")
	end

	--打断
	if tbuffstate("可打断") then
		cast("厥阴指")
	end

	--副本处理
	local mapName = map()
	--print(mapName)
	local func = tMapFunc[mapName]
	if func then
		func(g_player)
	end

	--等待阳明指释放
	if bWait and gettimer("阳明指读条结束") < 0.3 then
		return
	end

	--目标不是敌对, 结束
	if not rela("敌对") then return end

	--无标无敌, 结束
	if tbuff("隐遁") then return end

	--副本防开怪, 在副本没进战, 结束
	if getopt("副本防开怪") and dungeon() and nofight() then return end

	-------------------------------------------------------开始输出

	v["目标血量较多"] = tlifevalue() > 20 * 10000		--目标血量大于20万才放水月乱撒

	--水月无间
	if rela("敌对") and v["目标血量较多"] and dis() < 18 and mana() < 0.9 then
		cast("水月无间")
	end

	--获取目标3dot信息
	v["商阳指时间"] = tbufftime("商阳指", id())
	v["钟林时间"] = tbufftime("钟林毓秀", id())
	v["兰摧时间"] = tbufftime("兰摧玉折", id())
	v["有3dot"] = v["商阳指时间"] > 0 and v["钟林时间"] > 0 and v["兰摧时间"] > 0

	v["最短时间"] = v["商阳指时间"]
	if v["钟林时间"] < v["最短时间"] then
		v["最短时间"] = v["钟林时间"]
	end
	if v["兰摧时间"] < v["最短时间"] then
		v["最短时间"] = v["兰摧时间"]
	end

	--乱洒青荷
	if rela("敌对") and v["目标血量较多"] and dis() < 18 and v["商阳指时间"] <= 0 and v["钟林时间"] <= 0 and v["兰摧时间"] <= 0 then
		if cdtime("玉石俱焚") > 15 then	--重置玉石
			cast("乱洒青荷")
		end
	end

	--有3dot
	if gettimer("吞海") > 2 and v["有3dot"] then
		--最短的一个还有16秒，就爆, 这个时间根据加速调整
		if v["最短时间"] > 16 then
			cast("玉石俱焚")
		end

		--芙蓉并蒂刷新dot
		if scdtime("玉石俱焚") < 1 or (buff("满雪") and buffsn("满雪") >= 2) then
			if v["最短时间"] > 0.1 and v["最短时间"] < 10 then
				cast("芙蓉并蒂")
			end
		end
	end

	--兰摧
	if gettimer("寒碧") > 2 and gettimer("兰摧读条结束") > 0.3 then
		if gettimer("吞海") < 1 or v["兰摧时间"] <= 0 then
			cast("兰摧玉折")
		end
	end

	--钟林
	if gettimer("钟林读条结束") > 0.3 then
		if gettimer("吞海") < 1 or v["钟林时间"] <= 0 then
			cast("钟林毓秀")
		end
	end

	--商阳
	if gettimer("吞海") < 1 or v["商阳指时间"] <= 0 then
		cast("商阳指")
	end

	--快雪
	if buff("满雪") and buffsn("满雪") >= 2 then
		cast("快雪时晴")
	end

	--10秒回%60蓝
	if fight() and mana() < 0.45 then
		cast("碧水滔天", true)
	end
	
	cast("阳明指")
end

--释放技能时执行
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	--如果释放技能的是自己
	if CasterID == id() then
		--释放阳明指, 等待结束
		if SkillName == "阳明指" then
			bWait = false
		end

		--阳明指触发[寒碧]，给目标上兰摧
		if SkillID == 3037 then
			print("----------寒碧")
			settimer("寒碧")
		end

		--镇派[皓月]阳明指吞噬3dot
		if SkillName == "吞海" then
			print("----------呑海")
			settimer("吞海")
		end
		
		--[[输出记录，用于调试
		if TargetType == 2 then		--类型2 是坐标位置, 类型 3 4 是的NPC或玩家
			print("OnCast->["..xname(CasterID).."] 释放:"..SkillName..", 技能ID:"..SkillID..", 技能等级:"..SkillLevel..", 目标位置:"..TargetID.."|"..PosY.."|"..PosZ..", 开始帧:"..StartFrame..", 当前帧:"..FrameCount)
		else
			print("OnCast->["..xname(CasterID).."] 释放:"..SkillName..", 技能ID:"..SkillID..", 技能等级:"..SkillLevel..", 目标ID:"..TargetID..", 开始帧:"..StartFrame..", 当前帧:"..FrameCount)
		end
		--]]
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
		settimer("藏·剑邪鸠点名")
		bigtext("被 藏·剑邪鸠 点名, 快跑")
	end
end

-------------------------------------------------副本处理
tMapFunc = {}

tMapFunc["英雄法王窟"] = function(g_player)
	--老1老2无敌buff, 不输出
	if tbuff("隐遁") then exit() end
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
	--驱散2号debuff
	xcast("清风垂露", party("没状态:重伤", "距离<20", "视线可达", "buff类型时间:阳性不利效果|混元性不利效果|阴性不利效果|点穴不利效果|毒性不利效果>1"))
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

	--打天雷，只用阳明指
	if tname("天雷") then
		cast("阳明指")
		exit()
	end

	--选中对应的五行珠
	for k,v in pairs(tWuXing) do
		if buff(k) then
			settar(npc("名字:"..v))
			break
		end
	end

	--平A
	if tname("五行·金珠|五行·木珠|五行·水珠|五行·火珠|五行·土珠") then
		cast("判官笔法")
		exit()
	end

	--汉唐 大地震颤
	local hantang = npc("读条:大地震颤")
	if hantang ~= 0 and xcastpass(hantang) > 2 then
		jump()
	end
end
