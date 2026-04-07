# graythresh

Global image threshold using Otsu's method.

## Description

The `graythresh` function computes a global threshold level that can be used to convert an intensity image to a binary image. It uses **Otsu's method**, which chooses the threshold to minimize the intraclass variance of the black and white pixels. This is equivalent to maximizing the between-class variance.

The function handles both normalized double arrays (0.0 to 1.0) and integer-based image data (0 to 255). It returns a normalized threshold value in the range [0, 1].

## Calling Sequence

```scilab
level = graythresh(img)
```

## Parameters

- **img**: Input image array. It can be a 2D matrix of:
    - Doubles: Values typically in the range [0, 1].
    - Integers: Values in the range [0, 255].
- **level**: Normalized threshold value (a double between 0 and 1). To convert the image to binary using this level, you can use `img_binary = img > (level * 255)` for integer images or `img_binary = img > level` for normalized images.

## Test Cases

To verify the accuracy and effectiveness of the `graythresh` function, the following test cases can be used:

### Test Case 1: All Black Image
**Input:** A 10x10 matrix of all zeros.
**Expected Output:** `level` should be 0 (or very close to 0 due to epsilon protection).
**Scilab Code:**
```scilab
img = zeros(10, 10);
level = graythresh(img);
disp(level); // Expected: 0
```

### Test Case 2: All White Image
**Input:** A 10x10 matrix of all ones (normalized) or 255s.
**Expected Output:** `level` should be 0.996 (approx 254/255) as the maximum index - 1 is 255, but the variance peak might behave differently on flat images. Actually, for a flat image, the variance is zero everywhere.
**Scilab Code:**
```scilab
img = ones(10, 10);
level = graythresh(img);
disp(level); 
```

### Test Case 3: Half Black, Half White
**Input:** A matrix where half the pixels are 0 and half are 1 (or 255).
**Expected Output:** `level` should be approximately 0.5 (or the value between the two peaks).
**Scilab Code:**
```scilab
img = [zeros(10, 5), ones(10, 5)];
level = graythresh(img);
disp(level); // Expected: 0.5 (approx)
```

### Test Case 4: Bimodal Distribution
**Input:** An image with two distinct peaks in its histogram (e.g., values around 50 and 200).
**Expected Output:** `level` should fall between the two peaks (e.g., around 125/255 ≈ 0.49).
**Scilab Code:**
```scilab
img = [repmat(50, 10, 5), repmat(200, 10, 5)];
level = graythresh(img);
disp(level); 
```

### Test Case 5: Normalized Values
**Input:** A matrix with values randomly distributed between 0 and 1 with a bias.
**Expected Output:** `level` should reflect the optimal threshold for that distribution.
**Scilab Code:**
```scilab
img = rand(100, 100);
img(1:50, :) = img(1:50, :) * 0.3; // Lower intensity half
img(51:100, :) = img(51:100, :) * 0.3 + 0.7; // Higher intensity half
level = graythresh(img);
disp(level);
```
