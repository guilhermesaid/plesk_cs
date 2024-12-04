allowhardlink
#include /usr/local/psa/etc/logrotate.d

####
####  CS
####
/var/www/vhosts/system/*/logs/*.processed {
        daily
        dateext
        compress
        missingok
        rotate 5
        postrotate
                /etc/admin/send_logs_s3_web.py
        endscript
}
/var/www/vhosts/system/*/logs/error_log {
        daily
        dateext
        compress
        missingok
        copytruncate
        rotate 5
}
/var/www/vhosts/system/*/logs/proxy_error_log {
        daily
        dateext
        compress
        missingok
        copytruncate
        rotate 5
}

####
####  CS
####


/var/log/plesk/xferlog.processed {
        missingok
        rotate 3
        size    10M
        compress
        nocreate
}

/var/log/maillog.processed {
        missingok
        rotate 3
        size    10M
        compress
        nocreate
}



/usr/local/psa/var/webalizer.cache {
    missingok
    rotate  0
    size    512M
    nocreate
}
