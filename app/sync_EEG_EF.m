% relaciona los vectores de tiempo de los datos EEG y Emo_Flechas
function index = sync_EEG_EF(datosEEG,datosEF)
    index = zeros(length(datosEF.Var6),2);
    for i = 1:length(datosEF.Var6)
        val1=datosEF.Var6(i)/1000;
        val2=datosEF.Var7(i)/1000;
        [~,I1] = min(abs(val1-datosEEG(:,1)));
        [~,I2] = min(abs(val2-datosEEG(:,1)));
        index(i,:) = [I1,I2];
    end
end

