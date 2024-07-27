# hadoop_notebook

**hadoop 開發/安裝筆記**

_目前使用版本: hadoop3.1.3_

## 參考了 google 的三篇論文

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

_組成上沒有區別。_

## HDFS

- NameNode(nn): 儲存元數據, 文件名, 文件目錄結構, 文件屬性, 每個文件的塊列表和塊所在的 DataNode 等
- DataNode(dn): 本地文件系統存儲文件塊數據, 以及塊數據的校驗
- Secondary NameNode(2nn): 每隔一段時間對 NameNode 元數據備分

## Yarn

- Yet Another Resource Negotiator 資源協調者
  - Resource Manager: 整個集群資源的(CPU RAM)老大
  - Node Manager: 單個節點服務器資源的老大
  - Client: Job Submission 任務提交
  - ApplicationMaster: 單個任務的老大, 任務提交時會在 NM 產生一個 AM
  - Container: 在 NM 中產生一個容器,運行 AM, 相當於一台獨立的服務器, 裡面封裝了任務運行所需要的資源, 內存 CPU 磁盤 網路等, 當任務結束就將資源返還給 NM 可向 RM 要更多的資源來運行任務, RM 會分配資源給他, 甚至可以分配別的 NM 的資源

_客戶端可以有多個_

_集群上可以運行多個 ApplicationMaster_

_每個 NM 上可以有多個 container_

_一個 container 的 ram 為 1-8G, CPU 最少要開一個_

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
  - Sqoop 數據傳遞
  - HDFS 文件存儲
  - YARN 資源管理
  - MapReduce 離線計算
  - Hive 數據查詢
  - Oozie 任務調度
  - 業務模型 數據可視化 業務應用
- 文件日誌(半結構化數據)未來可以導入 DB
  - Flume 日誌收集
  - HDFS 文件存儲
  - HBase 非關係型數據庫
  - YARN 資源管理
  - Spark Core 內存
    - Spark Mlib 數據挖掘
    - Spark Sql 數據查詢
  - Azkaban 任務調度
  - 業務模型 數據可視畫 業務應用
- 影片 ppt 等(非結構化數據)
  - Kalfka 消息隊列
  - Storm 實時計算
  - Flink
  - Spark Streaming 實時計算
- Zookeeper 數據平台配置和調度
- 數據來源層
  - 數據傳輸層
  - 數據存儲層
  - 資源管理層
  - 數據計算層
  - 任務調度層

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

### 安裝完 centos 以後使用 root 權限更改以下檔案

_僅限於使用 iso 檔安裝 需要配置以下設定_

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

### 修改主機名稱與主機名稱映射(iso 檔安裝與 vagrant 安裝皆須執行)

```
vim /etc/hostname
```

改為 hadoop100

```
hadoop100
```

### 修改 hosts

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

改完 reboot

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

_企業開發時，單個機器的防火牆是關閉的，公司整體對外會開啟一個非常安全的防火牆_

創造 atguitu 用戶, 並修改 atguigu 用戶的密碼

```
# useradd atguigu
# passwd atguigu
```

配置 atguigu 用戶 root 權限, 方便後期加 sudo 執行 root 權限命令

```
vim /etc/sudoers
```

修改/etc/sudoer 文件 在%wheel 這行下面加一行 如下所示

```
## Allow root to run any commands anywhere
root ALL=(ALL)		ALL

## Allows people in group wheel to run all commands
%wheel ALL=(ALL)		ALL
atguigu ALL=(ALL)		NOPASSWD:ALL
```

_注意: atguigu 這行不要直接放到 root 下面, 因為所有用戶都屬於%wheel 組, 你先配置了 atguigu 具有免密功能,
但是程序執行到%wheel 行時, 該功能又被覆蓋回需要密碼
所以 atguigu 要放到%wheel 這行下面_

切換到 atguigu

```
$ su atguigu
```

在 opt 下創建以下資料夾

```
$ cd /opt
$ sudo mkdir module
$ sudo mkdir software
```

更改資料夾權限

```
$ sudo chown atguigu:atguigu module/ software/
```

卸載虛擬機自帶的 jdk
_如果虛擬機是最小安裝, 忽略這一步_

```
# rpm -qa | grep -i java | xargs -n1 rpm -e --nodeps
```

- rpm -qa: 查詢所安裝的所有 rpm 軟體包
- grep -i: 忽略大小寫
- xargs -n1: 表示每次只傳遞一個參數
- rpm -e -nodeps: 強制卸載軟體

重啟虛擬機

```
# reboot
```

## 克隆虛擬機

_克隆前先關機_

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

### 依序修改 102-104 ip 地址

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

## 安裝 jdk 與 hadoop

### 準備檔案

```
1.	自行下載hadoop-3.1.3.tar.gz & jdk-8u202-linux-x64.tar.gz
2.	使用ftp 上傳到 hadoop102的 /opt/software
3.	記得把檔案的所有者與群組改為atguigu:atguigu
```

### 安裝 jdk

```
在 /opt/software 中 執行 tar -zxvf jdk-8u202-linux-x64.tar.gz -C /opt/module
```

### 創建自己的環境變量

```
1.	# cd /etc/profile.d
2.	# vim my_env.sh

#JAVA_HOME
export JAVA_HOME=/opt/module/jdk1.8.0_202
export PATH=$PATH:$JAVA_HOME/bin

3.	保存退出
4.	加載環境變量: #source /etc/profile
5.	測試是否加載成功: # java
如果跳一堆訊息就代表安裝完畢!
```

### 安裝 hadoop

