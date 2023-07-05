# charm

<!-- badges: start -->
[![R-CMD-check](https://github.com/seankross/charm/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/seankross/charm/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

Lightweight, R-centered, file-oriented workflow framework.

## Installation

You can install Charm using the `remotes` package:

``` r
remotes::install_github("seankross/charm")
```

## Getting Started

Charm allows you to organize an analysis that is comprised of multiple R scripts
into a coherent, reproducible, project-oriented workflow. If you are already
organizing your analysis in a project using multiple R scripts, Charm allows you
to reuse your existing scripts without rewriting any code, while making 
running your code a more straightforward process that allows you to stop using
`source()` and `setwd()`. Charm is lightweight: just add a `_charm.R` file to 
your project directory to start using the package.

Charm is specifically designed to work within a ***project-oriented workflow***.
If you are not familiar with working within a project-oriented workflow, you
can read about it 
[here](https://www.tidyverse.org/blog/2017/12/workflow-vs-script/) and
[here](https://rstats.wtf/projects.html). You should also familiarize yourself
with the [`here`](https://here.r-lib.org/) R package, which is tightly
integrated into using Charm.

See also:

- GNU Make
- Targets
- WDL
