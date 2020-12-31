% 2020-HS Intro Bio Computers
% RA, 2020-12-30

%%

clear all;
close all;

m1 = sbioloadproject("Integrase0.sbproj").m1;

index_of = containers.Map();
for i = 1 : length(m1.Species)
	index_of(m1.Species(i).Name) = i;
end

%%

% Disable any events in the model
set(m1.Events, 'Active', 0)

m1.Species(index_of('wB_in')).InitialAmount = 10;
%m1.Species(index_of('s0_in')).InitialAmount = 0; % set by the loop
%m1.Species(index_of('r0_in')).InitialAmount = 0; % set by the loop

% Remove input
addevent(m1, "time >= 100", "wB_in = 0");
addevent(m1, "time >= 100", "s0_in = 0");
addevent(m1, "time >= 100", "r0_in = 0");

% Request output
addevent(m1, "time >= 200", "wA_in = 10");

% https://ch.mathworks.com/help/simbio/ref/sbiosimulate.html
% Set final time
T = 300;
set(getconfigset(m1, 'active'), 'Stoptime', T);

%%

aa = logspace(-2, 2, 19);
bb = logspace(-2, 2, 20);

A = "s0_in";
B = "r0_in";

responses = {};

for a = aa
	for b = bb
		m1.Species(index_of(A)).InitialAmount = a;
		m1.Species(index_of(B)).InitialAmount = b;
		[t, x] = sbiosimulate(m1);
		%[t, x] = sbiosteadystate(m1);
		% for R = convertCharsToStrings({m1.Species.name})
		assert(max(t) == T);
		for r = (1 : length(m1.Species))
			responses{r}(a == aa, b == bb) = x(end, r);
		end
	end
end

for R = ["s0", "c1"]
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
	
	filename = ['response_' str2mat(R) '.png'];
	saveas(gcf, filename);
	close all;
end
