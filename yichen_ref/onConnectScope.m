function onConnectScope(~,~)

global gui;
global systemParameters;

try
    if isempty(systemParameters.ScopeObj),
        % If scope has not been connected
        systemParameters.ScopeObj = instrfind('Type', 'visa-usb', 'RsrcName', systemParameters.ScopeAddress, 'Tag', '');
        % Create the VISA object if it does not exist
        % otherwise use the object that was found.
        if isempty(systemParameters.ScopeObj),
            systemParameters.ScopeObj = visa('AGILENT', systemParameters.ScopeAddress);
        else
            fclose(systemParameters.ScopeObj);
            systemParameters.ScopeObj = systemParameters.ScopeObj(1);
        end
        % Set the buffer size
        systemParameters.ScopeObj.InputBufferSize = 8000000;
        % Set the timeout value
        systemParameters.ScopeObj.Timeout = 10;
        % Set the Byte order
        systemParameters.ScopeObj.ByteOrder = 'littleEndian';
        fopen(systemParameters.ScopeObj);
        % Update button appearance and text
        set(gui.connectScope,'BackgroundColor',[0 0.498 0]);
        set(gui.connectScope,'String','Disconnect Scope');
        % Run setup commands
%         fprintf(systemParameters.ScopeObj, '*RST'); % Reset instrument
%         operationComplete = str2double(query(systemParameters.ScopeObj,'*OPC?'));
%         while ~operationComplete
%             operationComplete = str2double(query(systemParameters.ScopeObj,'*OPC?'));
%         end
        fprintf(systemParameters.ScopeObj, ':ACQuire:RSIGnal OUT');
        instrumentError = query(systemParameters.ScopeObj,':SYSTEM:ERR?');
        while ~(isequal(instrumentError,['+0,"No error"' char(10)]) || isequal(instrumentError,['0' char(10)])),
            disp(['Instrument Error: ' instrumentError]);
            instrumentError = query(systemParameters.ScopeObj,':SYSTEM:ERR?');
        end
    elseif ~isempty(systemParameters.ScopeObj),
        % If scope is already connected, disconnect
        fclose(systemParameters.ScopeObj);
        systemParameters.ScopeObj = [];
        % Update button appearance and text
        set(gui.connectScope,'BackgroundColor',[0.847 0.161 0]);
        set(gui.connectScope,'String','Connect Scope');
    end
catch ME,
    systemParameters.ScopeObj = [];
    set(gui.connectScope,'BackgroundColor',[0.847 0.161 0]);
    set(gui.connectScope,'String','Connect Scope');
    errordlg(ME.message,'Error');
end