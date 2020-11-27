% 2020-HS Intro Bio Computers
% RA, 2020-11-26

close all;

m1 = sbioloadproject("0x0E.sbproj").m1;

index_of = containers.Map();
for i = 1 : length(m1.Species)
	index_of(m1.Species(i).Name) = i;
end

m1.Species(index_of('Ara')).InitialAmount = 10;


aa = linspace(0, 20, 9);
bb = linspace(0, 20, 10);

A = "IPTG";
B = "aTc";

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
		disp([a, b, t(end)]);
	end
end

for R = ["PhlF", "BetI", "YFP", "AmtR"]
	figure;
	surf(aa, bb, responses{index_of(R)}');
	xlabel(A);
	ylabel(B);
	title(R);
end
