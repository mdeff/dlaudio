

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Standard Sparse Coding
%
% min_Z,D 1/2*|| X - DZ ||_2^2 + lambda*|| Z ||_1
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function test_standard_sparse_coding




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load image
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[Im0,map] = imread('barbara128.tif'); fs = 3;
Im0 = double(Im0);
Im0 = double(Im0); Im0 = Im0/ max(Im0(:)); % normalize image
[Ny,Nx] = size(Im0);

% Display
if 1==1
    cpt_fig = 1;
    figure(cpt_fig); clf;
    imagesc(Im0); colormap(gray);
    truesize(cpt_fig,[round(fs*Ny) round(fs*Nx)]);
    title('Original Image');
    %pause
end





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Collect intensity patches
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if 2==1
    
    % Parameters
    % p = patch size 2m+1 x 2m+1
    m = 5;
    m = 10;
    p = 2*m + 1;
    
    % Extract patches
    fprintf('Collect patches...\n');
    X = zeros(p^2,Ny-2*m,Nx-2*m);
    u = Im0;
    tic
    for x = m+1 : Nx-m
        for y = m+1 : Ny-m
            patch = squeeze( u( y-m:y+m , x-m:x+m ) );
            patch = patch - mean(patch(:));
            X(:,y-m,x-m) = reshape(patch,p^2,1);
        end
    end
    toc
    X = reshape(X,p^2,(Ny-2*m)*(Nx-2*m)); % reshape: X(:,y,x) -> X(:,(x-1)*Ny+ y)
    
    sizeX = size(X)
    
    % Save
    save('X.mat','X','p');
    
    % Display
    if 2==1
        cpt_fig = 2;
        for x = m+1 : Nx-m
            for y = m+1 : Ny-m
                patch = squeeze( u( y-m:y+m , x-m:x+m ) );
                figure(cpt_fig); clf;
                imagesc(patch); colormap(gray);
                fs=1; truesize(cpt_fig,[round(fs*Ny) round(fs*Nx)]);
                title(['Patches - x = ', num2str(x), ' - y = ' , num2str(y) ]);
                pause(0.2)
                %pause
            end
        end
    end
    
    % Display
    if 2==1
        n = size(X,2)
        cpt_fig = 3;
        for i = 1:n
            patch = squeeze( X( : , i ) );
            patch = reshape(patch,p,p);
            figure(cpt_fig); clf;
            imagesc(patch); colormap(gray);
            fs=1; truesize(cpt_fig,[round(fs*Ny) round(fs*Nx)]);
            title(['Patches - i = ', num2str(i) ]);
            pause(0.2)
            %pause
        end
    end
    
end

load('X.mat','X','p');







%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Init: Z^{n=0}, D^{n=0}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

N = size(X,2)
n = size(X,1)
m = 256
m = 64
p

if 2==1
    
    Zinit = -1 + 2* rand(m,N);
    Dinit = rand(n,m);
    
    % Column L2 Normalization
    D = Dinit;
    D = bsxfun(@rdivide, D, sqrt(sum(D.^2,1)));
    Dinit = D;
    
    % Save
    save('initZD.mat','Zinit','Dinit');
    
    % Display
    if 1==1
        cpt_fig = 4;
        figure(cpt_fig); clf;
        subplot(121);
        imagesc(Zinit); colorbar;
        title('Init Z');
        subplot(122);
        imagesc(Dinit); colorbar;
        title('Init D');
    end
    
end

load('initZD.mat','Zinit','Dinit');





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sparse coding Z,D
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% L1 parameter 
lambda = 1e-1;

% Init
Z = Zinit;
D = Dinit;

