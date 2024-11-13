-module(http_util).
-export([init/2, handle/2, terminate/3, check_method/2, get_path/1, create_response/2, create_response/4]).

-record(success_response, {status, data, message}).
-record(error_response, {status, error, message}).

init(Req, State) ->
    {cowboy_rest, Req, State}.


check_method(Req, MethodCheck) ->
    Method = cowboy_req:method(Req),
    Method =:= MethodCheck.

get_path(Req) ->
    Path = cowboy_req:path(Req),
    binary_to_list(Path).

create_response(Req, #success_response{status = Status, data = Data, message = Message}) ->
    ResponseData = #{success => true, data => Data, message => Message},
    JsonData = jsx:encode(ResponseData),
    {ok, Resp} = cowboy_req:reply(Status, #{<<"content-type">> => <<"application/json">>}, JsonData, Req),
    {ok, Resp, []};

create_response(Req, #error_response{status = Status, error = Error, message = Message}) ->
    ResponseData = #{success => false, error => Error, message => Message},
    JsonData = jsx:encode(ResponseData),
    {ok, Resp} = cowboy_req:reply(Status, #{<<"content-type">> => <<"application/json">>}, JsonData, Req),
    {ok, Resp, []}.

create_response(Status, IsSuccess, Message, Req) ->
    ResponseData = #{success => IsSuccess, message =>  Message},
    JsonData = jsx:encode(ResponseData),
    Resp = cowboy_req:reply(Status, #{<<"content-type">> => <<"application/json">>}, JsonData, Req),
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
    user_controller:handle_get_register(Req, State).

handle_post(Req, State) ->
    % Forward to the actual handler for POST requests
    user_controller:handle_post_register(Req, State).

terminate(_Reason, _Req, _State) ->
    ok.