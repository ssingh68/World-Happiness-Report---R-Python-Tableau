#Reading the CSV file

require(xlsx)
Happiness = read.xlsx("C:/Users/shrey/Desktop/Happiness.xlsx", sheetName = "2015-2017")

Happiness_Predicting = Happiness[ -c(1,2,3,4)]

#EDA
Num.cols <- sapply(Happiness, is.numeric)
Cor.data <- cor(Happiness[, Num.cols])
library(corrplot)
corrplot(Cor.data, method = 'color')  
#Obviously, there is an inverse correlation between "Happiness Rank"  and all the other
#numerical variables. In other words, the lower the happiness rank, the higher the happiness score,
#and the higher the other seven factors that contribute to happiness.
#So let's remove the happiness rank, and see the correlation again.

# Create a correlation plot
newdatacor = cor(Happiness[c(4:11)])
corrplot(newdatacor, method = "number")
#According to the above cor plot, Economy, life expectancy, and family play the most significant 
#role in contributing to happiness. Trust and generosity have the lowest impact on the happiness 
#score.

#Building Models
set.seed(12345)
n <- nrow(Happiness_Predicting)
Happiness_Upd <- Happiness_Predicting[sample(n), ]
train <- 1:round(0.7 * n)
Happiness_Train <- Happiness_Upd[train, ]
test <- (round(0.7 * n) + 1):n
Happiness_Test <- Happiness_Upd[test, ]

# Fitting Multiple Linear Regression to the Training set
regressor_lm = lm(formula = Happiness.Score ~ .,
                  data = Happiness_Train)

summary(regressor_lm)
#The summary shows that all independent variables have a significant impact, and adjusted R 
#squared is 1! As we discussed, it is clear that there is a linear correlation between dependent 
#and independent variables. Again, I should mention that the sum of the independent variables is 
#equal to the dependent variable which is the happiness score. This is the justification for having 
#an adjusted R squared equals to 1. As a result, I guess Multiple Linear Regression will predict 
#happiness scores with 100 % accuracy!

y_pred = predict(regressor_lm, newdata = Happiness_Test)

Pred <- as.data.frame(cbind(Prediction = y_pred, Actual = Happiness_Test$Happiness.Score))

library(ggplot2)
gg.lm <- ggplot(Pred, aes(Actual, Prediction )) +
  geom_point() + theme_bw() + geom_abline() +
  labs(title = "Multiple Linear Regression", x = "Actual happiness score",
       y = "Predicted happiness score") +
  theme(plot.title = element_text(family = "Helvetica", face = "bold", size = (15)), 
        axis.title = element_text(family = "Helvetica", size = (10)))
gg.lm

# Fitting Decision Tree Regression to the dataset
library(rpart)
regressor_dt = rpart(formula = Happiness.Score ~ .,
                     data = Happiness_Predicting,
                     control = rpart.control(minsplit = 10))

# Predicting a new result with Decision Tree Regression
y_pred_dt = predict(regressor_dt, newdata = Happiness_Test)

Pred_Actual_dt <- as.data.frame(cbind(Prediction = y_pred_dt, Actual = Happiness_Test$Happiness.Score))


gg.dt <- ggplot(Pred_Actual_dt, aes(Actual, Prediction )) +
  geom_point() + theme_bw() + geom_abline() +
  labs(title = "Decision Tree Regression", x = "Actual happiness score",
       y = "Predicted happiness score") +
  theme(plot.title = element_text(family = "Helvetica", face = "bold", size = (15)), 
        axis.title = element_text(family = "Helvetica", size = (10)))
gg.dt

#It seems that Decision Tree Regression is not an excellent choice for this dataset.
#Let's see the tree.

# Plotting the tree
library(rpart.plot)
prp(regressor_dt)

#Random Forest Regression

# Fitting Random Forest Regression to the dataset
library(randomForest)
set.seed(1234)
regressor_rf = randomForest(x = Happiness_Predicting[-1],
y = Happiness_Predicting$Happiness.Score,
ntree = 500)

# Predicting a new result with Random Forest Regression
y_pred_rf = predict(regressor_rf, newdata = Happiness_Test)

Pred_Actual_rf <- as.data.frame(cbind(Prediction = y_pred_rf, Actual = Happiness_Test$Happiness.Score))


gg.rf <- ggplot(Pred_Actual_rf, aes(Actual, Prediction )) +
geom_point() + theme_bw() + geom_abline() +
labs(title = "Random Forest Regression", x = "Actual happiness score",
y = "Predicted happiness score") +
theme(plot.title = element_text(family = "Helvetica", face = "bold", size = (15)), 
axis.title = element_text(family = "Helvetica", size = (10)))
gg.rf

#Randon Forest regression did a better job than Decision Tree in Predicting the Happiness Score.  
