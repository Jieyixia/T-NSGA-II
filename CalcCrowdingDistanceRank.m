function pop = CalcCrowdingDistanceRank(pop, F, TargetRegion)
    
    nPop = numel(pop);
    
    nF = numel(F);
    
    % Judge Particles In the Target Region
    for i = 1 : nPop
        
        pop(i) = JudgeWithin(pop(i), TargetRegion);
        
    end
    
    % Calculate Crowding Distance
    pop = CalcCrowdingDistance(pop, F);
    
    % Assign Crowding Distance Rank
    for i = 1 : nF
        
        pop(F{i}) = AssignCrowdingDistanceRank(pop, TargetRegion);
    
    end
    
end

function pop = JudgeWithin(pop, TargetRegion)
% Judge Particles In the Target Region


    nTR = numel(TargetRegion);
    nObj = numel(TargetRegion(1).lower);
    
    is_within = 1 : nTR;

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
    end

    pop.is_within = is_within;
    
    if sum(is_within) == 0
        pop.CrowdingDistance = 0;
    end
end

function pop = AssignCrowdingDistanceRank(pop, TargetRegion)
% Assign Crowding Distance Rank to Particles in the same Front
        

    nPop = nume(pop);
    nTR = numel(TargetRegion);
    is_within = [pop.is_within];
    MaxDc = floor(numel(pop) / nTR);
    
    for i = 1 : nTR
        
        within_flag = is_within(i, :);
        
        CrowdingDistance = [pop(within_flag == i).CrowdingDistance];
        
        [~, index] = sort(CrowdingDistance, 'descend');
        
        for j = 1 : min(MaxDc, nPop)
            
            pop(index(j)).CrowdingDistanceRank = MaxDc - j + 1;
           
        end
        
        for j = min(MaxDc, nPop) + 1 : nPop
            
            pop(index(j)).CrowdingDistanceRank = pop(index(j)).CrowdingDistance / maxDc;
            
        end
        
    end

end