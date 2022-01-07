Cooking in Iron Pots for Iron Deficiency Anemia
================
Isabel Lebron

  

#### **Purpose:**

To compare the iron levels in 3 different dishes cooked in 3 different
pots **using a two-way ANOVA analysis**.

#### **Background Info:**

Iron deficiency anemia is the most common form of malnutrition in
developing countries, affecting about 50% of children and women and 25%
of men. Some research has suggested that food cooked in iron pots will
contain more iron than food cooked in other types of pots. To
investigate this, a study was designed to compare the iron content of
Ethiopian foods cooked in aluminum, clay, and iron pots. Three different
types of Ethiopian food were used; one with meat, one with legumes, and
the third with vegetables only. Four samples of each food were cooked in
each type of pot. The iron in the food was measured in milligrams of
iron per 100 grams of cooked food.  
  

#### Preparing the data:

``` r
cook <- read.csv("~/Desktop/Projects/cook.csv")
cook$dish <- factor(cook$dish, levels = c("meat", "legumes", "vegetable"))
cook$pot <- factor(cook$pot, levels = c("Aluminum", "Clay", "Iron"))
attach(cook)
head(cook)
```

    ##   obs      pot potid dish dishid iron
    ## 1   1 Aluminum     1 meat      1 1.77
    ## 2   2 Aluminum     1 meat      1 2.36
    ## 3   3 Aluminum     1 meat      1 1.96
    ## 4   4 Aluminum     1 meat      1 2.14
    ## 5   5     Clay     2 meat      1 2.27
    ## 6   6     Clay     2 meat      1 1.28

**Notes:** In the code above, I read the dataset into R and made both
predictor variables into factor objects. I then checked that my dataset
was correctly set up.  
  

#### Summary statistics:

``` r
cell.means <- tapply(cook$iron, list(cook$pot,cook$dish), mean)
round(cell.means, digits =2)
```

    ##          meat legumes vegetable
    ## Aluminum 2.06    2.33      1.23
    ## Clay     2.18    2.47      1.46
    ## Iron     4.68    3.67      2.79

``` r
cell.sds <- tapply(cook$iron, list(cook$pot,cook$dish), sd)
round(cell.sds, digits=2)
```

    ##          meat legumes vegetable
    ## Aluminum 0.25    0.11      0.23
    ## Clay     0.62    0.07      0.46
    ## Iron     0.63    0.17      0.24

**Notes:** Above, I obtained the means and standard deviations for each
cell using the tapply function.  
  

#### Plot of factor level means and the interaction plot

``` r
plot.design(iron ~ pot*dish)
interaction.plot(pot, dish, response = iron)
```

<img src="Iron-Pots_files/figure-gfm/unnamed-chunk-3-1.png" width="50%" /><img src="Iron-Pots_files/figure-gfm/unnamed-chunk-3-2.png" width="50%" />
**Notes:** Based on the interaction plot above, it can be seen that
there is some indication of a present interaction between the pot type
and the dish type.

  - The factor levels of legumes and vegetables are fairly parallel
    throughout all three types of pots. This shows little to no level of
    interaction between those terms.
  - The interaction line for meat is not parallel to either of the lines
    for vegetables or legumes, it even crosses the legumes lines as it
    approaches the iron factor. Due to this intersection, we are unable
    to get rid of the interaction.
  - We can also see that the difference between μ11 and μ12 will be
    negative and the same applies to the difference between μ21 and μ22.
  - On the other hand, the difference between μ31 and μ32 is positive,
    which implies that there is some level of interaction between the
    type of pot that was used and the dish cooked in those respective
    pots.  
      

#### Two-Way Analysis of Variance

``` r
fit<- aov(iron ~ pot + dish + pot:dish)
anova(fit)
```

    ## Analysis of Variance Table
    ## 
    ## Response: iron
    ##           Df  Sum Sq Mean Sq F value    Pr(>F)    
    ## pot        2 24.8940 12.4470  92.263 8.531e-13 ***
    ## dish       2  9.2969  4.6484  34.456 3.699e-08 ***
    ## pot:dish   4  2.6404  0.6601   4.893  0.004247 ** 
    ## Residuals 27  3.6425  0.1349                      
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

**Notes:** In the code above, I fit the two-way ANOVA model with
interaction to produce its regression coefficients, fitted values, and
residuals. After the model has been fit, I run the two-way ANOVA test
obtaining the ANOVA table providing an F value and a p-value.  
  

#### Hypothesis testing:

