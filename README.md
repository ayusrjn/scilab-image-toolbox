# Scilab Image Toolbox

Welcome to the Scilab Image Toolbox repository! This project contains native Scilab implementations for standard image processing algorithms traditionally found in Octave or MATLAB. 

Each mathematical module is completely modular, natively handling processing arrays independently. They also include their own math documentation, source functions, and executable test suites.

## Modules

### 1. `edge/`
Contains an independent detection engine calculating structural boundaries across 2D image matrices. 
- **Algorithms**: Sobel, Prewitt, and Roberts operators.
- **Highlights**: Features a custom non-maximum suppression (NMS) mapping tool, transforming heavy mathematical gradients into 1-pixel wide, visually clean edge lines.

### 2. `entropy/`
Calculates the absolute measure of randomness (Shannon Entropy formulation) within input matrices.
- **Support**: Natively maps Boolean matrices, normal grayscale objects, and massive multidimensional 3D color images seamlessly.
- **Dynamic Usage**: Offers easy configuration to evaluate limits using specific custom histogram bin arrays.

### 3. `graythresh/`
A global binarization framework running mathematical clustering via **Otsu’s Method**.
- **Purpose**: Automatically identifies the absolute mathematically optimal cutoff threshold (0 to 255) to visually split a continuous grayscale image strictly into contrasting binary foreground and background pixels.
- **Highlights**: Fully vectorized approach processing metrics simultaneously across plateau edges, skipping `for` loops completely!

---

## Running Tests

Each sub-directory features its own native Scilab executables (e.g., `test_edge.sce`, `test_graythresh.sce`, and `test_entropy.sce`). Execute them natively in the Scilab IDE or standard command line interfaces to automatically test matrix boundary checking, visual noise mapping, and flat image detection boundaries.
