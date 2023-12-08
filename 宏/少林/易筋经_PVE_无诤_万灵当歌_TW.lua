--[[ 奇穴: [明法][幻身][纷纭][缩地][降魔渡厄][金刚怒目][净果][三生][众嗔][無執][金剛日輪][無諍]
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
		cast("扶搖直上")
	end

	if fight() and life() < 0.5 then
		cast("無相訣")
	end

	if nobuff("般若訣") and nofight() then
		cast("般若訣", true)
	end
	
	if nobuff("伏魔") then
		cast("二業依緣", true)
	end

	if buff("25882") then
		cbuff("25882")
	end
	
	if not rela("敌对") then return end

	if getopt("副本防开怪") and dungeon() and nofight() then return end

	if gettimer("等待禅那同步") < 0.3 then return end
	
	if qidian() > 2 and dis() < 6 then
		CastX("羅漢金身")
	end
	
	f["橫掃六合"]()
	
	f["千斤墜"]()
	
	f["纷纭"]()
	
	if fight() and buffsn("貪破") >= 2 and buffsn("24454") < 3 then
		cast("鍛骨訣")
	end
	
	if buff("拿雲") and qidian() > 2 and buff("金剛日輪") then
		CastX("拿雲式")
	end
	
	if buff("拿雲") and qidian() > 2 and nobuff("金剛日輪") and scdtime("千斤墜") >= 14 and bufftime("23069", id()) <= 0 and bufftime("23070", id()) <= 0 then
		CastX("拿雲式")
	end

	if qidian() > 2 and nobuff("拿雲") then
		CastX("韋陀獻杵")
	end
	
	if (cdleft(16) > 0.5 or dis() > 8) and qidian() < 2 and buff("捕風式") and dis() > 4 then
		CastX("捉影式")
	end
	
	CastX("守缺式")
	
	if buff("金剛日輪") and qidian() < 3 then
		CastX("捕風式")
	end
	
	if qidian() < 2 and nobuff("擒龍訣") then
		CastX("摩訶無量")
	end
	
	if qidian() < 3 and nobuff("擒龍訣") and (nobuff("21617") or scdtime("千斤墜") <= cdinterval(16) or bufftime("23069", id()) > 0 or bufftime("23070", id()) > 0) then
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

f["千斤墜"] = function()
	if face() < 60 and nobuff("金剛日輪") then
		CastX("千斤墜")
	end
	if face() < 60 and dis() < 8 and scdtime("羅漢金身") > 0 and scdtime("橫掃六合") <= cdinterval(16) then
		CastX("千斤墜")
	end
end

f["纷纭"] = function()
	if dis() > 5.5 then return end

	v["金剛日輪阵"] = npc("关系:自己", "模板ID:107539", "距离<8")
	v["阵法内敌人数量"] = 0
	if v["金剛日輪阵"] ~= 0 then
		_, v["阵法内敌人数量"] = xnpc(v["金剛日輪阵"], "关系:敌对", "距离<8", "可选中")
	end
	
	if v["阵法内敌人数量"] > 0 and bufftime("23069", id()) > 0 and bufftime("23069", id()) < 1.5 and nobuff("21617") and qidian() < 3 and cdleft(16) <= 0 then
		if cast("普渡四方") then
			CastX("千斤墜·無取")
		end
	end
	
	if v["阵法内敌人数量"] > 0 and bufftime("23069", id()) > 0 and bufftime("23069", id()) < 1.5 then
		CastX("千斤墜·無取")
	end
	
	if v["爆阵续日轮"] and bufftime("23069", id()) > 0 then
		CastX("千斤墜·無取")
	end
	
	if v["金剛日輪阵"] <= 0 and gettimer("千斤墜") > 1.5 and bufftime("23069", id()) > 0 then
		CastX("千斤墜·無取")
	end
	
	if v["阵法内敌人数量"] > 0 and bufftime("23070", id()) > 0 and bufftime("23070", id()) < 1.5 then
		CastX("千斤墜·無舍")
	end
	
	if v["爆阵续日轮"] and bufftime("23070", id()) > 0 then
		CastX("千斤墜·無舍")
	end
	
	if v["金剛日輪阵"] <= 0 and gettimer("千斤墜·無取") > 1.5 and bufftime("23070", id()) > 0 then
		CastX("千斤墜·無舍")
	end
end

f["橫掃六合"] = function()
	if dis() > 5.5 then return end
	
	if cdtime("橫掃六合") > 0 then
		return
	end
	
	if bufftime("羅漢金身", id()) <= 6 then
		return
	end
	
	if buff("21616") and buff("金剛日輪") and (scdtime("千斤墜") <= cdinterval(16) or bufftime("23069", id()) > 0 or bufftime("23070", id()) > 0) then
		if scdtime("擒龍訣") > 0 then
			CastX("橫掃六合")
		end
		
		if scdtime("擒龍訣") <= 0 then
			CastX("擒龍訣")
		end
	end
	
	if buff("21616") and nobuff("金剛日輪") and scdtime("千斤墜") >= 14 and bufftime("23069", id()) <= 0 and bufftime("23070", id()) <= 0 then
		CastX("橫掃六合")
	end
	
	if nobuff("21616") and buff("金剛日輪") then
		if scdtime("擒龍訣") > 0 then
			CastX("橫掃六合")
		end
		
		if scdtime("擒龍訣") <= 0 then
			CastX("擒龍訣")
		end
	end
	
	if nobuff("21616") and nobuff("金剛日輪") and scdtime("千斤墜") >= 14 and bufftime("23069", id()) <= 0 and bufftime("23070", id()) <= 0 then
		CastX("橫掃六合")
	end
end

-------------------------------------------------------------------------------

function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		if SkillName == "金剛日輪" then
			v["爆阵续日轮"] = true
			settimer("金剛日輪")
			return
		end
		
		if SkillName == "千斤墜" then
			v["爆阵续日轮"] = false
			settimer("千斤墜")
			return
		end
		
		if SkillName == "千斤墜·無取" then
			v["爆阵续日轮"] = false
			settimer("千斤墜·無取")
			return
		end
	end
end

--气点更新
function OnQidianUpdate()
	deltimer("等待禅那同步")
end
