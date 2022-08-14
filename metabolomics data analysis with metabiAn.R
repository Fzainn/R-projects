getwd()

library(dplyr)

# control 1

data1 <-read.csv("Control1.csv",TRUE,",")
head(data1)
p_con1 <- data1[data1$Transition.level..Sympol. == "P", ]
print(p_con1)

meta_abun_con1= p_con1 %>% select(Metabolite.ID, avr_high_sample)
colnames(meta_abun_con1)[2] <- "control1"

# control 2

data2 <-read.csv("Control2.csv",TRUE,",")
head(data2)
p_con2 <- data2[data2$Transition.level..Sympol. == "P", ]
print(p_con2)

meta_abun_con2= p_con2 %>% select(Metabolite.ID, avr_high_sample)
colnames(meta_abun_con2)[2] <- "control2"

# control 3

data3 <-read.csv("Control3.csv",TRUE,",")
head(data3)
p_con3 <- data3[data3$Transition.level..Sympol. == "P", ]
print(p_con3)

meta_abun_con3= p_con3 %>% select(Metabolite.ID, avr_high_sample)
colnames(meta_abun_con3)[2] <- "control3"

# merge control
#merge 3 df together for control samples
all.control <- merge(meta_abun_con1, meta_abun_con2, by="Metabolite.ID", all = T)
head(all.control)

all.control=merge(meta_abun_con3, all.control, by="Metabolite.ID", all = T)
head(all.control)
all.control <- all.control[!duplicated(all.control$Metabolite.ID),]

# is.na(any data frame) >>> will give you a TRUE or FALSE (TRUE if there are NAs values in the data frame)
all.control[is.na(all.control)] <- 0




# SARS1

data1<-read.csv("SARS1.csv",TRUE,",")
print(data1)
p_sars1<- data1[data1$Transition.level..Sympol. == "P", ]
print(p_sars1)

meta_abun_sars1= p_sars1 %>% select(Metabolite.ID, avr_high_sample)
colnames(meta_abun_sars1)[2] <- "sars1"

# SARS1

data2<-read.csv("SARS2.csv",TRUE,",")
print(data2)
p_sars2<- data2[data2$Transition.level..Sympol. == "P", ]
print(p_sars2)

meta_abun_sars2= p_sars2 %>% select(Metabolite.ID, avr_high_sample)
colnames(meta_abun_sars2)[2] <- "sars2"

# SARS1

data3<-read.csv("SARS3.csv",TRUE,",")
print(data3)
p_sars3<- data3[data3$Transition.level..Sympol. == "P", ]
print(p_sars3)

meta_abun_sars3= p_sars3 %>% select(Metabolite.ID, avr_high_sample)
colnames(meta_abun_sars3)[2] <- "sars3"


#merge 3 df sars samples
all.sars <- merge(meta_abun_sars1, meta_abun_sars2, by="Metabolite.ID", all = T)
head(all.sars)

all.sars <- merge(meta_abun_sars3, all.sars, by="Metabolite.ID", all = T)
head(all.sars)
all.sars <- all.sars[!duplicated(all.sars$Metabolite.ID),]

all.sars[is.na(all.sars)] <- 0


### all data

all.data <- merge(all.control, all.sars , by = "Metabolite.ID", all = TRUE)
head(all.data)

all.data[is.na(all.data)] <- 0
head(all.data)

write.csv(all.data, )

