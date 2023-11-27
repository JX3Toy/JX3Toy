--[[ 奇穴: [素矰][棘矢][襄尺][长右][鹿蜀][桑柘][于狩][卢令][托月][佩弦][贯侯][朝仪万汇]
秘籍:
劲风	2会心 2伤害
饮羽	2调息 1重置 1非侠
引风	3调息 1回血

开打前把蓝打坐回满, 不然起手弛律不会放, 引风的释放时机有点问题导致有的大循环少1次棘矢引爆, 怕循环卡的太死实战中少打引风蓝不够
--]]

load("Macro/Lib_PVP.lua")

--关闭自动面向
setglobal("自动面向", false)

--宏选项
addopt("副本防开怪", false)

--变量表
local v= {}
v["输出信息"] = true
v["没石次数"] = 0

--函数表
local f = {}

--主循环
function Main()
	if casting("饮羽簇") and castleft() < 0.13 then
		settimer("饮羽簇读条结束")
	end
	if gettimer("饮羽簇读条结束") < 0.3 then return end

	--初始化变量
	v["弓箭"] = rage()
	v["幻灵印"] = beast()
	
	v["饮羽CD"] = scdtime("饮羽簇")
	v["白羽CD"] = scdtime("白羽流星")
	v["金乌充能次数"] = cn("金乌见坠")
	v["金乌充能时间"] = cntime("金乌见坠", true)
	v["引风CD"] = scdtime("引风唤灵")
	v["弛律CD"] = scdtime("弛律召野")
	v["朝仪CD"] = scdtime("朝仪万汇")

	v["承契层数"] = buffsn("承契")
	v["承契时间"] = bufftime("承契")
	v["贯穿层数"] = tbuffsn("贯穿", id())
	v["贯穿时间"] = tbufftime("贯穿", id())
	v["标鹄层数"] = tbuffsn("标鹄")
	v["标鹄时间"] = tbufftime("标鹄", id())
	v["目标血量较多"] = rela("敌对") and tlifevalue() > lifemax() * 10


	--设置动物
	if not nextbeast("鹰") then		--只召鹰
		setbeast( { "鹰", "虎", "狼", "大象", "野猪", "熊" } )
	end

	--澄神醒梦
	v["被控时间"] = math.max(buffstate("定身时间"), buffstate("眩晕时间"), buffstate("击倒时间"))
	if v["被控时间"] - cdleft(16) > 1 then
		CastX("澄神醒梦")
	end

	--应天授命
	if fight() and life() < 0.55 then
		CastX("应天授命")
	end

	--寒更晓箭
	if v["弓箭"] < 8 then
		if nofight() then		--没进战把箭装满
			CastX("寒更晓箭")
		end

		if v["弓箭"] < 1 then	--没箭了装箭, 自动装箭会比GCD晚1帧, 自己装, 抢不过也没影响, 抢过了还能快1帧
			CastX("寒更晓箭")
		end
	end

	--副本防开怪
	if getopt("副本防开怪") and dungeon() and nofight() then return end

	--金乌见坠
	if v["弓箭"] >= 8 then		--满箭才用
		if rela("敌对") and dis() < 30 then
			v["最后一支箭状态"] = arrow(7)
			if v["最后一支箭状态"] ~= 2 and v["最后一支箭状态"] ~= 4 then	--最后一支箭没金乌
				CastX("金乌见坠")
			end
			
			if v["金乌充能次数"] >= 3 and bufftime("佩弦") < 0 and v["饮羽CD"] < 1 then	--充能满了没瞬发
				CastX("金乌见坠")
			end
		end
	end

	--没石饮羽
	if buff("26862") then
		CastX("没石饮羽")
	end

	--棘矢处理
	if qixue("棘矢") then
		if gettimer("释放没石饮羽") < 2 and v["弓箭"] == 2 then	--没石后把箭打到1
			CastX("劲风簇")
		end
	end

	--饮羽簇
	if v["弓箭"] >= 8 and v["承契时间"] < 2.5 then	--起手打承契
		CastX("饮羽簇")
	end
	if v["弓箭"] == 5 or v["弓箭"] == 6 then	--循环内
		CastX("饮羽簇")
	end

	--弛风鸣角
	if buff("26861") and v["弓箭"] >= 3 then
		if v["弓箭"] == 3 then	--最后3箭
			CastX("弛风鸣角")
		end

		if v["弓箭"] == 8 and v["引风CD"] < 4.5 and v["饮羽CD"] < cdinterval(16) then	--这个小节打引风
			CastX("弛风鸣角")
		end
	end

	--引风唤灵, 和目标的角色距离大于20尺是在自己附近放
	if fight() and rela("敌对") and dis3() < 20 then
		CastX("引风唤灵")
	end
	
	--弛律召野
	if fight() and rela("敌对") and dis3() < 20 then
		if v["承契层数"] < 5 and mana() > 0.8 then	--起手打承契
			CastX("弛律召野")
		end
	end

	--朝仪万汇
	if v["目标血量较多"] and v["承契时间"] > 12 and v["弓箭"] < 5 then
		if gettimer("释放寒更晓箭") < 0.5 or v["弓箭"] > 0 then	--GCD刚转完, 放朝仪开始引导, 自动的寒更晓箭放不出来
			if v["弓箭"] ~= 1 or gettimer("释放没石饮羽") > 2.5 or v["没石次数"] >= 3 then	--防止卡掉没石后续2跳
				CastX("朝仪万汇")
			end
		end
	end

	--劲风簇
	if qixue("棘矢") and v["弓箭"] == 1 then	--最后1支箭
		if gettimer("释放没石饮羽") > 1.75 or v["没石次数"] >= 2 then	--没石2跳之后
			CastX("劲风簇")
		end
	else
		CastX("劲风簇")
	end


	if nofight() then
		g_func["采集"]()
	end
	--[[
	if fight() and rela("敌对") and dis() < 25 and cdleft(16) <= 0 and castleft() <= 0 and gettimer("朝仪万汇") > 0.5 and gettimer("弛风鸣角") > 0.5 then
		PrintInfo("---------- 没打技能")
	end
	--]]
