-module(auth_middleware).

-behaviour(cowboy_middleware).
-export([execute/2]).

execute(Req, Env) ->
    io:format("In auth middleware~n"),
    Path = cowboy_req:path(Req),
    io:format("Path ~s~n", [Path]),
    case should_check_path(Path) of
        true ->
            case cowboy_req:header(<<"authorization">>, Req) of
                undefined ->
                    {ok, Resp} = cowboy_req:reply(401, #{<<"content-type">> => <<"application/json">>},
                        <<"{\"error\": \"Unauthorized\"}">>, Req),
                    {ok, Resp, Env};
                AuthHeader ->
                    Token = extract_token(AuthHeader),
                    verify_token(Token, Req, Env)
            end;
        false ->
            io:format("No need to check~n"),
            {ok, Req, Env}
    end.

should_check_path(<<"/user">>) -> true;
should_check_path(_) -> false.

extract_token(AuthHeader) ->
    [_, Token] = binary:split(AuthHeader, <<" ">>),
    Token.

verify_token(Token, Req, Env) ->
    case jwt_util:verify_token(Token) of
        {ok, _Claims} ->
            {ok, Req, Env};
        {error, _Reason} ->
            {ok, Resp} = cowboy_req:reply(401, #{<<"content-type">> => <<"application/json">>},
                <<"{\"error\": \"Unauthorized\"}">>, Req),
            {ok, Resp, Env}
    end.