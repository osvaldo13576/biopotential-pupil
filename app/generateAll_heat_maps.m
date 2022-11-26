%argumentos: loadEmoFlechasVar gaze_on_surface sync_data
%gaze_positions_on_surface_index global_time_sync 
%gaze_positions_on_surface_data bmpdir 

function generateAll_heat_maps(bmpdir,loadEmoFlechasVar,sync_data,gaze_positions_on_surface_index, ...
    gaze_positions_on_surface_data)
    %bmpdir = '/home/osvaldo13576/Documents/BMPfiles';
    %loadEmoFlechasVar =  loadEmoFlechas('/home/osvaldo13576/Documents/14_11_2022/003/eeg_tarea/Emo_Flechas.data.2022-11-14--19-07.txt');
    BMPnames = loadEmoFlechasVar.Var4;
    %sync_data = sync_EEG_EF(loadEEG('/home/osvaldo13576/Documents/14_11_2022/003/eeg_tarea/eeg_data_data.txt',1668451922),loadEmoFlechasVar);
    %EEG_data = loadEEG('/home/osvaldo13576/Documents/14_11_2022/003/eeg_tarea/eeg_data_data.txt',1668451922);%variabletemporal
    %gaze_positions_on_surface_index = sync_EEG_pupil(EEG_data(sync_data(1,1):sync_data(end,2),1),'/home/osvaldo13576/Documents/14_11_2022/003/exports/005/surfaces/gaze_positions_on_surface_Surface 1.csv',1668452030.664301-6532.796161);
    sync_data = sync_data - sync_data(1,1)+1;
    %gaze_positions_on_surface_data = readtable('/home/osvaldo13576/Documents/14_11_2022/003/exports/005/surfaces/gaze_positions_on_surface_Surface 1.csv');
    for kk = 1:length(loadEmoFlechasVar.Var1)
        bmpfile = fullfile(bmpdir,[char(BMPnames(kk)),'.bmp']);
        im = imread(bmpfile);
        posONsurf=xy_scaled_index(gaze_positions_on_surface_data,gaze_positions_on_surface_index(sync_data(kk,1)),gaze_positions_on_surface_index(sync_data(kk,2)));
        if length(posONsurf) <= 2 || isempty(posONsurf)
            dat_x = zeros(52,52);dat_y = zeros(52,52);dat_pdf = zeros(52,52);
        else
                p=gkde2(posONsurf);
                p.xylim=[0 0 1283 720];
                dat_x = zeros(52,52);dat_y = zeros(52,52);dat_pdf = zeros(52,52);
                for i = 2:51
                    dat_x(:,i) = p.x(1,i-1);
                end
                
                for i = 2:51
                    dat_y(i,:) = p.y(i-1,1);
                end
                dat_x(:,1) = 0; dat_x(:,52) = 1283;
                dat_y(1,:) = 0; dat_y(52,:) = 720;
                dat_pdf(2:51,2:51) = 2.03524970807053e-37;
                dat_pdf(3:50,3:50) = p.pdf(2:49,2:49); 
        end
        f=figure('visible','off');
        image([0, 1283],[720,0], im);
        hold on
        ax = gca;
        set(gca, 'Visible', 'off')
        ax.YDir='normal';
        xlim([0, 1283]);
        ylim([0,720]);
        surf(dat_x,dat_y,dat_pdf,'FaceAlpha',0.5,'AlphaDataMapping','scaled','AlphaData',dat_pdf,'FaceColor','interp','EdgeAlpha',0);colormap(jet);
        view(2)
        namefig = ['heatmap',int2str(kk),'.png'];
        dir = fullfile(bmpdir,'heatmaps',namefig);
        export_fig(f,dir, '-native');
        clearAllMemoizedCaches;
    end
end