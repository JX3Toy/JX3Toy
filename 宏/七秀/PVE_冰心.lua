output("奇穴: [青梅嗅][千里冰封][新妆][青梅][枕上][广陵月][望舒][元君][盈袖][化冰][疾光][霜降]")

--宏选项
addopt("副本防开怪", true)


--主循环
function Main(g_player)

	if fight() and life() < 0.5 then
		cast("天地低昂")	
	end

	cast("心鼓弦")

	--副本防开怪
	if getopt("副本防开怪") and dungeon() and nofight() then return end

	if tbuffstate("可打断") then
		fcast("剑心通明")
	end

	if tbuffsn("急曲", id()) >= 3 and tbufftime("急曲", id()) > 6 and dis() < 20 then
		if cast("广陵月") and tlifevalue() > lifemax() * 5 then
			cast("繁音急节")
		end
	end

	if tbuffsn("急曲", id()) < 3 or tbufftime("急曲", id()) < casttime(2707) + 0.2 then
		cast("剑破虚空")
		cast("江海凝光")
	end

	--玳弦急曲, 技能名放不出来用技能ID
	cast(2707)

	cast("江海凝光")
	cast("剑破虚空")
	cast("剑气长江")
end
