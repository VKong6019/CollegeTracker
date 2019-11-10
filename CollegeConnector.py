import mysql.connector
import secretsecret

# pip install mysql-connector-python
college_db = mysql.connector.connect(host='localhost', database='uscolleges', user='root',
                                     passwd=secretsecret.spooky_password)

print(college_db)

print('Connected! :)') if college_db else print('Not Connected! :(')

# methods for CRUD operations go here
