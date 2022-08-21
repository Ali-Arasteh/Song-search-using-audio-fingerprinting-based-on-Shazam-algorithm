%% adding the path of subfolders
addpath('functions/');
addpath('database/');
addpath('musics/');
addpath('test_musics/');


%% creating the database
clear; clc; close all;

% Creating an empty hashmap for storing the hash-keys and hash-values found in songs
database = containers.Map('KeyType','char','ValueType','char');

%% finding the songs' fingerprints and adding them to the database
clc;

% getting the names of musics in musics folder in order to process them
files = dir(fullfile('musics/','*.mp3'));
[filenames{1:size(files,1)}] = deal(files.name);

% a full screen figure for plots
figure('Units','normalized','Position',[0 0 1 1])

% path of musics folder
path = 'musics/';

% going over all songs, finding their fingerprints and adding them to the database
for k = 1:length(filenames)
    
    disp("Uploading music " + k + " to the database...")
    
    % importing audio 
    format = '.mp3';
    [downsampled_Fs, audioMono] = import_audio(path, k, format);

    % creating the time-freq matrix of the audio using fft and an overlapping sliding window with the length of "window_time"
    window_time = 0.1;
    [time, freq, time_freq_mat] = STFT(audioMono, downsampled_Fs, window_time);
    
    % plotting the stft
    subplot(1,2,1);
    pcolor(time, freq, time_freq_mat);
    axis square
    shading interp
    colorbar;
    xlabel('time(s)','interpreter','latex');
    ylabel('frequency(Hz)','interpreter','latex');
    title("STFT(dB) for music: " + k,'interpreter','latex');

    % finding the anchor points of stft using a sliding window with the size of 2dt*2df
    df = floor(0.1*size(time_freq_mat, 1)/4);
    dt = 2/window_time;
    % finding anchor points
    anchor_points = find_anchor_points(time_freq_mat, dt, df);
    % plotting the anchor points
    subplot(1,2,2)
    scatter(time(anchor_points(:, 2)), freq(anchor_points(:, 1)),'x');
    axis square
    xlabel('time(s)','interpreter','latex');
    ylabel('frequency(Hz)','interpreter','latex');
    title("Anchor Points for music: " + k,'interpreter','latex');
    xlim([time(1) time(end)]);
    ylim([freq(1) freq(end)]);
    grid on; grid minor;
    close;
    % creating the hash tags using a window with the size of dt*2df for each anchor point
    df_hash = floor(0.1*size(time_freq_mat,1));
    dt_hash = 20/window_time;
    % creating hash-keys and hash-values for each pair of anchor points
    % key format: (f1*f2*(t2-t1)) 
    % value format: (song_name*time_from_start)
    [hash_key, hash_value] = create_hash_tags(anchor_points, df_hash, dt_hash, k);
    % adding hash-keys and hash-values to the database
    for i = 1:length(hash_key)
        key_tag = [num2str(hash_key(i, 1)), '*', num2str(hash_key(i, 2)), '*', num2str(hash_key(i, 3))];
        if ~(isKey(database, key_tag))
            database(key_tag) = [num2str(hash_value(i, 1)), '*', num2str(hash_value(i, 2))];
        else
            database(key_tag) = [database(key_tag), '+', [num2str(hash_value(i, 1)), '*', num2str(hash_value(i, 2))]];
        end
    end
   
end

% save the database and musics name in database folder
save('database/database','database');