#!/usr/bin/env python3

import requests
#import json
import untangle
#import re
import urllib3
from pyVim.connect import SmartConnect
from pyVmomi import vim
import ssl
 

# disable ssl warning
urllib3.disable_warnings()


# base url
baseurl = "https://vcenter"
vcenter = "vcenter"

b64username = ""
b64password = ""
authtoken = b64username,b64password

cluster = ""




# header info for primo api

# set the right content when rending request
#headers = {'Content-Type': 'application/json'}
headers = {
'Authorization': f"{authtoken}"
}

# to verify credentials
auth_url = requests.post(f"{baseurl}/rest/com/vmware/cis/session", auth=(f'{b64username}',f'{b64password}'), verify=False)

json_content = auth_url.json()


token = json_content["value"]


headers = {
'vmware-api-session-id': f"{token}"
}



get_cluster = requests.get(f'{baseurl}/rest/vcenter/cluster', headers=headers, verify=False)

cluster_list = get_cluster.json()

#for key, value in cluster_list.items():

#  print(key, ":", value)

print(cluster_list["value"]["cluster"] )

get_vm = requests.get(f'{baseurl}/rest/vcenter/vm', headers=headers, verify=False)

#cluster_content = get_cluster.json()

vm_list = get_vm.json()

#cluster = json

#print(vm_list["value"])

#print(cluster)




#value_header = auth_url.headers.get('value')
#auth_url_content = auth_url.headers.get('')

#print(auth_url_content)

#get_org = requests.get(f'{baseurl}/dt-rest/v100/security/manager/organizations', data=xml_auth, headers=headers, verify=False)

#print(get_org.raw)
#print(get_org.content)
#print(get_org.text)
#print(get_org.status_code)'


#get_tenantusage = requests.get(f'{baseurl}/dt-rest/v100/reporting/manager/tenantusagereport', data=xml_auth, headers=headers, verify=False)
#get_tenantusage = requests.get(f'{baseurl}/dt-rest/v100/reporting/manager/usagereports', data=xml_auth, headers=headers, verify=False)
#print(get_tenantusage.content)
