FROM telegraf:1.2.2

RUN apt-get update && \
    apt-get install -y --no-install-recommends ipmitool snmp libsnmp-base && \
	rm -rf /var/lib/apt/lists/*