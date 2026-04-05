# Entropy Function

## Description

The `entropy` function computes the entropy of an image or array, which is a measure of the randomness or information content in the data. It supports both grayscale and boolean images, and allows for a custom number of histogram bins.

## Calling Sequence

```scilab
E = entropy(IM)
E = entropy(IM, NBINS)
```

## Parameters

- **IM**: (matrix)  
  The input image or array. Can be of any numeric type or boolean. For color images, the function flattens all channels into a single vector.

- **NBINS**: (integer, optional)  
  The number of bins to use for the histogram.  
  - If not specified:  
    - For boolean images, defaults to 2.  
    - For other images, defaults to 256.

## Returns

- **E**: (double)  
  The entropy value of the input image or array.

## Detailed Explanation

1. **Default Bins**: If `NBINS` is not provided, the function chooses 2 for boolean images and 256 for others.
2. **Conversion**: The input is converted to double and flattened into a vector.
3. **Constant Image Handling**: If all pixels have the same value, entropy is 0.
4. **Binning**: The pixel values are scaled into the range `[0, NBINS-1]` and binned using `floor`.
5. **Histogram**: A histogram is built by counting occurrences in each bin.
6. **Probability Calculation**: The histogram is normalized to get probabilities.
7. **Zero Bin Removal**: Bins with zero probability are removed.
8. **Entropy Calculation**: Entropy is computed as `-sum(P .* log2(P))`.

## Test Cases

### 1. Random Grayscale Image

```scilab
img = rand(10, 10); // Random grayscale image
E = entropy(img);
disp(E); // Should be close to log2(256) ≈ 8 if NBINS=256
```

### 2. Constant Image

```scilab
img = ones(5, 5); // All pixels same
E = entropy(img);
disp(E); // Should be 0
```

### 3. Boolean Image

```scilab
img = [%T %F %T %F];
E = entropy(img);
disp(E); // Should be 1 (if equal number of T/F)
```

### 4. Custom Number of Bins

```scilab
img = grand(1, 100, "uin", 0, 9); // 100 random integers 0-9
E = entropy(img, 10);
disp(E); // Should be close to log2(10) ≈ 3.32 if uniform
```

### 5. Color Image

```scilab
img = rand(5, 5, 3); // Random color image
E = entropy(img);
disp(E); // Should return a positive value
```

---