```
1.	# cd /opt/software
2.  # tar -zxvf hadoop-3.1.4.tar.gz -C /opt/module
3.  # cd /etc/profile.d
4.	# vim my_env.sh

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
  - hdfs ( 數據存儲 )
  - yarn ( 資源調度 )
  - mapred ( map reduce )
- etc/ ( 大量的配置信息 )
  - hdfs-site.xml ( hdfs 相關配置)
  - mapred-site.xml ( mapreduce 相關)
  - yarn-site.xml ( yarn 相關)
  - core-site.xml ( 核心文件 )
- include/ ( 頭文件 )
- sbin/
  - hadoop-daemon.sh ( 單節點啟動 )
  - start-dfs.sh ( 啟動 dfs )
  - start-yarn.sh ( 啟動資源調度器 )
  - mr-jobhistory-daemon.sh ( 啟動歷史服務器 )
- share/ ( 學習資料 )
  - doc/
  - hadoop/
    - mapreduce/ ( 內含 jar 範例檔 )

### hadoop 三種模式

- 本地
  - 數據存儲在 linux 本地
  - 範例
    - hadoop100
  - 測試偶爾用一下
- 偽分布式
  - 數據儲存在 HDFS
  - 範例
    - hadoop101
  - 公司經費有限
- 完全分布式
  - 數據存在 HDFS/ 多台服務器工作
  - 範例
    - hadoop102
    - hadoop103
    - hadoop104
  - 企業大量使用

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
# cd /opt/module/hadoop-3.1.4
# hadoop jar share/hadoop/mapreduce/hadoop-mapreduce-examples-3.1.4.jar wordcount wcinput/ ./wcoutput

share/hadoop/mapreduce/hadoop-mapreduce-examples-3.1.4.jar: 範例代碼
wordcount: 字數統計
wcinput/: 輸入目錄
wcoutput/: 輸出目錄(不能事先創建!!)

察看結果
# cd /opt/module/hadoop-3.1.4/
# wcoutput會有兩個數據
  - part-r-00000
    - 結果寫在這裡
  - _SUCCESS
    - 只是標記 裡面沒有東西
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
      - _前提: 在 hadoop102、hadoop103、hadoop104 都已創建好 /opt/module, /opt/software 兩個目錄並把這兩個目錄修改為 atguigu:atguigu_
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
   - 與 scp 不同，rsync 只對差異文件做更新，scp 是直接覆蓋

     1. 基本語法

     ```
     sync   -av     $pdir/$fname          $user@$host:$pdir/$fname
     命令   選項參數  要拷貝的文件路徑/名稱  目的地用戶@主機:目的地路徑/名稱
     ```

     - 選項參數說明
       - -a: 歸檔拷貝
       - -v: 顯示複製過程

     2. 案例實操
        1. 刪除 hadoop103 中 /opt/module/hadoop-3.1.4/wcinput
        ```
        [atguigu@hadoop103 hadoop-3.1.4]$ rm -rf wcinput/
        ```
        2. 同步 hadoop102 中 /opt/module/hadoop-3.1.4 到 hadoop103
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

      1. 在/home/atguigu/bin 目錄下創建 xsync 文件

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
                      #5. 獲取父目錄 (cd -P: 忽略ln，進入真實目錄)
                      pdir=$(cd -P $(dirname $file); pwd)

                      #6. 獲取當前目錄名稱 (mkdir -p: 如果存在就不創建 )
                      fname=$(basename $file)
                      ssh $host "mkdir -p $pdir"
                      rsync -av $pdir/$fname $host:$pdir
                  else
                      echo $file does not exists!
              fi
          done
        done
      ```

      2. 增加執行權限 x

      ```
      [atguigu@hadoop102 ~]$ chmod 777 /home/atguigu/bin/xsync
      ```

      3. 測試 ( 盡量用 atguigu 操作 )

      ```
      [atguigu@hadoop102 ~]$ xsync bin/
      ```

      4. 測試(sudo)

      ```
      [atguigu@hadoop102 ~]$ sudo ./bin/xsync /etc/profile.d/my_env.sh
      ```

   4. 載入 profile(分別進入 hadoop103 & hadoop104)

   ```
   [atguigu@hadoop103 ~]$ source /etc/profile
   [atguigu@hadoop104 ~]$ source /etc/profile
   ```

### SSH 無密登入配置

1. 配置 ssh
   1. 基本語法
   ```
    ssh [另一台電腦的 IP 地址]
   ```
   2. ssh 連線時出現 Host key verification failed
   ```
    [atguigu@hadoop102 ~]$ ssh hadoop103
   ```
   - 如果出現以下內容:
   ```
    Are you sure you want to continue connecting (yes/no)?
   ```
   輸入 yes，並 enter
