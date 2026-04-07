disp("Generating test image...");
// Create a 50x50 blank image and draw a diagonal line
BW = zeros(50, 50);
for i = 10:40
    BW(i, i) = 1;
end

disp("Computing Hough Transform...");
// Run the function
[H, theta, rho] = hough(BW);

disp("Plotting results...");
// Create a new figure
scf(); 

// Plot the matrix (transposing H to match dimensions)
grayplot(theta, rho, H'); 

// Add labels and title
title('Hough Transform Accumulator Matrix');
xlabel('Theta (degrees)');
ylabel('Rho (distance)');

// Apply the hot colormap to highlight the intersection peaks
f = gcf();
f.color_map = hotcolormap(64); 

// Reverse the Y-axis direction to match Octave's top-down image system
a = gca();
a.axes_reverse = ["off", "on", "off"];

disp("Done!");
