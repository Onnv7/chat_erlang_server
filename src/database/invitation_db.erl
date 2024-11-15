-module(invitation_db).
-export([create_invitation/2, process_invitation/2]).

create_invitation(SenderId, ReceiverId) ->
    Pid = whereis(mysql_conn),
    Query = "INSERT INTO relationships (sender_id, receiver_id, relationship) VALUES (?, ?, 'pending')",
    Params = [SenderId, ReceiverId],
    io:format("Params =>L>>: ~p~n", [Params]),
    case mysql:query(Pid, Query, Params) of
        Result ->
            SelectQuery = "SELECT id FROM relationships WHERE sender_id = ? AND receiver_id = ?",
            SelectParams = [SenderId, ReceiverId],
            case mysql:query(Pid, SelectQuery, SelectParams) of
                 {ok, _Key, [[Data]]} ->
                    {ok, Data};
                {error, Reason} ->
                    {error, Reason}
            end;
        {error, Reason} ->
            {error, Reason}
    end.


process_invitation(InvitationId, Action) ->
    Pid = whereis(mysql_conn),
    case Action of
        "accept" ->
            Query = "UPDATE relationships SET relationship = 'accepted' WHERE id = ?",
            Params = [InvitationId];
        "reject" ->
            Query = "DELETE FROM relationships WHERE id = ?",
            Params = [InvitationId]
    end,
    mysql:query(Pid, Query, Params).