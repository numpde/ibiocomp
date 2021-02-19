% 2020-HS Intro Bio Computers
% RA, 2020-12-31
% RA, 2021-01-16

function response_d1_temporal
	close all;

	m1 = sbioloadproject("Bit1_d1.sbproj").m1;

	index_of = containers.Map();
	for i = (1 : length(m1.Species))
		index_of(m1.Species(i).Name) = i;
	end

	% Disable any events in the model
	set(m1.Events, 'Active', 0)

	A = "s1_in";
	B = "r1_in";
	C = "c1_in";

	m1.Species(index_of('wA_in')).InitialAmount = 0;
	m1.Species(index_of('wB_in')).InitialAmount = 0;
	m1.Species(index_of(A)).InitialAmount = 0;
	m1.Species(index_of(B)).InitialAmount = 0;
	m1.Species(index_of(C)).InitialAmount = 0;
	
	% Set input
	addevent(m1, "time >= 250", "wB_in = 15");
	addevent(m1, "time >= 250", "s1_in = 10");
	addevent(m1, "time >= 250", "r1_in = 10");
	addevent(m1, "time >= 250", "c1_in = 10");

	% Remove input
	addevent(m1, "time >= 500", "wB_in = 0.01");
	addevent(m1, "time >= 500", "s1_in = 0.01");
	addevent(m1, "time >= 500", "r1_in = 0.01");
	addevent(m1, "time >= 500", "c1_in = 0.01");

	% Request output
	addevent(m1, "time >= 750", "wA_in = 15");
	addevent(m1, "time >= 1000", "wA_in = 0.01");
	
	
	% Set input
	addevent(m1, "time >= 1250", "wB_in = 15");
	addevent(m1, "time >= 1250", "s1_in = 10");
	addevent(m1, "time >= 1250", "r1_in = 0.01");
	addevent(m1, "time >= 1250", "c1_in = 10");

	% Remove input
	addevent(m1, "time >= 1500", "wB_in = 0.01");
	addevent(m1, "time >= 1497", "s1_in = 0.01"); % MISTIMING
	addevent(m1, "time >= 1500", "r1_in = 0.01");
	addevent(m1, "time >= 1500", "c1_in = 0.01");

	% Request output
	addevent(m1, "time >= 1750", "wA_in = 15");
	addevent(m1, "time >= 2000", "wA_in = 0.01");
	

	% https://ch.mathworks.com/help/simbio/ref/sbiosimulate.html
	% Set final time
	T = 2200;
	set(getconfigset(m1, 'active'), 'Stoptime', T);
	
	% Why the Shelf?
	%
% 	addevent(m1, "time >= 600", "wA_in = 0");
% 	
% 	m1.Species(index_of(A)).InitialAmount = 10;
% 	m1.Species(index_of(B)).InitialAmount = 10;
% 	m1.Species(index_of(C)).InitialAmount = 10;
% 	
% 	addevent(m1, "time >= 800", "wB_in = 10");
% 	addevent(m1, "time >= 800", "s1_in = 10");
% 	addevent(m1, "time >= 800", "r1_in = 0");
% 	addevent(m1, "time >= 800", "c1_in = 10");
% 	
% 	addevent(m1, "time >= 1000", "wB_in = 0");
% 	
% 	addevent(m1, "time >= 1200", "wA_in = 0");
% 
% 	[t, x] = sbiosimulate(m1);
% 	close all
% 	spp = ["Y", "ShelfLoaded", "Xis", "Int", "P1_forw"];
% 	for sp = spp
% 		semilogy(t, x(:, index_of(sp)))
% 		hold on
% 		axis([0, T, 1e-2, 1e2]);
% 	end
% 	legend(spp, 'Interpreter', 'none')

	
	for MakeShelf = [1, 0]
		
		m1.Rules({m1.Rules.Name} == "make_Shelf").Active = MakeShelf;
		
		%%
		responses = {};

		[t, x] = sbiosimulate(m1);
		assert(max(t) == T);

		close all;

		figure;
		set(0, 'DefaultAxesFontSize', 14);
		set(gcf, 'renderer', 'Painters');

		hold on;

		styles = containers.Map();
		styles("wA_in") = "--k";
		styles("wB_in") = "--r";
		styles("Y") = "--b";
		styles("Shelf_Y") = "-.b";
		styles("Xis") = "-b";
		styles("Int") = "-r";
		styles("d1") = "-k";

		species = ["wA_in", "wB_in", "Y", "Shelf_Y", "Xis", "Int", "d1"];

		for S = species
			plot(t, x(:, index_of(S)), styles(S), 'LineWidth', 2);
		end


		pbaspect([3, 1, 1]);

		ylabel("Molecules");
		xlabel("Time (a.u.)");

		species(species == "wA_in") = "#wA";
		species(species == "wB_in") = "#wB";
		species(species == "d1") = "#d1";
		legend(species, 'Location', 'NE', 'Interpreter', 'none');
		axis tight;

		set(gcf, 'units', 'inches', 'position', [0, 0, 15, 5])

		filename = ['response_d1_tempo' '__Shelf=' num2str(MakeShelf)];
		exportgraphics(gcf, ['output/' filename '.pdf']);
		exportgraphics(gcf, ['output/' filename '.png'], 'Resolution', 180);

		close all;
	end
end
