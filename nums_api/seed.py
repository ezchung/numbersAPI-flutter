from nums_api.database import db
from nums_api import app
from nums_api.trivia.models import Trivia

# import all models - necessary for create_all()

db.drop_all()
db.create_all()
