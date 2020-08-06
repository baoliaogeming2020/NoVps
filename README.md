# 回看油管视频通过P2P传播爆料革命  
本项目适合传播任何分辨率的音视频，只要油管支持的格式就可以向墙内传播，考虑战友中电脑小白较多，因此抛弃某些复杂方案。**有一个重要的事一直忘说了，分享流量(传播种子)的个人电脑最好有独立IP(独立IP，独立IP，重要的事说三遍，因为P2P实现两方连接，要求必须有一方有公网IP)，具体是 IPv4 或者 IPv6 无所谓；或者通过端口映射公网IP** [查看自己是否有独立IP]()  

**任何战友都可以自愿参与此项目，  
人数越多向墙内传播的速度越快**。  

## 项目简介  
战友通过此方法回看爆料革命油管音视频，同时给墙内用 Bittorrent 下载的战友补档(给种子加速)，用此脚本回看同一音视频的战友越多，墙内战友下载越快。  

## 版权声明：  
本项目为穿墙模式试探，所有方法与技术实现不向爆料革命战友保留版权，任何爆料革命战友都可以用相同的方式传播爆料革命。  
如爆料革命主播想用此方式向墙内传播音视频，本人可以提供全程技术支持，请在评论区留言，我会主动联系爆料革命主播本人。  

## 穿墙原理：  
通过解析 youtube 音视频 http(s) 链接，下载到本地硬盘，生成 .torrent 种子向墙内传播。因 youtube 同一音视频生成种子相同，墙外战友分享人数越多，或者墙内战友下载人数越多，下载速度越快。GFW 是无法完全封锁 Bittorrent 软件的 tracker 服务器和 DHT 路由。但是，因为墙内战友网络条件不同，需要有不同网络条件的战友分享。  
通过 Bittorrent 分享文件需要3个条件：  
1. 做种时要在种子内加入 tracker 节点；  
2. 做种分享时最好同时设置 DHT 路由，这样可以保证在 tracker 全部失效时也可以分享；  
3. 做种分享时要保持开机时长，删除分享文件一定要保证上传率为 100%；  
4. 做种电脑要有独立 IP，因 P2P 链接必须有一方为独立 IP；  

## 分享方法  
以面具先生20200731视频为例  
### 软件安装  
- 安装 qbtorrent，本软件支持 Mac / Windows 操作系统  
[官网下载](https://www.qbittorrent.org/download.php)  
### 实施步骤  
1. 访问[面具先生视频](https://www.youtube.com/watch?v=FBY0147BGws)，复制网址  
2. 访问 youtube 视频链接[解析网站](https://www.findyoutube.net/)，将面具网址粘贴到文本框内  
![图1](0001.png)
3. 点击文本框后的 download 按钮进入下一页面  
4. 向下滚动，会看到“视频下载链接(Videos Download)”，根据油管提供的视频清晰度，本网站会提供不同的下载链接，直接结束后大概1小时左右，油管才会生成下载链接。  
![图1](0002.png)  
5. 右键点击任意 Download 按钮，选择"链接存储为"，在"存储为"文本框内输入 "20200731_mask.mp4"，点击"存储"。此方法为浏览器下载，无法实现边下载边回看。  
> **如果要边下载边回看需要安装 aria2**  
> Mac 安装 aria2  
> ``` /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"```  
> ```brew install aria2```  
> ```aria2c --all-proxy "http://127.0.0.1:1087" "此处粘贴刚才复制的链接地址"```  

6. 用软件qbtorrent做种  
[0003.png](0003.png)  
7. 将 .torrent 种子文件上传到某个空间或分享到群，记得注释写明视频原标题。  

## 下载方法
墙内战友可根据自己的习惯选择 Bittorrent 下载软件，并设置 tracker / DHT。  
### 支持软件汇总：
- [qbtorrent](https://www.qbittorrent.org/download.php)：支持 Mac / Windows 操作系统，功能较全。  
- aria2：是一款自由、跨平台命令行下载管理器，支持的下载协议有： HTTP / HTTPS / FTP / Bittorrent / Metalink。无 shell 基础不爱折腾的战友不建议使用。
> - AriaNg：aria2 最好用的界面，支持大部分 aria2 参数设置。
> - aria2webui：aria2 最早的的界面，有网站版，但不太好用。
> - yaaw：aria2 最早的的界面，有 firefox / chrome 插件版，功能太简单。

- [Motrix](https://motrix.app/)：只支持 Mac，相对好学。
... ...
### BT节点服务器：
- tracker 服务器网站：https://newtrackon.com/list  
- dht.dat 下载的网站：https://github.com/P3TERX/aria2.conf  
## 历史抛弃方案及原因  
- github + metalink 分享：通过 将音视频文件上传 github 后生成 .metalink / .magnet / .torrent 文件分享，发现 github 文件大小限制 <25M，而且会封号 P2P 分享，所以抛弃。
- sourceforge + metalink 分享：SF 网站有 1000M 空间，可以类似 github 一样分享，但也是因为分享 P2P 很快就被封号，所以抛弃。
- okteto + metalink 分享：okteto 网站有 5G 空间，可以类似 github 一样分享，但也会因分享 P2P 封号，所以抛弃。
- metalink + PC 分享：metalink 是可以通过 aria2 将 http 流量导入 P2P，但实验过程中发现 aria2 为存命令行模式，战友小白太多，所以抛弃。
