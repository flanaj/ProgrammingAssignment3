---
title: "Codebook"
author: "JAF"
date: "8/30/2020"
output: html_document
---

# Analysis steps

* if zip file is not present download it
* if "UCI HAR Dataset" directory does not exist unzip downloaded file
* define dataframes and load data using the features dataset as the colun names for the X axis
  + features
  + activities
  + testSubject
  + testX
  + testY
  + trainSubject
  + trainX
  + trainY
* Merge X, Y, and Subject dataframes
  + X <- testX + trainX
  + Y <- testY + trainY
  + Subject <- testSubject + trainSubject
* add activity description to Y dataframe
  + mutate y add activity=activities[code,2]
* Complete the merge creating a single dataset
  + cbind X Y and Subject
* restrict data to required fields
  + select columns subject, code, activity, contains(mean), & contains(std)
* clean up column names
* groub by subject and activity 
* summarize means