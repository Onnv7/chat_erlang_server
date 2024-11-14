-module(jwt_util).
-export([create_token/1, verify_token/1]).

create_token(Expires) ->
    Secret = <<"your_secret_key">>,

    Claims = [{exp, Expires}, {name, <<"bob">>}],

    Jwt = jwerl:sign(Claims, hs256, Secret),

    Jwt.

verify_token(Token) ->
    %% Define the secret key for verifying the token
    Secret = <<"your_secret_key">>,

    %% Verify the JWT
    case jwerl:verify(Token, hs256, Secret) of
        {ok, Claims} ->
            {ok, Claims};
        {error, Reason} ->
            {error, Reason}
    end.