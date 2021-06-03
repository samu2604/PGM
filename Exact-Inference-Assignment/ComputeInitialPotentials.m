%COMPUTEINITIALPOTENTIALS Sets up the cliques in the clique tree that is
%passed in as a parameter.
%
%   P = COMPUTEINITIALPOTENTIALS(C) Takes the clique tree skeleton C which is a
%   struct with three fields:
%   - nodes: cell array representing the cliques in the tree.
%   - edges: represents the adjacency matrix of the tree.
%   - factorList: represents the list of factors that were used to build
%   the tree. 
%   
%   It returns the standard form of a clique tree P that we will use through 
%   the rest of the assigment. P is struct with two fields:
%   - cliqueList: represents an array of cliques with appropriate factors 
%   from factorList assigned to each clique. Where the .val of each clique
%   is initialized to the initial potential of that clique.
%   - edges: represents the adjacency matrix of the tree. 
%
% Copyright (C) Daphne Koller, Stanford University, 2012


function P = ComputeInitialPotentials(C)

% number of cliques
N = length(C.nodes);

% initialize cluster potentials 
P.cliqueList = repmat(struct('var', [], 'card', [], 'val', []), N, 1);
P.edges = zeros(N);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%
% First, compute an assignment of factors from factorList to cliques. 
% Then use that assignment to initialize the cliques in cliqueList to 
% their initial potentials. 

% C.nodes is a list of cliques.
% So in your code, you should start with: P.cliqueList(i).var = C.nodes{i};
% Print out C to get a better understanding of its structure.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

P.edges = C.edges;
[Variables, map] = unique([C.factorList.var]);
cards = [C.factorList.card];
cards = cards(map);
used_factors = zeros(size(C.factorList));

for i = 1:N

    P.cliqueList(i).var = C.nodes{i};
    P.cliqueList(i).card = cards(C.nodes{i});

    tmpFactor = struct('var', [], 'card', [], 'val', []);
    tmpFactor.var = P.cliqueList(i).var;
    tmpFactor.card = P.cliqueList(i).card;
    tmpFactor.val = ones(1, prod(P.cliqueList(i).card));

    for j = 1:length(C.factorList)
        if used_factors(j) == 0 && all(ismember(C.factorList(j).var, C.nodes{i})) == 1   % I look for factors whose scope is included in the var list of the i-th node
            tmpFactor = FactorProduct(tmpFactor, C.factorList(j));
            used_factors(j) = 1;    
        end
    end

    P.cliqueList(i).val = tmpFactor.val;

end    


end

