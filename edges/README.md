# scilab-image-toolbox: Edge Detection (`edge.sci`)

This document provides detailed information about each function present in the `edge.sci` script. It includes descriptions, calling sequences, parameter explanations, and test cases for algorithmic verification.

---

## 1. `edge`

### Description
A wrapper function to mimic the overall behavior of the `edge()` function in Octave/MATLAB. It serves as the primary interface to apply different edge-detection algorithms to an input image. 

### Calling Sequence
```scilab
[BW, THRESH] = edge(IM)
[BW, THRESH] = edge(IM, METHOD)
[BW, THRESH] = edge(IM, METHOD, thresh)
```

### Parameters
*   `IM` (Matrix): The input 2D image matrix (handles grayscale intensities).
*   `METHOD` (String, Optional): The edge detection algorithm to execute. Supported options are `"sobel"` (default), `"prewitt"`, and `"roberts"`. String comparison is case insensitive.
*   `thresh` (Scalar, Optional): The customized threshold value used to filter out weak gradients during the non-maximum suppression phase. If omitted, a dynamic value based on the root-mean-square of the gradient magnitudes is generated.

### Return Values
*   `BW` (Boolean Matrix): A matrix of logical values (`%t` and `%f`) of the same dimensions as `IM`, where `%t` indicates the presence of a binarized boundary.
*   `THRESH` (Scalar): The internal scalar threshold value that was used to binarize the gradients.

### Test Cases
```scilab
// Setup for testing
IM = zeros(10, 10);
IM(3:7, 3:7) = 1;

// Test Case 1: Use default parameters (Sobel operator, auto threshold)
[BW, TH] = edge(IM);
disp(BW);

// Test Case 2: Explicitly specify the Prewitt method
[BW, TH] = edge(IM, "prewitt");
disp(BW);

// Test Case 3: Explicitly specify the Roberts method
[BW, TH] = edge(IM, "roberts");
disp(BW);

// Test Case 4: Provide an explicit numerical threshold manually
[BW, TH] = edge(IM, "sobel", 0.5);
disp(BW);

// Test Case 5: Verify incorrect user input throws expected error
// [BW, TH] = edge(IM, "invalid_algorithm"); 
```

---

## 2. `non_max_suppression`

### Description
Performs non-maximum gradient suppression on an initialized magnitude matrix to eliminate thick clustered edges, leaving only thin, distinct lines. It dynamically compares the magnitude of each respective pixel with its neighboring gradients intersecting along the direction of the geometric gradient.

### Calling Sequence
```scilab
nms = non_max_suppression(mag, Ix, Iy)
```

### Parameters
*   `mag` (Matrix): The initially calculated magnitude of the gradients at each pixel `sqrt(Ix^2 + Iy^2)`.
*   `Ix` (Matrix): The horizontal gradient structural components.
*   `Iy` (Matrix): The vertical gradient structural components.

### Return Values
*   `nms` (Matrix): The globally thinned gradient magnitude scalar matrix where non-maximum/sub-optimal gradient values are entirely set to zero.

### Test Cases
```scilab
// Test Case 1: Simple Horizontal Gradient Simulation (Vertical Edge)
mag = [0 0 0; 0.5 1 0.5; 0 0 0];
Ix  = [0 0 0; 0.5 1 0.5; 0 0 0];
Iy  = [0 0 0; 0   0   0  ; 0 0 0];
nms = non_max_suppression(mag, Ix, Iy);

// Test Case 2: Simple Vertical Gradient Simulation (Horizontal Edge)
mag = [0 0.5 0; 0 1 0; 0 0.5 0];
Ix  = [0 0 0; 0 0 0; 0 0 0];
Iy  = [0 0.5 0; 0 1 0; 0 0.5 0];
nms = non_max_suppression(mag, Ix, Iy);

// Test Case 3: Complete Flat Region (No Gradients)
mag = zeros(3, 3);
Ix  = zeros(3, 3);
Iy  = zeros(3, 3);
nms = non_max_suppression(mag, Ix, Iy);

// Test Case 4: Standard Diagonal Gradient Trace (45 degrees)
mag = [0 0 3; 0 3 0; 3 0 0];
Ix  = [0 0 3; 0 3 0; 3 0 0];
Iy  = [0 0 3; 0 3 0; 3 0 0];
nms = non_max_suppression(mag, Ix, Iy);

// Test Case 5: Full uniform matrices execution 
mag = ones(5, 5); 
Ix = ones(5, 5); 
Iy = zeros(5, 5);
nms = non_max_suppression(mag, Ix, Iy);
```

