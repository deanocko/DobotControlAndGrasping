# Sensors and Control Dobot Project: Control and Grasping
%%%%% Authors 
Dean Ockenden    13213537 - Sensors & Control and Robotics
Joseph Seklawy   12578845 - Robotics Team member
Will Hoogervorst 00000000 - Robotics Team member
Chris William    00000000 - Sensors and Control

Each file has a brief description if it is a function or is commented throughout to ensure ease of following.

%%Startup.m

%% Main File

%% Detection
The ColouredBlobDetection function in the detection folder is used for identifying the objects in the rgb image.
The folder also contains some example images that were used for testing.

A full explanation of the ColouredBlobDetection function:
- To use this function, you must input an image and define colour and dimensional threshold values.
- The function first separates the colour bands of the image, then displays them in a figure
- It then applies masks to the colour bands based on the defined colour thresholds, and displays them in the same figure
- Blobs in the masks of a size smaller than a defined minimum threshold are removed, and the masks are combined in such a way to output a more refined masks
- These refined masks are then reanalysed, checking for colour intensity and the blob with the highest intensity is selected, and all others eliminated
- The centroids of the chosen blobs of each colour are used in conjunction with defined width of the surface, and the defined relative Dobot position to translate the centroid values to real world distances measured in metres.

%% DobotControl

%% Models

%% ObjectClasses

%% RealRobot

%% RobotMechanics






         
