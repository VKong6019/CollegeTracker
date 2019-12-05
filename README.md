# CollegeTracker
### Dynamic web application that allows users to view database of U.S. colleges and create a custom favorite colleges list to edit, delete, and update their colleges.

### *Full-stack Python application with MySQL database and Jinja-templated Bootstrap front-end*

## Features
CollegeTracker is fully equipped with CRUD operations supported by the MySQL database.

### College Database
CollegeTracker comes provided with a list of colleges with a variety of attributes: name, rank, type, price, location, and president. Every college is identified with a unique _college id_. The college database is read-only. 

### Favorites List
Each user has a custom favorites list in which they can add colleges from the database and add their own personalized comments.

A user can add a favorite, which contains a _college id_, _rank_, and _review_. Once a favorite is added, a user can choose to delete or edit the favorite at any point.

### User Authentication
A user must login to an authentication page with their username and password in order to access the college database and their customized favorites list.

### Editing a Favorite
Once a user decides to edit a favorite, they are taken to the edit page where they can change the rank and review of the selected favorite.


## Specifications

#### Languages: Python3, SQL, HTML/CSS

#### Programs: PyCharm IDE, MySQL Workbench 8.0

#### Modules:
* [Flask](https://pypi.org/project/Flask/) - web app framework (Python)
* [Werkzeug](https://pypi.org/project/Werkzeug/) - WSGI web app library (Python)
* [MySQL Connector](https://www.mysql.com/products/connector/) - Driver for MySQL (Python)
* [Flask-WTF](https://flask-wtf.readthedocs.io/en/stable/install.html) - Extension that integrates WTForms and Flask (Python)
* [Bootstrap](https://getbootstrap.com/) - front-end component library (HTML/CSS/JS) 

#### Installing Dependencies:

`pip install Flask`

`pip install Werkzeug`

`pip install mysql-connector`

`pip install Flask-WTF`


## Usage
- Clone this repository: `git clone https://github.com/VKong6019/CollegeTracker.git`
- Once all dependencies have been installed, run CollegeTracker locally on a Flask server: `flask run`
- The server will run on http://127.0.0.1:5000/.

Download our local MySQL 'uscolleges' database dump and run the queries in [CS3200 Project](https://github.com/VKong6019/CollegeTracker/tree/master/CS3200%20Project).

## Credits
Vera Kong and Nicole Danuwidjaja

CS3200: Database Design, Professor Kathleen Durant, Northeastern University


