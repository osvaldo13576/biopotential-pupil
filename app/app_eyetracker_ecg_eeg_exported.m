classdef app_eyetracker_ecg_eeg_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                       matlab.ui.Figure
        DuracionmsEditField            matlab.ui.control.NumericEditField
        DuracionmsEditFieldLabel       matlab.ui.control.Label
        AccionEditField                matlab.ui.control.EditField
        AccionEditFieldLabel           matlab.ui.control.Label
        ParteEditField                 matlab.ui.control.NumericEditField
        ParteEditFieldLabel            matlab.ui.control.Label
        MinPeakDistanceEditField       matlab.ui.control.NumericEditField
        MinPeakDistanceEditFieldLabel  matlab.ui.control.Label
        MinPeakHeightuVEditField       matlab.ui.control.NumericEditField
        MinPeakHeightuVEditFieldLabel  matlab.ui.control.Label
        CargarHeatMapspreviosCheckBox  matlab.ui.control.CheckBox
        DatosCicloDropDown             matlab.ui.control.DropDown
        DatosCicloDropDownLabel        matlab.ui.control.Label
        TiempoSlider                   matlab.ui.control.Slider
        TiempoSliderLabel              matlab.ui.control.Label
        TextNdataEditField             matlab.ui.control.EditField
        CanalDropDown                  matlab.ui.control.DropDown
        CanalDropDownLabel             matlab.ui.control.Label
        SelecBMPButton                 matlab.ui.control.Button
        EditField_2                    matlab.ui.control.EditField
        CargarDatosButton              matlab.ui.control.Button
        EEGtimestapmEditField          matlab.ui.control.NumericEditField
        EEGtimestapmEditFieldLabel     matlab.ui.control.Label
        EditField                      matlab.ui.control.EditField
        AbrircarpetaButton             matlab.ui.control.Button
        SeleccionarButton              matlab.ui.control.Button
        ListBox                        matlab.ui.control.ListBox
        FrecCardEditField              matlab.ui.control.NumericEditField
        FrecCardEditFieldLabel         matlab.ui.control.Label
        SiguienteButton                matlab.ui.control.Button
        AnteriorButton                 matlab.ui.control.Button
        CerrarButton                   matlab.ui.control.Button
        PlayPauseButton                matlab.ui.control.Button
        TextArea                       matlab.ui.control.TextArea
        UIAxes5                        matlab.ui.control.UIAxes
        UIAxes4                        matlab.ui.control.UIAxes
        UIAxes3                        matlab.ui.control.UIAxes
        UIAxes2                        matlab.ui.control.UIAxes
        UIAxes                         matlab.ui.control.UIAxes
    end

    properties (Access = public)
       BMPfiles_L
       dataDIR_L
       EEG_timestamps_L
       debug
       data_json
       canales = {'Fp1-A1' , 'Fp2-A2','F3-A1','F4-A2','C3-A1','C4-A2','P3-A1','P4-A2','O1-A1','O2-A2','F7-A1','F8-A2','T3-A1',...
           'T4-A2','T5-A1','T6-A2','Add_lead1','Add_lead2','Add_lead3','Add_lead4','Add_lead5','Add_lead6','Add_lead7','Add_lead8','Add_lead9','Add_lead10'};
       canales_data=[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26];
       dpc = {'x10','x1','x2','x5','x20','x50','x100','x200'};
       %dpc_data = [1,2,5,10,20,50,100,200];
       dpc_element = 10;
       EEGfile
       Emo_Flechasfile
       direc_exports
       direc_surfaces
       indices
       pupil_timestamp
       pupil_positions_dir;blinks_dir;eye0_mp4_dir;eye0_dir;gaze_positions_on_surface_dir
       pupil_positions_data;blinks_data;eye0_mp4_data;eye0_data;gaze_positions_on_surface_data
       pupil_positions_index;blinks_index;eye0_index;gaze_positions_on_surface_index
       global_time_sync 
       playing
       vector_tiempo
       h1;h2;h3;
       valor =1
       ECGdata
       EEG_grafica
       canal
       canal_index = 1;
       heatname
       MinPeakHeight_L
       MinPeakDistance_L
       frec_card_index
       bpm
       eeg_chanel
       eegplot
       EEG_data
       abs_ind
       dur_num
       accion
       loadHM
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            load("info.mat","BMPfiles");load("info.mat","EEG_timestamps");load("info.mat","dataDIR");
            load("info.mat","MinPeakHeight");load("info.mat","MinPeakDistance");
            app.BMPfiles_L = BMPfiles;
            app.dataDIR_L = dataDIR;
            app.EEG_timestamps_L = EEG_timestamps;
            app.EditField.Editable = false;
            app.EditField_2.Editable = false;
            app.EditField.Value = app.dataDIR_L;
            app.EditField_2.Value = app.BMPfiles_L;
            app.EEGtimestapmEditField.Value = app.EEG_timestamps_L;
            %
            app.MinPeakHeight_L = MinPeakHeight;
            app.MinPeakDistance_L = MinPeakDistance;
            app.MinPeakHeightuVEditField.Value = app.MinPeakHeight_L;
            app.MinPeakDistanceEditField.Value = app.MinPeakDistance_L;
            %
            app.CanalDropDown.Items = app.canales;
            app.CanalDropDown.ItemsData = app.canales_data;
            app.DatosCicloDropDown.Items=app.dpc;
           %app.DatosCicloDropDown.ItemsData=app.dpc_data;
            %textArea
            app.debug = "Seleccione sus datos. [OK] EEG timestamp cargada desde memoria: " + convertCharsToStrings(convert_timestamp(app.EEG_timestamps_L));
            app.TextArea.Value = app.debug;
            %enables/disables
            app.ListBox.Enable = false;
            app.CargarDatosButton.Enable = false;
            app.AnteriorButton.Enable = false;
            app.SiguienteButton.Enable = false;
            app.PlayPauseButton.Enable = false;
            app.TiempoSlider.Enable = false;
            app.loadHM = true;
            app.CargarHeatMapspreviosCheckBox.Value = app.loadHM;
            app.CanalDropDown.Enable = false;
            % otros
            app.UIAxes4.XLim = [0,913];
            app.UIAxes4.YLim = [0,721];
            
            %
        end

        % Button pushed function: SeleccionarButton
        function SeleccionarButtonPushed(app, event)
            directorio = uigetdir;
            if directorio == 0
                app.EditField.Value = app.dataDIR_L;
            else
                app.EditField.Value = directorio;
                dataDIR = directorio;
                app.dataDIR_L = dataDIR;
                save('info.mat','dataDIR','-append');
                app.debug =  "[OK] Directorio de datos cargado " + convertCharsToStrings(directorio)+ newline+app.debug;
                app.TextArea.Value = app.debug;
            end
        end

        % Button pushed function: SelecBMPButton
        function SelecBMPButtonPushed(app, event)
            directorio = uigetdir;
            if directorio == 0
                app.EditField_2.Value = app.BMPfiles_L;
            else
                app.EditField_2.Value = directorio;
                BMPfiles = directorio;
                app.BMPfiles_L = BMPfiles;
                save('info.mat','BMPfiles','-append');
                app.debug =  "[OK] Directorio BMP cargado " + convertCharsToStrings(directorio)+newline+app.debug;
                app.TextArea.Value = app.debug;
            end
        end

        % Value changed function: EEGtimestapmEditField
        function EEGtimestapmEditFieldValueChanged(app, event)
            value = app.EEGtimestapmEditField.Value;
            EEG_timestamps = value;
            app.EEG_timestamps_L = EEG_timestamps;
            app.debug = "Variable EEG_timestamps actualizada: " +convertCharsToStrings(convert_timestamp(EEG_timestamps))+newline+app.debug;
            app.TextArea.Value = app.debug;
            save('info.mat',"EEG_timestamps","-append")
        end

        % Value changed function: MinPeakHeightuVEditField
        function MinPeakHeightuVEditFieldValueChanged(app, event)
            value = app.MinPeakHeightuVEditField.Value;
            MinPeakHeight = value;
            app.MinPeakHeight_L = MinPeakHeight;
            app.debug = "Variable MinPeakHeight actualizada."+newline+app.debug;
            app.TextArea.Value = app.debug;
            save('info.mat',"MinPeakHeight","-append")
        end

        % Value changed function: MinPeakDistanceEditField
        function MinPeakDistanceEditFieldValueChanged(app, event)
            value = app.MinPeakDistanceEditField.Value;
            MinPeakDistance = value;
            app.MinPeakDistance_L = MinPeakDistance;
            app.debug = "Variable MinPeakDistance actualizada. " +newline+app.debug;
            app.TextArea.Value = app.debug;
            save('info.mat',"MinPeakDistance","-append")
        end

        % Button pushed function: AbrircarpetaButton
        function AbrircarpetaButtonPushed(app, event)
            app.debug = "Buscando archivos necesarios..."+newline+app.debug;app.TextArea.Value=app.debug;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            if isafolder(app.dataDIR_L,'exports') == 1 && is_an_empty(fullfile(app.dataDIR_L,'exports'))  == 0
                c_exports = 1;
                app.ListBox.Items = listaFolders(fullfile(app.dataDIR_L,'exports'));
                app.debug = "[OK] Subcarpetas /exports detectadas."+newline+app.debug;
                app.TextArea.Value = app.debug;
            else
                app.debug = "[X] Directotio /exports vacio o no existe."+newline+app.debug;
                app.TextArea.Value = app.debug;
                c_exports = 0;
                
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       
            if isempty(listaArchivos(app.BMPfiles_L,'*.bmp')) == 1
               app.debug = "[X] Carpeta de imagenes no contiene archivos BMP"+newline+app.debug;
               app.TextArea.Value = app.debug;
               c_bmp = 0;
            else
                NUM = length(listaArchivos(app.BMPfiles_L,'*.bmp'));
                app.debug = "[OK] Num. Archivos BMP = " + int2str(NUM)+newline+app.debug;
                app.TextArea.Value = app.debug;
                c_bmp = 1;
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            if  isarchivo(app.dataDIR_L,'info.player.json') == 1
               app.data_json = readjson(fullfile(app.dataDIR_L,'info.player.json'));
               app.debug = "[OK] info.player.json encontrado. Inicio de experimento eye tracker: "+convertCharsToStrings(convert_timestamp(app.data_json.start_time_system_s))...;
                   +newline+"Duracion del experimento: " + sprintf('%.2f',app.data_json.duration_s/60)+" minutos"+newline+app.debug;
               
               app.TextArea.Value = app.debug;
               app.pupil_timestamp = app.data_json.start_time_system_s-app.data_json.start_time_synced_s;
                c_json = 1;
            else
                app.debug = "[X] info.player.json no encontrado"+newline+app.debug;
                app.TextArea.Value = app.debug;
                c_json = 0;
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            app.EEGfile = EEGdata_finder(fullfile(app.dataDIR_L,'eeg_tarea'));
            app.Emo_Flechasfile = EmoFlechas_finder(fullfile(app.dataDIR_L,'eeg_tarea'));
            set = length(app.EEGfile)*length(app.Emo_Flechasfile);
            if set == 0
                app.debug = "[X] Archivos XXXXXXXXX_data.txt o Emo_Flechas.data.20XX-XX-XX--XX-XX.txt no encontrados"+newline+app.debug;
                app.TextArea.Value = app.debug;
                c_eeg = 0;
            else
                app.debug = "[OK] Archivos " + convertCharsToStrings(app.Emo_Flechasfile) +" y "+convertCharsToStrings(app.EEGfile)+" encontrados."+newline+app.debug;
                app.TextArea.Value = app.debug;
                c_eeg = 1;
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            if c_bmp == 1 && c_exports == 1 && c_json ==1 && c_eeg
                app.ListBox.Enable = true;
            else
                app.ListBox.Enable = false;
            end
            

        end

        % Value changed function: ListBox
        function ListBoxValueChanged(app, event)
            value = app.ListBox.Value;
            % buscamos los archivos restantes que usaremos: 
            % (1) ./exports/blinks.csv 
            % (2) ./exports/pupil_positions.csv
            % (3) ./exports/eye0_timestamps.csv
            % (4) ./exports/surfaces/gaze_positions_on_surface_XXXXXX.csv
            % (5) ./exports/eye0.mp4
            %;;;;
            app.direc_exports = fullfile(app.dataDIR_L,'exports',convertStringsToChars(value));
            app.direc_surfaces = fullfile(app.direc_exports,'surfaces');
            file_1 = isarchivo(app.direc_exports,'blinks.csv');
            if file_1 == true
                file_1 =1;
                   app.blinks_dir = fullfile(app.direc_exports,'blinks.csv');
            else
                file_1 =0;
            end
            file_2 = isarchivo(app.direc_exports,'pupil_positions.csv');
            if file_2 == true
                file_2 =1;
                   app.pupil_positions_dir = fullfile(app.direc_exports,'pupil_positions.csv');
            else
                file_2 =0;
            end
            %%
            file_3 = isarchivo(app.direc_exports,'eye0_timestamps.csv');
            if file_3 == true
                file_3 =1;
                app.eye0_dir = fullfile(app.direc_exports,'eye0_timestamps.csv');
            else
                file_3 =0;
            end
            %%
            file_4 = file_finder(app.direc_surfaces,'gaze_positions_on_surface');
            app.gaze_positions_on_surface_dir = fullfile(app.direc_surfaces,file_4);
            file_5 = isarchivo(app.direc_exports,'eye0.mp4');
            if file_5 == true
                file_5 =1;
                app.eye0_mp4_dir = fullfile(app.direc_exports,'eye0.mp4');
            else
                file_5 =0;
            end
            set = file_1*length(file_2)*length(file_3)*length(file_4)*file_5;
            if set == 0
                app.debug = "[X] Archivos faltantes"+newline+app.debug;  
                app.TextArea.Value = app.debug;
                app.CargarDatosButton.Enable = false;
            else
                app.debug = "[OK] Archivos encontrados"+newline+app.debug;  
                app.TextArea.Value = app.debug;
                app.CargarDatosButton.Enable = true;
            end
        end

        % Button pushed function: CargarDatosButton
        function CargarDatosButtonPushed(app, event)
            %   Archivos a cargar
            %   (1)'eye0.mp4'              &
            %   (2)'eye0_timestamps.csv'   &
            %   (3)'pupil_positions.csv'   &
            %   (4)'blinks.csv'            &
            %   (5)'gaze_positions_on_surface_Surface 1.csv'
            %%
            app.CerrarButton.Enable = false;
            %% limpiamos las graficas en caso de volver a cargar datos

            %%
            app.CargarDatosButton.Enable = false;
            app.debug = "Sincronizando datos y cargando variables..."+newline+app.debug;
            app.TextArea.Value = app.debug;
           pause(0.1)
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% EmoFlechas vs EEG
            EmoFlechas_data = loadEmoFlechas(fullfile(app.dataDIR_L,'eeg_tarea',app.Emo_Flechasfile));
            app.EEG_data = loadEEG(fullfile(app.dataDIR_L,'eeg_tarea',app.EEGfile),app.EEG_timestamps_L);            
            app.indices = sync_EEG_EF(app.EEG_data,EmoFlechas_data);
            app.abs_ind = app.indices(:,1)-app.indices(1,1)+1;
            tiempo = app.EEG_data(:,1);
            tiempo = tiempo(app.indices(1,1):app.indices(end,2));
            app.vector_tiempo = tiempo-tiempo(1);
            app.EEG_grafica = app.EEG_data;
            app.debug = "[OK] Sincronizandos: " + convertCharsToStrings(app.EEGfile) + " vs " +...
                convertCharsToStrings(app.Emo_Flechasfile)+newline+app.debug;
            app.TextArea.Value = app.debug;
           pause(0.1) 
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% EEG vs pupil_positions
            %vector de tiempo de EEG
            app.global_time_sync = app.EEG_data(app.indices(1,1):app.indices(end,2),1);
            %
            app.pupil_positions_index = sync_EEG_pupil(app.global_time_sync,app.pupil_positions_dir,app.pupil_timestamp);
            app.pupil_positions_data = readtable(app.pupil_positions_dir);
            app.debug = "[OK] Sincronizandos: " + convertCharsToStrings(app.EEGfile) + " vs " +...
                "pupil_positions.csv"+newline+app.debug;
            app.TextArea.Value = app.debug;
            pause(0.1)
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% EEG vs eye0
            app.eye0_index = sync_EEG_pupil(app.global_time_sync,app.eye0_dir,app.pupil_timestamp);
            app.eye0_data = VideoReader(app.eye0_mp4_dir);
            app.debug = "[OK] Sincronizandos: " + convertCharsToStrings(app.EEGfile) + " vs " +...
                "eye0.mp4"+newline+app.debug;
            app.TextArea.Value = app.debug;
           pause(0.1)
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% EEG vs gazeOnsurface
            app.gaze_positions_on_surface_index = sync_EEG_pupil(app.global_time_sync,app.gaze_positions_on_surface_dir,app.pupil_timestamp);
            app.gaze_positions_on_surface_data = readtable(app.gaze_positions_on_surface_dir);
            app.debug = "[OK] Sincronizandos: " + convertCharsToStrings(app.EEGfile) + " vs " +...
                "gaze_positions_on_surface"+newline+app.debug;
            app.TextArea.Value = app.debug;
            pause(0.1)
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ECG
            app.ECGdata =  app.EEG_data(app.indices(1,1):app.indices(end,2),20)-app.EEG_data(app.indices(1,1):app.indices(end,2),19);
            [app.bpm, locs_Rwave] = loadECG(app.ECGdata,app.indices,app.EEG_data(:,1),app.MinPeakHeight_L, app.MinPeakDistance_L);
            app.frec_card_index = sync_EEG_FrecCard(tiempo,app.bpm(:,2));
            app.debug = "[OK] ECG cargado "+newline+app.debug;
            app.TextArea.Value = app.debug;
            pause(0.1)
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Mapas de calor
            app.debug = "Cargando mapas de calor... "+newline+app.debug;
            app.TextArea.Value = app.debug;
           
            if app.loadHM == false
            generateAll_heat_maps(app.BMPfiles_L,EmoFlechas_data,app.indices,app.gaze_positions_on_surface_index, ...
    app.gaze_positions_on_surface_data);
            app.debug = "[OK] Mapas de calor generados en el directorio" + ...
                convertCharsToStrings(fullfile(app.BMPfiles_L,'heatmaps'))+newline+app.debug;
            elseif app.loadHM == true
                app.debug = "[OK] Mapas de calor previos seleccionados en el directorio" + ...
                convertCharsToStrings(fullfile(app.BMPfiles_L,'heatmaps'))+newline+app.debug;
            end
            app.heatname = loadHeatMap(EmoFlechas_data,app.indices);
            app.TextArea.Value = app.debug;
            pause(0.1)
            %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Otros datos
            app.debug = "Cargando datos relacionados con "+convertCharsToStrings(app.Emo_Flechasfile)+newline+app.debug;
            app.TextArea.Value = app.debug;
            [app.dur_num, app.accion] = loadTaskAction(app.indices,EmoFlechas_data);
            app.debug = "[OK] indices relacionados con: "+convertCharsToStrings(app.Emo_Flechasfile)+newline+app.debug;
            app.TextArea.Value = app.debug;
            pause(0.1)
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Parpadeo
            ones_area = sync_EEG_blinks(app.blinks_dir,app.pupil_timestamp,app.global_time_sync);
            app.debug = "[OK] Sincronizandos: " + convertCharsToStrings(app.EEGfile) + " vs " +...
                "blinks.csv"+newline+app.debug;
            app.TextArea.Value = app.debug;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            
            app.TiempoSlider.Limits = [1,app.indices(end,2)-app.indices(1,1)+1];
            app.TiempoSlider.Enable = true;
            app.TextNdataEditField.Value = "1";
            %%% duracion - accion
            app.ParteEditField.Value = app.dur_num(1,1);
            app.DuracionmsEditField.Value = app.dur_num(1,2);
            app.AccionEditField.Value = char(app.accion(1));
            %%% ajuste de eje X
            app.UIAxes2.XLim = [app.vector_tiempo(app.valor)-2,app.vector_tiempo(app.valor)+2];
            app.UIAxes3.XLim = [app.vector_tiempo(app.valor)-2,app.vector_tiempo(app.valor)+2];
            app.UIAxes5.XLim = [app.vector_tiempo(app.valor)-2,app.vector_tiempo(app.valor)+2];
            %% YLims
            app.UIAxes2.YLim = [min(app.ECGdata),max(app.ECGdata)];
            app.UIAxes3.YLim = [min(min(app.EEG_data(:,2:end)))/5,max(max(app.EEG_data(:,2:end)))/5];
            UIaxes5Xmax = max(app.pupil_positions_data.diameter)/2; 
            ones_area = ones_area*UIaxes5Xmax;
            app.UIAxes5.YLim = [min(app.pupil_positions_data.diameter),UIaxes5Xmax];

            %% previews
            imshow(fullfile(app.BMPfiles_L,'heatmaps',char(app.heatname(1))), 'Parent', app.UIAxes4);
            app.FrecCardEditField.Value = app.bpm(app.frec_card_index(1),1);
            frames_eye0 = flipud(read(app.eye0_data,app.eye0_index(1)));
            imshow(frames_eye0, 'Parent', app.UIAxes);
            
            hold(app.UIAxes2,'on')
            plot(app.UIAxes2,app.vector_tiempo,app.ECGdata,'-r','LineWidth',1)
            plot(app.UIAxes2,app.vector_tiempo(locs_Rwave),app.ECGdata(locs_Rwave),'rv','MarkerFaceColor','green');
            hold(app.UIAxes2,'off')

            hold(app.UIAxes3,'on')
            app.eeg_chanel = app.EEG_grafica(app.indices(1,1):app.indices(end,2),app.canal_index+1);
            area(app.UIAxes3,app.vector_tiempo,ones_area*1000,'LineWidth',2,'FaceAlpha',0.5)
            area(app.UIAxes3,app.vector_tiempo,-ones_area*1000,'LineWidth',2,'FaceAlpha',0.5)
            app.eegplot = plot(app.UIAxes3,app.vector_tiempo,app.eeg_chanel,'-b','LineWidth',1);
            app.h2 = xline(app.UIAxes3,app.vector_tiempo(1),'-r','LineWidth',1);
            hold(app.UIAxes3,'off')

            hold(app.UIAxes5,'on')
            area(app.UIAxes5,app.vector_tiempo,ones_area,'LineWidth',2,'FaceAlpha',0.5)
            plot(app.UIAxes5,app.vector_tiempo,app.pupil_positions_data.diameter(app.pupil_positions_index),'-b','LineWidth',1)
            app.h3 = xline(app.UIAxes5,app.vector_tiempo(1),'-r','LineWidth',1);
            hold(app.UIAxes5,'off')

            title(app.UIAxes3,"EEG ("+app.canales(app.canal_index)+")")
            app.h1 = xline(app.UIAxes2,app.vector_tiempo(1),'-blue','LineWidth',1);
            
            %%%%
            %%%%
            app.CerrarButton.Enable = true;
            app.PlayPauseButton.Text = "Play";
            app.playing = 0;
            app.PlayPauseButton.Enable = true;
            app.SiguienteButton.Enable = true;
            app.CanalDropDown.Enable = true;
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        end

        % Button pushed function: PlayPauseButton
        function PlayPauseButtonPushed(app, event)
             if app.playing == 0
                app.PlayPauseButton.Text = 'Pausa';
                app.playing = 1;
                app.CerrarButton.Enable = false;             
            else
                app.playing = 0;
                app.PlayPauseButton.Text = 'Play';
                app.CerrarButton.Enable = true;
             end    
            ndata = app.indices(end,2)-app.indices(1,1)+1;
            while app.playing == 1
                if app.valor <= ndata
                    %%
                    if app.valor < app.abs_ind(2)
                        app.AnteriorButton.Enable = false;
                    end
                    if app.valor >= app.abs_ind(end)
                        app.SiguienteButton.Enable = false;
                    end
                    %%
                    %% slider
                    app.TiempoSlider.Value = app.valor;
                    app.TextNdataEditField.Value = int2str(app.valor);
                    %% XLims
                    app.UIAxes2.XLim = [app.vector_tiempo(app.valor)-2,app.vector_tiempo(app.valor)+2];
                    app.UIAxes3.XLim = [app.vector_tiempo(app.valor)-2,app.vector_tiempo(app.valor)+2];
                    app.UIAxes5.XLim = [app.vector_tiempo(app.valor)-2,app.vector_tiempo(app.valor)+2];
                    %% lines 
                    app.h1.Value = app.vector_tiempo(app.valor);
                    app.h2.Value = app.vector_tiempo(app.valor);
                    app.h3.Value = app.vector_tiempo(app.valor);
                    %% video
                    %frames_eye0 = read(app.eye0_data,app.eye0_index(app.valor));
                    frames_eye0 = flipud(read(app.eye0_data,app.eye0_index(app.valor)));
                    imshow(frames_eye0, 'Parent', app.UIAxes);
                    %otros 
                    imshow(fullfile(app.BMPfiles_L,'heatmaps',char(app.heatname(app.valor))), 'Parent', app.UIAxes4);
                    app.FrecCardEditField.Value = app.bpm(app.frec_card_index(app.valor),1);
                    %%% duracion - accion
                    app.ParteEditField.Value = app.dur_num(app.valor,1);
                    app.DuracionmsEditField.Value = app.dur_num(app.valor,2);
                    app.AccionEditField.Value = char(app.accion(app.valor));
                    drawnow limitrate
                    app.valor = app.valor + app.dpc_element;
                    
                else
                    app.valor = ndata;
                    app.SiguienteButton.Enable = false;
                    break
                end
            end
            % enables/disables
            app.CerrarButton.Enable = true;
            app.playing = 0;
           
            app.PlayPauseButton.Text = "Play";
        end

        % Value changed function: TiempoSlider
        function TiempoSliderValueChanged(app, event)
            app.valor = round(app.TiempoSlider.Value);
            app.TextNdataEditField.Value = int2str(app.valor);
             %% slider
            app.TiempoSlider.Value = app.valor;
            app.TextNdataEditField.Value = int2str(app.valor);
            %% XLims
            app.UIAxes2.XLim = [app.vector_tiempo(app.valor)-2,app.vector_tiempo(app.valor)+2];
            app.UIAxes3.XLim = [app.vector_tiempo(app.valor)-2,app.vector_tiempo(app.valor)+2];
            app.UIAxes5.XLim = [app.vector_tiempo(app.valor)-2,app.vector_tiempo(app.valor)+2];
            %% lines 
            app.h1.Value = app.vector_tiempo(app.valor);
            app.h2.Value = app.vector_tiempo(app.valor);
            app.h3.Value = app.vector_tiempo(app.valor);
            %% video
            %frames_eye0 = read(app.eye0_data,app.eye0_index(app.valor));
            frames_eye0 = flipud(read(app.eye0_data,app.eye0_index(app.valor)));
            imshow(frames_eye0, 'Parent', app.UIAxes);
            %otros 
            imshow(fullfile(app.BMPfiles_L,'heatmaps',char(app.heatname(app.valor))), 'Parent', app.UIAxes4);
            app.FrecCardEditField.Value = app.bpm(app.frec_card_index(app.valor),1);
            %%% duracion - accion
            app.ParteEditField.Value = app.dur_num(app.valor,1);
            app.DuracionmsEditField.Value = app.dur_num(app.valor,2);
            app.AccionEditField.Value = char(app.accion(app.valor));
        end

        % Value changed function: CargarHeatMapspreviosCheckBox
        function CargarHeatMapspreviosCheckBoxValueChanged(app, event)
            app.loadHM = app.CargarHeatMapspreviosCheckBox.Value;
            
        end

        % Value changed function: CanalDropDown
        function CanalDropDownValueChanged(app, event)
            app.canal_index = app.CanalDropDown.ItemsData(app.CanalDropDown.Value);
            cla(app.UIAxes3, 'reset'); 
            app.UIAxes3.XLim = [app.vector_tiempo(app.valor)-2,app.vector_tiempo(app.valor)+2];
            app.UIAxes3.YLim = [min(min(app.EEG_data(:,2:end)))/5,max(max(app.EEG_data(:,2:end)))/5];
            hold(app.UIAxes3,'on')
            area(app.UIAxes3,app.vector_tiempo,ones_area*1000,'LineWidth',2,'FaceAlpha',0.5)
            area(app.UIAxes3,app.vector_tiempo,-ones_area*1000,'LineWidth',2,'FaceAlpha',0.5)
            app.h2=xline(app.UIAxes3,app.vector_tiempo(app.valor),'-r','LineWidth',1);
            app.eeg_chanel = app.EEG_grafica(app.indices(1,1):app.indices(end,2),app.canal_index+1);
            plot(app.UIAxes3,app.vector_tiempo,app.eeg_chanel,'-b','LineWidth',1)
            hold(app.UIAxes3,'off')
            title(app.UIAxes3,"EEG ("+app.canales(app.canal_index)+")")

        end

        % Value changed function: DatosCicloDropDown
        function DatosCicloDropDownValueChanged(app, event)
            %value = app.DatosCicloDropDown.Value;
            app.dpc_element = str2double(app.DatosCicloDropDown.Value(2:end));
        end

        % Button pushed function: SiguienteButton
        function SiguienteButtonPushed(app, event)
            sig_cond = app.abs_ind > app.valor;
            sig_ind2 = app.abs_ind(sig_cond);
            app.valor = sig_ind2(1);
            if app.valor >= app.abs_ind(end)
                app.SiguienteButton.Enable = false;
            end
            if app.valor >= app.abs_ind(2)
                app.AnteriorButton.Enable = true;
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
             %% slider
            app.TiempoSlider.Value = app.valor;
            app.TextNdataEditField.Value = int2str(app.valor);
            %% XLims
            app.UIAxes2.XLim = [app.vector_tiempo(app.valor)-2,app.vector_tiempo(app.valor)+2];
            app.UIAxes3.XLim = [app.vector_tiempo(app.valor)-2,app.vector_tiempo(app.valor)+2];
            app.UIAxes5.XLim = [app.vector_tiempo(app.valor)-2,app.vector_tiempo(app.valor)+2];
            %% lines 
            app.h1.Value = app.vector_tiempo(app.valor);
            app.h2.Value = app.vector_tiempo(app.valor);
            app.h3.Value = app.vector_tiempo(app.valor);
            %% video
            %frames_eye0 = read(app.eye0_data,app.eye0_index(app.valor));
            frames_eye0 = flipud(read(app.eye0_data,app.eye0_index(app.valor)));
            imshow(frames_eye0, 'Parent', app.UIAxes);
            %otros 
            imshow(fullfile(app.BMPfiles_L,'heatmaps',char(app.heatname(app.valor))), 'Parent', app.UIAxes4);
            app.FrecCardEditField.Value = app.bpm(app.frec_card_index(app.valor),1);
            %%% duracion - accion
            app.ParteEditField.Value = app.dur_num(app.valor,1);
            app.DuracionmsEditField.Value = app.dur_num(app.valor,2);
            app.AccionEditField.Value = char(app.accion(app.valor));
        end

        % Button pushed function: AnteriorButton
        function AnteriorButtonPushed(app, event)
            ant_cond = app.abs_ind < app.valor;
            ant_ind2 = app.abs_ind(ant_cond);
            app.valor = ant_ind2(end);
            if app.valor < app.abs_ind(2)
                app.AnteriorButton.Enable = false;
            end
            if app.valor < app.abs_ind(end)
                app.SiguienteButton.Enable = true;
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %% slider
            app.TiempoSlider.Value = app.valor;
            app.TextNdataEditField.Value = int2str(app.valor);
            %% XLims
            app.UIAxes2.XLim = [app.vector_tiempo(app.valor)-2,app.vector_tiempo(app.valor)+2];
            app.UIAxes3.XLim = [app.vector_tiempo(app.valor)-2,app.vector_tiempo(app.valor)+2];
            app.UIAxes5.XLim = [app.vector_tiempo(app.valor)-2,app.vector_tiempo(app.valor)+2];
            %% lines 
            app.h1.Value = app.vector_tiempo(app.valor);
            app.h2.Value = app.vector_tiempo(app.valor);
            app.h3.Value = app.vector_tiempo(app.valor);
            %% video
            %frames_eye0 = read(app.eye0_data,app.eye0_index(app.valor));
            frames_eye0 = flipud(read(app.eye0_data,app.eye0_index(app.valor)));
            imshow(frames_eye0, 'Parent', app.UIAxes);
            %otros 
            imshow(fullfile(app.BMPfiles_L,'heatmaps',char(app.heatname(app.valor))), 'Parent', app.UIAxes4);
            app.FrecCardEditField.Value = app.bpm(app.frec_card_index(app.valor),1);
            %%% duracion - accion
            app.ParteEditField.Value = app.dur_num(app.valor,1);
            app.DuracionmsEditField.Value = app.dur_num(app.valor,2);
            app.AccionEditField.Value = char(app.accion(app.valor));
        end

        % Button pushed function: CerrarButton
        function CerrarButtonPushed(app, event)
                app.delete;
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 1062 720];
            app.UIFigure.Name = 'MATLAB App';

            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.XTick = [];
            app.UIAxes.XTickLabel = '';
            app.UIAxes.YTick = [];
            app.UIAxes.Position = [842 149 211 186];

            % Create UIAxes2
            app.UIAxes2 = uiaxes(app.UIFigure);
            title(app.UIAxes2, 'ECG')
            xlabel(app.UIAxes2, 'Tiempo (s)')
            ylabel(app.UIAxes2, 'Potencial mV')
            zlabel(app.UIAxes2, 'Z')
            app.UIAxes2.XGrid = 'on';
            app.UIAxes2.YGrid = 'on';
            app.UIAxes2.FontSize = 10;
            app.UIAxes2.Position = [17 150 416 185];

            % Create UIAxes3
            app.UIAxes3 = uiaxes(app.UIFigure);
            title(app.UIAxes3, 'EEG (canal)')
            xlabel(app.UIAxes3, 'Tiempo (s)')
            ylabel(app.UIAxes3, 'Potencial uV')
            zlabel(app.UIAxes3, 'Z')
            app.UIAxes3.XGrid = 'on';
            app.UIAxes3.YGrid = 'on';
            app.UIAxes3.FontSize = 10;
            app.UIAxes3.Position = [443 150 396 185];

            % Create UIAxes4
            app.UIAxes4 = uiaxes(app.UIFigure);
            title(app.UIAxes4, 'Heat map')
            xlabel(app.UIAxes4, 'Pixels X')
            ylabel(app.UIAxes4, 'Pixels Y')
            zlabel(app.UIAxes4, 'Z')
            app.UIAxes4.XLim = [0 1283];
            app.UIAxes4.YLim = [0 720];
            app.UIAxes4.XTick = [];
            app.UIAxes4.YTick = [];
            app.UIAxes4.FontSize = 10;
            app.UIAxes4.Position = [559 366 502 356];

            % Create UIAxes5
            app.UIAxes5 = uiaxes(app.UIFigure);
            title(app.UIAxes5, 'Diametro de la pupila / Parpadeo')
            xlabel(app.UIAxes5, 'Tiempo (s)')
            ylabel(app.UIAxes5, 'Diametro mm')
            zlabel(app.UIAxes5, 'Z')
            app.UIAxes5.XGrid = 'on';
            app.UIAxes5.YGrid = 'on';
            app.UIAxes5.FontSize = 10;
            app.UIAxes5.Position = [13 372 539 185];

            % Create TextArea
            app.TextArea = uitextarea(app.UIFigure);
            app.TextArea.FontSize = 10;
            app.TextArea.FontColor = [0 1 0];
            app.TextArea.BackgroundColor = [0 0 0];
            app.TextArea.Position = [19 13 894 89];
            app.TextArea.Value = {'Error1'; 'Error2'; 'Error3'; 'Error4'; 'Error5'; 'Error6'; 'Error7'};

            % Create PlayPauseButton
            app.PlayPauseButton = uibutton(app.UIFigure, 'push');
            app.PlayPauseButton.ButtonPushedFcn = createCallbackFcn(app, @PlayPauseButtonPushed, true);
            app.PlayPauseButton.Position = [929 55 100 47];
            app.PlayPauseButton.Text = 'Play/Pause';

            % Create CerrarButton
            app.CerrarButton = uibutton(app.UIFigure, 'push');
            app.CerrarButton.ButtonPushedFcn = createCallbackFcn(app, @CerrarButtonPushed, true);
            app.CerrarButton.Position = [929 13 100 37];
            app.CerrarButton.Text = 'Cerrar';

            % Create AnteriorButton
            app.AnteriorButton = uibutton(app.UIFigure, 'push');
            app.AnteriorButton.ButtonPushedFcn = createCallbackFcn(app, @AnteriorButtonPushed, true);
            app.AnteriorButton.Position = [189 574 100 22];
            app.AnteriorButton.Text = 'Anterior';

            % Create SiguienteButton
            app.SiguienteButton = uibutton(app.UIFigure, 'push');
            app.SiguienteButton.ButtonPushedFcn = createCallbackFcn(app, @SiguienteButtonPushed, true);
            app.SiguienteButton.Position = [288 574 96 22];
            app.SiguienteButton.Text = 'Siguiente';

            % Create FrecCardEditFieldLabel
            app.FrecCardEditFieldLabel = uilabel(app.UIFigure);
            app.FrecCardEditFieldLabel.HorizontalAlignment = 'right';
            app.FrecCardEditFieldLabel.Position = [27 341 66 22];
            app.FrecCardEditFieldLabel.Text = 'Frec. Card.';

            % Create FrecCardEditField
            app.FrecCardEditField = uieditfield(app.UIFigure, 'numeric');
            app.FrecCardEditField.Position = [100 341 53 22];

            % Create ListBox
            app.ListBox = uilistbox(app.UIFigure);
            app.ListBox.Items = {'Carpetas'};
            app.ListBox.ValueChangedFcn = createCallbackFcn(app, @ListBoxValueChanged, true);
            app.ListBox.Position = [17 574 145 74];
            app.ListBox.Value = 'Carpetas';

            % Create SeleccionarButton
            app.SeleccionarButton = uibutton(app.UIFigure, 'push');
            app.SeleccionarButton.ButtonPushedFcn = createCallbackFcn(app, @SeleccionarButtonPushed, true);
            app.SeleccionarButton.Position = [348 689 85 22];
            app.SeleccionarButton.Text = 'Seleccionar';

            % Create AbrircarpetaButton
            app.AbrircarpetaButton = uibutton(app.UIFigure, 'push');
            app.AbrircarpetaButton.ButtonPushedFcn = createCallbackFcn(app, @AbrircarpetaButtonPushed, true);
            app.AbrircarpetaButton.Position = [465 666 89 42];
            app.AbrircarpetaButton.Text = 'Abrir carpeta';

            % Create EditField
            app.EditField = uieditfield(app.UIFigure, 'text');
            app.EditField.Position = [17 689 323 22];
            app.EditField.Value = '/home/osvaldo/datos/pupildata/003';

            % Create EEGtimestapmEditFieldLabel
            app.EEGtimestapmEditFieldLabel = uilabel(app.UIFigure);
            app.EEGtimestapmEditFieldLabel.HorizontalAlignment = 'right';
            app.EEGtimestapmEditFieldLabel.Position = [179 626 90 22];
            app.EEGtimestapmEditFieldLabel.Text = 'EEG timestapm';

            % Create EEGtimestapmEditField
            app.EEGtimestapmEditField = uieditfield(app.UIFigure, 'numeric');
            app.EEGtimestapmEditField.ValueChangedFcn = createCallbackFcn(app, @EEGtimestapmEditFieldValueChanged, true);
            app.EEGtimestapmEditField.Position = [275 626 109 22];
            app.EEGtimestapmEditField.Value = 1668451922;

            % Create CargarDatosButton
            app.CargarDatosButton = uibutton(app.UIFigure, 'push');
            app.CargarDatosButton.ButtonPushedFcn = createCallbackFcn(app, @CargarDatosButtonPushed, true);
            app.CargarDatosButton.Position = [189 600 195 22];
            app.CargarDatosButton.Text = 'Cargar Datos';

            % Create EditField_2
            app.EditField_2 = uieditfield(app.UIFigure, 'text');
            app.EditField_2.Position = [17 662 323 22];
            app.EditField_2.Value = '/bmp/dir';

            % Create SelecBMPButton
            app.SelecBMPButton = uibutton(app.UIFigure, 'push');
            app.SelecBMPButton.ButtonPushedFcn = createCallbackFcn(app, @SelecBMPButtonPushed, true);
            app.SelecBMPButton.Position = [348 662 85 22];
            app.SelecBMPButton.Text = 'Selec. BMP';

            % Create CanalDropDownLabel
            app.CanalDropDownLabel = uilabel(app.UIFigure);
            app.CanalDropDownLabel.HorizontalAlignment = 'right';
            app.CanalDropDownLabel.Position = [559 346 37 22];
            app.CanalDropDownLabel.Text = 'Canal';

            % Create CanalDropDown
            app.CanalDropDown = uidropdown(app.UIFigure);
            app.CanalDropDown.ValueChangedFcn = createCallbackFcn(app, @CanalDropDownValueChanged, true);
            app.CanalDropDown.Position = [611 346 81 22];

            % Create TextNdataEditField
            app.TextNdataEditField = uieditfield(app.UIFigure, 'text');
            app.TextNdataEditField.Position = [921 113 108 22];
            app.TextNdataEditField.Value = '0';

            % Create TiempoSliderLabel
            app.TiempoSliderLabel = uilabel(app.UIFigure);
            app.TiempoSliderLabel.HorizontalAlignment = 'right';
            app.TiempoSliderLabel.Position = [11 115 45 22];
            app.TiempoSliderLabel.Text = 'Tiempo';

            % Create TiempoSlider
            app.TiempoSlider = uislider(app.UIFigure);
            app.TiempoSlider.MajorTicks = [];
            app.TiempoSlider.ValueChangedFcn = createCallbackFcn(app, @TiempoSliderValueChanged, true);
            app.TiempoSlider.MinorTicks = [];
            app.TiempoSlider.Position = [77 124 823 3];

            % Create DatosCicloDropDownLabel
            app.DatosCicloDropDownLabel = uilabel(app.UIFigure);
            app.DatosCicloDropDownLabel.HorizontalAlignment = 'right';
            app.DatosCicloDropDownLabel.Position = [393 557 67 22];
            app.DatosCicloDropDownLabel.Text = 'Datos/Ciclo';

            % Create DatosCicloDropDown
            app.DatosCicloDropDown = uidropdown(app.UIFigure);
            app.DatosCicloDropDown.Items = {'datos'};
            app.DatosCicloDropDown.ValueChangedFcn = createCallbackFcn(app, @DatosCicloDropDownValueChanged, true);
            app.DatosCicloDropDown.Position = [475 557 70 22];
            app.DatosCicloDropDown.Value = 'datos';

            % Create CargarHeatMapspreviosCheckBox
            app.CargarHeatMapspreviosCheckBox = uicheckbox(app.UIFigure);
            app.CargarHeatMapspreviosCheckBox.ValueChangedFcn = createCallbackFcn(app, @CargarHeatMapspreviosCheckBoxValueChanged, true);
            app.CargarHeatMapspreviosCheckBox.Text = 'Cargar HeatMaps previos';
            app.CargarHeatMapspreviosCheckBox.Position = [393 632 159 22];

            % Create MinPeakHeightuVEditFieldLabel
            app.MinPeakHeightuVEditFieldLabel = uilabel(app.UIFigure);
            app.MinPeakHeightuVEditFieldLabel.HorizontalAlignment = 'right';
            app.MinPeakHeightuVEditFieldLabel.Position = [389 583 105 22];
            app.MinPeakHeightuVEditFieldLabel.Text = 'MinPeakHeight uV';

            % Create MinPeakHeightuVEditField
            app.MinPeakHeightuVEditField = uieditfield(app.UIFigure, 'numeric');
            app.MinPeakHeightuVEditField.ValueChangedFcn = createCallbackFcn(app, @MinPeakHeightuVEditFieldValueChanged, true);
            app.MinPeakHeightuVEditField.Position = [498 583 47 22];
            app.MinPeakHeightuVEditField.Value = 273;

            % Create MinPeakDistanceEditFieldLabel
            app.MinPeakDistanceEditFieldLabel = uilabel(app.UIFigure);
            app.MinPeakDistanceEditFieldLabel.HorizontalAlignment = 'right';
            app.MinPeakDistanceEditFieldLabel.Position = [392 605 99 22];
            app.MinPeakDistanceEditFieldLabel.Text = 'MinPeakDistance';

            % Create MinPeakDistanceEditField
            app.MinPeakDistanceEditField = uieditfield(app.UIFigure, 'numeric');
            app.MinPeakDistanceEditField.ValueChangedFcn = createCallbackFcn(app, @MinPeakDistanceEditFieldValueChanged, true);
            app.MinPeakDistanceEditField.Position = [498 605 47 22];
            app.MinPeakDistanceEditField.Value = 100;

            % Create ParteEditFieldLabel
            app.ParteEditFieldLabel = uilabel(app.UIFigure);
            app.ParteEditFieldLabel.HorizontalAlignment = 'right';
            app.ParteEditFieldLabel.Position = [701 344 34 22];
            app.ParteEditFieldLabel.Text = 'Parte';

            % Create ParteEditField
            app.ParteEditField = uieditfield(app.UIFigure, 'numeric');
            app.ParteEditField.Position = [740 344 21 22];

            % Create AccionEditFieldLabel
            app.AccionEditFieldLabel = uilabel(app.UIFigure);
            app.AccionEditFieldLabel.HorizontalAlignment = 'right';
            app.AccionEditFieldLabel.Position = [931 343 42 22];
            app.AccionEditFieldLabel.Text = 'Accion';

            % Create AccionEditField
            app.AccionEditField = uieditfield(app.UIFigure, 'text');
            app.AccionEditField.Position = [981 344 75 22];
            app.AccionEditField.Value = 'Nada/Error';

            % Create DuracionmsEditFieldLabel
            app.DuracionmsEditFieldLabel = uilabel(app.UIFigure);
            app.DuracionmsEditFieldLabel.HorizontalAlignment = 'right';
            app.DuracionmsEditFieldLabel.Position = [769 343 81 22];
            app.DuracionmsEditFieldLabel.Text = 'Duracion (ms)';

            % Create DuracionmsEditField
            app.DuracionmsEditField = uieditfield(app.UIFigure, 'numeric');
            app.DuracionmsEditField.Position = [853 343 69 22];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = app_eyetracker_ecg_eeg_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end