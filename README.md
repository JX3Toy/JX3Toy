# 下载
[下载链接1](https://pixeldrain.com/u/nanbztBY)

[下载链接2](https://gateway.pinata.cloud/ipfs/bafybeiekz2rpuvpfe2dwbzliuubb3x7fekjmz2svtv6arwgw3o4rj2qw4m/Toy.zip)

# 安装
无需安装, 解压缩到任意位置即可。如果杀毒软件误报，请自行设置排除相关文件夹。解压缩后运行更新程序，会自动下载和更新组件并启动。

# 注册

## 安装浏览器MetaMask(小狐狸)钱包扩展

Edge浏览器 <https://microsoftedge.microsoft.com/addons/detail/metamask/ejbalbakoplchlghecdalmeeeajnimhm>

火狐浏览器 <https://addons.mozilla.org/zh-CN/firefox/addon/ether-metamask/?utm_source=addons.mozilla.org&utm_medium=referral&utm_content=search>

如果以上链接有变动请自行在浏览器扩展商店中搜索安装 MetaMask 扩展插件。

如果是Edge浏览器，安装后点击右上角扩展按钮把Metamask显示在工具栏上。

## 创建钱包账户
安装好MetaMask钱包后根据提示创建账户，**助记词尽量用笔记录在纸上，如果你是第一次接触区块链请留意以下安全提示：** 
1. **助记词和私钥不要泄露给任何人**
2. **当网站请求连接钱包时仔细辨别后再同意，防止被钓鱼**
3. **交易或付款时看清楚金额再同意**
4. **其它安全事项请自行搜索**

## 连接钱包
从软件启动界面打开网站，点击连接MetaMask钱包，同意添加网络，同意连接钱包。

本软件构建在Polygon测试网上，Polygon是一个以太坊侧链，和以太坊的操作基本相同，gas费便宜很多。如果操作MetaMask钱包有疑问，搜索相关以太坊视频教程参考即可。

## 获取测试币
区块链操作需要 Token（代币）作为 gas（燃料），就像汽车需要加油才能开一样。polygon网络的原生代币是MATIC，账户中需要有MATIC才能和网络交互。
测试网的MATIC可以免费领取，以下几个网站可以领测试币，领取时网络选择 Mumbai (Polygon测试网)，需要科学上网。科学上网 免费节点分享网站 <https://nodefree.org>, 软件建议用 Clash，开 System Proxy。

<https://faucet.polygon.technology> 一次给0.2个，2分钟领一次，账户中超过0.4个就不给了。

<https://mumbaifaucet.com> 一次给0.5个，很快到帐，24小领一次。如果注册账号一次给1个。

只要领成功一次就可以继续，不够用有空再领，1个就能用很久。如果实在不会弄，就找别人多领点，从钱包发送给你。

## 领取测试USDT
MATIC用作执行交易的手续费, USDT是货币，用于支付。

在网站依次执行 添加测试USDT到钱包资产列表，领取测试USDT币，成功后钱包中会显示有500个USDT。

## 注册
在软件启动界面复制 设备ID 进行注册。

注册成功后充值。

从钱包复制账户地址到启动界面进行登录，登录成功后就可以使用了。

# 使用
在登录游戏之前启动软件，如果已经进入游戏才启动，设置的快捷键不生效，重新设置或者返回角色重新进游戏即可。

## 菜单功能
进入游戏后， 点击角色头像下方小箭头或屏幕右侧小扳手。

- 全局设置
  - 主播模式（开启后不显示所有提示信息）
  - 自动面向（使用技能不需要面向， PVE建议关闭）
  - 拾取碎银（开启后，自动拣自己周围的碎银）
  - 自动QTE（开启后，类似龙门飞剑之类的QTE会自动完成）
- 技能开关（勾选的技能，宏不会施放）
- 门派宏（当前门派对应的宏列表，点击列表载入宏）
- 通用宏（对应宏目录下的通用）
- 宏选项（载入宏之后，如果宏定义了选项，会在这显示）
- 调试信息
  - 记录技能释放（开启后，宏内使用技能时会输出记录信息）
  - 自己buff（输出自己buff信息）
  - 目标buff（输出目标buff信息）
  - 附近NPC（输出附近所有NPC信息）
  - 自己位置（输出自己的位置坐标）
- 自动科举，自动攻防答题等功能请自行探索

## 快捷键设置
点击游戏主菜单的快捷键设置，找到相应条目设置快捷键。

## 如何编写宏
宏是一个Lua脚本文件，可以使用记事本或任意文本编辑器进行编写。最好找一款支持Lua语法高亮的编辑器，如 Notepad++、VSCode（安装Lua插件）、EditPlus（安装Lua插件）。

**请留意宏文件保存时的编码，保存为ANSI编码，没有这个编码选项的编辑器保存为GBK、GB18030等简体中文编码。**

编写好的宏放在软件 **Macro** 文件夹下 **对应门派** 的文件夹中。

宏里面定义一系列函数，函数中调用预定义的宏命令实现宏的执行逻辑，运行的时候这些函数会被系统调用。

最基本的是Main函数，每秒调用十几次，下面是一个简单示例。
```lua
--如果宏是运行状态, 这个函数每秒被调用十几次。
function Main(g_player)
  bigtext("Hello World.")
end
```

# 联系和反馈
如果发现Bug或有建议请通过以下方式联系：

Email: <JX3Toy@pm.me>

Keybase: <https://keybase.io/jx3toy>
