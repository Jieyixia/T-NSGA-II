function pop=CalcChebychevRank(pop, TargetRegion, epsilon)
    
    nPop = numel(pop);
    
    % Calculate Chebychev Distance
    for i = 1 : nPop
        pop(i)=CalcChebychevDistance(pop(i),TargetRegion);
    end
    
   
    % Calculate Chebychev Rank
    CheDist = [pop.ChebychevDistance];
    
    CheRank = zeros(size(CheDist));
    
    for i = 1 : numel(TargetRegion)
        CD = CheDist(i, :);
        [~, index] = sort(CD);
        
        cRank = 1;
        for j = 1 : nPop
            if CheRank(i, index(j)) > nPop
                continue
            end
 
            CheRank(i, index(j)) = cRank;
            cRank = cRank + 1;
            
            MutualCD = pdist2(pop(index(j)).Cost', [pop.Cost]', 'Chebychev');
            MarkedIndex = find(MutualCD < epsilon);
            MarkedIndex(MarkedIndex == index(j)) = [];
            
            CheRank(i, MarkedIndex) = nPop + ceil(CD(MarkedIndex));

        end         
    end
    
    CheRank = min(CheRank);
    
    for i = 1: nPop
        pop(i).ChebychevRank = CheRank(i);
    end
    
    
end