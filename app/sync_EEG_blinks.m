% relaciona los vectores de tiempo de los datos EEG y blinks.csv 
function index_ones = sync_EEG_blinks(directorio_pupil,pupil_timestamp,global_time)
    %%
    %pupil_timestamp = 1668452030.664301-6532.796161;
    %directorio_pupil = '/home/osvaldo13576/Documents/14_11_2022/003/exports/005/blinks.csv';
    %dir_data = '/home/osvaldo13576/Documents/14_11_2022/003/eeg_tarea/eeg_data_data.txt';
    %timestamp = 1668451922.6;
    %data = loadEEG(dir_data,timestamp); %borrar
    %indices =  sync_EEG_EF(data,loadEmoFlechas('/home/osvaldo13576/Documents/14_11_2022/003/eeg_tarea/Emo_Flechas.data.2022-11-14--19-07.txt'));
    %global_time = data(indices(1,1):indices(end,2),1);
    %%
    data = readmatrix(directorio_pupil,'NumHeaderLines',1);
    data_start = data(:,2) + pupil_timestamp;
    data_end = data(:,4) + pupil_timestamp;
    index_ones = NaN*zeros(length(global_time),1);
    %local_index = indices - indices(1,1) +1;
    %% Recortando el vetor de parpadeos
    [~,indice1] = min(abs(data_start-global_time(1)));
    [~,indice2] = min(abs(data_end-global_time(end)));
    %%
    data_start0 = data_start(indice1+1:indice2-1);
    data_end0 = data_end(indice1+1:indice2-1);
    
    for i = 1:length(data_end0)
        [~,I1] = min(abs(global_time-data_start0(i)));
        [~,I2] = min(abs(global_time-data_end0(i)));
        index_ones(I1:I2) = 1;
    end
end

