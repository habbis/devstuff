#!/usr/bin/env python3

#import packages
import smtplib

port = 25
smtp_server = ""
sender = ""
receiver = ""

message = """\
Hi Colleagues,<br>
<br>
Here is the DaaS usage report for currentMonth currentYear attached
<br>
<br>
Kind Regards,<br>
The DaaS team
message from python.
"""

#try:
smtpObj = smtplib.SMTP(smtp_server, port)
smtpObj.sendmail(sender, receiver, message)
print ("Successfully sent email")
#except SMTPException:
#   print ("Error: unable to send email")

