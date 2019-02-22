FROM ubuntu

ENV APACHE_VERSION 2.4.38
ENV APR_VERSION 1.6.5
ENV APR_UTIL_VERSION 1.6.1

RUN apt-get update -y && apt-get install wget libpcre3 libpcre3-dev zlib1g-dev libssl-dev gcc build-essential expat libexpat-dev -y && \
    mkdir -p /tmp/src && \
    cd /tmp/src && \
    wget https://archive.apache.org/dist/httpd/httpd-${APACHE_VERSION}.tar.gz && \
    wget https://archive.apache.org/dist/apr/apr-${APR_VERSION}.tar.gz && \
    wget https://archive.apache.org/dist/apr/apr-util-${APR_UTIL_VERSION}.tar.gz && \
    tar -zxvf httpd-${APACHE_VERSION}.tar.gz && \
    tar -zxvf apr-${APR_VERSION}.tar.gz && \
    tar -zxvf apr-util-${APR_UTIL_VERSION}.tar.gz && \
    mv apr-${APR_VERSION} apr && \
    mv apr-util-${APR_UTIL_VERSION} apr-util && \
    mv apr apr-util httpd-${APACHE_VERSION}/srclib/ && \
    cd httpd-${APACHE_VERSION}/ && \
    sudo ./configure \
        --prefix=/usr/local/apache-${APACHE_VERSION} \    
	--enable-so \
	--enable-auth-digest \ 
	--enable-rewrite \ 
	--enable-setenvif \ 
	--enable-mime \ 
	--enable-deflate \ 
	--enable-ssl \ 
	--enable-headers \ 
	--enable-proxy \ 
	--enable-proxy-connect \
	--enable-proxy-http \ 
	--enable-unique-id \ 
	--enable-disk-cache \ 
	--enable-cache \ 
	--enable-memory-cache \ 
	--with-included-apr \ 
	--enable-usertrack \  
	--with-mpm=event \
        && \
    sudo make && \
    sudo make install && \

    sudo chown -R daemon:daemon /usr/local/apache-${APACHE_VERSION}/ -R && \
    sudo chmod -R 755 /usr/local/apache-${APACHE_VERSION}/ -R && \

    sudo ln -sf  /usr/local/apache-${APACHE_VERSION} /usr/local/apache && \
## Forward request and error logs to docker log collector
    sudo ln -sf /dev/stdout /usr/local/apache/logs/https.access.log && \
    sudo ln -sf /dev/stderr /usr/local/apache/logs/debug.error.log && \
    sudo /usr/local/apache-${APACHE_VERSION} start 'daemon off;'
##Opening port for the Container

EXPOSE 80 443
