import sys
import threading
import time
import numpy as np
import subprocess
import platform
import ipaddress
import concurrent.futures

from PyQt6.QtWidgets import QWidget, QVBoxLayout, QHBoxLayout, QLabel, QLineEdit, QPushButton, QListWidget, QListWidgetItem
from PyQt6.QtCore import QTimer, Qt, QMetaObject, Q_ARG, pyqtSlot

from PyQt6.QtWidgets import (
    QApplication, QWidget, QVBoxLayout, QHBoxLayout,
    QLabel, QLineEdit, QPushButton, QTabWidget, QListWidget, QListWidgetItem
)
from PyQt6.QtCore import QTimer
import pyqtgraph as pg

USE_HARDWARE = False  # Set True if you have RTL-SDR connected

if USE_HARDWARE:
    from rtlsdr import RtlSdr
else:
    RtlSdr = None  # dummy placeholder


class SDRStreamer:
    def __init__(self, freq_hz, sample_rate=2.4e6, buffer_size=1024):
        self.freq_hz = freq_hz
        self.sample_rate = sample_rate
        self.buffer_size = buffer_size
        self.running = False
        self.thread = None
        self.latest_samples = None
        self.t = 0  # for simulated signal time
        self.sdr = None

        if USE_HARDWARE:
            self.sdr = RtlSdr()

    def start(self):
        self.running = True
        self.thread = threading.Thread(target=self.stream, daemon=True)
        self.thread.start()

    def stream(self):
        if USE_HARDWARE:
            try:
                self.sdr.sample_rate = self.sample_rate
                self.sdr.center_freq = self.freq_hz
                self.sdr.gain = 'auto'

                while self.running:
                    samples = self.sdr.read_samples(self.buffer_size)
                    self.latest_samples = samples
            except Exception as e:
                print(f"SDR Error: {e}")
            finally:
                if self.sdr:
                    self.sdr.close()
        else:
            freq_offset = 100e3  # 100 kHz simulated tone
            dt = 1 / self.sample_rate
            while self.running:
                t_vals = np.arange(self.t, self.t + self.buffer_size) * dt
                self.t += self.buffer_size

                samples = np.exp(2j * np.pi * freq_offset * t_vals)
                noise = (np.random.normal(0, 0.1, self.buffer_size) +
                         1j * np.random.normal(0, 0.1, self.buffer_size))
                self.latest_samples = samples + noise

                time.sleep(0.1)

    def stop(self):
        self.running = False
        if self.thread:
            self.thread.join()


class SDRTab(QWidget):
    def __init__(self):
        super().__init__()

        layout = QVBoxLayout()

        freq_layout = QHBoxLayout()
        freq_label = QLabel("Frequency (MHz):")
        self.freq_input = QLineEdit("100.0")
        freq_layout.addWidget(freq_label)
        freq_layout.addWidget(self.freq_input)

        btn_layout = QHBoxLayout()
        self.start_btn = QPushButton("Start")
        self.stop_btn = QPushButton("Stop")
        self.stop_btn.setEnabled(False)
        btn_layout.addWidget(self.start_btn)
        btn_layout.addWidget(self.stop_btn)

        layout.addLayout(freq_layout)
        layout.addLayout(btn_layout)

        self.plot_widget = pg.PlotWidget()
        self.plot_widget.setYRange(-140, 0)
        self.plot_widget.setLabel('left', 'Power (dB)')
        self.plot_widget.setLabel('bottom', 'Frequency (MHz)')
        layout.addWidget(self.plot_widget)

        self.setLayout(layout)

        self.start_btn.clicked.connect(self.start_sdr)
        self.stop_btn.clicked.connect(self.stop_sdr)

        self.fft_curve = self.plot_widget.plot(pen='y')
        self.sdr_streamer = None

        self.timer = QTimer()
        self.timer.setInterval(100)
        self.timer.timeout.connect(self.update_plot)

    def start_sdr(self):
        freq_str = self.freq_input.text()
        try:
            freq_mhz = float(freq_str)
            freq_hz = int(freq_mhz * 1e6)
            print(f"Starting SDR at {freq_hz} Hz")

            self.sdr_streamer = SDRStreamer(freq_hz)
            self.sdr_streamer.start()

            self.start_btn.setEnabled(False)
            self.stop_btn.setEnabled(True)
            self.freq_input.setEnabled(False)
            self.timer.start()
        except ValueError:
            print("Invalid frequency entered!")

    def stop_sdr(self):
        print("Stopping SDR")
        if self.sdr_streamer:
            self.sdr_streamer.stop()
            self.sdr_streamer = None

        self.start_btn.setEnabled(True)
        self.stop_btn.setEnabled(False)
        self.freq_input.setEnabled(True)
        self.timer.stop()
        self.fft_curve.clear()

    def update_plot(self):
        if self.sdr_streamer and self.sdr_streamer.latest_samples is not None:
            samples = self.sdr_streamer.latest_samples

            fft_vals = np.fft.fftshift(np.fft.fft(samples, n=1024))
            power = 20 * np.log10(np.abs(fft_vals) + 1e-6)

            sample_rate = self.sdr_streamer.sample_rate
            freqs = np.fft.fftshift(np.fft.fftfreq(len(fft_vals), 1/sample_rate)) / 1e6
            center_freq_mhz = self.sdr_streamer.freq_hz / 1e6
            freqs = freqs + center_freq_mhz

            self.fft_curve.setData(freqs, power)


