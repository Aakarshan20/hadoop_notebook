# hadoop_notebook
**hadoop 開發/安裝筆記**

*目前使用版本: hadoop3.1.3*


## 參考了google的三篇論文

- GFS -> HDFS
- Map-Reduce -> MR
- BigTable -> HBase


### hadoop1.x

- Common (輔助工具)
- HDFS (數據存儲)
- MapReduce (計算+資源調度)

### hadoop2.x

- Common (輔助工具)
- HDFS (數據存儲)
- Yarn(資源調度)
- MapReduce (計算)

### hadoop3.x

*組成上沒有區別。*

## HDFS

- NameNode(nn): 儲存元數據, 文件名, 文件目錄結構, 文件屬性, 每個文件的塊列表和塊所在的DataNode等
- DataNode(dn): 本地文件系統存儲文件塊數據, 以及塊數據的校驗
- Secondary NameNode(2nn): 每隔一段時間對NameNode元數據備分


## Yarn

- Yet Another Resource Negotiator 資源協調者
	- Resource Manager: 整個集群資源的(CPU RAM)老大
	- Node Manager: 單個節點服務器資源的老大
	- Client: Job Submission 任務提交
	- ApplicationMaster: 單個任務的老大, 任務提交時會在NM產生一個AM
	- Container: 在NM中產生一個容器,運行AM, 相當於一台獨立的服務器, 裡面封裝了任務運行所需要的資源, 內存 CPU 磁盤 網路等, 當任務結束就將資源返還給NM 可向RM要更多的資源來運行任務, RM會分配資源給他, 甚至可以分配別的NM的資源
	
*客戶端可以有多個*

*集群上可以運行多個ApplicationMaster*

*每個NM上可以有多個container*

*一個container的ram 為1-8G, CPU最少要開一個*

## MapReduce

# MapReduce 計算過程分兩步
	1.	Map階段併行處裡輸入數據
	2.	Reduce階段對Map進行彙總



## 處理過程
	1.	Client 
	2.	ResourceManager
	3.	Container(app master) 
	4	.ResourceManager(要資源)
	5.	Container(MapTask) *N 
	6.	Container(ReduceTask)


## 大數據技術生態體系


- 數據庫(結構化數據)
	+ Sqoop數據傳遞
	+ HDFS文件存儲
	+ YARN 資源管理
	+ MapReduce離線計算
	+ Hive數據查詢
	+ Oozie任務調度
	+ 業務模型 數據可視化 業務應用
- 文件日誌(半結構化數據)未來可以導入DB
	+ Flume日誌收集
	+ HDFS文件存儲
	+ HBase非關係型數據庫
	+ YARN 資源管理
	+ Spark Core 內存
		+ Spark Mlib 數據挖掘
		+ Spark Sql 數據查詢
	+ Azkaban 任務調度
	+ 業務模型 數據可視畫 業務應用
- 影片 ppt等(非結構化數據)
	+ Kalfka消息隊列
	+ Storm 實時計算
	+ Flink
	+ Spark Streaming 實時計算
- Zookeeper 數據平台配置和調度
- 數據來源層
	+ 數據傳輸層
	+ 數據存儲層
	+ 資源管理層
	+ 數據計算層
	+ 任務調度層

## 推薦系統項目框架
	1.	用戶購買商品	
	2.	Nginx
	3.	Tomcat 收集訪問日誌
	4.	文件日誌
	5.	Flume日誌收集
	6.	Kafka消息隊列
	7.	Spark Stream實時計算 or Flink
	8.	java EE 後台
	9.	文件 OR DB
	10.	Tomcat 推薦業務



### 安裝完 centos以後使用root權限更改以下檔案
*僅限於使用iso檔安裝 需要配置以下設定*
```
#vim /etc/sysconfig/network-scripts/ifcfg-ens33
```

將
```
BOOTPROTO="dhcp"
```

改為
```
BOOTPROTO="static"
```

增加以下參數
```
IPADDR=192.168.10.100
GATEWAY=192.168.10.2
DNS1=192.168.10.2
```

