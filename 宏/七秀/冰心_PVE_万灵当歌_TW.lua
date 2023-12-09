--[[ 奇穴: [青梅嗅][千里冰封][新妝][青梅][枕上][廣陵月][流玉][釵燕][盈袖][化冰][夜天][凝華]
秘籍:
玳弦  3伤害 1距离
剑气  2调息 1伤害 1效果(上急曲重置CD)
江海  2会心 2伤害
繁音  3调息 1效果(满堂)
天地  2调息 1消耗 1持续 别点回血回蓝

第十一重奇穴也可以尝试[瓊宵]
--]]

--关闭自动面向
setglobal("自动面向", false)

--宏选项
addopt("副本防开怪", false)
addopt("打断", false)

--变量表
local v = {}
v["记录信息"] = true

--函数表
local f = {}

--主循环
function Main(g_player)
	--按下自定义快捷键1挂扶摇, 注意是快捷键设定里面插件的快捷键1指定的按键，不是键盘上的1
	if keydown(1) then
		cast("扶搖直上")
	end

	--减伤
	if fight() and life() < 0.6 then
		cast("天地低昂")
	end

	--开剑舞
	if nobuff("劍舞") then
		cast("名動四方")
	end

	--化冰
	if qixue("化冰") and rela("敌对") and dis() < 30 then
		if nobuff("化冰") or nofight() then
			cast("心鼓弦", true)
		end
	end

	--初始化变量
	v["目标急曲层数"] = tbuffsn("急曲", id())
	v["目标急曲时间"] = tbufftime("急曲", id())
	v["繁音时间"] = bufftime("繁音急節")
	
	v["剑气CD"] = scdtime("劍氣長江")
	v["剑破CD"] = scdtime("劍破虛空")
	v["剑影CD"] = scdtime("劍影留痕")	
	v["江海CD"] = scdtime("江海凝光")
	v["繁音CD"] = scdtime("繁音急節")
	v["广陵月CD"] = scdtime("廣陵月")
	
	v["钗燕没玳弦"] = nobuff("22695")
	v["钗燕没剑影"] = nobuff("23190")
	v["钗燕没剑气"] = nobuff("23191")
	v["钗燕没剑破"] = nobuff("23192")
	v["钗燕没江海"] = nobuff("26240")
	v["钗燕次数"] = buffsn("釵燕")	--26287, 6秒, 层数是次数, 结束时删除所有buff
	v["流玉时间"] = bufftime("25910")

	v["目标血量较多"] = rela("敌对") and tlifevalue() > lifemax() * 10	--目标当前血量大于自己最大血量5倍
	local tSpeedXY, tSpeedZ = speed(tid())
	v["目标静止"] = rela("敌对") and tSpeedXY <= 0 and tSpeedZ <= 0		--目标没移动

	--------------------------------------------- 开始打伤害

	--副本防开怪
	if getopt("副本防开怪") and dungeon() and nofight() then return end

	--打断
	if getopt("打断") and tbuffstate("可打断") then
		fcast("劍心通明")
	end
	
	--等待剑影释放
	if gettimer("剑影留痕") < 0.3 then return end

	--繁音
	if v["目标血量较多"] and dis() < 20 and face() < 80 and cdleft(16) < 0.5 and v["钗燕次数"] == 2 then
		CastX("繁音急節")
	end

	--琼宵
	if qixue("瓊宵") and v["目标静止"] and dis() < 9 then
		v["移动键被按下"] = keydown("MOVEFORWARD") or keydown("MOVEBACKWARD") or keydown("STRAFELEFT") or keydown("STRAFERIGHT") or keydown("JUMP")
		if not v["移动键被按下"] and state("站立") and nobuff("劍神無我") and v["钗燕没玳弦"] and v["钗燕没剑影"] and v["钗燕没剑气"] and v["钗燕没剑破"] and v["钗燕没江海"] then
			CastX("婆羅門")
		end
	end

	f["江海凝光"]()
	
	--剑影留痕
	if v["钗燕没剑影"] and v["钗燕没玳弦"] and cdleft(16) >= 0.5 and cdleft(16) < 1 then
		if CastX("劍影留痕") then
			return
		end
	end

	--有流玉先打玳弦
	if v["流玉时间"] > 1 then
		f["玳弦急曲"]()
	end

	--目标凝华大于6层
	if tbuffsn("凝華", id()) > 6 then
		f["剑气长江"]()
	end

	f["剑破虚空"]()
	f["玳弦急曲"]()
	f["剑气长江"]()
end

f["剑破虚空"] = function()
	if v["钗燕没剑破"] then
		CastX("劍破虛空")
	end
end

f["剑气长江"] = function()
	if v["钗燕没剑气"] then
		CastX("劍氣長江")
	end
end

f["江海凝光"] = function()
	if v["钗燕没江海"] then
		CastX("江海凝光")
	end
end

f["玳弦急曲"] = function()
	if v["钗燕没玳弦"] then
		--广陵月绑定玳弦
		if rela("敌对") and dis() < 25 and cdtime("玳弦急曲") <= 0 then
			CastX("廣陵月")
		end
		CastX("玳弦急曲")
	end
end

-------------------------------------------------------------------------------

--记录信息到日志窗口
function PrintInfo(s)
	local t = {}
	if s then t[#t+1] = s end
	t[#t+1] = "流玉:"..v["流玉时间"]
	t[#t+1] = "剑气CD:"..v["剑气CD"]
	t[#t+1] = "剑破CD"..v["剑破CD"]
	t[#t+1] = "剑影CD:"..v["剑影CD"]
	t[#t+1] = "江海CD:"..v["江海CD"]
	t[#t+1] = "繁音CD:"..v["繁音CD"]
	t[#t+1] = "广陵月CD:"..v["广陵月CD"]
	
	print(table.concat(t, ", "))
end

--使用技能并记录信息
function CastX(szSkill, bSelf)
	if cast(szSkill, bSelf) then
		settimer(szSkill)
		if v["记录信息"] then PrintInfo() end
		return true
	end
	return false
end

-------------------------------------------------------------------------------

--释放技能
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		if SkillID == 546 then		--剑影留痕
			deltimer("剑影留痕")
			return
		end

		if SkillID == 34611 then	--钗燕·明
			print("------------------------------", SkillName, SkillID, SkillLevel)
		end
	end
end
