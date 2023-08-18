--[[ 奇穴: [青梅嗅][千里冰封][新妆][青梅][枕上][广陵月][凝华][钗燕][盈袖][化冰][夜天][流玉]
秘籍:
玳弦  3伤害 1距离
剑气  2调息 1会心 1效果(上急曲重置CD)
江海  2会心 2伤害
天地  2调息 1持续 1效果
繁音  3调息 1效果(满堂)
--]]

--关闭自动面向
setglobal("自动面向", false)

--宏选项
addopt("副本防开怪", false)
addopt("打断", false)

--变量表
local v = {}

--函数表
local f = {}

--主循环
function Main(g_player)
	if fight() and life() < 0.6 then
		cast("天地低昂")
	end

	if nobuff("剑舞") then
		cast("名动四方")
	end

	if qixue("化冰") and nobuff("化冰") then
		cast("心鼓弦", true)
	end

	if gettimer("剑影留痕") < 0.3 then return end

	--副本防开怪
	if getopt("副本防开怪") and dungeon() and nofight() then return end

	--打断
	if getopt("打断") and tbuffstate("可打断") then
		fcast("剑心通明")
	end

	--钗燕次数
	local CY_Buffs = {
	"23190",	--剑影
	"23191",	--剑气
	"23192",	--剑破
	"22695",	--玳弦
	"26240",	--江海
	}

	v["钗燕次数"] = 0
	for key, buffid in ipairs(CY_Buffs) do
		if buff(buffid) then
			v["钗燕次数"] = v["钗燕次数"] + 1
		end
	end

	v["目标血量较多"] = rela("敌对") and tlifevalue() > lifemax() * 5	--目标当前血量大于自己最大血量5倍

	--繁音
	if v["目标血量较多"] and dis() < 20 and face() < 60 and cdleft(16) < 0.5 and v["钗燕次数"] == 2 then
		cast("繁音急节")
	end
	
	--剑影
	if nobuff("22695") then
		if cast("剑影留痕") then
			settimer("剑影留痕")
			return
		end
	end

	--有流玉打玳弦
	if buff("25902") and buff("25910") then
		f["玳弦急曲"]()
	end

	f["剑破虚空"]()
	f["剑气长江"]()
	f["江海凝光"]()
	f["玳弦急曲"]()
end

f["剑破虚空"] = function()
	if nobuff("23192") then
		cast("剑破虚空")
	end
end

f["剑气长江"] = function()
	if nobuff("23191") then
		cast("剑气长江")
	end
end

f["江海凝光"] = function()
	if nobuff("26240") then
		cast("江海凝光")
	end
end

f["玳弦急曲"] = function()
	if nobuff("22695") then
		--广陵月绑定玳弦
		if rela("敌对") and dis() < 25 and cdtime("玳弦急曲") <= 0 then
			cast("广陵月")
		end
		cast("玳弦急曲")
	end
end

--释放技能
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		if SkillID == 546 then		--剑影留痕
			deltimer("剑影留痕")
		end
		if SkillID == 34611 then	--钗燕·明
			print("OnCast: "..SkillName, SkillID, SkillLevel)
		end
		--if SkillID == 34613 then	--凝华
		--	print("OnCast: "..SkillName, SkillID, SkillLevel)
		--end
	end
end
