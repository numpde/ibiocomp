% RA, 2020-10-25

function environment
	constants = load('shared_constants');
	
	player1 = Player1('X');
	player2 = Player2("Y");
	
	assert(isa(player1, 'handle'));
    % -> to check the datatype of player1
	assert(isa(player2, 'handle'));
	

	env_bits = [0, 0, 0, 0, 0];
	
	
	history_envment = [];
	history_player1 = [];
	history_player2 = [];
	
	function checkpoint(varargin)
        % -> varagin is used when the number of inputs is not fixed
		if (nargin == 0)
            % ->returns the number of function input arguments 
            % ->given in the call to the currently executing function. 
			varargin = 1;
		else
			varargin = varargin{1};
		end
		history_envment = [history_envment; varargin * env_bits];
		history_player1 = [history_player1; varargin * [player1.response1, player1.response2, player1.response3]];
		history_player2 = [history_player2; varargin * [player2.response1, player2.response2, player2.response3]];
	end

	checkpoint();	
		

	function player_took = ask(player, sticks)
		disp(['ENV: Waiting for player ' char(player.name) ' to initialize.']);
		
		checkpoint(nan);
		
		% Cool down message
		env_bits = 0 * env_bits;
		env_bits(1) = constants.NO_INPUT;
		checkpoint();
		%
		while (max([player.response1, player.response2, player.response3]) > constants.ALMOST_ZERO)
			player.process([constants.NO_INPUT, 0, 0, 0, 0]);
			checkpoint();
		end
		%
		readout = interpret(player);
		assert(readout(1) == 0);
		
		
		% Signal new input
		env_bits = encode_to_bits(sticks);
		env_bits(1) = constants.ATTENTION;
		checkpoint();
		%
		disp(['ENV: Sending stick status to player ' char(player.name) ' and waiting for the response.']);
		%
		while (player.response1 < constants.ALMOST_ONE)
			player.process(env_bits);
			checkpoint();
		end
		%
		readout = interpret(player);
		player_took = (readout(2) * 2) + readout(3);
		
		disp(['ENV: Player ' char(player.name) ' took ' num2str(player_took) ' / ' num2str(sticks) ' sticks.']);
		
		assert(player_took == expected_move(sticks));
	end
		
	
	
	sticks = 15;
	while 1
		took = ask(player1, sticks);
		sticks = sticks - took;
		if (sticks <= 0); break; end
		
		took = ask(player2, sticks);
		sticks = sticks - took;
		if (sticks <= 0); break; end
	end

	disp(['ENV: There are ' num2str(sticks) ' sticks left.']);
	
	
	for i = (1 : 33)
		checkpoint()
	end

	imagesc([history_envment, history_player1, history_player2]);
	colormap('gray');
	colorbar;
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
