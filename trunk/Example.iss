[Setup]
AppName=Web Browser Project
AppVersion=1.0
DefaultDirName={pf}\Web Browser Project

[Files]
Source:"WebBrowser.dll"; Flags: dontcopy

[Code]
var
  CustomPage: TWizardPage;

procedure CreateWebBrowser(ParentWnd: HWND; Left, Top, Width, Height: Integer);
  external 'CreateWebBrowser@files:webbrowser.dll stdcall';
procedure DestroyWebBrowser;
  external 'DestroyWebBrowser@files:webbrowser.dll stdcall';
procedure ShowWebBrowser(Visible: Boolean);
  external 'ShowWebBrowser@files:webbrowser.dll stdcall';
procedure NavigateWebBrowser(URL: WideString);
  external 'NavigateWebBrowser@files:webbrowser.dll stdcall';

procedure InitializeWizard;
begin
  CustomPage := CreateCustomPage(wpWelcome, 'Web Browser Page', 
    'This page contains web browser');
  CreateWebBrowser(WizardForm.InnerPage.Handle, 0, WizardForm.Bevel1.Top, 
    WizardForm.InnerPage.ClientWidth, WizardForm.InnerPage.ClientHeight - WizardForm.Bevel1.Top);
  NavigateWebBrowser('http://www.google.com/pda/');
end;

procedure DeinitializeSetup;
begin
  DestroyWebBrowser;
end;

procedure CurPageChanged(CurPageID: Integer);
begin
  ShowWebBrowser(CurPageID = CustomPage.ID);
end;


