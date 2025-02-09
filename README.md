# Euclidean Distance-based Adaptive Sampling (EDAS)

**EDAS** is an adaptive smoothing algorithm designed to separate transient and oscillatory components in neural signals. By dynamically adjusting the sampling rate based on Euclidean distance thresholds, EDAS captures sharp transitions while minimizing spectral leakage, outperforming conventional methods.

## Visualization
#### Before and After EDAS Processing
![[Graph Placeholder](path/to/example_graph.png)](https://github.com/Safwanmahmoud/EDAS/blob/main/EDAS%20Vs%20Conv.jpg)

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

> Mohammed et al., "Euclidean Distance-based Adaptive Sampling Algorithm for Disassociating Transient and Oscillatory Components in Signals," *Journal/Conference Name*, Year.

BibTeX:
```bibtex
@article{mohammed2024edas,
  author = {Safwan Mohammed, Neeraj J. Gandhi, Clara Bourelly, Ahmed Dallal},
  title = {Euclidean Distance-based Adaptive Sampling Algorithm for Disassociating Transient and Oscillatory Components in Signals},
  journal = {Journal/Conference Name},
  year = {2024}
}
```

## Contact
For questions or contributions, please open an issue or contact us at [safwanmahmoud60@gmail.com].
