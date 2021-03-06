% GRASSMANN_AVERAGE    Estimate average subspace spanned by data.
%
%     GRASSMANN_AVERAGE(X) returns a basis vector for the average one-dimensional
%     subspace spanned by the data X. This is a N-by-D matrix containing N observations
%     in R^D.
%
%     GRASSMANN_AVERAGE(X, K) returns a D-by-K matrix of orthogonal basis vectors
%     spanning a K-dimensional average subspace.
%
%     Reference:
%     "Grassmann Averages for Scalable Robust PCA".
%     S. Hauberg, A. Feragen and M.J. Black. In CVPR 2014.
%     http://ps.is.tue.mpg.de/project/Robust_PCA

%    Grassmann Averages
%    Copyright (C) 2014  Søren Hauberg
%
%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with this program.  If not, see <http://www.gnu.org/licenses/>.

function vectors = grassmann_average(X, K, options)
  
  %% Check input
  if (nargin == 0)
    error ('grassmann_average: not enough input arguments');
  elseif (nargin == 1)
    K = 1;
  end % if
  
  epsilon = 10*eps(ones(class(X)));
  
  %% Create output structure
  [N, D] = size(X);
  vectors = NaN(D, K, class(X));
  
  for k = 1:K
    %% Compute k'th principal component
    mu = rand(D, 1, class(X)) - 0.5; % Dx1 % ���
    mu = mu / norm(mu(:));
      
    %% Initialize using a few EM iterations
    for iter = 1:3
      dots = X * mu; % Nx1
      mu = dots.' * X; % 1xD
      mu = mu(:) / norm(mu); % Dx1
    end % for
    dots = []; % clear up memory
      
    %% Now the Grassmann average
    for iter = 1:N
      prev_mu = mu;

      %% Compute angles and flip
      dot_signs = sign(X * mu); % Nx1
        
      %% Compute weighted Grassmannian mean
      mu = (dot_signs).' * X; % 1xD
      mu = mu(:) / norm(mu); % Dx1

      %% Check for convergence
      if (max(abs(mu - prev_mu)) < epsilon)
        break;
      end % if

      dot_signs = []; % clear up memory
      prev_mu = []; % clear up memory
    end % for
% {
    %% Store the estimated vector (and possibly subtract it from data, and perform reorthonomralisation)
    if (k == 1)
      vectors(:, k) = mu;
    elseif (k < K)
      mu = reorth(vectors(:, 1:k-1), mu, 1);
      mu = mu / norm(mu);
      vectors(:, k) = mu;

      X = X - (X * mu) * mu.';
      %subtract_outer_product(X, X*mu, mu);
    else % k == K
      mu = reorth(vectors(:, 1:k-1), mu, 1);
      mu = mu / norm(mu);
      vectors(:, k) = mu;
    end % if
%}
%{  
    vectors(:, k) = mu;
      
    %% Remove the k'th component from the data
    if (k < K)
      X = X - (X * mu) * mu.';
      % XXX: orthononormalise!
    end % if
%}
  end % for
end % function

