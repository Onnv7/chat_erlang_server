-module(db_manager).
-export([start_link/0, stop/0, create_tables/1]).

-define(DB_HOST, "localhost").
-define(DB_USER, "root").
-define(DB_PASS, "112233").
-define(DB_NAME, "chat").
-define(DB_PORT, 3306).

start_link() ->
    {ok, Pid} = mysql:start_link([{host, ?DB_HOST}, {port, ?DB_PORT}, {user, ?DB_USER}, {password, ?DB_PASS}, {database, ?DB_NAME}]),
    register(mysql_conn, Pid),
    create_tables(Pid),
    {ok, Pid}.

stop() ->
    unregister(mysql_conn),
    ok.


create_tables(Pid) ->
    % User table
    mysql:query(Pid, "CREATE TABLE IF NOT EXISTS users (
        id VARCHAR(255) PRIMARY KEY,
        username VARCHAR(255),
        password VARCHAR(255)
    )"),

    % Room table
    mysql:query(Pid, "CREATE TABLE IF NOT EXISTS rooms (
        id VARCHAR(255) PRIMARY KEY,
        type ENUM('personal', 'group'),
        name VARCHAR(255)
    )"),

    % Member table
     mysql:query(Pid, "CREATE TABLE IF NOT EXISTS members (
        id VARCHAR(255) PRIMARY KEY,
        room_id VARCHAR(255),
        user_id VARCHAR(255),
        FOREIGN KEY (room_id) REFERENCES rooms(id),
        FOREIGN KEY (user_id) REFERENCES users(id)
    )"),
    mysql:query(Pid, "CREATE TABLE IF NOT EXISTS messages (
        id VARCHAR(255) PRIMARY KEY,
        content VARCHAR(255),
        created_at DATE,
        room_id VARCHAR(255),
        sender_id VARCHAR(255),
        FOREIGN KEY (room_id) REFERENCES rooms(id),
        FOREIGN KEY (sender_id) REFERENCES members(id)
    )"),
    ok.