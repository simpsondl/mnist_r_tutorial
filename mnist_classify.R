# Load previously saved dataset
load("mnist_data.RData")

library(keras)
library(reshape2)
library(ggplot2)

# Let R know to use the created conda environment
use_condaenv("mnist", conda = "/usr/licensed/anaconda3/2019.3/bin/conda")

# Extract training/testing images (x)/labels (y)
x_train <- mnist$train$x
y_train <- mnist$train$y
x_test <- mnist$test$x
y_test <- mnist$test$y

### Pre-processing
# reshape images from 28x28 to 1x784
x_train_pp <- array_reshape(x_train, c(nrow(x_train), 784))
x_test_pp <- array_reshape(x_test, c(nrow(x_test), 784))
# rescale grayscale values
x_train_pp <- x_train_pp / 255
x_test_pp <- x_test_pp / 255
# make labels categorical
y_train_pp <- to_categorical(y_train, 10)
y_test_pp <- to_categorical(y_test, 10)

# Define the model
model <- keras_model_sequential() 

model %>% 
  layer_dense(units = 256, activation = 'relu', input_shape = c(784)) %>% 
  layer_dropout(rate = 0.4) %>% 
  layer_dense(units = 128, activation = 'relu') %>%
  layer_dropout(rate = 0.3) %>%
  layer_dense(units = 10, activation = 'softmax')

# Examine model structure
summary(model)

# Compile model
model %>% 
  compile(loss = 'categorical_crossentropy',
          optimizer = optimizer_rmsprop(),
          metrics = c('accuracy'))

# Train model
history <- model %>% 
            fit(x_train_pp, y_train_pp, 
                epochs = 30, batch_size = 128, 
                validation_split = 0.2)

# Organize training metrics for plotting
metrics <- do.call(cbind.data.frame, history$metrics)
metrics <- melt(metrics)
metrics$acc <- ifelse(grepl("acc",metrics$variable),"Accuracy","Loss")
metrics$epoch <- rep(1:30,4)

# Save history of training in a plot
pdf("training_metrics.pdf")
ggplot(metrics,aes(epoch, value, col = variable)) + 
  facet_grid(acc ~ ., scales = "free_y") + 
  geom_point() + geom_line()
dev.off()

# Generate predictions on test data
pred <- model %>% predict_classes(x_test_pp)

# Save some predictions on test data
pdf("output.pdf")
par(mfcol=c(5,5))
par(mar=c(0, 0, 3, 0), xaxs='i', yaxs='i')
for (idx in 1:25) { 
  im <- x_test[idx,,]
  im <- t(apply(im, 2, rev)) 
  image(1:28, 1:28, im, col=gray((0:255)/255), 
        xaxt='n', main=paste("Label:", y_test[idx],"\nPredicted:", pred[idx]))
}
dev.off()