warning off;
tstart = tic;
for niter=1:15
    
    
    niter
    
    
    
    %%%%%%%%%%%%%%%%%%%
    % Update D
    %%%%%%%%%%%%%%%%%%%
    fprintf('Update D...\n');
    
    % Init D,Y
    Dt = D';
    Dtb = Dt; Dtold = Dt;
    Zt = Z';
    Yt = Zt* Dt;
    Xt = X';
    
    % Norm of D
    normZ = normest(Zt);
    
    % Init time steps
    sigma = 1e0/normZ;
    tau = 1e0/normZ;
    
    % Gamma
    gamma = 1e-1;
    
    % Loop
    NbInnerIter = 100; % 1000 5000
    PlotError = zeros(NbInnerIter,1);
    tic
    i = 0; rel_err = 1;
    %for i=1:NbInnerIter
    while (i<NbInnerIter && rel_err>1e-7)
        
        % Iteration
        i = i + 1;
        
        % New Y
        Yt = Yt + sigma* (Zt* Dtb);
        Yt = ( Yt - sigma* Xt )/ (sigma + 1);
        
        % New D
        Dt = Dt - tau* (Zt'* Yt);
        %Dt = bsxfun(@rdivide, Dt', sqrt( sum(Dt'.^2,1))+1e-6 ); Dt = Dt';
        Dt = bsxfun(@rdivide, Dt', max( 1, sqrt( sum(Dt'.^2,1))+1e-6 ) ); Dt = Dt';
        
        % Acceleration
        theta = 1./sqrt(1+2*gamma*tau);
        tau = tau.* theta;
        sigma = sigma./ theta;
        
        % New Bb
        Dtb = Dt + theta* ( Dt - Dtold );
        
        % Relative error
        rel_err = norm(Dt-Dtold)/(n*m);
        
        % New Bold
        Dtold = Dt;
        
        % Error Plot
        PlotError(i) = norm(Dt,2);
        
    end
    toc
    
    % New D
    D = Dt';
    
    % Display
    figure(10); %clf;
    subplot(121);
    imagesc(D); colorbar;
    title(['D - outer iter= ', num2str(niter) ,' - inner iter= ',num2str(i),' - time = ',num2str(toc(tstart))]);
    
    figure(11); %clf;
    subplot(121);
    plot(PlotError,'r-');
    title('Error vs iter');
    pause(0.01)
    
    
    
    
    
    
    %%%%%%%%%%%%%%%%%%%
    % Update Z
    %%%%%%%%%%%%%%%%%%%
    fprintf('Update Z...\n');
    
    % Init Z, Y
    Zb = Z; Zold = Z;
    Y = D* Z;
    
    % Norm of D
    normD = normest(D);
    
    % Init time steps
    sigma = 1e0/normD;
    tau = 1e0/normD;
    
    % Gamma
    gamma = 1e-1;
    
    % Loop
    NbInnerIter = 100; % 1000 5000
    PlotError = zeros(NbInnerIter,1);
    tic
    i = 0; rel_err = 1;
    %for i=1:NbInnerIter
    while (i<NbInnerIter && rel_err>1e-5)
        
        % Iteration
        i = i + 1;
        
        % New Y
        Y = Y + sigma* (D* Zb);
        Y = ( Y - sigma* X )/ (sigma + 1);
        
        % New Z
        Z = Z - tau* (D'* Y);
        Z = Shrink( Z , tau* lambda );
        
        % Acceleration
        theta = 1./sqrt(1+2*gamma*tau);
        tau = tau.* theta;
        sigma = sigma./ theta;
        
        % New Bb
        Zb = Z + theta* ( Z - Zold );
        
        % Relative error
        rel_err = norm(Z-Zold)/(N*m);
        
        % New Bold
        Zold = Z;
        
        % Error Plot
        PlotError(i) = norm(Z,2);
        
    end
    toc
    
    % Display
    figure(10); %clf;
    subplot(122);
    %imagesc(Z); colorbar;
    imagesc(Z(:,1:100)); colorbar;
    perc_nnz = length(find(abs(Z)<1e-4)) / (m*N)
    title(['Z - outer iter= ', num2str(niter) ,' - inner iter= ',num2str(i),' - time = ',num2str(toc(tstart))]);
    
    figure(11); %clf;
    subplot(122);
    plot(PlotError,'r-');
    title('Error vs iter');
    pause(0.25)
    %pause
    %return
    
    
    current_time = toc(tstart)
    
    
    %%%%%%%%%%%%%%%%%%%
    % Display patterns
    %%%%%%%%%%%%%%%%%%%
    sqrm = sqrt(m);
    figure(30); clf; colormap(gray); hold on;
    for i1=1:sqrm
        for i2=1:sqrm
            i = (i1-1)*sqrm + i2;
            pattern = squeeze(D(:,i));
            subplot(sqrm,sqrm,i); imagesc( reshape( pattern,p,p ) ); axis off;
        end
    end
    pause(0.5)
    %pause
    %return
    
    
end





end














%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sub-Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



function res = Shrink(x,lambda)

s = sqrt(x.^2);
ss = s - lambda;
ss = ss.* ( ss>0 );
s = s + ( s<lambda );
ss = ss./s;
res = ss.* x;

end








    
    