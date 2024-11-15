-module(room_controller).
-include("../config/datatype/data_type.hrl").
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
            handle_register(Req, Method);
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
    % Giả sử bạn lấy danh sách phòng từ dịch vụ room_db
    Rooms = room_db:get_rooms(),

    % Tạo phản hồi dữ liệu các phòng
    ResponseData = #{<<"rooms">> => Rooms},

    % Tạo phản hồi HTTP với mã trạng thái 200 và dữ liệu các phòng
    http_util:create_response(Req, #success_response{
        status = 200, data = ResponseData, message = <<"Rooms fetched successfully">>
    }).

handle_get_members(Req, _State) ->
    % Giả sử bạn lấy danh sách người dùng từ dịch vụ user_service
    Members = room_db:get_members(),

    % Tạo phản hồi dữ liệu các phòng
    ResponseData = #{<<"members">> => Members},

    % Tạo phản hồi HTTP với mã trạng thái 200 và dữ liệu các phòng
    http_util:create_response(Req, #success_response{
        status = 200, data = ResponseData, message = <<"Rooms fetched successfully">>
    }).

handle_register(Req, Method) ->
    if
        Method =:= <<"POST">> ->
            {ok, Body, _} = cowboy_req:read_body(Req),
            case jsx:decode(Body, [{labels, atom}]) of
                #{type := Type, name := Name} ->
                    case room_db:insert_room(Type, Name) of
                        %     http_util:create_response(200, true, <<"Create successfully">>, Req);
                        % _ ->
                        %     http_util:create_response(400, false, <<"Invalid JSON payload">>, Req)
                        {ok, Name} ->
                            % Tạo phản hồi dữ liệu phòng vừa được tạo
                            ResponseData = #{<<"name">> => Name},
                            % Trả về phản hồi HTTP với mã trạng thái 200
                            http_util:create_response(Req, #success_response{
                                status = 200,
                                data = ResponseData,
                                message = <<"Room created successfully">>
                            });
                        {error, Reason} ->
                            % Trả về lỗi nếu có
                            ResponseData = #{<<"error">> => Reason},
                            http_util:create_response(Req, #success_response{
                                status = 500,
                                data = ResponseData,
                                message = <<"Room creation failed">>
                            })
                    end;
                _ ->
                    % Nếu JSON không hợp lệ
                    http_util:create_response(Req, #success_response{
                        status = 400,
                        data = #{<<"error">> => <<"Invalid JSON payload">>},
                        message = <<"Invalid JSON payload">>
                    })
            end;
        true ->
            http_util:create_response(405, false, <<"Method not allowed">>, Req)
    end.

handle_create_member(Req, Method) ->
    if
        Method =:= <<"POST">> ->
            {ok, Body, _} = cowboy_req:read_body(Req),
            case jsx:decode(Body, [{labels, atom}]) of
                #{type := Type, name := Name, user_ids := UserIds} when is_list(UserIds) ->
                    io:format("Received data - Type: ~p, Name: ~p, UserIds: ~p~n", [
                        Type, Name, UserIds
                    ]),
                    case room_db:insert_room_and_member(Type, Name, UserIds) of
                        {ok, RoomId} ->
                            % Tạo phản hồi dữ liệu phòng vừa được tạo
                            ResponseData = #{<<"room_id">> => RoomId},
                            % Trả về phản hồi HTTP với mã trạng thái 200
                            http_util:create_response(Req, #success_response{
                                status = 200,
                                data = ResponseData,
                                message = <<"Member created successfully">>
                            });
                        {error, Reason} ->
                            % Trả về lỗi nếu có
                            ResponseData = #{<<"error">> => Reason},
                            http_util:create_response(Req, #success_response{
                                status = 500,
                                data = ResponseData,
                                message = <<"Member creation failed">>
                            })
                    end;
                _ ->
                    % Xử lý nếu JSON không hợp lệ hoặc thiếu danh sách user_ids
                    http_util:create_response(Req, #success_response{
                        status = 400,
                        data = #{<<"error">> => <<"Invalid JSON payload">>},
                        message = <<"Invalid JSON payload">>
                    })
            end;
        true ->
            % Nếu phương thức không phải POST, trả về lỗi 405 Method Not Allowed
            {ok, Req2} = cowboy_req:reply(
                405,
                #{<<"content-type">> => <<"application/json">>},
                <<"{\"error\": \"Method not allowed\"}">>,
                Req
            ),
            {stop, Req2, []}
    end.