end

-------------------------------------------------------------------------------

--输出信息
function PrintInfo(s)
	local t = {}
	if s then t[#t+1] = s end
	t[#t+1] = "弓箭:"..v["弓箭"]
	t[#t+1] = "内力:"..mana()
	--t[#t+1] = "幻灵印:"..v["幻灵印"]

	t[#t+1] = "承契:"..v["承契层数"]..", "..v["承契时间"]
	t[#t+1] = "贯穿:"..v["贯穿层数"]..", "..v["贯穿时间"]
	t[#t+1] = "标鹄:"..v["标鹄层数"]..", "..v["标鹄时间"]
	
	t[#t+1] = "饮羽CD:"..v["饮羽CD"]
	t[#t+1] = "白羽CD:"..v["白羽CD"]
	t[#t+1] = "引风CD:"..v["引风CD"]
	--t[#t+1] = "弛律CD:"..v["弛律CD"]
	t[#t+1] = "朝仪CD:"..v["朝仪CD"]
	t[#t+1] = "金乌CD:"..v["金乌充能次数"]..", "..v["金乌充能时间"]

	print(table.concat(t, ", "))
end

--使用技能并输出信息
function CastX(szSkill, bSelf)
	if cast(szSkill, bSelf) then
		settimer(szSkill)
		if v["输出信息"] then PrintInfo() end
		return true
	end
	return false
end

-------------------------------------------------------------------------------

--释放技能
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		if SkillID == 35665 then	--没石饮羽
			v["没石次数"] = 0
			settimer("释放没石饮羽")
		end

		if SkillID == 35987 then	--没石每跳子技能
			v["没石次数"] = v["没石次数"] + 1
		end

		if SkillID == 36165 then
			print("----------棘矢引爆")
		end

		if	SkillID == 35695 then	--引风唤灵
			settimer("释放引风唤灵")
		end

		if SkillID == 35669 then	--寒更晓箭
			settimer("释放寒更晓箭")
			print("----------------------------------------寒更晓箭换箭")
		end

		if SkillID == 35661 then	--饮羽簇
			deltimer("饮羽簇读条结束")
		end
	end
end

--战斗状态改变, 日志记录一下用于分析数据
function OnFight(bFight)
	if bFight then
		print("--------------------进入战斗")
	else
		print("--------------------离开战斗")
	end
end
