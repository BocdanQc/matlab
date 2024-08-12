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

NormFeaturesTrainReduced = NormFeaturesTrain(:, FeaturesToKeep);
NormFeaturesTestReduced = NormFeaturesTest(:, FeaturesToKeep);

%% Train the SVM with the reduced data set.
% Set the default values for C and Gamma.
% (These values are based on previous experimentations.)
DefaultC = 2^4;
DefaultGamma = 1 / size(FeaturesToKeep, 2);
SVMModelReduced = TrainSVMWithSurfaceFeatures(NormFeaturesTrainReduced, NormFeatureLabelsTrain, 'C', DefaultC, 'Gamma', DefaultGamma);

%% Predictions with the SVM model on the reduced test data set
[SVMConfusionMatrixReduced, SVMAccuracyReduced] = TestSVMWithSurfaceFeatures(NormFeaturesTestReduced, NormFeatureLabelsTest, SVMModelReduced);
    
PlotConfusionMatrix(SVMConfusionMatrixReduced', SurfaceNames);
