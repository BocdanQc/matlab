function cleandata = RemoveOutliers(rawdata)
%function cleandata = RemoveOutliers(rawdata)
%  DESCRIPTION
%    This function is used to remove NaN and outliers in the data set.
%    An outlier is considered to have more than 5 times the standard deviation.
%  INPUT
%    rawdata: An array of data to clean.
%  OUTPUT
%    cleandata: An array of clean data without outliers.

    NB_SIGMA = 5;
    
%% First, prune the NaNs
    indexnan = isnan(rawdata);
    indextokeep = sum(indexnan, 2) == 0;
    cleandata = rawdata(indextokeep, :);
    
%% Second, remove the outliers
    outlierhighs = [];
    outlierlows = [];
    for i = 1 : size(cleandata, 2)
        threshold = std(cleandata) * NB_SIGMA;
        avg = mean(cleandata);
        
        outlierhighs(:, i) = (cleandata(:, i) > (avg(i) + threshold(i)));
        outlierlows(:, i) = (cleandata(:, i) < (avg(i) - threshold(i)));
    end
    
    outliers = outlierhighs + outlierlows;
    indextokeep = sum(outliers, 2) == 0;

    cleandata = cleandata(indextokeep, :);
end
