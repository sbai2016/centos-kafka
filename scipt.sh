export config_root_proxy=http://ntes.proxy.corp.sopra:8080
docker run -ti -d --net=host --privileged -e http_proxy=$config_root_proxy -e https_proxy=$config_root_proxy reckonn/forgetproxy
