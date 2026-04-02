// Load function
exec('/home/ayush-ranjan/scilab/rgb2gray.sci', -1);

// Create sample image
img = rand(5,5,3);

// Apply function
gray = rgb2gray(img);

// Display result
disp("Grayscale Output:");
disp(gray);