2. 無密鑰配置

   _需求: 希望 hadoop102 可以無密鑰登入 hadoop103 hadoop104_

   1. 產生 ssh key

   _機器上有執行過 ssh 命令, 家目錄才會有 .ssh 目錄_

   _看看誰來過 ( 非必要 )_

   ```
   [atguigu@hadoop103 ~]$ cd .ssh
   [atguigu@hadoop103 .ssh]$ cat known_hosts
    hadoop102,192.168.10.102 ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBH4POQy1mBfqwxlzDUnH3jZcwORaPWOxWtQGHjGGfXRrX4AXHC1xYOZ1IXcJ0MKb8w7NjB0lPi5/VDt05b59Poc=
    hadoop104,192.168.10.104 ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBH4POQy1mBfqwxlzDUnH3jZcwORaPWOxWtQGHjGGfXRrX4AXHC1xYOZ1IXcJ0MKb8w7NjB0lPi5/VDt05b59Poc=
    hadoop103,192.168.10.103 ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBH4POQy1mBfqwxlzDUnH3jZcwORaPWOxWtQGHjGGfXRrX4AXHC1xYOZ1IXcJ0MKb8w7NjB0lPi5/VDt05b59Poc=
   ```

   建立密鑰

   ```
     [atguigu@hadoop102 ~]$ cd ~/.ssh
     [atguigu@hadoop102 .ssh]$ ssh-keygen -t rsa
   ```

   之後連按三次 enter

   ```
    [atguigu@hadoop102 .ssh]$ ll
     總計 12
     -rw-------. 1 atguigu atguigu 1675  7月 31 23:35 id_rsa
     -rw-r--r--. 1 atguigu atguigu  399  7月 31 23:35 id_rsa.pub
     -rw-r--r--. 1 atguigu atguigu  558  7月 31 12:22 known_hosts
   ```

   可見產生了 `id_rsa` 與 `id_rsa.pub`

   ```
   [atguigu@hadoop102 .ssh]$ cat id_rsa
   -----BEGIN RSA PRIVATE KEY-----
   MIIEowIBAAKCAQEAx0KK+4r3v61PxJV8pGlpvlxz9HtCOHX1n/FWSQSAzxdLEMrO
   jsGiAgFO2L34uE/dC/JBtSklkRq7Rx5eAWjnLsQHvTEUIJ58x4S7ZeUBMTXGTGBm
   /FBiSI7743DuW23dEqzIFwOy280TDJPhRT0Tej3GK/LqtATrtAyzZOMA7K/vI85u
   hv0jNwLSru1m3eoRMWfsGgT6mYdF7EzHh/PhoyGhCOBNNYw5j4oX8ToQy79jCEVQ
   fDDkLQW66WZZSyb3BQhb7YZhnIsewZ1Zu6j23rfRhUYDCApVCPidYnQ8zns8ca0w
   DeSkAcY2OsEJo2TIqWiwwtzKi25qAvIx73gWJwIDAQABAoIBAQDG/gxgQxtCX+l+
   kC9G3kMNKbVfXcz3J85hqZmbGBUvO7rqjS8VYAjT6cx9JdMC9jbxnEDEk9ABhmmr
   D4ef7syZZom4BhBstvo0IrknfDjhlStw0QFoTzqn7ateK0TPJ/uUj9rPKRFw8u9o
   KzLYe7M86/5Bm7mKiDN/vwNU6GLe+twaHYfCMLkyRYzkwIOfETbRgnotk5Q2imy8
   Zcv1enJx9PxWjW0VlikXDexYoyZcWo++avvJwfNgdU6laln4d+9V3GUTIa3jrbMT
   l8OQV1OkqR8+gyLM7PfcyQfLpzxlFREQvRuauG6fHq6xkHRUOoFRjUsSoYeXpEoY
   NKZb3fQRAoGBAPKfSFle9+LQxjhfsIogElNV1zKrvkafTrScB3mhdCgFpZkgHg1o
   0gojX7XOp6OsrwgGC+EJIew+MuHwKMrB5cX6YK5tr1JNPlmJbbEZxS6Pj2NSEYON
   lNNdW96lua51tyufqanDnbBnqM+bKKQaM5lvjyjinh9aWq7tMQzNk/7fAoGBANI/
   LuKmIqD/EcuYr2pMXle3IQvKNjCTcgCOQNYGfDB9erkrdidNY6pXuWxYe0A/T2RV
   afq9p5Sprao7oh9TpBDW6l06CJUeapGXWSiUREMc55ZCLzVeNiNYzbXMAbd7bWI2
   3qBoUyBlyVA7vVAwQSAYpqL0hfUyDi52eETNIvm5AoGAfLcT4ZzHn3fh7KiDfvzt
   bpj5fbp6nKLXOk/aJ9OuecQtU4EG8a2oCj4UvMf1tFTXxDAXex3OqjluvmVNEqyJ
   CDOj7wXC0XOTUUMrd5Xfngd9lXhiOFVW4y9iQhi+UceA2JPCCtna/QrL46vGQFSX
   oY+O711OGp+/bZvPUt157dECgYBjAdoEZZP9GOC6bcZ9WkU7LUPkl275ZRXUaSjj
   IN6uvwhh1rOnQmxitTjearRvxuCOMSLdLx6RhW4AsmBgPDUQsQRgromIH3Cz6v/T
   ei7DJANy4Ov2R81ay+DjcZSFYRxbmdcw1q/+m7A3lkpKTs78XF9scZX7p3zCKIvu
   amPEEQKBgGnrBSIXyjtxS6swRgD4X5+60xQ5XeKDb7uzgsmAMkjejvhiGFft9xch
   /fV33EI6RFMUFT//OokjgIsFCfMT45hVg1/AAPCEiSK/Rm/Ukd185JZiQdX4CnK3
   geTb1LJq1xdp4lDbUFcWFcRJNNeLnyFtwbFUovrSzUcyZonr9X7F
   -----END RSA PRIVATE KEY-----
   [atguigu@hadoop102 .ssh]$ cat id_rsa.pub
   ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDHQor7ive/rU/ElXykaWm+XHP0e0I4dfWf8VZJBIDPF0sQys6OwaICAU7Yvfi4T90L8kG1KSWRGrtHHl4BaOcuxAe9MRQgnnzHhLtl5QExNcZMYGb8UGJIjvvjcO5bbd0SrMgXA7LbzRMMk+FFPRN6PcYr8uq0BOu0DLNk4wDsr+8jzm6G/SM3AtKu7Wbd6hExZ+waBPqZh0XsTMeH8+GjIaEI4E01jDmPihfxOhDLv2MIRVB8MOQtBbrpZllLJvcFCFvthmGcix7BnVm7qPbet9GFRgMIClUI+J1idDzOezxxrTAN5KQBxjY6wQmjZMipaLDC3MqLbmoC8jHveBYn atguigu@hadoop102
   ```

   2. 把密碼送到 hadoop103 去

   ```
   [atguigu@hadoop102 .ssh]$ ssh-copy-id hadoop103
   /usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/home/atguigu/.ssh/id_rsa.pub"
   /usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
   /usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
   ```

   3. 輸入 hadoop103 的密碼
   4. 可見以下訊息

   ```
   Number of key(s) added: 1

   Now try logging into the machine, with:   "ssh 'hadoop103'"
   and check to make sure that only the key(s) you wanted were added.
   ```

   5. 試著在 hadoop102 連線 hadoop103

   ```
    [atguigu@hadoop102 .ssh]$ ssh hadoop103
    Last login: Sun Jul 31 22:46:23 2022 from 192.168.10.1
    [atguigu@hadoop103 ~]$
   ```

   6. 在 102 上配置 104 & 102

   ```
    [atguigu@hadoop102 .ssh]$ ssh-copy-id hadoop104
    /usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/home/atguigu/.ssh/id_rsa.pub"
    /usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
    /usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
    atguigu@hadoop104's password:

    Number of key(s) added: 1

    Now try logging into the machine, with:   "ssh 'hadoop104'"
    and check to make sure that only the key(s) you wanted were added.

    [atguigu@hadoop102 .ssh]$ ssh hadoop104
    Last login: Sun Jul 31 22:48:00 2022 from 192.168.10.1
    [atguigu@hadoop104 ~]$ exit
    logout
    Connection to hadoop104 closed.
    [atguigu@hadoop102 .ssh]$ ssh hadoop102
    atguigu@hadoop102's password:
    Last login: Sun Jul 31 22:45:36 2022 from 192.168.10.1
    [atguigu@hadoop102 ~]$ exit
    logout
    Connection to hadoop102 closed.
   ```

   查看剛剛產生的 key (authorized_keys: 允許那些主機可以免密登入我)

   ```
    [atguigu@hadoop102 .ssh]$ ll
    總計 16
    -rw-------. 1 atguigu atguigu  399  8月  1 00:22 authorized_keys
    -rw-------. 1 atguigu atguigu 1675  7月 31 23:35 id_rsa
    -rw-r--r--. 1 atguigu atguigu  399  7月 31 23:35 id_rsa.pub
    -rw-r--r--. 1 atguigu atguigu  558  7月 31 12:22 known_hosts
    [atguigu@hadoop102 .ssh]$ cat authorized_keys
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDHQor7ive/rU/ElXykaWm+XHP0e0I4dfWf8VZJBIDPF0sQys6OwaICAU7Yvfi4T90L8kG1KSWRGrtHHl4BaOcuxAe9MRQgnnzHhLtl5QExNcZMYGb8UGJIjvvjcO5bbd0SrMgXA7LbzRMMk+FFPRN6PcYr8uq0BOu0DLNk4wDsr+8jzm6G/SM3AtKu7Wbd6hExZ+waBPqZh0XsTMeH8+GjIaEI4E01jDmPihfxOhDLv2MIRVB8MOQtBbrpZllLJvcFCFvthmGcix7BnVm7qPbet9GFRgMIClUI+J1idDzOezxxrTAN5KQBxjY6wQmjZMipaLDC3MqLbmoC8jHveBYn atguigu@hadoop102
    [atguigu@hadoop102 .ssh]$
   ```

   7. 換 hadoop103

   ```
    [atguigu@hadoop103 .ssh]$ ll
    總計 8
    -rw-------. 1 atguigu atguigu 399  7月 31 23:46 authorized_keys
    -rw-r--r--. 1 atguigu atguigu 186  7月 31 08:36 known_hosts
    [atguigu@hadoop103 .ssh]$ cat authorized_keys
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDHQor7ive/rU/ElXykaWm+XHP0e0I4dfWf8VZJBIDPF0sQys6OwaICAU7Yvfi4T90L8kG1KSWRGrtHHl4BaOcuxAe9MRQgnnzHhLtl5QExNcZMYGb8UGJIjvvjcO5bbd0SrMgXA7LbzRMMk+FFPRN6PcYr8uq0BOu0DLNk4wDsr+8jzm6G/SM3AtKu7Wbd6hExZ+waBPqZh0XsTMeH8+GjIaEI4E01jDmPihfxOhDLv2MIRVB8MOQtBbrpZllLJvcFCFvthmGcix7BnVm7qPbet9GFRgMIClUI+J1idDzOezxxrTAN5KQBxjY6wQmjZMipaLDC3MqLbmoC8jHveBYn atguigu@hadoop102
   ```

   在 hadoop103 中配置免密登入 hadoop102 & hadoop104 (參考 1-6)
   在 hadoop104 中配置免密登入 hadoop102 & hadoop103 (參考 1-6)

   8. 有空把 hadoop102 的 root 也配置一下對 hadoop103 & hadoop104 的 key
   9. 同理 hadoop103 & hadoop104 也是
   10. 測試

   ```
   [atguigu@hadoop102 ~] touch a.txt
   [atguigu@hadoop102 ~] xsync a.txt
   ======= hadoop102 ========
   sending incremental file list

   sent 61 bytes  received 12 bytes  48.67 bytes/sec
   total size is 0  speedup is 0.00
   ======= hadoop103 ========
   sending incremental file list
   a.txt

   sent 104 bytes  received 35 bytes  278.00 bytes/sec
   total size is 0  speedup is 0.00
   ======= hadoop104 ========
   sending incremental file list
   a.txt

   sent 104 bytes  received 35 bytes  278.00 bytes/sec
   total size is 0  speedup is 0.00
   ```

   成功!!

