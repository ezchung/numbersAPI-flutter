from flask import Blueprint, jsonify
from nums_api.years.models import Year
import random

years = Blueprint("years", __name__)

@years.get("/<int:year>")
def get_year_facts(year):
    """
    Get fact about a year
        Input: year (int)
        Output: JSON like
        {
            "fact": {
                year=2023,
                fragment="the year for this y1 test fact_fragment",
                statement="2023 is the year for this y1 test fact statement.",
                type="year"
            }
        }

        OR If number is not found...
        Output: JSON like
        {
            error: {
                    "message": f"A fact for { year } not found",
                    "status": 404
                    }
        }
    """
    year_facts = Year.query.filter(Year.year == year).all()

    if not year_facts:
        error = {
            "message": f"A fact for { year } not found",
            "status": 404
        }

        return (jsonify(error=error), 404)

    fact = random.choice(year_facts)

    fact_data = {
        "fragment": fact.fact_fragment,
        "statement": fact.fact_statement,
        "year": fact.year,
        "type": "year"
    }

    return jsonify(fact=fact_data)

@years.get("/random")
def get_year_facts_random():
    """
     Get trivia fact about random year
        Output: JSON like
        {
            "fact": {
                "fragment": "the year Argentina won the World Cup",
                "statement": "2022 is the year Argentina won the World Cup.",
                "year": 2022,
                "type": "year"
            }
        }
    """
    year_facts = Year.query.all()
    fact = random.choice(year_facts)

    fact_data = {
        "fragment": fact.fact_fragment,
        "statement": fact.fact_statement,
        "year": fact.year,
        "type": "year"
    }

    return jsonify(fact=fact_data)
