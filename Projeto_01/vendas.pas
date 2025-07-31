unit vendas;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, MaskEdit, StrUtils;

type

  { TfrmVendas }

  TfrmVendas = class(TForm)
    btncpf: TButton;
    btnBusca: TButton;
    btnConcluir: TButton;
    btnAdd: TButton;
    edtCodigoProd: TEdit;
    edtcpf: TMaskEdit;
    lblValorDaVenda: TLabel;
    lblCPF: TLabel;
    lblCodProd: TLabel;
    lblNomeCliente: TLabel;
    srlProduto: TScrollBox;
    srlProdutosCompr: TScrollBox;
    //procedure btnpesquisaClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnBuscaClick(Sender: TObject);
    procedure btncpfClick(Sender: TObject);
  private

  public

  end;

var
  frmVendas: TfrmVendas;

implementation
uses
  principal, produto;

{$R *.lfm}

{ TfrmVendas }

procedure TfrmVendas.btncpfClick(Sender: TObject);
var
  i, j: Integer;
  cpfBuscado, linha, nome, telefone: string;
  controle: TControl;
  lbl: TLabel;
  achou: Boolean;
  dados: TStringList;
begin
  lblNomeCliente.Caption := '';      // limpa antes
  cpfBuscado := Trim(edtcpf.Text);   // CPF com máscara
  achou := False;

  for i := 0 to frmprincipal.srldados.ControlCount - 1 do
  begin
    controle := frmprincipal.srldados.Controls[i];
    if controle is TLabel then
    begin
      lbl := TLabel(controle);

      // se esse label tem o CPF buscado...
      if Pos(cpfBuscado, lbl.Caption) > 0 then
      begin
        // quebra em linhas
        dados := TStringList.Create;
        try
          dados.Text := lbl.Caption;
          nome := '';
          telefone := '';

          // percorre cada linha procurando “Nome:” e “Telefone:”
          for j := 0 to dados.Count - 1 do
          begin
            linha := dados[j];
            if Pos('Nome:', linha) > 0 then
              nome := Trim(Copy(linha, Length('Nome:') + 1, MaxInt));
            if Pos('Telefone:', linha) > 0 then
              telefone := Trim(Copy(linha, Length('Telefone:') + 1, MaxInt));
          end;

          // só exibe nome e telefone, na mesma linha
          lblNomeCliente.Caption :=
            'Nome: ' + nome + ' | Telefone: ' + telefone;

          achou := True;
        finally
          dados.Free;
        end;
        Break;
      end;
    end;
  end;

  if not achou then
    ShowMessage('CPF não encontrado.');
end;

procedure TfrmVendas.btnBuscaClick(Sender: TObject);
var
  i, j: Integer;
  codigoBuscado, texto, parte, codeValue: string;
  controles: TControl;
  lbl, lblResultado: TLabel;
  achou: Boolean;
  partes: TStringList;
  yOffset: Integer;
