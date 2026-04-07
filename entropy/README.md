# Entropy Function

## Description

The `entropy` function computes the Shannon entropy of an image or array. Entropy is a statistical measure of randomness or information content in data. A higher entropy indicates that the image contains more details and varying pixel intensities, while an image with a single uniform color has zero entropy.

This function supports grayscale, color, and boolean images, and allows for a custom number of histogram bins.

## Calling Sequence

```scilab
E = entropy(IM)
E = entropy(IM, NBINS)
```

## Parameters

- **`IM`**: (matrix)  
  The input image or array. It can be of any numerical type or boolean. For multi-channel (color) images, the function flattens all channels into a single sequence of pixels.

- **`NBINS`**: (integer, optional)  
  The number of bins to use for the image histogram calculation.  
  - If not specified:  
    - Defaults to `2` for boolean images.  
    - Defaults to `256` for other images.

## Returns

- **`E`**: (double)  
  The calculated entropy value of the input image or array.

## Mathematical Formulation

The function calculates the **Shannon Entropy** ($E$). The mathematical formula is:

$$ E = - \sum_{i=1}^{N} P_i \log_2(P_i) $$

Where:
- $N$ is the total number of bins (`NBINS`).
- $P_i$ is the probability of a pixel value belonging to the $i^{th}$ bin. The probability is calculated as the frequency of pixels in the bin divided by the total number of pixels.

*Note: If $P_i = 0$, that probability term is ignored since $\lim_{p \rightarrow 0} p \log_2(p) = 0$.*

## Detailed Explanation (How it works & Why)

1. **Default Bins**: If `NBINS` is not provided, the function selects 2 for boolean logic and 256 for standard images. This is because standard image channels usually have values in the range [0, 255].
2. **Flattening**: The input is first converted to double precision and flattened into a 1D vector. This is done to ensure the function smoothly processes both 2D (grayscale) and 3D (color) arrays without dimension complexities.
3. **Handling Constant Images**: If all pixels share the identical value, the entropy is immediately evaluated to `0`, representing no randomness.
4. **Data Scaling**: The pixel values are normalized and mapped into the range `[0, NBINS-1]`. Scaling is crucial to ensure that, irrespective of the initial data boundaries, all values fit perfectly into the provided number of bins. 
5. **Discretization**: The `floor` function turns the scaled decimals into distinct bins (indices). Boundary conditions are corrected so that edge values perfectly hit valid bins.
6. **Histogram & Probabilities**: A histogram computes pixel distributions. Then, the histogram counts are divided by the total number of pixels to obtain probabilities ($P_i$).
7. **Zero Probability Filtering**: Bins with zero counts are excluded from calculation. This is necessary because the logarithm of zero ($\log_2(0)$) is undefined.
8. **Final Calculation**: Finally, the standard Shannon Entropy formula is applied to obtain the total entropy.

## Test Cases

The test cases for this function are in the ```test_entropy.sce``` file. You can run it directly in Scilab to verify the functionality by ```exec('test_entropy.sce', -1);```.

1. **Random Grayscale Image**: Computes the entropy of a 10x10 array of random values. The output should be close to log₂(256) ≈ 8.
2. **Constant Image**: Tests an image where all pixel values are exactly the same, verifying that the entropy calculation returns exactly 0.
3. **Boolean Image**: Tests an array of boolean values (True/False). Entropy should be 1 if True and False are equally distributed.
4. **Custom Number of Bins**: Evaluates the entropy on an array of random integers using a custom specified bin count (10 bins). Output should be close to log₂(10) ≈ 3.32.
5. **Color Image**: Tests handling of a 3D (color) array to verify flattening logic.