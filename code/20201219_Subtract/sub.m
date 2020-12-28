% 2020-HS Intro Bio Computers
% RA, 2020-12-19
% RA, 2020-12-25

% Compute  d = s - r  bit by bit

function sub
	function print
		s = [s3 s2 s1 s0];
		r = [[0 0] r1 r0];
		d = [d3 d2 d1 d0];
		c = [c3 c2 c1 c0];
		disp(['b = ' num2str(s) ' = ' num2str(x2n(s))])
		disp(['r = ' num2str(r) ' = ' num2str(x2n(r))])
		disp(['d = ' num2str(d) ' = ' num2str(x2n(d))])
		disp(['c = ' num2str(c) ' = ' num2str(x2n(c))])
	end

	for n = 1:22
		d3 = 0; d2 = 0; d1 = 0; d0 = 0;
		c3 = 0; c2 = 0; c1 = 0; c0 = 0;
	
		s3 = (rand > 0.5);
		s2 = (rand > 0.5);
		s1 = (rand > 0.5);
		s0 = (rand > 0.5);
		r1 = (rand > 0.5);
		r0 = (rand > 0.5);
		
		disp('SUBTRACTING')
		print

		disp('Digit 0')
		d0 = (r0 && not(s0)) || (not(r0) && s0);
		c1 = (r0 && not(s0));
		print

		disp('Digit 1');
		d1 = (r1 && not(s1) && not(c1)) || (not(r1) && s1 && not(c1)) || (r1 && s1 && c1) || (not(r1) && not(s1) && c1);
		c2 = (r1 && not(s1)) || (c1 && not(s1)) || (r1 && c1);
		print

		disp('Digit 2');
		d2 = (c2 && not(s2)) || (not(c2) && s2);
		c3 = (c2 && not(s2));
		print

		disp('Digit 3');
		d3 = (c3 && not(s3)) || (not(c3) && s3);
		print
		
		disp('Result:')
		s = x2n(s);
		r = x2n(r);
		d = x2n(d);
		disp([num2str(s) ' - ' num2str(r) ' = ' num2str(d) ' (mod 16)'])
		assert(mod(s - r, 16) == d)
	end
end

function n = x2n(x)
	n = dot(x(1:4), [8, 4, 2, 1]);
end
