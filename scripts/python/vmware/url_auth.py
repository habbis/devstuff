#!/usr/bin/env python3

import requests
import json
import csv
import xmltodict
#import re
import urllib3

# disable ssl warning
urllib3.disable_warnings()


def auth():

 # credentials for the user and AD domain
  #XMLusername = "bf-daas-inv-user"
  #XMLpass = "4Uakrs!8"
  #XMLdomain = "MGMT"


  XMLusername = ""
  XMLpass = ""
  XMLdomain = ""

  # base url
  spbaseurl = "https://url"

  # api needs the user info to be in xml
  xml_auth = f"""<DtCredentials type="CREDENTIALS">
	    <username>{XMLusername}</username>
	    <password>{XMLpass}</password>
            <domain>{XMLdomain}</domain>
        </DtCredentials>"""

  # set the right content when rending request
  headers = {'Content-Type': 'application/xml'}

  # to verify credentials
  auth_url = requests.post(f"{spbaseurl}/dt-rest/v100/system/authenticate/credentials", data=xml_auth, headers=headers, verify=False)

  # get auth info from auth_url header
  auth_header = auth_url.headers.get('Authorization')

  xdt_header = auth_url.headers.get('x-dt-csrf-header')

  headers = {'Authorization': f"{auth_header}",
       'x-dt-csrf-header': f"{xdt_header}",
       'Accept': 'application/json'
  }

  return

def main

  get_org = requests.get(f'{spbaseurl}/dt-rest/v100/security/manager/organizations',  headers=headers, verify=False)


