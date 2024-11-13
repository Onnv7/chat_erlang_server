-module(auth_middleware).
-behaviour(cowboy_middleware).

-export([execute/2]).

% Khởi tạo middleware (thường không có logic gì ở đây)


% Xử lý request để kiểm tra JWT
execute(Req, Env) ->
    io:format("In auth middleware~n"),
    Req.

% Kết thúc middleware
