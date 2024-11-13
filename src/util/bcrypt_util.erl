-module(bcrypt_util).
-export([hash_password/1]).

hash_password(Password) ->
    io:format("In hash"),
    {ok, Salt} = bcrypt:gen_salt(12),
    io:format("Salt: ~p~n", [Salt]),
    bcrypt:hashpw(Password, Salt).