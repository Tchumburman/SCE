# ===========================================================================
# Module: References (APA-style bibliography, organized by module)
# ===========================================================================

# Helper: one hanging-indent reference block per module
ref_section <- function(title, icon_name, refs) {
  tagList(
    tags$h5(class = "mt-4 mb-2 border-bottom pb-1",
            icon(icon_name), HTML(paste0("&ensp;", title))),
    tags$div(
      class = "ps-3 mb-3",
      style = "line-height: 1.6;",
      lapply(refs, function(r) {
        tags$p(class = "mb-2",
               style = "text-indent: -2em; padding-left: 2em;",
               HTML(r))
      })
    )
  )
}

references_ui <- function(id) {
  ns <- NS(id)
  nav_panel_hidden(
  value = "References",
  class = "p-4",
  div(
    style = "max-width: 920px; margin: auto;",
    tags$h2(icon("book"), " References", class = "mb-2"),
    tags$p(class = "text-muted mb-4",
      "APA-style references for the statistical concepts, methods, and software
       demonstrated in each module of this application."
    ),

    # =====================================================================
    # GENERAL CONCEPTS
    # =====================================================================
    tags$h4(class = "mt-4 mb-3 text-primary",
            icon("lightbulb"), " General Concepts"),

    # -- Measurement Fundamentals --
    ref_section("Measurement Fundamentals", "ruler-horizontal", c(
      'Stevens, S. S. (1946). On the theory of scales of measurement. <em>Science, 103</em>(2684), 677&ndash;680.',
      'Messick, S. (1989). Validity. In R. L. Linn (Ed.), <em>Educational measurement</em> (3rd ed., pp. 13&ndash;103). American Council on Education/Macmillan.',
      'Messick, S. (1995). Validity of psychological assessment: Validation of inferences from persons&rsquo; responses and performances as scientific inquiry into score meaning. <em>American Psychologist, 50</em>(9), 741&ndash;749.',
      'Cronbach, L. J. (1951). Coefficient alpha and the internal structure of tests. <em>Psychometrika, 16</em>(3), 297&ndash;334.',
      'Campbell, D. T., &amp; Fiske, D. W. (1959). Convergent and discriminant validation by the multitrait-multimethod matrix. <em>Psychological Bulletin, 56</em>(2), 81&ndash;105.',
      'Lynn, M. R. (1986). Determination and quantification of content validity. <em>Nursing Research, 35</em>(6), 382&ndash;385.',
      'Cohen, J. (1960). A coefficient of agreement for nominal scales. <em>Educational and Psychological Measurement, 20</em>(1), 37&ndash;46.',
      'Landis, J. R., &amp; Koch, G. G. (1977). The measurement of observer agreement for categorical data. <em>Biometrics, 33</em>(1), 159&ndash;174.',
      'Nunnally, J. C., &amp; Bernstein, I. H. (1994). <em>Psychometric theory</em> (3rd ed.). McGraw-Hill.'
    )),

    # -- Data Quality --
    ref_section("Data Quality", "eye-slash", c(
      'Little, R. J. A., &amp; Rubin, D. B. (2019). <em>Statistical analysis with missing data</em> (3rd ed.). John Wiley &amp; Sons.',
      'van Buuren, S. (2018). <em>Flexible imputation of missing data</em> (2nd ed.). Chapman &amp; Hall/CRC. https://stefvanbuuren.name/fimd/',
      'Rubin, D. B. (1976). Inference and missing data. <em>Biometrika, 63</em>(3), 581&ndash;592.',
      'Barnett, V., &amp; Lewis, T. (1994). <em>Outliers in statistical data</em> (3rd ed.). John Wiley &amp; Sons.'
    )),

    # -- Multiple Imputation --
    ref_section("Multiple Imputation", "fill-drip", c(
      'Rubin, D. B. (1987). <em>Multiple imputation for nonresponse in surveys.</em> John Wiley &amp; Sons.',
      'van Buuren, S., &amp; Groothuis-Oudshoorn, K. (2011). mice: Multivariate imputation by chained equations in R. <em>Journal of Statistical Software, 45</em>(3), 1&ndash;67.',
      'van Buuren, S. (2018). <em>Flexible imputation of missing data</em> (2nd ed.). Chapman &amp; Hall/CRC.'
    )),

    # -- Statistical Phenomena --
    ref_section("Statistical Phenomena", "arrows-split-up-and-left", c(
      'Simpson, E. H. (1951). The interpretation of interaction in contingency tables. <em>Journal of the Royal Statistical Society: Series B, 13</em>(2), 238&ndash;241.',
      'Galton, F. (1886). Regression towards mediocrity in hereditary stature. <em>Journal of the Anthropological Institute of Great Britain and Ireland, 15</em>, 246&ndash;263.',
      'Pearl, J., Glymour, M., &amp; Jewell, N. P. (2016). <em>Causal inference in statistics: A primer.</em> John Wiley &amp; Sons.'
    )),

    # -- Data Preparation --
    ref_section("Data Preparation", "wand-magic-sparkles", c(
      'Box, G. E. P., &amp; Cox, D. R. (1964). An analysis of transformations. <em>Journal of the Royal Statistical Society: Series B, 26</em>(2), 211&ndash;252.',
      'Tukey, J. W. (1977). <em>Exploratory data analysis.</em> Addison-Wesley.',
      'Wickham, H. (2014). Tidy data. <em>Journal of Statistical Software, 59</em>(10), 1&ndash;23.'
    )),

    # -- Visualization Principles --
    ref_section("Visualization Principles", "palette", c(
      'Cleveland, W. S., &amp; McGill, R. (1984). Graphical perception: Theory, experimentation, and application to the development of graphical methods. <em>Journal of the American Statistical Association, 79</em>(387), 531&ndash;554.',
      'Tufte, E. R. (2001). <em>The visual display of quantitative information</em> (2nd ed.). Graphics Press.',
      'Wilke, C. O. (2019). <em>Fundamentals of data visualization: A primer on making informative and compelling figures.</em> O&rsquo;Reilly Media. https://clauswilke.com/dataviz/',
      'Wickham, H. (2016). <em>ggplot2: Elegant graphics for data analysis</em> (2nd ed.). Springer. https://ggplot2-book.org/',
      'Few, S. (2012). <em>Show me the numbers: Designing tables and graphs to enlighten</em> (2nd ed.). Analytics Press.'
    )),

    # -- Game Theory --
    ref_section("Game Theory", "chess", c(
      'von Neumann, J., &amp; Morgenstern, O. (1944). <em>Theory of games and economic behavior.</em> Princeton University Press.',
      'Nash, J. F. (1950). Equilibrium points in <em>n</em>-person games. <em>Proceedings of the National Academy of Sciences, 36</em>(1), 48&ndash;49.',
      'Axelrod, R. (1984). <em>The evolution of cooperation.</em> Basic Books.',
      'Maynard Smith, J. (1982). <em>Evolution and the theory of games.</em> Cambridge University Press.',
      'Osborne, M. J. (2004). <em>An introduction to game theory.</em> Oxford University Press.'
    )),

    # -- Information Theory --
    ref_section("Information Theory", "infinity", c(
      'Shannon, C. E. (1948). A mathematical theory of communication. <em>Bell System Technical Journal, 27</em>(3), 379&ndash;423.',
      'Cover, T. M., &amp; Thomas, J. A. (2006). <em>Elements of information theory</em> (2nd ed.). John Wiley &amp; Sons.',
      'Kullback, S., &amp; Leibler, R. A. (1951). On information and sufficiency. <em>Annals of Mathematical Statistics, 22</em>(1), 79&ndash;86.'
    )),

    # -- Signal Detection Theory --
    ref_section("Signal Detection Theory", "satellite-dish", c(
      'Green, D. M., &amp; Swets, J. A. (1966). <em>Signal detection theory and psychophysics.</em> John Wiley &amp; Sons.',
      'Macmillan, N. A., &amp; Creelman, C. D. (2005). <em>Detection theory: A user&rsquo;s guide</em> (2nd ed.). Lawrence Erlbaum Associates.',
      'Stanislaw, H., &amp; Todorov, N. (1999). Calculation of signal detection theory measures. <em>Behavior Research Methods, Instruments, &amp; Computers, 31</em>(1), 137&ndash;149.'
    )),

    # -- Interrater Reliability --
    ref_section("Interrater Reliability", "users-between-lines", c(
      'Cohen, J. (1960). A coefficient of agreement for nominal scales. <em>Educational and Psychological Measurement, 20</em>(1), 37&ndash;46.',
      'Fleiss, J. L. (1971). Measuring nominal scale agreement among many raters. <em>Psychological Bulletin, 76</em>(5), 378&ndash;382.',
      'Landis, J. R., &amp; Koch, G. G. (1977). The measurement of observer agreement for categorical data. <em>Biometrics, 33</em>(1), 159&ndash;174.',
      'Cicchetti, D. V., &amp; Feinstein, A. R. (1990). High agreement but low kappa: II. Resolving the paradoxes. <em>Journal of Clinical Epidemiology, 43</em>(6), 551&ndash;558.'
    )),

    # -- Text Analysis --
    ref_section("Text Analysis", "file-word", c(
      'Flesch, R. (1948). A new readability yardstick. <em>Journal of Applied Psychology, 32</em>(3), 221&ndash;233.',
      'Gunning, R. (1952). <em>The technique of clear writing.</em> McGraw-Hill.',
      'Silge, J., &amp; Robinson, D. (2017). <em>Text mining with R: A tidy approach.</em> O&rsquo;Reilly Media. https://www.tidytextmining.com/',
      'Hu, M., &amp; Liu, B. (2004). Mining and summarizing customer reviews. In <em>Proceedings of the 10th ACM SIGKDD International Conference on Knowledge Discovery and Data Mining</em> (pp. 168&ndash;177). ACM.',
      'Nielsen, F. &Aring;. (2011). A new ANEW: Evaluation of a word list for sentiment analysis in microblogs. In <em>Proceedings of the ESWC2011 Workshop on Making Sense of Microposts</em> (pp. 93&ndash;98).'
    )),

    # =====================================================================
    # DISTRIBUTIONS
    # =====================================================================
    tags$h4(class = "mt-4 mb-3 text-primary",
            icon("chart-area"), " Distributions"),

    # -- Distribution Shapes --
    ref_section("Distribution Shapes", "chart-area", c(
      'Johnson, N. L., Kotz, S., &amp; Balakrishnan, N. (1994). <em>Continuous univariate distributions</em> (Vol. 1, 2nd ed.). John Wiley &amp; Sons.',
      'Johnson, N. L., Kemp, A. W., &amp; Kotz, S. (2005). <em>Univariate discrete distributions</em> (3rd ed.). John Wiley &amp; Sons.',
      'Thode, H. C. (2002). <em>Testing for normality.</em> Marcel Dekker.'
    )),

    # -- Sampling Theorems --
    ref_section("Sampling Theorems", "layer-group", c(
      'Fischer, H. (2011). <em>A history of the central limit theorem: From classical to modern probability theory.</em> Springer.',
      'Casella, G., &amp; Berger, R. L. (2002). <em>Statistical inference</em> (2nd ed.). Duxbury/Thomson Learning.',
      'Sen, P. K., &amp; Singer, J. M. (1993). <em>Large sample methods in statistics: An introduction with applications.</em> Chapman &amp; Hall.'
    )),

    # -- Data Summary --
    ref_section("Data Summary", "list-ol", c(
      'Tukey, J. W. (1977). <em>Exploratory data analysis.</em> Addison-Wesley.',
      'Feller, W. (1968). <em>An introduction to probability theory and its applications</em> (Vol. 1, 3rd ed.). John Wiley &amp; Sons.',
      'Freedman, D., Pisani, R., &amp; Purves, R. (2007). <em>Statistics</em> (4th ed.). W. W. Norton.'
    )),

    # =====================================================================
    # SAMPLING & DESIGN
    # =====================================================================
    tags$h4(class = "mt-4 mb-3 text-primary",
            icon("object-group"), " Sampling & Design"),

    # -- Sampling --
    ref_section("Sampling", "object-group", c(
      'Cochran, W. G. (1977). <em>Sampling techniques</em> (3rd ed.). John Wiley &amp; Sons.',
      'Lohr, S. L. (2022). <em>Sampling: Design and analysis</em> (3rd ed.). Chapman &amp; Hall/CRC.',
      'Thompson, S. K. (2012). <em>Sampling</em> (3rd ed.). John Wiley &amp; Sons.'
    )),

    # -- Experimental Design --
    ref_section("Experimental Design", "flask", c(
      'Campbell, D. T., &amp; Stanley, J. C. (1963). <em>Experimental and quasi-experimental designs for research.</em> Houghton Mifflin.',
      'Kirk, R. E. (2013). <em>Experimental design: Procedures for the behavioral sciences</em> (4th ed.). SAGE Publications.',
      'Maxwell, S. E., Delaney, H. D., &amp; Kelley, K. (2018). <em>Designing experiments and analyzing data: A model comparison perspective</em> (3rd ed.). Routledge.',
      'Shadish, W. R., Cook, T. D., &amp; Campbell, D. T. (2002). <em>Experimental and quasi-experimental designs for generalized causal inference.</em> Houghton Mifflin.'
    )),

    # -- Survey Methodology --
    ref_section("Survey Methodology", "clipboard-list", c(
      'Groves, R. M., Fowler, F. J., Couper, M. P., Lepkowski, J. M., Singer, E., &amp; Tourangeau, R. (2009). <em>Survey methodology</em> (2nd ed.). John Wiley &amp; Sons.',
      'Kish, L. (1965). <em>Survey sampling.</em> John Wiley &amp; Sons.',
      'Lumley, T. (2010). <em>Complex surveys: A guide to analysis using R.</em> John Wiley &amp; Sons.',
      'Heeringa, S. G., West, B. T., &amp; Berglund, P. A. (2017). <em>Applied survey data analysis</em> (2nd ed.). Chapman &amp; Hall/CRC.'
    )),

    # =====================================================================
    # INFERENCE
    # =====================================================================
    tags$h4(class = "mt-4 mb-3 text-primary",
            icon("scale-balanced"), " Inference"),

    # -- Mean Comparisons --
    ref_section("Mean Comparisons", "not-equal", c(
      'Student. (1908). The probable error of a mean. <em>Biometrika, 6</em>(1), 1&ndash;25.',
      'Welch, B. L. (1947). The generalization of &ldquo;Student&rsquo;s&rdquo; problem when several different population variances are involved. <em>Biometrika, 34</em>(1&ndash;2), 28&ndash;35.',
      'Fisher, R. A. (1925). <em>Statistical methods for research workers.</em> Oliver &amp; Boyd.',
      'Wilcoxon, F. (1945). Individual comparisons by ranking methods. <em>Biometrics Bulletin, 1</em>(6), 80&ndash;83.'
    )),

    # -- Confidence & Resampling --
    ref_section("Confidence &amp; Resampling", "arrows-left-right", c(
      'Efron, B., &amp; Tibshirani, R. J. (1993). <em>An introduction to the bootstrap.</em> Chapman &amp; Hall/CRC.',
      'Neyman, J. (1937). Outline of a theory of statistical estimation based on the classical theory of probability. <em>Philosophical Transactions of the Royal Society of London. Series A, 236</em>(767), 333&ndash;380.',
      'Cumming, G. (2012). <em>Understanding the new statistics: Effect sizes, confidence intervals, and meta-analysis.</em> Routledge.',
      'Davison, A. C., &amp; Hinkley, D. V. (1997). <em>Bootstrap methods and their application.</em> Cambridge University Press.'
    )),

    # -- Categorical & Association --
    ref_section("Categorical &amp; Association", "table-cells", c(
      'Pearson, K. (1900). On the criterion that a given system of deviations from the probable in the case of a correlated system of variables is such that it can be reasonably supposed to have arisen from random sampling. <em>Philosophical Magazine, 50</em>(302), 157&ndash;175.',
      'Agresti, A. (2013). <em>Categorical data analysis</em> (3rd ed.). John Wiley &amp; Sons.',
      'Kendall, M. G. (1938). A new measure of rank correlation. <em>Biometrika, 30</em>(1&ndash;2), 81&ndash;93.',
      'Spearman, C. (1904). The proof and measurement of association between two things. <em>American Journal of Psychology, 15</em>(1), 72&ndash;101.'
    )),

    # -- Bayesian & Power --
    ref_section("Bayesian &amp; Power", "chart-pie", c(
      'Cohen, J. (1988). <em>Statistical power analysis for the behavioral sciences</em> (2nd ed.). Lawrence Erlbaum Associates.',
      'Kruschke, J. K. (2015). <em>Doing Bayesian data analysis: A tutorial with R, JAGS, and Stan</em> (2nd ed.). Academic Press.',
      'Murphy, K. R., Myors, B., &amp; Wolach, A. (2014). <em>Statistical power analysis: A simple and general model for traditional and modern hypothesis tests</em> (4th ed.). Routledge.'
    )),

    # -- Corrections & Robustness --
    ref_section("Corrections &amp; Robustness", "clone", c(
      'Benjamini, Y., &amp; Hochberg, Y. (1995). Controlling the false discovery rate: A practical and powerful approach to multiple testing. <em>Journal of the Royal Statistical Society: Series B, 57</em>(1), 289&ndash;300.',
      'Bonferroni, C. E. (1936). Teoria statistica delle classi e calcolo delle probabilit&agrave;. <em>Pubblicazioni del R Istituto Superiore di Scienze Economiche e Commerciali di Firenze, 8</em>, 3&ndash;62.',
      'Holm, S. (1979). A simple sequentially rejective multiple test procedure. <em>Scandinavian Journal of Statistics, 6</em>(2), 65&ndash;70.',
      'Wilcox, R. R. (2022). <em>Introduction to robust estimation and hypothesis testing</em> (5th ed.). Academic Press.'
    )),

    # -- Specialized Inference --
    ref_section("Specialized Inference", "heart-pulse", c(
      'Cox, D. R. (1972). Regression models and life-tables. <em>Journal of the Royal Statistical Society: Series B, 34</em>(2), 187&ndash;220.',
      'Kaplan, E. L., &amp; Meier, P. (1958). Nonparametric estimation from incomplete observations. <em>Journal of the American Statistical Association, 53</em>(282), 457&ndash;481.',
      'Borenstein, M., Hedges, L. V., Higgins, J. P. T., &amp; Rothstein, H. R. (2021). <em>Introduction to meta-analysis</em> (2nd ed.). John Wiley &amp; Sons.',
      'Higgins, J. P. T., &amp; Thompson, S. G. (2002). Quantifying heterogeneity in a meta-analysis. <em>Statistics in Medicine, 21</em>(11), 1539&ndash;1558.'
    )),

    # -- Sequential Testing --
    ref_section("Sequential Testing", "forward", c(
      'Wald, A. (1947). <em>Sequential analysis.</em> John Wiley &amp; Sons.',
      'O&rsquo;Brien, P. C., &amp; Fleming, T. R. (1979). A multiple testing procedure for clinical trials. <em>Biometrics, 35</em>(3), 549&ndash;556.',
      'Pocock, S. J. (1977). Group sequential methods in the design and analysis of clinical trials. <em>Biometrika, 64</em>(2), 191&ndash;199.',
      'Lan, K. K. G., &amp; DeMets, D. L. (1983). Discrete sequential boundaries for clinical trials. <em>Biometrika, 70</em>(3), 659&ndash;663.',
      'Gr&uuml;nwald, P. D., de Heide, R., &amp; Koolen, W. M. (2024). Safe testing. <em>Journal of the Royal Statistical Society: Series B, 86</em>(5), 1091&ndash;1128.'
    )),

    # -- Type I & II Errors --
    ref_section("Type I &amp; II Errors", "circle-exclamation", c(
      'Cohen, J. (1988). <em>Statistical power analysis for the behavioral sciences</em> (2nd ed.). Lawrence Erlbaum Associates.',
      'Neyman, J., &amp; Pearson, E. S. (1933). On the problem of the most efficient tests of statistical hypotheses. <em>Philosophical Transactions of the Royal Society of London. Series A, 231</em>, 289&ndash;337.'
    )),

    # -- Power: Complex Designs --
    ref_section("Power: Complex Designs", "bolt", c(
      'Cohen, J. (1988). <em>Statistical power analysis for the behavioral sciences</em> (2nd ed.). Lawrence Erlbaum Associates.',
      'Snijders, T. A. B., &amp; Bosker, R. J. (2012). <em>Multilevel analysis: An introduction to basic and advanced multilevel modeling</em> (2nd ed.). SAGE Publications.',
      'Sobel, M. E. (1982). Asymptotic confidence intervals for indirect effects in structural equation models. <em>Sociological Methodology, 13</em>, 290&ndash;312.',
      'Gelman, A., &amp; Loken, E. (2014). The statistical crisis in science. <em>American Scientist, 102</em>(6), 460&ndash;465.'
    )),

    # -- Replication & Open Science --
    ref_section("Replication &amp; Open Science", "unlock", c(
      'Open Science Collaboration. (2015). Estimating the reproducibility of psychological science. <em>Science, 349</em>(6251), aac4716.',
      'Ioannidis, J. P. A. (2005). Why most published research findings are false. <em>PLOS Medicine, 2</em>(8), e124.',
      'Nosek, B. A., Ebersole, C. R., DeHaven, A. C., &amp; Mellor, D. T. (2018). The preregistration revolution. <em>Proceedings of the National Academy of Sciences, 115</em>(11), 2600&ndash;2606.',
      'Schimmack, U. (2012). The ironic effect of significant results on the credibility of multiple-study articles. <em>Psychological Methods, 17</em>(4), 551&ndash;566.'
    )),

    # -- Clinical Trials --
    ref_section("Clinical Trials", "flask", c(
      'Friedman, L. M., Furberg, C. D., DeMets, D. L., Reboussin, D. M., &amp; Granger, C. B. (2015). <em>Fundamentals of clinical trials</em> (5th ed.). Springer.',
      'Schulz, K. F., Altman, D. G., &amp; Moher, D. (2010). CONSORT 2010 statement: Updated guidelines for reporting parallel group randomised trials. <em>BMJ, 340</em>, c332.',
      'Pallmann, P., Bedding, A. W., Choodari-Oskooei, B., Dimairo, M., Flight, L., Hampson, L. V., &hellip; Jaki, T. (2018). Adaptive designs in clinical trials: Why use them, and how to run and report them. <em>BMC Medicine, 16</em>(1), 29.'
    )),

    # -- Assumption Violations --
    ref_section("Assumption Violations", "triangle-exclamation", c(
      'Box, G. E. P. (1953). Non-normality and tests on variances. <em>Biometrika, 40</em>(3&ndash;4), 318&ndash;335.',
      'Glass, G. V., Peckham, P. D., &amp; Sanders, J. R. (1972). Consequences of failure to meet assumptions underlying the fixed effects analyses of variance and covariance. <em>Review of Educational Research, 42</em>(3), 237&ndash;288.',
      'Wilcox, R. R. (2022). <em>Introduction to robust estimation and hypothesis testing</em> (5th ed.). Academic Press.',
      'Osborne, J. W. (2010). Improving your data transformations: Applying the Box-Cox transformation. <em>Practical Assessment, Research, and Evaluation, 15</em>(12), 1&ndash;9.'
    )),

    # -- Causal Inference --
    ref_section("Causal Inference", "scale-unbalanced", c(
      'Pearl, J. (2009). <em>Causality: Models, reasoning, and inference</em> (2nd ed.). Cambridge University Press.',
      'Angrist, J. D., &amp; Pischke, J.-S. (2009). <em>Mostly harmless econometrics: An empiricist&rsquo;s companion.</em> Princeton University Press.',
      'Hern&aacute;n, M. A., &amp; Robins, J. M. (2020). <em>Causal inference: What if.</em> Chapman &amp; Hall/CRC.',
      'Imbens, G. W., &amp; Rubin, D. B. (2015). <em>Causal inference for statistics, social, and biomedical sciences: An introduction.</em> Cambridge University Press.',
      'Rosenbaum, P. R., &amp; Rubin, D. B. (1983). The central role of the propensity score in observational studies for causal effects. <em>Biometrika, 70</em>(1), 41&ndash;55.',
      'VanderWeele, T. J., &amp; Ding, P. (2017). Sensitivity analysis in observational research: Introducing the E-value. <em>Annals of Internal Medicine, 167</em>(4), 268&ndash;274.'
    )),

    # -- Effect Size Explorer --
    ref_section("Effect Size Explorer", "ruler-combined", c(
      'Cohen, J. (1988). <em>Statistical power analysis for the behavioral sciences</em> (2nd ed.). Lawrence Erlbaum Associates.',
      'Fritz, C. O., Morris, P. E., &amp; Richler, J. J. (2012). Effect size estimates: Current use, calculations, and interpretation. <em>Journal of Experimental Psychology: General, 141</em>(1), 2&ndash;18.',
      'Lakens, D. (2013). Calculating and reporting effect sizes to facilitate cumulative science: A practical primer for <em>t</em>-tests and ANOVAs. <em>Frontiers in Psychology, 4</em>, 863.'
    )),

    # -- Monte Carlo & Simulation --
    ref_section("Monte Carlo &amp; Simulation", "dice", c(
      'Robert, C. P., &amp; Casella, G. (2004). <em>Monte Carlo statistical methods</em> (2nd ed.). Springer.',
      'Good, P. I. (2005). <em>Permutation, parametric, and bootstrap tests of hypotheses</em> (3rd ed.). Springer.',
      'Mooney, C. Z. (1997). <em>Monte Carlo simulation.</em> SAGE Publications.'
    )),

    # -- Bayesian Workflow --
    ref_section("Bayesian Workflow", "chart-pie", c(
      'Gelman, A., Carlin, J. B., Stern, H. S., Dunson, D. B., Vehtari, A., &amp; Rubin, D. B. (2013). <em>Bayesian data analysis</em> (3rd ed.). Chapman &amp; Hall/CRC.',
      'McElreath, R. (2020). <em>Statistical rethinking: A Bayesian course with examples in R and Stan</em> (2nd ed.). Chapman &amp; Hall/CRC.',
      'Gelman, A., Vehtari, A., Simpson, D., Margossian, C. C., Carpenter, B., Yao, Y., Kennedy, L., Gabry, J., B&uuml;rkner, P.-C., &amp; Modr&aacute;k, M. (2020). Bayesian workflow. <em>arXiv preprint arXiv:2011.01808.</em>',
      'Metropolis, N., Rosenbluth, A. W., Rosenbluth, M. N., Teller, A. H., &amp; Teller, E. (1953). Equation of state calculations by fast computing machines. <em>The Journal of Chemical Physics, 21</em>(6), 1087&ndash;1092.'
    )),

    # -- p-Hacking Simulator --
    ref_section("p-Hacking Simulator", "wand-magic-sparkles", c(
      'Simmons, J. P., Nelson, L. D., &amp; Simonsohn, U. (2011). False-positive psychology: Undisclosed flexibility in data collection and analysis allows presenting anything as significant. <em>Psychological Science, 22</em>(11), 1359&ndash;1366.',
      'Gelman, A., &amp; Loken, E. (2014). The statistical crisis in science. <em>American Scientist, 102</em>(6), 460&ndash;465.',
      'Simonsohn, U., Nelson, L. D., &amp; Simmons, J. P. (2014). P-curve: A key to the file-drawer. <em>Journal of Experimental Psychology: General, 143</em>(2), 534&ndash;547.',
      'Steegen, S., Tuerlinckx, F., Gelman, A., &amp; Vanpaemel, W. (2016). Increasing transparency through a multiverse analysis. <em>Perspectives on Psychological Science, 11</em>(5), 702&ndash;712.',
      'Ioannidis, J. P. A. (2005). Why most published research findings are false. <em>PLOS Medicine, 2</em>(8), e124.'
    )),

    # =====================================================================
    # MODELING
    # =====================================================================
    tags$h4(class = "mt-4 mb-3 text-primary",
            icon("chart-line"), " Modeling"),

    # -- Regression Core --
    ref_section("Regression Core", "chart-line", c(
      'Fox, J. (2016). <em>Applied regression analysis and generalized linear models</em> (3rd ed.). SAGE Publications.',
      'McCullagh, P., &amp; Nelder, J. A. (1989). <em>Generalized linear models</em> (2nd ed.). Chapman &amp; Hall/CRC.',
      'Myung, I. J. (2003). Tutorial on maximum likelihood estimation. <em>Journal of Mathematical Psychology, 47</em>(1), 90&ndash;100.',
      'Agresti, A. (2015). <em>Foundations of linear and generalized linear models.</em> John Wiley &amp; Sons.'
    )),

    # -- Model Diagnostics --
    ref_section("Model Diagnostics", "triangle-exclamation", c(
      'Cook, R. D. (1977). Detection of influential observation in linear regression. <em>Technometrics, 19</em>(1), 15&ndash;18.',
      'Hoerl, A. E., &amp; Kennard, R. W. (1970). Ridge regression: Biased estimation for nonorthogonal problems. <em>Technometrics, 12</em>(1), 55&ndash;67.',
      'Tibshirani, R. (1996). Regression shrinkage and selection via the lasso. <em>Journal of the Royal Statistical Society: Series B, 58</em>(1), 267&ndash;288.',
      'Zou, H., &amp; Hastie, T. (2005). Regularization and variable selection via the elastic net. <em>Journal of the Royal Statistical Society: Series B, 67</em>(2), 301&ndash;320.'
    )),

    # -- Multilevel Models --
    ref_section("Multilevel Models", "sitemap", c(
      'Raudenbush, S. W., &amp; Bryk, A. S. (2002). <em>Hierarchical linear models: Applications and data analysis methods</em> (2nd ed.). SAGE Publications.',
      'Hox, J. J., Moerbeek, M., &amp; van de Schoot, R. (2018). <em>Multilevel analysis: Techniques and applications</em> (3rd ed.). Routledge.',
      'Snijders, T. A. B., &amp; Bosker, R. J. (2012). <em>Multilevel analysis: An introduction to basic and advanced multilevel modeling</em> (2nd ed.). SAGE Publications.',
      'Gelman, A., &amp; Hill, J. (2007). <em>Data analysis using regression and multilevel/hierarchical models.</em> Cambridge University Press.'
    )),

    # -- Extended Models --
    ref_section("Extended Models", "layer-group", c(
      'Agresti, A. (2010). <em>Analysis of ordinal categorical data</em> (2nd ed.). John Wiley &amp; Sons.',
      'Huber, P. J. (1981). <em>Robust statistics.</em> John Wiley &amp; Sons.',
      'Maronna, R. A., Martin, R. D., Yohai, V. J., &amp; Salibi&aacute;n-Barrera, M. (2019). <em>Robust statistics: Theory and methods (with R)</em> (2nd ed.). John Wiley &amp; Sons.',
      'Venables, W. N., &amp; Ripley, B. D. (2002). <em>Modern applied statistics with S</em> (4th ed.). Springer.'
    )),

    # -- Mediation & Moderation --
    ref_section("Mediation &amp; Moderation", "arrows-split-up-and-left", c(
      'Baron, R. M., &amp; Kenny, D. A. (1986). The moderator&ndash;mediator variable distinction in social psychological research: Conceptual, strategic, and statistical considerations. <em>Journal of Personality and Social Psychology, 51</em>(6), 1173&ndash;1182.',
      'Hayes, A. F. (2022). <em>Introduction to mediation, moderation, and conditional process analysis: A regression-based approach</em> (3rd ed.). Guilford Press.',
      'Preacher, K. J., &amp; Hayes, A. F. (2008). Asymptotic and resampling strategies for assessing and comparing indirect effects in multiple mediator models. <em>Behavior Research Methods, 40</em>(3), 879&ndash;891.',
      'Johnson, P. O., &amp; Neyman, J. (1936). Tests of certain linear hypotheses and their application to some educational problems. <em>Statistical Research Memoirs, 1</em>, 57&ndash;93.'
    )),

    # -- Time Series --
    ref_section("Time Series", "chart-line", c(
      'Box, G. E. P., Jenkins, G. M., Reinsel, G. C., &amp; Ljung, G. M. (2015). <em>Time series analysis: Forecasting and control</em> (5th ed.). John Wiley &amp; Sons.',
      'Hyndman, R. J., &amp; Athanasopoulos, G. (2021). <em>Forecasting: Principles and practice</em> (3rd ed.). OTexts. https://otexts.com/fpp3/',
      'Cleveland, R. B., Cleveland, W. S., McRae, J. E., &amp; Terpenning, I. (1990). STL: A seasonal-trend decomposition procedure based on loess. <em>Journal of Official Statistics, 6</em>(1), 3&ndash;73.'
    )),

    # -- Count Data Models --
    ref_section("Count Data Models", "hashtag", c(
      'Cameron, A. C., &amp; Trivedi, P. K. (2013). <em>Regression analysis of count data</em> (2nd ed.). Cambridge University Press.',
      'Hilbe, J. M. (2011). <em>Negative binomial regression</em> (2nd ed.). Cambridge University Press.',
      'Lambert, D. (1992). Zero-inflated Poisson regression, with an application to defects in manufacturing. <em>Technometrics, 34</em>(1), 1&ndash;14.'
    )),

    # -- GAMs --
    ref_section("GAMs", "wave-square", c(
      'Wood, S. N. (2017). <em>Generalized additive models: An introduction with R</em> (2nd ed.). Chapman &amp; Hall/CRC.',
      'Hastie, T. J., &amp; Tibshirani, R. J. (1990). <em>Generalized additive models.</em> Chapman &amp; Hall.',
      'Ruppert, D., Wand, M. P., &amp; Carroll, R. J. (2003). <em>Semiparametric regression.</em> Cambridge University Press.'
    )),

    # -- Quantile Regression --
    ref_section("Quantile Regression", "chart-bar", c(
      'Koenker, R. (2005). <em>Quantile regression.</em> Cambridge University Press.',
      'Koenker, R., &amp; Bassett, G. (1978). Regression quantiles. <em>Econometrica, 46</em>(1), 33&ndash;50.',
      'Koenker, R., &amp; Hallock, K. F. (2001). Quantile regression. <em>Journal of Economic Perspectives, 15</em>(4), 143&ndash;156.'
    )),

    # -- GEE --
    ref_section("GEE", "people-arrows", c(
      'Liang, K.-Y., &amp; Zeger, S. L. (1986). Longitudinal data analysis using generalized linear models. <em>Biometrika, 73</em>(1), 13&ndash;22.',
      'Zeger, S. L., &amp; Liang, K.-Y. (1986). Longitudinal data analysis for discrete and continuous outcomes. <em>Biometrics, 42</em>(1), 121&ndash;130.',
      'Hardin, J. W., &amp; Hilbe, J. M. (2013). <em>Generalized estimating equations</em> (2nd ed.). Chapman &amp; Hall/CRC.'
    )),

    # =====================================================================
    # MULTIVARIATE
    # =====================================================================
    tags$h4(class = "mt-4 mb-3 text-primary",
            icon("project-diagram"), " Multivariate"),

    # -- Dimension Reduction --
    ref_section("Dimension Reduction", "project-diagram", c(
      'Jolliffe, I. T. (2002). <em>Principal component analysis</em> (2nd ed.). Springer.',
      'Fabrigar, L. R., &amp; Wegener, D. T. (2012). <em>Exploratory factor analysis.</em> Oxford University Press.',
      'Borg, I., &amp; Groenen, P. J. F. (2005). <em>Modern multidimensional scaling: Theory and applications</em> (2nd ed.). Springer.',
      'Greenacre, M. (2017). <em>Correspondence analysis in practice</em> (3rd ed.). Chapman &amp; Hall/CRC.'
    )),

    # -- Clustering & Classification --
    ref_section("Clustering &amp; Classification", "circle-nodes", c(
      'Kaufman, L., &amp; Rousseeuw, P. J. (2005). <em>Finding groups in data: An introduction to cluster analysis.</em> John Wiley &amp; Sons.',
      'Tibshirani, R., Walther, G., &amp; Hastie, T. (2001). Estimating the number of clusters in a data set via the gap statistic. <em>Journal of the Royal Statistical Society: Series B, 63</em>(2), 411&ndash;423.',
      'McLachlan, G. J. (2004). <em>Discriminant analysis and statistical pattern recognition.</em> John Wiley &amp; Sons.'
    )),

    # -- Structural Models --
    ref_section("Structural Models", "diagram-project", c(
      'Kline, R. B. (2016). <em>Principles and practice of structural equation modeling</em> (4th ed.). Guilford Press.',
      'Bollen, K. A. (1989). <em>Structural equations with latent variables.</em> John Wiley &amp; Sons.',
      'Epskamp, S., Borsboom, D., &amp; Fried, E. I. (2018). Estimating psychological networks and their accuracy: A tutorial paper. <em>Behavior Research Methods, 50</em>(1), 195&ndash;212.',
      'Hu, L., &amp; Bentler, P. M. (1999). Cutoff criteria for fit indexes in covariance structure analysis: Conventional criteria versus new alternatives. <em>Structural Equation Modeling, 6</em>(1), 1&ndash;55.'
    )),

    # -- Latent Class Analysis --
    ref_section("Latent Class Analysis", "object-ungroup", c(
      'Hagenaars, J. A., &amp; McCutcheon, A. L. (Eds.). (2002). <em>Applied latent class analysis.</em> Cambridge University Press.',
      'Collins, L. M., &amp; Lanza, S. T. (2010). <em>Latent class and latent transition analysis: With applications in the social, behavioral, and health sciences.</em> John Wiley &amp; Sons.',
      'McLachlan, G. J., &amp; Peel, D. (2000). <em>Finite mixture models.</em> John Wiley &amp; Sons.',
      'Dempster, A. P., Laird, N. M., &amp; Rubin, D. B. (1977). Maximum likelihood from incomplete data via the EM algorithm. <em>Journal of the Royal Statistical Society: Series B, 39</em>(1), 1&ndash;38.'
    )),

    # -- Growth Mixture Models --
    ref_section("Growth Mixture Models", "chart-line", c(
      'Muth&eacute;n, B. (2004). Latent variable analysis: Growth mixture modeling and related techniques for longitudinal data. In D. Kaplan (Ed.), <em>The SAGE handbook of quantitative methodology for the social sciences</em> (pp. 345&ndash;368). SAGE Publications.',
      'Nagin, D. S. (2005). <em>Group-based modeling of development.</em> Harvard University Press.',
      'Ram, N., &amp; Grimm, K. J. (2009). Growth mixture modeling: A method for identifying differences in longitudinal change among unobserved groups. <em>International Journal of Behavioral Development, 33</em>(6), 565&ndash;576.'
    )),

    # =====================================================================
    # MACHINE LEARNING
    # =====================================================================
    tags$h4(class = "mt-4 mb-3 text-primary",
            icon("robot"), " Machine Learning"),

    # -- ML Algorithms --
    ref_section("ML Algorithms", "robot", c(
      'Hastie, T., Tibshirani, R., &amp; Friedman, J. (2009). <em>The elements of statistical learning: Data mining, inference, and prediction</em> (2nd ed.). Springer.',
      'Breiman, L. (2001). Random forests. <em>Machine Learning, 45</em>(1), 5&ndash;32.',
      'Cortes, C., &amp; Vapnik, V. (1995). Support-vector networks. <em>Machine Learning, 20</em>(3), 273&ndash;297.',
      'Breiman, L., Friedman, J. H., Olshen, R. A., &amp; Stone, C. J. (1984). <em>Classification and regression trees.</em> Wadsworth.'
    )),

    # -- Model Evaluation --
    ref_section("Model Evaluation", "chart-area", c(
      'James, G., Witten, D., Hastie, T., &amp; Tibshirani, R. (2021). <em>An introduction to statistical learning: With applications in R</em> (2nd ed.). Springer.',
      'Kuhn, M., &amp; Johnson, K. (2013). <em>Applied predictive modeling.</em> Springer.',
      'Geman, S., Bienenstock, E., &amp; Doursat, R. (1992). Neural networks and the bias/variance dilemma. <em>Neural Computation, 4</em>(1), 1&ndash;58.',
      'Fawcett, T. (2006). An introduction to ROC analysis. <em>Pattern Recognition Letters, 27</em>(8), 861&ndash;874.'
    )),

    # -- AI & LLMs --
    ref_section("AI &amp; LLMs", "microchip", c(
      'Vaswani, A., Shazeer, N., Parmar, N., Uszkoreit, J., Jones, L., Gomez, A. N., Kaiser, &Lstrok;., &amp; Polosukhin, I. (2017). Attention is all you need. In <em>Advances in Neural Information Processing Systems</em> (Vol. 30). Curran Associates.',
      'Kaplan, J., McCandlish, S., Henighan, T., Brown, T. B., Chess, B., Child, R., Gray, S., Radford, A., Wu, J., &amp; Amodei, D. (2020). Scaling laws for neural language models. <em>arXiv preprint arXiv:2001.08361.</em>',
      'Hoffmann, J., Borgeaud, S., Mensch, A., Buchatskaya, E., Cai, T., Rutherford, E., &hellip; Sifre, L. (2022). Training compute-optimal large language models. <em>arXiv preprint arXiv:2203.15556.</em>',
      'Goodfellow, I., Bengio, Y., &amp; Courville, A. (2016). <em>Deep learning.</em> MIT Press.'
    )),

    # =====================================================================
    # PSYCHOMETRICS
    # =====================================================================
    tags$h4(class = "mt-4 mb-3 text-primary",
            icon("brain"), " Psychometrics"),

    # -- IRT Models --
    ref_section("IRT Models", "wave-square", c(
      'de Ayala, R. J. (2022). <em>The theory and practice of item response theory</em> (2nd ed.). Guilford Press.',
      'Embretson, S. E., &amp; Reise, S. P. (2000). <em>Item response theory for psychologists.</em> Lawrence Erlbaum Associates.',
      'van der Linden, W. J. (Ed.). (2016). <em>Handbook of item response theory</em> (Vols. 1&ndash;3). Chapman &amp; Hall/CRC.',
      'Samejima, F. (1969). Estimation of latent ability using a response pattern of graded scores. <em>Psychometrika Monograph Supplement, 34</em>(4, Pt. 2), 1&ndash;97.'
    )),

    # -- Rasch Family --
    ref_section("Rasch Family", "stairs", c(
      'Rasch, G. (1960). <em>Probabilistic models for some intelligence and attainment tests.</em> Danish Institute for Educational Research.',
      'Wright, B. D., &amp; Stone, M. H. (1979). <em>Best test design.</em> MESA Press.',
      'Linacre, J. M. (1994). Many-facet Rasch measurement. <em>Rasch Measurement Transactions, 8</em>(2), 362&ndash;363.',
      'Bond, T. G., &amp; Fox, C. M. (2015). <em>Applying the Rasch model: Fundamental measurement in the human sciences</em> (3rd ed.). Routledge.'
    )),

    # -- Test & Item Quality --
    ref_section("Test &amp; Item Quality", "microscope", c(
      'Cronbach, L. J. (1951). Coefficient alpha and the internal structure of tests. <em>Psychometrika, 16</em>(3), 297&ndash;334.',
      'McDonald, R. P. (1999). <em>Test theory: A unified treatment.</em> Lawrence Erlbaum Associates.',
      'Revelle, W., &amp; Zinbarg, R. E. (2009). Coefficients alpha, beta, omega, and the glb: Comments on Sijtsma. <em>Psychometrika, 74</em>(1), 145&ndash;154.',
      'DeVellis, R. F., &amp; Thorpe, C. T. (2022). <em>Scale development: Theory and applications</em> (5th ed.). SAGE Publications.'
    )),

    # -- Scoring & Reporting --
    ref_section("Scoring &amp; Reporting", "ruler-combined", c(
      'Crocker, L., &amp; Algina, J. (2008). <em>Introduction to classical and modern test theory.</em> Cengage Learning.',
      'Kolen, M. J., &amp; Brennan, R. L. (2014). <em>Test equating, scaling, and linking: Methods and practices</em> (3rd ed.). Springer.',
      'Embretson, S. E., &amp; Reise, S. P. (2000). <em>Item response theory for psychologists.</em> Lawrence Erlbaum Associates.'
    )),

    # -- Fairness & Bias --
    ref_section("Fairness &amp; Bias", "scale-balanced", c(
      'Holland, P. W., &amp; Wainer, H. (Eds.). (1993). <em>Differential item functioning.</em> Lawrence Erlbaum Associates.',
      'Cleary, T. A. (1968). Test bias: Prediction of grades of Negro and White students in integrated colleges. <em>Journal of Educational Measurement, 5</em>(2), 115&ndash;124.',
      'Meijer, R. R., &amp; Sijtsma, K. (2001). Methodology review: Evaluating person fit. <em>Applied Psychological Measurement, 25</em>(2), 107&ndash;135.',
      'Camilli, G. (2006). Test fairness. In R. L. Brennan (Ed.), <em>Educational measurement</em> (4th ed., pp. 221&ndash;256). American Council on Education/Praeger.'
    )),

    # -- Equating & Linking --
    ref_section("Equating &amp; Linking", "link", c(
      'Kolen, M. J., &amp; Brennan, R. L. (2014). <em>Test equating, scaling, and linking: Methods and practices</em> (3rd ed.). Springer.',
      'von Davier, A. A. (Ed.). (2011). <em>Statistical models for test equating, scaling, and linking.</em> Springer.',
      'Stocking, M. L., &amp; Lord, F. M. (1983). Developing a common metric in item response theory. <em>Applied Psychological Measurement, 7</em>(2), 201&ndash;210.'
    )),

    # -- Adaptive Testing --
    ref_section("Adaptive Testing", "robot", c(
      'van der Linden, W. J., &amp; Glas, C. A. W. (Eds.). (2010). <em>Elements of adaptive testing.</em> Springer.',
      'Wainer, H. (Ed.). (2000). <em>Computerized adaptive testing: A primer</em> (2nd ed.). Lawrence Erlbaum Associates.',
      'Thompson, N. A., &amp; Weiss, D. J. (2011). A framework for the development of computerized adaptive tests. <em>Practical Assessment, Research, and Evaluation, 16</em>(1), 1&ndash;9.',
      'Wald, A. (1947). <em>Sequential analysis.</em> John Wiley &amp; Sons.'
    )),

    # -- Validity & Measurement --
    ref_section("Validity &amp; Measurement", "check-double", c(
      'Campbell, D. T., &amp; Fiske, D. W. (1959). Convergent and discriminant validation by the multitrait-multimethod matrix. <em>Psychological Bulletin, 56</em>(2), 81&ndash;105.',
      'Meredith, W. (1993). Measurement invariance, factor analysis and factorial invariance. <em>Psychometrika, 58</em>(4), 525&ndash;543.',
      'Messick, S. (1995). Validity of psychological assessment: Validation of inferences from persons&rsquo; responses and performances as scientific inquiry into score meaning. <em>American Psychologist, 50</em>(9), 741&ndash;749.',
      'Brown, T. A. (2015). <em>Confirmatory factor analysis for applied research</em> (2nd ed.). Guilford Press.'
    )),

    # -- Advanced Models --
    ref_section("Advanced Psychometric Models", "brain", c(
      'de la Torre, J. (2011). The generalized DINA model framework. <em>Psychometrika, 76</em>(2), 179&ndash;199.',
      'Brennan, R. L. (2001). <em>Generalizability theory.</em> Springer.',
      'Gierl, M. J., &amp; Haladyna, T. M. (Eds.). (2013). <em>Automatic item generation: Theory and practice.</em> Routledge.',
      'Rupp, A. A., Templin, J., &amp; Henson, R. A. (2010). <em>Diagnostic measurement: Theory, methods, and applications.</em> Guilford Press.'
    )),

    # -- Large-Scale Assessment --
    ref_section("Large-Scale Assessment", "dice-d20", c(
      'Mislevy, R. J., Beaton, A. E., Kaplan, B., &amp; Sheehan, K. M. (1992). Estimating population characteristics from sparse matrix samples of item responses. <em>Journal of Educational Measurement, 29</em>(2), 133&ndash;161.',
      'von Davier, M., Gonzalez, E., &amp; Mislevy, R. J. (2009). What are plausible values and why are they useful? In M. von Davier &amp; D. Hastedt (Eds.), <em>IERI Monograph Series</em> (Vol. 2, pp. 9&ndash;36). IEA-ETS Research Institute.',
      'Cizek, G. J., &amp; Bunch, M. B. (2007). <em>Standard setting: A guide to establishing and evaluating performance standards on tests.</em> SAGE Publications.',
      'van der Linden, W. J. (2006). A lognormal model for response times on test items. <em>Journal of Educational and Behavioral Statistics, 31</em>(2), 181&ndash;204.'
    )),

    # =====================================================================
    # SOFTWARE
    # =====================================================================
    tags$h4(class = "mt-4 mb-3 text-primary",
            icon("laptop-code"), " Software &amp; Tools"),

    ref_section("R &amp; Shiny", "laptop-code", c(
      'R Core Team. (2025). <em>R: A language and environment for statistical computing.</em> R Foundation for Statistical Computing. https://www.R-project.org/',
      'Chang, W., Cheng, J., Allaire, J. J., Sievert, C., Schloerke, B., Xie, Y., Allen, J., McPherson, J., Dipert, A., &amp; Borges, B. (2024). <em>shiny: Web application framework for R</em> (R package). https://shiny.posit.co/',
      'Sievert, C. (2020). <em>Interactive web-based data visualization with R, plotly, and shiny.</em> Chapman &amp; Hall/CRC.',
      'Wickham, H., Averick, M., Bryan, J., Chang, W., McGowan, L. D., Fran&ccedil;ois, R., Grolemund, G., Hayes, A., Henry, L., Hester, J., Kuhn, M., Pedersen, T. L., Miller, E., Bache, S. M., M&uuml;ller, K., Ooms, J., Robinson, D., Seidel, D. P., Spinu, V., &hellip; Yutani, H. (2019). Welcome to the tidyverse. <em>Journal of Open Source Software, 4</em>(43), 1686.',
      'Kuhn, M., &amp; Silge, J. (2022). <em>Tidy modeling with R.</em> O&rsquo;Reilly Media. https://www.tmwr.org/'
    )),

    tags$hr(class = "mt-4"),
    tags$p(class = "text-muted text-center", style = "font-size: 0.85rem;",
      "This reference list covers the primary sources for the statistical methods
       demonstrated in each module of this application. Individual modules may
       draw on additional sources not listed here."
    )
  )
)
}

# No server logic needed for references
references_server <- function(id) {
  moduleServer(id, function(input, output, session) {})
}
