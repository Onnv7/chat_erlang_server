-module(friend_controller).
-behaviour(cowboy_handler).
-export([init/2]).

init(Req, State) ->
    Method = cowboy_req:method(Req),
    Path = http_util:get_path(Req),
    case Path of
        "/friend/send" ->
            handle_send_invitation(Req, Method);
        _ ->
            {ok, Resp} = cowboy_req:reply(404, #{<<"content-type">> => <<"application/json">>},
                <<"{\"error\": \"Not Found\"}">>, Req),
            {ok, Resp, []}
    end.

handle_send_invitation(Req, Method) -> 
    if Method =:= <<"POST">> ->
       friend_service:handle_send_invitation(Req);
    true ->
        {ok, Req2} = cowboy_req:reply(405, #{<<"content-type">> => <<"application/json">>},
            <<"{\"error\": \"Method not allowed\"}">>, Req),
        {ok, Req2, []}
    end.