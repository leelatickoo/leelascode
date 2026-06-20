# Leela's Code Dictionary

## Contents
-   [Data Cleaning](#datacleaning)
-   [Regressions](#regressions)

## Data Cleaning
<a id="datacleaning"></a>
### Dyplr
<details>
  
<summary>Single Table Manipulation</summary>
  
#### select()
use case: Keep or drop columns
``` {r eval = FALSE}
%>%
  select(colname)
  select(-colname)
```
### filter()
use case: Keep rows that match a condition

``` {r eval = FALSE}
%>%
  filter(colname %in% listvector)
  filter(colname == listvector)
  filter(is.na(colname))
  filter(between(colname, left, right))

#outside pipe operator
filter(dataframename, is.na(colname))
filter(dataframename,between(colname, lowerboundary, upperboundary))
```
[top](#contents)

</details>

## Regressions

<a id="regressions"></a>

<details>

<summary><strong>Regressions</strong></summary>

### Regressions - Multivariable - Continuous Outcome Var
Use cases: multivariable clustered regression, long data set

```{r eval = FALSE}
#package needed
library(fixest)

#creating the model
model <- feols(continuous_outcome ~ xvar1 + xvar2 + xvar3, data = df, cluster = ~ clustervar)
```

<details>
<summary>*Table Function*</summary>
```{r eval = FALSE}
#the leela special
feolstable <- function(m,repnum){
  namevector <- names(coef(m))
  pnames <- matrix(,nrow=repnum,ncol=length(namevector))
  oddsratios <- matrix(,nrow=repnum,ncol=length(namevector))
  for (i in repnum){
    pnames[i,] <- summary(m)$coeftable[, "Pr(>|t|)"]
    oddsratios[i,] <- exp(coef(m))
  }
  ps <- matrix(,nrow=repnum,ncol=length(namevector))
  dimnames(ps) <- list(NULL, namevector)
  or <- matrix(,nrow=repnum,ncol=length(namevector))
  dimnames(or) <- list(NULL, namevector)
  for (i in repnum) {
    p <- pnames[i,]
    ps[i,] <- ifelse(
      is.na(p), NA_character_,
      ifelse( p <0.001, "<0.001", 
              ifelse(p <= 0.05 & p >= 0.001, format(round(p,3), nsmall = 3), 
                     format(round(p,2),nsmall=2) )))
    o <- oddsratios[i,]
    or[i,] <- ifelse(
      is.na(o), NA_character_, format(round(o,2))
    )
  }
  #print("Odds Ratios")
  #print(or)
  #print("P-values")
  #print(ps)
  merged <- as.data.frame(rbind(or,ps))
  rownames(merged) <- c("Odds Ratios","P-values")
  return(merged)
}
```

</details>

### Logistic Regressions - Multivariable - Logistic - Binary Outcome Var

use cases: Logistic multivariable clustered regression, long data set

```{r eval = FALSE}
#package needed
library(fixest)

#creating the model
model <- feglm(outcome ~ xvar1 + xvar2 + xvar3, data = df, family = "logit", cluster = ~ clustervar)
```
<details>
<summary>*Table Function*</summary>
``` {r eval = FALSE}
#the leela special
glmtable <- function(m,repnum){
  lengthvect <- length(summary(m)$coefficients)
  pnames <- matrix(,nrow=repnum,ncol=lengthvect)
  oddsratios <- matrix(,nrow=repnum,ncol=lengthvect)
  for (i in repnum){
    pnames[i,] <- summary(m)$coeftable[, "Pr(>|z|)"]
    oddsratios[i,] <- exp(coef(m))
  }
  ps <- matrix(,nrow=repnum,ncol=lengthvect)
  dimnames(ps) <- list(NULL, names(coef(m)))
  or <- matrix(,nrow=repnum,ncol=lengthvect)
  dimnames(or) <- list(NULL, names(coef(m)))
for (i in seq_along(repnum)) {
  p <- pnames[i,]
  ps[i,] <- ifelse(
    is.na(p), NA_character_,
    ifelse( p <0.001, "<0.001", 
            ifelse(p <= 0.05 & p >= 0.001, format(round(p,3), nsmall = 3), format(round(p,2),nsmall=2) )))
  o <- oddsratios[i,]
  or[i,] <- ifelse(
    is.na(o), NA_character_, format(round(o,2))
  )
}
  #print("Odds Ratios")
  #print(or)
  #print("P-values")
  #print(ps)
  merged <- as.data.frame(rbind(or,ps))
  rownames(merged) <- c("Odds Ratios","P-values")
  return(merged)
}
```

</details>

### Mixed Effects

Use cases: mixed effects binomial regression, long dataset

```{r eval = FALSE}
#package needed
library(lme4)

#model template
model <- glmer(categorical_outcome ~ xvar1 + xvar2 + xvar3 + (1|random_effect_1) + (1|random_effect_2), data = df, family = binomial)
```

<details>
<summary>*Table Function*</summary>
``` {r eval = FALSE}
#table function
glmer_table <- function(m, repnum) {
  lengthvect <- length(summary(m)$coefficients) / ncol(summary(m)$coefficients)
  pnames <- matrix(, nrow = repnum, ncol = lengthvect)
  oddsratios <- matrix(, nrow = repnum, ncol = lengthvect)
  
  for (i in repnum) {
    pnames[i, ] <- summary(m)$coefficients[, "Pr(>|z|)"]
    oddsratios[i, ] <- exp(fixef(m))
  }
  
  ps <- matrix(, nrow = repnum, ncol = lengthvect)
  dimnames(ps) <- list(NULL, names(fixef(m)))
  or <- matrix(, nrow = repnum, ncol = lengthvect)
  dimnames(or) <- list(NULL, names(fixef(m)))
  
  for (i in seq_along(repnum)) {
    p <- pnames[i, ]
    ps[i, ] <- ifelse(
      is.na(p), NA_character_,
      ifelse(p < 0.001, "<0.001",
             ifelse(p <= 0.05 & p >= 0.001, format(round(p, 3), nsmall = 3), format(round(p, 2), nsmall = 2))))
    o <- oddsratios[i, ]
    or[i, ] <- ifelse(
      is.na(o), NA_character_, format(round(o, 2))
    )
  }
  
  merged <- as.data.frame(rbind(or, ps))
  rownames(merged) <- c("Odds Ratios", "P-values")
  return(merged)
}
```

</details>

### Multinomial

#### multinom()

Use cases: multinomial logistic regression

```{r eval = FALSE}
#package needed
library(nnet)

#model template
multinom(driver_seat ~ xvar1 + xvar2 + xvar3, data=df, cluster = ~clustervar)
```

<details>
<summary>*Table Function*</summary>
``` {r eval = FALSE}
multinomtable <- function(m) {
  s <- summary(m)
  coefs <- s$coefficients       
  ses   <- s$standard.errors   
  zvals <- coefs / ses
  pvals <- 2 * (1 - pnorm(abs(zvals)))
  oddsratios <- exp(coefs)
  #Format p-values
  ps <- matrix(NA, nrow = nrow(pvals), ncol = ncol(pvals))
  for (i in 1:nrow(pvals)) {
    for (j in 1:ncol(pvals)) {
      p <- pvals[i, j]
      ps[i, j] <- ifelse(
        is.na(p), NA,
        ifelse(p < 0.001, "<0.001",
               ifelse(p <= 0.05,
                      format(round(p, 3), nsmall = 3),
                      format(round(p, 2), nsmall = 2)))
      )}}
  # Format ORs
  or <- matrix(format(round(oddsratios, 2), nsmall = 2), nrow = nrow(oddsratios), ncol = ncol(oddsratios))
  #clean data
  rownames(ps) <- rownames(coefs)
  colnames(ps) <- colnames(coefs)
  rownames(or) <- rownames(coefs)
  colnames(or) <- colnames(coefs)
  
  #return(list(coefficients = coefs, odds_ratios = or,p_values = ps)) #this line doesn't help with table creation but is helpful
  merged <- as.data.frame(rbind(or, ps)) #I haven't checked whether this works or not
  rownames(merged) <- c("Odds Ratios", "P-values")
  return(merged)
}

```

</details>

</details>



