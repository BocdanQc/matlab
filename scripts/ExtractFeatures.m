function [features, featurenames] = ExtractFeatures(window)
%function [features, featurenames] = ExtractFeatures(window)
%  DESCRIPTION
%    This function extracts the following 8 features from the given window of samples.
%    Features: 1. Mean
%              2. Variance
%              3. Skewness
%              4. Kurtosis
%              5. Fifth Moment
%              6. The sum of variations over time
%              7. The number of times 20 uniformly separated thresholds are crossed
%              8. The sum of the highest half of the amplitude spectrum
%  INPUT
%    window: An array of 1 x N samples corresponding to accelerometer data.
%  OUTPUT
%    features: The array 1 x 8 features listed above.
%    featurenames: An array of strings for the features names.

    if (size(window, 1) > size(window, 2))
        window = window';
    end
    windowsize = size(window, 2);
    
    %% Feature 1: Mean
    featurenames{1} = 'Mean';
    features(1) = mean(window);

    %% Feature 2: Variance
    featurenames{2} = 'Variance';
    features(2) = var(window);

    %% Feature 3: Skewness
    featurenames{3} = 'Skewness';
    features(3) = skewness(window);

    %% Feature 4: Kurtosis
    featurenames{4} = 'Kurtosis';
    features(4) = kurtosis(window);

    %% Feature 5: Fifth Moment
    featurenames{5} = 'Fifth Moment';
    features(5) = moment(window, 5);

    %% Feature 6: The sum of variations over time
    featurenames{6} = 'Area of Crossings';
    features(6) = sum(HistogramLineCrossings(window', 30) ./ (30 * windowsize));

    %% Feature 7: The number of times 20 uniformly separated thresholds are crossed
    featurenames{7} = 'Sum of Changes';
    features(7) = sum(abs((window(1 : (end - 1)) - window(2 : end)) / windowsize)) ./ windowsize;         
    
    %% Feature 8: The sum of the highest half of the amplitude spectrum
    featurenames{8} = 'Sum of High Frequencies';
    windowspectrum = abs(fft(window));
    windowspectrum = windowspectrum(1 : 0.5 * windowsize);
    features(8) = sum(windowspectrum(ceil(size(windowspectrum, 2) * 0.5) : end)) / (0.5 * windowsize);                
return

function ret = HistogramLineCrossings(values, nbin)
    range = max(values) - min(values);
    incr = range / nbin;
    index = 1;
    for t = (min(values) + incr) : incr : (max(values) - incr)
        ret(index) = LineCrossings(values, t);
        index = index + 1;
    end
return

function ret = LineCrossings(values, threshold)
    values = values - threshold;
    ret = sum(values(1:end-1) .* values(2:end) < 0);
return
