metanr_packages()
# FALSE = Unpaird
mSet<-InitDataObjects("conc", "stat", FALSE)

mSet<-Read.TextData(mSet, "for_metabo.csv", "colu", "disc");

mSet<-SanityCheckData(mSet)

mSet<-PreparePrenormData(mSet)
mSet<-Normalization(mSet, "NULL", "NULL", "AutoNorm")

# feature = metabolites
mSet<-PlotNormSummary(mSet, "norm_0_", "png", 300, width=NA)

# sample 
mSet<-PlotSampleNormSummary(mSet, "snorm_0_", "png", 300, width=NA)

# 0 = group 1 / group 2
# 1 = group 2 / group 1

# group 1 = control
# group 2 = sars
mSet<-FC.Anal(mSet, 2.0, 1, FALSE) 
mSet<-PlotFC(mSet, "fc_1_", "png", 300, width=NA)


mSet<-Ttests.Anal(mSet, F, 0.05, FALSE, TRUE, "fdr", TRUE)

mSet<-PlotTT(mSet, "tt_2_", "png", 72, width=NA)



mSet<-Volcano.Anal(mSet, FALSE, 2.0, 1, F, 0.05, TRUE, "fdr")
mSet<-PlotVolcano(mSet, "volcano_1_",1, "png", 72, width=NA)


mSet<-PCA.Anal(mSet)
mSet<-PlotPCA2DScore(mSet, "pca_score2d_0_", "png", 300, width=NA, 1,2,0.95,0,0)

