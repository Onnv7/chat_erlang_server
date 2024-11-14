-module(friend_service).
-include("../config/datatype/data_type.hrl").
-export([handle_send_invitation/1]).

handle_send_invitation(Req) ->
    {ok, Body, Req2} = cowboy_req:read_body(Req),
    Data =  json:decode(Body),
    io:format("Body: ~p~n", [Data]),
    data_type_util:print_type(maps:get(<<"senderId">>, Data)),
    SenderId = maps:get(<<"senderId">>, Data),
    ReceiverId = maps:get(<<"receiverId">>, Data),
    io:format("SenderId: ~p, ReceiverId: ~p~n", [SenderId, ReceiverId]),
            %% Tạo lời mời
            case invitation_db:create_invitation(SenderId, ReceiverId) of
                {ok, _Result} ->
                    {ok, Resp} = cowboy_req:reply(200, #{<<"content-type">> => <<"application/json">>}, <<"{\"message\": \"Invitation sent successfully\"}">>, Req2),
                    {ok, Resp, []};
                {error, Reason} ->
                    {ok, Resp} = cowboy_req:reply(500, #{<<"content-type">> => <<"application/json">>}, <<"{\"error\": \"Failed to send invitation\"}">>, Req2),
                    {ok, Resp, []}
            end.