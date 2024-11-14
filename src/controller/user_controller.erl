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
            handle_register(Req, Method),
            http_util:create_response(200, <<"Register successfully">>, Req);
        _ ->
            {ok, Resp} = cowboy_req:reply(
                404,
                #{<<"content-type">> => <<"application/json">>},
                <<"{\"error\": \"Not Found\"}">>,
                Req
            ),
            {ok, Resp, []}
    end.

handle_get(Req, _State) ->
    % Giả sử bạn lấy danh sách người dùng từ dịch vụ user_service
    Users = user_db:get_users(),

    % Mã hóa danh sách người dùng thành JSON

    % Sử dụng jsx để mã hóa JSON
    UsersJson = jsx:encode(Users),

    % Tạo phản hồi HTTP với mã trạng thái 200 và dữ liệu người dùng
    {ok, Req2} = cowboy_req:reply(
        200,
        #{<<"content-type">> => <<"application/json">>},
        UsersJson,
        Req
    ),

    {ok, Req2, []}.

handle_register(Req, Method) ->
    if
        Method =:= <<"POST">> ->
            user_service:handle_register_user(Req),
            http_util:create_response(200, true, <<"Create successfully">>, Req);
        true ->
            {ok, Req2} = cowboy_req:reply(
                405,
                #{<<"content-type">> => <<"application/json">>},
                <<"{\"error\": \"Method not allowed\"}">>,
                Req
            ),
            {stop, Req2, []}
    end.
