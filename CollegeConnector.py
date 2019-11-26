import mysql.connector

# pip install mysql-connector-python
db_dict = {}


# given db login info, connect to db and show success msg
# should only be called once on a user
def login_db(username, password):
    try:
        college_db = mysql.connector.connect(host='localhost', database='uscolleges', user=username,
                                             passwd=password)
        college_db.close()
        db_dict[username] = password
        return "Successful Login!"
    except mysql.connector.Error:
        return "Unsuccessful Login."


# read an id to its respective college
# TODO : probably remove later
def get_college_name(cid):
    db = mysql.connector.connect(host='localhost', database='uscolleges',
                                 user=next(iter(db_dict)),
                                 passwd=db_dict[next(iter(db_dict))])
    coll_cursor = db.cursor()
    coll_cursor.execute("get_college_name", cid)
    cname = coll_cursor.fetchone()
    coll_cursor.close()
    db.close()
    print(cname)
    return cname

# TODO: first modify the sql code and call the procedure to obtain all the colleges here
