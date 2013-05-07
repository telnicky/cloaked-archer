cloaked-archer
==============

Websocket proof of concept

When a client connects it will begin to send its cursor position over a web socket. The server will then relay that position
to all the other clients. When a client receives a cursor position it will display it as a blue circle. Cursor positions are
updated frequently.

