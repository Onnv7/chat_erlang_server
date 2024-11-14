-module(user_db).
-export([insert_user/2, create_user_table/1, get_user/1]).

create_user_table(Pid) ->
    mysql:query(Pid, "CREATE TABLE IF NOT EXISTS users (
        id INT AUTO_INCREMENT PRIMARY KEY,
        username VARCHAR(255),
        password VARCHAR(255)
    )").

insert_user(Username, Password) ->
    Pid = whereis(mysql_conn),
    Query = io_lib:format("INSERT INTO users (username, password) VALUES ('~s', '~s')", [Username, Password]),
    mysql:query(Pid, Query).

get_user(Username) ->
    Pid = whereis(mysql_conn),
    Query = io_lib:format("SELECT * FROM users WHERE username = '~s'", [Username]),
    mysql:query(Pid, Query).