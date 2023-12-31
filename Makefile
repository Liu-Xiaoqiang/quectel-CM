ifneq ($(CROSS_COMPILE),)
CROSS-COMPILE:=$(CROSS_COMPILE)
endif
ifeq ($(CC),cc)
CC:=$(CROSS-COMPILE)gcc
endif
LD:=$(CROSS-COMPILE)ld

QL_CM_SRC=QmiWwanCM.c GobiNetCM.c main.c MPQMUX.c QMIThread.c util.c qmap_bridge_mode.c mbim-cm.c device.c
ifeq (1,1)
QL_CM_DHCP=udhcpc.c
else
LIBMNL=libmnl/ifutils.c libmnl/attr.c libmnl/callback.c libmnl/nlmsg.c libmnl/socket.c
DHCP=libmnl/dhcp/dhcpclient.c libmnl/dhcp/dhcpmsg.c libmnl/dhcp/packet.c
QL_CM_DHCP=udhcpc_netlink.c
QL_CM_DHCP+=${LIBMNL}
endif

release: clean qmi-proxy
	$(CC) -Wall -s ${QL_CM_SRC} ${QL_CM_DHCP} -o quectel-CM -lpthread -ldl

debug: clean
	$(CC) -Wall -g -DCM_DEBUG ${QL_CM_SRC} ${QL_CM_DHCP} -o quectel-CM -lpthread -ldl

qmi-proxy:
	$(CC) -Wall -s quectel-qmi-proxy.c  -o quectel-qmi-proxy -lpthread -ldl

clean:
	rm -rf quectel-CM *~
	rm -rf quectel-qmi-proxy
