function [fnames, outmat] = select_features(M1_FZmat, SN41_FZmat)

frequencies = 0:2:1666*2;

% tempaccelXm1 = [M1_FXmat_acc' ones(size(M1_FXmat_acc,2),1)];
% tempaccelXsn41 = [SN41_FXmat_acc' zeros(size(SN41_FXmat_acc,2),1)]; 
% tempaccelX = [tempaccelXm1; tempaccelXsn41];
% 
% tempaccelYm1 = [M1_FYmat_acc' ones(size(M1_FYmat_acc,2),1)];
% tempaccelYsn41 = [SN41_FYmat_acc' zeros(size(SN41_FYmat_acc,2),1)]; 
% tempaccelY = [tempaccelYm1; tempaccelYsn41];
% 
% tempaccelZm1 = [M1_FZmat_acc' ones(size(M1_FZmat_acc,2),1)];
% tempaccelZsn41 = [SN41_FZmat_acc' zeros(size(SN41_FZmat_acc,2),1)]; 
% tempaccelZ = [tempaccelZm1; tempaccelZsn41];
% 
% tempvelXm1 = [M1_FXmat' ones(size(M1_FXmat,2),1)];
% tempvelXsn41 = [SN41_FXmat' zeros(size(SN41_FXmat,2),1)]; 
% tempvelX = [tempvelXm1; tempvelXsn41];
% 
% tempvelYm1 = [M1_FYmat' ones(size(M1_FYmat,2),1)];
% tempvelYsn41 = [SN41_FYmat' zeros(size(SN41_FYmat,2),1)]; 
% tempvelY = [tempvelYm1; tempvelYsn41];

tempvelZm1 = [M1_FZmat' ones(size(M1_FZmat,2),1)];
tempvelZsn41 = [SN41_FZmat' zeros(size(SN41_FZmat,2),1)]; 
tempvelZ = [tempvelZm1; tempvelZsn41];

% Rax = corr(tempaccelX);
% Ray = corr(tempaccelY);
% Raz = corr(tempaccelZ);
% Rvx = corr(tempvelX);
% Rvy = corr(tempvelY);
Rvz = corr(tempvelZ);
% Rax = Rax(1:1667,1668);
% Ray = Ray(1:1667,1668);
% Raz = Raz(1:1667,1668);
% Rvx = Rvx(1:1667,1668);
% Rvy = Rvy(1:1667,1668);
Rvz = Rvz(1:1667,1668);

% hold on;
% plot(frequencies, Rax, 'b')
% plot(frequencies, Rvx, 'r')
% xlabel('Frequency (Hz)')
% ylabel('Correlation')
% legend({'Acceleration'; 'Velocity'});
% title('Velocity and Acceleration in the X Direction')
% 
% figure;
% hold on;
% plot(frequencies, Ray, 'b')
% plot(frequencies, Rvy, 'r')
% xlabel('Frequency (Hz)')
% ylabel('Correlation')
% legend({'Acceleration'; 'Velocity'});
% title('Velocity and Acceleration in the Y Direction')
% 
figure;
hold on;
% plot(frequencies, Raz, 'b')
plot(frequencies, Rvz, 'r')
xlabel('Frequency (Hz)')
ylabel('Correlation')
% legend({'Acceleration'; 'Velocity'});
% title('Velocity and Acceleration in the Z Direction')
title('Velocity in the Z Direction')

fnames = {};
outmat = [];
corr_threshold = 0.7;
% % grab features with abs(correlation) > corr_threshold
% indices_accelX = find(abs(Rax) > corr_threshold);
% freqs = frequencies(indices_accelX);
% for i=1:length(freqs)
%   fnames = [fnames; ['accelX_' num2str(freqs(i)) '_Hz']];
% end
% outmat = [outmat tempaccelX(:,indices_accelX)];
% 
% indices_accelY = find(abs(Ray) > corr_threshold);
% freqs = frequencies(indices_accelY);
% for i=1:length(freqs)
%   fnames = [fnames; ['accelY_' num2str(freqs(i)) '_Hz']];
% end
% outmat = [outmat tempaccelY(:,indices_accelY)];

indices_velZ = find(abs(Rvz) > corr_threshold);
freqs = frequencies(indices_velZ);
for i=1:length(freqs)
  fnames = [fnames; ['accelZ_' num2str(freqs(i)) '_Hz']];
end
outmat = [outmat tempvelZ(:,indices_velZ)];

fnames = [fnames; 'm1?'];
outmat = [outmat tempvelZ(:,1668)];
