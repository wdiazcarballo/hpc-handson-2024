# Exercise 3 - convolution.py 
import tensorflow as tf 
print(tf.__version__) 

# Partition input data 
mnist = tf.keras.datasets.fashion_mnist
(training_images,training_labels), (test_images, test_labels) = mnist.load_data() 

# Reshape input data 
training_images=training_images.reshape(60000, 28, 28, 1) 
training_images=training_images / 255.0 
test_images = test_images.reshape(10000, 28, 28, 1) 
test_images=test_images / 255.0 

#Build the model 
model = tf.keras.models.Sequential([ 
    tf.keras.layers.Conv2D(64,(3,3),activation='relu', 
    input_shape=(28, 28, 1)), 
    tf.keras.layers.MaxPooling2D(2, 2), 
    tf.keras.layers.Conv2D(64, (3, 3), activation='relu'), 
    tf.keras.layers.MaxPooling2D(2,2), 
    tf.keras.layers.Flatten(), 
    tf.keras.layers.Dense(128, activation='relu'), 
    tf.keras.layers.Dense(10, activation='softmax') 
]) 
# Compile and fit the model 
model.compile(optimizer='adam', 
    loss='sparse_categorical_crossentropy', metrics=['accuracy']) 
model.fit(training_images, training_labels, epochs=5) 

# Test the model 
test_loss,test_accuracy=model.evaluate(test_images,test_labels) 
print('Test loss: {}, Test accuracy: {}'.format(test_loss, test_accuracy*100)) 
