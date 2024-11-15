-module(db_manager).
-export([start_link/0, stop/0, create_tables/1]).

-define(DB_HOST, "localhost").
-define(DB_USER, "root").
-define(DB_PASS, "123456").
-define(DB_NAME, "chat").
-define(DB_PORT, 3306).

start_link() ->
    {ok, Pid} = mysql:start_link([
        {host, ?DB_HOST},
        {port, ?DB_PORT},
        {user, ?DB_USER},
        {password, ?DB_PASS},
        {database, ?DB_NAME}
    ]),
    register(mysql_conn, Pid),
    create_tables(Pid),
    {ok, Pid}.

stop() ->
    unregister(mysql_conn),
    ok.

create_tables(Pid) ->
    % User table
    mysql:query(Pid, "CREATE TABLE IF NOT EXISTS users (
        id INT AUTO_INCREMENT PRIMARY KEY,
        username VARCHAR(255) UNIQUE,
        password VARCHAR(255)
    )"),

    % Room table
    mysql:query(
        Pid,
        "CREATE TABLE IF NOT EXISTS rooms (
\n"
        "        id INT AUTO_INCREMENT PRIMARY KEY,
\n"
        "        type ENUM('personal', 'group'),
\n"
        "        name VARCHAR(255)
\n"
        "    )"
    ),

    % Member table
    mysql:query(
        Pid,
        "CREATE TABLE IF NOT EXISTS members (
\n"
        "        id INT AUTO_INCREMENT PRIMARY KEY,
\n"
        "        room_id INT,
\n"
        "        user_id INT,
\n"
        "        FOREIGN KEY (room_id) REFERENCES rooms(id),
\n"
        "        FOREIGN KEY (user_id) REFERENCES users(id)
\n"
        "    )"
    ),

    % Message table
    mysql:query(Pid, "CREATE TABLE IF NOT EXISTS messages (
        id INT AUTO_INCREMENT PRIMARY KEY,
        content VARCHAR(255),
        created_at DATE,
        room_id INT,
        sender_id INT,
        FOREIGN KEY (room_id) REFERENCES rooms(id),
        FOREIGN KEY (sender_id) REFERENCES members(id)
    )"),
    ok.
