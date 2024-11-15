-module(http_util).
-include("../config/datatype/room_dto.hrl").
-export([init/2, handle/2, terminate/3, check_method/2, get_path/1, create_response/2, create_response/4, get_field_value/2]).

-record(success_response, {status, data, message}).
-record(error_response, {status, error, message}).

init(Req, State) ->
    {cowboy_rest, Req, State}.


check_method(Req, MethodCheck) ->
    Method = cowboy_req:method(Req),
    Method =:= MethodCheck.

get_field_value(Body, Field) ->
    % {ok, Body, _} = cowboy_req:read_body(Req),
    io:format("Data: ~p~p~n", [Body, Field]),
    Data = json:decode(Body),
    X = maps:get(Field, Data),
    data_type_util:print_type(X),
    case maps:get(Field, Data) of
        Value when is_binary(Value) -> 
            io:format("Value is binary: ~p~n", [Value]),
            io:format("Value: ~p~n", [binary_to_list(Value)]),
            data_type_util:print_type(binary_to_list(Value)),
            binary_to_list(Value);
        Value when is_integer(Value) -> 
            Value;
        Value when is_float(Value) -> 
            Value;
        Value when is_list(Value) ->
            io:format("Value is list: ~p~n", [Value]),
            data_type_util:print_type(Value),

            % Assuming Value is a non-empty list
            [FirstElement | _] = Value,
            io:format("First element: ~p~n", [FirstElement]),
            data_type_util:print_type(FirstElement),
            Value;
            % case lists:all(fun(X) -> is_binary(X), is_integer(X), is_float(X) end, Value) of
            %     true -> 
            %         {ok, lists:map(fun(X) -> 
            %             case X of
            %                 Bin when is_binary(Bin) -> binary_to_list(Bin);
            %                 Num when is_integer(Num); is_float(Num) -> Num
            %             end
            %         end, Value)};
            %     false -> 
            %         {error, invalid_list_elements}
            % end;
        _ -> 
            {error, invalid_field}
    end.


get_path(Req) ->
    Path = cowboy_req:path(Req),
    binary_to_list(Path).

create_response(Req, #success_response{status = Status, data = Data, message = Message}) ->
    ResponseData = #{success => true, data => Data, message => Message},
    JsonData = json:encode(ResponseData),
    Headers = #{<<"content-type">> => <<"application/json">>, <<"Access-Control-Allow-Origin">> => <<"*">>},
    Resp= cowboy_req:reply(Status, Headers, JsonData, Req),
    {ok, Resp, []};

create_response(Req, #error_response{status = Status, error = Error, message = Message}) ->
    ResponseData = #{success => false, error => Error, message => Message},
    JsonData = jsx:encode(ResponseData),
    Headers = #{<<"content-type">> => <<"application/json">>, <<"Access-Control-Allow-Origin">> => <<"*">>},
    Resp = cowboy_req:reply(Status, Headers, JsonData, Req),
    {ok, Resp, []}.

create_response(Status, IsSuccess, Message, Req) ->
    ResponseData = #{success => IsSuccess, message =>  Message},
    JsonData = jsx:encode(ResponseData),
    Headers = #{<<"content-type">> => <<"application/json">>, <<"Access-Control-Allow-Origin">> => <<"*">>},
    Resp = cowboy_req:reply(Status, Headers, JsonData, Req),
    {ok, Resp, []}.


handle(Req, State) ->
    Method = cowboy_req:method(Req),
    case Method of
        <<"GET">> ->
            handle_get(Req, State);
        <<"POST">> ->
            handle_post(Req, State);
        _ ->
            {ok, Req2} = cowboy_req:reply(405, #{}, <<"Method Not Allowed">>, Req),
            {stop, Req2, State}
    end.

handle_get(Req, State) ->
    % Forward to the actual handler for GET requests
    user_handler:handle_get_register(Req, State).

handle_post(Req, State) ->
    % Forward to the actual handler for POST requests
    user_handler:handle_post_register(Req, State).

terminate(_Reason, _Req, _State) ->
    ok.