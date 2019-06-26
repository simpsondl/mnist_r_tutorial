# Package requirements
pkgs <- c("keras","reshape2","ggplot2")

# Check if packages already installed and install if not
new.pkgs <- pkgs[!(pkgs %in% installed.packages()[,"Package"])]
if(length(new.pkgs)) install.packages(new.pkgs)

# Load keras and save the mnist dataset
library(keras)
use_condaenv("mnist")

mnist <- dataset_mnist()

save.image("mnist_data.RData") 