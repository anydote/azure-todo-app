import azure.functions as func
import logging

app = func.FunctionApp(http_auth_level=func.AuthLevel.ANONYMOUS)


@app.route(route="/todos", methods=["GET"])
def get_todos(req: func.HttpRequest) -> func.HttpResponse:
    # TODO: Fetch all todos from storage
    return func.HttpResponse("[TODO] List all todos", mimetype="application/json")


@app.route(route="/todos", methods=["POST"])
def add_todo(req: func.HttpRequest) -> func.HttpResponse:
    # TODO: Add a new todo to storage
    return func.HttpResponse("[TODO] Add new todo", mimetype="application/json")
