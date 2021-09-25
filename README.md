# hadoop_notebook
**hadoop 開發/安裝筆記**

## 目前使用版本: hadoop3.1.3


# 參考了google的三篇論文

- GFS -> HDFS
- Map-Reduce -> MR
- BigTable -> HBase


#### hadoop1.x 

- Common (輔助工具)
- HDFS (數據存儲)
- MapReduce (計算+資源調度)

#### hadoop2.x

- Common (輔助工具)
- HDFS (數據存儲)
- Yarn(資源調度)
- MapReduce (計算)

#### hadoop3.x

**組成上沒有區別 **

# HDFS

- NameNode(nn): 儲存元數據, 文件名, 文件目錄結構, 文件屬性, 每個文件的塊列表和塊所在的DataNode等
- DataNode(dn): 本地文件系統存儲文件塊數據, 以及塊數據的校驗
- Secondary NameNode(2nn): 每隔一段時間對NameNode元數據備分


# Yarn

- Yet Another Resource Negotiator 資源協調者
	- Resource Manager: 整個集群資源的(CPU RAM)老大
	- Node Manager: 單個節點服務器資源的老大
	- Client: Job Submission 任務提交
	- ApplicationMaster: 單個任務的老大, 任務提交時會在NM產生一個AM
	- Container: 在NM中產生一個容器,運行AM, 相當於一台獨立的服務器, 裡面封裝了任務運行所需要的資源, 內存 CPU 磁盤 網路等, 當任務結束就將資源返還給NM 可向RM要更多的資源來運行任務, RM會分配資源給他, 甚至可以分配別的NM的資源
	
**客戶端可以有多個 **
**集群上可以運行多個ApplicationMaster **
**每個NM上可以有多個container
**一個container的ram 為1-8G, CPU最少要開一個

# MapReduce

- MapReduce 計算過程分兩步
	1. Map階段併行處裡輸入數據
	2. Reduce階段對Map進行彙總


	
Client -> ResourceManager -> Container(app master) -> ResourceManager(要資源) -> Container(MapTask) *N -> Container(ReduceTask)