### 集群配置

1. 集群部屬規劃
   - 注意
     - NameNode 和 SecondaryNameNode 不要安裝在同一台服務器 因為都很耗內存
     - ResoruceManager 也很耗內存，不要和 NameNode、SecondaryNameNode 配置在同一台機器上。
   - hadoop102
     - HDFS
       - NameNode
       - DataNode
     - YARN
       - NodeManager
   - hadoop103
     - HDFS
       - DataNode
     - YARN
       - ResourceManager
       - NodeManager
   - hadoop104
     - HDFS
       - SecondaryNameNode
       - DataNode
     - YARN
       - NodeManager
2. 配置文件說明

   - hadoop 配置文件分兩類: 默認配置文件和自訂義配置文件，只有用戶想修改某一默認配置值時，才需要修改自訂義配置文件，更改相應屬性值。

   1. 默認配置文件 ( 四大模塊分別對應 ):
      | 要獲取的默認文件 | 文件存放在 hadoop 的 jar 包中的位置 | 模塊名稱 |
      | -------------------- | --------------------------------------------------------- | ---- |
      | [core-default.xml] | hadoop-common-3.1.4.jar/core-default.xml | common |
      | [hdfs-default.xml] | hadoop-hdfs-3.1.4.jar/hdfs-default.xml | hdfs |
      | [yarn-default.xml] | hadoop-yarn-common-3.1.4.jar/yarn-default.xml | yarn |
      | [mapred-default.xml] | hadoop-mapreduce-client-core-3.1.4.jar/mapred-default.xml | mapreduce |
   2. 自定義配置文件:
      - core-site.xml、 hdfs-site.xml、 yarn-site.xml、 mapred-site.xml 四個配置文件存放在 `$HADOOP_HOME/etc/hadoop` 這個路徑上，用戶可以根據項目需求重新進行修改配置。
   3. 配置集群

      1. 核心配置文件

         - 配置 `core-site.xml`

         ```
         [atguigu@hadoop102 ~]$ cd $HADOOP_HOME/etc/hadoop
         [atguigu@hadoop102 hadoop]$ vim core-site.xml
         ```

         - 文件內容如下

         ```
         <?xml version="1.0" encoding="UTF-8"?>
         <?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
         <!--
         Licensed under the Apache License, Version 2.0 (the "License");
         you may not use this file except in compliance with the License.
         You may obtain a copy of the License at

           http://www.apache.org/licenses/LICENSE-2.0

         Unless required by applicable law or agreed to in writing, software
         distributed under the License is distributed on an "AS IS" BASIS,
         WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
         See the License for the specific language governing permissions and
         limitations under the License. See accompanying LICENSE file.
         -->

         <!-- Put site-specific property overrides in this file. -->

         <configuration>
             <!-- 指定 NameNode 的地址 -->
             <property>
                 <name>fs.defaultFS</name>
                 <value>hdfs://hadoop102:8020</value>
             </property>
             <!-- 指定 NameNode 的數據存儲目錄 -->
             <property>
                 <name>hadoop.tmp.dir</name>
                 <value>/opt/module/hadoop-3.1.4/data</value>
             </property>
             <!-- 配置 NameNode 網頁登入使用的靜態用戶為 atguigu -->
             <property>
                 <name>hadoop.http.staticuser.user</name>
                 <value>atguigu</value>
             </property>
         </configuration>
         ```

      2. HDFS 配置文件
         - 配置 `hdfs-site.xml`
         ```
         [atguigu@hadoop102 hadoop]$ vim hdfs-site.xml
         ```
         - 文件內容如下
         ```
          <configuration>
              <!-- 指定 nn web端訪問地址 -->
              <property>
                  <name>dfs.namenode.http-address</name>
                  <value>hadoop102:9870</value>
              </property>
              <!-- 2nn web端訪問地址  -->
              <property>
                  <name>dfs.namenode.secondary.http-address</name>
                  <value>hadoop104:9868</value>
             </property>
          </configuration>
         ```
      3. YARN 配置文件
         - 配置 `yarn-site.xml`
         ```
         [atguigu@hadoop102 hadoop]$ vim yarn-site.xml
         ```
         - 文件內容如下
         ```
          <configuration>
              <!-- 指定 MR 走 shuffle -->
              <property>
                  <name>yarn.nodemanager.aux-services</name>
                  <value>mapreduce_shuffle</value>
              </property>
              <!-- 指定 ResourceManager 的地址 -->
              <property>
                  <name>yarn.resourcemanager.hostname</name>
                  <value>hadoop103</value>
              </property>
              <!-- 環境變量的繼承 , 3.2 版以後不用加這個-->
              <property>
                  <name>yarn.nodemanager.env-whitelist</name>
                  <value>JAVA_HOME,HADOOP_COMMON,HADOOP_HDFS_HOME,HADOOP_CONF_DIR,CLASSPATH_PREPEND_DISTCACHE,HADOOP_YARN_HOME,HADOOP_MAPRED_HOME</value>
              </property>
          </configuration>
         ```
      4. MapReduce 配置文件
         - 配置 `mapred-site.xml`
         ```
         [atguigu@hadoop102 hadoop]$ vim mapred-site.xml
         ```
         - 文件內容如下
         ```
          <configuration>
          <!-- 指定 MapReduce 程序運行在 Yarn 上 -->
              <property>
                  <name>mapreduce.framework.name</name>
                  <value>yarn</value>
              </property>
         </configuration>
         ```

   4. 在集群上分發配置好的 hadoop 配置文件
      ```
      [atguigu@hadoop102 hadoop]$ xsync /opt/module/hadoop-3.1.4/etc/hadoop
      ```
   5. 去 hadoop103 和 hadoop104 上查看文件分發情況
      ```
      [atguigu@hadoop103 ~]$ cat /opt/module/hadoop-3.1.4/etc/hadoop/core-site.xml
      [atguigu@hadoop104 ~]$ cat /opt/module/hadoop-3.1.4/etc/hadoop/core-site.xml
      ```

