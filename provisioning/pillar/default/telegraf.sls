telegraf:
  config: |
    [agent]
      interval = "10s"
      round_interval = true
      metric_batch_size = 1000
      metric_buffer_limit = 10000
      collection_jitter = "0s"
      flush_interval = "10s"
      flush_jitter = "0s"
      omit_hostname = false
  modules:
    10_inputs_config:
      config: |
        [inputs]
        [[inputs.cpu]]
        percpu = false
        totalcpu = false
        collect_cpu_time = false
        report_active = false
        [[inputs.mem]]
        [[inputs.net]]
        [[inputs.disk]]
        ignore_fs = ["tmpfs", "devtmpfs", "devfs", "iso9660", "overlay", "aufs", "squashfs"]
    91_outputs_influxdb:
      config: |
        [outputs]
        [[outputs.influxdb]]
        urls = [ "http://logging-docker-01:8086" ]
        database = "telegraf"
