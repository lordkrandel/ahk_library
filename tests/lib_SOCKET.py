# lib_socket.ahk test
import socket, time

host    = '127.0.0.1'
port    = 18664
backlog = 5
size    = 1024
s       = socket.socket( socket.AF_INET, socket.SOCK_STREAM )
# s.setblocking(True)
s.bind( (host,port) )
s.listen(backlog)

client, address = s.accept()
while 1:
    data = client.recv(size)
    if data:
        # AHK_L Unicode
        print(data.decode('utf-16LE'))
        time.sleep(1)
        client.send(data)

#client.close()

