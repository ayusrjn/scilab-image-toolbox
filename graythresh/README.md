# Graythresh (`graythresh.sci`)

Calculates the global image threshold using **Otsu's method**.

## Description

The `graythresh` function finds the optimal threshold level to convert a grayscale image into a binary (black and white) image. It uses Otsu's method, which automatically determines a threshold by maximizing the variance between the two classes (foreground and background pixel intensities).

**Calling Sequence:**
```scilab
level = graythresh(img)
```
- **`img`**: The input image matrix (can handle values between 0-255 or normalized 0.0-1.0).
- **`level`**: The normalized threshold value returned, mapped strictly between `0` and `1`.

---

## Mathematics (Otsu's Method)

Otsu's method works by iteratively evaluating every possible threshold value $T$ (from 0 to 255) and calculating a mathematical measure of spread (variance) for the pixel levels that fall on each respective side of the cutoff limit. 

For a threshold $T$:
1. **Weight (Probability) of Class 1 (Background):**  
   $$\omega_1(T) = \sum_{i=0}^{T} p_i$$ 
   *(where $p_i$ is the exact probability of a pixel holding physical value $i$)*
2. **Mean of Class 1:**  
   $$\mu_1(T) = \frac{\sum_{i=0}^{T} i \cdot p_i}{\omega_1(T)}$$

The identical logical formulations are made to calculate probabilities for Class 2 ($\omega_2, \mu_2$) checking pixel ranges $> T$.

The absolutely optimal threshold **$T^*$** is logically the value that maximizes the **Between-Class Variance** ($\sigma_b^2$):
$$ \sigma_b^2(T) = \omega_1(T) \omega_2(T) \Big[\mu_1(T) - \mu_2(T)\Big]^2 $$

The `graythresh.sci` script natively computes these algorithms instantaneously exploiting rapid vectorized cumulative operations!

---

## Testing

A complete ready-to-run suite is stored natively in `test_graythresh.sce`. The testing executions evaluate:
1. Matrix logic acting against fully black image templates
2. Processing boundaries handling purely white matrix fields
3. Perfect geometric split validation evaluating matrices set exactly half-black and half-white
4. Distribution matching tested directly across distinctly bimodal intensity histogram curves
5. Robust testing handling heavily randomized physical noise limits
