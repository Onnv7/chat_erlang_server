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
    mysql:query(Pid, Query).

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

% insert_room_and_member(Type, Name, UserId) ->
%     Pid = whereis(mysql_conn),

%     % Chèn phòng vào bảng rooms
%     Query = io_lib:format(
%         "INSERT INTO rooms (type, name) VALUES (~p, '~s'); SELECT LAST_INSERT_ID() AS id", [
%             Type, Name
%         ]
%     ),

%     % In ra câu query trước khi thực thi
%     % io:format("Executing query: ~s~n", [Query]),
%     % Data = mysql:query(Pid, Query),
%     % io:format("Data ~w", [Data]),
%     case mysql:query(Pid, Query) of
%         % Match với kiểu dữ liệu trả về
%         % {ok, _BinaryData, [[RoomId]]} ->
%         %     % for(userId: userIdList) {
%         %     insert(userId, RoomId)
%         % }

%             io:format("Room ID lấy được: ~p~n", [RoomId]),

%             % Thực hiện chèn thành viên vào bảng members
%             MemberQuery = io_lib:format("INSERT INTO members (room_id, user_id) VALUES (~p, ~p)", [
%                 RoomId, UserId
%             ]),
%             case mysql:query(Pid, MemberQuery) of
%                 {ok, _} -> {ok, RoomId};
%                 {error, Reason} -> {error, Reason}
%             end;
%         {error, Reason} ->
%             {error, Reason}
%     end.

insert_room_and_member(Type, Name, UserId) ->
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

            % Thực hiện chèn thành viên vào bảng members
            MemberQuery = io_lib:format("INSERT INTO members (room_id, user_id) VALUES (~p, ~p)", [
                RoomId, UserId
            ]),

            % Thực thi câu query chèn thành viên
            case mysql:query(Pid, MemberQuery) of
                Result ->
                    % Thành công
                    io:format("Successfully inserted member into room ~p~n", [RoomId]),
                    {ok, RoomId};
                {error, Reason} ->
                    io:format("Error inserting member: ~p~n", [Reason]),
                    % Lỗi khi chèn thành viên
                    {error, Reason}
            end;
        % Trường hợp kết quả trả về không khớp
        {ok, _Result, _} ->
            io:format("Unexpected result format from query: ~p~n", [_Result]),
            {error, "Unexpected result format"};
        % Trường hợp khác (ví dụ: lỗi khi kết nối, hoặc không thể thực hiện truy vấn)
        {error, Reason} ->
            io:format("Error during query execution: ~p~n", [Reason]),
            {error, Reason}
    end.
