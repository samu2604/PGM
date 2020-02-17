
function Fsum = SumOfFactors(F1, F2)

if (length(F1.var) == 0)
  sum = F2;
  return;
end;

if (length(F2.var) == 0)
  sum = F1;
  return;
end;

Fsum.var = union(F1.var, F2.var);

[~, mapF1] = ismember(F1.var, Fsum.var);
[~, mapF2] = ismember(F2.var, Fsum.var);

Fsum.card = zeros(1,length(Fsum.var));
Fsum.card(mapF1) = F1.card;
Fsum.card(mapF2) = F2.card;
Fsum.val = zeros(1, prod(Fsum.card));

assignments = IndexToAssignment(1:length(Fsum.val), Fsum.card);

index_of_F1_values = AssignmentToIndex(assignments(:, mapF1), F1.card);
index_of_F2_values = AssignmentToIndex(assignments(:, mapF2), F2.card);

Fsum.val = F1.val(index_of_F1_values) + F2.val(index_of_F2_values);

end