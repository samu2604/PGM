function phenotypeFactor = phenotypeGivenGenotypeFactor(alphaList, genotypeVar, phenotypeVar)
% This function computes the probability of each phenotype given the 
% different genotypes for a trait. Genotypes (assignments to the genotype
% variable) are indexed from 1 to the number of genotypes, and the alphas
% are provided in the same order as the corresponding genotypes so that the
% alpha for genotype assignment i is alphaList(i).
%
% For the phenotypes, assignment 1 maps to having the physical trait, and 
% assignment 2 maps to not having the physical trait.
%
% THE VARIABLE TO THE LEFT OF THE CONDITIONING BAR MUST BE THE FIRST
% VARIABLE IN THE .var FIELD FOR GRADING PURPOSES
%
% Input:
%   alphaList: Vector of alpha values for each genotype (n x 1 vector,
%   where n is the number of genotypes) -- the alpha value for a genotype
%   is the probability that a person with that genotype will have the
%   physical trait 
%   genotypeVar: The variable number for the genotype variable (goes in the
%   .var part of the factor)
%   phenotypeVar: The variable number for the phenotype variable (goes in
%   the .var part of the factor)
%
% Output:
%   phenotypeFactor: Factor in which the val has the probability of having 
%   each phenotype for each genotype combination (note that this is the 
%   FULL CPD with no evidence observed)

phenotypeFactor = struct('var', [], 'card', [], 'val', []);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%INSERT YOUR CODE HERE
% The number of genotypes is the length of alphaList.


phenotypeFactor.var(1) = phenotypeVar;
phenotypeFactor.var(2) = genotypeVar;

% The number of phenotypes is 2.
phenotypeFactor.card(1) = 2;
% The number of genotypes is the length of alphaList.
phenotypeFactor.card(2) = length(alphaList);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

phenotypeFactor.val = zeros(1, prod(phenotypeFactor.card));
% Replace the zeros in phentoypeFactor.val with the correct values.

index_vector = 1:length(phenotypeFactor.val); 
assignment = IndexToAssignment(index_vector, phenotypeFactor.card);

trait = 1;
no_trait = 2;

FF = 1;
Ff = 2;
ff = 3;

alpha_list_index = 1;

for index = 1:length(index_vector) 
  if assignment(index) == trait
    phenotypeFactor.val(index) = alphaList(alpha_list_index);
  elseif assignment(index) == no_trait
    phenotypeFactor.val(index) = 1 - alphaList(alpha_list_index);
    alpha_list_index += 1;
  end;
end;  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Testing phenotypeGivenGenotypeFactor:
%alphaList = [0.8; 0.6; 0.1];
%genotypeVar = 1;
%phenotypeVar = 3;
%phenotypeFactorAlpha = struct('var', [3,1], 'card', [2,3], 'val', [0.8,0.2,0.6,0.4,0.1,0.9]); % Comment out this line for testing
% phenotypeFactorAlpha = phenotypeGivenGenotypeFactor(alphaList, genotypeVar, phenotypeVar);






