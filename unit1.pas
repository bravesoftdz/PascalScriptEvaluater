unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  uPSComponent;

type

  { TPascalScriptEvalForm }

  TPascalScriptEvalForm = class(TForm)
    BtnCompileAndRun: TButton;
    ScriptText: TMemo;
    ResultText: TMemo;
    PSScript1: TPSScript;
    procedure BtnCompileAndRunClick(Sender: TObject);
    procedure PSScript1Compile(Sender: TPSScript);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  MainForm1: TPascalScriptEvalForm;

implementation

{$R *.lfm}

{ TPascalScriptEvalForm }

procedure MyWriteln(const s: string);
begin
  ShowMessage(s);
end;

procedure TPascalScriptEvalForm.PSScript1Compile(Sender: TPSScript);
begin
     // スクリプトからアクセスできる関数を定義する.
     Sender.AddFunction(@MyWriteln, 'procedure ShowMessage(s: string);');
end;

// https://github.com/remobjects/pascalscript/blob/master/Samples/RemObjects%20SDK%20Client/fMain.pas
procedure TPascalScriptEvalForm.BtnCompileAndRunClick(Sender: TObject);
  procedure OutputMessages;
    var
      l: Longint;
    begin
      for l := 0 to PSScript1.CompilerMessageCount - 1 do
      begin
        ResultText.Lines.Add('Compiler: '+ PSScript1.CompilerErrorToStr(l));
      end;
    end;
  begin
    ResultText.Lines.Clear;
    PSScript1.Script.Assign(ScriptText.Lines);

    ResultText.Lines.Add('Compiling');
    if PSSCript1.Compile then begin
        OutputMessages;
        ResultText.Lines.Add('Compiled succesfully');
        if not PSScript1.Execute then
        begin
             ScriptText.SelStart := PSScript1.ExecErrorPosition;
             ResultText.Lines.Add(PSScript1.ExecErrorToString + ' at ' +
                 Inttostr(PSScript1.ExecErrorProcNo) + '.' +
                 Inttostr(PSScript1.ExecErrorByteCodePosition));
        end else
            ResultText.Lines.Add('Succesfully executed');
    end else begin
        OutputMessages;
        ResultText.Lines.Add('Compiling failed');
    end;
  end;

end.

