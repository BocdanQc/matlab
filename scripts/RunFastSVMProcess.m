%This script is used to run a quick surface identification SVM training and testing.

%% Ensure the normalized feature data for training and testing is loaded.
if (~exist('NormFeaturesTrain','var') || ~exist('NormFeaturesTest','var'))
    load('SurfaceFeatures (v1.2).mat');
end

%% Ensure the surface names are present for the Confusion Matrix display
if (~exist('SurfaceNames','var'))
    load('SurfaceData (v1.2).mat');
end

%% Keep a subset of features training data

% Features index organization
%      1   2   3   4   5   6   7
%   +-                          -+
% X | **  02  03  04  05  **  ** |
% Y | **  09  10  11  12  **  ** |
% Z | **  16  17  18  19  **  ** |
%   +-                          -+
%FeaturesToKeep = 1 : 21;
%FeaturesToKeep = [1 3 5 6 7 8 10 11 12 13 14 15 16 18 19 20 21];
FeaturesToKeep = [1 3 5 7 8 10 12 14 15 17 19 21];
%FeaturesToKeep = [1 3 6 7 8 10 13 14 15 17 20 21];
%FeaturesToKeep = [2 3 4 5 9 10 11 12 16 17 18 19];

NormFeaturesTrainUsed = NormFeaturesTrain(:, FeaturesToKeep);

% Keep even indexes of the features to keep for training
IndexToKeep = (1 : floor(size(NormFeaturesTrain, 1) / 2)) * 2;
NormFeaturesTrainEven = NormFeaturesTrainUsed(IndexToKeep, :);
if (size(NormFeatureLabelsTrain, 1) == 1)
    NormFeatureLebelsTrainEven = NormFeatureLabelsTrain';
    NormFeatureLebelsTrainEven = NormFeatureLebelsTrainEven(IndexToKeep);
else
    NormFeatureLebelsTrainEven = NormFeatureLebelsTrainEven(IndexToKeep);
end

% Keep odd indexes of the features to keep for verification
IndexToKeep = IndexToKeep - 1;
NormFeaturesTrainOdd = NormFeaturesTrainUsed(IndexToKeep, :);
if (size(NormFeatureLabelsTrain, 1) == 1)
    NormFeatureLebelsTrainOdd = NormFeatureLabelsTrain';
    NormFeatureLebelsTrainOdd = NormFeatureLebelsTrainOdd(IndexToKeep);
else
    NormFeatureLebelsTrainOdd = NormFeatureLebelsTrainOdd(IndexToKeep);
end

NormFeaturesTestUsed = NormFeaturesTest(:, FeaturesToKeep);
if (size(NormFeatureLabelsTest, 1) == 1)
    NormFeatureLabelsTestUsed = NormFeatureLabelsTest';
else
    NormFeatureLabelsTestUsed = NormFeatureLabelsTest;
end

%% Train libsvm with the reduced data set (even indexes).
% Set the default values for C and Gamma.
% (These values are based on previous experimentations.)
DefaultC = 2^4;
DefaultGamma = 1 / size(FeaturesToKeep, 2);

FastSVMModel = svmtrain(NormFeatureLebelsTrainEven, NormFeaturesTrainEven, ['-c ', num2str(DefaultC), ' -g ', num2str(DefaultGamma)]);

%% Predictions with the fast model on the reduced train data set (odd indexes)
[TrainOddPredictedLabels, TrainOddAccuracy, ~] = svmpredict(NormFeatureLebelsTrainOdd, NormFeaturesTrainOdd, FastSVMModel);

% Creating the Confusion Matrix with the actual labels vs the predicted labels
TrainOddConfusionMatrix = ConfusionMatrix(NormFeatureLebelsTrainOdd', TrainOddPredictedLabels') * 100.0;

% Display the classification results.
PlotConfusionMatrix(TrainOddConfusionMatrix', SurfaceNames, false);

%% Predictions with the fast model on the reduced test data set
[PredictedLabels, FastSVMAccuracy, ~] = svmpredict(NormFeatureLabelsTestUsed, NormFeaturesTestUsed, FastSVMModel);

% Creating the Confusion Matrix with the actual labels vs the predicted labels
FastSVMConfusionMatrix = ConfusionMatrix(NormFeatureLabelsTestUsed', PredictedLabels') * 100.0;
    
% Display the classification results.
PlotConfusionMatrix(FastSVMConfusionMatrix', SurfaceNames, false);
