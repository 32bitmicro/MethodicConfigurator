; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!
; This file should be run from MethodicConfiguratorWinBuild.bat

#define MyAppName "MethodicConfigurator"
; Note MyAppVersion is defined in MethodicConfiguratorWinBuild.bat
; #define MyAppVersion {code:GetVersion}
#define MyAppPublisher "Amilcar do Carmo Lucas"
#define MyAppURL "https://github.com/ArduPilot/MethodicConfigurator"
#define MyAppExeName "ardupilot_methodic_configurator.exe"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{F13FF76D-C9FC-47F0-BCE3-A2E0ED2859F6}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={commonpf}\{#MyAppName}
DefaultGroupName={#MyAppName}
LicenseFile=..\LICENSE.md
OutputBaseFilename=MethodicConfiguratorSetup-{#MyAppVersion}
Compression=lzma
SolidCompression=yes
ChangesEnvironment=yes

[InstallDelete]
Type: filesandordirs; Name: {commonpf}\{#MyAppName}

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "..\MethodicConfigurator\dist\ardupilot_methodic_configurator\ardupilot_methodic_configurator.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\MethodicConfigurator\dist\ardupilot_methodic_configurator\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
; NOTE: Don't use "Flags: ignoreversion" on any shared system files
Source: "..\vehicle_examples\diatone_taycan_mxc\4.3.8-params\*.*"; DestDir: "{commonappdata}\.ardupilot_methodic_configurator\vehicle_examples\diatone_taycan_mxc\4.3.8-params"; Flags: ignoreversion
Source: "..\vehicle_examples\diatone_taycan_mxc\4.4.4-params\*.*"; DestDir: "{commonappdata}\.ardupilot_methodic_configurator\vehicle_examples\diatone_taycan_mxc\4.4.4-params"; Flags: ignoreversion
Source: "..\vehicle_examples\diatone_taycan_mxc\4.5.1-params\*.*"; DestDir: "{commonappdata}\.ardupilot_methodic_configurator\vehicle_examples\diatone_taycan_mxc\4.5.1-params"; Flags: ignoreversion
Source: "..\vehicle_examples\diatone_taycan_mxc\4.6.0-DEV-params\*.*"; DestDir: "{commonappdata}\.ardupilot_methodic_configurator\vehicle_examples\diatone_taycan_mxc\4.6.0-DEV-params"; Flags: ignoreversion
Source: "..\windows\version.txt"; DestDir: "{commonappdata}\.ardupilot_methodic_configurator"; Flags: ignoreversion
Source: "..\windows\MethodicConfigurator.ico"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\MethodicConfigurator\ArduPilot_icon.png"; DestDir: "{app}\_internal"; Flags: ignoreversion
Source: "..\MethodicConfigurator\ArduPilot_logo.png"; DestDir: "{app}\_internal"; Flags: ignoreversion
Source: "..\MethodicConfigurator\file_documentation.json"; DestDir: "{app}\_internal"; Flags: ignoreversion
Source: "..\credits\*.*"; DestDir: "{app}\credits"; Flags: ignoreversion

[Icons]
Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; WorkingDir: "{commonappdata}\.ardupilot_methodic_configurator\vehicle_examples"; Tasks: desktopicon; IconFilename: "{app}\MethodicConfigurator.ico"
Name: "{group}\Documentation"; Filename: "https://github.com/ArduPilot/MethodicConfigurator/blob/master/USERMANUAL.md"
Name: "{group}\Vehicle Examples"; Filename: "{commonappdata}\.ardupilot_methodic_configurator\vehicle_examples"
Name: "{group}\ArduPilot MethodicConfigurator Forum"; Filename: "https://discuss.ardupilot.org/t/new-ardupilot-methodic-configurator-gui/115038/"
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; WorkingDir: "{commonappdata}\.ardupilot_methodic_configurator\vehicle_examples"; IconFilename: "{app}\MethodicConfigurator.ico"

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

[Registry]
Root: HKLM; Subkey: "SYSTEM\CurrentControlSet\Control\Session Manager\Environment"; \
    ValueType: expandsz; ValueName: "PATH"; ValueData: "{olddata};{app}"; \
    Check: NeedsAddPath('{app}')
Root: HKLM; Subkey: "SYSTEM\CurrentControlSet\Control\Session Manager\Environment";  ValueName: "PATH"; ValueData: "{app}"; Flags: uninsdeletevalue

[Code]
function NeedsAddPath(Param: string): boolean;
var
  OrigPath: string;
begin
  if not RegQueryStringValue(
    HKEY_LOCAL_MACHINE,
    'SYSTEM\CurrentControlSet\Control\Session Manager\Environment',
    'Path', OrigPath)
  then begin
    Result := True;
    exit;
  end;
  { look for the path with leading and trailing semicolon }
  { Pos() returns 0 if not found }
  Result :=
    (Pos(';' + UpperCase(Param) + ';', ';' + UpperCase(OrigPath) + ';') = 0) and
    (Pos(';' + UpperCase(Param) + '\;', ';' + UpperCase(OrigPath) + ';') = 0); 
end;

var
  Paths: string;

const
  EnvironmentKey = 'SYSTEM\CurrentControlSet\Control\Session Manager\Environment';
  SMTO_ABORTIFHUNG = 2;
  WM_WININICHANGE = $001A;
  WM_SETTINGCHANGE = WM_WININICHANGE;

type
  WPARAM = UINT_PTR;
  LPARAM = INT_PTR;
  LRESULT = INT_PTR;

function SendTextMessageTimeout(hWnd: HWND; Msg: UINT;
  wParam: WPARAM; lParam: PAnsiChar; fuFlags: UINT;
  uTimeout: UINT; out lpdwResult: DWORD): LRESULT;
  external 'SendMessageTimeoutA@user32.dll stdcall';  

procedure SaveOldPath();
begin
  if not RegQueryStringValue(HKEY_LOCAL_MACHINE, EnvironmentKey, 'Path', Paths) then
  begin
    Log('PATH not found');
  end else begin
    Log(Format('Old Path saved as [%s]', [Paths]));
  end;
end;

procedure RemovePath(Path: string);
var
  P: Integer;
begin
  Log(Format('Prepare to remove from Old PATH [%s]', [Paths]));

  P := Pos(';' + Uppercase(Path) + ';', ';' + Uppercase(Paths) + ';');
  if P = 0 then
  begin
    Log(Format('Path [%s] not found in PATH', [Path]));
  end
    else
  begin
    Delete(Paths, P - 1, Length(Path) + 1);
    Log(Format('Path [%s] removed from PATH => [%s]', [Path, Paths]));

    if RegWriteExpandStringValue(HKEY_LOCAL_MACHINE, EnvironmentKey, 'Path', Paths) then
    begin
      Log('PATH written');
    end
      else
    begin
      Log('Error writing PATH');
    end;
  end;
end;

procedure RefreshEnvironment;
var
  S: AnsiString;
  MsgResult: DWORD;
begin
  S := 'Environment';
  SendTextMessageTimeout(HWND_BROADCAST, WM_SETTINGCHANGE, 0,
    PAnsiChar(S), SMTO_ABORTIFHUNG, 5000, MsgResult);
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin
  if CurUninstallStep =  usUninstall then
  begin
    SaveOldPath();
  end;
  if CurUninstallStep = usPostUninstall then
  begin
    RemovePath(ExpandConstant('{app}'));
    RefreshEnvironment();
  end;
end;
