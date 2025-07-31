unit principal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  MaskEdit, Menus, LCLType;

type

  { Tfrmprincipal }

  Tfrmprincipal = class(TForm)
    btncadastrar: TButton;
    edtcpf: TMaskEdit;
    edtnome: TEdit;
    lblnome: TLabel;
    lbltelefone: TLabel;
    lblcep: TLabel;
    edtfone: TMaskEdit;
    lblcpf: TLabel;
    edtcep: TMaskEdit;
    MainMenu1: TMainMenu;
    mniProduto: TMenuItem;
    mniPsequisa: TMenuItem;
    mniVenda: TMenuItem;
    qrggenero: TRadioGroup;
    srldados: TScrollBox;
    slrdados: TScrollBox;
    procedure btncadastrarClick(Sender: TObject);
    procedure edtcepExit(Sender: TObject);
    procedure edtcpfChange(Sender: TObject);
    procedure edtfoneExit(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure mniProdutoClick(Sender: TObject);
    procedure mniPsequisaClick(Sender: TObject);
    procedure mniVendaClick(Sender: TObject);
    procedure mnmprincipalChange(Sender: TObject; Source: TMenuItem;
      Rebuild: Boolean);
    procedure mnmprincipalDrawItem(Sender: TObject; ACanvas: TCanvas;
      ARect: TRect; AState: TOwnerDrawState);
    procedure mnmprincipalMeasureItem(Sender: TObject; ACanvas: TCanvas;
      var AWidth, AHeight: Integer);
  private
    linhaAtual: Integer;
  public

  end;

var
  frmprincipal: Tfrmprincipal;

implementation
  uses
    pesquisa, produto, vendas;

{$R *.lfm}

{ Tfrmprincipal }
function OnlyNumbers(const s: string): string;
var
  i: Integer;
begin
  Result := '';
  for i := 1 to Length(s) do
    if s[i] in ['0'..'9'] then
      Result := Result + s[i];
end;

procedure Tfrmprincipal.edtcepExit(Sender: TObject);
begin

end;

procedure Tfrmprincipal.edtcpfChange(Sender: TObject);
begin

end;

procedure Tfrmprincipal.btncadastrarClick(Sender: TObject);
var
  nome, telefone, cep, cpf, genero: string;
  lblCadastro: TLabel;
begin
  nome := Trim(edtnome.Text);
  cpf:= Trim(edtcpf.Text);
  telefone := Trim(edtfone.Text);
  cep:= Trim(edtcep.Text);

  case qrggenero.ItemIndex of
    0: genero := 'Masculino';
    1: genero := 'Feminino';
    2: genero := 'Perdido';
  else
    genero := 'Não informado';
  end;

  // Verifica se os campos foram preenchidos
  if (nome = '') or (cpf='') or (telefone = '') or (cep='') then
  begin
    ShowMessage('Preencha todos os campos.');
    Exit;
  end;

  // Cria um novo Label e adiciona na ScrollBox
  lblCadastro := TLabel.Create(srldados);
  lblCadastro.Parent := srldados;
  lblCadastro.Top := linhaAtual;
  lblCadastro.Left := 8;
  lblCadastro.Caption := Format(
  'Nome: %s' + LineEnding +
  'Gênero: %s' + LineEnding +
  'CPF: %s' + LineEnding +
  'Telefone: %s' + LineEnding +
  'CEP: %s',
  [nome, genero, cpf, telefone, cep]);
  lblCadastro.WordWrap := True;
  lblCadastro.AutoSize := False;
  lblCadastro.Width := srldados.Width - 16;


  // Atualiza a posição para o próximo cadastro
  linhaAtual := linhaAtual + lblCadastro.Height + 8;

  // Limpa os campos (mas não a ScrollBox)
  edtnome.Clear;
  edtfone.Clear;
  edtcpf.Clear;
  edtcep.Clear;
  qrggenero.ItemIndex := -1;

  // Coloca foco no primeiro campo
  edtnome.SetFocus;
end;

procedure Tfrmprincipal.edtfoneExit(Sender: TObject);
begin

end;

procedure Tfrmprincipal.FormShow(Sender: TObject);
begin

end;

procedure Tfrmprincipal.mniProdutoClick(Sender: TObject);
begin
  frmproduto.Show;
end;

procedure Tfrmprincipal.mniPsequisaClick(Sender: TObject);
begin
  frmpesquisa.Show;
end;

procedure Tfrmprincipal.mniVendaClick(Sender: TObject);
begin
  frmVendas.Show;
end;

procedure Tfrmprincipal.mnmprincipalChange(Sender: TObject; Source: TMenuItem;
  Rebuild: Boolean);
begin

end;

procedure Tfrmprincipal.mnmprincipalDrawItem(Sender: TObject; ACanvas: TCanvas;
  ARect: TRect; AState: TOwnerDrawState);
begin

end;

procedure Tfrmprincipal.mnmprincipalMeasureItem(Sender: TObject;
  ACanvas: TCanvas; var AWidth, AHeight: Integer);
begin

end;

end.

