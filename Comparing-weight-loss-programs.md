Comparison of weight-loss programs
================
Isabel Lebron

  

#### **Purpose:**

To compare weight-loss programs using Analysis of Variance

#### **Background Info:**

104 employees of the Children’s Hospital of Philadelphia, with BMIs of
30 to 40 kilograms per square meter (kg/m2), were each randomly assigned
to one of three weight-loss programs. Participants in the control
program were provided a link to weight-control information. Participants
in the individual-incentive program received this link but were also
told that $100 would be given to them each time they met or exceeded
their target monthly weight loss. Finally, participants in the
group-incentive program received similar information and financial
incentives as the individual-incentive program but were also told that
they were placed in secret groups of 5 and at the end of each 4-week
period, those in their group who met their goals throughout the period
would equally split an additional $500. The study ran for 24 weeks and
the total change in weight (in pounds) was recorded.  
  

#### Perparing the data:

``` r
setwd("~/Desktop/Projects")
wtloss <- read.csv("wtloss.csv",header=TRUE)
Trt <- factor(wtloss$Group,levels=c("Ctrl","Indiv","Grp"))
names(wtloss) <- c("Group","Change") 
wtloss$Trt <- Trt; rm(Trt)
```

**Notes:** Above I read in the data creates the dataframe. Additionally,
I specified the 3 different weight loss programs that are distinguished
under “Group” in the data set. I’ll call these levels, “Ctrl”, “Indiv”
and “Grp”. I then change the name of the response variable from “Loss”
to “Change” in the data set, since not everyone in the dataset is
necessarily losing weight.  
  

#### Summary statistics:

``` r
aggregate(Change~Trt,length,data=wtloss)
```

    ##     Trt Change
    ## 1  Ctrl     35
    ## 2 Indiv     35
    ## 3   Grp     34

``` r
aggregate(Change~Trt,mean,data=wtloss)
```

    ##     Trt     Change
    ## 1  Ctrl  -1.008571
    ## 2 Indiv  -3.708571
    ## 3   Grp -10.785294

``` r
aggregate(Change~Trt,sd,data=wtloss)
```

    ##     Trt    Change
    ## 1  Ctrl 11.500726
    ## 2 Indiv  9.078364
    ## 3   Grp 11.139151

**Notes:** In the code above, I split the data into subsets, computed
summary statistics for each, and returned the result in a convenient
form. I obtained the length of each group, the mean, as well as the
standard deviation.  
  

#### Plot of factor level means and the comparative boxplots for the three groups.

``` r
plot.design(Change ~ Trt, data=wtloss)
plot(Change ~ Trt, data=wtloss)  
```

<img src="Comparing-weight-loss-programs_files/figure-gfm/unnamed-chunk-3-1.png" width="50%" /><img src="Comparing-weight-loss-programs_files/figure-gfm/unnamed-chunk-3-2.png" width="50%" />  
**Notes:** Taking a look at the boxplots, It is very clear that for the
“Control” weight loss program, the median weight change is very close
to zero, seems to be around -1. Additionally, for the “Individual”
weightloss program, the median weight change seems to be around -5 which
also seems to be very close to being the middle of the two groups
“Control” and “Group”. With that being said, the “Group” median weight
loss change was the most obvious of the 3. It seems to be very close to
-10, hence why the “individual” group seems to be between “Control” and
“Group”.  
  

#### Analysis of Variance

``` r
wtloss.aov <- aov(Change ~ Trt, data=wtloss)
anova(wtloss.aov)
```

    ## Analysis of Variance Table
    ## 
    ## Response: Change
    ##            Df  Sum Sq Mean Sq F value    Pr(>F)    
    ## Trt         2  1752.6  876.30  7.7679 0.0007278 ***
    ## Residuals 101 11393.9  112.81                      
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

**Notes:** Above is the code used to fit the model so it produces its
regression coefficients, fitted values, and residuals. After the model
has been fit, I then run the one way ANOVA test which provides us with
an F value and a p-value.  
  
Below is the plot of residuals versus fitted values, and the
quantile-quantile plot of standardized residuals.

``` r
 plot(wtloss.aov,which=1)
 plot(wtloss.aov,which=2)
```

<img src="Comparing-weight-loss-programs_files/figure-gfm/unnamed-chunk-5-1.png" width="50%" /><img src="Comparing-weight-loss-programs_files/figure-gfm/unnamed-chunk-5-2.png" width="50%" />  
**Notes** The above plots are pretty useful for showing whether or not
the ANOVA assumptions are satisfied. First, the assumption that variance
is constant, can be seen to be satisfied from the plot of residuals. It
can be seen that for each group, there are a similar amount of positive
versus negative values on each side of the zero line. Additionally, when
taking a look at the normal Q-Q plot, our data is not only strongly
positively correlated but very close to the dotted y=x line in the
background which is normally distributed. Therefore, disregarding the
few outliers on the tail ends, it seems as though the error terms follow
a normal distribution.  
  

#### Hypothesis testing:

Below I will test whether or not the mean response is the same for the
four treatment groups using the cell means model, as well as the F test
for equality of factor level means.  
**Null Hypothesis:** μ1 = μ2 = μ3  
**Alternative Hypothesis:** At least two of the means are not equal.

``` r
# Obtaining F(r-1,nT-r)
qf(.95, df1=2, df2=101)
```

    ## [1] 3.086371

**Notes:** For an alpha = .05 hypothesis test, we will reject the null
hypthesis if Fobs is greater than 3.086371. Since Fobs = 7.7679 (from
ANOVA table), which is greater than 3.086371, we will reject the null
hypothesis.

``` r
#  finding the p-value with the test statistics
1-pf(7.7679, df1=2, df2=101)
```

    ## [1] 0.0007278328

**Notes:** Above, the p-value is calculated to be .0007 which matches
the p-value provided in the ANOVA table.  
  
**Conclusion:** Since the p-value of .0007 is less than the alpha level
of .05, we reject the null hypothesis. Therefore, we have enough
evidence to conclude that at least two of the means for the three
treatment groups differ.  
  

#### Confidence intervals

Below I will be finding confidence intervals for all pairwise
comparisons between the treatment means

``` r
TukeyHSD(wtloss.aov, conf.level = .95)
```

    ##   Tukey multiple comparisons of means
    ##     95% family-wise confidence level
    ## 
    ## Fit: aov(formula = Change ~ Trt, data = wtloss)
    ## 
    ## $Trt
    ##                 diff        lwr        upr     p adj
    ## Indiv-Ctrl -2.700000  -8.739576  3.3395765 0.5389107
    ## Grp-Ctrl   -9.776723 -15.860546 -3.6928996 0.0006641
    ## Grp-Indiv  -7.076723 -13.160546 -0.9928996 0.0183138

**Notes:** I can say with 95% confidence that all three of these
confidence intervals contain their restrictive parameter
