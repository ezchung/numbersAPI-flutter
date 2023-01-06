from flask import Blueprint, render_template
from markdown import markdown


root = Blueprint("root", __name__)


@root.get("/")
def root_route():
    """Render html with API docs from markdown file."""

    with open("./nums_api/static/docs/api-documentation.md", "r") as f:
        text = f.read()
        api_docs = markdown(text)

    return render_template("index.html", api_docs=api_docs)
