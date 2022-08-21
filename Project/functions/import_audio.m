function [downsampled_Fs, resampled_audio] = import_audio(path, song_num, format)
    % import the audio 
    [audio, Fs] = audioread([path, 'music', num2str(song_num), format]);
    % getting mean over right and left channels
    audioMono = mean(audio, 2);
    % downsample the audio to 8 KHz
    downsampled_Fs = 8000;
    [Numer, Denom] = rat(downsampled_Fs/Fs);
    resampled_audio = resample(audioMono, Numer, Denom);
end