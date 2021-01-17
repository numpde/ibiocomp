% 2020-HS Intro Bio Computers
% RA, 2020-12-17

clear all;
close all;

m1 = sbioloadproject("PlayerA.sbproj").m1;

index_of = containers.Map();
for i = 1 : length(m1.Species)
	index_of(m1.Species(i).Name) = i;
end

m1.Species(index_of('wA_in')).InitialAmount = 1;


aa = logspace(-2, 2, 9);
bb = logspace(-2, 2, 10);

A = "s0_in";
B = "s1_in";

responses = {};

for a = aa
	for b = bb
		m1.Species(index_of(A)).InitialAmount = a;
		m1.Species(index_of(B)).InitialAmount = b;
		[t, x] = sbiosimulate(m1);
		% for R = convertCharsToStrings({m1.Species.name})
		for r = (1 : length(m1.Species))
			responses{r}(a == aa, b == bb) = x(end, r);
		end
	end
end

for R = ["r0", "r1"]
	figure;
	surf(aa, bb, responses{index_of(R)}');
	xlabel(A);
	ylabel(B);
	title(R);
	
	ax = gca;
	ax.XScale = 'log';
	ax.YScale = 'log';
end
