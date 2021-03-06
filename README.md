# Performing the Analysis

The analysis consists of one script with the name `run_analysis.R`. You should be able to load the file in R with `source("PATH_TO_SCRIPT/run_analysis.R")`.

The main function to perform the analysis in this file is `runAnalysis()`. Calling this function will perform the analysis and return the result as the tidied data table grouped by activities containing the measures from the Samsung data set.

The result will not only be returned but also saved to files named `results.txt` and `activity_results.txt` into the working directory. The file `results.txt` contains the un-grouped results.

To execute the analysis the `dplyr` package will be loaded so make sure the package is installed before running the script.

Because the files will be downloaded from the internet with the `download.file` function there might be issues on MacOS if there are additional parameters required. The script was tested only on a Windows machine. Maybe in that case the `method` parameter must be set for the download function.