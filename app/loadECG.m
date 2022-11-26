% carga los datos ECG
% variables EEG indices MinPeakHeight MinPeakDistance
function [bpm, locs_Rwave] = loadECG(data,indices,tiempo,MinPeakHeight, MinPeakDistance)
    %data = '/home/osvaldo13576/Documents/14_11_2022/003/eeg_tarea/eeg_data_data.txt'; %borrar
    %timestamp = 1668451923.3 ; %borrar
    %data = loadEEG(data,timestamp); %borrar
    %tiempo = data(:,1);
    %%
    %indices =  sync_EEG_EF(data,loadEmoFlechas('/home/osvaldo13576/Documents/14_11_2022/003/eeg_tarea/Emo_Flechas.data.2022-11-14--19-07.txt'));
    %%
    tiempo = tiempo(indices(1,1):indices(end,2));
    %ecg1 = data(:,19);
    %ecg2 = data(:,20);
    %%
    bipolar = data;%ecg2(indices(1,1):indices(end,2))-ecg1(indices(1,1):indices(end,2));
    %length(bipolar)
    %bipolar=bipolar(1:200);
    [~,locs_Rwave] = findpeaks(bipolar,'MinPeakHeight', MinPeakHeight,'MinPeakDistance',MinPeakDistance);
    %%
    %figure
    %hold on
    %plot(bipolar)
    %plot(locs_Rwave,bipolar(locs_Rwave),'rv','MarkerFaceColor','r');
    %%
    times_ = tiempo(locs_Rwave);
    bpm = zeros(length(times_)-1,2);
    for i = 1:length(times_)-1
        bpm(i,1) = 60/(times_(i+1)-times_(i));
        bpm(i,2) = (times_(i+1)+times_(i))/2;
    end
end
%%


%function [bmp, locs_Rwave] = loadECG(data,indices,MinPeakHeight, MinPeakDistance)
%    data = readmatrix(directorio_archivo,'NumHeaderLines',1);
%    % convertir a char: char(datos.Var4(1))
%    data(:,1) = data(:,1) + timestamp; % actualizamos el valor del tiempo
%end
