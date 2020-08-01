终于找到了不用申请VPS传播爆料革命的方法。大部分VPS架设P2P都会被封号，所以在想破脑袋后，终于想到了最适合的办法。  

本项目适合传播任何分辨率的音视频，只要油管支持的格式就可以向墙内传播。  
**任何战友都可以自愿参与此项目，  
人数越多向墙内传播的速度越快**。  

# 项目简介  
本项目是通过解析油管视频链接后生成 metalink 向墙内传播郭先生爆料革命音视频，当墙外战友通过 metalink 下载时，可向墙内战友分享下载流量。传播方式是通过向墙外战友分享metalink链接，向墙内战友分享torrent / magnet 两种 P2P 链接，在墙外战友下载时，可通过 P2P 技术向墙内战友分享下载流量。  

# 版权声明：
本项目为穿墙模式试探，所有方法与技术实现不向爆料革命战友保留版权，任何爆料革命战友都可以用相同的方式传播爆料革命。  
如爆料革命主播想用此方式向墙内传播音视频，本人可以提供全程技术支持，请在评论区留言，我会主动联系爆料革命主播本人。  

# 穿墙原理：
通过解析 youtube 音视频链接，发现非 Blob 链接，用 aria2 技术下载后，用 mktorrent 生成 .torrent 种子文件，用 aria2c -S 解析 magnet 链接，再用脚本生成 metalink 下载文件。  

metalink 协议支持 HTTP / FTP / Bittorrent 同时下载同一个文件，墙外战友在下载时可以通过 BT 向墙内分享流量，墙外战友下载人数越多，墙内速度越快。metalink 是 xml 文件，内含相同文件的 HTTP / FTP / Bittorrent 下载链接，BT 以 btih 加密 hash 方式写入，此 btih-hash 与 magnet-btih 加密方式完全相同，这样，墙外战友下载后可以直接将 btih-hash 构造成 magnet 文本后向墙内战友传播，墙内战友直接可以下载。而 magnet 首先会下载一个 Bittorrent 种子，然后可以通过所有 Bittorrent 软件进行下载。某些BT软件在下载 magnet 链接时找种慢，可以用迅雷(虽然有点危险)下载 magnet，这样找种快，然后再用其它BT软件下载此种子文件， *注意* ，迅雷在指定下载文件夹内先下载种子，但种子是隐藏文件，要想看到种子需要打开文件夹的显示隐藏功能。  

GFW 是无法完全封锁 Bittorrent 软件的 tracker 服务器和 DHT 路由。  

# 软件安装
## MAC操作系统
- 安装 homebrew：  
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"  
- 安装aria2：  
brew install aria2  
- 安装mktorrent：  
brew insatll mktorrent  

## WIN操作系统  
- 安装mktorrent：  
根据你操作系统是32位或64位，直接下载 .7z 软件压缩包，解压到某个目录。  
- 安装aria2：
根据你操作系统是32位或64位，直接下载 .zip 软件压缩包，解压到某个目录。  
- 设置运行环境：  
将以上两个软件路径添加 PATH 参考此网站根据你的操作系统版本设置PATH  

## LINUX操作系统
- 会linux的战友，一定能看懂MAC脚本，不写了，基本一样，无非是换几个命令。  

# 实施步骤  
以面具先生20200731视频为例：  
## 找到 youtube 视频下载地址  
1. 访问面具先生视频，复制网址  
https://www.youtube.com/watch?v=FBY0147BGws  
2. 访问 youtube 视频链接解析网站，将面具网址粘贴到文本框内  
https://www.findyoutube.net/  
![图1](0001.png)  
3. 点击文本框后的 download 按钮进入下一页面  
4. 向下滚动，会看到“视频下载链接(Videos Download)”，根据油管提供的视频清晰度，本网站会提供不同的下载链接  
![图1](0002.png)  
5. 右键点击任意 Download 按钮，复制链接地址。  
6. 打开 MAC 终端，输入以下命令开始下载  
aria2c --all-proxy "http://127.0.0.1:1087" "此处粘贴刚才复制的链接地址"  
7. 生成 .torrent / .metalink / .magnet 三种下载链接  
执行 mkmetalink4m.sh(MAC) 或 mkmetalink4w.bat(WIN) 或 mkmetalink4l.sh(linux)脚本，脚本用法参考脚本内注释。  
8. 将三种文件上传到某个空间或分享到群。

# 项目参考  
[路德]() / [面具]()  

# 参与分享  
- 参与分享链接：根据本项目步骤生成 .torrent / .metalink / .magnet 三种下载链接，并向墙外分享 .metalink，向墙内分享 .torrent / .magnet  
- 参与分享流量：根据拿到的分享链接墙外战友在个人电脑下载并保留下载内容一段时间，保持开机状态，这样可以向墙内战友分享P2P流量

# 软件支撑  
参与分享流量的战友需要支持 .torrent / .metalink / .magnet 协议的软件，并对软件进行相应的设置。
## 支持 metalink 软件汇总：
- aria2：是一款自由、跨平台命令行下载管理器，支持的下载协议有： HTTP / HTTPS / FTP / Bittorrent / Metalink。无 shell 基础战友不建议使用。  
- AriaNg：  
- aria2webui：  
- yaaw：  
　... ...  

## 支持 BT / magnet 软件汇总：
- Motrix：https://motrix.app/  
　... ...  

## BT服务器：
- tracker 服务器网站：https://newtrackon.com/list  
- dht.dat 下载的网站：https://github.com/P3TERX/aria2.conf  
