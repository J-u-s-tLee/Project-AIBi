function [TP, FP, FN, Jaccard] = Evaluation(ROI, ROI_GT)

TP = nnz(ROI_GT&ROI);
FP = nnz(ROI == 1 & ROI_GT == 0);
FN = nnz(ROI == 0 & ROI_GT == 1);
Jaccard = TP/(TP+FP+FN);

end