function [transientComponent, oscillatoryComponent] = edas(signal, w, segmaFactor,rf, method, numIterations,vis)

% Input arguments

% signal: input signal
% w: window
% segmaFactor: variable controlling the threshold that decides which areas gets upsampled
% rf: down sampling factor
% method: the smoothing method {"sg": savitsy-golay, "ma": Moving average, "Ir": Loacal regression}
% numIteration: number of iterations 
% vis: boolean controlling visualization of steps

% Initializing the transient component as a signal to be updated iteratively

transientComponent = zeros([numIterations+1 length(signal)]);
transientComponent(1,:) = signal;

for ii = 1:numIterations
    % Down-sampling the signal
    signal_ = resample(transientComponent(ii,:), 1, rf);
    
    % Calculating the distance array
    x = 0:(length(signal_) - 1);
    d = eucDist(x(1:end-1), x(2:end), signal_(1:end-1), signal_(2:end));
    
    % Calculating the threshold (T) on the distance array
    threshold_ = median(d) + segmaFactor * mad(d);  % The threshold is set to be segmaFactor times the standard deviation (σ)
    
    % Adding more points
    y_ = [];
    indices = [];
    add_pnts_x = [];
    add_pnts_y = [];

    for i = 1:length(d)
        % Add the current point
        y_(end+1) = signal_(i);
        indices(end+1) = length(y_);
        
        % Add interpolated points if the distance exceeds the threshold
        if round(d(i) / threshold_) > 1
            p1 = [x(i), signal_(i)];
            p2 = [x(i+1), signal_(i+1)];
            n = round(d(i) / (median(d) + std(d)));  % Number of added points

            x_coords = linspace(p1(1), p2(1), n+2);
            y_coords = linspace(p1(2), p2(2), n+2);
            y_coords = y_coords(2:end-1);  % Exclude endpoints to avoid duplication
            x_coords = x_coords(2:end-1);  % Exclude endpoints to avoid duplication
     
            add_pnts_x(end+1:end+n) = x_coords;
            add_pnts_y(end+1:end+n) = y_coords;
           
            y_(end+1:end+n) = y_coords;
        end
    end
    % Add the last point
    indices(end+1) = length(y_) + 1;
    y_(end+1) = signal_(end);
    
    % Smoothing the signal
    switch method
        case "sg"  % Savitzky-Golay filter
            if mod(round(w/rf), 2) == 0
                w_ = round(w/rf) - 1;
            else
                w_ = round(w/rf);
            end
            sy = sgolayfilt(y_, 3, w_);
        case "ma"  % Moving average
            sy = movmean(y_, round(w/rf));
        case "lr"  % Local regression (Loess)
            sy = smooth(y_, round(w/rf), "loess");
    end
    
    % Extract the smoothed signal at the original indices
    y_ = sy(indices);
    
    % Upsampling again
    temp = resample(y_, rf, 1);
    
    % Output the final signal
    transientComponent(ii+1,:) = temp(1:length(transientComponent(ii,:)));
    
    % Visualizing process and results
    min_ = min(signal) - 0.01*(length(signal));
    max_ = max(signal) + 0.01*(length(signal));
    if vis == true
        subplot(numIterations+1, 5, 1)  % Input signal
        plot(signal, "color", [155 155 155]/255, "LineWidth",1)
        xlabel("Time (ms)")
        ylabel("V (mv)")
        title ('A','FontSize',15); 
        ax = gca;
        ax.TitleHorizontalAlignment = 'left';
        ylim([min_ max_])

        subplot(numIterations+1,5,5) % Output (Transient component)
        plot(signal, "color", [155 155 155]/255, "LineWidth",1)
        legs = ["Input Signal"];
        hold on
        for iter = 1:numIterations
            plot(transientComponent(iter+1,:)', "LineWidth",2, "Color",[55+iter*(200/numIterations) 0 0]/255)
            legs(end+1) = ("Iteration: "+ iter);
        end
        plot(movmean(signal, w), "Color",[0 100 0]/255, "LineWidth",2)
        legs(end+1) = "Conventional";
        legend(legs)
        xlabel("Time (ms)")
        ylabel("V (mv)")
        title ('B','FontSize',15); 
        ax = gca;
        ax.TitleHorizontalAlignment = 'left';
        ylim([min_ max_])
        hold off

        subplot(numIterations+1, 10, ii*10+3)  % Down-sampled signal
        plot(signal_, ".black", "LineWidth",1,"LineStyle","-")
        xlabel("Time (ms)")
        ylabel("V (mv)")
        ylim([min_ max_])

        subplot(numIterations+1, 10, ii*10+4)  % Eucledian distance array
        plot(d, "xblue","LineWidth",2)
        xlabel("Time (ms)")
        ylabel("Euc. Distance")
        yline(threshold_, "-red","LineWidth",2)
        yline(median(d),"-black", "LineWidth",2)

        subplot(numIterations+1, 10, ii*10+5)  % Down-sampled signal
        plot(signal_, ".black", "LineWidth",1,"LineStyle","-")
        hold on
        scatter(add_pnts_x+1, add_pnts_y, "red", "filled")
        xlabel("Time (ms)")
        ylabel("V (mv)")
        ylim([min_ max_])
        hold off

        subplot(numIterations+1, 10, ii*10+6)  % Smoothed signal
        plot(y_, ".black", "LineWidth",1,"LineStyle","-")
        hold on
        sy(indices) = [];
        scatter(add_pnts_x+1, sy, "red","filled")
        xlabel("Time (ms)")
        ylabel("V (mv)")
        ylim([min_ max_])
        hold off

        subplot(numIterations+1, 10, ii*10+7)  % Removed excess points
        plot(y_, ".black", "LineWidth",1,"LineStyle","-")
        xlabel("Time (ms)")
        ylabel("V (mv)")
        ylim([min_ max_])

        subplot(numIterations+1, 10, ii*10+8)  % Output signal
        plot(transientComponent(ii+1,:), "color", [55+ii*(200/numIterations) 0 0]/255, "LineWidth",2,"LineStyle","-")
        xlabel("Time (ms)")
        ylabel("V (mv)")
        ylim([min_ max_])
    end
end
oscillatoryComponent = signal - transientComponent(end,:);
transientComponent = transientComponent(end,:);
end