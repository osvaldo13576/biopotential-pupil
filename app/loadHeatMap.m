% carga los nombres de los mapas de calor y sus indices con respecto al EEG
% variables: loademoflechas sync_EEG_EF(indices)
function  names = loadHeatMap(load1,indices)
    %load1 = loadEmoFlechas('/home/osvaldo13576/Documents/14_11_2022/003/eeg_tarea/Emo_Flechas.data.2022-11-14--19-07.txt');
    %name = [char(load1.Var4(1)) '.bmp']; 
    %eegdata = loadEEG('/home/osvaldo13576/Documents/14_11_2022/003/eeg_tarea/eeg_data_data.txt',1668451922);
    %indices = sync_EEG_EF(eegdata,load1);
    indices = indices - indices(1,1)+1;
    names = cell(indices(end,2)-indices(1,1)+1,1);%zeros(indices(end,2)-indices(1,1)+1,1);
    for i =  1:length(indices(:,1))
        
        if i>=60
            names(indices(i,1):indices(i,2),1) =  {['heatmap',int2str(i),'.png']};
        else
            names(indices(i,1):indices(i,2),1) = {['heatmap',int2str(i),'.png']};
            names(indices(i,2)+1:indices(i+1,1)-1,1) = {'void.png'};
        end
    end
end