def ping(ip):
    param = '-n' if platform.system().lower() == 'windows' else '-c'
    if platform.system().lower() == 'windows':
        command = ['ping', param, '1', '-w', '500', str(ip)]  # 500 ms timeout on Windows
    else:
        command = ['ping', param, '1', '-W', '1', str(ip)]    # 1 second timeout on Linux/macOS

    try:
        result = subprocess.run(command, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        return ip, result.returncode == 0
    except Exception as e:
        print(f"Ping error on {ip}: {e}")
        return ip, False


def scan_network(network_cidr):
    network = ipaddress.ip_network(network_cidr, strict=False)
    live_hosts = []
    print(f"Starting scan on {network_cidr}...")

    with concurrent.futures.ThreadPoolExecutor(max_workers=100) as executor:
        futures = {executor.submit(ping, ip): ip for ip in network.hosts()}
        for future in concurrent.futures.as_completed(futures):
            ip, alive = future.result()
            if alive:
                print(f"Host alive: {ip}")
                live_hosts.append(str(ip))
    print(f"Scan complete. Found {len(live_hosts)} hosts.")
    return live_hosts


class LANScanTab(QWidget):
    def __init__(self):
        super().__init__()

        layout = QVBoxLayout()

        subnet_layout = QHBoxLayout()
        subnet_label = QLabel("Subnet (CIDR):")
        self.subnet_input = QLineEdit("192.168.1.0/24")
        subnet_layout.addWidget(subnet_label)
        subnet_layout.addWidget(self.subnet_input)

        self.scan_btn = QPushButton("Scan LAN")
        self.scan_btn.clicked.connect(self.start_scan)

        self.result_list = QListWidget()

        layout.addLayout(subnet_layout)
        layout.addWidget(self.scan_btn)
        layout.addWidget(self.result_list)

        self.setLayout(layout)

        self.scan_thread = None

    def start_scan(self):
        subnet = self.subnet_input.text()
        self.result_list.clear()
        self.scan_btn.setEnabled(False)
        self.scan_thread = threading.Thread(target=self.scan_network_thread, args=(subnet,), daemon=True)
        self.scan_thread.start()

    def scan_network_thread(self, subnet):
        print(f"Starting LAN scan on subnet: {subnet}")
        live_hosts = scan_network(subnet)  # Assume scan_network is your ping scanning function
        print(f"Scan complete. Found {len(live_hosts)} hosts.")
        self.update_results(live_hosts)

    def update_results(self, live_hosts):
        # Schedule UI update on main thread using QMetaObject.invokeMethod
        QMetaObject.invokeMethod(self, "run_update", Qt.ConnectionType.QueuedConnection, Q_ARG(object, live_hosts))

    @pyqtSlot(object)
    def run_update(self, live_hosts):
        print(f"Updating UI with {len(live_hosts)} hosts...")
        self.result_list.clear()
        for ip in live_hosts:
            item = QListWidgetItem(ip)
            self.result_list.addItem(item)
        self.scan_btn.setEnabled(True)
        print("LAN scan results updated in UI.")

def parse_netsh_networks(output):
    networks = []
    lines = output.splitlines()
    current = {}
    for line in lines:
        line = line.strip()
        if line.startswith("SSID "):
            if current:
                networks.append(current)
                current = {}
            ssid = line.split(" : ", 1)[1]
            current['SSID'] = ssid
        elif line.startswith("Signal"):
            current['Signal'] = line.split(" : ", 1)[1]
        elif line.startswith("Authentication"):
            current['Authentication'] = line.split(" : ", 1)[1]
    if current:
        networks.append(current)
    return networks


class WiFiScanTab(QWidget):
    def __init__(self):
        super().__init__()

        layout = QVBoxLayout()

        self.scan_btn = QPushButton("Scan Wi-Fi")
        self.scan_btn.clicked.connect(self.scan_wifi)

        self.result_list = QListWidget()

        layout.addWidget(self.scan_btn)
        layout.addWidget(self.result_list)

        self.setLayout(layout)

    def scan_wifi(self):
        self.scan_btn.setEnabled(False)
        self.result_list.clear()

        threading.Thread(target=self.scan_wifi_thread, daemon=True).start()

    def scan_wifi_thread(self):
        if platform.system().lower() == 'windows':
            try:
                output = subprocess.check_output(
                    ['netsh', 'wlan', 'show', 'networks', 'mode=bssid'],
                    encoding='utf-8',
                    errors='ignore'
                )
                networks = parse_netsh_networks(output)
            except Exception as e:
                networks = [{'SSID': 'Error', 'Signal': str(e), 'Authentication': ''}]
        else:
            networks = [{'SSID': 'Unsupported OS', 'Signal': '', 'Authentication': ''}]

        self.update_results(networks)

    def update_results(self, networks):
        def update():
            for net in networks:
                ssid = net.get('SSID', 'N/A')
                signal = net.get('Signal', '')
                auth = net.get('Authentication', '')
                item = QListWidgetItem(f"{ssid} | Signal: {signal} | Auth: {auth}")
                self.result_list.addItem(item)
            self.scan_btn.setEnabled(True)
            print("Wi-Fi scan results updated in UI.")

        QTimer.singleShot(0, update)


class MainApp(QWidget):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("Waveband Tool")

        layout = QVBoxLayout()

        self.tabs = QTabWidget()
        self.sdr_tab = SDRTab()
        self.lan_tab = LANScanTab()
        self.wifi_tab = WiFiScanTab()

        self.tabs.addTab(self.sdr_tab, "SDR")
        self.tabs.addTab(self.lan_tab, "LAN Scan")
        self.tabs.addTab(self.wifi_tab, "Wi-Fi Scan")

        layout.addWidget(self.tabs)
        self.setLayout(layout)


def main():
    app = QApplication(sys.argv)
    main_window = MainApp()
    main_window.resize(800, 600)
    main_window.show()
    sys.exit(app.exec())


if __name__ == "__main__":
    main()