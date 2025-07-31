unit Principal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus;

type

  { TfrmPrincipal }

  TfrmPrincipal = class(TForm)
    MainMenu1: TMainMenu;
    menCadastro: TMenuItem;
    menCliente: TMenuItem;
    menProduto: TMenuItem;
    menPesquisa: TMenuItem;
    menPsCliente: TMenuItem;
    menPsProduto: TMenuItem;
    menNotaFis: TMenuItem;
    menVenda: TMenuItem;
    procedure menClienteClick(Sender: TObject);
  private

  public

  end;

var
  frmPrincipal: TfrmPrincipal;

implementation
uses CadastroCliente;

{$R *.lfm}

{ TfrmPrincipal }

procedure TfrmPrincipal.menClienteClick(Sender: TObject);
begin
  frmCadastroCliente.Show;
end;

end.

