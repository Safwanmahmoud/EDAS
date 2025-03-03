# Euclidean Distance-based Adaptive Sampling (EDAS)

**EDAS** is an adaptive smoothing algorithm designed to separate transient and oscillatory components in neural signals. By dynamically adjusting the sampling rate based on Euclidean distance thresholds, EDAS captures sharp transitions while minimizing spectral leakage, outperforming conventional methods.

## Visualization
#### With and without EDAS
![[Graph Placeholder](path/to/example_graph.png)](https://github.com/Safwanmahmoud/EDAS/blob/main/EDAS%20Vs%20Conv.jpg)

## About the algorithm
For a deeper understanding of the algorithm and its tunable parameters, please refer to the paper (Link).

## Usage Example (MATLAB)
```matlab
%% Creating synthetic signal
t = 0:0.1:100;                                                              % Time array

y1 = 1*(sin(1*t) + sin(2*t) + sin(3*t));                                    % Oscillatory component

steep = 0.9;                                                                % Paramter controlling steepness of transient component
y2 = 20*tanh(steep*(40-t));                                                 % Transient component

noise_ = wgn(1,1001,5,'linear');                                            % Additive white Gaussian noise

y = y1 + y2 + noise_;                                                       % Synthetic signal
        
%% Smoothing
w = 100;
y_conventional = movmean(y, w);                                             % Conventional moving mean

segmaFactor = 1;
rf = 10;
method = "ma";
numIterations = 1;
vis = false;
y_edas = edas(y, w, segmaFactor, rf, method, numIterations, vis);           % EDAS moving mean    

%% Visualizing
subplot(211)
plot(y, "Color",[155 155 155]/255, "LineWidth",2);
hold on
plot(y_conventional, "Color","red", "LineWidth",2);
xlim([0 800])
title("Conventional Moving Average")

subplot(212)
plot(y, "Color",[155 155 155]/255, "LineWidth",2);
hold on
plot(y_edas, "Color","red", "LineWidth",2);
xlim([0 800])
title("EDAS Moving Average")
```

## Citation
If you use this code in your research, please cite our paper:

> Mohammed, S., Gandhi, N. J., Bourelly, C., & Dallal, A. H. (2025). Euclidean Distance based Adaptive Sampling Algorithm for Disassociating Transient and Oscillatory Components of Signals. bioRxiv. https://doi.org/10.1101/2025.02.23.639754

BibTeX:
```bibtex
@article{mohammed2025edas,
  author    = {Safwan Mohammed and Neeraj J. Gandhi and Clara Bourelly and Ahmed H. Dallal},
  title     = {Euclidean Distance based Adaptive Sampling Algorithm for Disassociating Transient and Oscillatory Components of Signals},
  journal   = {bioRxiv},
  year      = {2025},
  doi       = {10.1101/2025.02.23.639754},
  url       = {https://www.biorxiv.org/content/10.1101/2025.02.23.639754v1},
  note      = {Preprint}
}

```

## Contact
For questions or contributions, please open an issue or contact us at [safwanmahmoud60@gmail.com].
