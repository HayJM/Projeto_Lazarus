unit produto;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, ComCtrls, DBGrids,
  StdCtrls, ExtCtrls, DBCtrls, ZDataset, ZAbstractRODataset;

type

  { TfrmProduto }

  TfrmProduto = class(TForm)
    DataSource1: TDataSource;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    DBEdit5: TDBEdit;
    DBEdit6: TDBEdit;
    DBEdit7: TDBEdit;
    DBEdit8: TDBEdit;
    DBMemo1: TDBMemo;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    bar: TStatusBar;
    ZTable1: TZTable;
    ZTable1DATAAQUISICAO: TZDateField;
    ZTable1DESCRIOCAO: TZRawCLobField;
    ZTable1FORNECEDOR: TZRawStringField;
    ZTable1ID: TZIntegerField;
    ZTable1MARCA: TZRawStringField;
    ZTable1NOME: TZRawStringField;
    ZTable1PRECOCOMPRA: TZBCDField;
    ZTable1PRECOVENDA: TZBCDField;
    ZTable1QUANTIDADE: TZIntegerField;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DataSource1DataChange(Sender: TObject; Field: TField);
  private
    procedure ConectarBanco;
    procedure VerificarEstado;
  public

  end;

var
  frmProduto: TfrmProduto;

implementation
uses
  principal;

{$R *.lfm}

{ TfrmProduto }

procedure TfrmProduto.ConectarBanco;
begin
  try
    // Conecta ao banco se não estiver conectado
    if not frmPrincipal.ZConnection1.Connected then
      frmPrincipal.ZConnection1.Connected := True;
    
    // Define a conexão do ZTable1
    ZTable1.Connection := frmPrincipal.ZConnection1;
    
    // Só abre a tabela se não estiver ativa
    if not ZTable1.Active then
    begin
      ZTable1.Active := True;
      Caption := 'Produto - Conectado (' + IntToStr(ZTable1.RecordCount) + ' registros)';
    end;
    
    // Garante que o DBNavigator está habilitado
    DBNavigator1.Enabled := True;
      
  except
    on E: Exception do
    begin
      ShowMessage('Erro ao conectar com o banco de dados: ' + E.Message);
      Caption := 'Produto - Erro na Conexão';
      DBNavigator1.Enabled := False;
    end;
  end;
end;

procedure TfrmProduto.VerificarEstado;
var
  statusMsg: string;
begin
  try
    statusMsg := 'Status Debug Produto:' + #13#10;
    statusMsg := statusMsg + 'Conexão: ' + BoolToStr(frmPrincipal.ZConnection1.Connected, True) + #13#10;
    statusMsg := statusMsg + 'Tabela Ativa: ' + BoolToStr(ZTable1.Active, True) + #13#10;
    statusMsg := statusMsg + 'DataSource Dataset: ' + BoolToStr(DataSource1.DataSet <> nil, True) + #13#10;
    statusMsg := statusMsg + 'DBNavigator Enabled: ' + BoolToStr(DBNavigator1.Enabled, True) + #13#10;
    if ZTable1.Active then
      statusMsg := statusMsg + 'Registros: ' + IntToStr(ZTable1.RecordCount) + #13#10;
    
    // Mostra apenas se houver problema
    if not frmPrincipal.ZConnection1.Connected or not ZTable1.Active or not DBNavigator1.Enabled then
      ShowMessage(statusMsg);
      
  except
    on E: Exception do
      ShowMessage('Erro na verificação: ' + E.Message);
  end;
end;

procedure TfrmProduto.FormCreate(Sender: TObject);
begin
  ConectarBanco;
  VerificarEstado;
  bar.Panels[2].text := 'Hoje é ' + FormatDateTime('dddddd', date);
end;

procedure TfrmProduto.FormShow(Sender: TObject);
begin
  // Só conecta se não estiver conectado para evitar loops
  if not ZTable1.Active then
    ConectarBanco;
end;

procedure TfrmProduto.DataSource1DataChange(Sender: TObject; Field: TField);
begin
  // Atualiza o título baseado no estado da tabela
  // Usa try-except para evitar loops infinitos
  try
    if ZTable1.Active then
    begin
      case ZTable1.State of
        dsInsert: Caption := 'Produto - Novo Registro (Inserindo)';
        dsEdit: Caption := 'Produto - Editando Registro';
        dsBrowse: Caption := 'Produto - Navegando (' + IntToStr(ZTable1.RecordCount) + ' registros)';
        else Caption := 'Produto - ' + IntToStr(ZTable1.RecordCount) + ' registros';
      end;
    end
    else
      Caption := 'Produto - Desconectado';
  except
    // Ignora erros para evitar loops
  end;
end;

end.