### 修改主機名稱與主機名稱映射(iso檔安裝與vagrant安裝皆須執行)


```
vim /etc/hostname
```

改為hadoop100

```
hadoop100
```

### 修改hosts

```
vim /etc/hosts
```

添加以下內容
```
192.168.10.100 hadoop100
192.168.10.101 hadoop101
192.168.10.102 hadoop102
192.168.10.103 hadoop103
192.168.10.104 hadoop104
192.168.10.105 hadoop105
192.168.10.106 hadoop106
192.168.10.107 hadoop107
192.168.10.108 hadoop108
```

改完reboot

```
# sudo reboot
```

安裝紅帽體系操作系統的倉庫
```
# yum install -y epel-release
```

關閉防火牆,關閉防火牆開機自啟
```
# systemctl stop firewalld
# systemctl disable firewalld.service

```
*企業開發時，單個機器的防火牆是關閉的，公司整體對外會開啟一個非常安全的防火牆*

創造atguitu 用戶, 並修改atguigu用戶的密碼
```
# useradd atguigu
# passwd atguigu
```

配置atguigu用戶root權限, 方便後期加sudo 執行 root 權限命令
```
vim /etc/sudoers
```

修改/etc/sudoer 文件 在%wheel這行下面加一行 如下所示
```
## Allow root to run any commands anywhere
root ALL=(ALL)		ALL

## Allows people in group wheel to run all commands
%wheel ALL=(ALL)		ALL
atguigu ALL=(ALL)		NOPASSWD:ALL
```

*注意: atguigu這行不要直接放到root下面, 因為所有用戶都屬於%wheel組, 你先配置了atguigu具有免密功能,
但是程序執行到%wheel行時, 該功能又被覆蓋回需要密碼
所以atguigu要放到%wheel這行下面*

切換到atguigu
```
$ su atguigu
```

在opt下創建以下資料夾
```
$ cd /opt
$ sudo mkdir module
$ sudo mkdir software 
```

更改資料夾權限
```
$ sudo chown atguigu:atguigu module/ software/
```

卸載虛擬機自帶的jdk
*如果虛擬機是最小安裝, 忽略這一步*

```
# rpm -qa | grep -i java | xargs -n1 rpm -e --nodeps
```

- rpm -qa: 查詢所安裝的所有rpm軟體包
- grep -i: 忽略大小寫
- xargs -n1: 表示每次只傳遞一個參數
- rpm -e -nodeps: 強制卸載軟體

重啟虛擬機

```
# reboot
```

## 克隆虛擬機

*克隆前先關機*

```
1.	vm ware 中選定機器
2.	右鍵 manager
3.	clone
4.	當前狀態 ( the current state in the virtual machine )
5.	創建完整克隆 ( create a full clone )
6.	Virtual machine name 填入: hadoop102
7.	Location : 在跟hadoop100同級的地方開一個資料夾hadoop102 路徑指到這邊
8.	等一段時間...
9.	參照1-8 創建hadoop103 & hasoop104 
```

### 依序修改 102-104 ip地址
```
1.	進入 hadoop102 (用 root 登入)
2.	vim /etc/sysconfig/network-scripts/ifcfg-ens33
3.	IPADDR 改為 192.168.10.102
4.	vim /etc/hostname
5.	改為 hadoop102
6.	# reboot
7.	仿照1-7 修改 hadoop103 & hadoop104
8.	reboot
```

## 安裝jdk 與 hadoop

### 準備檔案
```
1.	自行下載hadoop-3.1.3.tar.gz & jdk-8u202-linux-x64.tar.gz
2.	使用ftp 上傳到 hadoop102的 /opt/software
3.	記得把檔案的所有者與群組改為atguigu:atguigu
```

