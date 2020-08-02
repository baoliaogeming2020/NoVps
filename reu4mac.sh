#! /bin/zsh

# 如果你是战友，又喜欢回看爆料革命主播的视频，用此脚本看回看，你就能通过 P2P 向墙内战友传播此视频，看完把文件夹内的 .torrent 文件向墙内战友传播。
# 脚本用法：本脚本只适用于macOS，首先下载此脚本到本机，然后用命令 "chmod 777 reu4mac.sh" 修改此脚本的运行权限，"./reu4mac.sh -h" 查看帮助。

# 根据参数提取变量
while getopts f:o:x:i:h OPT;do
    case $OPT in
        f)
            mycode=$OPTARG
            onlyhelp=false
            ;;
        o)
            myfilename=$OPTARG
            onlyhelp=false
            ;;
        x)
            myproxy=$OPTARG
            onlyhelp=false
            ;;
        i)
            myURL=$OPTARG # "https://www.youtube.com/watch?v=FBY0147BGws"
            onlyhelp=false
            ;;
        h)
            onlyhelp=true
            cat << EOF
本脚本帮助战友回看爆料革命油管音视频，同时给墙内战友用 Bittorrent 下载时补档(给种子加速)，用此脚本回看同一音视频的战友越多，墙内战友下载越快。
本脚本首先会下载音视频，下载后会生成同名的 .torrent / .magnet 文件，如果你想传播此音视频，可以将这两个文件传向墙内。
补档：Bittorrent 种子下载时通常下载速度为 0，这是因为种子是死档。而将种子内文件放入 BT 软件内就是补档，给 BT 种子加速。
本脚本使用前需要安装 homebrew / mktorrent / aria2，安装命令如下：
安装 homebrew：/usr/bin/ruby -e "\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
安装 aria2：brew install aria2
安装 mktorrent：brew insatll mktorrent

语法 :
    ./mkfromUtube.sh -f code -o filename -x proxy -i videoLinkfromYoutube
    ./mkfromUtube.sh -h

选项 :
    -f 默认 18，选择要下载的油管格式代码
    -o 默认日期，输出音视频文件名，文件名后缀根据油管格式代码自动添加，如：-f 18 -o 20200731，输出音视频文件名为 "20200731.mp4"，
       据此也指定了种子文件名为 "音视频文件名 + .torrent"，magnet文件名为 "音视频文件名 + .magnet"
    -x 可选，代理网络，支持 http / sock /sock5
    -i 要下载视频的油管网址，一定要用双引号括起来
    -h 输出帮助文档

代码：油管支持的音视频格式对应代码，"video only"只有视频无音频。
    249   webm    audio only tiny    58k , opus @ 50k (48000Hz)
    250   webm    audio only tiny    77k , opus @ 70k (48000Hz)
    140   m4a     audio only tiny   134k , m4a_dash container, mp4a.40.2@128k (44100Hz)
    251   webm    audio only tiny   145k , opus @160k (48000Hz)
    160   mp4     256x144    144p   144k , avc1.4d400c, 30fps, video only
    278   webm    256x144    144p   156k , webm container, vp9, 30fps, video only
    242   webm    426x240    240p   298k , vp9, 30fps, video only
    133   mp4     426x240    240p   311k , avc1.4d4015, 30fps, video only
    243   webm    640x360    360p   506k , vp9, 30fps, video only
    134   mp4     640x360    360p   626k , avc1.4d401e, 30fps, video only
    244   webm    854x480    480p   894k , vp9, 30fps, video only
    135   mp4     854x480    480p  1217k , avc1.4d401f, 30fps, video only
    247   webm    1280x720   720p  1530k , vp9, 30fps, video only
    136   mp4     1280x720   720p  2362k , avc1.64001f, 30fps, video only
    248   webm    1920x1080  1080p 2375k , vp9, 30fps, video only
    137   mp4     1920x1080  1080p 4498k , avc1.640028, 30fps, video only
    18    mp4     640x360    360p   421k , avc1.42001E, 30fps, mp4a.40.2@ 96k (44100Hz)
    22    mp4     1280x720   720p  1100k , avc1.64001F, 30fps, mp4a.40.2@192k (44100Hz) (best)

注释：最适宜传播的音视频代码为 18 / 140。
    code : 18  为最小的音视频(一小时大概 200+M)
    code : 140 为流行格式音频(一小时大概  70+M)

示例：
    下载面具先生 20200731 油管视频 : https://www.youtube.com/watch?v=FBY0147BGws
    $0 -f 18 -o 20200731_mask -i "https://www.youtube.com/watch?v=FBY0147BGws"

作者：
    https://github.com/baoliaogeming2020
EOF
            ;;
        \?)
            echo err
            exit 1
            ;;
    esac
done

if [ "$onlyhelp" = false ]; then
    # 生成今天的日期，如果未指定 -o 则用今天日期当文件名
    genDate=$(date "+%Y%m%d" )
    # 解释油管视频为下载链接的网站
    parsNet1="https://www.findyoutube.net/"
    # 解释网站的解释结果页面
    parsNet2="https://www.findyoutube.net/result"

    # 根据指定的油管格式代码给文件添加后缀
    case ${mycode:-"18"} in
        18|22|134|135|136|137|160)
            myfilename=$myfilename".mp4"
            ;;
        140)
            myfilename=$myfilename".m4a"
            ;;
        249|250|251|278|242|243|244|247|248)
            myfilename=$myfilename".webm"
            ;;
        \?)
            myfilename="unknow.mp4"
            exit 1
            ;;
    esac

    # 解释网站需要 token 才能在结果页面给出解释结果
    myToken=$(curl --proxy "$myproxy" "$parsNet1" | awk '/token/{gsub(/.+value="/,"");gsub(/".+/,"");print}')
    # 获取解释结果页面 html 代码
    myContent=$(curl --proxy "$myproxy" -d "url=${myURL}&proxy:=Random&submit=Download&csrf_token=$myToken"  -X POST $parsNet2)
    # 在结果页面中找到指定格式代码的下载链接
    myLink=$(echo $myContent | awk '/<a href=/' | awk '/itag=18/{gsub(/<a href=/,"");gsub(/ download=.+/,"");gsub(/amp;/,"");print}' | sort | uniq)

    # 下载音视频，生成 .torrent 种子，生成 .magnet 文件。
    aria2c --all-proxy "$myproxy" -o "$myfilename" $myLink \
    && mktorrent $myfilename \
    && aria2c -S $myfilename".torrent" > $myfilename".magnet"
fi
