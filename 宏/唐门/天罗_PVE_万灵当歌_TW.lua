--[[ 奇穴: [血影留痕][天風汲雨][弩擊急驟][擘兩分星][流星趕月][聚精凝神][化血迷心][殺機斷魂][秋風散影][雀引彀中][曙色催寒][詭鑑冥微]
秘籍:
暴雨  1会心 2伤害 1效果
肌彈  2读条 2伤害
天絕  3伤害 1范围
埋蛋  1会心 3伤害

--]]

--变量表
local v = {}
v["输出信息"] = true

--宏选项
addopt("副本防开怪", false)

function Main(g_player)
	-- 按下自定义快捷键1交扶摇
	if keydown(1) then
		cast("扶搖直上")
	end
	
	--防止打断鬼斧
	if gettimer("鬼斧神工") < 0.5 or lasttime("鬼斧神工") < 2 or casting("鬼斧神工") then
		if castprog() > 0.1 and puppet("機關千機變連弩") and gettimer("释放连弩") > 5 then --读条鬼斧切弩续弩的时间
			fcast("重弩形態")
		end
		return
	else
		nomove(false)		--允许移动
	end
	
	--减伤
	if fight() and life() < 0.5 then
		cast("惊鸿游龙")
	end

	if not rela("敌对") then return end
	
	--初始化变量
	local speedXY, speedZ = speed(tid())
	v["目标静止"] = rela("敌对") and speedXY <= 0 and speedZ <= 0
	
	v["GCD"] = cdleft(16)
	
	v["神机值"] = energy()
	
	
	v["鬼斧CD"] = scdtime("鬼斧神工")
	v["天絕CD"] = scdtime("天絕地滅")
	v["飛星充能次数"] = cn("飛星遁影")
	v["暴雨充能次数"] = cn("暴雨梨花針")
	v["詭鑑充能次数"] = cn("詭鑑冥微")
	v["詭鑑当前充能时间"] = cntime("詭鑑冥微")
	v["詭鑑充能总时间"] = cntime("詭鑑冥微", true)
	
	v["心無时间"] = bufftime("心無旁騖")
	v["天绝伤害内置buff"] = bufftime("27578")
	v["化血持续时间"] = tbufftime("化血", id())
	
	_, v["暗藏杀机数量"] = tnpc("关系:自己", "名字:機關暗藏殺機", "距离<6")
	_, v["天绝数量"] = npc("关系:自己", "模板ID:15994")
	
	_, v["场上所有诡鉴数量"] = npc("名字:詭鑑冥微")   -- 场上任何形态的鬼鉴数量
	_, v["没CD诡鉴数量"] = npc("名字:詭鑑冥微", "buff时间:24389 < -1") -- 没进入拟态CD的鬼鉴数量
	_, v["可拟态诡鉴数量"] = npc("名字:詭鑑冥微", "buff时间:24389|24391 < -1") --没进入拟态CD切没有拟态天绝的鬼鉴数量
	
	v["目标血量较多"] = rela("敌对") and tlifevalue() > lifemax() * 10	--目标当前血量大于自己最大血量10倍
	
	--副本防开怪
	if getopt("副本防开怪") and dungeon() and nofight() then
		return
	end
	
	--鬼斧
	if dis() < 20 and puppet("機關千機變連弩") and gettimer("释放连弩") < 115 then   --距离小于20尺,有连弩切连弩剩余时间大于5秒
		if xdis(pupid()) < 4 and v["目标血量较多"] and v["詭鑑充能总时间"] < 8 and v["暗藏杀机数量"] >= 1 then --到连弩的距离小于4尺,目标血量较多(可自己调整),鬼鉴充能总时间小于8秒,至少有一个蛋
			if cast("鬼斧神工", true) then
				stopmove()			--停止所有移动
				nomove(true)		--禁止移动
				settimer("鬼斧神工")
				exit()				--中断脚本执行
			end
		end
	end
	
	--没有可拟态诡鉴放蛋
	if gettimer("诡鉴冥微") > 0.5 and gettimer("释放诡鉴冥微") > 2 and v["可拟态诡鉴数量"] <= 0 then
		if cast("暗藏殺機") then
			settimer("暗藏殺機")
		end
	end
	
	--放弩
	if dis() < 20 then
		if nopuppet() or xxdis(pupid(), tid()) > 25 or (xdis(pupid()) > 4 and v["鬼斧CD"] <= 2) then
			cast("千機變", true)
		end

		if puppet("機關千機變底座|機關千機變重弩") then
			fcast("連弩形態")
		end

		if puppet("機關千機變連弩") and gettimer("释放连弩") > 115 then
			fcast("重弩形態")
		end
	end
	
	-- 心无绑定鬼斧
	if gettimer("释放鬼斧") < 5 then
		cast("心無旁騖")
	end
	
	-- 起手开弩 罡风吃秋风
	if puppet("機關千機變連弩|機關千機變重弩") and v["鬼斧CD"] > 0 and scdtime("心無旁騖") > 0 and puptid() ~= tid() and xxdis(pupid(), tid()) < 25 and xxvisible(pupid(), tid()) then
		cast("攻擊")
		cast("罡風鏢法")
	end
	
	--孔雀绑定爆蛋
	if v["暗藏杀机数量"] <= 1 and gettimer("圖窮匕見") < 2 then
		if CastX("孔雀翎") then
			settimer("孔雀翎")
		end
	end
	
	
	--爆发循环
	if (buff("揚威") and buff("心無旁騖")) or gettimer("释放鬼斧") < 5 then
		-- 天绝
		if v["天絕CD"] <= 0 then
			if CastX("天絕地滅") then
				settimer("天絕地滅")
			end
		end
		
		--鬼鉴
		if v["天絕CD"] > 0 and gettimer("诡鉴冥微") > 2.5 and v["GCD"] <= 0 then --天绝进入CD,GCD为零,2.5秒没交过鬼鉴(防止鬼鉴连交)
			if v["詭鑑充能次数"] > 1 then
				if CastX("詭鑑冥微") then
					settimer("诡鉴冥微")
					return
				end
			end
			if v["詭鑑充能次数"] > 0 and gettimer("释放天绝持续效果") > 0.5 and v["天绝伤害内置buff"] <= 0.4 then --增加判定是为了卡47跳,可根据自己的延迟上下调整
				if CastX("詭鑑冥微") then
					settimer("诡鉴冥微")
					return
				end
			end
		end
		
		--蹭心无爆蛋
		if v["心無时间"] < 0.5 then 
			if CastX("圖窮匕見") then
				settimer("圖窮匕見")
			end
		end
		
		--暴雨
		if v["天絕CD"] > 0 and v["詭鑑充能次数"] <= 0 and v["詭鑑当前充能时间"] > 5 and gettimer("暴雨梨花針") > 3 and v["心無时间"] > 3 then --心无期间天诡天交完后填充伤害,防止连交以及最后给爆蛋留时间
			if CastX("暴雨梨花針") then
				settimer("暴雨梨花針")
			end
		end
		
		--飞星控神机
		if v["飛星充能次数"] > 0 and v["天絕CD"] > 0 and v["詭鑑充能次数"] <= 0 and v["天绝伤害内置buff"] <= 1 and v["神机值"] > 75 and gettimer("飛星遁影") > 1.5 then
			if CastX("飛星遁影") then
				settimer("飛星遁影")
			end
		end
		
		--填充伤害
		if v["天絕CD"] > 0 and v["詭鑑充能次数"] <= 1 and v["詭鑑当前充能时间"] > 5 then
			if gettimer("天女散花") > 3 then
				if CastX("天女散花") then
					settimer("天女散花")
				end
			end
			if v["心無时间"] < 4 and v["心無时间"] > 2 then
				if CastX("天女散花") then
					settimer("天女散花")
				end
			end
		end
		return
	end
	
	--非爆发循环
	
	--天绝
	v["放天絕"] = false
	
	if v["天絕CD"] <= 0 and v["目标静止"] and (v["鬼斧CD"] > 7 or gettimer("诡鉴冥微") < 2 or not v["目标血量较多"]) then --尽量不拖鬼斧CD,天诡天连招绑定
		
		if v["可拟态诡鉴数量"] > 1 then 
			v["放天絕"] = true
		end
		
		if v["可拟态诡鉴数量"] == 1 and v["没CD诡鉴数量"] == 1 then
			v["放天絕"] = true
		end
		
		if v["场上所有诡鉴数量"] <= 0 then
			v["放天絕"] = true
		end
		
		if v["放天絕"] then
			if casting("暴雨梨花針|蝕肌彈") and v["GCD"] <= 0 then --天绝满足条件打断读条
				stopcasting()
				return
			end
			if v["神机值"] <= 55 and gettimer("诡鉴冥微") > 3 then --预防天诡天神机值不够
				return
			end
			if CastX("天絕地滅") then
				settimer("天絕地滅")
			end
		end
	end
	
	--鬼鉴
	if v["天絕CD"] > 0 and gettimer("诡鉴冥微") > 8 and v["GCD"] <= 0 and v["鬼斧CD"] < 42 and (v["鬼斧CD"] > 7 or gettimer("天絕地滅") < 3) then
		if gettimer("释放天绝") < 3.5 and gettimer("释放天绝") > 2.3 then --增加判定是为了卡21跳,可根据自己的延迟上下调整
			if CastX("詭鑑冥微") then
				settimer("诡鉴冥微")
			end
			return
		end
	end
	
	--爆蛋
	if v["暗藏杀机数量"] >= 3 then
		if v["天绝数量"] <= 0 and v["詭鑑充能总时间"] > 8 then
			if v["天絕CD"] > 4 then
				if CastX("圖窮匕見") then
					settimer("圖窮匕見")
				end
			end
			if scdtime("孔雀翎") <= 1.5 then
				if CastX("圖窮匕見") then
					settimer("圖窮匕見")
				end
			end
		end
		
		if v["天绝数量"] > 1 and scdtime("孔雀翎") <= 1.5 then
			if gettimer("释放天绝") < 1.5 then
				if CastX("圖窮匕見") then
					settimer("圖窮匕見")
				end
			end
			if v["天绝伤害内置buff"] > 2 then
				if CastX("圖窮匕見") then
					settimer("圖窮匕見")
				end
			end
		end
	end
	
	-- 填充伤害 控神机
	
	if gettimer("天絕地滅") > 2 and v["天绝数量"] <= 0 and v["暴雨充能次数"] > 0 and gettimer("暴雨梨花針") > 3.5 and v["天絕CD"] > 0 then
		if CastX("暴雨梨花針") then
			settimer("暴雨梨花針")
		end
	end
	
	if v["神机值"] > 70 and v["天絕CD"] > 0 then
		if gettimer("诡鉴冥微") < 3 and gettimer("释放天绝") < 1 then
			deltimer("释放天绝")
		end
		
		if v["詭鑑充能次数"] > 0 and gettimer("释放天绝") < 3.5 then
			return
		end
		
		if state("站立") and v["化血持续时间"] > 9 then
			CastX("蝕肌彈")
		end
		
		CastX("天女散花")
	end
	
