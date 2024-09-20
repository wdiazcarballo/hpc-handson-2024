# Exercise 2 - fashion.py 
import tensorflow as tf 
import keras 


fashion_mnist = keras.datasets.fashion_mnist 


# Partition input data 
(train_images, train_labels), (test_images, test_labels) = fashion_mnist.load_data() 

# Build the model 
model = keras.Sequential([ 
    keras.layers.Flatten(input_shape=(28,28)), 
    keras.layers.Dense(128, activation = tf.nn.relu), 
    keras.layers.Dense(10, activation=tf.nn.softmax) 
]) 

# Compile and fit the model 
model.compile(optimizer = tf.keras.optimizers.Adam(), 
    loss = 'sparse_categorical_crossentropy', 
    metrics=['accuracy']) 


model.fit(train_images, train_labels, epochs=20) 

# Test the model 
test_loss, test_acc = model.evaluate(test_images,test_labels) 
print('Test loss: {}, Test accuracy: {}'.format(test_loss, test_acc*100)) 
