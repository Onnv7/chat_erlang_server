-module(user_db).
-export([insert_user/2, create_user_table/1, get_users/0]).

create_user_table(Pid) ->
    mysql:query(Pid, "CREATE TABLE IF NOT EXISTS users (
        id INT AUTO_INCREMENT PRIMARY KEY,
        username VARCHAR(255),
        password VARCHAR(255)
    )").

get_users() ->
    case mysql:query(whereis(mysql_conn), "SELECT id, username, password FROM users") of
        {ok, _, Rows} ->
            [
                #{id => Id, username => Username, password => Password}
                || [Id, Username, Password] <- Rows
            ];
        _ ->
            []
    end.

insert_user(Username, Password) ->
    Pid = whereis(mysql_conn),
    Query = io_lib:format("INSERT INTO users (username, password) VALUES ('~s', '~s')", [Username, Password]),
    mysql:query(Pid, Query).