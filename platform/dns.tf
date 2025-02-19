data "http" "public_ip" {
  url = "http://ipv4.icanhazip.com"
}

resource "namecheap_domain_records" "securitybits" {
  domain = "securitybits.io"
  mode = "OVERWRITE"
  email_type = "MX"

  record {
    hostname = "*"
    type = "A"
    address = "${chomp(data.http.public_ip.response_body)}"
  }

  record {
    hostname = "@"
    type = "A"
    address = "${chomp(data.http.public_ip.response_body)}"
  }
  
  record {
    hostname = "@"
    type = "MX"
    address = "mx2.privateemail.com"
  }

  record {
    hostname = "@"
    type = "TXT"
    address = "v=spf1 include:spf.privateemail.com ~all"
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
}
yes