#!venv/bin/python3.9

# Flask's modules.
from flask import (
    Flask,
    Response,
    make_response,
    request
)

# Variables declaration.
application = Flask(__name__)


@application.route(
    rule="/api/add",
    methods=[
        "POST"
    ]
)
def add() -> Response:
    request_body: dict = request.get_json(
        silent=True
    )
    return make_response(
        {
            "result": request_body["num1"] + request_body["num2"]
        },
        200
    )


@application.route(
    rule="/health",
    methods=[
        "GET"
    ]
)
def health() -> Response:
    return make_response(
        "",
        200
    )


if __name__ == "__main__":
    application.run(
        host="0.0.0.0",
        port=8000,
        debug=True,
    )