### 安裝jdk
```
在 /opt/software 中 執行 tar -zxvf jdk-8u202-linux-x64.tar.gz -C /opt/module
```
### 創建自己的環境變量
```
1.	# cd /etc/profile.d
2.	# sudo vim my_env.sh

#JAVA_HOME
export JAVA_HOME=/opt/module/jdk1.8.0_202
export PATH=$PATH:$JAVA_HOME/bin

3.	保存退出 
4.	加載環境變量: #source /etc/profile
5.	測試是否加載成功: # java 
如果跳一堆訊息就代表安裝完畢!
```

### 安裝hadoop 
```
1.	# cd /opt/software
2.	# tar -zxvf hadoop-3.1.4.tar.gz -C /opt/module
3.	# sudo vim my_env.sh

(往下面增加這幾行 配置hadoop 環境變量)
#HADOOP_HOME
export HADOOP_HOME=/opt/module/hadoop-3.1.4

export PATH=$PATH:$HADOOP_HOME/bin
export PATH=$PATH:$HADOOP_HOME/sbin

4.	保存退出 
5.	加載環境變量: # source /etc/profile
6.	測試是否加載成功: # hadoop 
如果跳一堆訊息就代表安裝完畢!
```

### hadoop 目錄結構 ( 僅列出重點 )
- bin/
    + hdfs
    + yarn
    + mapred ( map reduce )
- etc/ ( 大量的配置信息 )
    + hdfs-site.xml ( hdfs相關配置)
    + mapred-site.xml ( mapreduce 相關)
    + yarn-site.xml ( yarn 相關)
    + core-site.xml ( 核心文件 )
- include/ ( 頭文件 )
- sbin/
  + hadoop-daemon.sh ( 單節點啟動 ) 
  + start-dfs.sh ( 啟動dfs )
  + start-yarn.sh ( 啟動資源調度器 )
  + mr-jobhistory-daemon.sh ( 啟動歷史服務器 )
- share/ ( 學習資料 )
  + doc/
  + hadoop/
    + mapreduce/ ( 內含jar 範例檔 )




### hadoop 三種模式

+ 本地
  - 數據存儲在linux 本地
  - 範例
    - hadoop100
  - 測試偶爾用一下 
+ 偽分布式
  + 數據儲存在 HDFS
  + 範例
    + hadoop101
  + 公司經費有限 
+ 完全分布式
  + 數據存在 HDFS/ 多台服務器工作
  + 範例
    + hadoop102
    + hadoop103
    + hadoop104
  + 企業大量使用
  
### 本地模式
```
# cd /opt/module/hadoop-3.1.4
# mkdir wcinput
# cd wcinput
# vim word.txt

ss ss
cls cls
banzang
bobo
yangge

保存退出
# hadoop jar share/hadoop/mapreduce/hadoop-mapreduce-examples-3.1.4.jar wordcount wcinput/ ./wcoutput

share/hadoop/mapreduce/hadoop-mapreduce-examples-3.1.4.jar: 範例代碼
wordcount: 自數統計
wcinput/: 輸入目錄
wcoutput/: 輸出目錄(不能事先創建!!)

察看結果
# cd /opt/module/hadoop-3.1.4/
# cat wcoutput/part-r-00000
```
 
## 完全分布式運行模式 ( 開發重點 )

```
1. 	準備三台客戶機 ( 關閉防火牆、靜態IP、主機名稱 )
2. 	安裝 JDK
3. 	配置環境變量
4. 	安裝 HADOOP
5. 	配置環境變量
6. 	配置集群
7. 	單點啟動
8. 	配置 ssh
9.	 群起並測試集群
```
### 編寫集群分發腳本 xsync

