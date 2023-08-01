--[[
奇穴: [玄黃][堅冰][斜打狗背][無疆][鳳歌][越淵][溫酒][龍醒][留魄][含弘][飲江][城復於隍]

秘籍:
恶狗 1回蓝 3伤害
蜀犬 2会心 2伤害
龙腾 2会心 2伤害
龙战 1会心 3伤害
亢龙 1会心 2伤害 1攻击提高
龙跃 2CD 1免内力 1伤害
狂龙 3伤害 1随便
龙啸 看着随便点
酒中仙 2CD 2读条 必须, 不然循环可能有问题

循环:
喝酒 - 蛟龙 - 双龙 - 亢龙(城复) - 龙游 - 龙腾 - 时乘 - 狂龙
恶狗 - 犬牙 - 亢龙 - 龙战
蜀犬 - 蛟龙 - 双龙 - 亢龙 - 龙游 - 龙腾 - 时乘 - 狂龙
棒打 - 龙跃 - 斜打 - 喝酒

打木桩还行，实战循环可能会乱, 有空再弄, 优点就是烟雨行不进循环, 站桩打不用跳来跳去
--]]

--变量表
local v = {}
v["输出信息"] = true

--函数表
local f = {}

--使用技能，输出调试信息
local CastX = function(szSkill)
	if cast(szSkill) then
		if v["输出信息"] then
			print("蓝:"..format("%0.3f",mana()), "蛟影时间:"..v["蛟影时间"], "镇慑时间:"..v["镇慑时间"], "无疆时间:"..v["无疆时间"], "盈久时间:"..v["盈久时间"], "酒时间:"..v["酒时间"], "恶狗CD:"..scdtime("惡狗攔路"), "蜀犬CD:"..scdtime("蜀犬吠日"), "亢龙CD:"..scdtime("亢龍有悔"), "酒CD:"..scdtime("酒中仙"), "时乘CD:"..scdtime("時乘六龍"))
		end
		return true
	end
	return false
end

f["酒中仙"] = function()
	if cast("酒中仙") then
		if v["输出信息"] then
			print("蓝:"..format("%0.3f",mana()), "蛟影时间:"..v["蛟影时间"], "镇慑时间:"..v["镇慑时间"], "无疆时间:"..v["无疆时间"], "盈久时间:"..v["盈久时间"], "酒时间:"..v["酒时间"], "恶狗CD:"..scdtime("惡狗攔路"), "蜀犬CD:"..scdtime("蜀犬吠日"), "亢龙CD:"..scdtime("亢龍有悔"), "酒CD:"..scdtime("酒中仙"), "时乘CD:"..scdtime("時乘六龍"))
		end
		stopmove()			--停止移动
		nomove(true)		--禁止移动
		settimer("酒中仙")
		exit()
	end
end

--主循环
function Main(g_player)
	--减伤
	if fight() and life() < 0.5 then
		cast("龍嘯九天")
	end

	if casting("酒中仙") and castleft() < 0.13 then
		settimer("酒中仙读条结束")
	end

	--喝酒防打断
	if gettimer("酒中仙") < 0.5 or casting("酒中仙") then
		return
	else
		nomove(false)	--允许移动
	end

	--初始化变量
	v["酒时间"] = bufftime("酣暢淋漓")
	v["蛟影时间"] = bufftime("25904")
	v["镇慑时间"] = bufftime("亢龍·鎮懾")
	v["无疆时间"] = bufftime("無疆")
	v["盈久时间"] = bufftime("盈久")
	v["酒中仙CD"] = scdtime("酒中仙")
	v["破招点"] = g_player.nSurplusPowerValue

	if not rela("敌对") then return end		--目标不是敌对结束
	if gettimer("时乘六龙") < 0.25 then return end	--时乘没GCD，稍微等下
	if buff("22483") then return end	--等待城复冲刺结束

	--喝酒读条结束等待蓝同步
	if gettimer("酒中仙读条结束") < 0.5 and mana() < 0.85 then
		print("喝酒后等待蓝同步")
		return
	end

	if buff("酣暢淋漓") then
		f["有酒"]()
	else
		if mana() > 0.35 then
			f["酒中仙"]()
		end

		--没有酒buff, 先打蛟龙套顶一下
		CastX("龍騰五嶽")
		CastX("龍遊天地")
		CastX("雙龍取水")
		if mana() > 0.75 then
			CastX("蛟龍翻江")
		end
		
		--没酒或者蓝达不到喝酒条件
		CastX("按狗低頭")
		CastX("反截狗臀")
		CastX("斜打狗背")
	end
