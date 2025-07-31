unit CadastroCliente;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  MaskEdit, ZConnection, ZDataset, fphttpclient, fpjson, jsonparser,
  opensslsockets, DB;

type

  { TfrmCadastroCliente }

  TfrmCadastroCliente = class(TForm) 
    btnBuscaCEP: TButton;
    btnCadastrar: TButton;
    cmbStado: TComboBox;
    DataSource1: TDataSource;
    edtnome: TEdit;
    edtRua: TEdit;
    edtnumero: TEdit;
    edtBairro: TEdit;
    edtcomplemento: TEdit;
    edtCidade: TEdit;
    edtEstado: TEdit;
    lblCPF: TLabel;
    lblTelefone: TLabel;
    lblCEP: TLabel;
    lblNome: TLabel;
    grpGenero: TRadioGroup;
    lblRua: TLabel;
    lblBairro: TLabel;
    lblNumero: TLabel;
    lblComplemento: TLabel;
    lblCidade: TLabel;
    lblEstado: TLabel;
    edtCPF: TMaskEdit;
    edtTelefone: TMaskEdit;
    edtCEP: TMaskEdit;
    ZConnection1: TZConnection;
    ZQuery1: TZQuery;
    procedure btnBuscaCEPClick(Sender: TObject);
    procedure btnCadastrarClick(Sender: TObject);
    procedure edtCEPChange(Sender: TObject);
    procedure edtCPFExit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
   function LimparCEP(const Texto: string): string;
   function ValidarCPF(const CPF: string): Boolean; // Validação matemática do CPF
    procedure CriarTabelaCliente;
    procedure TestarInsercao;
    procedure DebugCPFsNoBanco; // Método para debug 
  public

  end;

var
  frmCadastroCliente: TfrmCadastroCliente;

implementation

{$R *.lfm}

function TfrmCadastroCliente.LimparCEP(const Texto: string): string;

var
  i: Integer;
begin
  Result := '';
  for i := 1 to Length(Texto) do
    if Texto[i] in ['0'..'9'] then
      Result := Result + Texto[i];
end;

function TfrmCadastroCliente.ValidarCPF(const CPF: string): Boolean;
var
  i, soma, resto: Integer;
  cpfLimpo: string;
begin
  Result := False;
  
  // Remove formatação
  cpfLimpo := StringReplace(CPF, '.', '', [rfReplaceAll]);
  cpfLimpo := StringReplace(cpfLimpo, '-', '', [rfReplaceAll]);
  cpfLimpo := StringReplace(cpfLimpo, ' ', '', [rfReplaceAll]);
  
  // Verifica se tem 11 dígitos
  if Length(cpfLimpo) <> 11 then Exit;
  
  // Verifica se todos os dígitos são iguais (ex: 111.111.111-11)
  if (cpfLimpo = '00000000000') or (cpfLimpo = '11111111111') or
     (cpfLimpo = '22222222222') or (cpfLimpo = '33333333333') or
     (cpfLimpo = '44444444444') or (cpfLimpo = '55555555555') or
     (cpfLimpo = '66666666666') or (cpfLimpo = '77777777777') or
     (cpfLimpo = '88888888888') or (cpfLimpo = '99999999999') then Exit;
  
  // Validação do primeiro dígito verificador
  soma := 0;
  for i := 1 to 9 do
    soma := soma + (StrToInt(cpfLimpo[i]) * (11 - i));
  
  resto := soma mod 11;
  if resto < 2 then resto := 0
  else resto := 11 - resto;
  
  if resto <> StrToInt(cpfLimpo[10]) then Exit;
  
  // Validação do segundo dígito verificador
  soma := 0;
  for i := 1 to 10 do
    soma := soma + (StrToInt(cpfLimpo[i]) * (12 - i));
  
  resto := soma mod 11;
  if resto < 2 then resto := 0
  else resto := 11 - resto;
  
  if resto <> StrToInt(cpfLimpo[11]) then Exit;
  
  Result := True;
end;

procedure TfrmCadastroCliente.CriarTabelaCliente;
begin
  try
    ZQuery1.Connection := ZConnection1;
    ZQuery1.SQL.Text :=
      'CREATE TABLE IF NOT EXISTS cliente (' +
      'id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
      'nome TEXT NOT NULL, ' +
      'cpf TEXT NOT NULL, ' +
      'telefone TEXT, ' +
      'cep TEXT, ' +
      'rua TEXT, ' +
      'numero TEXT, ' +
      'bairro TEXT, ' +
      'complemento TEXT, ' +
      'cidade TEXT, ' +
      'estado TEXT, ' +
      'genero TEXT NOT NULL)';
    ZQuery1.ExecSQL;
  except
    on E: Exception do
    begin
      ShowMessage('Erro ao criar tabela: ' + E.Message);
      raise;
    end;
  end;
end;



{ TfrmCadastroCliente }

