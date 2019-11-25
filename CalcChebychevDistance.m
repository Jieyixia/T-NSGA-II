function pop=CalcChebychevDistance(pop, TargetRegion)

nObj = numel(TargetRegion(1).lower);   
nTR = numel(TargetRegion);

is_within = ones(nTR, 1);
pop.ChebychevDistance = zeros(nTR, 1);

for i = 1 : nTR
    for j = 1 : nObj
        if pop.Cost(j) < TargetRegion(i).lower(j)
            is_within(i) = 0;
            break
        end

        if pop.Cost(j) > TargetRegion(i).upper(j)
            is_within(i) = 0;
            break
        end
    end

    pop.ChebychevDistance(i) = pdist2(pop.Cost', TargetRegion(i).center, 'Chebychev');
   
end

pop.is_within = is_within;

% Modify Crowding Distance (If the particle not in any target region)
if sum(is_within) == 0
    pop.CrowdingDistance = 0;
end

end