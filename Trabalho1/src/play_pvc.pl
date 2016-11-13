/* PLAY MODE PVC */

/* PLAYER */
play_pvc(Player, Board, Difficulty) :-
	
	write('Player'), write(Player), nl,
	(Player=:=1 ->
		(read_position_from(Player, Board, InitialColumn, InitialLine, JumpMoves, AdjoinMoves, CenterMoves),
		read_position_to(Player, Board, FinalColumn, FinalLine, JumpMoves, AdjoinMoves, CenterMoves, Move));
		(sleep(1),
		random_position_from(Player, Board, InitialColumn, InitialLine, JumpMoves, AdjoinMoves, CenterMoves, Difficulty),
		
		random_position_to(Player, Board, FinalColumn, FinalLine, JumpMoves, AdjoinMoves, CenterMoves, Move, Difficulty))),
	
	Other is ((Player mod 2) + 1),
	move(Board, NewBoard, InitialColumn, InitialLine, FinalColumn, FinalLine),

	% Adjoining move -> player plays again
	((Move=='adjoin') ->
		(print_board(10, NewBoard), nl,
		(member2d(Other, NewBoard) ->
			(member2d(Player, NewBoard) ->
				play_pvc(Player, NewBoard, Difficulty);
				(write('Player'), write(Other), write(' won!'), nl));
			(write('Player'), write(Player), write(' won!'), nl)));
	
	% Centering move -> player passes the turn
	((Move=='center') ->
		(print_board(10, NewBoard), nl,
		(member2d(Other, NewBoard) ->
			(member2d(Player, NewBoard) ->
				play_pvc(Other, NewBoard, Difficulty);
				(write('Player'), write(Other), write(' won!'), nl));
			(write('Player'), write(Player), write(' won!'), nl)));
	
	% Jumping move -> player passes the turn if the selected piece can't jump again
	((Move=='jump') ->
		(DeltaLine is FinalLine-InitialLine,
		DeltaColumn is FinalColumn-InitialColumn,
		JumpLine is FinalLine+DeltaLine,
		JumpColumn is FinalColumn+DeltaColumn,
		move(NewBoard, JumpBoard, FinalColumn, FinalLine, JumpColumn, JumpLine),
		print_board(10, JumpBoard), nl,
		(member2d(Other, JumpBoard) ->
			(member2d(Player, JumpBoard) ->			
				(get_jump_positions(Player, JumpBoard, JumpColumn, JumpLine, DoubleJumpMoves),
				((DoubleJumpMoves == []) ->
					play_pvc(Other, JumpBoard, Difficulty);
					play_pvc_jump(Player, JumpBoard, JumpColumn, JumpLine, DoubleJumpMoves, Difficulty)));
				(write('Player'), write(Other), write(' won!'), nl));
			(write('Player'), write(Player), write(' won!'), nl)))))).


play_pvc_jump(Player, Board, InitialColumn, InitialLine, JumpMoves, Difficulty) :-
	write('Player'), write(Player), nl,
	(Player=:=1 ->
		read_position_to(Player, Board, FinalColumn, FinalLine, JumpMoves, [], [], Move);
		random_position_to(Player, Board, FinalColumn, FinalLine, JumpMoves, [], [], Move, Difficulty)),
	Other is ((Player mod 2) + 1),
	move(Board, NewBoard, InitialColumn, InitialLine, FinalColumn, FinalLine),
	DeltaLine is FinalLine-InitialLine,
	DeltaColumn is FinalColumn-InitialColumn,
	JumpLine is FinalLine+DeltaLine,
	JumpColumn is FinalColumn+DeltaColumn,
	move(NewBoard, JumpBoard, FinalColumn, FinalLine, JumpColumn, JumpLine),
	print_board(10, JumpBoard), nl,
	(member2d(Other, JumpBoard) ->
		(member2d(Player, JumpBoard) ->		
				(get_jump_positions(Player, JumpBoard, JumpColumn, JumpLine, DoubleJumpMoves),
				((DoubleJumpMoves == []) ->
					play_pvc(Other, JumpBoard, Difficulty);
					play_pvc_jump(Player, JumpBoard, JumpColumn, JumpLine, DoubleJumpMoves, Difficulty)));
				(write('Player'), write(Other), write(' won!'), nl));
		(write('Player'), write(Player), write(' won!'), nl)).


















