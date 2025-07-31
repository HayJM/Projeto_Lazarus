unit produto;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { Tfrmproduto }

  Tfrmproduto = class(TForm)
    btnCadastrar: TButton;
    edtProduto: TEdit;
    edtVCompra: TEdit;
    edtAjuste: TEdit;
    edtMarca: TEdit;
    edtcodigo: TEdit;
    lblVvenda: TLabel;
    lblValorCompra: TLabel;
    lblAjuste: TLabel;
    lbldDescricao: TLabel;
    lblNomeProd: TLabel;
    lblMarca: TLabel;
    lblCodigoProd: TLabel;
    memDescricao: TMemo;
    srlDadosProduto: TScrollBox;
    procedure btnCadastrarClick(Sender: TObject);
    procedure edtAjusteExit(Sender: TObject);
  private
    Vvenda: Double;
    linhaAtual: Integer;
  public

  end;

var
  frmproduto: Tfrmproduto;

implementation

{$R *.lfm}

{ Tfrmproduto }

procedure Tfrmproduto.btnCadastrarClick(Sender: TObject);
var
  produto,marca, codigo, Vcompra, venda, Descricao: string;
  lblCadastro: TLabel;
begin
  produto := Trim(edtProduto.Text);
  marca:= Trim(edtMarca.Text);
  codigo:= Trim(edtcodigo.Text);
  descricao := Trim(memDescricao.Text);
  Vcompra:= Trim(edtVCompra.Text);
  venda:= FloatTostr(Vvenda);
  // Verifica se os campos foram preenchidos
  if (produto = '') or (marca='') or (codigo='') or (descricao = '') or (Vcompra='') or (edtAjuste.Text='')  then
  begin
    ShowMessage('Preencha todos os campos.');
    Exit;
  end;

  // Cria um novo Label e adiciona na ScrollBox
  lblCadastro := TLabel.Create(srlDadosProduto);
  lblCadastro.Parent := srlDadosProduto;
  lblCadastro.Top := linhaAtual;
  lblCadastro.Left := 16;
  lblCadastro.Caption := Format(
  'Código: %s' + LineEnding +
  'Produto: %s |'+ 'Marca: %s ' + LineEnding +
  'Valor de Compra: %s |' +' Valor de Venda: %s |'  + LineEnding +
  'Descrição do Produto:' + LineEnding +
  ' %s ',
  [codigo, produto, marca, Vcompra, venda, descricao]);
  lblCadastro.WordWrap := True;
  lblCadastro.AutoSize := False;
  lblCadastro.Width := srlDadosProduto.Width - 16;


  // Atualiza a posição para o próximo cadastro
  linhaAtual := linhaAtual + lblCadastro.Height + 8;

  // Limpa os campos (mas não a ScrollBox)
  edtProduto.Clear;
  edtMarca.Clear;
  edtcodigo.Clear;
  memDescricao.Clear;
  edtVCompra.Clear;
  edtAjuste.Clear;
  lblVvenda.Caption:= 'Valor de venda';
  // Coloca foco no primeiro campo
  edtProduto.SetFocus;
end;

procedure Tfrmproduto.edtAjusteExit(Sender: TObject);
var
  Vcompra, Pajuste: Double;

  begin
    Vcompra:= 0.0;
    Vvenda:= 0.0;

    Vcompra:= StrToFloat(edtVcompra.Text);
    Pajuste:= StrToFloat(edtAjuste.Text)/100;
    Vvenda:= Vcompra + (Vcompra * Pajuste);

  lblVvenda.Caption:= ('Valor de Venda: ' + FloatToStr(Vvenda));

end;

end.

