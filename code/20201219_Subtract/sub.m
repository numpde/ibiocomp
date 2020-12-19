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
		b = logical(rand(1, 5) > 0.5);
		r = logical(rand(1, 5) > 0.5);

		c(1:5) = false;
		d(1:5) = false;
		
		disp('SUBTRACTING')
		print

		d(5) = xor(b(5), r(5));
		c(4) = r(5) > b(5);

		disp('Digit 5')
		print

		d(4) = (c(4) == (b(4) == r(4)));
		c(3) = (~c(4) && (r(4) > b(4))) || (c(4) && (r(4) >= b(4)));

		disp('Digit 4');
		print

		d(3) = (c(3) == (b(3) == r(3)));
		c(2) = (~c(3) && (r(3) > b(3))) || (c(3) && (r(3) >= b(3)));

		disp('Digit 3');
		print

		d(2) = (c(2) == (b(2) == r(2)));
		c(1) = (~c(2) && (r(2) > b(2))) || (c(2) && (r(2) >= b(2)));

		disp('Digit 2');
		print

		d(1) = (c(1) == (b(1) == r(1)));

		disp('Digit 1');
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
	n = dot(b(2:5), [8, 4, 2, 1]);
end
