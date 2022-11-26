% relaciona los vectores de tiempo de los datos EEG y frecuencia cardiaca
function index_FC = sync_EEG_FrecCard(datos_tiempo,datos_tiempoFC)
    index_FC = zeros(length(datos_tiempo),1);
    for i = 1:length(datos_tiempo)
            [~,I] = min(abs(datos_tiempoFC-datos_tiempo(i)));
            index_FC(i) = I; 
    end
end
