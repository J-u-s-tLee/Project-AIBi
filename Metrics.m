function [Metrics_Table] = Metrics(Vetores_de_Imagens, Method)

Max_TP = 0;
Sum_TP = 0;
Max_FP = 0;
Sum_FP = 0;
Max_FN = 0;
Sum_FN = 0;
Max_Jaccard = 0;
Sum_Jaccard = 0;

for i = 1: length(Vetores_de_Imagens{3})
    if(Method == "ROI_Hough")
        ROI = ROI_Hough(Vetores_de_Imagens{2}{1,i});
    elseif (Method == "MorphologicalFilters")
        ROI = MorphologicalFilters(Vetores_de_Imagens{2}{1,i});  
    end

    ROI_GT = im2double(Vetores_de_Imagens{3}{1,i});

    [TP, FP, FN, Jaccard] = Evaluation(ROI, ROI_GT);
    Sum_TP = Sum_TP + TP;
    Sum_FP = Sum_FP + FP;
    Sum_FN = Sum_FN + FN;
    Sum_Jaccard = Sum_Jaccard + Jaccard;
    
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
end

Mean_TP = (Sum_TP / length(Vetores_de_Imagens{3}));
Mean_FN = (Sum_FN / length(Vetores_de_Imagens{3}));
Mean_FP = (Sum_FP / length(Vetores_de_Imagens{3}));
Mean_Jaccard = (Sum_Jaccard / length(Vetores_de_Imagens{3}))*100;
Max_Jaccard = Max_Jaccard * 100;

Metrics_Table = table(Mean_TP, Max_TP, Mean_FN, Max_FN, Mean_FP, Max_FP, Mean_Jaccard, Max_Jaccard);

end