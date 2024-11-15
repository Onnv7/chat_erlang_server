-module(user_controller).
-include("../config/datatype/data_type.hrl").
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
        "/user/login" ->
            handle_login(Req, Method);
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

    % Tạo phản hồi dữ liệu người dùng
    ResponseData = #{<<"users">> => Users},

    % Tạo phản hồi HTTP với mã trạng thái 200 và dữ liệu người dùng
    http_util:create_response(Req, #success_response{
        status = 200, data = ResponseData, message = <<"Users fetched successfully">>
    }).

handle_login(Req, Method) ->
    if
        Method =:= <<"POST">> ->
            case user_service:handle_login_user(Req) of
                {ok, #login_response{accessToken = Token, id = Id}} ->
                    ResponseData = #{<<"accessToken">> => Token, <<"id">> => Id},
                    http_util:create_response(Req, #success_response{
                        status = 200, data = ResponseData, message = <<"Login successfully">>
                    });
                % Req2 = cowboy_req:reply(200, #{<<"content-type">> => <<"application/json">>}, ResponseBody, Req),
                % {ok, Req2, []};
                {error, invalid_password} ->
                    {ok, Resp} = cowboy_req:reply(
                        401,
                        #{<<"content-type">> => <<"application/json">>},
                        <<"{\"error\": \"Invalid password\"}">>,
                        Req
                    ),
                    {ok, Resp, []};
                {error, Reason} ->
                    {ok, Resp} = cowboy_req:reply(
                        500,
                        #{<<"content-type">> => <<"application/json">>},
                        <<"{\"error\": \"Internal server error\"}">>,
                        Req
                    ),
                    {ok, Resp, []}
            end;
        true ->
            {ok, Req2} = cowboy_req:reply(
                405,
                #{<<"content-type">> => <<"application/json">>},
                <<"{\"error\": \"Method not allowed\"}">>,
                Req
            ),
            {ok, Req2, []}
    end.

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
