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
	+ 業務模型 數據可視畫 業務應用
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
192.168.33.9 hadoop100
192.168.33.11 hadoop101
192.168.33.12 hadoop102
192.168.33.13 hadoop103
192.168.33.14 hadoop104
192.168.33.15 hadoop105
192.168.33.16 hadoop106
192.168.33.17 hadoop107
192.168.33.18 hadoop108
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
# rpm -qa | grep -i java | xargs - n1 rpm -e --nodeps
```

rpm -qa: 查詢所安裝的所有rpm軟體包
grep -i: 忽略大小寫
xargs -n1: 表示每次只傳遞一個參數
rpm -e -nodeps: 強制卸載軟體

重啟虛擬機

```
# reboot
```


