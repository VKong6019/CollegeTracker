# !/usr/bin/env python
# -*- coding: utf-8 -*-

from flask import Flask, render_template, flash, url_for
from werkzeug.utils import redirect
from flask_bootstrap import Bootstrap
from CollegeConnector import get_colleges, get_favs, create_fav
from user_input import AddFavorites, SignUpForm
import pymysql
import secretsecret

# pip install mysql-connector
# pip install cryptography

# Connect to Flask server

app = Flask(__name__)
app.config['SECRET_KEY'] = secretsecret.secret_key

bootstrap = Bootstrap(app)

@app.route("/", methods=['GET', 'POST'])
def main():
    # call a mysql function get_college_name(id)
    # Prompt user for valid MYSQl username and password
    # while connection is None:
    #     try:
    #         user = input("Enter username: ")
    #         password = input("Enter password: ")
    #         # Connect to schema
    #         connection = pymysql.connect(host='localhost', db='uscolleges', user=user, password=password,
    #                                      cursorclass=pymysql.cursors.DictCursor)
    #         connection.cursor()
    #     except pymysql.err.OperationalError:
    #         print("Invalid credentials!\n")
    #         pass

    # create a form object for adding favorites
    fav_form = AddFavorites()

    # checks if form is validated and submitted properly
    if fav_form.validate_on_submit():
        # calls on python function to create favorite based on user input
        create_fav(fav_form.college_id.data, fav_form.rank.data, fav_form.review.data)
        flash("Favorite added!")
        return redirect(url_for('main'))

    # obtain lists of current favorites and colleges from database
    favorites_list = get_favs()
    college_names = get_colleges()

    # render front end
    return render_template("index.html", colleges=college_names, favs=favorites_list, form=fav_form, content_type='application/json')

# signin page
@app.route("/login", methods=['GET', 'POST'])
def login():
    login = SignUpForm()

    if login.validate_on_submit():
        flash("Login successful!")
        return redirect(url_for('main'))

    return render_template('login.html', title="Sign In", form=login)


if __name__ == "__main__":
    app.run()