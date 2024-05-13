function table = evaluation_table (evaluation)
average_evaluation = zeros (1,6);
for n=1:6
    average_evaluation(1,n) = mean(evaluation(:,n));
end
std_evaluation = zeros(1,6);
for n=1:6
    std_evaluation(1,n) = std(evaluation(:,n));
end

table = [average_evaluation(1), average_evaluation(2), average_evaluation(3), average_evaluation(4), average_evaluation(5), average_evaluation(6); std_evaluation(1),std_evaluation(2), std_evaluation(3), std_evaluation(4), std_evaluation(5), std_evaluation(6)];
table = array2table(table);
table.Properties.VariableNames = {'TP', 'FP', 'FN', 'recall', 'precision', 'F_measure'};
table.Properties.RowNames = {'average', 'standart desviation'};
end