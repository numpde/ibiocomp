% 2020-HS Intro Bio Computers
% RA, 2020-12-30
% RA, 2021-01-18

function response_final
	close all;

	m1 = sbioloadproject("Bit0.sbproj").m1;

	index_of = containers.Map();
	for i = (1 : length(m1.Species))
		index_of(m1.Species(i).Name) = i;
	end

	% Disable any events in the model
	set(m1.Events, 'Active', 0)

	A = 's0_in'; A_label = ['# ' A(1:2)];
	aa = logspace(-2, 2, 19);
	B = 'r0_in'; B_label = ['# ' B(1:2)];
	bb = logspace(-2, 2, 20);

	m1.Species(index_of('wA_in')).InitialAmount = 0.01;
	m1.Species(index_of('wB_in')).InitialAmount = 10;

	% Remove input
	addevent(m1, "time >= 200", "wB_in = 0");
	addevent(m1, "time >= 200", "s0_in = 0");
	addevent(m1, "time >= 200", "r0_in = 0");

	% Request output
	addevent(m1, "time >= 400", "wA_in = 10");

	% https://ch.mathworks.com/help/simbio/ref/sbiosimulate.html
	% Set final time
	T = 600;
	set(getconfigset(m1, 'active'), 'Stoptime', T);
	
	%%

	responses = {};

	for a = aa
		for b = bb
			m1.Species(index_of(A)).InitialAmount = a;
			m1.Species(index_of(B)).InitialAmount = b;

			[t, x] = sbiosimulate(m1);
			assert(max(t) == T);
			for r = (1 : length(m1.Species))
				responses{r}(a == aa, b == bb) = x(end, r);
			end
		end
	end


	for R = ["d0", "c1"]
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

		filename = ['response_' str2mat(R) '_final'];
		exportgraphics(gcf, ['output/' filename '.pdf']);
		exportgraphics(gcf, ['output/' filename '.png'], 'Resolution', 180);
	end

end
