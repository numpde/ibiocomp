% RA, 2020-10-17

classdef Player
	properties
		% These are outward signals,
		% by convention between zero and one.
		response1
		response2
		response3
	end
	
	methods
		function self = Player()
			self.response1 = rand;
			self.response2 = rand;
			self.response3 = rand;
			
			% There could be a problem if 
			% self.response1 is initially almost zero.
			%
			% This may be interpreted as "ready".
			%
			% Therefore, the environment has to make sure first
			% that all response bits are zero.
		end
		
		function self = process(self, input)
			assert(length(input) == 5)
			constants = load('shared_constants');
			
			b1 = input(1);
			
			if (b1 > 0.5)
				% This means I need to build a response.
			
				% Input bits
				b2 = input(2);
				b3 = input(3);
				b4 = input(4);
				b5 = input(5);

				% The variable `sticks` here is only for development;
				% later use only the bits without assembling `sticks`.
				
				sticks = (b2 * 8) + (b3 * 4) + (b4 * 2) + (b5 * 1);
				disp(['Player: I see ' num2str(sticks) ' sticks.']);

				if (sticks < 0.6)
					% Assume zero sticks
					target = [1, [0, 0]];
					disp('Player: I see no sticks.');
				elseif (15.4 <= sticks)
					% Assume over 15 sticks
					target = [1, [0, 0]];
					disp('Player: too many sticks.');
				else
					% Try to leave 1, 5, 9, 13 sticks
					sticks = round(sticks);
					
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

					while sticks > 4
						sticks = sticks - 4;
					end
					
					% At this point, we can't have "no sticks".
					assert((1 <= sticks) && (sticks <= 4))
					
					if (sticks == 1)
						% No choice but to take
						target = [1, [0, 1]];
					elseif (sticks == 2)
						% Take 1
						target = [1, [0, 1]];
					elseif (sticks == 3)
						% Take 2
						target = [1, [1, 0]];
					elseif (sticks == 4)
						% Take 3
						target = [1, [1, 1]];
					else
						disp('SOMETHING IS WRONG.');
					end
					
					
					% The above loop and logic can be streamlined:
					%	if (b4 == 0) && (b5 == 0) 
					%		% Take 3
					%	else
					%		% sticks == (b4 * 2) + (b5 * 1)
					%		% ...
					%	end
				end

			else
				% This means my response has been read.
				% I need to turn it off.
				
				disp('Player: getting ready.');
				
				% Need to wait until those are zero
				% because they will switch on faster 
				% than target1 when returning an answer.
				target1 = (self.response2 > constants.ALMOST_ZERO) || (self.response3 > constants.ALMOST_ZERO);
				
				target = [target1, [0, 0]];
			end
			
			% Convention: the first output bit is a "ready" signal.
			% Make it slow so that the actual response
			% in output bits 2 and 3 has time to build up.
			
			FAST = 0.2;
			SLOW = 0.1;
			self.response1 = (1 - SLOW) * self.response1 + SLOW * target(1);
			self.response2 = (1 - FAST) * self.response2 + FAST * target(2);
			self.response3 = (1 - FAST) * self.response3 + FAST * target(3);
		end
	end
end