### 群起集群

1. 配置 workers
   ```
   [atguigu@hadoop102 hadoop]$ vim /opt/module/hadoop-3.1.4/etc/hadoop/workers
   ```
   - 在該文件中增加如下內容 ( 默認的 localhost 刪了 )
   ```
   hadoop102
   hadoop103
   hadoop104
   ```
   _注意: 該文件中添加的內容結尾不允許有空格，文件中不允許有空行。_
   ```
   [atguigu@hadoop102 hadoop]$xsync /opt/module/hadoop-3.1.4/etc
   ```
2. 啟動集群
   1. _如果是第一次啟動_，需要在 hadoop102 結點格式化 NameNode ( 注意: 格式化 NameNode，會產生新的集群 id，導致 NameNode 和 DataNode 的集群 id 不一致，集群找不到以往數據。如果集群在運行過程中報錯，需要重新格式化 NameNode 的話，一定要先停止 NameNode 和 DataNode 進程，並且要刪除所有機器的 data 和 logs 目錄，然後再進行格式化。)
      ```
      [atguigu@hadoop102 hadoop-3.1.4]$ hdfs namenode -format
      ```
   - 如果成功，`/opt/module/hadoop-3.1.4/` 會產生一個 data ，裡面有 data/dfs/name
   - 查看一下 VERSION
     ```
     [atguigu@hadoop102 ~] cat /opt/module/hadoop-3.1.4/data/dfs/name/current/VERSION
     #Tue Aug 02 01:13:57 CST 2022
     namespaceID=1901990470
     clusterID=CID-3363d696-c09f-4407-8bd2-075507f44675
     cTime=1659374037667
     storageType=NAME_NODE
     blockpoolID=BP-1820893376-192.168.10.102-1659374037667
     layoutVersion=-64
     ```
   2. 啟動 HDFS
   ```
   [atguigu@hadoop102 hadoop-3.1.4]$ sbin/start-dfs.sh
   Starting namenodes on [hadoop102]
   Starting datanodes
   hadoop104: WARNING: /opt/module/hadoop-3.1.4/logs does not exist. Creating.
   hadoop103: WARNING: /opt/module/hadoop-3.1.4/logs does not exist. Creating.
   Starting secondary namenodes [hadoop104]
   ```
   查看 NameNode 有沒有起來
   ```
   [atguigu@hadoop102 hadoop-3.1.4]$ jps
   62853 NameNode
   62971 DataNode
   63230 Jps
   [atguigu@hadoop103 hadoop-3.1.4]$ jps
   61408 DataNode
   61499 Jps
   [atguigu@hadoop104 hadoop]$ jps
   61376 SecondaryNameNode
   61269 DataNode
   61449 Jps
   ```
   3. 在配置了 ResourceManager 的節點 (hadoop103) 啟動 YARN
   ```
   [atguigu@hadoop103 hadoop-3.1.4]$ sbin/start-yarn.sh
   ```
   4. Web 端查看 HDFS 的 NameNode
      1. 瀏覽器輸入: http://hadoop102:9870
      2. 點選導航列的 Utilities
      3. 展開下拉選項
      4. 點選 Browse the file system
      5. 查看 HDFS 上存儲的信息
   5. Web 端查看 YARN 的 ResourceManager
      1. 瀏覽器輸入: http://hadoop103:8088
      2. 查看 YARN 上運行的 job 信息

## 錯誤排除

如果啟動途中 發現這種訊息
AJM6892

```
[atguigu@hadoop103 hadoop-3.1.4]$ sbin/start-yarn.sh
Starting resourcemanager
Starting nodemanagers
hadoop103: Permission denied (publickey,gssapi-keyex,gssapi-with-mic,password).
```

代表那台機器 ( 如: hadoop103 ) 沒有配置金鑰登入,
使用以下指令加上金鑰登入即可

```
[atguigu@hadoop102 .ssh]$ ssh-copy-id hadoop103
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/home/atguigu/.ssh/id_rsa.pub"
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
```

### 測試創建小文件

```
[atguigu@hadoop102 hadoop-3.1.4]$ hadoop fs -mkdir /wcinput
```

1. 查看 `http://hadoop102:9870/explorer.html#/`

2. 發現多了一個 wcinput 的文件

- 把 hadoop102 的 word.txt 上傳到 hdfs

```
[atguigu@hadoop102 hadoop-3.1.4]$ hadoop fs -put wcinput/word.txt /wcinput
```

1. 查看 `http://hadoop102:9870/explorer.html#/`

2. 點擊 wcinput

3. 發現裡面出現 word.txt

4. 點擊 word.txt

5. 點選 Tail the file

6. 可以看到以下內容

```
ss ss
cls cls
banzhang
yangge
```

7. 想要下載可以點 Download

### 測試創建大文件

把 jdk 丟上去

```
[atguigu@hadoop102 hadoop-3.1.4]$ hadoop fs -put /opt/software/jdk-8u202-linux-x64.tar.gz /
```

1. 查看 `http://hadoop102:9870/explorer.html#/`
2. 輸入框打入 `/ `
3. 發現多了一個 `jdk-8u202-linux-x64.tar.gz` 的文件

### 東西存在哪?

在這

`/opt/module/hadoop-3.1.4/data`

這是當初配置集群文件時配置的

```
[atguigu@hadoop102 hadoop]$ vim core-site.xml
```

這段

```
    <property>
        <name>hadoop.tmp.dir</name>
        <value>/opt/module/hadoop-3.1.4/data</value>
    </property>
```

進去看文件怎麼存的

```
[atguigu@hadoop102 subdir0]$ pwd
/opt/module/hadoop-3.1.4/data/dfs/data/current/BP-1820893376-192.168.10.102-1659374037667/current/finalized/subdir0/subdir0
[atguigu@hadoop102 subdir0]$ ll
總計 58884
-rw-rw-r--. 1 atguigu atguigu 59825109  7月 27 17:30 blk_1073741827
-rw-rw-r--. 1 atguigu atguigu   467391  7月 27 17:30 blk_1073741827_1003.meta
```

_BP-1820893376-192.168.10.102-1659374037667_ 這段每台機器都不同, 請自行進入對應的 forder

```
進入 hadoop103 發現有一個132M的檔案
[atguigu@hadoop103 subdir0]$ cd /opt/module/hadoop-3.1.4/data/dfs/data/current/BP-1820893376-192.168.10.102-1659374037667/current/finalized/subdir0/subdir0
[atguigu@hadoop103 subdir0]$ ll
總計 132108
-rw-rw-r--. 1 atguigu atguigu        30  7月 27 17:25 blk_1073741825
-rw-rw-r--. 1 atguigu atguigu        11  7月 27 17:25 blk_1073741825_1001.meta
-rw-rw-r--. 1 atguigu atguigu 134217728  7月 27 17:30 blk_1073741826
-rw-rw-r--. 1 atguigu atguigu   1048583  7月 27 17:30 blk_1073741826_1002.meta
```

