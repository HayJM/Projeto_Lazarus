//teste te comite github 
// como assim não era pra ta assim
// agora temos uma comucação via terminal
unit pesquisa;


{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, MaskEdit;

type

  { Tfrmpesquisa }

  Tfrmpesquisa = class(TForm)
    btnpesquisa: TButton;
    edtcpf: TMaskEdit;
    lblcpf: TLabel;
    srlpesquisa: TScrollBox;
    procedure btnpesquisaClick(Sender: TObject);
  private

  public

  end;

var
  frmpesquisa: Tfrmpesquisa;

implementation
uses
  principal;

{$R *.lfm}

{ Tfrmpesquisa }


procedure Tfrmpesquisa.btnpesquisaClick(Sender: TObject);
var
  i: Integer;
  cpfBuscado: string;
  controle: TControl;
  lbl: TLabel;
  achou: Boolean;
  lblResultado: TLabel;
begin
  // Limpa resultados anteriores
  while srlpesquisa.ControlCount > 0 do
    srlpesquisa.Controls[0].Free;

  cpfBuscado := Trim(edtcpf.Text);
  achou := False;

  // Procura nos Labels do srldados
  for i := 0 to frmprincipal.srldados.ControlCount - 1 do
  begin
    controle := frmprincipal.srldados.Controls[i];
    if (controle is TLabel) then
    begin
      lbl := TLabel(controle);
      if Pos(cpfBuscado, lbl.Caption) > 0 then
      begin
        // Mostra o label encontrado em srlpesquisa 
        
        lblResultado := TLabel.Create(srlpesquisa);
        lblResultado.Parent := srlpesquisa;
        lblResultado.Top := 8;
        lblResultado.Left := 8;
        lblResultado.Caption := lbl.Caption;
        lblResultado.WordWrap := True;
        lblResultado.AutoSize := True;
        achou := True;
        Break;
      end;
    end;
  end;

  if not achou then
    ShowMessage('CPF não encontrado.');
end;


end.

