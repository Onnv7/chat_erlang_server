-module(room_controller).
-export([handle_register/2, handle_get_members/2, handle_create_member/2]).

-behaviour(cowboy_handler).
-export([init/2]).

init(Req, State) ->
    Method = cowboy_req:method(Req),
    Path = http_util:get_path(Req),
    case Path of
        "/room" ->
            handle_get(Req, State);
        "/room/members" ->
            handle_get_members(Req, State);
        "/room/register" ->
            handle_register(Req, Method),
            http_util:create_response(200, <<"Register successfully">>, Req);
        % Đường dẫn tạo phòng và thêm thành viên
        "/room/create-members" ->
            handle_create_member(Req, Method);
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
    Rooms = room_db:get_rooms(),

    % Mã hóa danh sách người dùng thành JSON

    % Sử dụng jsx để mã hóa JSON
    UsersJson = jsx:encode(Rooms),

    % Tạo phản hồi HTTP với mã trạng thái 200 và dữ liệu người dùng
    {ok, Req2} = cowboy_req:reply(
        200,
        #{<<"content-type">> => <<"application/json">>},
        UsersJson,
        Req
    ),

    {ok, Req2, []}.

handle_get_members(Req, _State) ->
    % Giả sử bạn lấy danh sách người dùng từ dịch vụ user_service
    Members = room_db:get_members(),

    % Mã hóa danh sách người dùng thành JSON

    % Sử dụng jsx để mã hóa JSON
    UsersJson = jsx:encode(Members),

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
            {ok, Body, _} = cowboy_req:read_body(Req),
            case jsx:decode(Body, [{labels, atom}]) of
                #{type := Type, name := Name} ->
                    room_db:insert_room(Type, Name),
                    http_util:create_response(200, true, <<"Create successfully">>, Req);
                _ ->
                    http_util:create_response(400, false, <<"Invalid JSON payload">>, Req)
            end;
        true ->
            http_util:create_response(405, false, <<"Method not allowed">>, Req)
    end.

handle_create_member(Req, Method) ->
    if
        Method =:= <<"POST">> ->
            {ok, Body, _} = cowboy_req:read_body(Req),
            case jsx:decode(Body, [{labels, atom}]) of
                #{type := Type, name := Name, user_id := UserId} ->
                    case room_db:insert_room_and_member(Type, Name, UserId) of
                        {ok, RoomId} ->
                            % Nếu chèn thành công
                            ResponseMessage = io_lib:format("Create successfully, Room ID: ~p", [
                                RoomId
                            ]),
                            http_util:create_response(
                                200, true, lists:flatten(ResponseMessage), Req
                            );
                        {error, Reason} ->
                            % Trả về lỗi nếu có
                            ErrorMessage = io_lib:format("Database error: ~p", [Reason]),
                            http_util:create_response(500, false, lists:flatten(ErrorMessage), Req)
                    end;
                _ ->
                    % Nếu JSON không hợp lệ
                    http_util:create_response(400, false, <<"Invalid JSON payload">>, Req)
            end;
        true ->
            % Nếu không phải phương thức POST
            http_util:create_response(405, false, <<"Method not allowed">>, Req)
    end.
