UNIT Unit1;

{$mode objfpc}{$H+}

INTERFACE

USES
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, ComCtrls,strutils,
  StdCtrls, ExtDlgs, ExtCtrls, SynEdit, SynHighlighterPas, process,LazFileUtils;

TYPE

  { TForm1 }

  TForm1 = CLASS(TForm)
    Button1: TButton;
    CalculatorDialog1: TCalculatorDialog;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    FindDialog1: TFindDialog;
    Memo1: TMemo;
    Build: TMenuItem;
    MenuItem11: TMenuItem;
    Target: TMenuItem;
    Compile: TMenuItem;
    Make: TMenuItem;
    Compile_popup: TPopupMenu;
    Preferences_Box: TGroupBox;
    Close_file: TMenuItem;
    Calculator_button: TMenuItem;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    Cut: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    Preferences: TMenuItem;
    open_file: TMenuItem;
    edit_popup: TPopupMenu;
    tool_popup: TPopupMenu;
    Save_file: TMenuItem;
    saveas_file: TMenuItem;
    OpenDialog1: TOpenDialog;
    File_popup: TPopupMenu;
    SaveDialog1: TSaveDialog;
    Search: TMenuItem;
    Replace: TMenuItem;
    Search_popup: TPopupMenu;
    ReplaceDialog1: TReplaceDialog;
    SynEdit1: TSynEdit;
    SynFreePascalSyn1: TSynFreePascalSyn;
    ToolBar1: TToolBar;
    ToolBar2: TToolBar;
    File_button: TToolButton;
    Help_button: TToolButton;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    ToolButton13: TToolButton;
    ToolButton14: TToolButton;
    ToolButton15: TToolButton;
    ToolButton16: TToolButton;
    Edit_button: TToolButton;
    Search_button: TToolButton;
    Run_button: TToolButton;
    Compile_button: TToolButton;
    Debug_button: TToolButton;
    Tools_button: TToolButton;
    Options_Button: TToolButton;
    Window_button: TToolButton;
    PROCEDURE Button1Click(Sender: TObject);
    PROCEDURE Calculator_buttonClick(Sender: TObject);
    PROCEDURE CheckBox1Change(Sender: TObject);
    PROCEDURE FormCreate(Sender: TObject);
    PROCEDURE FormResize(Sender: TObject);
    PROCEDURE Close_fileClick(Sender: TObject);
    PROCEDURE PreferencesClick(Sender: TObject);
    PROCEDURE CompileClick(Sender: TObject);
    PROCEDURE open_fileClick(Sender: TObject);
    procedure Run_buttonClick(Sender: TObject);
    PROCEDURE saveas_fileClick(Sender: TObject);
    PROCEDURE Save_fileClick(Sender: TObject);
    procedure SearchClick(Sender: TObject);
    procedure FindDialog1Find(Sender: TObject);




  private
    filename: string;
    filechanged : int64;
      fPos:integer;
  found:boolean;
  public

  END;

VAR
  Form1: TForm1;

IMPLEMENTATION

{$R *.lfm}

{ TForm1 }

PROCEDURE TForm1.FormCreate(Sender: TObject);
BEGIN
  synedit1.Width := form1.Width - 2 * synedit1.left;
  toolbar1.ButtonWidth := form1.Width DIV 10;
  toolbar2.ButtonWidth := form1.Width DIV 6;
  filename := '';
  Preferences_Box.Left := toolbar1.ButtonWidth;
  Preferences_Box.top := 21;
  Preferences_Box.Visible := False;
  memo1.width := form1.width;
  synedit1.Height:=form1.Height-(toolbar1.Height+toolbar2.Height)-memo1.Height;
END;


PROCEDURE TForm1.Calculator_buttonClick(Sender: TObject);
BEGIN
  calculatordialog1.Execute;
END;



PROCEDURE TForm1.Button1Click(Sender: TObject);
BEGIN
  Preferences_Box.Visible := False;
END;

PROCEDURE TForm1.CheckBox1Change(Sender: TObject);
BEGIN
  // toggle syntax highlighting
  synFreePascalSyn1.Enabled := checkbox1.Checked;
END;

