% RA, 2020-10-17

function environment
	shared_constants;
	
	STICKS = randi([0, 16], [1, 10]);

	player = Player;
	
	disp(['ENV: Waiting for Player to initalize.']);

	while (max([player.response1, player.response2, player.response3]) > ALMOST_ZERO)
		player = player.process([NO_INPUT, 0, 0, 0, 0]);
	end
	readout = interpret(player);
		
	assert(readout(1) == 0);
	disp(['ENV: Player is ready.']);
	
		
	for sticks = STICKS
		disp(['===========']);
		disp(['ENV: There are now ' num2str(sticks) ' stick/s.']);

		bits = [0, 0, 0, 0, 0];

		% Cool down
		bits(1) = NO_INPUT;
		
		disp(['ENV: Waiting for Player to get ready.']);

		while (player.response1 > ALMOST_ZERO)
			player = player.process(bits);
		end
		readout = interpret(player);
		
		assert(readout(1) == 0);
		
		disp(['ENV: Player is ready.']);

		% Signal new input
		bits = to_bits(sticks);
		bits(1) = ATTENTION;

		disp(['ENV: Sending stick status to player and waiting for the reponse.']);
		
		while (player.response1 < ALMOST_ONE)
			player = player.process(bits);
		end
		readout = interpret(player);
		
		disp(['ENV: Player responded.']);

		player_took = readout(2) * 2 + readout(3);
		disp(['ENV: There were ' num2str(sticks) ' stick/s. Player TOOK ' num2str(player_took) ' STICK/S.']);

% 		% Cool down
% 		bits(1) = NO_INPUT;
% 
% 		while (player.response1 > ALMOST_ZERO)
% 			player = player.process(bits);
% 		end
% 		interpret(player);
	
	end
end

function bits = to_bits(number)
	bits = dec2bin(number, 5) - '0';
end

function [readout] = interpret(player)
	response = [player.response1, player.response2, player.response3];
	readout = round(response);
	disp(['ENV: Readout ' num2str(readout) ' (interpreted from ' num2str(response) ')']);
end
