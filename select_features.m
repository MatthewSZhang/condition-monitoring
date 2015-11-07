function [fnames, outmat] = select_features(M3freqdomain, M4freqdomain)

frequencies = 0:2:1666*2;

tempaccelXm3 = [M3freqdomain.accelX' ones(2325,1)];
tempaccelXm4 = [M4freqdomain.accelX' zeros(1478,1)]; 
tempaccelX = [tempaccelXm3; tempaccelXm4];

tempaccelYm3 = [M3freqdomain.accelY' ones(2325,1)];
tempaccelYm4 = [M4freqdomain.accelY' zeros(1478,1)]; 
tempaccelY = [tempaccelYm3; tempaccelYm4];

tempaccelZm3 = [M3freqdomain.accelZ' ones(2325,1)];
tempaccelZm4 = [M4freqdomain.accelZ' zeros(1478,1)]; 
tempaccelZ = [tempaccelZm3; tempaccelZm4];

tempvelXm3 = [M3freqdomain.velX' ones(2325,1)];
tempvelXm4 = [M4freqdomain.velX' zeros(1478,1)]; 
tempvelX = [tempvelXm3; tempvelXm4];

tempvelYm3 = [M3freqdomain.velY' ones(2325,1)];
tempvelYm4 = [M4freqdomain.velY' zeros(1478,1)]; 
tempvelY = [tempvelYm3; tempvelYm4];

tempvelZm3 = [M3freqdomain.velZ' ones(2325,1)];
tempvelZm4 = [M4freqdomain.velZ' zeros(1478,1)]; 
tempvelZ = [tempvelZm3; tempvelZm4];

Rax = corr(tempaccelX);
Ray = corr(tempaccelY);
Raz = corr(tempaccelZ);
Rvx = corr(tempvelX);
Rvy = corr(tempvelY);
Rvz = corr(tempvelZ);
Rax = Rax(1:1667,1668);
Ray = Ray(1:1667,1668);
Raz = Raz(1:1667,1668);
Rvx = Rvx(1:1667,1668);
Rvy = Rvy(1:1667,1668);
Rvz = Rvz(1:1667,1668);

hold on;
plot(frequencies, Rax, 'b')
plot(frequencies, Rvx, 'r')
xlabel('Frequency (Hz)')
ylabel('Correlation')
legend({'Acceleration';'Velocity'});
title('Velocity and Acceleration in the X Direction')

figure;
hold on;
plot(frequencies, Ray, 'b')
plot(frequencies, Rvy, 'r')
xlabel('Frequency (Hz)')
ylabel('Correlation')
legend({'Acceleration';'Velocity'});
title('Velocity and Acceleration in the Y Direction')

figure;
hold on;
plot(frequencies, Raz, 'b')
plot(frequencies, Rvz, 'r')
xlabel('Frequency (Hz)')
ylabel('Correlation')
legend({'Acceleration';'Velocity'});
title('Velocity and Acceleration in the Z Direction')

fnames = {};
outmat = [];
% grab features with abs(correlation) > 0.2
indices_accelX = find(Rax > 0.2);
freqs = frequencies(indices_accelX);
for i=1:length(freqs)
  fnames = [fnames; ['accelX_' num2str(freqs(i)) '_Hz']];
end
outmat = [outmat tempaccelX(:,indices_accelX)];

indices_accelY = find(Ray > 0.2);
freqs = frequencies(indices_accelY);
for i=1:length(freqs)
  fnames = [fnames; ['accelY_' num2str(freqs(i)) '_Hz']];
end
outmat = [outmat tempaccelY(:,indices_accelY)];

indices_accelZ = find(Raz > 0.2);
freqs = frequencies(indices_accelZ);
for i=1:length(freqs)
  fnames = [fnames; ['accelZ_' num2str(freqs(i)) '_Hz']];
end
outmat = [outmat tempaccelZ(:,indices_accelZ)];

fnames = [fnames; 'm3?'];
outmat = [outmat tempaccelX(:,1668)];