把他放入 tar.gz

```
[atguigu@hadoop103 subdir0]$ cat blk_1073741826>>tmp.tar.gz
[atguigu@hadoop103 subdir0]$ ll
總計 263180
-rw-rw-r--. 1 atguigu atguigu        30  7月 27 17:25 blk_1073741825
-rw-rw-r--. 1 atguigu atguigu        11  7月 27 17:25 blk_1073741825_1001.meta
-rw-rw-r--. 1 atguigu atguigu 134217728  7月 27 17:30 blk_1073741826
-rw-rw-r--. 1 atguigu atguigu   1048583  7月 27 17:30 blk_1073741826_1002.meta
-rw-rw-r--. 1 atguigu atguigu 134217728  7月 27 18:36 tmp.tar.gz
```

把他解壓

```
[atguigu@hadoop103 subdir0]$ tar -zxvf tmp.tar.gz
```

解出來就是 jdk 了

```
[atguigu@hadoop103 subdir0]$ ll
總計 263180
-rw-rw-r--. 1 atguigu atguigu        30  7月 27 17:25 blk_1073741825
-rw-rw-r--. 1 atguigu atguigu        11  7月 27 17:25 blk_1073741825_1001.meta
-rw-rw-r--. 1 atguigu atguigu 134217728  7月 27 17:30 blk_1073741826
-rw-rw-r--. 1 atguigu atguigu   1048583  7月 27 17:30 blk_1073741826_1002.meta
drwxr-xr-x. 7 atguigu atguigu       226 12月 16  2018 jdk1.8.0_202
-rw-rw-r--. 1 atguigu atguigu 134217728  7月 27 18:36 tmp.tar.gz
```

### 執行計算任務

```
[atguigu@hadoop102 hadoop-3.1.4]$ hadoop jar share/hadoop/mapreduce/hadoop-mapreduce-examples-3.1.4.jar wordcount /wcinput /wcoutput
2024-07-27 20:03:35,070 INFO client.RMProxy: Connecting to ResourceManager at hadoop103/192.168.10.103:8032
2024-07-27 20:03:35,781 INFO mapreduce.JobResourceUploader: Disabling Erasure Coding for path: /tmp/hadoop-yarn/staging/atguigu/.staging/job_1722081559445_0001
2024-07-27 20:03:36,353 INFO input.FileInputFormat: Total input files to process : 1
2024-07-27 20:03:36,448 INFO mapreduce.JobSubmitter: number of splits:1
2024-07-27 20:03:36,670 INFO mapreduce.JobSubmitter: Submitting tokens for job: job_1722081559445_0001
2024-07-27 20:03:36,671 INFO mapreduce.JobSubmitter: Executing with tokens: []
2024-07-27 20:03:36,855 INFO conf.Configuration: resource-types.xml not found
2024-07-27 20:03:36,855 INFO resource.ResourceUtils: Unable to find 'resource-types.xml'.
2024-07-27 20:03:37,309 INFO impl.YarnClientImpl: Submitted application application_1722081559445_0001
2024-07-27 20:03:37,364 INFO mapreduce.Job: The url to track the job: http://hadoop103:8088/proxy/application_1722081559445_0001/
2024-07-27 20:03:37,365 INFO mapreduce.Job: Running job: job_1722081559445_0001
2024-07-27 20:03:46,604 INFO mapreduce.Job: Job job_1722081559445_0001 running in uber mode : false
2024-07-27 20:03:46,605 INFO mapreduce.Job:  map 0% reduce 0%
2024-07-27 20:03:52,694 INFO mapreduce.Job:  map 100% reduce 0%
2024-07-27 20:03:57,749 INFO mapreduce.Job:  map 100% reduce 100%
2024-07-27 20:03:57,773 INFO mapreduce.Job: Job job_1722081559445_0001 completed successfully
2024-07-27 20:03:57,916 INFO mapreduce.Job: Counters: 53
        File System Counters
                FILE: Number of bytes read=53
                FILE: Number of bytes written=442411
                FILE: Number of read operations=0
                FILE: Number of large read operations=0
                FILE: Number of write operations=0
                HDFS: Number of bytes read=133
                HDFS: Number of bytes written=31
                HDFS: Number of read operations=8
                HDFS: Number of large read operations=0
                HDFS: Number of write operations=2
        Job Counters
                Launched map tasks=1
                Launched reduce tasks=1
                Data-local map tasks=1
                Total time spent by all maps in occupied slots (ms)=3540
                Total time spent by all reduces in occupied slots (ms)=3217
                Total time spent by all map tasks (ms)=3540
                Total time spent by all reduce tasks (ms)=3217
                Total vcore-milliseconds taken by all map tasks=3540
                Total vcore-milliseconds taken by all reduce tasks=3217
                Total megabyte-milliseconds taken by all map tasks=3624960
                Total megabyte-milliseconds taken by all reduce tasks=3294208
        Map-Reduce Framework
                Map input records=4
                Map output records=6
                Map output bytes=54
                Map output materialized bytes=53
                Input split bytes=103
                Combine input records=6
                Combine output records=4
                Reduce input groups=4
                Reduce shuffle bytes=53
                Reduce input records=4
                Reduce output records=4
                Spilled Records=8
                Shuffled Maps =1
                Failed Shuffles=0
                Merged Map outputs=1
                GC time elapsed (ms)=84
                CPU time spent (ms)=1020
                Physical memory (bytes) snapshot=342560768
                Virtual memory (bytes) snapshot=5045940224
                Total committed heap usage (bytes)=230821888
                Peak Map Physical memory (bytes)=222322688
                Peak Map Virtual memory (bytes)=2519580672
                Peak Reduce Physical memory (bytes)=120238080
                Peak Reduce Virtual memory (bytes)=2526359552
        Shuffle Errors
                BAD_ID=0
                CONNECTION=0
                IO_ERROR=0
                WRONG_LENGTH=0
                WRONG_MAP=0
                WRONG_REDUCE=0
        File Input Format Counters
                Bytes Read=30
        File Output Format Counters
                Bytes Written=31
```

成功後訪問 `http://hadoop102:9870/explorer.html#/wcoutput`

點擊 `part-r-00000`

點擊 `Tail the file (last 32K)`

可以看到計算結果

```
banzhang	1
cls	2
ss	2
yangge	1
```

如果出現

