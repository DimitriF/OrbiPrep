---
output: html_document
---

## Introduction

Application to prepare session of tlc-ms interfacing.

## Installation

Install R
https://www.r-project.org/

In the console, install the package with those commands
```r
install.packages("shiny")
install.packages("rmarkdown")
install.packages("devtools")
devtools::install_github('DimitriF/DLC')
```

Then, run this command to launch the application
```r
shiny::runGitHub(repo='OrbiPrep', username='DimitriF',launch.browser=T)
```
