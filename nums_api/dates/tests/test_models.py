from unittest import TestCase
from nums_api import app
from nums_api.database import db, connect_db
from nums_api.config import DATABASE_URL_TEST
from nums_api.dates.models import Date

app.config["SQLALCHEMY_DATABASE_URI"] = DATABASE_URL_TEST
app.config["TESTING"] = True
app.config["SQLALCHEMY_ECHO"] = False
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

connect_db(app)

db.drop_all()
db.create_all()

class DateModelTestCase(TestCase):
    def setUp(self):
        """Set up test data here"""

        Date.query.delete()

        self.d1 = Date(
            day_of_year=60,
            year=2000,
            fact_fragment="the number for this d1 test fact fragment",
            fact_statement="60 is the number for this d1 test fact statement",
            was_submitted=False
        )

    def tearDown(self):
        """Clean up any fouled transaction."""
        db.session.rollback()

    def test_setup(self):
        """Test to make sure tests are set up correctly"""
        test_setup_correct = True
        self.assertEqual(test_setup_correct, True)

    def test_model(self):
        """Test to make sure record is inserted into the database correctly"""
        self.assertIsInstance(self.d1, Date)
        self.assertEqual(Date.query.count(), 0)

        db.session.add(self.d1)
        db.session.commit()

        self.assertEqual(Date.query.count(), 1)
        self.assertEqual(
            Date
            .query
            .filter_by(day_of_year=60)
            .one()
            .day_of_year, 60
        )
