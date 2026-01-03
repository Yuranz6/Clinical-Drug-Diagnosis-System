# Gunicorn配置文件
import multiprocessing
import os

# 服务器socket
bind = "0.0.0.0:{}".format(os.environ.get("PORT", "5003"))
backlog = 2048

# 工作进程
workers = multiprocessing.cpu_count() * 2 + 1
worker_class = "sync"
worker_connections = 1000
timeout = 120
keepalive = 5

# 日志
accesslog = "-"
errorlog = "-"
loglevel = "info"
access_log_format = '%(h)s %(l)s %(u)s %(t)s "%(r)s" %(s)s %(b)s "%(f)s" "%(a)s"'

# 进程命名
proc_name = "cdss-api"

# 服务器机制
daemon = False
pidfile = None
umask = 0
user = None
group = None
tmp_upload_dir = None

