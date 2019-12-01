from flask_wtf import FlaskForm
from wtforms import StringField, PasswordField, SubmitField, IntegerField, TextAreaField
from wtforms.validators import DataRequired, Length, EqualTo


# class form objects with respective fields

class SignUpForm(FlaskForm):
    username = StringField('Username', validators=[DataRequired(), Length(min=2, max=20)])
    password = PasswordField('Password', validators=[DataRequired()])
    confirm_password = PasswordField('Confirm Password', validators=[DataRequired(), EqualTo('password')])
    submit = SubmitField('Sign In')


class AddFavorites(FlaskForm):
    college_id = IntegerField('College Id', validators=[DataRequired()])
    rank = IntegerField('Rank', validators=[DataRequired()])
    review = TextAreaField('Review', validators=[DataRequired(), Length(max=250)])
    submit = SubmitField('Add')
