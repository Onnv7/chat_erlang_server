-module(room_handler).
-include("../config/datatype/room_dto.hrl").
-export([handle_create_room/2]).
-behaviour(cowboy_handler).
-export([init/2]).

init(Req, _State) ->
    Method = cowboy_req:method(Req),
    Path = http_util:get_path(Req),
    RoomId = cowboy_req:binding(id, Req),
    io:format("RoomId: ~p~n", [RoomId]),
    case Path of
        "/api/room" ->
            handle_create_room(Req, Method);
        _ ->
            {ok, Resp} = cowboy_req:reply(
                404,
                #{<<"content-type">> => <<"application/json">>},
                <<"{\"error\": \"Not Found\"}">>,
                Req
            ),
            {ok, Resp, []}
    end.

handle_create_room(Req, Method) ->
    io:format("handle_create_room: ~p~n", [Method]),
    if Method =:= <<"POST">> ->
        room_service:handle_create_room(Req),
        http_util:create_response(200, true, <<"Create room successfully">>, Req)
    end.
          