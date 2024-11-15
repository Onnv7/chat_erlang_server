-module(room_db).
-export([insert_room/2, get_rooms/0, get_members/0, create_room_table/1, insert_room_and_member/3]).

create_room_table(Pid) ->
    mysql:query(
        Pid,
        "CREATE TABLE IF NOT EXISTS rooms (
\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "        id INT AUTO_INCREMENT PRIMARY KEY,
\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "        type ENUM('personal', 'group'),,
\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "        name VARCHAR(255)
\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "    )"
    ).

get_rooms() ->
    case mysql:query(whereis(mysql_conn), "SELECT id, type, name FROM rooms") of
        {ok, _, Rows} ->
            [
                #{id => Id, type => Type, name => Name}
             || [Id, Type, Name] <- Rows
            ];
        _ ->
            []
    end.

insert_room(Type, Name) ->
    Pid = whereis(mysql_conn),
    Query = io_lib:format("INSERT INTO rooms (type, name) VALUES ('~s', '~s')", [
        Type, Name
    ]),

    case mysql:query(Pid, Query) of
        Result ->
            {ok, Name};
        {error, Reason} ->
            {error, Reason}
    end.

get_members() ->
    case
        mysql:query(whereis(mysql_conn), "SELECT id as member_id, room_id, user_id FROM members")
    of
        {ok, _, Rows} ->
            [
                #{member_id => Id, room_id => Room_id, user_id => User_id}
             || [Id, Room_id, User_id] <- Rows
            ];
        _ ->
            []
    end.

insert_room_and_member(Type, Name, UserIds) ->
    Pid = whereis(mysql_conn),

    % Chèn phòng vào bảng rooms và lấy id phòng vừa tạo
    Query = io_lib:format(
        "INSERT INTO rooms (type, name) VALUES (~p, '~s'); SELECT LAST_INSERT_ID() AS id", [
            Type, Name
        ]
    ),

    % Thực thi câu query chèn phòng
    case mysql:query(Pid, Query) of
        {ok, _Result, [[RoomId]]} ->
            io:format("Room ID lấy được: ~p~n", [RoomId]),

            % Tạo chuỗi INSERT cho nhiều user_id
            Values = lists:map(
                fun(UserId) -> io_lib:format("(~p, ~p)", [RoomId, UserId]) end, UserIds
            ),

            % Kết hợp tất cả các giá trị vào một chuỗi
            ValuesString = string:join(lists:map(fun(X) -> lists:flatten(X) end, Values), ", "),

            % Câu query chèn nhiều thành viên vào bảng members
            MemberQuery = io_lib:format("INSERT INTO members (room_id, user_id) VALUES ~s", [
                ValuesString
            ]),

            % Thực thi câu query chèn thành viên
            case mysql:query(Pid, MemberQuery) of
                Result ->
                    % Thành công, trả về RoomId (giá trị đã lưu từ câu query trước đó)
                    {ok, RoomId};
                {error, Reason} ->
                    % Lỗi khi chèn thành viên
                    {error, Reason}
            end;
        % Trường hợp kết quả trả về không khớp
        _Other ->
            io:format("Unexpected result from query: ~p~n", [_Other]),
            {error, "Unexpected result format"}
    end.
