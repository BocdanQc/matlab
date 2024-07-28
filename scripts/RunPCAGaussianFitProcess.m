% This script applies a PCA to the normalized feature data and uses a
% Gaussian Mixture Model to do the classification instead of using libsvm.

%% Ensure the normalized feature data for training and testing is loaded.
if (~exist('NormFeaturesTrain','var') || ~exist('NormFeaturesTest','var'))
    load('SurfaceFeatures (v1.2).mat');
end

%% Ensure the surface names are present for the Confusion Matrix display
if (~exist('SurfaceNames','var'))
    load('SurfaceData (v1.2).mat');
end

%% Perform the PCA transformation
[~, PCAData] = EigenPCA(NormFeaturesTrain, 3);

i = 1;
for hue = 0 : 0.07 : 1.0
    for sat = 1.0 : -0.5 : 0.5
        colors{i} = hsv2rgb([hue, sat, 1]);
        i = i + 1;
    end
end

% Plot the data set, with PCA transformation
figure('Name', 'PCA Transformation - First 2 Components');
for i = 1 : max(NormFeatureLabelsTrain)
    indextokeep = find(i == NormFeatureLabelsTrain);
    plot(PCAData(1, indextokeep), PCAData(2, indextokeep), '.', 'MarkerEdgeColor', colors{i});
    hold on;
end

figure('Name', 'PCA Transformation - First 3 Components');
for i = 1 : max(NormFeatureLabelsTrain)
    indextokeep = find(i == NormFeatureLabelsTrain);
    plot3(PCAData(1, indextokeep), PCAData(2, indextokeep), PCAData(3, indextokeep), '.', 'MarkerEdgeColor', colors{i});
    hold on;
end

%% Gaussian Fit
% ======================= Gaussian Mixture Model ==========================
% We will simply train a single Gaussian on each of the data set by
% computing the mean and covariance for each of the data sets.
for i = 1 : max(NormFeatureLabelsTrain)
    indextokeep = find(i == NormFeatureLabelsTrain);
    PCATrainingData = PCAData(:, indextokeep)';
    PCAMeans{i} = mean(PCATrainingData);
    PCACovs{i} = cov(PCATrainingData);
end

% Then evaluate the probability for each sample
for sample = 1 : size(PCAData, 2)
    for i = 1 : max(NormFeatureLabelsTrain)
        Predictions(sample, i) = mvnpdf(PCAData(:, sample)', PCAMeans{i}, PCACovs{i});
    end
end
% and pick the maximum a posteriori hypothesis
[~, PredictedLabels] = max(Predictions');

% Crude estimation of the successful prediction rate
PCAGaussianFitSuccessRate = 100 * sum(PredictedLabels == NormFeatureLabelsTrain) / size(PCAData, 2);
fprintf('The Gaussian Fit classification for PCA with the first 3 components is %.2f percent\n', PCAGaussianFitSuccessRate);

%% Create a confusion matrix
PCAGaussianFitConfusionMatrix = ConfusionMatrix(NormFeatureLabelsTrain, PredictedLabels) * 100.0;

PlotConfusionMatrix(PCAGaussianFitConfusionMatrix', SurfaceNames, false);
