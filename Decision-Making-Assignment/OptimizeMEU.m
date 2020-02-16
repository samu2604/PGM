% Copyright (C) Daphne Koller, Stanford University, 2012

function [MEU OptimalDecisionRule] = OptimizeMEU( I )

  % Inputs: An influence diagram I with a single decision node and a single utility node.
  %         I.RandomFactors = list of factors for each random variable.  These are CPDs, with
  %              the child variable = D.var(1)
  %         I.DecisionFactors = factor for the decision node.
  %         I.UtilityFactors = list of factors representing conditional utilities.
  % Return value: the maximum expected utility of I and an optimal decision rule 
  % (represented again as a factor) that yields that expected utility.
  
  % We assume I has a single decision node.
  % You may assume that there is a unique optimal decision.
  D = I.DecisionFactors(1);

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %
  % YOUR CODE HERE...
  % 
  % Some other information that might be useful for some implementations
  % (note that there are multiple ways to implement this):
  % 1.  It is probably easiest to think of two cases - D has parents and D 
  %     has no parents.
  % 2.  You may find the Matlab/Octave function setdiff useful.
  
  EUF = CalculateExpectedUtilityFactor(I);
  OptimalDecisionRule = EUF;
  OptimalDecisionRule.val(:) = 0;
  if length(D.var) == 1
   %D has no parents, so the best decision is to just take the maximum of EUF.
    [MEU, index] = max(EUF.val);
    OptimalDecisionRule.val(index) = 1;
  else
    assignments = IndexToAssignment(1:length(EUF.val), EUF.card);
    % I need to understand which variable of EUF.var corresponds to D.var(1)
    D_index_in_EUF = find(EUF.var == D.var(1));
    % I remove the decision var from the assignments, because I have to assign 
    % the best decision for each assignment to the parents of D.var(1)
    assignments(:, D_index_in_EUF) = [];
    
    for index = 1:length(EUF.val)
      % to be optimized
      equal_assignments_parents_D = find(assignments == assignments(index))
      [maxUtility, ids] =  max(EUF.val(equal_assignments_parents_D));
      OptimalDecisionRule.val(equal_assignments_parents_D(ids)) = 1;
    end;
      
  end;
  F = FactorProduct(OptimalDecisionRule, EUF);
  MEU = sum(F.val(:));
  
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    

end