Below I will carry out a test of the interaction effect at alpha = .05.
From the ANOVA table obtained previously, under the null distribution,
the F statistic has degrees of freedom 4 and 27.  
  

**Null Hypothesis:** There is no interaction between the two factors  
**Alternative Hypothesis:** There is some interaction between the two
factors  
  

``` r
qf(.95, 4,27)
```

    ## [1] 2.727765

**Notes:** From the output above, the null hypothesis can be rejected if
the observed F statistic is above 2.727765. Taking a look at the ANOVA
table in the previous question, the observed F statistic is 4.893. This
value is clearly above the null F statistic, therefore we can reject the
null hypotheses that no interaction is present with 95% confidence.  
  

#### Confidence Intervals

Below, I will be using the Scheffe method with 90% overall coverage
level to form confidence intervals for the following four contrasts:

  - L1 = μ31-μ32
  - L2 = μ31-μ33
  - L3 = μ32-μ33
  - L4 = μ3.- \[(μ1.+μ2.)/2\]

<!-- end list -->

``` r
L1 <- 4.68-3.67; L1
```

    ## [1] 1.01

``` r
L2 <- 4.68-2.79; L2
```

    ## [1] 1.89

``` r
L3 <- 3.67-2.79; L3
```

    ## [1] 0.88

``` r
L4 <- 3.7133-((1.8733+2.0367)/2); L4
```

    ## [1] 1.7583

``` r
# The next step in finding the confidence intervals, is finding the variance: 
# Var(L1) = Var(L2) = Var(L3) = (σ^2/n)(Σcij)^2
Var <- (.1349/4)*(1^2 + 1^2); Var;SE <- sqrt(Var); SE
```

    ## [1] 0.06745

    ## [1] 0.2597114

``` r
# Var(L4) = (σ^2/b*n)(ΣΣcij)^2
VarL4 <- (.1349/(3*4))*(1+(1/4)+(1/4)); VarL4; SE.L4 <- sqrt(VarL4); SE.L4
```

    ## [1] 0.0168625

    ## [1] 0.1298557

``` r
# Obtaining the value of S
S <- sqrt(8*qf(.90,8,27)); S
```

    ## [1] 3.90803

``` r
# Allowance for 90% confidence intervals
S*SE;S*SE.L4
```

    ## [1] 1.01496

    ## [1] 0.5074799

``` r
# Confidence Intervals
CI1.lower <- 1.01-((0.2597114)*(3.90803));CI1.lower; CI1.upper <- 1.01+((0.2597114)*(3.90803));CI1.upper
```

    ## [1] -0.004959943

    ## [1] 2.02496

``` r
CI2.lower <- 1.89-((0.2597114)*(3.90803));CI2.lower; CI2.upper <- 1.89+((0.2597114)*(3.90803));CI2.upper
```

    ## [1] 0.8750401

    ## [1] 2.90496

``` r
CI3.lower <- .88-((0.2597114)*(3.90803));CI3.lower; CI3.upper <- .88+((0.2597114)*(3.90803));CI3.upper
```

    ## [1] -0.1349599

    ## [1] 1.89496

``` r
CI4.lower <- 1.758-((0.12986)*(3.90803));CI4.lower; CI4.upper <- 1.758+((0.12986)*(3.90803));CI4.upper
```

    ## [1] 1.250503

    ## [1] 2.265497

**Notes:** Based on the output from above, contrasts L1, L2, and L3 all
have the same standard error 0.2597114, and allowance for 90% confidence
intervals for these three contrasts is the value of S times the standard
error which is equal to 1.01496. Contrast L4 has a standard error of
0.12986 and 90% CI allowance is the value of S times 0.12986 which is
equal to 0.5075  
  
**Conclusion:** We are 90% confident that each of the four parameters is
within their given confidence intervals.

  - Since the intervals for L1 and L3 contain zero, there is no
    statistical significance between the cell means of the amount of
    iron the food contains from the iron pots that cooked meat and that
    of the iron pots that cooked legumes, and there is no statistical
    significance between the cell means of the amount of iron within the
    food when we are looking at the iron pot when cooking legumes and
    the iron pots when cooking vegetables.
  - Since the interval for the parameter L2 does not contain zero, there
    is statistical significance between the cell means for the level of
    iron produced by the iron pots that cooked meat and the iron pots
    that cooked vegetables.
  - The final confidence level for parameter L4 also does not contain
    zero, also implying statistical significant evidence that the
    average amount of iron in the cooked food when using the iron pots
    is greater than the equally weighted averages of iron in the food
    when it was cooked in the aluminum and clay pots.
