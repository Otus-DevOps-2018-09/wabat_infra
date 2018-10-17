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
