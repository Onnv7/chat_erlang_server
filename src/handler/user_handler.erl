-module(user_handler).
-include("../config/datatype/data_type.hrl").
-export([handle_register/2]).

-behaviour(cowboy_handler).
-export([init/2]).

init(Req, State) ->
    Method = cowboy_req:method(Req),
    Path = http_util:get_path(Req),
    io:format("Method: ~p~n", [Method]),
       case {Method, Path} of
        {<<"OPTIONS">>, _} ->
            http_util:handle_options(Req, State);
        {<<"GET">>, "/api/user"} ->
            handle_get(Req, State);
        {<<"GET">>, "/api/user/test"} ->
            handle_get(Req, State);
        {<<"POST">>, "/api/user/register"} ->
            handle_register(Req, Method);
        {<<"POST">>, "/api/user/login"} ->
            handle_login(Req, Method);
        _ ->
            {ok, Resp} = cowboy_req:reply(404, #{<<"content-type">> => <<"application/json">>},
                <<"{\"error\": \"Not Found\"}">>, Req),
            {ok, Resp, []}
    end.

handle_login(Req, Method) ->
    if Method =:= <<"POST">> ->
        case user_service:handle_login_user(Req) of
            {ok, #login_response{accessToken = Token, id = Id}} ->
                ResponseData = #{<<"accessToken">> => Token, <<"userId">> => Id},
                http_util:create_response(Req, #success_response{status = 200, data = ResponseData, message = <<"Login successfully">>});
                % Req2 = cowboy_req:reply(200, #{<<"content-type">> => <<"application/json">>}, ResponseBody, Req),
                % {ok, Req2, []};
            {error, invalid_password} ->
                {ok, Resp} = cowboy_req:reply(401, #{<<"content-type">> => <<"application/json">>},
                    <<"{\"error\": \"Invalid password\"}">>, Req),
                {ok, Resp, []};
            {error, Reason} ->
                {ok, Resp} = cowboy_req:reply(500, #{<<"content-type">> => <<"application/json">>},
                    <<"{\"error\": \"Internal server error\"}">>, Req),
                {ok, Resp, []}
        end;
    true ->
        {ok, Req2} = cowboy_req:reply(405, #{<<"content-type">> => <<"application/json">>},
            <<"{\"error\": \"Method not allowed\"}">>, Req),
        {ok, Req2, []}
    end.
   

handle_get(Req, _State) ->
    % Response = #{message => <<"This is the user page">>},
    io:format("In user page~n"),
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
    


