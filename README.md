# Installing and Using Tensorflow with R

This tutorial implements the basic MNIST classification tutorial using the R interface to Keras with Tensorflow backend. In particular, this guide is aimed at using the GPU nodes available on Princeton's HPC Clusters (Adroit and Tiger).

## Read the tutorial

The original tutorial is available [here](https://keras.rstudio.com/) under the "MNIST Example" heading.

## Clone the repository

Log into a head node on either Adroit or Tiger for GPU node access. Clone this repository to your home directory with

```
git clone https://github.com/simpsondl/mnist_r_tutorial.git
```

This creates a folder ```mnist_r_tutorial```.

## Create a conda environment with Tensorflow

This will create a conda environment with Tensorflow and Keras available (note that specifying Python 3.6 is necessary to work around a conflict with R). 

```
module load anaconda3
conda create —name mnist python=3.6
conda activate mnist
pip install tensorflow-gpu keras
conda deactivate
```

Once this finishes, you will have a conda environment with tensorflow that can be accessed when needed. Note that this environment is not active by default, and in order to have R use this environment, we need to add a line to our R scripts. 

## Configure R environment and download data

From your home directory, run

```
module load anaconda3
cd mnist_r_tutorial
conda activate mnist
Rscript mnist_download.R
```

This will check if you have the packages ```keras```, ```reshape2```, and ```ggplot2``` installed. If they are not installed, then the script will stop with an error message indicating which packages need to be installed. Open an R terminal, and install missing packages with

```
install.packages(c("keras", "reshape2", "ggplot2"))
```

If you already have some of these installed, then the command can be changed by removing these. If this is your first time installing an R package, you will be asked if you would like to create a personal library in your home directory at a given path--select yes both times. You will also be prompted to select a CRAN mirror; choose one in the US (for example, 64). Once the missing packages have been installed, re-run the ```mnist_download.R``` script. If this completes, it should create a new RData file containing the MNIST dataset (```mnist_data.RData```). Notice that the conda environment we created earlier is specified in the R script using the command ```use_condaenv("mnist")```.

## Run the classification

Now that the environments have been created and the data has been downloaded, the actual classification can be performed. In ```mnist.s```, remove the space in the ```--mail-user``` line and include your Princeton NetID. From the ```mnist_r_tutorial``` directory, run

```
sbatch mnist.s
```

This will request a GPU node for 5 minutes and queue the job. You can check whether or not your job is running with ```squeue -u yourusername```. Once the job has completed, you should have several output files: ```slurm-XXXXXXX.out``` containing any printed output from the job (this will include training progress and a model summary), ```training_metrics.pdf``` containing a plot of the accuracy and loss values during training, and ```output.pdf``` containing MNIST example images with their labels and predictions. Download the PDF files to your computer for viewing with

```
scp yourusername@hpcclustername.princeton.edu:~/mnist_r_tutorial/*pdf .
```

Note that this command should be run from your computer (not the cluster), and you will need to change ```yourusername``` to your Princeton NetID and ```hpcclustername``` to Adroit or Tiger depending on which HPC cluster you are using. Finally, you can change the download location by changing ```.``` to a path of your choice.
