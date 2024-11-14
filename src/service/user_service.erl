-module(user_service).
-include("../config/datatype/data_type.hrl").
-export([handle_register_user/1, handle_login_user/1]).

% -record(login_response, {accessToken, id}).

handle_register_user(Req) ->
    {ok, Body, _Req2} = cowboy_req:read_body(Req),
    Data = json:decode(Body),
    Username = binary_to_list(maps:get(<<"username">>, Data)),
    Password = binary_to_list(maps:get(<<"password">>, Data)),
    io:format("Username: ~p~n", [Username]),
    user_db:insert_user(Username, Password).
    % Pass = bcrypt_util:hash_password(Password),
    % io:format("Password: ~p~n", [Pass]).
    
handle_login_user(Req) -> 
    {ok, Body, _Req2} = cowboy_req:read_body(Req),
    Data = json:decode(Body),
    Username = binary_to_list(maps:get(<<"username">>, Data)),
    Password = binary_to_list(maps:get(<<"password">>, Data)),
    case user_db:get_user(Username) of
        {ok, [<<"id">>, <<"username">>, <<"password">>], [[Id, _DbUsername, DbPassword]]} ->
            case compare_password(Password, binary_to_list(DbPassword)) of
                true ->
                    Expires =  erlang:system_time(seconds) + 3600,
                    Token = jwt_util:create_token(Expires),
                    Response = #login_response{accessToken = Token, id = Id},
                    socket_server:send_message(Id, "Msg"),
                    {ok, Response};
                false ->
                    {error, invalid_password}
            end;
        {error, Reason} ->
            {error, Reason}
    end.

compare_password(Password, DbPassword) ->
    Password == DbPassword.