end

f["有酒"] = function()
	--城复, 亢龙和蜀犬后
	if gettimer("释放亢龙有悔") < 1 or gettimer("释放蜀犬吠日") < 1 then
		CastX("城復於隍")
	end

	--犬牙
	CastX("犬牙交錯")

	--狂龙
	if dis() < 5 then
		CastX("狂龍亂舞")
	end

	--亢龙
	if mana() > 0.7 and buff("5986") then
		CastX("亢龍有悔")
	end

	--龙腾
	if gettimer("释放龙游2") < 1 or buff("5987") then	--极少情况龙游打完，龙腾buff还没同步
		CastX("龍騰五嶽")
		return
	end

	--龙游
	if buff("5986") then
		CastX("龍遊天地")
		return
	end

	--双龙
	if gettimer("释放双龙取水") > 1.5 and buff("5985") then
		CastX("雙龍取水")
		return
	end

	--蛟龙
	if nobuff("5985|5986|5987") then	--没有234段buff
		if mana() >= 0.85 or (mana() >= 0.75 and gettimer("酒中仙读条结束") < 0.5) then
			if v["蛟影时间"] < 15 or v["酒中仙CD"] > 20 then
				CastX("蛟龍翻江")
			end
		end
		if mana() >= 0.3 and v["蛟影时间"] < 8 then
			CastX("蛟龍翻江")
		end
	end
	
	--亢龙
	if mana() > 0.7 then
		CastX("亢龍有悔")
	end

	--时乘
	if mana() >= 0.225 and dis() < 5 and cdleft(590) <= 0 and nobuff("5985|5986|5987") then
		if CastX("時乘六龍") then
			settimer("时乘六龙")
			exit()
		end
	end

	--恶狗
	--if dis() < 6 and face() < 60 and mana() < 0.85 and v["酒中仙CD"] > 12.5 then
	if dis() < 6 and mana() < 0.85 and v["酒中仙CD"] > 12.5 then
		if acast("惡狗攔路") then
			if v["输出信息"] then
				print("蓝:"..format("%0.3f",mana()), "蛟影时间:"..v["蛟影时间"], "镇慑时间:"..v["镇慑时间"], "无疆时间:"..v["无疆时间"], "盈久时间:"..v["盈久时间"], "酒时间:"..v["酒时间"], "恶狗CD:"..scdtime("惡狗攔路"), "蜀犬CD:"..scdtime("蜀犬吠日"), "亢龙CD:"..scdtime("亢龍有悔"), "酒CD:"..scdtime("酒中仙"), "时乘CD:"..scdtime("時乘六龍"))
			end
		end
	end

	--龙战
	--if gettimer("释放亢龙有悔") < 3.5 and nobuff("龍戰於野") and v["镇慑时间"] < 5 then
	if mana() > 0.6 and nobuff("5989|5985|5986|5987") and nobuff("龍戰於野") and v["镇慑时间"] < 5 then
		CastX("龍戰於野")
	end

	--蜀犬
	if mana() < 0.85 and scdtime("惡狗攔路") > 1 and v["酒中仙CD"] > 7 then
		CastX("蜀犬吠日")
	end

	--喝酒
	if mana() >= 0.35 and nobuff("5989|5985|5986|5987") then	--没有时乘2段, 蛟龙234段
		--if scdtime("蜀犬吠日") < 17.5 and scdtime("時乘六龍") < 9.4375 then
		if scdtime("時乘六龍") < 9.4375 then
			f["酒中仙"]()
		end
	end
	
	if v["酒中仙CD"] <= 0 and nobuff("5989|5985|5986|5987") then
		CastX("棒打狗頭")
		CastX("龍躍於淵")
	end
	
	CastX("斜打狗背")

	--正常不会打，备用回蓝
	CastX("按狗低頭")
	CastX("反截狗臀")
end

--释放技能
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		if SkillID == 5367 then		--蛟龙
			if bufftime("25904") > -1 and bufftime("25904") < 6.5 then	--有蛟影 时间不够打完一套 先取消
				cbuff("25904")
				print("--------------------------取消蛟影")
			end
			return
		end
		if SkillID == 5638 then		--亢龙
			settimer("释放亢龙有悔")
			return
		end
		if SkillID == 5257 then		--蜀犬
			settimer("释放蜀犬吠日")
			return
		end
		if SkillID == 6363 then	--龙游伤害2
			settimer("释放龙游2")
			return
		end
		if SkillID == 5368 then
			settimer("释放双龙取水")
			return
		end
	end
end
