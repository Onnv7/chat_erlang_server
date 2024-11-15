-module(socket_server).
-behaviour(gen_server).

%% API
-export([start_link/0, arrive/2, leave/1, get_clients/0, send_message/2]).
%% gen_server callbacks
-export([init/1, handle_cast/2, handle_call/3, terminate/2, code_change/3]).

%% API
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

arrive(Pid, UserId) ->
    io:fwrite("Arrive: ~w, UserId: ~w~n", [Pid, UserId]),
    gen_server:cast(?MODULE, {arrive, Pid, UserId}).

leave(Pid) ->
    gen_server:cast(?MODULE, {leave, Pid}).

get_clients() ->
    gen_server:call(?MODULE, get_clients).

send_message(UserId, Content) ->
    gen_server:call(?MODULE, {send_message, UserId, Content}).

%% Helper function to find the Pid for a given UserId
find_user_client(UserId, State) ->
    case lists:keyfind(UserId, 2, State) of
        {Pid, UserId} -> {ok, Pid};
        false -> {error, user_not_found}
    end.

init([]) ->
    {ok, []}.

handle_cast({arrive, Pid, UserId}, State) ->
    {noreply, lists:usort([{Pid, UserId} | State])}; % Ensure no duplicates

handle_cast({leave, Pid}, State) ->
    {noreply, lists:delete(Pid, State)}.

handle_call(get_clients, _From, State) ->
    {reply, State, State};

handle_call({send_message, UserId, Content}, _From, State) ->
    io:format("Start send message to ~w~n", [UserId]),
    case find_user_client(UserId, State) of
        {ok, Pid} ->
            io:format("Sending message to ~w~n", [Pid]),
            io:format("Content: ~s~n", [Content]),
            Pid ! {message, Content},
            {reply, ok, State};
        {error, user_not_found} ->
            {reply, {error, user_not_found}, State}
    end.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.