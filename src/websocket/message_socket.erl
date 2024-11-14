-module(message_socket).
-behaviour(cowboy_websocket).


-export([init/2, websocket_init/1, websocket_handle/2, websocket_info/2, terminate/3]).

init(Req, State) ->
    {cowboy_websocket, Req, State}.

websocket_init(State) ->
    Pid = self(),
    % socket_server:arrive(Pid),
    io:fwrite("WebSocket websocket_init, Pid: ~w~n", [Pid]),
    {ok, State}.

websocket_handle({text, Msg}, State) ->
    SenderPid = self(),
    Data =  json:decode(Msg),
    Topic = maps:get(<<"topic">>, Data),
    io:fwrite("websocket_handle: Received message ~s from ~p~n", [Msg, SenderPid]),
    case Topic of
        <<"register">> ->
            UserId = maps:get(<<"userId">>, Data),
                    io:format("Registering user: ~p with Pid: ~p~n", [UserId, SenderPid]),
                    socket_server:arrive(SenderPid, UserId),
                    {ok, State};
        <<"send_message">> -> 
            ReceiverId = maps:get(<<"receiverId">>, Data),
            io:format("Send message topic ~w~n", [ReceiverId]),
            data_type_util:print_type(ReceiverId),
            socket_server:send_message(ReceiverId, Msg),
             {ok, State};
        {error, Reason} ->
            io:fwrite("Failed to decode JSON: ~p~n", [Reason]),
            {ok, State}
    end.

websocket_info(ping, State) ->
    %% Gửi tin nhắn ping
    io:format("Sending ping~n"),
    {reply, {ping, <<>>}, State};

websocket_info({message, Content}, State) ->
    io:format("websocket_info: Received message ~s~n", [Content]),
    {reply, {text, Content}, State}.

terminate(_Reason, _Req, _State) ->
    Pid = self(),
    io:fwrite("WebSocket terminate, Pid: ~w~n", [Pid]),
    % chat_room:leave(Pid),
    ok.