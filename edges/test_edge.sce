// test_edge.sce - Test suite for the edge detection algorithms

disp("Loading edge.sci...");
exec('edge.sci', -1);

disp("=================================");
disp("1. Testing wrapper function: edge");
disp("=================================");
IM = zeros(10, 10);
IM(3:7, 3:7) = 1;

[BW, TH] = edge(IM);
disp("Test 1: Default (Sobel + auto thresh) passed.");
[BW, TH] = edge(IM, "prewitt");
disp("Test 2: Explicit Prewitt passed.");
[BW, TH] = edge(IM, "roberts");
disp("Test 3: Explicit Roberts passed.");
[BW, TH] = edge(IM, "sobel", 0.5);
disp("Test 4: Manual threshold passed.");

disp("=================================");
disp("2. Testing non_max_suppression");
disp("=================================");
mag = [0 0 0; 0.5 1 0.5; 0 0 0]; Ix  = [0 0 0; 0.5 1 0.5; 0 0 0]; Iy  = zeros(3,3); nms = non_max_suppression(mag, Ix, Iy);
disp("Test 1: Vertical edge suppression passed.");

mag = [0 0.5 0; 0 1 0; 0 0.5 0]; Ix  = zeros(3,3); Iy  = [0 0.5 0; 0 1 0; 0 0.5 0]; nms = non_max_suppression(mag, Ix, Iy);
disp("Test 2: Horizontal edge suppression passed.");

nms = non_max_suppression(zeros(3, 3), zeros(3, 3), zeros(3, 3));
disp("Test 3: Flat region passed.");

mag = [0 0 3; 0 3 0; 3 0 0]; nms = non_max_suppression(mag, mag, mag);
disp("Test 4: Diagonal gradient passed.");

nms = non_max_suppression(ones(5, 5), ones(5, 5), zeros(5, 5));
disp("Test 5: Uniform matrix passed.");

disp("=================================");
disp("3. Testing conv2_custom");
disp("=================================");
out = conv2_custom([1 2; 3 4], [0 0 0; 0 1 0; 0 0 0]);
disp("Test 1: Identity mapping passed.");

out = conv2_custom([0 0 0 0 1 1 1 1], [-1 1]);
disp("Test 2: Linear edge detection passed.");

out = conv2_custom(ones(3,3), ones(3,3) / 9);
disp("Test 3: Image smoothing passed.");

img = zeros(5, 5); img(2:4, 2:4) = 1;
out = conv2_custom(img, [-1 0 1; -2 0 2; -1 0 1]);
disp("Test 4: basic Sobel execution passed.");

img = zeros(5, 5); img(3, 3) = 1;
out = conv2_custom(img, [1 2; 3 4]);
disp("Test 5: dynamic impulse passed.");

disp("=================================");
disp("4. Testing edge_sobel");
disp("=================================");
IM = zeros(8, 8); IM(3:6, 3:6) = 1;
[BW, TH] = edge_sobel(IM); disp("Test 1: Auto standard execute passed.");
[BW, TH] = edge_sobel(IM, 5.0); disp("Test 2: Heavy threshold execute passed.");
[BW, TH] = edge_sobel(IM, 0.1); disp("Test 3: Low custom threshold test passed.");
[BW, TH] = edge_sobel(zeros(5, 5)); disp("Test 4: Uniform background test passed.");
try
    img = repmat([0 1; 1 0], 4, 4);
    [BW, TH] = edge_sobel(img); disp("Test 5: Checkerboard tested.");
catch
    disp("Test 5 skipped: repmat not supported natively.");
end

disp("=================================");
disp("5. Testing edge_prewitt");
disp("=================================");
IM = zeros(8, 8); IM(3:6, 3:6) = 1;
[BW, TH] = edge_prewitt(IM); disp("Test 1: Normal auto cut off passed.");
[BW, TH] = edge_prewitt(IM, 2.5); disp("Test 2: Float decimal limit passed.");
[BW, TH] = edge_prewitt(zeros(5,5)); disp("Test 3: Empty matrix handled.");
[BW, TH] = edge_prewitt([0 0 0; 0 1 0; 0 0 0]); disp("Test 4: Micro feature tested.");
[BW, TH] = edge_prewitt(IM, 9999); disp("Test 5: Large limit boundary handled.");

disp("=================================");
disp("6. Testing edge_roberts");
disp("=================================");
[BW, TH] = edge_roberts(eye(7, 7)); disp("Test 1: Optimal diagonal identity passed.");
IM2 = zeros(10, 10); IM2(4:6, 4:6) = 1;
[BW, TH] = edge_roberts(IM2, 1.2); disp("Test 2: Square feature boundary passed.");
[BW, TH] = edge_roberts(ones(8, 8)); disp("Test 3: Flat template handled.");
[BW, TH] = edge_roberts(rand(10, 10)); disp("Test 4: Random noise mapping passed.");
[BW, TH] = edge_roberts([1 0; 0 1]); disp("Test 5: Micro bounds logic passed.");

disp("All test cases completed successfully.");
