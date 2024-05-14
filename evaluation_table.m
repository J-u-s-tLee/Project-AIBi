function table = evaluation_table (evaluation)
% Criação e representação de uma tabela com os valores médios, desvios e
% máximos das grandezas a avaliar

% Cálculo dos valores médios
average_evaluation = zeros (1,7);
for n=1:7
    average_evaluation(1,n) = mean(evaluation(:,n));
end

% Cálculo dos desvios padrão
std_evaluation = zeros(1,7);
for n=1:7
    std_evaluation(1,n) = std(evaluation(:,n));
end

% Cálculo dos valores máximos
max_evaluation = zeros(1,7);
for n=1:7
    max_evaluation(1,n) = max(evaluation(:,n));
end

% Criação da tabela e representação na command window
table = [average_evaluation(1), average_evaluation(2), average_evaluation(3), average_evaluation(4), average_evaluation(5), average_evaluation(6), average_evaluation(7); std_evaluation(1),std_evaluation(2), std_evaluation(3), std_evaluation(4), std_evaluation(5), std_evaluation(6), std_evaluation(7); max_evaluation(1),max_evaluation(2), max_evaluation(3), max_evaluation(4), max_evaluation(5), max_evaluation(6), max_evaluation(7)];
table = array2table(table);
table.Properties.VariableNames = {'counted cells', 'TP', 'FP', 'FN', 'recall', 'precision', 'F_measure'};
table.Properties.RowNames = {'average', 'standart desviation', 'maximum'};
end