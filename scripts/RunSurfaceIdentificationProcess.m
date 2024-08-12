%This script is used to run the complete surface identification training and testing.

%% Close all figures
close all hidden;

%% Ensure the raw surface data for training and testing is loaded.
if (~exist('RawSurfaceDataTrain','var') || ~exist('RawSurfaceDataTest','var'))
    load('RawSurfaceData (v1.2).mat');
end

%% Clean the raw surface data for training and testing.
if (~exist('SurfaceDataTrain','var') || ~exist('SurfaceNames','var'))
    disp('Cleaning Surface Data for Training');
    [SurfaceDataTrain, SurfaceDataQualityTrain, SurfaceNames] = CleanRawSurfaceData(RawSurfaceDataTrain);
end
if (~exist('SurfaceDataTest','var'))
    disp('Cleaning Surface Data for Testing');
    [SurfaceDataTest, SurfaceDataQualityTest, ~] = CleanRawSurfaceData(RawSurfaceDataTest);
end

%% Set the sample window size to extract the surface features.
WindowSize = 800;

%% Display the first sample window for all axis of the surface data used to train libsvm.
PlotAllSurfaceData(SurfaceDataTrain, WindowSize, SurfaceNames)

%% Extract the surface features.
if (~exist('FeaturesTrain','var') || ~exist('FeaturesTest','var'))
    disp('Extracting Features from Surface Data for Training');
    [FeaturesTrain, FeatureNamesTrain] = ExtractSurfaceFeatures(SurfaceDataTrain, WindowSize);
    disp('Extracting Features from Surface Data for Testing');
    [FeaturesTest, FeatureNamesTest] = ExtractSurfaceFeatures(SurfaceDataTest, WindowSize);
end

%% Display all the extracted surface features for all axis and for all surface data.
PlotAllComparedSurfaceFeatures(FeaturesTrain, FeaturesTest, FeatureNamesTrain, SurfaceNames);

%% Normalize the surface features for libsvm training and testing. The Mean feature is removed from the data sets.
if (~exist('NormFeaturesTrain','var') || ~exist('NormFeaturesTest','var'))
    disp('Normalizing Extracted Features from Surface Data for Training');
    [NormFeaturesTrain, NormFeatureLabelsTrain, NormFactors] = NormalizeSurfaceFeatures(FeaturesTrain, FeatureNamesTrain);
    disp('Normalizing Extracted Features from Surface Data for Testing with Normalization Factors used for the training data set');
    [NormFeaturesTest, NormFeatureLabelsTest, ~] = NormalizeSurfaceFeatures(FeaturesTest, FeatureNamesTest, NormFactors);
end

%% Split the training data evenly into 2 sets: odd indexes and even indexes
IndexEven = (1 : floor(size(NormFeaturesTrain, 1) / 2)) * 2;
IndexOdd = IndexEven - 1;

NormFeaturesTrainOdd = NormFeaturesTrain(IndexOdd, :);
NormFeatureLebelsTrainOdd = NormFeatureLabelsTrain(:, IndexOdd);

NormFeaturesTrainEven = NormFeaturesTrain(IndexEven, :);
NormFeatureLebelsTrainEven = NormFeatureLabelsTrain(:, IndexEven);

%% Train the SVM with the reduced train data set (odd indexes) with the already known best values for C and Gamma.
if (~exist('SVMModel','var'))
    SVMModel = TrainSVMWithSurfaceFeatures(NormFeaturesTrainOdd, NormFeatureLebelsTrainOdd, 'C', 2^4, 'Gamma', 2^-5.75);
end

%% Verify the SVM model on the reduced train data set (even indexes)
if (~exist('SVMConfusionMatrixPractice','var') || ~exist('SVMAccuracyPractice','var'))
    [SVMConfusionMatrixPractice, SVMAccuracyPractice] = TestSVMWithSurfaceFeatures(NormFeaturesTrainEven, NormFeatureLebelsTrainEven, SVMModel);
end
% Display the classification verification results.
disp(['The prediction success rate of the SVM model on the Practice Data Set is ', num2str(SVMAccuracyPractice(1)),'%']);
PlotConfusionMatrix(SVMConfusionMatrixPractice', SurfaceNames);

%% Validate the SVM model with the surface features for testing
if (~exist('SVMConfusionMatrix','var') || ~exist('SVMAccuracy','var'))
    [SVMConfusionMatrix, SVMAccuracy] = TestSVMWithSurfaceFeatures(NormFeaturesTest, NormFeatureLabelsTest, SVMModel);
end
% Display the classification validation results.
disp(['The prediction success rate of the SVM model on the Test Data Set is ', num2str(SVMAccuracy(1)),'%']);
PlotConfusionMatrix(SVMConfusionMatrix', SurfaceNames, false);
