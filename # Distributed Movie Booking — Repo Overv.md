# Distributed Movie Booking — Repo Overview

This repository contains a small demo / prototype of a distributed movie booking system with:
- Raft-based leader election (simple simulation + FastAPI status endpoints)
- Application server (FastAPI) that handles authentication, movies and bookings
- Local LLM FAQ server (FastAPI with a Transformers QA pipeline)
- Desktop GUI to start nodes and simulate clients
- Simple in-memory SQLite storage utilities and tests

Quick summary of entry points and important symbols:
- Raft node entry: [main.py](main.py) — starts a single Raft node using [`raft.raft_node.RaftNode`](raft/raft_node.py)
- Application server (API): [Application_server/Application_server.py](Application_server/Application_server.py) — class [`Application_server.ApplicationServer`](Application_server/Application_server.py) and FastAPI app object `app`
- LLM server (FAQ): [llm/llm_server.py](llm/llm_server.py) — FastAPI `app` that serves `/ask` and `/` endpoints (`llm.llm_server.app`)
- Desktop GUI: [app.py](app.py) — Tkinter/CustomTkinter UI used to start nodes and simulate clients
- Client simulator: [client/client.py](client/client.py) — class [`client.client.Client`](client/client.py)
- Raft node internals: [`raft.raft_state.RaftNodeState`](raft/raft_state.py) and [`raft.raft_node.RaftNode`](raft/raft_node.py)
- Local storage helpers: [llm/storage.py](llm/storage.py) — functions such as [`llm.storage.create_in_memory_db`](llm/storage.py), `create_user`, `authenticate_user`, `create_session`

Repository files
- [app.py](app.py)
- [main.py](main.py)
- [.vscode/settings.json](.vscode/settings.json)
- [Application_server/__init__.py](Application_server/__init__.py)
- [Application_server/Application_server.py](Application_server/Application_server.py)
- [client/__init__.py](client/__init__.py)
- [client/client.py](client/client.py)
- [llm/__init__.py](llm/__init__.py)
- [llm/llm_server.py](llm/llm_server.py)
- [llm/storage.py](llm/storage.py)
- [proto/__init__.py](proto/__init__.py)
- [proto/raft_pb2_grpc.py](proto/raft_pb2_grpc.py)
- [proto/raft_pb2.py](proto/raft_pb2.py)
- [proto/raft.proto](proto/raft.proto)
- [raft/__init__.py](raft/__init__.py)
- [raft/raft_config.json](raft/raft_config.json)
- [raft/raft_node.py](raft/raft_node.py)
- [raft/raft_state.py](raft/raft_state.py)
- [tests/test_booking.py](tests/test_booking.py)
- [tests/test_raft.py](tests/test_raft.py)

Prerequisites
- Python 3.8+
- Recommended (for LLM server): `fastapi`, `uvicorn`, `transformers`, `torch`
- For GUI: `customtkinter`
- Install base requirements via pip as needed:
  pip install fastapi uvicorn requests customtkinter

How to run components (development / manual)

1) Start the Application Server (HTTP API)
- Entry: [Application_server/Application_server.py](Application_server/Application_server.py)
- Run:
  python Application_server/Application_server.py
- The server listens on http://127.0.0.1:9000 and exposes:
  - POST /register
  - POST /login
  - GET /data/{data_type}
  - POST /business
  - POST /add_movie

2) Start a Raft node (each node runs its own FastAPI status endpoint)
- Entry: [main.py](main.py) — pass node id (node1, node2, node3)
- Example (run three terminals / processes):
  python main.py node1
  python main.py node2
  python main.py node3
- Internals: uses [`raft.raft_node.RaftNode`](raft/raft_node.py) which exposes `/status` and `/trigger-election`.
- Ports: node1 -> 50051, node2 -> 50052, node3 -> 50053

3) Start the local LLM FAQ server (optional)
- Entry: [llm/llm_server.py](llm/llm_server.py)
- Run:
  uvicorn llm.llm_server:app --host 0.0.0.0 --port 8500 --reload
- Endpoint examples:
  - GET /  (health)
  - POST /ask  (QA requests)

4) Start the Desktop GUI (convenience)
- Entry: [app.py](app.py)
- Run:
  python app.py
- The GUI can spawn Raft node processes by invoking [main.py](main.py) for node1/node2/node3 and provides simulation buttons.

5) Run client simulation (standalone)
- Entry: [client/client.py](client/client.py)
- Run:
  python client/client.py
- This script attempts to register/login against the app server at http://127.0.0.1:9000 and submit booking requests.

6) Tests
- Tests live in [tests/](tests)
- Run tests with pytest:
  pytest -q

Notes and pointers
- Raft proto definitions: [proto/raft.proto](proto/raft.proto) and generated bindings: [proto/raft_pb2.py](proto/raft_pb2.py), [proto/raft_pb2_grpc.py](proto/raft_pb2_grpc.py)
- Persistent storage: the current storage utilities use an in-memory SQLite DB via [`llm.storage.create_in_memory_db`](llm/storage.py). Adjust to a file DB if persistence is required.
- The Raft implementation is a demo/simplified simulation. For production-grade consensus, use a fully-featured Raft library.

If you want, I can add a small docker-compose and simple requirements.txt next.