PROCEDURE TForm1.FormResize(Sender: TObject);
BEGIN
  synedit1.Width := form1.Width - 2 * synedit1.left;
  toolbar1.ButtonWidth := form1.Width DIV 10;
  toolbar2.ButtonWidth := form1.Width DIV 6;
  synedit1.Height:=form1.Height-(toolbar1.Height+toolbar2.Height)-memo1.Height;
  memo1.width := form1.width;
END;

PROCEDURE TForm1.Close_fileClick(Sender: TObject);
BEGIN
  if (filechanged = synedit1.ChangeStamp) then
  begin
       synedit1.Lines.Clear;
       filename := '';
       form1.Caption := 'Free Pascal IDE';
  end
  else
     ShowMessage('file was changed but not saved');
END;



PROCEDURE TForm1.PreferencesClick(Sender: TObject);
BEGIN
  Preferences_Box.Visible := True;
END;

PROCEDURE TForm1.CompileClick(Sender: TObject);
CONST
  BUF_SIZE = 2048; // Buffer size for reading the output in chunks

VAR
  AProcess: TProcess;
  OutputStream: TStream;
  BytesRead, leng: longint;
  Buffer: ARRAY[1..BUF_SIZE] OF byte;
  executable : string;

BEGIN
  leng := length(filename);
  executable := LeftStr(filename,leng-3) + 'exe';
  IF filename <> '' THEN
  BEGIN
    if FileExists(executable) then
      DeleteFile(executable);

    synedit1.Lines.SaveToFile(filename);
    filechanged := synedit1.ChangeStamp;;
    AProcess := TProcess.Create(nil);
    memo1.Clear;
    AProcess.Executable := 'fpc';
    AProcess.Parameters.Add('-O1');
    AProcess.Parameters.Add(filename);
    AProcess.Options := [poUsePipes,poNoConsole];
    AProcess.Execute;
    OutputStream := TMemoryStream.Create;

    REPEAT
      BytesRead := AProcess.Output.Read(Buffer, BUF_SIZE);
      OutputStream.Write(Buffer, BytesRead)
    UNTIL BytesRead = 0;
    AProcess.Free;
    OutputStream.Position := 0;
    memo1.Lines.LoadFromStream(outputstream);
    OutputStream.Free;
  END
  ELSE
    ShowMessage('File has no name, please use "save as first"');

END;



PROCEDURE TForm1.open_fileClick(Sender: TObject);
BEGIN
  IF OpenDialog1.Execute THEN
  BEGIN
    filename := OpenDialog1.Filename;
    synedit1.Lines.LoadFromFile(filename);
  END;
  form1.Caption := 'Free Pascal IDE' + ' ('+filename+')';
  filechanged := synedit1.ChangeStamp;
END;

procedure TForm1.Run_buttonClick(Sender: TObject);
var
  Process: TProcess;
  I, leng: Integer;
  executable : String;
begin
  leng := length(filename);
  executable := LeftStr(filename,leng-3) + 'exe';
  if FileExists(executable) then
  Begin
  Process := TProcess.Create(nil);
  try
    Process.InheritHandles := False;
    Process.Options := [];
    Process.ShowWindow := swoShow;

    for I := 1 to GetEnvironmentVariableCount do
      Process.Environment.Add(GetEnvironmentString(I));

    Process.Executable := executable;
    Process.Execute;
  finally
    Process.Free;
  end;
  end
  else ShowMessage('Executable doesn''t exist. Must compile succesfully first');

end;

PROCEDURE TForm1.saveas_fileClick(Sender: TObject);
BEGIN
  IF SaveDialog1.Execute THEN
  BEGIN
    filename := saveDialog1.Filename;
    synedit1.Lines.SaveToFile(filename);
  END;
  form1.Caption := 'Free Pascal IDE' + ' ('+filename+')';
  filechanged := synedit1.ChangeStamp;
END;

PROCEDURE TForm1.Save_fileClick(Sender: TObject);

BEGIN
  IF filename <> '' THEN
  begin
    synedit1.Lines.SaveToFile(filename);
    filechanged := synedit1.ChangeStamp;
  end
  ELSE
    ShowMessage('File has no name, please use "save as"');
END;



END.

