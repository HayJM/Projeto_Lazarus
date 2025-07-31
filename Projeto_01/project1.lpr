program project1;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, principal, pesquisa, vendas, produto
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(Tfrmprincipal, frmprincipal);
  Application.CreateForm(Tfrmpesquisa, frmpesquisa);
  Application.CreateForm(TfrmVendas, frmVendas);
  Application.CreateForm(Tfrmproduto, frmproduto);
  Application.Run;
end.

