function [Metrics_Table] = Metrics(Vetores_de_Imagens, Method)

Max_TP = 0;
Sum_TP = zeros(1,length(Vetores_de_Imagens{3}));
Max_FP = 0;
Sum_FP = zeros(1,length(Vetores_de_Imagens{3}));
Max_FN = 0;
Sum_FN = zeros(1,length(Vetores_de_Imagens{3}));
Max_Jaccard = 0;
Sum_Jaccard = zeros(1,length(Vetores_de_Imagens{3}));
Max_Euclidean = 0;
Sum_Euclidean = zeros(1,length(Vetores_de_Imagens{3}));

for i = 1: length(Vetores_de_Imagens{3})
    if(Method == "ROI_Hough")
        ROI = ROI_Hough(Vetores_de_Imagens{2}{1,i});
    elseif (Method == "MorphologicalFilters")
        ROI = MorphologicalFilters(Vetores_de_Imagens{2}{1,i});  
    end

    ROI_GT = im2double(Vetores_de_Imagens{3}{1,i});

    [TP, FP, FN, Jaccard] = Evaluation(ROI, ROI_GT);
    [Mean_Eu, Max_Eu] = Euclidean_Distance(ROI, ROI_GT);
    Sum_TP(i) = TP;
    Sum_FP(i) = FP;
    Sum_FN(i) = FN;
    Sum_Jaccard(i) = Jaccard;
    Sum_Euclidean(i) = Mean_Eu;
    
    if(TP > Max_TP)
        Max_TP = TP;
    end
    if(FP > Max_FP)
      Max_FP = FP;
    end
    if(FN > Max_FN)
      Max_FN = FN;
    end
    if(Jaccard > Max_Jaccard)
      Max_Jaccard = Jaccard;
    end
     if(Max_Eu > Max_Euclidean)
      Max_Euclidean = Max_Eu;
    end
end

Mean_TP = mean(Sum_TP,"all");
STD_TP = std(Sum_TP);
Mean_FN = mean(Sum_FN, "all");
STD_FN = std(Sum_FN);
Mean_FP = mean(Sum_FP, "all");
STD_FP = std(Sum_FP);
Mean_Jaccard = mean(Sum_Jaccard, "all");
STD_Jaccard = std(Sum_Jaccard);
Mean_Euclidean = mean(Sum_Euclidean, "all");
STD_Euclidean = std(Sum_Euclidean);

Metrics_Table = table(Mean_TP, STD_TP, Max_TP, Mean_FN, STD_FN, Max_FN, Mean_FP, STD_FP, Max_FP, Mean_Jaccard, STD_Jaccard, Max_Jaccard, Mean_Euclidean, STD_Euclidean, Max_Euclidean);

end
