-module(room_db).
-export([insert_room/1]).

insert_room(Type) ->
    Pid = whereis(mysql_conn),
    data_type_util:print_type(Type),
    Query = io_lib:format("INSERT INTO rooms (type) VALUES ('~s');", [Type]),
    io:format("Query =>>>: ~s~n", [Query]),
    ok = mysql:query(Pid, Query),
    {ok, _Key, [[Id]]}= mysql:query(Pid, "SELECT LAST_INSERT_ID()"),
    io:format("Id =>>>: ~p~n", [Id]),
    Id.

