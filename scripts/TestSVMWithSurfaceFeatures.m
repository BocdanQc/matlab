function [cm, accuracy] = TestSVMWithSurfaceFeatures(features, featureslabels, svmmodel)
%function TestSVMWithSurfaceFeatures(features, featureslabels, svmmodel)
%  DESCRIPTION
%    This function gets the prediction of the classes based on given model
%    fed to libsvm.
%  INPUT
%    features: The features to test against the given SVM model.
%    featureslabels: The labels (classes) of the features.
%    svmmodel: The trained model to do the predictions.
%  OUTPUT
%    cm: The Confusion Matrix
%    accuracy: The accuracy of the predictions provided by libsvm

    %% Ensures the labels are in the right format for svmtrain of libsvm
    if (size(featureslabels, 1) == 1)
        featureslabels = featureslabels';
    end

    %% Predicting the classes based on the trained model.
    disp('--- Predicting the classes based on the trained model. ---')
    [predictedlabels, accuracy, ~] = svmpredict(featureslabels, features, svmmodel);

    %% Creating the Confusion Matrix with the actual labels vs the predicted labels
    cm = ConfusionMatrix(featureslabels', predictedlabels') * 100.0;
end
