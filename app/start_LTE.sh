#!/bin/bash
echo Stopping LTE iface
ifconfig wwan0 down
echo Setting up raw_ip mode
echo Y > /sys/class/net/wwan0/qmi/raw_ip
echo Setting LTE hat to online-mode
qmicli -d /dev/cdc-wdm0 --dms-set-operating-mode='online'
echo Configure KPN SIM APN details
qmicli -p -d /dev/cdc-wdm0 --device-open-net='net-raw-ip|net-no-qos-header' --wds-start-network="apn='internet',ip-type=4" --client-no-release-cid
echo Leasing an IP for wwan0
udhcpc -i wwan0