from unittest import TestCase
from nums_api import app
from nums_api.database import db, connect_db
from nums_api.config import DATABASE_URL_TEST
from nums_api.maths.models import Math

app.config["SQLALCHEMY_DATABASE_URI"] = DATABASE_URL_TEST
app.config["TESTING"] = True
app.config["SQLALCHEMY_ECHO"] = False
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False

connect_db(app)

db.drop_all()
db.create_all()


class MathBaseRouteTestCase(TestCase):
    """
        Houses setup functionality for math route tests.
        Should be subclassed for any math route classes utilized.
    """

    def setUp(self):
        """Set up test data here"""

        Math.query.delete()

        m1 = Math(
            number=1,
            fact_fragment="the number for this m1 test fact fragment",
            fact_statement="1 is the number for this m1 test fact statement.",
            was_submitted=False,
        )

        m2 = Math(
            number=2.22,
            fact_fragment="the number for this m2 test fact fragment",
            fact_statement="2.22 is the number for this m2 test fact statement.",
            was_submitted=False,
        )

        db.session.add_all([m1, m2])
        db.session.commit()

        self.client = app.test_client()

    def tearDown(self):
        """Clean up any fouled transaction."""

        db.session.rollback()


class MathRouteTestCase(MathBaseRouteTestCase):

    def test_setup(self):
        """Test to make sure tests are set up correctly"""

        test_setup_correct = True
        self.assertEqual(test_setup_correct, True)

    def test_get_math_fact_for_int(self):
        with self.client as c:

            resp = c.get("/api/math/1")
            expected_resp = {
                "fact": {
                    "fragment": "the number for this m1 test fact fragment",
                    "statement": "1 is the number for this m1 test fact statement.",
                    "number": 1,
                    "type": "math"
                }
            }

            self.assertEqual(resp.status_code, 200)
            self.assertEqual(resp.json, expected_resp)

    def test_get_math_fact_for_float(self):
        with self.client as c:

            resp = c.get("/api/math/2.22")
            expected_resp = {
                "fact": {
                    "fragment": "the number for this m2 test fact fragment",
                    "statement": "2.22 is the number for this m2 test fact statement.",
                    "number": 2.22,
                    "type": "math"
                }
            }

            self.assertEqual(resp.status_code, 200)
            self.assertEqual(resp.json, expected_resp)

    def test_get_math_fact_not_found(self):
        with self.client as c:

            resp = c.get("/api/math/-1")
            expected_resp = {
                "error": {
                    "message": "A math fact for -1 not found",
                    "status": 404
                }
            }

            self.assertEqual(resp.status_code, 404)
            self.assertEqual(resp.json, expected_resp)

    def test_get_math_fact_invalid_number(self):
        with self.client as c:

            resp = c.get("/api/math/one")

            self.assertEqual(resp.status_code, 400)

    def test_get_math_fact_random(self):
        with self.client as c:

            resp = c.get("/api/math/random")

            possible_resp_1 = {
                "fact": {
                    "fragment": "the number for this m1 test fact fragment",
                    "statement": "1 is the number for this m1 test fact statement.",
                    "number": 1,
                    "type": "math"
                }
            }

            possible_resp_2 = {
                "fact": {
                    "fragment": "the number for this m2 test fact fragment",
                    "statement": "2.22 is the number for this m2 test fact statement.",
                    "number": 2.22,
                    "type": "math"
                }
            }

            self.assertEqual(resp.status_code, 200)
            self.assertIn(resp.json, [possible_resp_1, possible_resp_2])
