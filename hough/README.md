# Hough Transform

This directory contains the implementation of the Hough transform, a feature extraction technique used in image analysis, computer vision, and digital image processing.

## Function: `hough`

### Description
Computes the Hough transform to find lines in a binary image. The function maps points in the image space to curves in the parameter space (rho and theta).

### Calling Sequence
```scilab
[H, theta, rho] = hough(BW)
[H, theta, rho] = hough(BW, 'Theta', theta_vec)
[H, theta, rho] = hough(BW, 'ThetaResolution', res)
```

### Parameters
- **`BW`**: A binary image (matrix of 0s and 1s) where 1s represent edge pixels.
- **`'Theta'`** (Optional): A vector of angles in degrees at which to compute the Hough transform. Default is `-90:89`.
- **`'ThetaResolution'`** (Optional): A scalar defining the step size for the theta vector. If provided, theta is calculated as `-90:res:89.999`.

### Returns
- **`H`**: The Hough transform accumulator matrix. Each element `H(rho_idx, theta_idx)` contains the number of votes for a line with parameters `(rho, theta)`.
- **`theta`**: A vector containing the angles (in degrees) used for the transform.
- **`rho`**: A vector containing the distances from the origin for each row in `H`.

---

## Test Cases

### 1. Vertical Line
A vertical line at $x=10$ in a 50x50 image should produce a peak at $\theta = 0$ and $\rho = 9$ (using 0-based coordinate indexing as per implementation).
```scilab
BW = zeros(50, 50);
BW(:, 10) = 1;
[H, theta, rho] = hough(BW);
[max_val, idx] = max(H);
[r_idx, t_idx] = ind2sub(size(H), idx);
disp("Peak at Theta: " + string(theta(t_idx)));
disp("Peak at Rho: " + string(rho(r_idx)));
```

### 2. Horizontal Line
A horizontal line at $y=20$ in a 50x50 image should produce a peak at $\theta = 90$ (or $-90$) and $\rho = 19$.
```scilab
BW = zeros(50, 50);
BW(20, :) = 1;
[H, theta, rho] = hough(BW);
[max_val, idx] = max(H);
[r_idx, t_idx] = ind2sub(size(H), idx);
disp("Peak at Theta: " + string(theta(t_idx)));
disp("Peak at Rho: " + string(rho(r_idx)));
```

### 3. Diagonal Line
A diagonal line from (10,10) to (40,40) as seen in `script.sce`.
```scilab
BW = zeros(50, 50);
for i = 10:40
    BW(i, i) = 1;
end
[H, theta, rho] = hough(BW);
[max_val, idx] = max(H);
[r_idx, t_idx] = ind2sub(size(H), idx);
disp("Peak at Theta: " + string(theta(t_idx)));
disp("Peak at Rho: " + string(rho(r_idx)));
```

### 4. Single Point
A single point at (25, 25) should result in a sinusoid in the accumulator matrix.
```scilab
BW = zeros(50, 50);
BW(25, 25) = 1;
[H, theta, rho] = hough(BW);
disp("Sum of H: " + string(sum(H))); // Should equal number of thetas
```

### 5. Empty Image
An image with no edge pixels should result in an accumulator matrix of all zeros.
```scilab
BW = zeros(50, 50);
[H, theta, rho] = hough(BW);
disp("Max of H: " + string(max(H))); // Should be 0
```
