unit cliente;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, DBCtrls, DBGrids,
  StdCtrls, ComCtrls, ZDataset, ZAbstractRODataset;

type

  { Tfrmcliente }

  Tfrmcliente = class(TForm)
    DataSource1: TDataSource;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    DBEdit5: TDBEdit;
    DBEdit6: TDBEdit;
    DBEdit7: TDBEdit;
    DBEdit8: TDBEdit;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    DBRadioGroup1: TDBRadioGroup;
    DBRadioGroup2: TDBRadioGroup;
    Label1: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    nome: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    ZTable1: TZTable;
    ZTable1BAIRRO: TZRawStringField;
    ZTable1CEP: TZRawStringField;
    ZTable1COMPLEMENTO: TZRawStringField;
    ZTable1CPF: TZRawStringField;
    ZTable1EMAIL: TZRawStringField;
    ZTable1GENERO: TZRawStringField;
    ZTable1MEMBERSHIP: TZRawStringField;
    ZTable1NOME: TZRawStringField;
    ZTable1NUMERO_CASA: TZIntegerField;
    ZTable1RUA: TZRawStringField;
    ZTable1TELEFONE: TZRawStringField;
    procedure DataSource1DataChange(Sender: TObject; Field: TField);
    procedure DBRadioGroup1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure ConectarBanco;
  public

  end;

var
  frmcliente: Tfrmcliente;

implementation
uses
  principal;

{$R *.lfm}

{ Tfrmcliente }

procedure Tfrmcliente.ConectarBanco;
begin
  try
    // Conecta ao banco se não estiver conectado
    if not frmPrincipal.ZConnection1.Connected then
      frmPrincipal.ZConnection1.Connected := True;
    
    // Só abre a tabela se não estiver ativa
    if not ZTable1.Active then
    begin
      ZTable1.Active := True;
      Caption := 'Cliente - Conectado';
    end;
      
  except
    on E: Exception do
    begin
      ShowMessage('Erro ao conectar com o banco de dados: ' + E.Message);
      Caption := 'Cliente - Erro na Conexão';
    end;
  end;
end;

procedure Tfrmcliente.FormCreate(Sender: TObject);
begin
  ConectarBanco;
end;

procedure Tfrmcliente.FormShow(Sender: TObject);
begin
  // Só conecta se não estiver conectado para evitar loops
  if not ZTable1.Active then
    ConectarBanco;
end;

procedure Tfrmcliente.DataSource1DataChange(Sender: TObject; Field: TField);
begin
  // Atualiza o título baseado no estado da tabela
  // Usa try-except para evitar loops infinitos
  try
    if ZTable1.Active then
    begin
      case ZTable1.State of
        dsInsert: Caption := 'Cliente - Novo Registro (Inserindo)';
        dsEdit: Caption := 'Cliente - Editando Registro';
        dsBrowse: Caption := 'Cliente - Navegando (' + IntToStr(ZTable1.RecordCount) + ' registros)';
        else Caption := 'Cliente - ' + IntToStr(ZTable1.RecordCount) + ' registros';
      end;
    end
    else
      Caption := 'Cliente - Desconectado';
  except
    // Ignora erros para evitar loops
  end;
end;

procedure Tfrmcliente.DBRadioGroup1Click(Sender: TObject);
begin

end;

end.

