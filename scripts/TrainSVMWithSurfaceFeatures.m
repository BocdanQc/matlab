function svmmodel = TrainSVMWithSurfaceFeatures(features, featureslabels)
%function svmmodel = TrainSVMWithSurfaceFeatures(features, featureslabels)
%  DESCRIPTION
%    This function will first do a refined Grid Search for the parameters C
%    and Gamma with 10-fold Cross Validation to determine the best values to
%    used to train libsvm. It will also do another 10-fold Cross validation
%    with the current best C parameter and with Gamma = 1 / number of
%    features. It will then use these results to create a model to do
%    predictions based on the training data.
%    
%    The refined Grid Search will be with these value range:
%       C = 2^2 to 2^4 with an exponent increment of 0.25
%       Gamma = 2^-6 to 2^-4 with an exponent increment of 0.25
%
%    Note: A coarse Grid Search was previously tested with C = 2^-5 to 2^15
%          and Gamma = 2^-15 to 2^3, both with an exponent increment of 1).
%  INPUT
%    features: The features used to train libsvm
%    featureslabels: The labels (classes) of the features used to train
%                    libsvm.
%  OUTPUT
%    svmmodel: The model provided by libsvm based on the given features.

    %% Ensures the labels are in the right format for svmtrain of libsvm
    if (size(featureslabels, 1) == 1)
        featureslabels = featureslabels';
    end
    
    %% Refined Grid Search for C and Gamma with 10-fold Cross Validation
    disp('--- Refined Grid Search for C and Gamma with 10-fold Cross Validation ---');

    bestCVRate = 0.0;
    bestExpC = 0;
    bestExpGamma = 0;

    for expC = 2 : 0.25 : 4
        C = 2 ^ expC;
        for expGamma = -6 : 0.25 : -4
            Gamma = 2 ^ expGamma;
            disp('Testing:')
            fprintf('\tC     = %-.6f\n', C);
            fprintf('\tGamma = %-.6f\n', Gamma);
            cmd = ['-v 10 -c ', num2str(C), ' -g ', num2str(Gamma)];
            CVrate = svmtrain(featureslabels, features, cmd);
            if (CVrate >= bestCVRate)
                bestCVRate = CVrate;
                bestExpC = expC;
                bestExpGamma = expGamma;
            end
        end
    end
    
    %% 10-fold Cross validation with the best C and Gamma = 1 / number of features
    disp('--- 10-fold Cross validation with the best C and Gamma = 1 / number of features ---');
    C = 2 ^ bestExpC;
    Gamma = 1 / size(features, 2);
    disp('Testing:')
    fprintf('\tC     = %-.6f\n', C);
    fprintf('\tGamma = %-.6f\n', Gamma);
    cmd = ['-v 10 -c ', num2str(C), ' -g ', num2str(Gamma)];
    CVrate = svmtrain(featureslabels, features, cmd);

    bestC = 2 ^ bestExpC;
    if (CVrate >= bestCVRate)
        bestGamma = Gamma;    
    else
        bestGamma = 2 ^ bestExpGamma;    
    end

    disp('--- Search Results for C and Gamma with 10-fold Cross Validation ---');
    disp('The best values are:');
    fprintf('\tC     = %-.6f\n', bestC);
    fprintf('\tGamma = %-.6f\n', bestGamma);

    %% Creating the SVM model based on the best C and Gamma found
    disp('--- Applying the best values of C and Gamma to the full data set through the SVM trainer ---')
    cmd = ['-c ', num2str(bestC), ' -g ', num2str(bestGamma)];
    svmmodel = svmtrain(featureslabels, features, cmd);
end
