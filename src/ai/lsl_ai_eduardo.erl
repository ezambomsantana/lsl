%%% @doc Eduardo AI for LSL.
%%% @end
-module(lsl_ai_eduardo).
-author('eduardo_santana').

-behaviour(lsl_ai).

-export([play/1, name/0, next_move/1]).

%% @equiv lsl_ai:play(lsl_ai_dumb, Match).
-spec play(lsl_core:match()) -> {lsl_core:cross_result(), lsl_core:match()}.
play(Match) -> lsl_ai:play(?MODULE, Match).

%% @private
-spec name() -> binary().
name() -> <<"Eduardo">>.


% I just changed to shown that I understood the code, I didn't have a better solution

%% @private
-spec next_move(lsl_core:match()) -> lsl_ai:move().
next_move(Match) ->
  Snapshot = lsl_core:snapshot(Match),
  case parse(Snapshot) of
    % No groups => cross stick
    % I didn't change
    {[Stick|_], []} -> cross(Stick); % the second part is empty
    % One group, even sticks => turn group into stick
    % I didn't change
    {Sticks, [Group]} when length(Sticks) rem 2 =:= 0 -> leave_one(Group); %just one group
    % One group, odd sticks => remove group
    % I didn't change
    {_Sticks, [Group]} -> cross(Group); 
    % Odd groups => cross smallest one
    % before crossed the entire group, now I leave one stick
    {_Sticks, [Group|Groups]} when length(Groups) rem 2 =:= 0 -> leave_one(Group);
    % Even groups, no sticks => reduce largest one
    % before remove just one from the biggest group, now I leave just one stick
    {[], Groups} -> leave_one(hd(lists:reverse(Groups))); % no length 1, remove 1 from the largest group
    % Even groups, at least one stick => cross stick
    %I didn't change
    {[Stick|_Sticks], _Groups} -> cross(Stick)
  end.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% INTERNAL FUNCTIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%return a list of groups, ordered by the length of the groups.
% also, it divides the list with all the groups with just one stick and the groups biggers than one size.

parse(Snapshot) ->
  parse(Snapshot, 1, 1, 0, []).

parse([], _Row, _Col, _Length, Moves) ->
  SortedMoves = lists:keysort(3, lists:sort(Moves)),
  lists:splitwith(fun({_, _, Length}) -> Length == 1 end, SortedMoves);
parse([[] | Rows], Row, _Col, 0, Moves) ->
  parse(Rows, Row + 1, 1, 0, Moves);
parse([[] | Rows], Row, Col, Length, Moves) ->
  parse(Rows, Row + 1, 1, 0, [{Row, Col, Length} | Moves]);
parse([[x | Cells] | Rows], Row, Col, 0, Moves) ->
  parse([Cells|Rows], Row, Col + 1, 0, Moves);
parse([[x | Cells] | Rows], Row, Col, Length, Moves) ->
  parse([Cells|Rows], Row, Col + Length, 0, [{Row, Col, Length} | Moves]);
parse([[i | Cells] | Rows], Row, Col, Length, Moves) ->
  parse([Cells|Rows], Row, Col, Length + 1, Moves).

cross(Move) -> Move.

leave_one({Row, Col, Length}) -> {Row, Col, Length - 1}.

reduce({Row, Col, _Length}) -> {Row, Col, 1}.