begin
  // 1) limpa o ScrollBox
  while srlProduto.ControlCount > 0 do
    srlProduto.Controls[0].Free;

  codigoBuscado := Trim(edtCodigoProd.Text);
  achou := False;
  yOffset := 8;

  partes := TStringList.Create;
  try
    partes.Delimiter := '-';
    partes.StrictDelimiter := True;

    // 2) percorre todos os Labels de produto
    for i := 0 to frmproduto.srldadosProduto.ControlCount - 1 do
    begin
      controles := frmproduto.srldadosProduto.Controls[i];
      if not (controles is TLabel) then Continue;
      lbl := TLabel(controles);
      texto := lbl.Caption;

      // 3) quebra em pedaços: ["Nome: X", "Código: Y", "Valor de Compra: Z", ...]
      partes.DelimitedText := StringReplace(texto, ' - ', '-', [rfReplaceAll]);
      codeValue := '';
      for j := 0 to partes.Count - 1 do
      begin
        parte := partes[j];
        if StartsText('Código:', parte) then
        begin
          codeValue := Trim(Copy(parte, Length('Código:') + 1, MaxInt));
          Break;
        end;
      end;

      // 4) só continua se for exatamente o código buscado
      if codeValue <> codigoBuscado then
        Continue;

      // 5) achou o produto certo! agora ocultamos "Valor de Compra"
      //    reconstruindo só as partes que queremos:
      texto := '';
      for j := 0 to partes.Count - 1 do
      begin
        parte := partes[j];
        if StartsText('Valor de Compra:', parte) then
          Continue;  // pula essa parte
        if texto <> '' then
          texto := texto + ' | ';
        texto := texto + Trim(parte);
      end;

      // 6) cria o label de resultado
      lblResultado := TLabel.Create(srlProduto);
      lblResultado.Parent   := srlProduto;
      lblResultado.Top      := yOffset;
      lblResultado.Left     := 8;
      lblResultado.Caption  := texto;
      lblResultado.WordWrap := True;
      lblResultado.AutoSize := True;

      Inc(yOffset, lblResultado.Height + 4);
      achou := True;
      Break;  // se quiser múltiplos resultados, remova este Break
    end;
  finally
    partes.Free;
  end;

  if not achou then
    ShowMessage('Código do produto não encontrado.')
  else
  begin
    edtCodigoProd.Clear;
    edtCodigoProd.SetFocus;
  end;
end;


procedure TfrmVendas.btnAddClick(Sender: TObject);
var
  totalVenda, valorItem: Double;
  controle: TControl;
  lbl, lblCopia: TLabel;
  vendaStr: string;
  posInicio, posFim: Integer;
  i: Integer;
begin
  // Verifica se há produto selecionado
  if srlProduto.ControlCount = 0 then
  begin
    ShowMessage('Nenhum produto selecionado.');
    Exit;
  end;
  
  // Copia o conteúdo do srlProduto para srlProdutosCompr
  for i := 0 to srlProduto.ControlCount - 1 do
  begin
    if srlProduto.Controls[i] is TLabel then
    begin
      lbl := TLabel(srlProduto.Controls[i]);
      
      // Cria uma cópia do label
      lblCopia := TLabel.Create(srlProdutosCompr);
      lblCopia.Parent := srlProdutosCompr;
      lblCopia.Caption := lbl.Caption;
      lblCopia.WordWrap := True;
      lblCopia.AutoSize := True;
      lblCopia.Top := srlProdutosCompr.ControlCount * 60; // Espaçamento entre itens
      lblCopia.Left := 8;
    end;
  end;
  
  // Limpa o srlProduto após copiar
  while srlProduto.ControlCount > 0 do
    srlProduto.Controls[0].Free;
  
  // Calcula o total da venda
  totalVenda := 0.0;
  for i := 0 to srlProdutosCompr.ControlCount - 1 do
  begin
    controle := srlProdutosCompr.Controls[i];
    if controle is TLabel then
    begin
      lbl := TLabel(controle);
      
      // Procura por "Valor de Venda:" no texto
      posInicio := Pos('Valor de Venda:', lbl.Caption);
      if posInicio > 0 then
      begin
        posInicio := posInicio + Length('Valor de Venda:');
        vendaStr := Copy(lbl.Caption, posInicio, MaxInt);
        
        // Remove espaços e pega até o próximo '|'
        vendaStr := Trim(vendaStr);
        posFim := Pos('|', vendaStr);
        if posFim > 0 then
          vendaStr := Copy(vendaStr, 1, posFim - 1)
        else
          vendaStr := vendaStr;
        
        vendaStr := Trim(vendaStr);
        
        // Converte para número e soma
        if TryStrToFloat(vendaStr, valorItem) then
          totalVenda := totalVenda + valorItem;
      end;
    end;
  end;
  
  // Atualiza o label com o valor total
  lblValorDaVenda.Caption := 'Valor Total da Venda: R$ ' + FloatToStrF(totalVenda, ffFixed, 8, 2);
  
  ShowMessage('Produto adicionado ao carrinho.');
end;
end.

