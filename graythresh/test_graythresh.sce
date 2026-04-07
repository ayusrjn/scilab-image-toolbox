// test_graythresh.sce - Test cases for graythresh

disp("Loading graythresh.sci...");
exec('graythresh.sci', -1);

disp("=================================");
disp("Test Case 1: All Black Image");
img1 = zeros(10, 10);
level1 = graythresh(img1);
disp("Calculated level:");
disp(level1);
disp("Expected: ~0");

disp("=================================");
disp("Test Case 2: All White Image");
img2 = ones(10, 10);
level2 = graythresh(img2);
disp("Calculated level:");
disp(level2);
disp("Expected: 0");

disp("=================================");
disp("Test Case 3: Half Black, Half White");
img3 = [zeros(10, 5), ones(10, 5)];
level3 = graythresh(img3);
disp("Calculated level:");
disp(level3);
disp("Expected: ~0.5");

disp("=================================");
disp("Test Case 4: Bimodal Distribution");
// Fallback for older scilab versions without repmat
try
    img4 = [repmat(50, 10, 5), repmat(200, 10, 5)];
    level4 = graythresh(img4);
    disp("Calculated level:");
    disp(level4);
    disp("Expected: ~0.49 (125/255)");
catch
    img4 = [ones(10, 5)*50, ones(10, 5)*200];
    level4 = graythresh(img4);
    disp("Calculated level:");
    disp(level4);
    disp("Expected: ~0.49 (125/255)");
end

disp("=================================");
disp("Test Case 5: Normalized Values");
img5 = rand(100, 100);
img5(1:50, :) = img5(1:50, :) * 0.3; // Lower intensity half
img5(51:100, :) = img5(51:100, :) * 0.3 + 0.7; // Higher intensity half
level5 = graythresh(img5);
disp("Calculated level:");
disp(level5);
disp("Expected: Value evaluating between the two randomized blocks.");

disp("All test cases completed successfully.");
