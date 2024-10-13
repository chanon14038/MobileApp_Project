from typing import Annotated

from fastapi import (
    APIRouter,
    Cookie,
    Depends,
    FastAPI,
    HTTPException,
    Query,
    Request,
    WebSocket,
    WebSocketDisconnect,
    WebSocketException,
    status,
)
from fastapi.responses import HTMLResponse
from sqlmodel import select
from sqlmodel.ext.asyncio.session import AsyncSession

from .. import models

from .. import deps


router = APIRouter(prefix="/ws")

html = """
<!DOCTYPE html>
<html lang="th">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WebSocket Client</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
        }
        #messages {
            border: 1px solid #ccc;
            padding: 10px;
            height: 200px;
            overflow-y: scroll;
        }
    </style>
</head>
<body>

<h1>WebSocket Client</h1>
<input type="text" id="token" placeholder="Enter your token" />
<button id="connectBtn">Connect</button>

<div id="messages"></div>

<input type="text" id="messageInput" placeholder="Type your message..." />
<button id="sendBtn">Send</button>

<script>
    let websocket;

    document.getElementById("connectBtn").onclick = function() {
        const token = document.getElementById("token").value;
        if (!token) {
            alert("Please enter a token.");
            return;
        }
        // Connect to WebSocket
        websocket = new WebSocket(`ws://127.0.0.1:8000/ws?token=${token}`);

        websocket.onopen = function() {
            console.log("Connected to WebSocket");
            document.getElementById("messages").innerHTML += "<div>Connected to server</div>";
        };

        websocket.onmessage = function(event) {
            console.log("Message from server: ", event.data);
            document.getElementById("messages").innerHTML += `<div>${event.data}</div>`;
        };

        websocket.onclose = function() {
            console.log("Disconnected from WebSocket");
            document.getElementById("messages").innerHTML += "<div>Disconnected from server</div>";
        };

        websocket.onerror = function(error) {
            console.error("WebSocket error: ", error);
            document.getElementById("messages").innerHTML += "<div style='color: red;'>WebSocket error occurred.</div>";
        };
    };

    document.getElementById("sendBtn").onclick = function() {
        const message = document.getElementById("messageInput").value;
        if (websocket && websocket.readyState === WebSocket.OPEN) {
            websocket.send(message);
            document.getElementById("messageInput").value = ""; // Clear input field
        } else {
            alert("WebSocket is not connected.");
        }
    };
</script>

</body>
</html>
"""


@router.get("/notifications")
async def get_notification(
    session: Annotated[AsyncSession, Depends(models.get_session)],
    current_user: models.User = Depends(deps.get_current_user),
):
    result = await session.exec(
        select(models.DBNotification).where(models.DBNotification.advisor_room == current_user.advisor_room)
    )
    notifications = result.all()
    return notifications
    
    
@router.get("")
async def get():
    return HTMLResponse(html)

active_connections: list[WebSocket] = []

async def get_notification(
    session: Annotated[AsyncSession, Depends(models.get_session)],
):
    result = await session.exec(select(models.DBNotification))
    notifications = result.all()
    return notifications


@router.get("")
async def get():
    return HTMLResponse(html)

active_connections: list[dict] = []


@router.websocket("")
async def websocket_endpoint(
    websocket: WebSocket,
    session: Annotated[AsyncSession, Depends(models.get_session)]
):
    token = websocket.query_params.get("token")

    if not token:
        await websocket.close(code=1008)
        return

    try:
        current_user = await deps.get_current_user(token=token, session=session)

        await websocket.accept()

        notifications = await get_notification(session=session)
        
        for notification in notifications:
            await websocket.send_text(notification.message)
        
    except HTTPException:
        await websocket.close(code=1008)
        return

    active_connections.append({"websocket": websocket, "user_id": current_user.id})

    try:
        while True:
            await websocket.receive_text()
    except WebSocketDisconnect:
        active_connections[:] = [
            conn for conn in active_connections 
            if conn["websocket"] != websocket or conn["user_id"] != current_user.id
        ]
        print(f"Client {current_user.id} disconnected")
