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

% Plot the data set, with PCA transformation, in 3D
figure('Name', 'PCA Transformation', 'NumberTitle', 'off');
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
    TrainingData = PCAData(:, indextokeep)';
    Means{i} = mean(TrainingData);
    Covs{i} = cov(TrainingData);
end

% Then evaluate the probability for each sample
for sample = 1 : size(TransformedData,2)
    for i = 1 : max(NormFeatureLabelsTrain)
        Predictions(sample, i) = mvnpdf(PCAData(:, sample)', Means{i}, Covs{i});
    end
end
% and pick the maximum a posteriori hypothesis
[~, PredictedLabels] = max(Predictions');

% Crude estimation of the success rate
SuccessRate = 100 * sum(PredictedLabels == NormFeatureLabelsTrain) / size(PCAData, 2);

%% Create a confusion matrix
PCAGaussianFitCM = ConfusionMatrix(NormFeatureLabelsTrain, PredictedLabels) * 100.0;

fprintf('Classification for PCA with 3 dimensions kept (no mean), Gaussian fit: %.2f percent\n', SuccessRate);
PlotConfusionMatrix(PCAGaussianFitCM, SuccessRate, SurfaceNames)

