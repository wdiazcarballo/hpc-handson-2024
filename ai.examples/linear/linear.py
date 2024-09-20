# Exercise 1 - linear.py 
import numpy as np 
import keras 

# Build the model 
model = keras.Sequential([keras.layers.Dense(units=1,input_shape=[1])]) 

# Set the loss and optimizer function 
model.compile(optimizer='sgd', loss='mean_squared_error') 

# Initialize input data 
xs = np.array([-1.0, 0.0, 1.0, 2.0, 3.0, 4.0], dtype=float) 


ys = np.array([-2.0, 1.0, 4.0, 7.0, 10.0, 13.0], dtype=float) 

# Fit the model 
model.fit(xs, ys, epochs=500) 
# Prediction 
dataIn = np.array([10.0], dtype=float) 


print(model.predict(dataIn,1,1))
