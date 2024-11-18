-module(message_db).
-export([create_message/3]).

create_message(Content, RoomId, SenderId) ->
    Pid = whereis(mysql_conn),
    Query = io_lib:format("INSERT INTO messages (content, room_id, sender_id, created_at) VALUES ('~s', ~p, ~p, NOW());", [Content, RoomId, SenderId]),
    io:format("Query messages =>>>: ~s~n", [Query]),
    mysql:query(Pid, Query).
