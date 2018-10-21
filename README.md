# wabat_infra
wabat Infra repository

##### ssh forwarding
```
 ssh -ti .ssh/kee -A bastion_host "ssh internal_host"
```
or
```
alias inter_host='ssh -ti .ssh/kee -A bastion_host "ssh internal_host"'
```
then use simple command 
```
inter_host
``` 
bastion_IP = 35.210.201.16 
someinternalhost_IP = 10.142.0.4
  
testapp_IP = 35.237.117.133
testapp_port = 9292 
