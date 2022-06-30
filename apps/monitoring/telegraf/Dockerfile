FROM telegraf:latest

RUN apt-get update && \
    apt-get install -y --no-install-recommends ipmitool snmp libsnmp-base && \
	rm -rf /var/lib/apt/lists/*