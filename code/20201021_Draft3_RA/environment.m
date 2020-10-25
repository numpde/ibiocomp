% RA, 2020-10-17

function environment
	constants = load('shared_constants');
	
	STICKS = randi([0, 16], [1, 10]);

	player = Player;
	
	disp(['ENV: Waiting for Player to initalize.']);

	while (max([player.response1, player.response2, player.response3]) > constants.ALMOST_ZERO)
		player = player.process([constants.NO_INPUT, 0, 0, 0, 0]);
	end
	readout = interpret(player);
		
	assert(readout(1) == 0);
	disp(['ENV: Player is ready.']);
	
	history_envmnt = [];
	history_player = [];
	
	function checkpoint()
		history_envmnt = [history_envmnt; env_bits];
		history_player = [history_player; [player.response1, player.response2, player.response3]];
	end

	for sticks = STICKS
		disp(['===========']);
		disp(['ENV: There are now ' num2str(sticks) ' stick/s.']);

		env_bits = [0, 0, 0, 0, 0];
		
		checkpoint();
		
		% Cool down message
		env_bits(1) = constants.NO_INPUT;
		
		disp(['ENV: Waiting for Player to get ready.']);

		while (player.response1 > constants.ALMOST_ZERO)
			player = player.process(env_bits);
			checkpoint();
		end
		readout = interpret(player);
		
		assert(readout(1) == 0);
		
		disp(['ENV: Player is ready.']);

		% Signal new input
		env_bits = encode_to_bits(sticks);
		env_bits(1) = constants.ATTENTION;
		
		checkpoint();

		disp(['ENV: Sending stick status to player and waiting for the reponse.']);
		
		while (player.response1 < constants.ALMOST_ONE)
			player = player.process(env_bits);
			checkpoint();
		end
		readout = interpret(player);
		
		disp(['ENV: Player responded.']);

		player_took = readout(2) * 2 + readout(3);
		disp(['ENV: There were ' num2str(sticks) ' stick/s. Player TOOK ' num2str(player_took) ' STICK/S.']);
		
		assert(player_took == expected_move(sticks));

	end
	
	for i = (1 : 100)
		checkpoint()
	end

	imagesc([history_envmnt, history_player]);
end

function move = expected_move(sticks)
	% See  Take Leave
	%  15    2   13
	%  14    1   13
	%  13    1   12
	%  12    3    9
	%  11    2    9
	%  10    1    9
	%   9    1    8
	%   8    3    5 
	%   7    2    5
	%   6    1    5
	%   5    1    4
	%   4    3    1
	%   3    2    1
	%   2    1    1
	%   1    1    0
	%   0    0    0
	
	if (sticks == 0)
		move = 0;
	elseif (sticks > 15) 
		move = 0;
	else
		move = [1, 1, 2, 3,  1, 1, 2, 3,  1, 1, 2, 3,  1, 1, 2];
		assert(length(move) == 15);
		move = move(sticks);
	end
end

function bits = encode_to_bits(number)
	% Examples:
	% encode_to_bits(1) == [0, 0, 0, 0, 1]
	% encode_to_bits(2) == [0, 0, 0, 1, 0]
	% encode_to_bits(3) == [0, 0, 0, 1, 1]
	max_bits = 5;
	bits = dec2bin(number, 5) - '0';
	bits = bits((end - max_bits + 1) : end);
	assert(length(bits) == max_bits);
end

function [readout] = interpret(player)
	response = [player.response1, player.response2, player.response3];
	readout = round(response);
	disp(['ENV: Readout ' num2str(readout) ' (interpreted from ' num2str(response) ')']);
end