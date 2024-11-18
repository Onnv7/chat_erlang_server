-module(room_service).
-include("../config/datatype/data_type.hrl").

-export([handle_create_room/1, handle_send_msg/1, get_room_list/1]).

handle_create_room(Req) -> 
    {ok, Body, _} = cowboy_req:read_body(Req),
    RoomType = http_util:get_field_value(Body, <<"type">>),
    UserIdList = http_util:get_field_value(Body, <<"user_id_list">>),
    data_type_util:print_type(UserIdList), 
    RoomId = room_db:insert_room(RoomType),
    lists:foreach(fun(UserId) ->
        % Process the UserId
        io:format("Processing UserId: ~p~n", [UserId]),
        member_db:create_member(UserId, RoomId)
    end, UserIdList),
    ok.
handle_send_msg(Req) -> 
    {ok, Body, _} = cowboy_req:read_body(Req),
    RoomId = erlang:binary_to_integer(cowboy_req:binding(id, Req)),
    Content = http_util:get_field_value(Body, <<"content">>),
    ContentString = list_to_binary(Content),
    SenderId = http_util:get_field_value(Body, <<"senderId">>),
    message_db:create_message(Content, RoomId, SenderId),
    UserIdList = member_db:get_member_id_list(RoomId),
    lists:foreach(fun(UserId) ->
        data_type_util:print_type(UserId),
        if UserId =/= SenderId ->
            Msg = json:encode(#{<<"senderId">> => SenderId, <<"content">> => ContentString, <<"roomId">> => RoomId}),
            socket_server:send_message(UserId, Msg);
        true ->
            ok
        end
    end, UserIdList).

get_room_list(Req) -> 
    {ok, Body, _} = cowboy_req:read_body(Req),
    UserId = erlang:binary_to_integer(cowboy_req:binding(userId, Req)),
    RoomList = room_db:get_room_list(UserId),
    data_type_util:print_type(RoomList),
    io:format("RoomList: ~p~n", [RoomList]),
    RoomList.