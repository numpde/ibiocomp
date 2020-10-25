% HH, 2020-10-25

classdef Player2 < handle
	properties
		% These are outward signals,
		% by convention between zero and one.
		response1
		response2
		response3
		
		name
	end
	
	methods
		function self = Player2(name)
			self.response1 = rand;
			self.response2 = rand;
			self.response3 = rand;
			
			self.name = name;
			
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
			
			% Input bits
			b1 = input(1);
			b2 = input(2);
			b3 = input(3);
			b4 = input(4);
			b5 = input(5);
			
            %   b4  b5  r2 r3
            %   0   1   0   1
            %   1   0   0   1
            %   0   0   1   1
            %   1   1   1   0
            
			if  b2*b3*b4*b5 > 0 && b1>0
                % make sure there are sticks
                r2 = (b4 == b5);
                r3 = 1 - (b4*b5);
            else
                r2 = 0;
                r3 = 0;
            end
            
			
			% Ready flag
			r1 = OR(b1, r2, r3);
			
			% Convention: the first output bit is a "ready" signal.
			% Make it slow so that the actual response
			% in output bits 2 and 3 has time to build up.
			
			FAST = 0.2;
			SLOW = 0.1;
			self.response1 = (1 - SLOW) * self.response1 + SLOW * r1;
			self.response2 = (1 - FAST) * self.response2 + FAST * r2;
			self.response3 = (1 - FAST) * self.response3 + FAST * r3;
		end
	end
end


function out = OR(varargin)
	out = any([varargin{:}]);
end

