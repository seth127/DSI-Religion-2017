library(ggplot2)

data <- read.csv("~/Documents/Data Science/DataForGraphs.csv")

group <- data$Group
scored <- data$rank
predictions <- data$rfClassPred

data <- transform(data, group = reorder(group, scored))
p <- ggplot(data, aes(x = factor(group), y = scored, colour = group))
p + geom_boxplot()

q <- ggplot(data, aes(x = factor(group), y = predictions, colour = group))
q + geom_boxplot()

data <- transform(data, group = reorder(group, predictions))
s <- ggplot(data, aes(x = factor(scored), y = predictions, colour = scored))
s + geom_boxplot()

t <- ggplot(data, aes(x = factor(scored), y = predictions, colour = group))
t + geom_boxplot()

data <- transform(data, group = reorder(group, data$Difference))
r <- ggplot(data, aes(x = factor(scored), y = data$Difference, colour = group))
r + geom_boxplot()

q <- ggplot(data, aes(x = factor(scored), y = data$Difference))
q + geom_boxplot()


