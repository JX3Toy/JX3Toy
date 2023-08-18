--[[ 奇穴:[血影留痕][天风汲雨][弩击急骤][千机之威][天罗地网][聚精凝神][化血迷心][雷甲三铉][秋风散影][回肠荡气][曙色催寒][千秋万劫]
秘籍:
暴雨	1会心 2伤害 1效果
蚀肌弹	2读条 2伤害
天绝	3伤害 1范围
暗藏	1会心 3伤害
--]]

--关闭自动面向
setglobal("自动面向", false)

--宏选项
addopt("副本防开怪", false)
addopt("手动爆发", false)

--变量表
local v = {}
v["输出信息"] = true

--主循环
function Main()
	--鬼斧防打断
	if gettimer("鬼斧神工") < 0.5 or gettimer("释放鬼斧") < 2 or casting("鬼斧神工") then
		return
	else
		nomove(false)		--允许移动
	end

	--减伤
	if fight() and life() < 0.5 then
		cast("惊鸿游龙")
	end

	--初始化变量
	v["神机值"] = energy()
	v["千秋CD"] = scdtime("千秋万劫")
	v["千秋二段CD"] = scdtime("千秋万劫·开火")
	v["千秋时间"] = bufftime("千秋万劫")
	v["暗藏CD"] = scdtime("暗藏杀机")
	v["天绝CD"] = scdtime("天绝地灭")
	v["GCD"] = cdleft(16)
	local tSpeedXY, tSpeedZ = speed(tid())
	v["目标静止"] = rela("敌对") and tSpeedXY <= 0 and tSpeedZ <= 0
	v["目标血量较多"] = rela("敌对") and tlifevalue() > lifemax() * 10
	
	--目标不是敌对, 结束
	if not rela("敌对") then return end

	--放弩
	if dis() < 20 then
		if nopuppet() or xxdis(pupid(), tid()) > 25 then		--没有弩或者弩和目标超过25尺
			CastX("千机变", true)
		end

		--连弩
		if puppet("机关千机变底座|机关千机变重弩") then
			CastX("连弩形态")
		end

		--时间快到了，换重弩
		if puppet("机关千机变连弩") and gettimer("释放连弩") > 116.5 then
			CastX("重弩形态")
		end
	end

	--副本防开怪
	if getopt("副本防开怪") and dungeon() and nofight() then return end

	--弩攻击
	if puppet("机关千机变连弩|机关千机变重弩") and puptid() ~= tid() and xxdis(pupid(), tid()) < 25 and xxvisible(pupid(), tid()) then
		CastX("攻击")
	end

	--暗藏杀机
	CastX("暗藏杀机")

	--千秋二段
	if bufftime("千秋万劫") > 0 then
		CastX("千秋万劫·开火")
	end

	--心无绑定鬼斧
	if gettimer("释放鬼斧") < 5 or bufftime("扬威") > 13 then
		CastX("心无旁骛")
	end

	--鬼斧
	if not getopt("手动爆发") and puppet("机关千机变连弩") and xdis(pupid()) < 4 and gettimer("释放连弩") < 100 then	--弩的剩余时间大于20秒
		if v["目标静止"] and v["目标血量较多"] and xxdis(pupid(), tid()) < 25 and v["千秋CD"] < 4 then
			if CastX("鬼斧神工") then
				stopmove()			--停止所有移动
				nomove(true)		--禁止移动
				exit()				--中断脚本执行
			end
		end
	end

	--千秋万劫
	CastX("千秋万劫")

	--天女散花 上dot
	if tnobuff("化血", id()) then
		CastX("天女散花")
	end

	--图穷匕见
	_, v["暗藏杀机数量"] = tnpc("关系:自己", "模板ID:16000", "平面距离<6")
	if v["暗藏杀机数量"] >= 3 then
		CastX("图穷匕见")
	end

	--天绝地灭
	if v["目标静止"] then
		CastX("天绝地灭")
	end

	--天女散花 群攻
	_, v["目标10尺敌人数量"] = tnpc("关系:敌对", "距离<10", "可选中")
	if v["目标10尺敌人数量"] >= 3 then
		CastX("天女散花")
	end

	--暴雨梨花针
	if v["千秋CD"] >= 2 then
		if gettimer("千秋万劫·开火") < 0.5 or v["千秋二段CD"] >= 2 or v["千秋二段CD"] >= v["千秋时间"] then
			CastX("暴雨梨花针")
		end
	end

	--蚀肌弹
	if v["千秋CD"] >= 1 and v["暗藏CD"] > 0.5 then
		if gettimer("千秋万劫·开火") < 0.5 or v["千秋二段CD"] >= 1 or v["千秋二段CD"] >= v["千秋时间"] then
			CastX("蚀肌弹")
		end
	end

	--天女散花
	if v["千秋CD"] > 1 then
		CastX("天女散花")
	end

	--没打技能输出信息
	if rela("敌对") and fight() and dis() < 20 and cdleft(16) <= 0 and castleft() <= 0 and gettimer("千机变") > 0.3 and gettimer("暴雨梨花针") > 0.3 and gettimer("蚀肌弹") > 0.3 then
		PrintInfo("----------没放技能, ")
	end
end

--输出信息
function PrintInfo(s)
	local szinfo = "神机值:"..v["神机值"]..", GCD:"..v["GCD"]..", 千秋CD:"..v["千秋CD"]..", 千秋二段CD:"..v["千秋二段CD"]..", 千秋时间:"..v["千秋时间"]..", 扬威:"..bufftime("扬威")..", 当前帧:"..frame()
	if s then
		szinfo = s..szinfo
	end
	print(szinfo)
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

--释放技能
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		if SkillID == 3368 then	--连弩形态
			settimer("释放连弩")
		end
		if SkillID == 3110 then
			settimer("释放鬼斧")
		end
	end
end
