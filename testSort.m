% test = [2 0.5 0; 1 3 1; 1 0.1 2; 2 1 3; 3 0.2 4; 3 0.6 5; 4 1 6];
test = [2 100 0; 1 20 0; 1 210 0; 2 20 0; 3 0.2 4; 3 0.6 5; 4 10 0];

empty.rank = [];
empty.CD = [];
empty.CR = [];

pop = repmat(empty, 7, 1);
for i = 1 : 7
    pop(i).rank = test(i, 1);
    pop(i).CD = test(i, 2);
    pop(i).CR = test(i, 3);
end

CR = [pop.CR];

[~, CRSO] = sort(CR);

pop = pop(CRSO);

CD = [pop.CD];

[~, CDSO] = sort(CD, 'descend');

pop = pop(CDSO);

NS = [pop.rank];

[~, NSSO] = sort(NS);

pop = pop(NSSO);