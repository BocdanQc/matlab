%This script is used to run the complete surface identification training and testing.

%% Ensure the raw surface data for training and testing is loaded.
if (~exist('RawSurfaceDataTrain','var') || ~exist('RawSurfaceDataTest','var'))
    load('RawSurfaceData (v1.2).mat');
end

%% Clean the raw surface data for training and testing.
if (~exist('SurfaceDataTrain','var') || ~exist('SurfaceNames','var'))
    [SurfaceDataTrain, SurfaceDataQualityTrain, SurfaceNames] = CleanRawSurfaceData(RawSurfaceDataTrain);
end
if (~exist('SurfaceDataTest','var'))
    [SurfaceDataTest, SurfaceDataQualityTest, ~] = CleanRawSurfaceData(RawSurfaceDataTest);
end

%% Set the sample window size to extract the surface features.
WindowSize = 800;

%% Extract and normalize the surface features for training and testing.
if (~exist('FeaturesTrain','var') || ~exist('FeaturesTest','var') || ~exist('NormalizationFactors','var'))
    % First, extract the surface features
    [FeaturesTrain, FeaturesTrainLabels, NormalizationFactors] = ExtractSurfaceFeatures(SurfaceDataTrain, WindowSize);
    [FeaturesTest, FeaturesTestLabels, ~] = ExtractSurfaceFeatures(SurfaceDataTest,  WindowSize);

    % Second, normalize the surface features for training and testing using
    % the same normalization factors from the training data set.
    disp('Normalization of the extracted surface features');
    FeaturesTrain = NormalizeSurfaceFeatures(FeaturesTrain, NormalizationFactors);
    FeaturesTest = NormalizeSurfaceFeatures(FeaturesTest, NormalizationFactors);
end

%% Train the libsvm with the surface features for training.
if (~exist('SVMModel','var'))
    SVMModel = TrainSVMWithSurfaceFeatures(FeaturesTrain, FeaturesTrainLabels);
end

%% Test the libsvm model with the surface features for testing
if (~exist('CM','var') || ~exist('Accuracy','var'))
    [CM, Accuracy] = TestSVMWithSurfaceFeatures(FeaturesTest, FeaturesTestLabels, SVMModel);
end

%% Display the classification results.
PlotConfusionMatrix(CM', Accuracy(1), SurfaceNames);
