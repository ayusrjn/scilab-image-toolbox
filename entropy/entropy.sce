// Load function
exec('entropy.sci', -1);

// Create sample image
img = rand(5,5,3);

// Apply function
img_entropy = entropy(img);

// Display result
disp("Entropy of the Image:");
disp(img_entropy);
