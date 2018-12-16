import os, yaml 

with open ('inventory.yml', 'r') as inv:
    f = inv.read ()
    
to_json = yaml.safe_load (f)
print (to_json)

