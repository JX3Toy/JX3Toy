--[[ 奇穴: [淵衝][襲伐][雨積][放皓][電逝][擊懈][界破][長溯][渙衍][連亙][聚疏][瀲風]
秘籍:
行云  1会心 3伤害 
停云  1会心 2伤害 1调息
决云  2伤害 2会心
断云  1会心 2伤害 1距离
沧浪  2会心 2伤害
横云  2会心 2伤害
孤锋  2会心 2伤害
留客  1会心 2伤害 1距离

靠近目标4尺内一键开打就完事了
--]]


--关闭自动面向
setglobal("自动面向", false)

--宏选项
addopt("副本防开怪", false)

--变量表
local v = {}
v["输出信息"] = true

--函数表
local f = {}

--主循环
function Main()
	--按下自定义快捷键1挂扶摇, 注意是快捷键设定里面插件的快捷键1指定的按键，不是键盘上的1
	if keydown(1) then
		cast("扶搖直上")
	end

	--初始化变量
	v["锐意"] = energy()
	v["单手"] = buff("24029")
	v["双持"] = buff("24110")
	v["识破时间"] = bufftime("識破")	--24108
	v["目标破绽层数"] = tbuffsn("破綻", id())	--24056
	v["目标破绽时间"] = tbufftime("破綻", id())
	v["身形数量"] = 0
	v["身形时间"] = -100
	for i = 1, 3 do
		local nTime = bufftime("2410"..4 + i)	--24105 24106 24107
		v["身形"..i.."时间"] = nTime
		if nTime >= 0 then
			v["身形数量"] = v["身形数量"] + 1
			v["身形时间"] = nTime
		end
	end
	v["戗风时间"] = bufftime("戧風")	--24557

	v["停云CD"] = scdtime("停雲勢")
	v["决云CD"] = scdtime("訣雲勢")
	v["驰风CD"] = scdtime(32140)		--二段重名用ID
	v["灭影CD"] = scdtime("滅影追風")
	v["游风充能次数"] = cn("遊風飄蹤")
	v["游风充能时间"] = cntime("遊風飄蹤", true)
	v["横云CD"] = scdtime("橫雲斷浪")
	v["留客CD"] = cdtime("留客雨")
	
	--等待单双切换
	if gettimer("斷雲勢") < 0.3 or gettimer("孤鋒破浪") < 0.3 or (qixue("威聲") and gettimer("滅影追風") < 0.3) then
		PrintInfo("----------等待单双切换, ")
		return
	end

	--副本防开怪
	if getopt("副本防开怪") and dungeon() and nofight() then return end

	if v["单手"] then
		f["单手"]()
	end

	if v["双持"] then
		f["双持"]()
	end

end

f["单手"] = function()
	--留客雨
	if cdleft(2436) >= 1 or v["锐意"] >= 100 then
		CastX("留客雨")
	end

	--断云势
	if rela("敌对") and dis() < range("斷雲勢", true) and face() < 90 then
		if CastX("斷雲勢") then
			return
		end
	end

	--决云势
	if v["锐意"] <= 15 then
		CastX("訣雲勢")
	end

	--行3
	if qixue("電逝") and buff("滅影追風") then
		CastX("行雲勢")
	end
	
	--停云势
	if v["锐意"] <= 45 then
		CastX("停雲勢")
	end

	CastX("行雲勢")
end

f["双持"] = function()
	--孤锋破浪
	if rela("敌对") and dis() < 6 and face() < 90 then
		if tbuffsn("長溯", id()) > 2 then
			CastX("滅影追風")
			if CastX("孤鋒破浪") then
				return
			end
		end
	end

	--沧浪三叠
	if rela("敌对") and dis() < 6 and face() < 90 then
		CastX("滄浪三疊")
	end

	--横云断浪
	CastX("橫雲斷浪")
end

-------------------------------------------------------------------------------

--输出信息
function PrintInfo(s)
	local t = {}
	if s then t[#t+1] = s end
	t[#t+1] = "锐意:"..v["锐意"]
	t[#t+1] = "灭影:"..bufftime("滅影追風")
	t[#t+1] = "停云CD:"..v["停云CD"]
	t[#t+1] = "决云CD:"..v["决云CD"]
	t[#t+1] = "留客CD:"..v["留客CD"]
	t[#t+1] = "横云CD:"..v["横云CD"]
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
		if SkillID == 36118 then	--潋风·携刃
			print("OnCast->释放:"..SkillName..", 技能ID:"..SkillID..", 技能等级:"..SkillLevel..", 目标ID:"..TargetID..", 开始帧:"..StartFrame..", 当前帧:"..FrameCount)
		end
		
	end
end

--buff更新
function OnBuff(CharacterID, BuffName, BuffID, BuffLevel, StackNum, SkillSrcID, StartFrame, EndFrame, FrameCount)
	if CharacterID == id() then
		if StackNum  > 0 then		
			if BuffID == 24110 then		--双持
				deltimer("斷雲勢")
				deltimer("滅影追風")
				print("-------------------- 双持")
			end
			if BuffID == 24029 then		--单手
				deltimer("孤鋒破浪")
				print("-------------------- 单手")
			end
		end
	end
end
