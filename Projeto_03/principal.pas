unit principal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, SQLite3Conn, IBConnection, Forms, Controls, Graphics,
  Dialogs, DBGrids, Menus, ComCtrls, ExtCtrls, ZConnection, ZDataset;

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
    ZConnection2: TZConnection;
    ZQuery1: TZQuery;
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ZConnection1AfterConnect(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure ConectarBanco;
  public
    procedure AtualizarDados;

  end;

var
  frmPrincipal: TfrmPrincipal;

implementation
uses
  produto, cliente;

{$R *.lfm}

{ TfrmPrincipal }

procedure TfrmPrincipal.ConectarBanco;
begin
  try
    if not ZConnection1.Connected then
    begin
      ZConnection1.Connected := True;
      bar.Panels[1].Text := 'Banco conectado';
    end;
    
    // Abre a query se não estiver ativa
    if ZConnection1.Connected and not ZQuery1.Active then
    begin
      ZQuery1.Open;
      bar.Panels[1].Text := 'Dados carregados';
    end;
  except
    on E: Exception do
    begin
      ShowMessage('Erro ao conectar com o banco: ' + E.Message);
      bar.Panels[1].Text := 'Erro na conexão';
    end;
  end;
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  ConectarBanco;
end;

procedure TfrmPrincipal.Timer1Timer(Sender: TObject);
begin
  bar.Panels[0].text:= 'Data: ' + datetostr(now);
  frmProduto.bar.Panels[0].text:= 'Hora: ' + timetostr(now);
  bar.Panels[2].text:= 'Hora: ' + timetostr(now);
     end;

procedure TfrmPrincipal.ZConnection1AfterConnect(Sender: TObject);
begin
  // Conecta ao banco e abre as tabelas necessárias
  try
    if not ZQuery1.Active then
    begin
      ZQuery1.Open;
      bar.Panels[1].Text := 'Dados carregados';
    end;
  except
    on E: Exception do
    begin
      ShowMessage('Erro ao carregar dados: ' + E.Message);
      bar.Panels[1].Text := 'Erro ao carregar dados';
    end;
  end;
end;

procedure TfrmPrincipal.MenuItem3Click(Sender: TObject);
begin
   frmProduto.Show;
end;

procedure TfrmPrincipal.MenuItem2Click(Sender: TObject);
begin
    frmCliente.Show;
end;

procedure TfrmPrincipal.AtualizarDados;
begin
  try
    if ZQuery1.Active then
    begin
      ZQuery1.Refresh;
      bar.Panels[1].Text := 'Dados atualizados - ' + DateTimeToStr(Now);
    end;
  except
    on E: Exception do
      ShowMessage('Erro ao atualizar dados: ' + E.Message);
  end;
end;

end.

