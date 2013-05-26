unit MainUnit;

interface

uses
  Classes, Windows, OleCtrls, SHDocVw;

const
  EVENT_BEFORE_NAVIGATE = 1;

type
  TWebBrowserEventProc = procedure(EventCode: Integer; URL: PWideChar) of object;

  TInnoWebBrowser = class
  private
    FWebBrowser: TWebBrowser;
    FEventCallback: TWebBrowserEventProc;
    procedure OnBeforeNavigate2(ASender: TObject; const pDisp: IDispatch; var URL: OleVariant;
      var Flags: OleVariant; var TargetFrameName: OleVariant; var PostData: OleVariant;
      var Headers: OleVariant; var Cancel: WordBool);
  public
    constructor Create;
    destructor Destroy; override;
    procedure InitWebBrowser(ParentWnd: HWND; Left, Top, Width,
      Height: Integer; CallbackProc: TWebBrowserEventProc);
    procedure ShowWebBrowser(Visible: Boolean);
    procedure NavigateWebBrowser(URL: PWideChar);
  end;

procedure CreateWebBrowser(ParentWnd: HWND; Left, Top, Width,
  Height: Integer; CallbackProc: TWebBrowserEventProc); stdcall;
procedure DestroyWebBrowser; stdcall;
procedure ShowWebBrowser(Visible: Boolean); stdcall;
procedure NavigateWebBrowser(URL: PWideChar); stdcall;

implementation

var
  InnoWebBrowser: TInnoWebBrowser;

procedure CreateWebBrowser(ParentWnd: HWND; Left, Top, Width, Height: Integer;
  CallbackProc: TWebBrowserEventProc);
begin
  DestroyWebBrowser;
  InnoWebBrowser := TInnoWebBrowser.Create;
  InnoWebBrowser.InitWebBrowser(ParentWnd, Left, Top, Width, Height, CallbackProc);
end;

procedure DestroyWebBrowser;
begin
  InnoWebBrowser.Free;
  InnoWebBrowser := nil;
end;

procedure ShowWebBrowser(Visible: Boolean);
begin
  if Assigned(InnoWebBrowser) then
    InnoWebBrowser.ShowWebBrowser(Visible);
end;

procedure NavigateWebBrowser(URL: PWideChar);
begin
  if Assigned(InnoWebBrowser) then
    InnoWebBrowser.NavigateWebBrowser(URL);
end;

{ TInnoWebBrowser }

constructor TInnoWebBrowser.Create;
begin
  FWebBrowser := TWebBrowser.Create(nil);
end;

destructor TInnoWebBrowser.Destroy;
begin
  FWebBrowser.Free;
  inherited;
end;

procedure TInnoWebBrowser.InitWebBrowser(ParentWnd: HWND; Left, Top, Width, Height: Integer;
  CallbackProc: TWebBrowserEventProc);
begin
  FWebBrowser.ParentWindow := ParentWnd;
  FWebBrowser.Left := Left;
  FWebBrowser.Top := Top;
  FWebBrowser.Width := Width;
  FWebBrowser.Height := Height;
  FWebBrowser.OnBeforeNavigate2 := OnBeforeNavigate2;

  FEventCallback := CallbackProc;
end;

procedure TInnoWebBrowser.NavigateWebBrowser(URL: PWideChar);
begin
  FWebBrowser.Navigate(URL);
end;

procedure TInnoWebBrowser.OnBeforeNavigate2(ASender: TObject; const pDisp: IDispatch; var URL,
  Flags, TargetFrameName, PostData, Headers: OleVariant; var Cancel: WordBool);
var
  URLString: WideString;
begin
  if Assigned(FEventCallback) then
  begin
    URLString := URL;
    FEventCallback(EVENT_BEFORE_NAVIGATE, PWideChar(URLString));
  end;
end;

procedure TInnoWebBrowser.ShowWebBrowser(Visible: Boolean);
begin
  if Visible then
    FWebBrowser.Show
  else
    FWebBrowser.Hide;
end;

end.
