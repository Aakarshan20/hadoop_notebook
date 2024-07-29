#!/bin/bash

if [ $# -lt 1 ]
then
        echo "No Args Input..."
        exit;
fi

case $l in
"start")
        echo " ================ 啟動 hadoop 集群 ================"
        echo " -------- 啟動 HDFS --------"
        ssh hadoop103 "/opt/module/hadoop-3.1.4/sbin/start-dfs.sh"
        echo " -------- 啟動 YARN --------"
        ssh hadoop103 "/opt/module/hadoop-3.1.4/sbin/start-yarn.sh"
        echo " -------- 啟動 historyserver --------"
        ssh hadoop102 "/opt/module/hadoop-3.1.4/bin/mapred --daemon start historyserver"
;;
"stop")
        echo " ================ 關閉 hadoop 集群 ================"
        echo " -------- 關閉 historyserver --------"
        ssh hadoop102 "/opt/module/hadoop-3.1.4/bin/mapred --daemon stop historyserver"
        echo " -------- 關閉 YARN --------"
        ssh hadoop103 "/opt/module/hadoop-3.1.4/sbin/stop-yarn.sh"
        echo " -------- 關閉 HDFS --------"
        ssh hadoop102 "/opt/module/hadoop-3.1.4/sbin/stop-dfs.sh"
;;
*)
        echo "Input Args Error..."
;;
esac