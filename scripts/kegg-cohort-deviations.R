####
#
## PCA across keggs
##

setwd("~/Documents/KEGG-IEEE-BigData/")

df = read.csv("./data/table-kegg-clean.csv", header = TRUE, stringsAsFactors = FALSE)
smallest = sapply(df[,-1], FUN = function(x) min(x[which(x>0)]))
laplace_scale = .1*min(smallest)

keggs.LS.mad = apply(log10(laplace_scale+df[,grep("LS", names(df))]), 1, mad)
keggs.HE.mad = apply(log10(laplace_scale+df[,grep("HE", names(df))]), 1, mad)
keggs.CD.mad = apply(log10(laplace_scale+df[,grep("CD", names(df))]), 1, mad)
keggs.UC.mad = apply(log10(laplace_scale+df[,grep("UC", names(df))]), 1, mad)

df.mad = data.frame(kegg = df$X, LS.mad = keggs.LS.mad, HE.mad = keggs.HE.mad, CD.mad = keggs.CD.mad, UC.mad = keggs.UC.mad)

library(reshape)

df.mad.m = melt(df.mad, id.vars = "kegg")
library(plotly)

ggplot(df.mad.m, aes(x = kegg, y = value, colour = variable, alpha = .4)) + geom_point() +  theme(axis.title.x=element_blank(),
                                                                                      axis.text.x=element_blank(),
                                                                                      axis.ticks.x=element_blank())-> p

df.keggs.good.bad = read.csv("./KEGG-RF-conf-scores.csv", header = TRUE, stringsAsFactors = FALSE)
names(df)[1] = "kegg"
df.res = merge(df.keggs.good.bad, df)

keggs.LS.mad = apply(df.res[,grep("LS", names(df))], 1, sd)
keggs.HE.mad = apply(df.res[,grep("HE", names(df))], 1, sd)
keggs.CD.mad = apply(df.res[,grep("CD", names(df))], 1, sd)
keggs.UC.mad = apply(df.res[,grep("UC", names(df))], 1, sd)

df.mad = data.frame(kegg = df.res$kegg, LS.mad = keggs.LS.mad, HE.mad = keggs.HE.mad, CD.mad = keggs.CD.mad, UC.mad = keggs.UC.mad)

df.mad.sorted = df.mad[order(df.res$over.abundant.health.conf),]

df.mad.m = melt(df.mad.sorted, id.vars = "kegg")

ggplot(df.mad.m, aes(x = kegg, y = log10(1e-10+value), colour = variable)) + geom_point() +  theme(axis.title.x=element_blank(),
                                                                                                  axis.text.x=element_blank(),
                                                                                                  axis.ticks.x=element_blank())-> p


#plotly_POST(x = p, filename = "mad-keggs-cohorts", fileopt = "overwrite")

ggplot(df.mad.m, aes(x = kegg, y = value, colour = variable, alpha = .4)) + geom_point() +  theme(axis.title.x=element_blank(),
                                                                                                              axis.text.x=element_blank(),
                                                                                                              axis.ticks.x=element_blank())-> p