function factors = ComputeEqualPairwiseFactors (images, K)
% This function computes the pairwise factors for one word in which every
% factor value is set to be 1.
%
% Input:
%   images: An array of structs containing the 'img' value for each
%     character in the word.
%   K: The alphabet size (accessible in imageModel.K for the provided
%     imageModel).
%
% Output:
%   factors: The pairwise factors for this word. Every entry in the factor
%     vals should be 1.
%
% Copyright (C) Daphne Koller, Stanford University, 2012

n = length(images);

factors = repmat(struct('var', [], 'card', [], 'val', []), n - 1, 1);

% Your code here:
for index = 1:(n-1)
  factors(index).var(1) = index;
  factors(index).var(2) = index + 1;
  factors(index).card(1) = K;
  factors(index).card(2) = K;
  factors(index).val(1:(K*K)) = 1;
end;

end