---

## 3. `conv2_custom`

### Description
Applies 2D discrete algorithmic convolution between a generated image matrix and a 2D convolution logical kernel (used fundamentally for standard spatial filters).

### Calling Sequence
```scilab
out = conv2_custom(img, kernel)
```

### Parameters
*   `img` (Matrix): The fundamental 2D grayscale input image.
*   `kernel` (Matrix): The static convolution kernel footprint map (e.g., `[-1 0 1; -2 0 2; -1 0 1]` for the Sobel configuration).

### Return Values
*   `out` (Matrix): The computed composite output matrix directly resulting from spatial convolution. It structurally keeps the same absolute spatial dimension as `img`.

### Test Cases
```scilab
// Test Case 1: Universal identity core kernel mapping
img = [1 2; 3 4];
kernel = [0 0 0; 0 1 0; 0 0 0];
out = conv2_custom(img, kernel);

// Test Case 2: High-pass linear edge detection pattern
img = [0 0 0 0 1 1 1 1];
kernel = [-1 1];
out = conv2_custom(img, kernel);

// Test Case 3: Generic small 3x3 uniform image smoothing
img = ones(3,3);
kernel = ones(3,3) / 9;
out = conv2_custom(img, kernel);

// Test Case 4: Custom 2D Basic Sobel execution on minimal resolution square
img = zeros(5, 5); img(2:4, 2:4) = 1;
kernel = [-1 0 1; -2 0 2; -1 0 1];
out = conv2_custom(img, kernel);

// Test Case 5: Single dynamic impulse response verification
img = zeros(5, 5); img(3, 3) = 1;
kernel = [1 2; 3 4];
out = conv2_custom(img, kernel);
```

---

## 4. `edge_sobel`

### Description
Executes the specific Sobel edge-detection mathematical algorithm on an image using customized static `3x3` matrices to measure direct spatial convolution gradients `Gx` and `Gy`.

### Calling Sequence
```scilab
[BW, THRESH] = edge_sobel(IM)
[BW, THRESH] = edge_sobel(IM, thresh)
```

### Parameters
*   `IM` (Matrix): Standard numerical input image array.
*   `thresh` (Scalar, Optional): Numeric suppression threshold mapped for gradient physical magnitude. 

### Return Values
*   `BW` (Boolean Matrix): Extracted boolean-based binary edges overlay.
*   `THRESH` (Scalar): Formally applied numeric threshold value.

### Test Cases
```scilab
IM = zeros(8, 8); IM(3:6, 3:6) = 1;

// Test Case 1: Automatic standard root-mean threshold execution
[BW, TH] = edge_sobel(IM);

// Test Case 2: Heavy custom threshold execution (Lower line/boundary yield)
[BW, TH] = edge_sobel(IM, 5.0);

// Test Case 3: Low custom threshold test (Greater noise/boundary yield)
[BW, TH] = edge_sobel(IM, 0.1);

// Test Case 4: Mapping applied to completely static uniform background
[BW, TH] = edge_sobel(zeros(5, 5));

// Test Case 5: Test deployed efficiently against gradient-heavy checkerboard feature pattern
img = repmat([0 1; 1 0], 4, 4);
[BW, TH] = edge_sobel(img);
```

