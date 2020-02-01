function factors = ComputeTripletFactors (images, tripletList, K)
% This function computes the triplet factor values for one word.
%
% Input:
%   images: An array of structs containing the 'img' value for each
%     character in the word.
%   tripletList: An array of the character triplets we will consider (other
%     factor values should be 1). tripletList(i).chars gives character
%     assignment, and triplistList(i).factorVal gives the value for that
%     entry in the factor table.
%   K: The alphabet size (accessible in imageModel.K for the provided
%     imageModel).
%
% Hint: Every character triple in the word will use the same 'val' table.
%   Consider computing that array once and then resusing for each factor.
%
% Copyright (C) Daphne Koller, Stanford University, 2012


n = length(images);

% If the word has fewer than three characters, then return an empty list.
if (n < 3)
    factors = [];
    return
end

factors = repmat(struct('var', [], 'card', [], 'val', []), n - 2, 1);

% Your code here:

for index = 1:(n-2)
  factors(index).var(1) = index;
  factors(index).var(2) = index + 1;
  factors(index).var(3) = index + 2;
  factors(index).card(1) = K;
  factors(index).card(2) = K;
  factors(index).card(3) = K;
  factors(index).val(1:(K*K*K)) = 1;
  for triplet_index = 1:length(tripletList) 
    val_index = AssignmentToIndex(tripletList(triplet_index).chars, factors(index).card);
    factors(index).val(val_index) = tripletList(triplet_index).factorVal;
  end;
  % normalization of the factor to have the 2000th most frequent triplet's factor equal to 1 
  factors(index).val /= tripletList(end).factorVal;  
end;


end
