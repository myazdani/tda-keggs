## 


setwd("~/Documents/KEGG-IEEE-BigData/")

df.patients = read.csv("./data/table-kegg-clean-transpose.csv", header = TRUE, stringsAsFactors = FALSE)
names(df.patients)[1] = "cohort"
subject.names = df.patients$cohort
df.patients$cohort = "healthy"
df.patients$cohort[-grep("HE", subject.names)] = "disease"
#numeric.df = df.patients[,-c(1, ncol(df.patients))]

# library(rpart)
# fit <- rpart(cohort ~ ., method="class", data=df.patients[,-grep("subject", names(df.patients))], maxdepth= 3)
# library(rpart.plot)
# rpart.plot(fit, type = 4, extra = 2)

library(rpart)
fit <- rpart(subject.type ~ ., method="class", 
             data=df.patients[,-grep("cohort", names(df.patients))], maxdepth= 5, 
             control=rpart.control(minsplit=5, cp=0.01))
library(rpart.plot)
rpart.plot(fit, type = 4, extra = 2)

printcp(fit) # display the results 
plotcp(fit) # visualize cross-validation results 
summary(fit) # detailed summary of splits


df.keggs.good.bad = read.csv("./KEGG-RF-conf-scores.csv", header = TRUE, stringsAsFactors = FALSE)

fit <- rpart(subject.type ~ ., method="class", 
             data=df.patients[,c("subject.type", make.names(df.keggs.good.bad$kegg[c(1:10)]))], 
             maxdepth= 3,control=rpart.control(minsplit=5, cp=0.000001, maxdepth = 4))
rpart.plot(fit, type = 4, extra = 2)


printcp(fit) # display the results 
plotcp(fit) # visualize cross-validation results 
summary(fit) # detailed summary of splits
