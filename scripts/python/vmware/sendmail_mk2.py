#!/usr/bin/env python3

#import packages
import smtplib
import sys
from datetime import datetime
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText


port = 25
#smtp_server = ""
#sender = ""
receiver = ""
subject = "email testing"
mailfrom = "test"

# current month and year
current_month_year = current_month = datetime.now().strftime("%B %Y")

message = f"""\
Hi Colleagues,<br>
<br>
Here is the DaaS usage report for {current_month_year} attached
<br>
<br>
Kind Regards,<br>
The DaaS team
"""

# mail setup
mail = MIMEMultipart('alternative')
mail['Subject'] = f"{subject}"
mail['From'] = f"{mailfrom}"
mail['To'] = f"{receiver}"

#MIME objects of both types
#part1 = MIMEText(text, 'plain', 'utf-8')
part2 = MIMEText(message, 'html', 'utf-8')

#send mail with both html and plaintext version
try:
    #mail.attach(part1)
    mail.attach(part2)
    server = smtplib.SMTP('localhost')
    server.sendmail(mail['From'], mail['To'],mail.as_string())
    server.quit()

except Exception as e:
   raise Exception(e)
