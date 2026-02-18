#set.seed(10)

# We import the data and give it's names
spambase.data <- read.table("spambase.data", sep = ",", dec = ".")
spambase.names <- read.table("spambase.names", comment.char = "|")
colnames(spambase.data) <- c(spambase.names[-1, 1], "class")


# We create the training and the testing matrixes
trainingBase <- spambase.data[
  sample(nrow(spambase.data), 0.9 * nrow(spambase.data)),
]
testBase <- spambase.data[-c(as.numeric(rownames(trainingBase))), ]

print(nrow(testBase) + nrow(trainingBase) == nrow(spambase.data))

# We create the relative frequencies of each piece of information
relativFreq <- matrix(0L, nrow = 3, ncol = ncol(spambase.data) - 1)
colnames(relativFreq) <- c(spambase.names[-1, 1])
rownames(relativFreq) <- c("Spam", "Ham", "Checker")


# We calculate the frequencies and number of Spam and Ham
NumberSpam <- sum(trainingBase[, "class"])
NumberHam <- nrow(trainingBase) - NumberSpam
ProbSpam <- mean(trainingBase[, "class"])
ProbHam <- 1 - ProbSpam


# We calculate the relative frequencies
for (i in spambase.names[-1, 1]) {
  relativFreq["Spam", i] <- sum(
    trainingBase[, i] > 0 & trainingBase[, "class"] == 1
  ) /
    NumberSpam
  relativFreq["Ham", i] <- sum(
    trainingBase[, i] > 0 & trainingBase[, "class"] == 0
  ) /
    NumberHam
  relativFreq["Checker", i] <- relativFreq["Spam", i] *
    NumberSpam +
    relativFreq["Ham", i] * NumberHam -
    sum(trainingBase[, i] > 0)
}


# We check the results
print(mean(relativFreq["Checker", ] < 10**-12) == 1)


# We create the matrix for classification of each mail in testBase
results <- matrix(0L, nrow = 2, ncol = nrow(testBase))
colnames(results) <- rownames(testBase)
rownames(results) <- c("Spam/Men", "Reality")
results["Reality", ] <- testBase[, "class"]

# This is the function that returns the probability of Spam with the training data, the names of the colums and a mail
probabilityOfVector <- function(data, names, vector) {
  relativFreq <- matrix(0L, nrow = 3, ncol = ncol(data) - 1)
  colnames(relativFreq) <- c(names[-1, 1])
  rownames(relativFreq) <- c("Spam", "Ham", "Checker")
  NumberSpam <- sum(data[, "class"])
  NumberHam <- nrow(data) - NumberSpam
  ProbSpam <- mean(data[, "class"])
  ProbHam <- 1 - ProbSpam
  for (i in names[-1, 1]) {
    relativFreq["Spam", i] <- sum(data[, i] > 0 & data[, "class"] == 1) /
      NumberSpam
    relativFreq["Ham", i] <- sum(data[, i] > 0 & data[, "class"] == 0) /
      NumberHam
    relativFreq["Checker", i] <- relativFreq["Spam", i] *
      NumberSpam +
      relativFreq["Ham", i] * NumberHam -
      sum(data[, i] > 0)
  }
  positiveSpam <- prod(relativFreq["Spam", ]**(vector > 0))
  negativeSpam <- prod((1 - relativFreq["Spam", ])**(vector == 0))
  MenIFSpam <- positiveSpam * negativeSpam
  positiveHam <- prod(relativFreq["Ham", ]**(vector > 0))
  negativeHam <- prod((1 - relativFreq["Ham", ])**(vector == 0))
  MenIFHam <- positiveHam * negativeHam
  return((MenIFSpam * ProbSpam) / (MenIFSpam * ProbSpam + MenIFHam * ProbHam))
}

# Use of the function
probabilityOfVector(
  trainingBase,
  spambase.names,
  testBase[1, -ncol(spambase.data)]
)

probabilitySpam <- function(vector) {
  positiveSpam <- prod(relativFreq["Spam", ]**(vector > 0))
  negativeSpam <- prod((1 - relativFreq["Spam", ])**(vector == 0))
  MenIFSpam <- positiveSpam * negativeSpam
  positiveHam <- prod(relativFreq["Ham", ]**(vector > 0))
  negativeHam <- prod((1 - relativFreq["Ham", ])**(vector == 0))
  MenIFHam <- positiveHam * negativeHam
  return((MenIFSpam * ProbSpam) / (MenIFSpam * ProbSpam + MenIFHam * ProbHam))
}

