function [pcavectors, pcadata] = EigenPCA(normdata, nbcomponents)
%[pcavectors, pcadata] = EigenPCA(normdata, nbcomponents)
%  DESCRIPTION
%    This function returns the "nbcomponents" top vectors of principal component
%    coefficients using the Eigenvalue decomposition (EIG) of the covariance
%    matrix algorithm. The PCA coefficients (Eigenvectors) are arranged in rows.
%
%    Note: Calling this function:
%              [pcavectors, pcadata] = EigenPCA(MyData, 3);
%          is similar to calling that function: 
%              [coeff, score, ~, ~, ~] = pca(MyData, 'Algorithm', 'eig', 'Centered', true, 'NumComponents', 3);
%          where:
%              pcavectors' == coeff
%              pcadata' == score
%          Type "help pca" in the command window for more information.
%  INPUT
%    normdata: The normalized data to transform.
%    nbcomponents: The number of Principal Component Coefficients vectors
%                  to return.
%                  If not set or equal to 0, then all vectors are returned.
%  OUTPUT
%    pcavectors: nbcomponents vectors of Principal Component Coefficients.
%    pcadata: The transformed normdata (Principal Component Scores).

    % Center the data by taking out the average.
    centereddata = normdata - repmat(mean(normdata), size(normdata, 1), 1);

    % Compute the eigenvectors and values of the covariance matrix
    [eigvects, eigvalues] = eig(cov(centereddata));
    % The eigenvectors are in column, change it to rows of eigenvectors.
    eigvects = eigvects';
    eigvalues = diag(eigvalues);

    [~, sortedindex] = sort(eigvalues, 1, 'descend');

    if (~exist('nbcomponents', 'var') || nbcomponents == 0)
        nbcomponents = size(eigvects, 1);
    end

    for i = 1 : nbcomponents
        pcavectors(i,:) = eigvects(sortedindex(i),:);
    end

    pcadata = pcavectors * (centereddata');
end

