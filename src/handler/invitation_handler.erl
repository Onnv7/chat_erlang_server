-module(invitation_handler).
-behaviour(cowboy_handler).
-export([init/2]).

init(Req, State) ->
    Method = cowboy_req:method(Req),
    Path = http_util:get_path(Req),
    case Path of
        "/api/invitation/send" ->
            handle_send_invitation(Req, Method);
        "/api/invitation/process" ->
            handle_process_invitation(Req, Method);
        _ ->
            {ok, Resp} = cowboy_req:reply(404, #{<<"content-type">> => <<"application/json">>},
                <<"{\"error\": \"Not Found\"}">>, Req),
            {ok, Resp, []}
    end.

handle_send_invitation(Req, Method) -> 
    if Method =:= <<"POST">> ->
        invitation_service:handle_send_invitation(Req),
        http_util:create_response(200, true, <<"Send invitation successfully">>, Req);
    true ->
        {ok, Req2} = cowboy_req:reply(405, #{<<"content-type">> => <<"application/json">>},
            <<"{\"error\": \"Method not allowed\"}">>, Req),
        {ok, Req2, []}
    end.

handle_process_invitation(Req, Method) -> 
    io:format("Method11: ~p~n", [Method]),
    if Method =:= <<"POST">> ->
        invitation_service:handle_process_invitation(Req),
        http_util:create_response(200, true, <<"Process invitation successfully">>, Req)
    end.