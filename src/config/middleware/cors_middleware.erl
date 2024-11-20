%% CORS Middleware for handling preflight requests and adding CORS headers
-module(cors_middleware).
-behaviour(cowboy_middleware).

-export([init/2, execute/2]).

init(Req, State) ->
    %% Add the necessary CORS headers to the request
    ReqWithCORS = cowboy_req:set_resp_header(
        Req, <<"Access-Control-Allow-Origin">>, <<"http://localhost:3000">>
    ),
    {ok, ReqWithCORS, State}.

execute(Req, State) ->
    case cowboy_req:method(Req) of
        <<"OPTIONS">> ->
            %% Handle preflight request and add CORS headers
            Res = cowboy_req:reply(
                200,
                [
                    %% Allow requests from frontend
                    {<<"Access-Control-Allow-Origin">>, <<"http://localhost:3000">>},
                    %% Allowed HTTP methods
                    {<<"Access-Control-Allow-Methods">>, <<"GET, POST, OPTIONS">>},
                    %% Allowed headers
                    {<<"Access-Control-Allow-Headers">>, <<"Content-Type, Authorization">>}
                ],
                Req
            ),
            {ok, Res, State};
        _ ->
            {ok, Req, State}
    end.
