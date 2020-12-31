% 2020-HS Intro Bio Computers
% RA, 2020-12-31

function response
	clear all;
	close all;

	m1 = sbioloadproject("Bit1.sbproj").m1;

	index_of = containers.Map();
	for i = (1 : length(m1.Species))
		index_of(m1.Species(i).Name) = i;
	end

	% Disable any events in the model
	set(m1.Events, 'Active', 0)

	A = "s1_in";
	aa = logspace(-2, 2, 9);
	B = "r1_in";
	bb = logspace(-2, 2, 10);
	C = "c1_in";
	cc = [0, 10];

	m1.Species(index_of('wB_in')).InitialAmount = 10;
	%m1.Species(index_of(A)).InitialAmount = 0; % set by the loop
	%m1.Species(index_of(B)).InitialAmount = 0; % set by the loop

	% Remove input
	addevent(m1, "time >= 100", "wB_in = 0");
	addevent(m1, "time >= 100", "s1_in = 0");
	addevent(m1, "time >= 100", "r1_in = 0");
	addevent(m1, "time >= 100", "c1_in = 0");

	% Request output
	addevent(m1, "time >= 300", "wA_in = 10");

	% https://ch.mathworks.com/help/simbio/ref/sbiosimulate.html
	% Set final time
	T = 400;
	set(getconfigset(m1, 'active'), 'Stoptime', T);


	m1.Species(index_of(A)).InitialAmount = 10;
	m1.Species(index_of(B)).InitialAmount = 0;
	m1.Species(index_of(C)).InitialAmount = 0;

	[t, x] = sbiosimulate(m1);
	close all
	hold on
	spp = ["Y", "Xis", "Int", "P1_forw"];
	for sp = spp
		plot(t, x(:, index_of(sp)))
	end
	legend(spp, 'Interpreter', 'none')
	

	%%

	for c = cc

		responses = {};

		for a = aa
			for b = bb
				m1.Species(index_of(A)).InitialAmount = a;
				m1.Species(index_of(B)).InitialAmount = b;
				m1.Species(index_of(C)).InitialAmount = c;

				[t, x] = sbiosimulate(m1);
				%[t, x] = sbiosteadystate(m1);
				% for R = convertCharsToStrings({m1.Species.name})
				assert(max(t) == T);
				for r = (1 : length(m1.Species))
					responses{r}(a == aa, b == bb) = x(end, r);
				end
			end
		end


		for R = ["c2"]
			figure;
			surf(aa, bb, (responses{index_of(R)}'));
			xlabel(A, 'Interpreter', 'none');
			ylabel(B, 'Interpreter', 'none');
			%title(R);
			shading interp;
			view(0, 90);

			ax = gca;
			ax.XScale = 'log';
			ax.YScale = 'log';

			colormap(flipud(gray));
			colorbar;

			filename = ['response__' str2mat(R) '__' str2mat(C) '=' num2str(c) '.png'];
			saveas(gcf, filename);
			close all;
		end
	end

end
