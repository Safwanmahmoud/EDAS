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