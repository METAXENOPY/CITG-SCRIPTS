import sys
import nmap
import socket
import threading
from PyQt6.QtCore import Qt, pyqtSlot, QMetaObject, Q_ARG
from PyQt6.QtWidgets import QApplication, QWidget, QVBoxLayout, QHBoxLayout, QLabel, QLineEdit, QPushButton, QListWidget, QListWidgetItem, QMessageBox
from scapy.all import ARP, Ether, srp

class LANScanTab(QWidget):
    def __init__(self):
        super().__init__()

        self.setWindowTitle("LAN Scan")
        layout = QVBoxLayout()

        subnet_layout = QHBoxLayout()
        subnet_label = QLabel("Subnet (CIDR):")
        self.subnet_input = QLineEdit("192.168.1.0/24")
        subnet_layout.addWidget(subnet_label)
        subnet_layout.addWidget(self.subnet_input)

        self.scan_btn = QPushButton("Scan LAN")
        self.scan_btn.clicked.connect(self.start_scan)

        self.result_list = QListWidget()
        self.result_list.itemDoubleClicked.connect(self.show_ip_details)

        layout.addLayout(subnet_layout)
        layout.addWidget(self.scan_btn)
        layout.addWidget(self.result_list)

        self.setLayout(layout)

    def start_scan(self):
        subnet = self.subnet_input.text()
        self.result_list.clear()
        self.scan_btn.setEnabled(False)
        self.scan_thread = threading.Thread(target=self.scan_network_thread, args=(subnet,), daemon=True)
        self.scan_thread.start()

    def scan_network_thread(self, subnet):
        live_hosts = self.scan_network(subnet)
        self.update_results(live_hosts)

    def scan_network(self, subnet):
        live_hosts = []
        arp_request = ARP(pdst=subnet)
        broadcast = Ether(dst="ff:ff:ff:ff:ff:ff")
        arp_request_broadcast = broadcast/arp_request
        answered_list = srp(arp_request_broadcast, timeout=1, verbose=False)[0]
        for element in answered_list:
            live_hosts.append(element[1].psrc)
        return live_hosts

    def update_results(self, live_hosts):
        def update():
            self.result_list.clear()
            for ip in live_hosts:
                item = QListWidgetItem(ip)
                self.result_list.addItem(item)
            self.scan_btn.setEnabled(True)

        QMetaObject.invokeMethod(self, "run_update", Qt.ConnectionType.QueuedConnection, Q_ARG(object, live_hosts))

    @pyqtSlot(object)
    def run_update(self, live_hosts):
        self.result_list.clear()
        for ip in live_hosts:
            item = QListWidgetItem(ip)
            self.result_list.addItem(item)
        self.scan_btn.setEnabled(True)

    def show_ip_details(self, item):
        ip = item.text()
        hostname = self.get_hostname(ip)
        mac_address = self.get_mac_address(ip)
        open_ports = self.get_open_ports(ip)

        details = f"IP: {ip}\nHostname: {hostname}\nMAC: {mac_address}\nOpen Ports:\n"
        for port, state in open_ports.items():
            details += f"  {port}: {state}\n"

        msg = QMessageBox()
        msg.setWindowTitle(f"Details for {ip}")
        msg.setText(details)
        msg.setIcon(QMessageBox.Icon.Information)
        msg.exec()

    def get_hostname(self, ip):
        try:
            return socket.gethostbyaddr(ip)[0]
        except socket.herror:
            return "Unknown"

    def get_mac_address(self, ip):
        arp_request = ARP(pdst=ip)
        broadcast = Ether(dst="ff:ff:ff:ff:ff:ff")
        arp_request_broadcast = broadcast/arp_request
        answered_list = srp(arp_request_broadcast, timeout=1, verbose=False)[0]
        for element in answered_list:
            if element[1].psrc == ip:
                return element[1].hwsrc
        return "Unknown"

    def get_open_ports(self, ip):
        nm = nmap.PortScanner()
        open_ports = {}
        try:
            nm.scan(ip, '1-1024')
            for proto in nm[ip].all_protocols():
                lport = nm[ip][proto].keys()
                for port in lport:
                    if nm[ip][proto][port]['state'] == 'open':
                        open_ports[port] = nm[ip][proto][port]['state']
        except nmap.nmap.PortScannerError:
            open_ports = {}
        return open_ports

def main():
    app = QApplication(sys.argv)
    window = LANScanTab()
    window.show()
    sys.exit(app.exec())

if __name__ == "__main__":
    main()
