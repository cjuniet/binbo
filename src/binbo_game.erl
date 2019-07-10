%% Copyright (c) 2019, Sergei Semichev <chessvegas@chessvegas.com>. All Rights Reserved.
%%
%% Licensed under the Apache License, Version 2.0 (the "License");
%% you may not use this file except in compliance with the License.
%% You may obtain a copy of the License at
%%
%%    http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing, software
%% distributed under the License is distributed on an "AS IS" BASIS,
%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%% See the License for the specific language governing permissions and
%% limitations under the License.

-module(binbo_game).

-export([new/1]).
-export([move/2]).
-export([status/1, draw/2]).
-export([pretty_board/2, get_fen/1]).

%%%------------------------------------------------------------------------------
%%%   Includes
%%%------------------------------------------------------------------------------

-include("binbo_move.hrl").

%%%------------------------------------------------------------------------------
%%%   Types
%%%------------------------------------------------------------------------------

-type parsed_fen() :: binbo_fen:parsed_fen().
-type bb_game() :: binbo_position:bb_game().
-type bb_game_error() :: binbo_position:bb_game_error().
-type game() :: undefined | bb_game().
-type game_fen() :: initial | binbo_fen:fen().
-type game_status() :: binbo_position:game_status().
-type sq_move() :: binbo_move:sq_move().
-type move_info() :: binbo_move:move_info().
-type bad_game_term() :: {bad_game, term()}.
-type init_error() :: binbo_fen:fen_error() | bb_game_error().
-type move_error() :: bad_game_term() | binbo_move:move_error().
-type draw_error() :: {already_has_status, binbo_position:game_over_status()} | bad_game_term().
-type pretty_board_error() :: bad_game_term() | {bad_options, term()}.
-type status_ret() :: {ok, game_status()} | {error, bad_game_term()}.
-type get_fen_ret() :: {ok, binary()} | {error, bad_game_term()}.

-export_type([game/0, game_fen/0]).
-export_type([game_status/0, status_ret/0, get_fen_ret/0]).
-export_type([init_error/0, move_error/0, draw_error/0]).
-export_type([pretty_board_error/0]).

%%%------------------------------------------------------------------------------
%%%   API
%%%------------------------------------------------------------------------------

%% new/1
-spec new(game_fen()) -> {ok, {bb_game(), game_status()}} | {error, init_error()}.
new(initial) ->
	new(binbo_fen:initial());
new(Fen) ->
	case binbo_fen:parse(Fen) of
		{ok, ParsedFen} ->
			init_game(ParsedFen);
		Error ->
			Error
	end.

%% move/2
-spec move(sq_move(), game()) -> {ok, {bb_game(), game_status()}} | {error, move_error()}.
move(Move, Game) ->
	case erlang:is_map(Game) of
		true  -> move(sq, Move, Game);
		false -> {error, {bad_game, Game}}
	end.

%% pretty_board/2
-spec pretty_board(game(), binbo_position:pretty_board_opts()) -> {ok, {iolist(), binbo_position:game_status()}} | {error, pretty_board_error()}.
pretty_board(Game, Opts) when is_map(Game), is_list(Opts) ->
	{ok, binbo_position:pretty_board(Game, Opts)};
pretty_board(Game, Opts) when is_list(Opts) ->
	{error, {bad_game, Game}};
pretty_board(_, Opts) ->
	{error, {bad_options, Opts}}.

%% status/1
-spec status(game()) -> status_ret().
status(Game) ->
	case erlang:is_map(Game) of
		true  -> {ok, binbo_position:get_status(Game)};
		false -> {error, {bad_game, Game}}
	end.

%% draw/2
-spec draw(term(), game()) ->  {ok, bb_game()} | {error, draw_error()}.
draw(Reason, Game) when is_map(Game) ->
	Status = binbo_position:get_status(Game),
	case binbo_position:is_status_inprogress(Status) of
		true  -> {ok, binbo_position:manual_draw(Reason, Game)};
		false -> {error, {already_has_status, Status}}
	end;
draw(_Reason, Game) ->
	{error, {bad_game, Game}}.

%% get_fen/1
-spec get_fen(game()) -> get_fen_ret().
get_fen(Game) ->
	case erlang:is_map(Game) of
		true  -> {ok, binbo_position:get_fen(Game)};
		false -> {error, {bad_game, Game}}
	end.

%%%------------------------------------------------------------------------------
%%%   Internal functions
%%%------------------------------------------------------------------------------

%% init_game/1
-spec init_game(parsed_fen()) -> {ok, {bb_game(), game_status()}} | {error, bb_game_error()}.
init_game(ParsedFen) ->
	Game = binbo_position:init_bb_game(ParsedFen),
	case binbo_position:validate_loaded_fen(Game) of
		ok ->
			{ok, finalize_fen(Game)};
		{error, _} = Error ->
			Error
	end.

%% finalize_fen/1
-spec finalize_fen(bb_game()) -> {bb_game(), game_status()}.
finalize_fen(Game0) ->
	SideToMove = binbo_position:get_sidetomove(Game0),
	HasValidMoves = binbo_movegen:has_valid_moves(SideToMove, Game0),
	IsCheck = binbo_position:is_in_check(SideToMove, Game0),
	Game = binbo_position:with_status(Game0, HasValidMoves, IsCheck),
	Status = binbo_position:get_status(Game),
	{Game, Status}.


%% move/3
-spec move(sq, sq_move(), bb_game()) -> {ok, {bb_game(), game_status()}} | {error, binbo_move:move_error()}.
move(sq, Move, Game) ->
	case binbo_move:validate_sq_move(Move, Game) of
		{ok, MoveInfo, Game2} ->
			{ok, finalize_move(MoveInfo, Game2)};
		{error, _} = Error ->
			Error
	end.

%% finalize_move/2
-spec finalize_move(move_info(), bb_game()) -> {bb_game(), game_status()}.
finalize_move(MoveInfo, Game0) ->
	EnemyColor = binbo_move:enemy_color(MoveInfo),
	HasValidMoves = binbo_movegen:has_valid_moves(EnemyColor, Game0),
	IsCheck = binbo_position:is_in_check(EnemyColor, Game0),
	MoveInfo2 = MoveInfo#move_info{
		is_check = IsCheck,
		has_valid_moves = HasValidMoves
	},
	Game = binbo_position:finalize_move(MoveInfo2, Game0),
	Status = binbo_position:get_status(Game),
	{Game, Status}.