-module(user_controller).
-export([handle_register/2]).

-behaviour(cowboy_handler).
-export([init/2]).

init(Req, State) ->
    Method = cowboy_req:method(Req),
    Path = http_util:get_path(Req),
    case Path of
        "/user" ->
            handle_get(Req, State);
        "/user/register" ->
            handle_register(Req, Method);
        _ ->
            {ok, Resp} = cowboy_req:reply(404, #{<<"content-type">> => <<"application/json">>},
                <<"{\"error\": \"Not Found\"}">>, Req),
            {ok, Resp, []}
    end.

handle_get(Req, _State) ->
    % Response = #{message => <<"This is the user page">>},
    http_util:create_response(200, true, <<"This is message">>, Req).

handle_register(Req, Method) ->
    if Method =:= <<"POST">> ->
        user_service:handle_register_user(Req),
        http_util:create_response(200, true, <<"Create successfully">>, Req);
    true ->
        {ok, Req2} = cowboy_req:reply(405, #{<<"content-type">> => <<"application/json">>},
            <<"{\"error\": \"Method not allowed\"}">>, Req),
        {stop, Req2, []}
    end.
    


