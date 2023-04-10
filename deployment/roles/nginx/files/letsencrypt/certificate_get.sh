#!/bin/sh

certbot --agree-tos --email christoffer.claesson@securitybits.io \
--redirect \
--authenticator standalone \
--installer nginx -n \
--pre-hook "service nginx stop" \
--post-hook "service nginx start" \
--expand \
-d dash.securitybits.io \
-d ombi.securitybits.io 

#-d securitybits.io \
if [ $? -ne 0 ]
 then
        ERRORLOG=`tail /var/log/letsencrypt.log`
        echo -e "The Let's Encrypt cert has not been created! \n \n" \
                 $ERRORLOG
 else
        nginx -s reload
fi

touch /etc/nginx/letsencrypt.created