```
[atguigu@hadoop102 hadoop-3.1.4]$ hadoop jar share/hadoop/mapreduce/hadoop-mapreduce-examples-3.1.4.jar wordcount /wcinput /wcoutput
2024-07-27 19:31:33,349 INFO client.RMProxy: Connecting to ResourceManager at hadoop103/192.168.10.103:8032
org.apache.hadoop.mapred.FileAlreadyExistsException: Output directory hdfs://hadoop102:8020/wcoutput already exists
        at org.apache.hadoop.mapreduce.lib.output.FileOutputFormat.checkOutputSpecs(FileOutputFormat.java:164)
        at org.apache.hadoop.mapreduce.JobSubmitter.checkSpecs(JobSubmitter.java:277)
        at org.apache.hadoop.mapreduce.JobSubmitter.submitJobInternal(JobSubmitter.java:143)
        at org.apache.hadoop.mapreduce.Job$11.run(Job.java:1570)
        at org.apache.hadoop.mapreduce.Job$11.run(Job.java:1567)
        at java.security.AccessController.doPrivileged(Native Method)
        at javax.security.auth.Subject.doAs(Subject.java:422)
        at org.apache.hadoop.security.UserGroupInformation.doAs(UserGroupInformation.java:1729)
        at org.apache.hadoop.mapreduce.Job.submit(Job.java:1567)
        at org.apache.hadoop.mapreduce.Job.waitForCompletion(Job.java:1588)
        at org.apache.hadoop.examples.WordCount.main(WordCount.java:87)
        at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
        at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)
        at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
        at java.lang.reflect.Method.invoke(Method.java:498)
        at org.apache.hadoop.util.ProgramDriver$ProgramDescription.invoke(ProgramDriver.java:71)
        at org.apache.hadoop.util.ProgramDriver.run(ProgramDriver.java:144)
        at org.apache.hadoop.examples.ExampleDriver.main(ExampleDriver.java:74)
        at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
        at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)
        at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
        at java.lang.reflect.Method.invoke(Method.java:498)
        at org.apache.hadoop.util.RunJar.run(RunJar.java:318)
        at org.apache.hadoop.util.RunJar.main(RunJar.java:232)
```

代表`wcoutput`資料夾已經存在了, 不要用 `rm -rf wcoutput`來刪, 會刪不乾淨, 執行以下指令刪除

```
[atguigu@hadoop102 hadoop-3.1.4]$ hadoop fs -rm -r /wcoutput
Deleted /wcoutput
[atguigu@hadoop102 hadoop-3.1.4]$
```

### 集群崩潰的處理方法

- 模擬集群崩潰

砍了 DataNode

```
[atguigu@hadoop102 hadoop-3.1.4]$ jps
16386 NodeManager
17396 Jps
15273 NameNode
15403 DataNode
[atguigu@hadoop102 hadoop-3.1.4]$ kill -9 14503
-bash: kill: (14503) - 沒有此一程序
[atguigu@hadoop102 hadoop-3.1.4]$ kill -9 15403
[atguigu@hadoop102 hadoop-3.1.4]$ jps
17409 Jps
16386 NodeManager
15273 NameNode
```

data 也砍

```
[atguigu@hadoop102 hadoop-3.1.4]$ rm -rf data
[atguigu@hadoop102 hadoop-3.1.4]$ ll
總計 180
drwxr-xr-x. 2 atguigu atguigu    183  7月 21  2020 bin
drwxr-xr-x. 3 atguigu atguigu     20  7月 21  2020 etc
drwxr-xr-x. 2 atguigu atguigu    106  7月 21  2020 include
drwxr-xr-x. 3 atguigu atguigu     20  7月 21  2020 lib
drwxr-xr-x. 4 atguigu atguigu    288  7月 21  2020 libexec
-rw-rw-r--. 1 atguigu atguigu 147145  7月 21  2020 LICENSE.txt
drwxrwxr-x. 3 atguigu atguigu   4096  7月 27 19:59 logs
-rw-rw-r--. 1 atguigu atguigu  21867  7月 21  2020 NOTICE.txt
-rw-rw-r--. 1 atguigu atguigu   1366  7月 21  2020 README.txt
drwxr-xr-x. 3 atguigu atguigu   4096  7月 21  2020 sbin
drwxr-xr-x. 4 atguigu atguigu     31  7月 21  2020 share
drwxrwxr-x. 2 atguigu atguigu     22  7月 31  2022 wcinput
[atguigu@hadoop102 hadoop-3.1.4]$
```

到 103 上面砍 data

```
[atguigu@hadoop103 hadoop-3.1.4]$ rm -rf data
```

到 104 上面砍 data

```
[atguigu@hadoop104 hadoop-3.1.4]$ rm -rf data
```

訪問 `http://hadoop102:9870/explorer.html#/wcinput`
點擊 `Download`

嘗試全關了再重啟

- 全關了

```
[atguigu@hadoop104 hadoop-3.1.4]$ sbin/stop-dfs.sh
Stopping namenodes on [hadoop102]
Stopping datanodes
Stopping secondary namenodes [hadoop104]
[atguigu@hadoop104 hadoop-3.1.4]$ sbin/stop-yarn.sh
Stopping nodemanagers
hadoop104: WARNING: nodemanager did not stop gracefully after 5 seconds: Trying to kill with kill -9
Stopping resourcemanager
[atguigu@hadoop104 hadoop-3.1.4]$
```

- 到 102 重啟 dfs

```
[atguigu@hadoop102 hadoop-3.1.4]$ jps
17866 Jps
[atguigu@hadoop102 hadoop-3.1.4]$ sbin/start-dfs.sh
Starting namenodes on [hadoop102]
Starting datanodes
Starting secondary namenodes [hadoop104]
[atguigu@hadoop102 hadoop-3.1.4]$ jps
18391 Jps
18186 DataNode
[atguigu@hadoop102 hadoop-3.1.4]$
```

發現 NameNode 掛了

因為剛剛 data 中的 name 被砍了

```
[atguigu@hadoop102 hadoop-3.1.4]$ ll data/dfs/
總計 0
drwx------. 2 atguigu atguigu 6  7月 27 21:01 data
```

嘗試格式化 hdfs

```
[atguigu@hadoop102 hadoop-3.1.4]$ hdfs namenode -format
```

訪問 `http://hadoop102:9870/`

- 發現連不上了

NameNode 也沒起來

```
[atguigu@hadoop102 hadoop-3.1.4]$ jps
18531 Jps
18186 DataNode
```

### 正確處理方法

只要`bin` `etc` 不要壞就好

1. 先殺進程(process)

```
[atguigu@hadoop102 hadoop-3.1.4]$ sbin/stop-dfs.sh
Stopping namenodes on [hadoop102]
Stopping datanodes
Stopping secondary namenodes [hadoop104]
[atguigu@hadoop102 hadoop-3.1.4]$ jps
18988 Jps
[atguigu@hadoop102 hadoop-3.1.4]$
```

2. 到每個集群上砍了 `data` `logs`

```
[atguigu@hadoop102 hadoop-3.1.4]$ rm -rf data/ logs/
[atguigu@hadoop103 hadoop-3.1.4]$ rm -rf data/ logs/
[atguigu@hadoop104 hadoop-3.1.4]$ rm -rf data/ logs/
```

3. 砍完再格式化

```
[atguigu@hadoop102 hadoop-3.1.4]$ hdfs namenode -format
```

會跳出一堆訊息, 就不貼了

4. 啟動集群

```
[atguigu@hadoop102 hadoop-3.1.4]$ sbin/start-dfs.sh
Starting namenodes on [hadoop102]
Starting datanodes
hadoop104: WARNING: /opt/module/hadoop-3.1.4/logs does not exist. Creating.
hadoop103: WARNING: /opt/module/hadoop-3.1.4/logs does not exist. Creating.
Starting secondary namenodes [hadoop104]
[atguigu@hadoop102 hadoop-3.1.4]$ jps
19234 NameNode
19387 DataNode
19612 Jps
```

