from pydantic import BaseModel, Field, constr
import uuid
from datetime import datetime
import azure.functions as func


class TodoItem(BaseModel):
    PartitionKey: str = Field(default="todos", const=True)
    RowKey: str = Field(default_factory=lambda: str(uuid.uuid4()))
    title: constr(max_length=200)
    createdAt: str = Field(default_factory=lambda: datetime.utcnow().isoformat())

    @property
    def id(self) -> str:
        return self.RowKey

    def to_dict(self):
        d = self.dict()
        d["id"] = self.id
        return d


app = func.FunctionApp(http_auth_level=func.AuthLevel.ANONYMOUS)


@app.route(route="/todos", methods=["GET"])
def get_todos(req: func.HttpRequest) -> func.HttpResponse:
    # TODO: Fetch all todos from storage
    return func.HttpResponse("[TODO] List all todos", mimetype="application/json")


@app.route(route="/todos", methods=["POST"])
def add_todo(req: func.HttpRequest) -> func.HttpResponse:
    # TODO: Add a new todo to storage
    return func.HttpResponse("[TODO] Add new todo", mimetype="application/json")
