%
% Copyright (c) 2015,Yarpiz (www.yarpiz.com)
% All rights reserved. Please read the "license.txt" for license terms.
%
% Project Code: YPEA120
% Project Title: Non-dominated Sorting Genetic Algorithm II (NSGA-II)
% Publisher: Yarpiz (www.yarpiz.com)
% 
% Developer: S. Mostapha Kalami Heris (Member of Yarpiz Team)
% 
% Contact Info: sm.kalami@gmail.com,info@yarpiz.com
%

function nsga2(seed,It_no,FuncName, TargetRegion, epsilon)
%% Load True Pareto Front
load true_pf.mat true_pf
TruePF=true_pf;

%% Problem Definition
switch FuncName
    case 'sch'
        CostFunction=@(x)SCH(x);
        nVar=1; 
        VarMax=1000;
        VarMin=-1000;      
        TruePF = TruePF{1};
        
    case 'fon'
        CostFunction=@(x)FON(x);
        nVar=3; 
        VarMax=ones(1,nVar)*4;
        VarMin=ones(1,nVar)*(-4);
        TruePF = TruePF{2};
        
    case 'kur'
        CostFunction=@(x)KUR(x);
        nVar=3;
        VarMax=ones(1,nVar)*5;
        VarMin=ones(1,nVar)*(-5);
        
    case 'zdt1'
        CostFunction=@(x)ZDT1(x);
        nVar=30; 
        VarMax=ones(1,nVar);
        VarMin=zeros(1,nVar);      
        TruePF = TruePF{3};
        
    case 'zdt2'
        CostFunction=@(x)ZDT2(x);
        nVar=30; 
        VarMax=ones(1,nVar);
        VarMin=zeros(1,nVar);    
        TruePF = TruePF{4};
        
    case 'zdt3'
        CostFunction=@(x)ZDT3(x);
        nVar=30; 
        VarMax=ones(1,nVar);
        VarMin=zeros(1,nVar);     
        TruePF = TruePF{5};
        
    case 'zdt4'
        CostFunction=@(x)ZDT4(x);
        nVar=10; 
        VarMax=[1 ones(1,nVar-1)*5];
        VarMin=[0 ones(1,nVar-1)*(-5)];  
        TruePF = TruePF{7};
        
    case 'zdt6'
        CostFunction=@(x)ZDT6(x);
        nVar=10; 
        VarMax=ones(1,nVar);
        VarMin=zeros(1,nVar);    
        TruePF = TruePF{6};
end


VarSize=[1 nVar];   % Size of Decision Variables Matrix


%% NSGA-II Parameters

MaxIt=500;      % Maximum Number of Iterations

nPop=100;        % Population Size

pCrossover=0.7;                         % Crossover Percentage
nCrossover=2*round(pCrossover*nPop/2);  % Number of Parents (Offsprings)

pMutation=0.4;                          % Mutation Percentage
nMutation=round(pMutation*nPop);        % Number of Mutants

mu=0.02;                    % Mutation Rate

sigma=0.1*(VarMax-VarMin);  % Mutation Step Size

%% Initialization
rng(seed)
empty_individual.Position=[];
empty_individual.Cost=[];
empty_individual.Rank=[];
empty_individual.DominationSet=[];
empty_individual.DominatedCount=[];
empty_individual.CrowdingDistance=0;
empty_individual.CrowdingDistanceRank=[];
empty_individual.ChebychevRank=[];
empty_individual.ChebychevDistance = [];
empty_individual.is_within = [];

pop=repmat(empty_individual,nPop,1);

for i=1:nPop
    
    pop(i).Position=unifrnd(VarMin,VarMax,VarSize);
    
    pop(i).Cost=CostFunction(pop(i).Position);
    
end

% Non-Dominated Sorting
[pop,F]=NonDominatedSorting(pop);

% Calculate Crowding Distance 
pop=CalcCrowdingDistance(pop,F);

% Calculate Chebychev Rank
pop=CalcChebychevRank(pop,TargetRegion,epsilon);

% Sort Population
[pop,~]=SortPopulation(pop);


%% NSGA-II Main Loop

for it=1:MaxIt 
    % Crossover
    popc=repmat(empty_individual,nCrossover/2,2);
    for k=1:nCrossover/2
        
        i1=randi([1 nPop]);
        p1=pop(i1);
        
        i2=randi([1 nPop]);
        p2=pop(i2);
        
        [popc(k,1).Position,popc(k,2).Position]=Crossover(p1.Position,p2.Position);
        
        % make new solution feasible--------------------------
        popc(k,1).Position=max(popc(k,1).Position,VarMin);
        popc(k,1).Position=min(popc(k,1).Position,VarMax);
        popc(k,2).Position=max(popc(k,2).Position,VarMin);
        popc(k,2).Position=min(popc(k,2).Position,VarMax);
        % make new solution feasible--------------------------
        
        popc(k,1).Cost=CostFunction(popc(k,1).Position);
        popc(k,2).Cost=CostFunction(popc(k,2).Position);
        
    end
    popc=popc(:);
    
    % Mutation
    popm=repmat(empty_individual,nMutation,1);
    for k=1:nMutation
        
        i=randi([1 nPop]);
        p=pop(i);
        
        popm(k).Position=Mutate(p.Position,mu,sigma);
        
        % make new solution feasible--------------------------
        popm(k).Position=max(popm(k).Position,VarMin);
        popm(k).Position=min(popm(k).Position,VarMax);
        % make new solution feasible--------------------------
        
        popm(k).Cost=CostFunction(popm(k).Position);
        
    end
    
    % Merge
    pop=[pop
         popc
         popm]; %#ok
        
    % Non-Dominated Sorting
    [pop,F]=NonDominatedSorting(pop);
       
    % Calculate Crowding Distance
    pop=CalcCrowdingDistance(pop,F);
        
    % Calculate Chebychev Rank
    pop=CalcChebychevRank(pop,TargetRegion,epsilon);
       
    % Sort Population
    pop=SortPopulation(pop);
     
    % Truncate
    pop=pop(1:nPop);
    
    % Non-Dominated Sorting为什么这里还要再进行一次非支配排序，计算拥挤距离等等？
    [pop,F]=NonDominatedSorting(pop);
    
%     % Calculate Crowding Distance
%     pop=CalcCrowdingDistance(pop,F);
%     
%     % Calculate Chebychev Rank
%     pop=CalcChebychevRank(pop,TargetRegion,epsilon);
% 
%     % Sort Population
%     [pop,F]=SortPopulation(pop);

    % Store F1
    F1=pop(F{1});
         
    % Plot F1 Costs
    figure(It_no);
    PlotCosts(F1,TargetRegion,TruePF,FuncName);
    pause(0.01);
    
    disp(['It-' num2str(it, '%04d')])
end

end
