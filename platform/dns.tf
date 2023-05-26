data "http" "public_ip" {
  url = "http://ipv4.icanhazip.com"
}

resource "namecheap_domain_records" "securitybits" {
  domain = "securitybits.io"
  mode = "OVERWRITE"

  record {
    hostname = "*"
    type = "A"
    address = "${chomp(data.http.public_ip.body)}"
  }

  record {
    hostname = "@"
    type = "A"
    address = "${chomp(data.http.public_ip.body)}"
  }

  record {
    hostname = "blog"
    type = "CNAME"
    address = "securitybits-io.github.com"
  }

  record {
    hostname = "www"
    type = "CNAME"
    address = "blog.securitybits.io"
  }

  record {
    hostname = "arma"
    type = "A"
    address = "45.92.36.102"
  }

  record {
    hostname = "ts"
    type = "CNAME"
    address = "ts3.logicserver.eu"
  }
}
