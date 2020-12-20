% 2020-HS Intro Bio Computers
% RA, 2020-12-19

% Compute  d = b - r  bit by bit

function sub

	function print
		disp(['b = ' num2str(b) ' = ' num2str(b2n(b))])
		disp(['r = ' num2str(r) ' = ' num2str(b2n(r))])
		disp(['d = ' num2str(d) ' = ' num2str(b2n(d))])
		disp(['c = ' num2str(c) ' = ' num2str(b2n(c))])
	end

	for n = 1:22
		b = logical([0, rand(1, 4) > 0.5]);
		r = logical([0, 0, 0, rand(1, 2) > 0.5]);

		c(1:5) = false;
		d(1:5) = false;
		
		disp('SUBTRACTING')
		print

		disp('Digit 5')
		d(5) = xor(b(5), r(5));
		c(4) = r(5) > b(5);
		print

		disp('Digit 4');
		d(4) = (c(4) == (b(4) == r(4)));
		c(3) = (~c(4) && (r(4) > b(4))) || (c(4) && (r(4) >= b(4)));
		print

		disp('Digit 3');
		d(3) = (c(3) == (b(3) == r(3)));
		c(2) = (~c(3) && (r(3) > b(3))) || (c(3) && (r(3) >= b(3)));
		print

		disp('Digit 2');
		d(2) = (c(2) == (b(2) == r(2)));
		c(1) = (~c(2) && (r(2) > b(2))) || (c(2) && (r(2) >= b(2)));
		print
		
		% Don't need the first digit (there is no b1)

		disp('Digit 1');
		d(1) = (c(1) == (b(1) == r(1)));
		print
		
		disp('Result:')
		b = b2n(b);
		r = b2n(r);
		d = b2n(d);
		disp([num2str(b) ' - ' num2str(r) ' = ' num2str(d) ' (mod 32)'])
		assert(mod(b - r, 32) == d)
	end
end

function n = b2n(b)
	n = dot(b(1:5), [16, 8, 4, 2, 1]);
end
