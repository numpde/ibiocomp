% 2020-HS Intro Bio Computers
% RA, 2020-12-19
% RA, 2020-12-25

% Compute  d = b - r  bit by bit

function sub
	function print
		b = [b3 b2 b1 b0];
		r = [[0 0] r1 r0];
		d = [d3 d2 d1 d0];
		c = [c3 c2 c1 c0];
		disp(['b = ' num2str(b) ' = ' num2str(b2n(b))])
		disp(['r = ' num2str(r) ' = ' num2str(b2n(r))])
		disp(['d = ' num2str(d) ' = ' num2str(b2n(d))])
		disp(['c = ' num2str(c) ' = ' num2str(b2n(c))])
	end

	for n = 1:22
		d3 = 0; d2 = 0; d1 = 0; d0 = 0;
		c3 = 0; c2 = 0; c1 = 0; c0 = 0;
	
		b3 = (rand > 0.5);
		b2 = (rand > 0.5);
		b1 = (rand > 0.5);
		b0 = (rand > 0.5);
		r1 = (rand > 0.5);
		r0 = (rand > 0.5);
		
		disp('SUBTRACTING')
		print

		disp('Digit 0')
		d0 = (r0 == not(b0));
		c1 = (r0 && not(b0));
		print

		disp('Digit 1');
		d1 = ((r1 == not(b1)) ~= c1);
		c2 = (r1 && not(b1)) || (c1 && not(b1)) || (r1 && c1);
		print

		disp('Digit 2');
		d2 = (c2 == not(b2));
		c3 = (c2 && not(b2));
		print

		disp('Digit 3');
		d3 = (c3 == not(b3));
		print
		
		disp('Result:')
		b = b2n(b);
		r = b2n(r);
		d = b2n(d);
		disp([num2str(b) ' - ' num2str(r) ' = ' num2str(d) ' (mod 16)'])
		assert(mod(b - r, 16) == d)
	end
end

function n = b2n(b)
	n = dot(b(1:4), [8, 4, 2, 1]);
end
