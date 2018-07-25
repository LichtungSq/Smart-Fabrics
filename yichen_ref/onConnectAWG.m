function onConnectAWG(~,~)
global gui;
global systemParameters;

try
    if isempty(systemParameters.AWGObj),
        % If scope has not been connected
        props = regexp(systemParameters.AWGAddress,'::','split');
        if ~isempty(str2num(props{3})),
            % 81180A
            systemParameters.AWGObj = instrfind('Type', 'tcpip', 'RemoteHost', props{2}, 'RemotePort', str2num(props{3}));
            % Create the VISA object if it does not exist
            % otherwise use the object that was found.
            if isempty(systemParameters.AWGObj),
                systemParameters.AWGObj = tcpip(props{2},str2num(props{3}));
            else
                fclose(systemParameters.AWGObj);
                systemParameters.AWGObj = systemParameters.AWGObj(1);
            end
            % Set the buffer size
            systemParameters.AWGObj.OutputBufferSize = 80000000;
            fopen(systemParameters.AWGObj);
            % Update button appearance and text
            set(gui.connectAWG,'BackgroundColor',[0 0.498 0]);
            set(gui.connectAWG,'String','Disconnect AWG');
            % Run setup commands
            fprintf(systemParameters.AWGObj, '*RST'); % Reset instrument
            operationComplete = str2double(query(systemParameters.AWGObj,'*OPC?'));
            while ~operationComplete
                operationComplete = str2double(query(systemParameters.AWGObj,'*OPC?'));
            end
            fprintf(systemParameters.AWGObj, ':SOUR:ROSC:SOUR EXT'); % Set oscillator clock to EXT
            fprintf(systemParameters.AWGObj, ':SOUR:ROSC:EXT:FREQ 10e6'); % Set frequency to 10MHz
            fprintf(systemParameters.AWGObj, ':INST:COUP:STAT ON'); % Couple sampling clock on channels
        else
            % 33522A
            vAddress = ['TCPIP0::' props{2} '::inst0::INSTR']; %build visa address string to connect
            systemParameters.AWGObj = visa('AGILENT',vAddress); %build IO object
            systemParameters.AWGObj.Timeout = 15; %set IO time out
            %calculate output buffer size
            set(systemParameters.AWGObj,'OutputBufferSize',80000000);
            % open connection to 33500A/B waveform generator
            fopen(systemParameters.AWGObj);
            % Update button appearance and text
            set(gui.connectAWG,'BackgroundColor',[0 0.498 0]);
            set(gui.connectAWG,'String','Disconnect AWG');
        end
    elseif ~isempty(systemParameters.AWGObj),
        % If scope is already connected, disconnect
        fclose(systemParameters.AWGObj);
        systemParameters.AWGObj = [];
        % Update button appearance and text
        set(gui.connectAWG,'BackgroundColor',[0.847 0.161 0]);
        set(gui.connectAWG,'String','Connect AWG');
    end
catch ME,
    systemParameters.AWGObj = [];
    set(gui.connectAWG,'BackgroundColor',[0.847 0.161 0]);
    set(gui.connectAWG,'String','Connect AWG');
    errordlg(ME.message,'Error');
end