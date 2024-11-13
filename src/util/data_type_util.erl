-module(data_type_util).
-export([print_type/1]).

print_type(Var) ->
    Type = case Var of
        _ when is_integer(Var) -> "Integer";
        _ when is_float(Var) -> "Float";
        _ when is_atom(Var) -> "Atom";
        _ when is_list(Var) -> "List";
        _ when is_binary(Var) -> "Binary";
        _ when is_tuple(Var) -> "Tuple";
        _ when is_map(Var) -> "Map";
        _ -> "Unknown"
    end,
    io:format("Type: ~s~n", [Type]).
