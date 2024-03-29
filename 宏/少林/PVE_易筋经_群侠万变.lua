--[[ 奇穴: [明法][幻身][纷纭][缩地][降魔渡厄][金刚怒目][净果][三生][众嗔][华香][金刚日轮][业因]
秘籍:
普渡	2调息 2伤害
韦陀	1会心 2伤害 1效果
横扫	1伤害 1消耗 1持续 1目标
捕风	2调息 2伤害
守缺	1会心 3伤害
拿云	1效果 3伤害
狮子吼	3调息 1效果
无相	2调息 1减伤 1持续

--每次打过千斤坠往后退点，卡3尺左右距离
--]]

--关闭自动面向
setglobal("自动面向", false)

--变量表
local v = {}

--函数表
local f = {}

--释放禅那变动技能
local CastX = function(szSkill, szReason)
	if cast(szSkill) then
		--if szReason then print(szReason) end
		settimer("等待禅那同步")
		exit()
	end
end

--主循环
function Main()
	--减伤
	if fight() and life() < 0.5 and buffstate("减伤效果") < 40 then
		cast("无相诀")
	end

	--等待禅那同步
	if gettimer("等待禅那同步") < 0.3 then return end

	--初始化变量
	v["禅那"] = qidian()
	v["阵法时间"] = bufftime("21619") - 12
	v["无取时间"] = bufftime("23069")
	v["无舍时间"] = bufftime("23070")
	v["金刚日轮阵"] = npc("关系:自己", "模板ID:107539")
	v["阵法内敌人数量"] = 0
	if v["金刚日轮阵"] ~= 0 then
		_, v["阵法内敌人数量"] = xnpc(v["金刚日轮阵"], "关系:敌对", "距离<8", "可选中")
	end
	v["龙爪功次数"] = buffsn("24454")
	v["目标血量较多"] = rela("敌对") and tlifevalue() > lifemax() * 5
	v["没吃到阵"] = v["阵法时间"] < 0 or nobuff("金刚日轮")

	---------------------------------------------开始输出
	v["放无取无舍"] = false

	--罗汉金身
	if rela("敌对") and dis() < 8 and v["禅那"] >= 3 and cdleft(16) < 1 then
		if cast("罗汉金身") then
			v["禅那"] = 0
			v["放无取无舍"] = true
		end
	end

	--二业依缘_伏魔
	if rela("敌对") and dis() < 5 and nobuff("24620") and v["禅那"] <= 1 then		--24620 业因四次无CD
		CastX(15166, "阵法时间: "..v["阵法时间"]..", 横扫CD: "..scdtime("横扫六合")..", 千斤坠CD:"..scdtime("千斤坠"))
	end

	--拿云韦陀
	if v["禅那"] >= 3 then
		if cast("拿云式") then
			v["放无取无舍"] = true
		end
		if cast("韦陀献杵") then
			v["放无取无舍"] = true
		end
	end

	if v["放无取无舍"] then
		if v["无取时间"] >= 0 and v["无取时间"] < 6.5 then
			f["千斤坠·无取"]("无取 拿云韦陀后面")
		end

		if v["无舍时间"] >= 0 and v["无舍时间"] < 6.5 and bufftime("21619") < 0 then
			f["千斤坠·无舍"]("无舍 拿云韦陀后面")
		end

		settimer("等待禅那同步")
		exit()
	end

	f["业因横扫守缺"]()

	if v["无取时间"] > 0 then
		f["横扫六合"]()
	
		if v["无取时间"] <= cdinterval(16) and cdleft(16) >= 1 then
			f["千斤坠·无取"]("时间小于1CD")
		end
	end

	if v["无舍时间"] > 0 then
		if v["无舍时间"] <= cdinterval(16) * 2 or scdtime("横扫六合") <= cdinterval(16) then
			if buff("21617") then
				if tbufftime("普渡") <= cdinterval(16) * 4 then
					CastX("普渡四方", "保普渡, 横扫CD: "..scdtime("横扫六合"))
				end
			end
		end
		
		if cdleft(16) >= 1 then
			if v["没吃到阵"] then
				f["千斤坠·无舍"]("没吃到阵")
			end

			if v["无舍时间"] <= cdinterval(16) then
				f["千斤坠·无舍"]("时间小于1CD")
			end
		end
	end

	if v["无取时间"] <= 0 and v["无舍时间"] <= 0 and v["阵法时间"] > 0 then
		--二业依缘_袈裟
		if rela("敌对") and dis() < 5 and face() < 60 and v["目标血量较多"] then
			--if scdtime("横扫六合") < cdleft(16) and cdtime("守缺式") < cdinterval(16) * 2 and v["禅那"] < 3 then
			if v["禅那"] < 3 and v["阵法时间"] > cdinterval(16) * 9 then
				if cast(15165) then
					CastX("擒龙诀")
				end
			end
		end

		if v["阵法时间"] <= cdinterval(16) * 2 then
			f["普渡四方"]("阵法时间快到了")
			--CastX("普渡四方", "阵法时间快到了")
		end

		if scdtime("千斤坠") < cdinterval(16) and scdtime("横扫六合") < cdinterval(16) * 2 then
			f["普渡四方"]("千斤坠和横扫冷却了")
			--CastX("普渡四方", "千斤坠和横扫冷却了")
		end

		if v["阵法时间"] > 12 - cdinterval(16) then
			f["横扫六合"]()
		end
	end

	--千斤坠
	if rela("敌对") and face() < 60 then
		if v["没吃到阵"] then
			CastX("千斤坠", "没吃到阵")
		end
		if scdtime("横扫六合") < cdinterval(16) then
			CastX("千斤坠", "横扫冷却")
		end
	end

	---------------------------------------------

	--捉影式
	if buff("捕风式") and cdleft(16) >= 1 then
		if buff("擒龙诀") and v["禅那"] < 2 or v["禅那"] < 3 then
			CastX("捉影式")
		end
	end

	CastX("守缺式")

	if buff("金刚日轮") then
		CastX("捕风式")
	end

	--大狮子吼 回禅那
	if v["禅那"] <= 1 and miji("大狮子吼", "《袈裟伏魔功·大狮子吼》人偶图残页") then
		_, v["6尺内敌人数量"] = npc("关系:敌对", "距离<6", "可选中")
		if v["6尺内敌人数量"] >= 3 then
			CastX("大狮子吼")
		end
	end

	--没技能打了回禅那
	if nobuff("擒龙诀") then
		if v["禅那"] <= 1 then
			CastX("摩诃无量")
		end
		if nobuff("金刚日轮") then
			CastX("普渡四方", "回禅那")
		end
	end