# We calculate the classification of each mail in testBase
results["Spam/Men", ] <- apply(
  X = testBase[, -ncol(testBase)],
  MARGIN = 1,
  FUN = probabilitySpam
)

#  We create the confusion matrix for 0.5
confusion <- matrix(0L, nrow = 2, ncol = 2)
rownames(confusion) <- c("PredSpam", "PredHam")
colnames(confusion) <- c("RealSpam", "RealHam")
confusion[1, 1] <- sum(results["Spam/Men", ] >= 0.5 & results["Reality", ] == 1)
confusion[1, 2] <- sum(results["Spam/Men", ] >= 0.5 & results["Reality", ] == 0)
confusion[2, 1] <- sum(results["Spam/Men", ] < 0.5 & results["Reality", ] == 1)
confusion[2, 2] <- sum(results["Spam/Men", ] < 0.5 & results["Reality", ] == 0)

print(confusion)

#  We create the graphdata
graphdata <- matrix(0L, nrow = 5, ncol = 99)
colnames(graphdata) <- (1:99) / 100
rownames(graphdata) <- c(
  "True positive",
  "False positive",
  "False negative",
  "True negative",
  "Total"
)


#  We calculate the graphdata
for (i in (1:99)) {
  graphdata["True positive", i] <- sum(
    results["Spam/Men", ] >= (i / 100) & results["Reality", ] == 1
  ) /
    nrow(testBase)
  graphdata["False positive", i] <- sum(
    results["Spam/Men", ] >= (i / 100) & results["Reality", ] == 0
  ) /
    nrow(testBase)
  graphdata["False negative", i] <- sum(
    results["Spam/Men", ] < (i / 100) & results["Reality", ] == 1
  ) /
    nrow(testBase)
  graphdata["True negative", i] <- sum(
    results["Spam/Men", ] < (i / 100) & results["Reality", ] == 0
  ) /
    nrow(testBase)
  graphdata["Total", i] <- graphdata["True positive", i] +
    graphdata["False positive", i] +
    graphdata["False negative", i] +
    graphdata["True negative", i]
}

print(mean(graphdata["Total", ]) == 1)
write.table(t(graphdata), file = "results.txt")

x <- (1:99) / 100
maximum <- max(graphdata["True positive", ] + graphdata["True negative", ])
minimum <- min(c(
  graphdata["True positive", ],
  graphdata["False positive", i],
  graphdata["False negative", i],
  graphdata["True negative", ]
))

#  We show the graphs
png("thresholds.png")
par(xpd = TRUE)

plot(
  x,
  graphdata["True positive", ],
  type = "o",
  main = "True positive",
  xlab = "Umbral",
  ylab = "Proporción",
  pch = 20,
  col = "blue"
)

plot(
  x,
  graphdata["True negative", ],
  type = "o",
  main = "True negative",
  xlab = "Umbral",
  ylab = "Proporción",
  pch = 20,
  col = "green"
)

plot(
  x,
  graphdata["True positive", ] + graphdata["True negative", ],
  type = "o",
  main = "Correctly clasified",
  xlab = "Umbral",
  ylab = "Proporción",
  pch = 20,
  col = "black"
)

plot(
  x,
  graphdata["True positive", ] + graphdata["True negative", ],
  ylim = c(minimum, maximum),
  type = "l",
  main = "Umbral vs Proporción",
  xlab = "Umbral",
  ylab = "Proporción",
  col = "black"
)
lines(x, graphdata["True positive", ], type = "l", col = "blue")
lines(x, graphdata["False positive", ], type = "l", col = "red")
lines(x, graphdata["False negative", ], type = "l", col = "brown")
lines(x, graphdata["True negative", ], col = "green")
legend(
  "topleft",
  inset = c(0, 0.15),
  legend = c(
    "Correctly clasified",
    "True positive",
    "False positive",
    "False negative",
    "True negative"
  ),
  col = c("black", "blue", "red", "brown", "green"),
  pch = 19
)
dev.off()

print(
  "Si quieres maximizar el número de mensajes correctamente indentificados como spam, el mejor o mejores valor para el umbral es:"
)
print(colnames(graphdata)[
  graphdata["True positive", ] == max(graphdata["True positive", ])
])

print(
  "Si quieres maximizar el número de mensajes correctamente indentificados como ham, el mejor o mejores valor para el umbral es:"
)
print(colnames(graphdata)[
  graphdata["True negative", ] == max(graphdata["True negative", ])
])

print(
  "Si quieres maximizar el número de mensajes correctamente clasificados, el mejor o mejores valor para el umbral es:"
)
print(colnames(graphdata)[
  graphdata["True positive", ] + graphdata["True negative", ] == maximum
])
