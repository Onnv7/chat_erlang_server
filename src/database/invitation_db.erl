-module(invitation_db).
-export([create_invitation/2]).

create_invitation(SenderId, ReceiverId) ->
    Pid = whereis(mysql_conn),
    Query = "INSERT INTO relationships (sender_id, receiver_id) VALUES (?, ?)",
    Params = [SenderId, ReceiverId],
    mysql:query(Pid, Query, Params).