---

## 5. `edge_prewitt`

### Description
Employs the classic Prewitt edge detection formula/methodology. Qualitatively comparable to Sobel mapping algorithms, but practically utilizes a strictly leveled `[-1 0 1; -1 0 1; -1 0 1]` vertical sequence and an equivalently straight/static horizontal convolution layer trace.

### Calling Sequence
```scilab
[BW, THRESH] = edge_prewitt(IM)
[BW, THRESH] = edge_prewitt(IM, thresh)
```

### Parameters
*   `IM` (Matrix): Original unmapped inputted 2D image geometric array representation.
*   `thresh` (Scalar, Optional): Custom pre-computation suppression limit bounding for standard minimal gradient intensity constraints.

### Return Values
*   `BW` (Boolean Matrix): Spatial matrix array where a formal output of `%t` guarantees definite geometric edge isolation mapping.
*   `THRESH` (Scalar): Final formal metric generated directly for active numeric thresholding applied globally to suppression blocks.

### Test Cases
```scilab
IM = zeros(8, 8); IM(3:6, 3:6) = 1;

// Test Case 1: Normal initialization routine mapping with auto-generated algorithmic cutoff 
[BW, TH] = edge_prewitt(IM);

// Test Case 2: Mapping verification testing against a hard float decimal limit requirement cut    
[BW, TH] = edge_prewitt(IM, 2.5);

// Test Case 3: Complete mapping simulation handling empty matrix null arrays
[BW, TH] = edge_prewitt(zeros(5,5));

// Test Case 4: Extreme microscopic feature isolated resolution scale tests  
[BW, TH] = edge_prewitt([0 0 0; 0 1 0; 0 0 0]);

// Test Case 5: Limit checks operating mathematically over heavy bound limit caps   
[BW, TH] = edge_prewitt(IM, 9999);
```

---

## 6. `edge_roberts`

### Description
Leverages the robust Roberts Cross operator format sequence methodology to precisely track specific, discrete structural `2-D` topological mapping spatial shifts using small array footprint geometric `2x2` convolution kernels. Especially ideal dynamically for rapid and rigid diagonal computational boundaries processing. Important NOTE: the inner loop immediately automatically adjusts physical trace mappings outwardly utilizing a direct manual 45-degree scale angular adjustment preceding core Non-Maximum algorithmic bounds.

### Calling Sequence
```scilab
[BW, THRESH] = edge_roberts(IM)
[BW, THRESH] = edge_roberts(IM, thresh)
```

### Parameters
*   `IM` (Matrix): Raw active mapping space data representation sequence template.
*   `thresh` (Scalar, Optional): Utilized absolute dynamic numeric limit applied directly globally onto structural filtering checks limit suppression mapping loops.

### Return Values
*   `BW` (Boolean Matrix): Hard bounded Boolean logic output geometric isolated representation array template.
*   `THRESH` (Scalar): Precise isolated mathematical ceiling bounds formula standard utilized throughout spatial filtering trace algorithm loops.

### Test Cases
```scilab
// Test Case 1: Trace Auto suppression testing handling directly across an optimal diagonal identity matrix feature block template   
IM = eye(7, 7);
[BW, TH] = edge_roberts(IM);

// Test Case 2: Hard ceiling bound trace mappings against a static isolated square feature region template    
IM2 = zeros(10, 10); IM2(4:6, 4:6) = 1;
[BW, TH] = edge_roberts(IM2, 1.2);

// Test Case 3: Flat template limit verification matrix mapping evaluation  
[BW, TH] = edge_roberts(ones(8, 8));

// Test Case 4: High entropy randomization signal noise evaluation mappings checking isolated structural algorithm logic limits
[BW, TH] = edge_roberts(rand(10, 10));

// Test Case 5: Minimal boundaries handling array tests against microscopic minimal structural logic sequences 
[BW, TH] = edge_roberts([1 0; 0 1]);
```
