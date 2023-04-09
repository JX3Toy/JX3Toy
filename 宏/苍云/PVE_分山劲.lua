output("ÆæÑ¨:[µ¶»ê][¾ø·µ][·ÖÒ°][±±Ä®][·æÃù][¸îÁÑ][»îÂö][ÁµÕ½][´ÓÈİ][·ßºŞ][ÃïÊÓ][ÕóÔÆ½á»Ş]")

local v = {}

function Main(g_player)
	v["Å­Æø"] = rage()
	v["ÕóÔÆ²ãÊı"] = buffsn("ÕóÔÆ")

	if rela("µĞ¶Ô") and dis() < 15 then
		cast("ÑªÅ­")
	end

	if pose("Çæ¶Ü") then
		v["Õ¶µ¶CD"] = cdleft(801)
		v["Çæµ¶GCD¼ä¸ô"] = cdinterval(16)

		if v["ÕóÔÆ²ãÊı"] >= 4 then
			v["Õ¶µ¶CD"] = v["Õ¶µ¶CD"] - v["Çæµ¶GCD¼ä¸ô"]
		end

		if v["Å­Æø"] >= 25 and v["Õ¶µ¶CD"] < 1 then
			if cast("¶Ü·É") then
				return
			end
		end

		cast("¶Ü»÷")
		cast("¶ÜÑ¹")
		cast("¶ÜÃÍ")
		cast("¶Üµ¶")
	end

	if pose("Çæµ¶") then
		if v["Å­Æø"] < 10 then
			cast("¶Ü»Ø")
			return
		end

		if buff("¿ñ¾ø") then	--¿ñ¾øºÍ³ÈÎäbuff
			cast("¾øµ¶")
		end

		--Õ¶µ¶
		if nobuff("¿ñ¾ø") then
			cast("Õ¶µ¶")
		end

		--ÉÁµ¶, 15µãÅ­Æø
		if v["Å­Æø"] >= 25 and tbuff("Á÷Ñª", id()) and tnobuff("¸îÁÑ", id()) then		--Ä¿±êÓĞÁ÷ÑªÃ»¼ÓÇ¿
			cast("ÉÁµ¶")
		end

		cast("ÑãÃÅÌöµİ")
		cast("ÔÂÕÕÁ¬Óª")

		if bufftime("¶Ü·É") > 10 and cntime("¶Ü»÷", true) > 2  then
			cast("ÕóÔÆ½á»Ş")
		end

		cast("¾øµ¶")

		--½Ùµ¶£¬ 10Å­Æø
		if v["Å­Æø"] >= 20 and v["Õ¶µ¶CD"] > 6 then
			cast("½Ùµ¶")
		end
	end
end
