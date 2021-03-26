#!/bin/env python

import logging
import sushy
from sushy import auth

LOG = logging.getLogger('sushy')
LOG.setLevel(logging.DEBUG)
LOG.addHandler(logging.StreamHandler())

bmc_user = ''
bmc_password = ''

bmc_server = ''

# if session fails it will fallback to either one
#basic_auth = auth.BasicAuth(username='bmc_user', password='bmc_password')
#session_auth = auth.SessionAuth(username='bmc_user', password='bmc_password')
session_or_basic_auth = auth.SessionOrBasicAuth(username='user',
                                                  password='bmc_password')

#s = sushy.Sushy('https://bmc_server/redfish/v1',
#                 auth=basic_auth)


#s = sushy.Sushy('https://bmc_server/redfish/v1',
#                 auth=session_auth)


s = sushy.Sushy('https://bmc_server/redfish/v1',
                 auth=session_or_basic_auth)
