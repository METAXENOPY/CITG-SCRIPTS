import psutil
from collections import defaultdict

def get_ports():
    ports = defaultdict(list)
    for conn in psutil.net_connections(kind='inet'):
        laddr = f"{conn.laddr.ip}:{conn.laddr.port}" if conn.laddr else ""
        raddr = f"{conn.raddr.ip}:{conn.raddr.port}" if conn.raddr else ""
        ports[conn.status].append({
            "pid": conn.pid,
            "laddr": laddr,
            "raddr": raddr,
            "status": conn.status
        })
    return ports