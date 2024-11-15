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
        id INT AUTO_INCREMENT PRIMARY KEY,
        username VARCHAR(255) UNIQUE,
        password VARCHAR(255)
    )"),

    % Room table
    mysql:query(Pid, "CREATE TABLE IF NOT EXISTS rooms (
        id INT AUTO_INCREMENT PRIMARY KEY,
        type ENUM('personal', 'group'),
        name VARCHAR(255)
    )"),

    % Member table
    mysql:query(Pid, "CREATE TABLE IF NOT EXISTS members (
        id INT AUTO_INCREMENT PRIMARY KEY,
        room_id INT,
        user_id INT,
        FOREIGN KEY (room_id) REFERENCES rooms(id),
        FOREIGN KEY (user_id) REFERENCES users(id)
    )"),

    % Message table
    mysql:query(Pid, "CREATE TABLE IF NOT EXISTS messages (
        id INT AUTO_INCREMENT PRIMARY KEY,
        content VARCHAR(255),
        created_at DATETIME,
        room_id INT,
        sender_id INT,
        FOREIGN KEY (room_id) REFERENCES rooms(id),
        FOREIGN KEY (sender_id) REFERENCES members(id)
    )"),

        % Relationship table
    mysql:query(Pid, "CREATE TABLE IF NOT EXISTS relationships (
        id INT AUTO_INCREMENT PRIMARY KEY,
        receiver_id INT,
        sender_id INT,
        relationship ENUM('pending', 'accepted') DEFAULT 'pending',
        FOREIGN KEY (receiver_id) REFERENCES users(id),
        FOREIGN KEY (sender_id) REFERENCES users(id),
        UNIQUE (sender_id, receiver_id),
        UNIQUE (receiver_id, sender_id)
    )"),
    ok.