end

--使用技能并输出信息
function CastX(szSkill)
	if cast(szSkill) then
		if v["输出信息"] then 
			PrintInfo()
		end
		return true
	end
	return false
end

--输出信息
function PrintInfo(s)
	local szinfo = "GCD:"..v["GCD"]..", 天绝伤害内置buff:"..v["天绝伤害内置buff"]..", 心無时间:"..v["心無时间"]..", 神机值:"..v["神机值"]..", 天絕CD:"..v["天絕CD"]..", 詭鑑充能次数:"..v["詭鑑充能次数"]..", 鬼斧CD:"..v["鬼斧CD"]..""
	if s then
		szinfo = s..szinfo
	end
	print(szinfo)
end


--释放技能
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		if SkillName == "詭鑑冥微" then
			settimer("释放诡鉴冥微")
		end
		if SkillName == "連弩形態" then
			settimer("释放连弩")
		end
		
		if SkillName == "心無旁騖" then
			settimer("释放心無旁騖")
			return
		end
		if SkillID == 3110 then
			settimer("释放鬼斧")
			return
		end
		if SkillID == 3301 then
			settimer("释放天绝持续效果")
			return
		end
		if SkillID == 3108 then
			settimer("释放天绝")
		end
		--print(xname(CasterID).. "释放技能:"..SkillName..", 技能ID:"..SkillID..", 技能等级:"..SkillLevel..", 目标类型"..TargetType..",目标是谁"..TargetID..",坐标y"..PosY..",坐标z"..PosZ)
	end
end

--buff更新
function OnBuff(CharacterID, BuffName, BuffID, BuffLevel, StackNum, SkillSrcID, StartFrame, EndFrame, FrameCount)
	if CharacterID == id() then
		if StackNum > 0 and BuffID == 25901 and bufflv("26055") == 6 then	--添加buff 白雨跳珠
			deltimer("暴雨读条结束")
		end
		
		--print(xname(CharacterID).. "添加buff:"..BuffName..", buffID:"..BuffID..", buff等级:"..BuffLevel..", 目标类型"..StackNum)
	end
	
	
end
