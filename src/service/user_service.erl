-module(user_service).

-export([handle_register_user/1]).

handle_register_user(Req) ->
    {ok, Body, _Req2} = cowboy_req:read_body(Req),
    Data = json:decode(Body),
    Username = binary_to_list(maps:get(<<"username">>, Data)),
    Password = binary_to_list(maps:get(<<"password">>, Data)),
    io:format("Username: ~p~n", [Username]),
    user_db:insert_user(Username, Password).
% Pass = bcrypt_util:hash_password(Password),
% io:format("Password: ~p~n", [Pass]).


