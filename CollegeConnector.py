import mysql.connector
import secretsecret

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


# retrieves all the current colleges to view in the database
# every value in a tuple or a college's result set is formatted as cid, cname, pres_name, rank (string),
# tuition (string), location (string), type (string), and endowment
# All strings noted above are concatenated strings more so a short sentence
def get_colleges():
    # colleges will be stored in a dictionary keyed by their cid's and values will be the respective tuple
    coll_dict = {}
    # connects to the mysql database
    # note that the login_db function needs to be called first for this to successfully connect
    # db = mysql.connector.connect(host='localhost', database='uscolleges',
    #                              user=next(iter(db_dict)),
    #                              passwd=db_dict[next(iter(db_dict))])

    db = mysql.connector.connect(host="localhost", database="uscolleges", user=secretsecret.spooky_username,
                                 password=secretsecret.spooky_password)
    coll_cursor = db.cursor()
    coll_cursor.callproc("track_colleges")
    # extracts tuples and puts them into the dictionary
    for result in coll_cursor.stored_results():
        for row in result.fetchall():
            coll_dict[row[0]] = row
    coll_cursor.close()
    db.close()

    return coll_dict


# retrieves the current user's favorite list and returns a dictionary
# more or less similar to the get_colleges function
# tuples are formatted as cid, pref_rank, cname, and review
def get_favs():
    coll_dict = {}
    # login_db must also be called first before this read operation can be done
    # db = mysql.connector.connect(host='localhost', database='uscolleges',
    #                              user=next(iter(db_dict)),
    #                              passwd=db_dict[next(iter(db_dict))])

    db = mysql.connector.connect(host="localhost", database="uscolleges", user=secretsecret.spooky_username,
                                 password=secretsecret.spooky_password)
    coll_cursor = db.cursor()
    # coll_cursor.callproc("track_user_favorites", [next(iter(db_dict))])
    coll_cursor.callproc("track_user_favorites", [secretsecret.spooky_username])
    for result in coll_cursor.stored_results():
        for row in result.fetchall():
            coll_dict[row[0]] = row
    coll_cursor.close()
    db.close()

    return coll_dict


# obtains the college id, user ranking, and review of given favorite id
def get_fav(fid):
    coll_dict = {}
    db = mysql.connector.connect(host="localhost", database="uscolleges", user=secretsecret.spooky_username,
                                 password=secretsecret.spooky_password)
    coll_cursor = db.cursor()
    coll_cursor.callproc("get_favorite", [secretsecret.spooky_username, fid])
    for result in coll_cursor.stored_results():
        for row in result.fetchall():
            coll_dict[row[0]] = row
    coll_cursor.close()
    db.close()

    return coll_dict


# creates a new entry into the user's favorite list given a college id, user ranking, and review
def create_fav(cid, rank, text):
    # db = mysql.connector.connect(host='localhost', database='uscolleges',
    #                              user=next(iter(db_dict)),
    #                              passwd=db_dict[next(iter(db_dict))])
    db = mysql.connector.connect(host="localhost", database="uscolleges", user=secretsecret.spooky_username,
                                 password=secretsecret.spooky_password)

    coll_cursor = db.cursor()
    # coll_cursor.callproc("create_fav", [cid, next(iter(db_dict)), rank, text])
    print(cid)
    print(rank)
    print(text)
    coll_cursor.callproc("create_fav", [cid, secretsecret.spooky_username, rank, text])
    message = None
    for result in coll_cursor.stored_results():
        for row in result.fetchall():
            message = row
    db.commit()
    coll_cursor.close()
    db.close()
    return message[0]


# deletes an entry from the user's favorite list given a college id
def delete_fav(cid):
    # db = mysql.connector.connect(host='localhost', database='uscolleges',
    #                              user=next(iter(db_dict)),
    #                              passwd=db_dict[next(iter(db_dict))])

    db = mysql.connector.connect(host="localhost", database="uscolleges", user=secretsecret.spooky_username,
                                 password=secretsecret.spooky_password)
    coll_cursor = db.cursor()
    # coll_cursor.callproc("delete_fav", [next(iter(db_dict)), cid])
    coll_cursor.callproc("delete_fav", [secretsecret.spooky_username, cid])
    db.commit()
    coll_cursor.close()
    db.close()


def update_college(old_id, new_id):
    # db = mysql.connector.connect(host='localhost', database='uscolleges',
    #                              user=next(iter(db_dict)),
    #                              passwd=db_dict[next(iter(db_dict))])
    db = mysql.connector.connect(host="localhost", database="uscolleges", user=secretsecret.spooky_username,
                                 password=secretsecret.spooky_password)
    coll_cursor = db.cursor()
    coll_cursor.callproc("update_coll_fav", [next(iter(db_dict)), old_id, new_id])
    db.commit()
    coll_cursor.close()
    db.close()


def update_rank(cid, new_rank):
    # db = mysql.connector.connect(host='localhost', database='uscolleges',
    #                              user=next(iter(db_dict)),
    #                              passwd=db_dict[next(iter(db_dict))])
    db = mysql.connector.connect(host="localhost", database="uscolleges", user=secretsecret.spooky_username,
                                 password=secretsecret.spooky_password)
    coll_cursor = db.cursor()
    coll_cursor.callproc("update_rank_fav", [next(iter(db_dict)), cid, new_rank])
    db.commit()
    coll_cursor.close()
    db.close()


def update_review(cid, new_text):
    # db = mysql.connector.connect(host='localhost', database='uscolleges',
    #                              user=next(iter(db_dict)),
    #                              passwd=db_dict[next(iter(db_dict))])
    db = mysql.connector.connect(host="localhost", database="uscolleges", user=secretsecret.spooky_username,
                                 password=secretsecret.spooky_password)
    coll_cursor = db.cursor()
    coll_cursor.callproc("update_review_fav", [next(iter(db_dict)), cid, new_text])
    db.commit()
    coll_cursor.close()
    db.close()
