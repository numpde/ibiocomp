% 2020-HS Intro Bio Computers
% RA, 2020-12-31
% RA, 2020-01-16

function response_d1_final
	close all;

	m1 = sbioloadproject("Bit1_d1.sbproj").m1;

	index_of = containers.Map();
	for i = (1 : length(m1.Species))
		index_of(m1.Species(i).Name) = i;
	end

	% Disable any events in the model
	set(m1.Events, 'Active', 0)

	A = "s1_in";
	aa = logspace(-2, 2, 15);
	B = "r1_in";
	bb = logspace(-2, 2, 16);
	C = "c1_in";
	cc = [0.1, 1, 10];

	m1.Species(index_of('wB_in')).InitialAmount = 10;
	%m1.Species(index_of(A)).InitialAmount = 0; % set by the loop
	%m1.Species(index_of(B)).InitialAmount = 0; % set by the loop

	% Remove input
	addevent(m1, "time >= 200", "wB_in = 0");
	addevent(m1, "time >= 200", "s1_in = 0");
	addevent(m1, "time >= 200", "r1_in = 0");
	addevent(m1, "time >= 200", "c1_in = 0");

	% Request output
	addevent(m1, "time >= 400", "wA_in = 10");

	% https://ch.mathworks.com/help/simbio/ref/sbiosimulate.html
	% Set final time
	T = 600;
	set(getconfigset(m1, 'active'), 'Stoptime', T);
	
	%%

	for c = cc

		responses = {};

		for a = aa
			for b = bb
				m1.Species(index_of(A)).InitialAmount = a;
				m1.Species(index_of(B)).InitialAmount = b;
				m1.Species(index_of(C)).InitialAmount = c;

				[t, x] = sbiosimulate(m1);
				assert(max(t) == T);
				for r = (1 : length(m1.Species))
					responses{r}(a == aa, b == bb) = x(end, r);
				end
			end
		end


		for R = ["d1"]
			figure;
			set(0, 'DefaultAxesFontSize', 14);
			set(gcf, 'renderer', 'Painters');
			
			surf(aa, bb, log10(responses{index_of(R)}'));
			xlabel(A, 'Interpreter', 'none');
			ylabel(B, 'Interpreter', 'none');
			
			%title(R);
			
			shading interp;
			view(0, 90);

			ax = gca;
			ax.XScale = 'log';
			ax.YScale = 'log';
			
			mima = @(arr) 10 .^ (floor(log10(min(arr))):ceil(log10(max(arr))));
			ax.XAxis.TickValues = mima(ax.XAxis.TickValues);
			ax.YAxis.TickValues = mima(ax.YAxis.TickValues);

			colormap(flipud(gray));
			cb = colorbar;
			cax = [-3, ceil(max(caxis))];
			caxis(cax);
			cb.Ticks = (cax(1):cax(2));
			TickLabels = arrayfun(@(x)(['10^{' num2str(x) '}']), cb.Ticks, 'UniformOutput', false);
			TickLabels(1) = {'...'};
			cb.TickLabels = TickLabels;
						
			grid on;

			filename = ['response_' str2mat(R) '_final' '__' str2mat(C) '=' num2str(c)];
			exportgraphics(gcf, [filename '.pdf']);
			exportgraphics(gcf, [filename '.png'], 'Resolution', 180);
			close all;
		end
	end

end
