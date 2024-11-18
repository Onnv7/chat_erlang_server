-module(member_db).
-export([create_member/2, get_member_id_list/1, get_member_list/1]).

create_member(UserId, RoomId) ->
    Pid = whereis(mysql_conn),
    Query = io_lib:format("INSERT INTO members (user_id, room_id) VALUES (~p, ~p);", [UserId, RoomId]),
    io:format("Query members =>>>: ~s~n", [Query]),
    mysql:query(Pid, Query).
   
get_member_id_list(RoomId) ->
    Pid = whereis(mysql_conn),
    Query = io_lib:format("SELECT user_id FROM members WHERE room_id = ~p;", [RoomId]),
    io:format("Query members =>>>: ~s~n", [Query]),
    {ok, _Key, Data} = mysql:query(Pid, Query),
    io:format("Data =>>>: ~p~n", [Data]),
    FlatList = lists:flatten(Data),
    io:format("Flat list: ~p~n", [FlatList]),
    FlatList.


get_member_list(RoomId) ->
    Pid = whereis(mysql_conn),
    Query = io_lib:format("SELECT user_id FROM members WHERE room_id = ~p;", [RoomId]),
    io:format("Query members =>>>: ~s~n", [Query]),
    {ok, _Key, Data} = mysql:query(Pid, Query),
    Data.