# Sausage Store

![image](https://user-images.githubusercontent.com/9394918/121517767-69db8a80-c9f8-11eb-835a-e98ca07fd995.png)


## Technologies used

* Frontend – TypeScript, Angular.
* Backend  – Java 16, Spring Boot, Spring Data.
* Database – H2.

## Installation guide

1. chmod +x install.axe
2. ./install.axe


####Chaper 6 Task 1

##    PostgreSQL single node
#1. host=rc1a-y0auvxa8pmxlqg94.mdb.yandexcloud.net \
#2. port=6432 \
#3. dbname=student \
#4. user=student \




 #   PostgreSQL 2 node cluster

#1. host=rc1a-7qbzfolspe11dctz.mdb.yandexcloud.net,rc1a-n767l0c2rfzu5bgw.mdb.yandexcloud.net \
#2. port=6432 \
#3. dbname=student \
#4. user=student \


# Пароль ко всем базам 123_456_789

# P.S PostgreSQL 2 node cluster на данный момент аварийно вышел из строя при попытке апгрейда PostgreSQL с 12 на 13. Создать его заново на данный момент не представляется возможным из-за фатальной ошибки. Error: error reading Cluster "c9qh1v6dnpfmtk5qcv0b": server-request-id = bf935514-3b0e-4050-9bcb-b4eb903ceb95 server-trace-id = ea39eedde5a23416:df7819e3faf43abd:ea39eedde5a23416:1 client-request-id = b66d3a90-83b3-4c84-bbf5-c8204b0e8d5d client-trace-id = 8b624108-1a95-4c1a-b0d5-9fbdcfb33504 rpc error: code = PermissionDenied desc = You do not have permission to access the requested object or object does not exist

# В саппорт я направил соответствующий тикет. База оаботает на PostgreSQL single node.