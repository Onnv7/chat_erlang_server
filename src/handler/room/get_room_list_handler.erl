-module(get_room_list_handler).
-include("../../config/datatype/data_type.hrl").
-behaviour(cowboy_handler).
-export([init/2]).


init(Req, State) ->
    Method = cowboy_req:method(Req),
    if Method =:= <<"GET">> ->
        ResponseData = room_service:get_room_list(Req),
        http_util:create_response(Req, #success_response{status = 200, data = ResponseData, message = <<"Get room list successfully">>})
    end.
        