啟動 yarn

```
[atguigu@hadoop102 hadoop-3.1.4]$ sbin/start-yarn.sh
Starting resourcemanager
Starting nodemanagers
[atguigu@hadoop102 hadoop-3.1.4]$ jps
19234 NameNode
20262 NodeManager
19387 DataNode
20398 Jps
```

5. 訪問 http://hadoop102:9870/explorer.html#/

### 配置歷史服務器

1. 編輯檔案

```
[atguigu@hadoop102 hadoop-3.1.4]$ vim etc/hadoop/mapred-site.xml
```

2. 添加以下設定

```
...
    <!-- 設置歷史服務器地址 -->
    <property>
        <name>mapreduce.jobhistory.address</name>
        <value>hadoop102:10020</value>
    </property>
    <!-- 歷史服務器 web 端地址 -->
    <property>
        <name>mapreduce.jobhistory.webapp.address</name>
        <value>hadoop102:19888</value>
    </property>
...
```

3. 分發配置

```
[atguigu@hadoop102 hadoop-3.1.4]$ cd etc/hadoop/
[atguigu@hadoop102 hadoop]$ xsync mapred-site.xml
======= hadoop102 ========
sending incremental file list

sent 72 bytes  received 12 bytes  168.00 bytes/sec
total size is 1,248  speedup is 14.86
======= hadoop103 ========
sending incremental file list
mapred-site.xml

sent 671 bytes  received 47 bytes  1,436.00 bytes/sec
total size is 1,248  speedup is 1.74
======= hadoop104 ========
sending incremental file list
mapred-site.xml

sent 671 bytes  received 47 bytes  478.67 bytes/sec
total size is 1,248  speedup is 1.74
```

4. 到 103 關閉 yarn 再重啟

```
[atguigu@hadoop103 hadoop-3.1.4]$ sbin/stop-yarn.sh
Stopping nodemanagers
Stopping resourcemanager
[atguigu@hadoop103 hadoop-3.1.4]$ sbin/start-yarn.sh
Starting resourcemanager
Starting nodemanagers
[atguigu@hadoop103 hadoop-3.1.4]$
```

5. 在 102 上啟動歷史服務器

```
[atguigu@hadoop102 hadoop]$ mapred --daemon start historyserver
[atguigu@hadoop102 hadoop]$ jps
21457 NodeManager
19234 NameNode
21642 JobHistoryServer
19387 DataNode
21679 Jps
[atguigu@hadoop102 hadoop]$
```

6. 測試歷史服務器

因為之前 /wcinput 被刪了, 所以這裡重新建立一個 /input

```
[atguigu@hadoop102 hadoop]$ hadoop fs -mkdir /input
```

先回到 hadoop-3.1.4

```
[atguigu@hadoop102 hadoop-3.1.4]$ cd /opt/module/hadoop-3.1.4
```

把 wcinput/word.txt 放入 /input

```
[atguigu@hadoop102 hadoop-3.1.4]$ hadoop fs -put wcinput/word.txt /input
```

運行任務

```
[atguigu@hadoop102 hadoop-3.1.4]$ hadoop jar share/hadoop/mapreduce/hadoop-mapreduce-examples-3.1.4.jar wordcount /input /output
```

訪問 `http://hadoop103:8088/cluster`

點選 `history` 打開歷史服務器

會跳到 `http://hadoop102:19888`

### 配置日誌聚集

0. 進入點

- `http://hadoop102:19888/jobhistory/job/[jobID]`

- 例如`http://hadoop102:19888/jobhistory/job/job_1722092974610_0001`
- 點選 `logs`
  發現錯誤訊息,

```
Aggregation is not enabled. Try the nodemanager at hadoop104:33318
Or see application log at http://hadoop104:8042/node/application/application_1722092974610_0001
```

1. 進入 102 修改 yarn-site.xml

```
[atguigu@hadoop102 hadoop-3.1.4]$ vim etc/hadoop/yarn-site.xml
```

2. 加入以下設置

```
    <!-- 開啟日誌聚集 -->
    <property>
        <name>yarn.log-aggregation-enable</name>
        <value>true</value>
    </property>
    <!-- 設置日誌聚集服務器位置 -->
    <property>
        <name>yarn.log.server.url</name>
        <value>http://hadoop102:19888/jobhistory/logs</value>
    </property>
    <!-- 設置日誌保留時間為7天 -->
    <property>
        <name>yarn.log-aggregation.retain-seconds</name>
        <value>604800</value>
    </property>
```

3. 分發配置

```
[atguigu@hadoop102 hadoop-3.1.4]$ xsync etc/hadoop/yarn-site.xml
======= hadoop102 ========
sending incremental file list

sent 70 bytes  received 12 bytes  164.00 bytes/sec
total size is 1,706  speedup is 20.80
======= hadoop103 ========
sending incremental file list
yarn-site.xml

sent 1,127 bytes  received 47 bytes  2,348.00 bytes/sec
total size is 1,706  speedup is 1.45
======= hadoop104 ========
sending incremental file list
yarn-site.xml

sent 1,127 bytes  received 47 bytes  2,348.00 bytes/sec
total size is 1,706  speedup is 1.45
```

4. 關閉 NodeManager, ResourceManager 和 HistoryServer

先在 hadooop102 關 historyserver

```
[atguigu@hadoop102 hadoop-3.1.4]$ mapred --daemon stop historyserver
```

到 hadoop103 關閉 yarn

```
[atguigu@hadoop103 hadoop-3.1.4]$ sbin/stop-yarn.sh
Stopping nodemanagers
hadoop104: WARNING: nodemanager did not stop gracefully after 5 seconds: Trying to kill with kill -9
hadoop102: WARNING: nodemanager did not stop gracefully after 5 seconds: Trying to kill with kill -9
hadoop103: WARNING: nodemanager did not stop gracefully after 5 seconds: Trying to kill with kill -9
Stopping resourcemanager
```

到 hadoop103 開啟 yarn

```
[atguigu@hadoop103 hadoop-3.1.4]$ sbin/start-yarn.sh
Starting resourcemanager
Starting nodemanagers
[atguigu@hadoop103 hadoop-3.1.4]$ jps
22352 DataNode
24578 Jps
24232 NodeManager
24093 ResourceManager
```

到 hadoop102 開啟 historyserver

```
[atguigu@hadoop102 hadoop-3.1.4]$ mapred --daemon start historyserver
[atguigu@hadoop102 hadoop-3.1.4]$ jps
31800 Jps
31481 JobHistoryServer
31674 NodeManager
29788 DataNode
29630 NameNode
```

```

```

這時再執行一個任務, 看看配置有沒有生效 ( 之前的任務 log 沒有聚合無法查看 )

回到 hadoop102 運行

```
[atguigu@hadoop102 hadoop-3.1.4]$ hadoop jar share/hadoop/mapreduce/hadoop-mapreduce-examples-3.1.4.jar wordcount /input /output2
```
