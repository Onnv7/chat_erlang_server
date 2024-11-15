-module(invitation_service).
-include("../config/datatype/data_type.hrl").
-export([handle_send_invitation/1, handle_process_invitation/1]).

handle_send_invitation(Req) ->
    {ok, Body, Req2} = cowboy_req:read_body(Req),
    Data =  json:decode(Body),
    io:format("Body: ~p~n", [Data]),
    #{<<"senderId">> := SenderId, <<"receiverId">> := ReceiverId} = json:decode(Body),
    data_type_util:print_type(maps:get(<<"senderId">>, Data)),
    %% Tạo lời mời
    case invitation_db:create_invitation(SenderId, ReceiverId) of
        {ok, InvitationId} ->
            Msg = json:encode(#{<<"invitationId">> => InvitationId}),
            socket_server:send_message(ReceiverId, Msg),
            ok;
        {error, Reason} ->
            {ok, Resp} = cowboy_req:reply(500, #{<<"content-type">> => <<"application/json">>}, <<"{\"error\": \"Failed to send invitation\"}">>, Req2),
            {ok, Resp, []}
    end.

handle_process_invitation(Req) ->
    {ok, Body, Req2} = cowboy_req:read_body(Req),
    Data =  json:decode(Body),
    InvitationId = maps:get(<<"id">>, Data),
    Action = binary_to_list(maps:get(<<"action">>, Data)),
    io:format("InvitationId: ~p~p~n", [InvitationId, Action]),
    case invitation_db:process_invitation(InvitationId, Action) of
        ok ->
            ok;
        {error, Reason} ->
            {ok, Resp} = cowboy_req:reply(500, #{<<"content-type">> => <<"application/json">>}, <<"{\"error\": \"Failed to send invitation\"}">>, Req2),
            {ok, Resp, []}
    end.