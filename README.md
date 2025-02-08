# Euclidean Distance-based Adaptive Sampling (EDAS)

**EDAS** is an adaptive smoothing algorithm designed to separate transient and oscillatory components in neural signals. By dynamically adjusting the sampling rate based on Euclidean distance thresholds, EDAS captures sharp transitions while minimizing spectral leakage, outperforming conventional methods.

## Features
- Adaptive up-sampling for transient component preservation
- Custom smoothing for oscillatory component extraction
- Works with both synthetic and real neural data (EEG, LFP, ECoG)
- Implementations available in **MATLAB** and **Python**

## Visualization
### Overview of EDAS Algorithm
![[Algorithm Flowchart](path/to/flowchart.png)](https://github.com/Safwanmahmoud/EDAS/blob/main/Figure2_20.jpeg)

### Example Results
#### Before and After EDAS Processing
![Graph Placeholder](path/to/example_graph.png)

#### EDAS in Action
![GIF Placeholder](path/to/example_visualization.gif)

## Installation
### MATLAB
Clone this repository and add the MATLAB functions to your path:
```matlab
addpath('path/to/edas_repo');
```

### Python
Install dependencies and clone the repository:
```bash
pip install -r requirements.txt
```

## Usage Example (MATLAB)
```matlab
% Load sample signal
t = 0:0.001:1;
signal = sin(2*pi*10*t) + 0.5*tanh(10*(t-0.5));

% Apply EDAS algorithm
params.window_size = 0.15;  % Smoothing window size
params.resample_factor = 10;  % Downsampling factor
params.threshold_factor = 1.5;  % Sensitivity parameter

[transient, oscillatory] = edas(signal, params);

% Plot results
figure;
subplot(3,1,1); plot(t, signal); title('Original Signal');
subplot(3,1,2); plot(t, transient); title('Extracted Transient Component');
subplot(3,1,3); plot(t, oscillatory); title('Extracted Oscillatory Component');
```

## Usage Example (Python)
*Coming soon!*

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

## License
[MIT License](LICENSE)

## Contact
For questions or contributions, please open an issue or contact us at [your email].
