from flask import Blueprint, jsonify
from nums_api.dates.models import Date
import random
from werkzeug.exceptions import BadRequest

dates = Blueprint("dates", __name__)


@dates.get("/<int:month>/<int:day>")
def get_date_fact(month, day):
    """
    Get date fact about specific date
        Input:
            month (int)
            day (int)
        Output: JSON like
        {
            "fact": {
                "fragment": "the test case",
                "statement": "January 1st is the test case.",
                "month": 1,
                "day" : 1,
                "year": 2023,
                "type": "date"
            }
        }

        OR If date is not found...
        Output: JSON like
        {
            error: {
                "message": "A date fact for 1/2 not found",
                "status": 404
            }
        }
    """

    try:
        day_of_year = Date.date_to_day_of_year(month, day)
    except ValueError as e:
        (error_msg, ) = e.args
        raise BadRequest(error_msg)

    date_facts = Date.query.filter(Date.day_of_year == day_of_year).all()

    if not date_facts:
        error = {
            "message": f"A date fact for {month}/{day} not found",
            "status": 404
        }

        return (jsonify(error=error), 404)

    fact = random.choice(date_facts)
    (month_num, day_num) = Date.date_from_day_of_year(fact.day_of_year)


    fact_data = {
        "fragment": fact.fact_fragment,
        "statement": fact.fact_statement,
        "month": month_num,
        "day": day_num,
        "year": fact.year,
        "type": "date",
    }

    return jsonify(fact=fact_data)


@dates.get("/random")
def get_date_fact_random():
    """
     Get date fact about random date
        Output: JSON like
        {
            "fact": {
                "fragment": "the test case",
                "statement": "January 1st is the test case.",
                "month": 1,
                "day" : 1,
                "year": 2023,
                "type": "date"
            }
        }
    """

    date_facts = Date.query.all()
    fact = random.choice(date_facts)
    (month_num, day_num) = Date.date_from_day_of_year(fact.day_of_year)

    fact_data = {
        "fragment": fact.fact_fragment,
        "statement": fact.fact_statement,
        "month": month_num,
        "day": day_num,
        "year": fact.year,
        "type": "date",
    }

    return jsonify(fact=fact_data)
