clear; clc;
[audioMono Fs] = (audioread('music1.mp3'));
audioMono = mean(audioMono,2);
start_time = randi([1, int32(0.9*length(audioMono))]);
audioMono_cut = audioMono(start_time:start_time+0.1*length(audioMono));
audiowrite('music1.wav',audioMono_cut,Fs);