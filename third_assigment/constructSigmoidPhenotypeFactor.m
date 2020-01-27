function phenotypeFactor = constructSigmoidPhenotypeFactor(alleleWeights, geneCopyVarOneList, geneCopyVarTwoList, phenotypeVar)
% This function takes a cell array of alleles' weights and constructs a 
% factor expressing a sigmoid CPD.
%
% You can assume that there are only 2 genes involved in the CPD.
%
% In the factor, for each gene, each allele assignment maps to the allele
% whose weight is at the corresponding location.  For example, for gene 1,
% allele assignment 1 maps to the allele whose weight is at
% alleleWeights{1}(1) (same as w_1^1), allele assignment 2 maps to the
% allele whose weight is at alleleWeights{1}(2) (same as w_2^1),....  
% 
% You may assume that there are 2 possible phenotypes.
% For the phenotypes, assignment 1 maps to having the physical trait, and
% assignment 2 maps to not having the physical trait.
%
% THE VARIABLE TO THE LEFT OF THE CONDITIONING BAR MUST BE THE FIRST
% VARIABLE IN THE .var FIELD FOR GRADING PURPOSES
%
% Input:
%   alleleWeights: Cell array of weights, where each entry is an 1 x n 
%   of weights for the alleles for a gene (n is the number of alleles for
%   the gene)
%   geneCopyVarOneList: m x 1 vector (m is the number of genes) of variable 
%   numbers that are the variable numbers for each of the first parent's 
%   copy of each gene (numbers in this list go in the .var part of the
%   factor)
%   geneCopyVarTwoList: m x 1 vector (m is the number of genes) of variable 
%   numbers that are the variable numbers for each of the second parent's 
%   copy of each gene (numbers in this list go in the .var part of the
%   factor) -- Note that both copies of each gene are from the same person,
%   but each copy originally came from a different parent
%   phenotypeVar: Variable number corresponding to the variable for the 
%   phenotype (goes in the .var part of the factor)
%
% Output:
%   phenotypeFactor: Factor in which the values are the probabilities of 
%   having each phenotype for each allele combination (note that this is 
%   the FULL CPD with no evidence observed)

phenotypeFactor = struct('var', [], 'card', [], 'val', []);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INSERT YOUR CODE HERE
% Note that computeSigmoid.m will be useful for this function.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

% Fill in phenotypeFactor.var.  This should be a 1-D row vector.
% Fill in phenotypeFactor.card.  This should be a 1-D row vector.

phenotypeFactor.var(1) = phenotypeVar;
number_of_genes = length(geneCopyVarOneList);

for gene = 1:number_of_genes
  phenotypeFactor.var(gene + 1) = geneCopyVarOneList(gene);
  phenotypeFactor.var(gene + 1 + number_of_genes) = geneCopyVarTwoList(gene);
end;

phenotypeFactor.card(1) = 2;

for gene = 1:number_of_genes
  phenotypeFactor.card(gene + 1) = length(alleleWeights{gene}); % this way I obtain the number of alleles for the specific gene.
  phenotypeFactor.card(gene + 1 + number_of_genes) = length(alleleWeights{gene});
end;

phenotypeFactor.val = zeros(1, prod(phenotypeFactor.card));
% Replace the zeros in phentoypeFactor.val with the correct values.

assignments = IndexToAssignment(1:length(phenotypeFactor.val), phenotypeFactor.card);

for index = 1:length(phenotypeFactor.val)
  z = 0;
  for gene = 1:number_of_genes
    z += alleleWeights{gene}(assignments(index, gene + 1));
    z += alleleWeights{gene}(assignments(index, gene + 1 + number_of_genes));
  end;
  if assignments(index, 1) == 1
    phenotypeFactor.val(index) = computeSigmoid(z);
  elseif assignments(index, 1) == 1
    phenotypeFactor.val(index) = 1 - computeSigmoid(z);
 end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Testing constructSigmoidPhenotypeFactor:
%alleleWeights = {[3, -3], [0.9, -0.8]};
%geneCopyVarParentOneList = [1; 2];
%geneCopyVarParentTwoList = [4; 5];
%phenotypeVar = 3;
%phenotypeFactorSigmoid = struct('var', [3,1,2,4,5], 'card', [2,2,2,2,2], 'val', [0.999590432835014,0.000409567164986080,0.858148935099512,0.141851064900488,0.997762151478724,0.00223784852127629,0.524979187478940,0.475020812521060,0.858148935099512,0.141851064900488,0.0147740316932731,0.985225968306727,0.524979187478940,0.475020812521060,0.00273196076301106,0.997268039236989,0.997762151478724,0.00223784852127629,0.524979187478940,0.475020812521060,0.987871565015726,0.0121284349842742,0.167981614866076,0.832018385133925,0.524979187478940,0.475020812521060,0.00273196076301106,0.997268039236989,0.167981614866076,0.832018385133925,0.000500201107079564,0.999499798892920]);  % Comment out this line for testing
% phenotypeFactorSigmoid = constructSigmoidPhenotypeFactor(alleleWeights, geneCopyVarParentOneList, geneCopyVarParentTwoList, phenotypeVar);