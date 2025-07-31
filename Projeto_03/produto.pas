unit produto;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, ComCtrls, DBGrids,
  StdCtrls, ExtCtrls;

type

  { TfrmProduto }

  TfrmProduto = class(TForm)
    DBGrid1: TDBGrid;
    Label1: TLabel;
    bar: TStatusBar;
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  frmProduto: TfrmProduto;

implementation
uses
  principal;

{$R *.lfm}

{ TfrmProduto }

procedure TfrmProduto.FormCreate(Sender: TObject);
begin
     bar.Panels[2].text:= 'Hoje é '+ FormatDateTime('dddddd',date);
end;

end.

