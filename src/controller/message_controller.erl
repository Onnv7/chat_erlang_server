-module(message_controller).
-include("../config/datatype/data_type.hrl").
-export([handle_get_message/2, handle_create_message/2]).

-behaviour(cowboy_handler).
-export([init/2]).

init(Req, State) ->
    Method = cowboy_req:method(Req),
    Path = http_util:get_path(Req),
    case Path of
        "/message" ->
            handle_get_message(Req, State);
        % Đường dẫn tạo tin nhắn
        "/message/create-message" ->
            handle_create_message(Req, Method);
        _ ->
            {ok, Resp} = cowboy_req:reply(
                404,
                #{<<"content-type">> => <<"application/json">>},
                <<"{\"error\": \"Not Found\"}">>,
                Req
            ),
            {ok, Resp, []}
    end.


handle_get_message(Req, _State) ->
    % Giả sử bạn lấy danh sách người dùng từ dịch vụ user_service
    Messages = message_db:get_message(),

    % Tạo phản hồi dữ liệu các phòng
    ResponseData = #{<<"messages">> => Messages},

    % Tạo phản hồi HTTP với mã trạng thái 200 và dữ liệu các phòng
    http_util:create_response(Req, #success_response{
        status = 200, data = ResponseData, message = <<"Messages fetched successfully">>
    }).

handle_create_message(Req, Method) ->
    if
        Method =:= <<"POST">> ->
            {ok, Body, _} = cowboy_req:read_body(Req),
            case jsx:decode(Body, [{labels, atom}]) of
                #{content := Content, room_id := RoomId, sender_id := SenderId} ->
                    io:format("Received data - Type: ~p, Name: ~p, UserIds: ~p~n", [
                        Content, RoomId, SenderId
                    ]),
                    case message_db:insert_message(Content, RoomId, SenderId) of
                        {ok, SenderId} ->
                            % Tạo phản hồi dữ liệu phòng vừa được tạo
                            ResponseData = #{<<"sender_id">> => SenderId},
                            % Trả về phản hồi HTTP với mã trạng thái 200
                            http_util:create_response(Req, #success_response{
                                status = 200,
                                data = ResponseData,
                                message = <<"Message created successfully">>
                            });
                        {error, Reason} ->
                            % Trả về lỗi nếu có
                            ResponseData = #{<<"error">> => Reason},
                            http_util:create_response(Req, #success_response{
                                status = 500,
                                data = ResponseData,
                                message = <<"Message creation failed">>
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
