% Copyright (C) Daphne Koller, Stanford University, 2012

function [MEU OptimalDecisionRule] = OptimizeLinearExpectations( I )
  % Inputs: An influence diagram I with a single decision node and one or more utility nodes.
  %         I.RandomFactors = list of factors for each random variable.  These are CPDs, with
  %              the child variable = D.var(1)
  %         I.DecisionFactors = factor for the decision node.
  %         I.UtilityFactors = list of factors representing conditional utilities.
  % Return value: the maximum expected utility of I and an optimal decision rule 
  % (represented again as a factor) that yields that expected utility.
  % You may assume that there is a unique optimal decision.
  %
  % This is similar to OptimizeMEU except that we will have to account for
  % multiple utility factors.  We will do this by calculating the expected
  % utility factors and combining them, then optimizing with respect to that
  % combined expected utility factor.  
  MEU = [];
  OptimalDecisionRule = [];
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %
  % YOUR CODE HERE
  %
  % A decision rule for D assigns, for each joint assignment to D's parents, 
  % probability 1 to the best option from the EUF for that joint assignment 
  % to D's parents, and 0 otherwise.  Note that when D has no parents, it is
  % a degenerate case we can handle separately for convenience.
  UtilityFactors = I.UtilityFactors;
  D = I.DecisionFactors;
  
  EUF = struct('var', [], 'card', [], 'val', []);
  for utility_index = 1:length(UtilityFactors)
    I.UtilityFactors = UtilityFactors(utility_index);
    EUF_i = CalculateExpectedUtilityFactor(I);
    utility_index
    EUF = SumOfFactors(EUF, EUF_i);
  end;
  
  
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
