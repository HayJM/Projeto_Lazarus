unit principal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, DBGrids, Menus,
  ComCtrls, ExtCtrls, ZConnection, ZDataset;

type

  { TfrmPrincipal }

  TfrmPrincipal = class(TForm)
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    bar: TStatusBar;
    Timer1: TTimer;
    ZConnection1: TZConnection;
    ZQuery1: TZQuery;
    procedure MenuItem3Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private

  public

  end;

var
  frmPrincipal: TfrmPrincipal;

implementation
uses
  produto;

{$R *.lfm}

{ TfrmPrincipal }

procedure TfrmPrincipal.Timer1Timer(Sender: TObject);
begin
  bar.Panels[0].text:= 'Data: ' + datetostr(now);
  frmProduto.bar.Panels[0].text:= 'Hora: ' + timetostr(now);
  bar.Panels[2].text:= 'Hora: ' + timetostr(now);
     end;

procedure TfrmPrincipal.MenuItem3Click(Sender: TObject);
begin
   frmProduto.Show;
end;

end.

