-module(room_db).
-export([insert_room/1, get_room_list/1]).

insert_room(Type) ->
    Pid = whereis(mysql_conn),
    data_type_util:print_type(Type),
    Query = io_lib:format("INSERT INTO rooms (type) VALUES ('~s');", [Type]),
    io:format("Query =>>>: ~s~n", [Query]),
    ok = mysql:query(Pid, Query),
    {ok, _Key, [[Id]]}= mysql:query(Pid, "SELECT LAST_INSERT_ID()"),
    io:format("Id =>>>: ~p~n", [Id]),
    Id.

get_room_list(UserId) ->
    Pid = whereis(mysql_conn),
    Query = io_lib:format("select r.*, m.id as member_id
                            from rooms r join members m on r.id = m.room_id 
                            join users u on u.id = m.id 
                            where u.id = ~p", [UserId]),
    MemberQuery = io_lib:format("select u.username 
                            from members m join users u on u.id = m.user_id 
                            where m.user_id != ~p", [UserId]),
    {ok, _Key, Data} = mysql:query(Pid, Query),
    Rooms = lists:map(fun([RoomId, Type, _RoomName, _MemberId]) ->
            {ok, _Key2, [[MemberData]]} = mysql:query(Pid, MemberQuery),
            #{roomId => RoomId, type => Type, roomName => MemberData}
        end, Data),
    Rooms.