procedure TfrmCadastroCliente.edtCEPChange(Sender: TObject);
begin

end;

procedure TfrmCadastroCliente.edtCPFExit(Sender: TObject);
var
  CPF, CPFLimpo: string;
  ZQueryCheck: TZQuery; 
begin
  CPF := Trim(edtCPF.Text);
  
  // Se o campo estiver vazio, não faz validação
  if CPF = '' then Exit;
  
  // Validação matemática do CPF
  if not ValidarCPF(CPF) then
  begin
    ShowMessage('CPF inválido! Verifique os dígitos digitados.');
    edtCPF.SetFocus;
    Exit;
  end;
  
  // Remove formatação para consulta no banco
  CPFLimpo := StringReplace(CPF, '.', '', [rfReplaceAll]);
  CPFLimpo := StringReplace(CPFLimpo, '-', '', [rfReplaceAll]);
  CPFLimpo := StringReplace(CPFLimpo, ' ', '', [rfReplaceAll]);

  // Debug: Mostrar o CPF que será consultado
  ShowMessage('Consultando CPF: [' + CPFLimpo + ']');
  
  // Debug: Mostrar o que tem no banco
  DebugCPFsNoBanco;

  // Verifica se CPF já está cadastrado
  ZQueryCheck := TZQuery.Create(nil);
  try
    ZQueryCheck.Connection := ZConnection1;
    
    // Consulta tanto o CPF formatado quanto o limpo
    ZQueryCheck.SQL.Text := 'SELECT COUNT(*) as total FROM cliente WHERE cpf = :cpf OR cpf = :cpf_formatado';
    ZQueryCheck.ParamByName('cpf').AsString := CPFLimpo;
    ZQueryCheck.ParamByName('cpf_formatado').AsString := CPF;
    ZQueryCheck.Open;

    if ZQueryCheck.FieldByName('total').AsInteger > 0 then
    begin
      ShowMessage('CPF já cadastrado no sistema!');
      edtCPF.SetFocus;
      edtCPF.SelectAll; // Seleciona todo o texto para facilitar correção
      Exit;
    end;
    
    ZQueryCheck.Close;

  except
    on E: Exception do
    begin
      ShowMessage('Erro ao verificar CPF: ' + E.Message);
    end;
  end;
  ZQueryCheck.Free;
end;

procedure TfrmCadastroCliente.FormCreate(Sender: TObject);
begin
  try
    // Configurar conexão com SQLite
    ZConnection1.Database := 'clientes.db';
    ZConnection1.Protocol := 'sqlite';
    ZConnection1.LibraryLocation := ''; 
    
    // Manter auto-commit como true para SQLite
    ZConnection1.AutoCommit := True;
    
    // Conectar ao banco
    ZConnection1.Connected := True;

    // Criar a tabela caso não exista
    CriarTabelaCliente;
    
  except
    on E: Exception do
    begin
      ShowMessage('Erro ao conectar com o banco de dados: ' + E.Message);
    end;
  end;
end;



procedure TfrmCadastroCliente.btnBuscaCEPClick(Sender: TObject);
var
  HttpClient: TFPHttpClient;
  Response: string;
  JsonData: TJSONData;
  CEP: string;
begin
  CEP := LimparCEP(edtCEP.Text);
  if Length(CEP) <> 8 then
  begin
    ShowMessage('CEP inválido. Digite um CEP com 8 dígitos.');
    Exit;
  end;

  HttpClient := TFPHttpClient.Create(nil);
  try
    Response := HttpClient.Get('https://viacep.com.br/ws/' + CEP + '/json/');
    JsonData := GetJSON(Response);

    if JsonData.FindPath('erro') <> nil then
    begin
      ShowMessage('CEP não encontrado.');
    end
    else
    begin
      edtRua.Text         := JsonData.FindPath('logradouro').AsString;
      edtBairro.Text      := JsonData.FindPath('bairro').AsString;
      edtCidade.Text      := JsonData.FindPath('localidade').AsString;
      edtEstado.Text      := JsonData.FindPath('uf').AsString;

    end;

    JsonData.Free;
  except
    on E: Exception do
      ShowMessage('Erro ao buscar CEP: ' + E.Message);
  end;
  HttpClient.Free;
end;

procedure TfrmCadastroCliente.btnCadastrarClick(Sender: TObject);
var
  GeneroSelecionado: string;
  CPFLimpo: string;
