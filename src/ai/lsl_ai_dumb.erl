%%% @doc DumbAI for LSL.
%%%      Always crosses the first clean stick.
%%% @end
-module(lsl_ai_dumb).
-author('elbrujohalcon@inaka.net').

-behaviour(lsl_ai).

-export([play/1, name/0, next_move/1]).

%% @equiv lsl_ai:play(lsl_ai_dumb, Match).
-spec play(lsl_core:match()) -> {lsl_core:cross_result(), lsl_core:match()}.
play(Match) -> lsl_ai:play(?MODULE, Match).

%% @private
-spec name() -> binary().
name() -> <<"DumbAI">>.

%% @private
-spec next_move(lsl_core:match()) -> lsl_ai:move().
next_move(Match) ->
  Snapshot = lsl_core:snapshot(Match),
  next_move(1, 1, Snapshot).

next_move(_, _, []) -> throw(cant_move);
next_move(R, C, [[i|_] | _]) -> {R, C, 1};
next_move(R, _, [[x] | Rows]) -> next_move(R+1, 1, Rows);
next_move(R, C, [[x|Row] | Rows]) -> next_move(R, C+1, [Row|Rows]).
