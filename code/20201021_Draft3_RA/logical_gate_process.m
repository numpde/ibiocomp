function self = logical_gate_process(self, input)
    assert(length(input)==5)
    constants = load('shared_constants');
    b1 = input(1);
    if b1 > 0.5
        target(1) = 1;
        b2 = input(2);
        b3 = input(3);
        b4 = input(4);
        b5 = input(5);
        if b2 * b3 * b4 * b5 > 0
            %meaning that they cannot all be zero
            %   b4  b5  r2 r3
            %   0   1   0   1
            %   1   0   0   1
            %   0   0   1   1
            %   1   1   1   0
            target(2) = (b4 == b5);
            target(3) = 1 - (b4*b5);
        else
            disp('Player: I see no sticks');
        end
    else
        target(1) = (self.response2 > constants.ALMOST_ZERO) ...
            || (self.response3 > constants.ALMOST_ZERO);
        target(2) = 0;
        target(3) = 0;
        disp('Player: getting ready.');
        
        FAST = 0.2;
		SLOW = 0.1;
		self.response1 = (1 - SLOW) * self.response1 + SLOW * target(1);
		self.response2 = (1 - FAST) * self.response2 + FAST * target(2);
		self.response3 = (1 - FAST) * self.response3 + FAST * target(3); 
    end
    