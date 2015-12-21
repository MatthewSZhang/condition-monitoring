function [Mu,Sigma,Phi] = MixGauss(TrainMatrix,Mu,Sigma,Phi, ...
                                    numiterations)
% Mu must be numfeatures x numclusters
% Sigma must be numfeatures x numfeatures x numclusters
% Phi must be numclusters x 1

numclusters = size(Mu,2);
numfeatures = size(TrainMatrix,1);
numtrainexamples = size(TrainMatrix,2);

w = zeros(numclusters,numtrainexamples);

% Begin while loop (following procedure in page 2-3 of the Mixture of
% Gaussians and EM algorithm section
iter = 0;
while iter < numiterations
    
    % E-step: determine the w-array
    PDF = zeros(numclusters,1);
    for i=1:numtrainexamples
        % E-step
        denom = 0;
        for n=1:numclusters
            PDF(n) = mvnpdf(TrainMatrix(:,i),Mu(:,n),Sigma(:,:,n))*Phi(n);
            denom = denom+PDF(n);
        end

        % Calculate the w probability for each cluster
        w(:,i) = PDF/sum(PDF);

    end
    
    % M-step
    % Update phi for each category
    for n=1:numclusters
        Phi(n) = sum(w(n,:))/numtrainexamples;
    end
    
    % Update mu for each category
    Mu = zeros(numfeatures,numclusters);
    for n=1:numclusters
        for i=1:numtrainexamples
            Mu(:,n) = Mu(:,n) + w(n,i)*TrainMatrix(:,i);
        end
        % Divide by the total number of each category
        Mu(:,n) = Mu(:,n)/sum(w(n,:));
    end
    
    % Update Sigma for each category
    Sigma = zeros(numfeatures,numfeatures,numclusters);
    for n=1:numclusters
        for i=1:numtrainexamples
            Sigma(:,:,n) = Sigma(:,:,n) + w(n,i)* ...
                (TrainMatrix(:,i)-Mu(:,n))*(TrainMatrix(:,i)-Mu(:,n))';
        end
        Sigma(:,:,n) = Sigma(:,:,n)/sum(w(n,:));
    end
    
    iter = iter+1;    
end
