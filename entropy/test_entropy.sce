// Test Cases for entropy.sci

disp("Running tests for entropy function...");

// Execute the entropy function file to load it in the environment
// Make sure you run this script from the same directory where entropy.sci is located
exec('entropy.sci', -1);

// Test 1: Random Grayscale Image
disp("Test 1: Random Grayscale Image");
img1 = rand(10, 10);
E1 = entropy(img1);
disp("Calculated Entropy: " + string(E1));
disp("Should be close to log2(256) ≈ 8 if NBINS=256");
disp("---------------------------------");

// Test 2: Constant Image
disp("Test 2: Constant Image");
img2 = ones(5, 5);
E2 = entropy(img2);
disp("Calculated Entropy: " + string(E2));
disp("Should be exactly 0");
disp("---------------------------------");

// Test 3: Boolean Image
disp("Test 3: Boolean Image");
img3 = [%T %F %T %F];
E3 = entropy(img3);
disp("Calculated Entropy: " + string(E3));
disp("Should be exactly 1");
disp("---------------------------------");

// Test 4: Custom Number of Bins
disp("Test 4: Custom Number of Bins");
img4 = grand(1, 100, "uin", 0, 9); // 100 random integers 0-9
E4 = entropy(img4, 10);
disp("Calculated Entropy: " + string(E4));
disp("Should be close to log2(10) ≈ 3.32 if uniform");
disp("---------------------------------");

// Test 5: Color Image
disp("Test 5: Color Image");
img5 = rand(5, 5, 3);
E5 = entropy(img5);
disp("Calculated Entropy: " + string(E5));
disp("Should return a positive value close to 8");
disp("---------------------------------");

disp("All tests completed.");
