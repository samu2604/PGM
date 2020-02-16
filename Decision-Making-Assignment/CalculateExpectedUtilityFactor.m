% Copyright (C) Daphne Koller, Stanford University, 2012

function EUF = CalculateExpectedUtilityFactor( I )

  % Inputs: An influence diagram I with a single decision node and a single utility node.
  %         I.RandomFactors = list of factors for each random variable.  These are CPDs, with
  %              the child variable = D.var(1)
  %         I.DecisionFactors = factor for the decision node.
  %         I.UtilityFactors = list of factors representing conditional utilities.
  % Return value: A factor over the scope of the decision rule D from I that
  % gives the conditional utility given each assignment for D.var
  %
  % Note - We assume I has a single decision node and utility node.
  EUF = [];
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %
  % YOUR CODE HERE...
  
  Decision_Factor = I.DecisionFactors
  Factors = [I.RandomFactors I.UtilityFactors];
  
  non_parents_D = setdiff(unique([Factors(:).var]), [Decision_Factor.var]);
  
  Factors_Product = Factors(1);
  for factor_index = 2:length(Factors)
      Factors_Product = FactorProduct(Factors_Product,Factors(factor_index));
  end;
  
  EUF = FactorMarginalization(Factors_Product, non_parents_D);
  
  %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
  
  
end  
