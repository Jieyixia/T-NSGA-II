%
% Copyright (c) 2015, Yarpiz (www.yarpiz.com)
% All rights reserved. Please read the "license.txt" for license terms.
%
% Project Code: YPEA120
% Project Title: Non-dominated Sorting Genetic Algorithm II (NSGA-II)
% Publisher: Yarpiz (www.yarpiz.com)
% 
% Developer: S. Mostapha Kalami Heris (Member of Yarpiz Team)
% 
% Contact Info: sm.kalami@gmail.com, info@yarpiz.com
%

function PlotCosts(pop,TargetRegion,TruePF,FuncName)

    Costs=[pop.Cost];
    
    plot(Costs(1,:),Costs(2,:),'r*','MarkerSize',8);
    xlabel('1^{st} Objective');
    ylabel('2^{nd} Objective');
    title('Non-dominated Solutions (F_{1})');
    hold on;
    
    if strcmp(FuncName, 'zdt3') 
        
        if length(TruePF) == 100         
            sec = [19 24 20 19 18];           
        else          
            sec = [96 121 102 93 88];           
        end
      
        cur = 0;
        for i = 1 : 5      
            plot(TruePF(1, cur + 1 : cur + sec(i)), TruePF(2, cur + 1 : cur + sec(i)))         
            hold on         
            cur = cur + sec(i);         
        end
        
    else
        plot(TruePF(1, :), TruePF(2, :))     
    end
    hold on;
    grid on;
    
    for i = 1 : numel(TargetRegion)
        lb = TargetRegion(i).lower;
        ub = TargetRegion(i).upper;
        plot([lb(1) ub(1) ub(1) lb(1) lb(1)], [lb(2) lb(2) ub(2) ub(2) lb(2)])
        hold on
    end
    hold off;

end