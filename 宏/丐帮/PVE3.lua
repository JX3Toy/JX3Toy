output("奇穴: [玄黄][益元][自强][无疆][克己][越渊][温酒][驯致][贞固][息元][饮江][潜龙勿用]")

--宏选项
addopt("副本防开怪", true)

--变量表
local v = {}
v["等待蓝同步"] = false

--主循环
function Main(g_player)
	--等待酒中仙读条结束后蓝同步, 蓝没同步，打不出无疆
	if casting("酒中仙") then
		if castleft() < 0.13 then
			settimer("酒中仙读条结束")
			v["等待蓝同步"] = true
		end
		return
	end
	if mana() >= 0.7 then
		v["等待蓝同步"] = false
	end
	if v["等待蓝同步"] and gettimer("酒中仙读条结束") < 0.5 then
		print("等蓝同步")
		return
	end

	--目标不是敌对结束
	if not rela("敌对") then return end

	--副本防开怪
	if getopt("副本防开怪") and dungeon() and nofight() then return end

	--减伤
	if fight() and life() < 0.5 then
		cast("龙啸九天")
	end

	--喝酒
	if nobuff("酣畅淋漓") or (bufftime("无疆") < 2 and mana() > 0.2) then
		if cast("酒中仙") then
			stopmove()			--停止移动
			settimer("酒中仙")
			return
		end
	end

	--龙跃龙战
	if buff("18082") then		--益元3秒标记
		cast("龙战于野")
		cast("龙跃于渊")
	end

	if nobuff("益元") and mana() > 0.375 and bufftime("酣畅淋漓") > 12 then
		if cdtime("龙战于野") < 1 then
			cast("龙跃于渊")
		end
		if cdtime("龙跃于渊") < 1 then
			cast("龙战于野")
		end
	end

	--亢龙
	cast("亢龙有悔")

	if bufftime("益元") > 1 then
		cast("拨狗朝天")
	else
		--潜龙
		--if buffsn("潜龙勿用·乾") >= 7 and bufftime("潜龙勿用·乾") > 1.8 then
		--	cast(18678)		--[驯致]潜龙勿用, 用名字有点问题
		--end
		if bufftime("潜龙勿用·乾") > 1.75 then
			if buffsn("潜龙勿用·乾") >= 7 or (buffsn("潜龙勿用·乾") >= 6 and bufftime("12522") < 3.125) then
				cast(18678)
			end
		end

		--恶狗
		if dis() < 6 and face() < 90 then
			cast("恶狗拦路")
		end

		--犬牙
		if dis() < 6 then
			cast("犬牙交错")
		end

		--保底回蓝
		cast("拨狗朝天")
		cast("横打双獒")
	end

	--棒打

end

--[[
local tBuff = {
[5754] = "霸体|龙威"
--[6385] = "亢龙·镇慑",
[6377] = "无疆",
[18083] = "益元",
}

--自己和队友buff更新
function OnBuff(CharacterID, BuffName, BuffID, BuffLevel, StackNum, SkillSrcID, StartFrame, EndFrame, FrameCount)
	--输出自己buff信息
	if CharacterID == id() then 
		if tBuff[BuffID] then
			if StackNum  > 0 then
				print("添加buff: ".. BuffName..", ID: "..BuffID..", 等级: "..BuffLevel..", 层数: "..StackNum..", 源ID: "..SkillSrcID..", 开始帧: "..StartFrame..", 当前帧: "..FrameCount..", 结束帧: "..EndFrame..", 剩余时间: "..(EndFrame-FrameCount)/16)
			else
				print("移除buff: ".. BuffName..", ID: "..BuffID..", 等级: "..BuffLevel..", 层数: "..StackNum..", 源ID: "..SkillSrcID..", 开始帧: "..StartFrame..", 当前帧: "..FrameCount)
			end
		end
	end
end
--]]
