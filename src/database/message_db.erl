-module(message_db).
-export([get_message/0, create_message_table/1, insert_message/3]).

create_message_table(Pid) ->
    mysql:query(
        Pid,
        "CREATE TABLE IF NOT EXISTS messages (
\n"
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
        "        content VARCHAR(255),
\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "        created_at DATE,
\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "        room_id INT,
\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "        sender_id INT,
\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "        FOREIGN KEY (room_id) REFERENCES rooms(id),
\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "        FOREIGN KEY (sender_id) REFERENCES members(id)
\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "\n"
        "    )"
    ).

get_message() ->
    case
        mysql:query(
            whereis(mysql_conn), "SELECT id, content, room_id, sender_id FROM messages"
        )
    of
        % Còn created_at đang chưa xử lý được

        {ok, _, Rows} ->
            [
                #{
                    id => Id,
                    content => Content,
                    % Chuyển đổi ngày giờ
                    % created_at => convert_datetime_to_string(CreatedAt),
                    room_id => RoomId,
                    sender_id => SenderId
                }
             || [Id, Content, RoomId, SenderId] <- Rows
            ];
        _ ->
            []
    end.

% Hàm chuyển đổi giá trị datetime từ MySQL (dưới dạng list byte) thành chuỗi "YYYY-MM-DD HH:MM:SS"
% convert_datetime_to_string({{Year, Month, Day}, {Hour, Minute, Second}}) ->
%     % Chuyển tuple thành chuỗi ngày giờ hợp lệ
%     io_lib:format("~4.4b-~2.2b-~2.2b ~2.2b:~2.2b:~2.2b", [Year, Month, Day, Hour, Minute, Second]);
% convert_datetime_to_string(_) ->
%     "Invalid date".

insert_message(Content, RoomId, SenderId) ->
    Pid = whereis(mysql_conn),

    % Câu query chèn tin nhắn vào bảng messages
    MessageQuery = io_lib:format(
        "INSERT INTO messages (content, created_at, room_id, sender_id) VALUES ('~s', NOW(), ~p, ~p)",
        [
            Content, RoomId, SenderId
        ]
    ),

    % Thực thi câu query chèn tin nhắn
    % Thực thi câu query chèn thành viên
    case mysql:query(Pid, MessageQuery) of
        Result ->
            % Thành công, trả về RoomId (giá trị đã lưu từ câu query trước đó)
            {ok, SenderId};
        {error, Reason} ->
            % Lỗi khi chèn thành viên
            {error, Reason}
    end.