end

f["横扫六合"] = function(szReason)
	if rela("敌对") and dis() < 5.5 then
		CastX("横扫六合", szReason)
	end
end

f["普渡四方"] = function(szReason)
	if buff("21617") and v["阵法内敌人数量"] > 0 then	--21617, 打过横扫
		CastX("普渡四方", "普渡, 爆阵法")
	end
		
	if tbufftime("普渡") <= cdinterval(16) * 4 then
		CastX("普渡四方", "普渡, 保普渡")
	end
end

f["业因横扫守缺"] = function()
	if buff("24620") then		--业因四次无CD
		if tbufftime("横扫六合") < 3.5 then
			f["横扫六合"]("业因横扫")
		end
		
		if v["龙爪功次数"] < 2 then
			if buffsn("24294") < 2 then
				f["横扫六合"]("业因横扫")
			end
			if buffsn("24292") < 2 then
				CastX("守缺式","业因守缺")
			end
		else
			if buffsn("24292") < 2 then
				CastX("守缺式","业因守缺")
			end
			if buffsn("24294") < 2 then
				f["横扫六合"]("业因横扫")
			end
		end
		exit()
	end
end

f["千斤坠·无取"] = function(szReason)
	if rela("敌对") and dis() < 5 and face() < 60 then
		CastX("千斤坠·无取", szReason)
	end
end

f["千斤坠·无舍"] = function(szReason)
	if rela("敌对") and dis() < 5 and face() < 60 then
		CastX("千斤坠·无舍", szReason)
	end
end

--气点更新
function OnQidianUpdate()
	--print("OnQidianUpdate, 气点: "..math.min(qidian(), 3))
	deltimer("等待禅那同步")
end

--释放技能
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		if SkillID == 29516 then
			print("金刚日轮阵被引爆")
			return
		end
	end
end

local tBuff = {
[23069] = "无取",
[23070] = "无舍",
[21619] = "阵法",
}

--buff更新
function OnBuff(CharacterID, BuffName, BuffID, BuffLevel, StackNum, SkillSrcID, StartFrame, EndFrame, FrameCount)
	--输出自己buff信息
	if CharacterID == id() then
		local szName = tBuff[BuffID]
		if szName then
			if StackNum  > 0 then
				print("OnBuff->添加buff: ".. szName..", ID: "..BuffID..", 等级: "..BuffLevel..", 层数: "..StackNum..", 源ID: "..SkillSrcID..", 开始帧: "..StartFrame..", 当前帧: "..FrameCount..", 结束帧: "..EndFrame..", 剩余时间: "..(EndFrame-FrameCount)/16)
			else
				print("OnBuff->移除buff: ".. szName..", ID: "..BuffID..", 等级: "..BuffLevel..", 层数: "..StackNum..", 源ID: "..SkillSrcID..", 开始帧: "..StartFrame..", 当前帧: "..FrameCount)
			end
		end
	end
end
