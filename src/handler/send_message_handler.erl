-module(send_message_handler).
-behaviour(cowboy_handler).
-export([init/2]).

init(Req, State) ->
    Method = cowboy_req:method(Req),
    RoomId = erlang:binary_to_integer(cowboy_req:binding(id, Req)),
    io:format("RoomId 2: ~p~n", [RoomId]),
    if Method =:= <<"POST">> ->
        io:format("handle_send_msg: ~p~n", [Method]),
        room_service:handle_send_msg(Req),
        
        http_util:create_response(200, true, <<"Send message successfully">>, Req)
    end.

    
