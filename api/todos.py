import os
from pydantic import BaseModel, Field, constr
from typing import Literal
import uuid
from datetime import datetime
import azure.functions as func


class TodoItem(BaseModel):
    PartitionKey: Literal["todos"] = Field(default="todos")
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
    try:
        import json
        from azure.data.tables import TableServiceClient

        # Parse request body
        data = req.get_json()
        todo = TodoItem(**data)

        # Get connection string from environment
        conn_str = os.environ.get("AzureWebJobsStorage")
        if not conn_str:
            return func.HttpResponse(
                json.dumps({"error": "Missing AzureWebJobsStorage env var"}),
                status_code=500,
                mimetype="application/json",
            )

        # Connect to Table Storage
        table_service = TableServiceClient.from_connection_string(conn_str)
        table_client = table_service.get_table_client(table_name="todos")
        # Insert entity
        table_client.create_entity(todo.to_dict())

        return func.HttpResponse(
            json.dumps(todo.to_dict()),
            status_code=201,
            mimetype="application/json",
        )
    except Exception as e:
        return func.HttpResponse(
            json.dumps({"error": str(e)}),
            status_code=400,
            mimetype="application/json",
        )
