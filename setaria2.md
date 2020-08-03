# Aria2 无法下载磁力链接、BT种子和速度慢的解决方案  
## 前言  
BT 下载并不是一个人的事，比如你在下载一部生理卫生知识教学影片时，背后其实是有一群和你下载同样影片的人在为你上传，同时你也在为他人上传，这个影片下载的人越多，上传的人就会越多，速度就会越快。但如果找不到这些人，你就可能无法下载。那么如何才能找到和你下载同样影片的人呢？  

## 开放端口  
在未开放端口的情况下，Aria2 无法与外界进行数据交换。所以开放端口是进行 BT 下载的首要条件。  

如果是在 VPS 上使用 Aria2 下载，最简单粗暴的办法是关闭防火墙。如果你不想这么做，那么首先要知道端口号，这也许是你自己设置的，也许是默认的，总之打开 Aria2 配置文件就知道了。以下是 Aria2 完美配置中的端口信息：  

```
# BT监听端口(TCP)  
listen-port=51413  
# DHT网络监听端口(UDP)  
dht-listen-port=51413  
```  
知道端口号后让防火墙放行这些端口即可，每个系统的操作都略有不同，随便咕咕搜索都能搜到，所以这里就不展开讲了。  

如果是在本地电脑或者 NAS 上使用 Aria2 下载，需要在路由器上设置端口转发，或者开启 UPnP 功能，它会自动进行端口转发。（Aria2 暂不支持 UPnP）  

## 添加 BitTorrent tracker  
BitTorrent tracker 是帮助 BT 协议在节点与节点之间做连接的服务器，俗称 BT 服务器、tracker 服务器（以下简称为 tracker ）。BT 下载一开始就要连接到 tracker ，从 tracker 获得其他客户端 IP 地址后，才能连接到其他客户端下载。在传输过程中，也会一直与 tracker 通信，上传自己的信息，获取其它客户端的信息。所以 tracker 在 BT 下载中起到了至关重要的作用。  

每个 BT 种子都会内置 tracker ，但可能因为不可抗力而导致连接困难或者速度不理想，这就意味着很难找到下载相同资源的人。好在这个问题可以通过添加额外 tracker 来解决，这样你遇到和你下载同样资源的人的机会就更多，就更容易找到给你上传的人，速度自然就会快了。  

trackerslist 是一个提供 tracker 列表的项目，几乎每天都会更新。列表还分为 udp、http、ws…… 小孩子才做选择，所以直接选择 trackers_all 这个包含所有服务器的列表。然后更改格式，tracker 之间用 , 隔开，再添加到 Aria2 配置文件中，就像下面这样：  

```
bt-tracker=udp://tracker.coppersurfer.tk:6969/announce,udp://tracker.leechers-paradise.org:6969/announce,udp://tracker.opentrackr.org:1337/announce,udp
://9.rarbg.to:2710/announce,udp://9.rarbg.me:2710/announce,udp://tracker.internetwarriors.net:1337/announce,udp://tracker.openbittorrent.com:80/announc
e,udp://exodus.desync.com:6969/announce,udp://open.demonii.si:1337/announce,udp://tracker.tiny-vps.com:6969/announce
```  
当然这种重复的事情，用脚本来做才是正确的方式：  

- 在 Aria2 配置文件(aria2.conf)所在目录执行以下命令即可获取最新 tracker 列表并自动添加到配置文件中。  
```
bash <(curl -fsSL git.io/tracker.sh)
```  
对于使用 Aria2 一键安装脚本的小伙伴，直接打开自动更新 BT-Tracker 功能即可。  

## 获取 DHT 数据  
由于 tracker 对 BT 下载起到客户端协调和调控的重要作用，所以一旦被封锁会严重影响 BT 下载。早年中国大陆对 tracker 的封锁，曾一度导致 BT 下载销声匿迹，这也促使了 DHT 网络的诞生。  

DHT 网络由无数节点组成，只要是开启 DHT 功能的 BT 客户端都是一个节点，所以你也可以是其中的一份子。当接触到一个节点，通过这个节点又能接触到更多的节点，接触的节点越多，你获取资源的能力就越强，下载的速度间接也就会有提升。即使在完全不连上 Tracker 服务器的情况下，也可以很好的下载。以下是 Aria2 配置文件中一些与 DHT 相关的功能选项：  

```
# DHT（IPv4）文件  
dht-file-path=/root/.aria2/dht.dat  
# DHT（IPv6）文件  
dht-file-path6=/root/.aria2/dht6.dat  
# 打开DHT功能, PT需要禁用, 默认:true  
enable-dht=true  
# 打开IPv6 DHT功能, PT需要禁用  
enable-dht6=true  
# DHT网络监听端口, 默认:6881-6999  
dht-listen-port=51413  
# 本地节点查找, PT需要禁用, 默认:false  
bt-enable-lpd=true  
# 种子交换, PT需要禁用, 默认:true  
enable-peer-exchange=true
```  
和其他 BT 下载工具一样，Aria2 有个 dht.dat 文件（开启 IPv6 还有个 dht6.dat），里面记录了 DHT 节点信息。但是！文件本身是不存在的，需要手动创建。如果你在 Aria2 第一次运行的时候直接下载磁力链接或者冷门种子，因为文件内没有任何数据，就无法获取到 DHT 网络中的节点，所以就会遇到无法下载的情况。  

第一个解决方案是找有数据 DHT 文件。比如 Aria2 完美配置中就有（所以使用 Aria2 一键安装脚本 增强版和 Aria2 Pro 的小伙伴无需担心这个问题）。  

第二个解决方案是生成 DHT 数据。找几个热门种子下载，比如 Ubuntu 镜像的种子。下载后做种几个小时，你会发现 dht.dat 从空文件变成有数据了。  

## 尾巴
经过以上的一波操作，也许下载并没有多么的快，但至少正常了。可能有些非常老而且冷门的资源不会一直有人在做种，这种情况要么是一直挂着等待有缘人突然做种，BT 就是这样，能下载都是缘分。要么把种子放到百度或者 115 进行离线下载，你会看到那虚假的进度条比你正常用 BT 下热门资源还要快（毕竟资源已经在服务器上存在了，进度条只是给你一种下载速度快的幻觉）。最后网盘下载的速度可能也并不理想，但总比不能下载要好吧。  