1. scp(secure copy) 安全拷貝
   1. 定義
        - 可以實現服務器間的數據拷貝
   2. 基本語法
        ```
        scp -r  $pdir/$fname        $user@$host:$pdir/$fname
        命令 遞歸 要拷貝的文件路徑/名稱  目的地用戶@主機:目的地路徑/名稱 
      ```
   3. 案例實操
        - *前提: 在hadoop102、hadoop103、hadoop104 都已創建好 /opt/module, /opt/software 兩個目錄並把這兩個目錄修改為 atguigu:atguigu*
         ```
      $ sudo chown atguigu:atguigu -R /opt/module
         ```
        1. (推) 在 hadoop102 上將 hadoop102 中 /opt/module/jdk1.8.0_202 拷貝到 hadoop103
       ```
       [atguigu@hadoop102 module]$ scp -r /opt/module/jdk1.8.0_202 atguigu@hadoop103:/opt/module	
       ```
        2. (拉) 在 hadoop103 上將 hadoop102 中 /opt/module/hadoop-3.1.4 拷貝到 hadoop104
        ```
      [atguigu@hadoop103 module]$ scp -r atguigu@hadoop102:/opt/module/hadoop-3.1.4 /opt/module/ 	
        ```
       3. 在 hadoop103 上將 hadoop102 中 /opt/module/hadoop-3.1.4 拷貝到 hadoop104
        ```
      [atguigu@hadoop103 module]$ scp -r atguigu@hadoop102:/opt/module/* atguigu@hadoop104:/opt/module/	
        ```
2. rsync 遠程同步工具
      - 主要用於備份與鏡像，速度快，避免複製相同內容和支持符號鏈接。
      - 與scp不同，rsync 只對差異文件做更新，scp 是直接覆蓋

        1. 基本語法
        ```
        sync   -av     $pdir/$fname          $user@$host:$pdir/$fname
        命令   選項參數  要拷貝的文件路徑/名稱  目的地用戶@主機:目的地路徑/名稱
        ```
       
        - 選項參數說明
          - -a: 歸檔拷貝
          - -v: 顯示複製過程
          
        2. 案例實操
           1. 刪除 hadoop103中 /opt/module/hadoop-3.1.4/wcinput
           ```
           [atguigu@hadoop103 hadoop-3.1.4]$ rm -rf wcinput/
           ```
           2. 同步 hadoop102中 /opt/module/hadoop-3.1.4 到 hadoop103
           ```
           [atguigu@hadoop102 module]$ rsync -av hadoop-3.1.4/ atguigu@hadoop103:/opt/module/hadoop-3.1.3
           ```
        
3. xsync 集群分發腳本
   1. 需求: 循環複製文件到所有節點的相同目錄下
   2. 需求分析:
      1. rsync 命令原始拷貝
      ```
      rsync -av /opt/module atguigu@hadoop103:/opt/
      ```
      2. 期望腳本:
      xsync [要同步的文件名稱]
      3. 期望腳本在任何路徑都能使用 ( 腳本放在聲明了全局環境變量的路徑 )
      ```
      [atguigu@hadoop102 ~]$ echo $PATH 
      ```
      得到如下結果
      ```
      /usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/home/atguigu/.local/bin:/home/atguigu/bin:/opt/module/jdk1.8.0_202/bin
      ```
   3. 腳本實現
      1. 在/home/atguigu/bin 目錄下創建xsync文件 
      ```
      [atguigu@hadoop102 opt]$ cd /home/atguigu
      [atguigu@hadoop102 ~]$ mkdir bin
      [atguigu@hadoop102 ~]$ cd bin
      [atguigu@hadoop102 bin]$ vim xsync
      ``` 
      在該文件中編寫如下代碼
	  ```
	  #!/bin/bash
	  #1. 判斷參數個數
	  if [ $# -lt 1 ]
      then
	      echo Not Enough Argument!
	  exit;
	  fi
   		
	  #2 遍歷集群所有機器
   	
	    for host in hadoop102 hadoop103 hadoop104
	    do
	      echo ======= $host ========
	      #3. 遍歷所有目錄，挨個發送
   	    
	      for file in $@
	      do
	          #4. 判斷文件是否存在
	          if [ -e $file ]
	              then
	                  #5. 獲取父目錄
	                  pdir=$(cd -P $(dirname $file); pwd)
                     
	                  #6. 獲取當前目錄名稱
	                  fname=$(basename $file)
	                  ssh $host "mkdir -p $pdir"
	                  rsync -av $pdir/$fname $host:$pdir
	              else
	                  echo $file does not exists!
	          fi
	      done
	    done
      ```
   		

