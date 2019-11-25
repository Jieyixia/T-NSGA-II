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

clear
clc

MaxIter = 3;
load seed.mat seed

func = {'sch', 'fon', 'zdt1', 'zdt2', 'zdt3', 'zdt6', 'zdt4'}; 

% Intersect Target Region for SCH Problem
empty_region.lower = [];
empty_region.upper = [];
empty_region.center = [];

TargetRegion = repmat(empty_region, 3, 1);
% TargetRegion(1).lower = [0,0.5];
% TargetRegion(1).upper = [0.1,1];
TargetRegion(1).lower = [0,0.8];
TargetRegion(1).upper = [0.1,0.9];
TargetRegion(1).center = (TargetRegion(1).lower + TargetRegion(1).upper) / 2;

% TargetRegion(2).lower = [0.8,0];
% TargetRegion(2).upper = [1,0.2];
TargetRegion(2).lower = [0.6,0.7];
TargetRegion(2).upper = [0.8,0.9];
TargetRegion(2).center = (TargetRegion(2).lower + TargetRegion(2).upper) / 2;

% TargetRegion(3).lower = [0.6,0.6];
% TargetRegion(3).upper = [0.8,0.8];
TargetRegion(3).lower = [0.3, 0.3];
TargetRegion(3).upper = [0.5, 0.5];
TargetRegion(3).center = (TargetRegion(3).lower + TargetRegion(3).upper) / 2;

for func_no = 2
    for i = 1 : MaxIter
        tic
        nsga2(seed(i), i, func{func_no}, TargetRegion, 0.05);
        toc
    end
end



