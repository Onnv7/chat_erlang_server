% -module(chat_erl_app).
% -behaviour(application).

% -export([start/2, stop/1]).

% -define(DB_HOST, "localhost").
% -define(DB_USER, "root").
% -define(DB_PASS, "112233").
% -define(DB_NAME, "chat").
% -define(DB_PORT, 3306).

% start(_StartType, _StartArgs) ->
%     {ok, _} = db_manager:start_link(),
%     chat_erl_sup:start_link(),
%     socket_server:start_link(),
%     Dispatch = cowboy_router:compile([
%         {'_', [
%                {"/user/[...]", user_controller, []},
%                 {"/room/[...]", room_controller, []},
%                 {"/message/[...]", message_controller, []},
%                 {"/ws/[...]", message_socket, []}
%         ]}
%     ]),
%     Middlewares = [auth_middleware, cowboy_router, cowboy_handler],
%     {ok, _} = cowboy:start_clear(
%         my_http_listener,
%         [{port, 8081}],
%         #{
%             env => #{dispatch => Dispatch}, 
%             middlewares => Middlewares,
%             idle_timeout => 60000
%         }
%     ),
%     io:format("Server started at http://localhost:8081 and ws://localhost:8081/ws~n"),
%     {ok, self()}.

% stop(_State) ->
%     db_manager:stop(),
%     ok.


-module(chat_erl_app).
-behaviour(application).

-export([start/2, stop/1]).

-define(DB_HOST, "localhost").
-define(DB_USER, "root").
-define(DB_PASS, "112233").
-define(DB_NAME, "chat").
-define(DB_PORT, 3306).

%% Start function for the application
start(_StartType, _StartArgs) ->
    %% Start the database manager
    {ok, _} = db_manager:start_link(),
    
    %% Start supervisor and other components
    chat_erl_sup:start_link(),
    socket_server:start_link(),

    %% Define dispatch rules for Cowboy routing
    Dispatch = cowboy_router:compile([
        {'_', [
            {"/user/[...]", user_controller, []},
            {"/room/[...]", room_controller, []},
            {"/message/[...]", message_controller, []},
            {"/ws/[...]", message_socket, []}
        ]}
    ]),

    %% Define middleware for Cowboy, including CORS handling
    Middlewares = [cors_middleware, auth_middleware, cowboy_router, cowboy_handler],

    %% Start the Cowboy HTTP server
    {ok, _} = cowboy:start_clear(
        my_http_listener,
        [{port, 8081}],
        #{
            env => #{dispatch => Dispatch},
            middlewares => Middlewares,
            idle_timeout => 60000
        }
    ),

    %% Log server startup message
    io:format("Server started at http://localhost:8081 and ws://localhost:8081/ws~n"),

    {ok, self()}.

%% Stop function for the application
stop(_State) ->
    %% Stop the database manager and other components
    db_manager:stop(),
    
    %% Log message to confirm stop
    io:format("Server stopped.~n"),
    
    ok.


