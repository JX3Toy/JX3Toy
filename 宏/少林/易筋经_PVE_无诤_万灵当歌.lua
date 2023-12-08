--[[ 奇穴: [明法][幻身][纷纭][缩地][降魔渡厄][金刚怒目][净果][三生][众嗔][无执][金刚日轮][无诤]
秘籍: 
普渡  2调息 2伤害
韦陀  1会心 2伤害 1效果
横扫  1伤害 1消耗 1持续 1目标个数
捕风  2调息 2伤害
守缺  1会心 3伤害
拿云  1效果 3伤害

每次千斤坠之后往后退一点，离目标3尺左右
--]]

setglobal("自动面向", false)

addopt("副本防开怪", false)

local v = {}
v["爆阵续日轮"] = false

local f = {}

function Main(g_player)
	-- 按下自定义快捷键1挂扶摇
	if keydown(1) then
		cast("扶摇直上")
	end

	if fight() and life() < 0.5 then
		cast("无相诀")
	end

	if nobuff("般若诀") and nofight() then
		cast("般若诀", true)
	end
	
	if nobuff("伏魔") then
		cast("二业依缘", true)
	end

	if buff("25882") then
		cbuff("25882")
	end
	
	if not rela("敌对") then return end

	if getopt("副本防开怪") and dungeon() and nofight() then return end

	if gettimer("等待禅那同步") < 0.3 then return end
	
	if qidian() > 2 and dis() < 6 then
		CastX("罗汉金身")
	end
	
	f["横扫六合"]()
	
	f["千斤坠"]()
	
	f["纷纭"]()
	
	if fight() and buffsn("贪破") >= 2 and buffsn("24454") < 3 then
		cast("锻骨诀")
	end
	
	if buff("拿云") and qidian() > 2 and buff("金刚日轮") then
		CastX("拿云式")
	end
	
	if buff("拿云") and qidian() > 2 and nobuff("金刚日轮") and scdtime("千斤坠") >= 14 and bufftime("23069", id()) <= 0 and bufftime("23070", id()) <= 0 then
		CastX("拿云式")
	end

	if qidian() > 2 and nobuff("拿云") then
		CastX("韦陀献杵")
	end
	
	if (cdleft(16) > 0.5 or dis() > 8) and qidian() < 2 and buff("捕风式") and dis() > 4 then
		CastX("捉影式")
	end
	
	CastX("守缺式")
	
	if buff("金刚日轮") and qidian() < 3 then
		CastX("捕风式")
	end
	
	if qidian() < 2 and nobuff("擒龙诀") then
		CastX("摩诃无量")
	end
	
	if qidian() < 3 and nobuff("擒龙诀") and (nobuff("21617") or scdtime("千斤坠") <= cdinterval(16) or bufftime("23069", id()) > 0 or bufftime("23070", id()) > 0) then
		CastX("普渡四方")
	end
end

-------------------------------------------------------------------------------

CastX = function(szSkill)
	if cast(szSkill) then
		settimer("等待禅那同步")
		exit()
	end
end

f["千斤坠"] = function()
	if face() < 60 and nobuff("金刚日轮") then
		CastX("千斤坠")
	end
	if face() < 60 and dis() < 8 and scdtime("罗汉金身") > 0 and scdtime("横扫六合") <= cdinterval(16) then
		CastX("千斤坠")
	end
end

f["纷纭"] = function()
	if dis() > 5.5 then return end

	v["金刚日轮阵"] = npc("关系:自己", "模板ID:107539", "距离<8")
	v["阵法内敌人数量"] = 0
	if v["金刚日轮阵"] ~= 0 then
		_, v["阵法内敌人数量"] = xnpc(v["金刚日轮阵"], "关系:敌对", "距离<8", "可选中")
	end
	
	if v["阵法内敌人数量"] > 0 and bufftime("23069", id()) > 0 and bufftime("23069", id()) < 1.5 and nobuff("21617") and qidian() < 3 and cdleft(16) <= 0 then
		if cast("普渡四方") then
			CastX("千斤坠·无取")
		end
	end
	
	if v["阵法内敌人数量"] > 0 and bufftime("23069", id()) > 0 and bufftime("23069", id()) < 1.5 then
		CastX("千斤坠·无取")
	end
	
	if v["爆阵续日轮"] and bufftime("23069", id()) > 0 then
		CastX("千斤坠·无取")
	end
	
	if v["金刚日轮阵"] <= 0 and gettimer("千斤坠") > 1.5 and bufftime("23069", id()) > 0 then
		CastX("千斤坠·无取")
	end
	
	if v["阵法内敌人数量"] > 0 and bufftime("23070", id()) > 0 and bufftime("23070", id()) < 1.5 then
		CastX("千斤坠·无舍")
	end
	
	if v["爆阵续日轮"] and bufftime("23070", id()) > 0 then
		CastX("千斤坠·无舍")
	end
	
	if v["金刚日轮阵"] <= 0 and gettimer("千斤坠·无取") > 1.5 and bufftime("23070", id()) > 0 then
		CastX("千斤坠·无舍")
	end
end

f["横扫六合"] = function()
	if dis() > 5.5 then return end
	
	if cdtime("横扫六合") > 0 then
		return
	end
	
	if bufftime("罗汉金身", id()) <= 6 then
		return
	end
	
	if buff("21616") and buff("金刚日轮") and (scdtime("千斤坠") <= cdinterval(16) or bufftime("23069", id()) > 0 or bufftime("23070", id()) > 0) then
		if scdtime("擒龙诀") > 0 then
			CastX("横扫六合")
		end
		
		if scdtime("擒龙诀") <= 0 then
			CastX("擒龙诀")
		end
	end
	
	if buff("21616") and nobuff("金刚日轮") and scdtime("千斤坠") >= 14 and bufftime("23069", id()) <= 0 and bufftime("23070", id()) <= 0 then
		CastX("横扫六合")
	end
	
	if nobuff("21616") and buff("金刚日轮") then
		if scdtime("擒龙诀") > 0 then
			CastX("横扫六合")
		end
		
		if scdtime("擒龙诀") <= 0 then
			CastX("擒龙诀")
		end
	end
	
	if nobuff("21616") and nobuff("金刚日轮") and scdtime("千斤坠") >= 14 and bufftime("23069", id()) <= 0 and bufftime("23070", id()) <= 0 then
		CastX("横扫六合")
	end
end

-------------------------------------------------------------------------------

function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		if SkillName == "金刚日轮" then
			v["爆阵续日轮"] = true
			settimer("金刚日轮")
			return
		end
		
		if SkillName == "千斤坠" then
			v["爆阵续日轮"] = false
			settimer("千斤坠")
			return
		end
		
		if SkillName == "千斤坠·无取" then
			v["爆阵续日轮"] = false
			settimer("千斤坠·无取")
			return
		end
	end
end

--气点更新
function OnQidianUpdate()
	deltimer("等待禅那同步")
end
