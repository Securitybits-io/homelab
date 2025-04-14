data "http" "public_ip" {
  url = "http://ipv4.icanhazip.com"
}

resource "namecheap_domain_records" "securitybits" {
  domain = "securitybits.io"
  mode = "OVERWRITE"

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
    hostname = "_github-pages-challenge-securitybits-io"
    type = "TXT"
    address = "4a141843757159a1a45645a83e6895"
  }
}