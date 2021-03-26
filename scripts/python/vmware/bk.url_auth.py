#!/usr/bin/env python3

import requests
import json
import csv
import xmltodict
#import re
import urllib3

# disable ssl warning
urllib3.disable_warnings()

# credentials for the user and AD domain
XMLusername = ""
XMLpass = ""
XMLdomain = ""

# base url
baseurl = "https://url"

# api needs the user info to be in xml
xml_auth = f"""<DtCredentials type="CREDENTIALS">
	    <username>{XMLusername}</username>
	    <password>{XMLpass}</password>
            <domain>{XMLdomain}</domain>
        </DtCredentials>"""

# customer id 
#kbn
customer_id = str(1000)

# set the right content when rending request
headers = {'Content-Type': 'application/xml'}

# to verify credentials
auth_url = requests.post(f"{baseurl}/dt-rest/v100/system/authenticate/credentials", data=xml_auth, headers=headers, verify=False)

# get auth info from auth_url header
auth_header = auth_url.headers.get('Authorization')

xdt_header = auth_url.headers.get('x-dt-csrf-header')

headers = {'Content-Type': 'application/json', 
     'Authorization': f"{auth_header}",
     'x-dt-csrf-header': f"{xdt_header}"
}

get_org = requests.get(f'{baseurl}/dt-rest/v100/security/manager/organizations', data=xml_auth, headers=headers, verify=False)



# turn xml outpout do dict for json parsing
org_dict = xmltodict.parse(get_org.text)

# turns xml dict to json
org_json = json.dumps(org_dict)


get_tenantusage = requests.get(f'{baseurl}/dt-rest/v100/reporting/manager/createBillingReportFilter', data=xml_auth, headers=headers, verify=False)

#print(get_tenantusage.text)

#with requests.Session() as s:
#    download = s.get(get_tenantusage)
#    decode_content = download.content.decode('utf-8')
#    cr = csv.reader(decoded_content.splitlines(), delimiter=',')
#    my_list = list(cr)
#    for row in my_list:
#        print(row)




#get_desktopmodel =  requests.get(f'{baseurl}/dt-rest/v100//infrastructure/desktopmodeldefinition/{id}', data=xml_auth, headers=headers, verify=False)

#get_quotas = requests.get(f'{baseurl}/dt-rest/v100/security/organization/1001/quotas',  headers=headers, verify=False)
get_quotas = requests.get(f'{baseurl}/dt-rest/v100/reporting/manager/getTenantReports"', data=xml_auth, headers=headers, verify=False)
#get_quotas = requests.get(f'{baseurl}/dt-rest/v100/reporting/concurrentusersreport', data=xml_auth, headers=headers, verify=False)

print(get_quotas.text)


# turn xml outpout do dict for json parsing
quotas_dict = xmltodict.parse(get_quotas.text)

# turns xml dict to json
quotas_json = json.dumps(quotas_dict)

# turn xml outpout do dict for json parsing
tenantusage_dict = xmltodict.parse(get_tenantusage.text)

# turns xml dict to json
tenantusage_json = json.dumps(tenantusage_dict)

#print(tenantusage_json)

#print(quotas_json)


