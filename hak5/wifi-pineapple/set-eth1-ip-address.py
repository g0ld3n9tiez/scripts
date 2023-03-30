import os
import socket
import fcntl
import struct
import webbrowser

os.system('sudo ip link set eth1 down')
os.system('sudo ip addr add 172.16.42.42/255.255.255.0 dev eth1')
os.system('sudo ifconfig eth1 up')

def get_ip_address(interface: str):
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    packed_iface = struct.pack('256s', interface.encode('utf_8'))
    packed_addr = fcntl.ioctl(sock.fileno(), 0x8915, packed_iface)[20:24]
    return socket.inet_ntoa(packed_addr)

print("Current IP for eth1")
print(get_ip_address('eth1'))

pineappleurl = 'http://172.16.42.1:1471'
checkip = '172.16.42.42'

if get_ip_address('eth1') == checkip:
        webbrowser.open(pineappleurl)
else:
        print("IP is not 172.16.42.42")
        print("Try again!")