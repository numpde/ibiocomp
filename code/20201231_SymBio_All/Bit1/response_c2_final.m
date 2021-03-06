% 2020-HS Intro Bio Computers
% RA, 2020-12-31
% RA, 2021-01-16

function response_c2_final
	close all;

	m1 = sbioloadproject("Bit1_c2.sbproj").m1;

	index_of = containers.Map();
	for i = (1 : length(m1.Species))
		index_of(m1.Species(i).Name) = i;
	end

	% Disable any events in the model
	set(m1.Events, 'Active', 0)

	A = 's1_in'; A_label = ['# ' A(1:2)];
	aa = logspace(-2, 2, 19);
	B = 'r1_in'; B_label = ['# ' B(1:2)];
	bb = logspace(-2, 2, 20);
	C = 'c1_in'; C_label = ['# ' C(1:2)];
	cc = [0.01, 0.1, 1, 10, 100];
	
	
	for CrossInh = [1, 0]
		m1.Rules({m1.Rules.Name} == "make_A*").Active = CrossInh;
		m1.Rules({m1.Rules.Name} == "make_B*").Active = CrossInh;
		
		% c2 does not depend on wA/wB
		%m1.Species(index_of('wA_in')).InitialAmount = 0;
		%m1.Species(index_of('wB_in')).InitialAmount = 0;

		% https://ch.mathworks.com/help/simbio/ref/sbiosimulate.html
		% Set final time
		T = 400;
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
					%[t, x] = sbiosteadystate(m1);
					% for R = convertCharsToStrings({m1.Species.name})
					assert(max(t) == T);
					for r = (1 : length(m1.Species))
						responses{r}(a == aa, b == bb) = x(end, r);
					end
				end
			end


			for R = ["c2"]
				close all;

				figure;
				set(0, 'DefaultAxesFontSize', 16);
				set(gcf, 'renderer', 'Painters');

				v = linspace(-3, 1, 21);
				[CM, Ch] = contourf(aa, bb, log10(abs(responses{index_of(R)}')), v, '-y', 'LineWidth', 0.3);
				clabel(CM, Ch, v(end-1:-7:1), 'FontSize', 7, 'Color', 'r')

				xlabel(A_label, 'Interpreter', 'none');
				ylabel(B_label, 'Interpreter', 'none');

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

				grid off;

				filename = ['response_' str2mat(R) '_final' '__CI=' num2str(CrossInh) '__' str2mat(C) '=' num2str(c)];
				exportgraphics(gcf, ['output/' filename '.pdf']);
				exportgraphics(gcf, ['output/' filename '.png'], 'Resolution', 180);
			end
		end
	end
end
