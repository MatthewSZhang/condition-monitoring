%% FFT data
% This file loads a .csv file and calculates the frequency spectrum of the
% time domain data. 
% tsdata: time series data
% fs: sampling frequency
% res: frequency resolution
% -------------------------------------------------------------------------


tsdata = load('Datasetaccel.csv');
% Use the sampling rate of the data
fs = 6664;
% Frequency resolution in the time domain
res = 2;
% Use column of the .csv file
rawtimedata = tsdata(:,6);

% ------- BEGIN SCRIPT ------- %
freqdata = zeros(fs/res+1,1);
count = 0;
for i=1:fs*(1/res):length(rawtimedata)-fs/res
   
    % Select the portion of the time data that we want to process. In our
    % case, we want to go out to the number of seconds = fs, because we are
    % able to achieve a 1 Hz resolution with the data
    rawtimedatacurr = rawtimedata(i:i+fs/res);
    N = length(rawtimedatacurr);
   
    % Calculate the resolution of the frequency domain data
    xval = linspace(0,fs/2,(N-1)/2+1);
    windrawtimedata = hann(length(rawtimedatacurr)).*rawtimedatacurr;
   
    % Correct for a single sided spectrum, and get RMS
    freqdata = freqdata+2*sqrt(2)*abs(fft(windrawtimedata))/N;
    count = count+1;
end
% Average the summation of the frequency values in the bins
freqdata = freqdata/count;
plot(xval,freqdata(1:length(xval)),'r')
hold on

%% Create new matrices to hold the Accelerometer raw data

% Create a new variable to hold all the x vibrations, with measurement
% number in different columns, and timedata values in different rows
csvlength = length(m4_vibration_waveform_data);
numsamples = 4096;

M4_Xmat = zeros(4096,csvlength/numsamples);
% X accel is in the 5th column
for i = 1:csvlength/numsamples
    startpt = (i-1)*numsamples+1;
    endpt = i*numsamples;
    M4_Xmat(:,i) = m4_vibration_waveform_data(startpt:endpt,8);
end

M4_Ymat = zeros(4096,csvlength/numsamples);
% Y accel is in the 6th column
for i = 1:csvlength/numsamples
    startpt = (i-1)*numsamples+1;
    endpt = i*numsamples;
    M4_Ymat(:,i) = m4_vibration_waveform_data(startpt:endpt,9);
end

M4_Zmat = zeros(4096,csvlength/numsamples);
% Z accel is in the 7th column
for i = 1:csvlength/numsamples
    startpt = (i-1)*numsamples+1;
    endpt = i*numsamples;
    M4_Zmat(:,i) = m4_vibration_waveform_data(startpt:endpt,10);
end

%%
% Use the sampling rate of the data
fs = 6664;
% Frequency resolution in the time domain
res = 2;
% Use column of the .csv file
rawtimedata = M4_Zmat;

% ------- BEGIN SCRIPT ------- %
M4_FZmat = zeros(1667,1478);
for j = 1:1478
    % Use column of the .csv file
    rawtimedata = M4_Zmat(:,j);
    freqdata = zeros(fs/res+1,1);
    count = 0;
    for i=1:fs*(1/res):length(rawtimedata)-fs/res

        % Select the portion of the time data that we want to process. In our
        % case, we want to go out to the number of seconds = fs, because we are
        % able to achieve a 2 Hz resolution with the data
        rawtimedatacurr = rawtimedata(i:i+fs/res);
        N = length(rawtimedatacurr);

        % Window the data
        windrawtimedata = hann(length(rawtimedatacurr)).*rawtimedatacurr;

        % Correct for a single sided spectrum, and get RMS
        freqdata = freqdata+2*sqrt(2)*abs(fft(windrawtimedata))/N;
        count = count+1;
    end
    % Average the summation of the frequency values in the bins
    freqdata = freqdata/count;
    
    % Save into frequency file
    xval = linspace(0,fs/2,(N-1)/2+1);
    M4_FZmat(:,j) = freqdata(1:length(xval));
end
