%CLIQUETREECALIBRATE Performs sum-product or max-product algorithm for 
%clique tree calibration.

%   P = CLIQUETREECALIBRATE(P, isMax) calibrates a given clique tree, P 
%   according to the value of isMax flag. If isMax is 1, it uses max-sum
%   message passing, otherwise uses sum-product. This function 
%   returns the clique tree where the .val for each clique in .cliqueList
%   is set to the final calibrated potentials.
%
% Copyright (C) Daphne Koller, Stanford University, 2012

function P = CliqueTreeCalibrate(P, isMax)


% Number of cliques in the tree.
N = length(P.cliqueList);

% Setting up the messages that will be passed.
% MESSAGES(i,j) represents the message going from clique i to clique j. 
MESSAGES = repmat(struct('var', [], 'card', [], 'val', []), N, N);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% We have split the coding part for this function in two chunks with
% specific comments. This will make implementation much easier.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% YOUR CODE HERE
% While there are ready cliques to pass messages between, keep passing
% messages. Use GetNextCliques to find cliques to pass messages between.
% Once you have clique i that is ready to send message to clique
% j, compute the message and put it in MESSAGES(i,j).
% Remember that you only need an upward pass and a downward pass.
%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if ~exist('isMax', 'var') || isempty(isMax)
    isMax = false;
end

if isMax
    for i = 1:length(P.cliqueList)
        P.cliqueList(i).val = log(P.cliqueList(i).val);
    end
end

[i, j] = GetNextCliques(P, MESSAGES);
while i ~= 0 && j ~= 0
    messageIndices = setdiff(find(P.edges(i, :) == 1), j); % all those that are connected with i, but not with j
    MESSAGES(i, j) = P.cliqueList(i);
    for k = 1:length(messageIndices)
        if ~isMax
            MESSAGES(i, j) = FactorProduct(MESSAGES(i, j), MESSAGES(messageIndices(k), i));
        else
            MESSAGES(i, j) = FactorSum(MESSAGES(i, j), MESSAGES(messageIndices(k), i));
        end
    end
    % the message sent from i to j "talks" only about the variables shared by both, clique i and j, so the message
    % from i to j has to be marginalized on the vars of Clique i that are not in Clique j
    vars_to_marginalize = setdiff(P.cliqueList(i).var, P.cliqueList(j).var);

    if ~isMax
        MESSAGES(i, j) = FactorMarginalization(MESSAGES(i, j), vars_to_marginalize);
        MESSAGES(i, j).val = MESSAGES(i, j).val / sum(MESSAGES(i, j).val);  % factor normalization
    else
        MESSAGES(i, j) = FactorMaxMarginalization(MESSAGES(i, j), vars_to_marginalize);
    end
    
    [i, j] = GetNextCliques(P, MESSAGES);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%
% Now the clique tree has been calibrated. 
% Compute the final potentials for the cliques and place them in P.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Iterate through the incoming messages, multiply them by the initial
% potential, and normalize
for i = 1:N
    connected_to_i = find(P.edges(i, :) == 1);
    for k = 1:length(connected_to_i)
        if ~isMax
            P.cliqueList(i) = FactorProduct(P.cliqueList(i), MESSAGES(connected_to_i(k), i));
        else
            P.cliqueList(i) = FactorSum(P.cliqueList(i), MESSAGES(connected_to_i(k), i));    
        end
    end
end


return