begin
  // Validação básica dos campos obrigatórios
  if Trim(edtnome.Text) = '' then
  begin
    ShowMessage('O campo Nome é obrigatório!');
    edtnome.SetFocus;
    Exit;
  end;

  if Trim(edtCPF.Text) = '' then
  begin
    ShowMessage('O campo CPF é obrigatório!');
    edtCPF.SetFocus;
    Exit;
  end;

  // Verificar se um gênero foi selecionado
  if grpGenero.ItemIndex = -1 then
  begin
    ShowMessage('Selecione um gênero!');
    grpGenero.SetFocus;
    Exit;
  end;

  GeneroSelecionado := grpGenero.Items[grpGenero.ItemIndex];
  
  // Limpar CPF para salvar no banco (sempre sem formatação)
  CPFLimpo := StringReplace(edtCPF.Text, '.', '', [rfReplaceAll]);
  CPFLimpo := StringReplace(CPFLimpo, '-', '', [rfReplaceAll]);
  CPFLimpo := StringReplace(CPFLimpo, ' ', '', [rfReplaceAll]);

  try
    ZQuery1.SQL.Text :=
      'INSERT INTO cliente (nome, cpf, telefone, cep, rua, numero, bairro, complemento, cidade, estado, genero) ' +
      'VALUES (:nome, :cpf, :telefone, :cep, :rua, :numero, :bairro, :complemento, :cidade, :estado, :genero)';

    ZQuery1.ParamByName('nome').AsString   := Trim(edtnome.Text);
    ZQuery1.ParamByName('cpf').AsString    := CPFLimpo; // Salva sempre sem formatação
    ZQuery1.ParamByName('telefone').AsString := edtTelefone.Text;
    ZQuery1.ParamByName('cep').AsString    := edtCEP.Text;
    ZQuery1.ParamByName('rua').AsString    := Trim(edtRua.Text);
    ZQuery1.ParamByName('numero').AsString := Trim(edtnumero.Text);
    ZQuery1.ParamByName('bairro').AsString := Trim(edtBairro.Text);
    ZQuery1.ParamByName('complemento').AsString := Trim(edtcomplemento.Text);
    ZQuery1.ParamByName('cidade').AsString := Trim(edtCidade.Text);
    ZQuery1.ParamByName('estado').AsString := Trim(edtEstado.Text);
    ZQuery1.ParamByName('genero').AsString := GeneroSelecionado;

    ZQuery1.ExecSQL;

    ShowMessage('Cliente salvo com sucesso!');
    
    // Verificar se realmente foi salvo
    TestarInsercao;
    
    // Limpar os campos após salvar
    edtnome.Clear;
    edtCPF.Clear;
    edtTelefone.Clear;
    edtCEP.Clear;
    edtRua.Clear;
    edtnumero.Clear;
    edtBairro.Clear;
    edtcomplemento.Clear;
    edtCidade.Clear;
    edtEstado.Clear;
    grpGenero.ItemIndex := -1;
    
    edtnome.SetFocus;
    
  except
    on E: Exception do
    begin
      ShowMessage('Erro ao salvar cliente: ' + E.Message);
    end;
  end;
end;

procedure TfrmCadastroCliente.TestarInsercao;
var
  ZQueryTest: TZQuery;
  Count: Integer;
begin
  ZQueryTest := TZQuery.Create(nil);
  try
    ZQueryTest.Connection := ZConnection1;
    
    // Contar quantos registros existem
    ZQueryTest.SQL.Text := 'SELECT COUNT(*) as total FROM cliente';
    ZQueryTest.Open;
    Count := ZQueryTest.FieldByName('total').AsInteger;
    ZQueryTest.Close;
    
    ShowMessage('Total de clientes no banco: ' + IntToStr(Count));
    
    // Mostrar todos os registros
    if Count > 0 then
    begin
      ZQueryTest.SQL.Text := 'SELECT * FROM cliente ORDER BY id DESC LIMIT 5';
      ZQueryTest.Open;
      
      while not ZQueryTest.EOF do
      begin
        ShowMessage('Cliente ID: ' + ZQueryTest.FieldByName('id').AsString + 
                   ', Nome: ' + ZQueryTest.FieldByName('nome').AsString +
                   ', CPF: ' + ZQueryTest.FieldByName('cpf').AsString);
        ZQueryTest.Next;
      end;
      ZQueryTest.Close;
    end;
    
  finally
    ZQueryTest.Free;
  end;
end;

procedure TfrmCadastroCliente.DebugCPFsNoBanco;
var
  ZQueryDebug: TZQuery;
begin
  ZQueryDebug := TZQuery.Create(nil);
  try
    ZQueryDebug.Connection := ZConnection1;
    ZQueryDebug.SQL.Text := 'SELECT id, nome, cpf FROM cliente';
    ZQueryDebug.Open;
    
    if ZQueryDebug.RecordCount = 0 then
    begin
      ShowMessage('Nenhum registro encontrado no banco.');
    end
    else
    begin
      while not ZQueryDebug.EOF do
      begin
        ShowMessage('ID: ' + ZQueryDebug.FieldByName('id').AsString + 
                   ', Nome: ' + ZQueryDebug.FieldByName('nome').AsString +
                   ', CPF: [' + ZQueryDebug.FieldByName('cpf').AsString + ']');
        ZQueryDebug.Next;
      end;
    end;
    
    ZQueryDebug.Close;
  finally
    ZQueryDebug.Free;
  end;
end;


end.
