unit MainUnit;

interface

uses
  Classes, Windows, OleCtrls, SHDocVw;

procedure CreateWebBrowser(ParentWnd: HWND; Left, Top, Width,
  Height: Integer); stdcall;
procedure DestroyWebBrowser; stdcall;
procedure ShowWebBrowser(Visible: Boolean); stdcall;
procedure NavigateWebBrowser(URL: PWideChar); stdcall;

implementation

var
  WebBrowser: TWebBrowser;

procedure CreateWebBrowser(ParentWnd: HWND; Left, Top, Width, Height: Integer);
begin
  WebBrowser := TWebBrowser.Create(nil);
  WebBrowser.ParentWindow := ParentWnd;
  WebBrowser.Left := Left;
  WebBrowser.Top := Top;
  WebBrowser.Width := Width;
  WebBrowser.Height := Height;
end;

procedure DestroyWebBrowser;
begin
  if Assigned(WebBrowser) then
  begin
    WebBrowser.Free;
    WebBrowser := nil;
  end;
end;

procedure ShowWebBrowser(Visible: Boolean);
begin
  if Assigned(WebBrowser) then
  begin
    if Visible then
      WebBrowser.Show
    else
      WebBrowser.Hide;
  end;
end;

procedure NavigateWebBrowser(URL: PWideChar);
begin
  if Assigned(WebBrowser) then
    WebBrowser.Navigate(URL);
end;

end.
