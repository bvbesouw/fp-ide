UNIT Unit1;

{$mode objfpc}{$H+}

INTERFACE

USES
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, ComCtrls, strutils,
  StdCtrls, ExtDlgs, ExtCtrls, SynEdit, SynHighlighterPas, process, LazFileUtils;

TYPE
  TConfig_rec = RECORD     //used for configuration file
    version,
    last_file,
    optimization,
    font,
    String_Spare1,
    String_Spare2,
    String_Spare3,
    String_Spare4,
    String_Spare5,
    String_Spare6,
    String_Spare7,
    String_Spare8,
    String_Spare9,
    String_Spare10: string[255];
    openlastfile,
    Boolean_Spare1,
    Boolean_Spare2,
    Boolean_Spare3,
    Boolean_Spare4,
    Boolean_Spare5,
    Boolean_Spare6,
    Boolean_Spare7,
    Boolean_Spare8,
    Boolean_Spare9,
    Boolean_Spare10: boolean;
    Font_size,
    Integer_Spare1,
    Integer_Spare2,
    Integer_Spare3,
    Integer_Spare4,
    Integer_Spare5,
    Integer_Spare6,
    Integer_Spare7,
    Integer_Spare8,
    Integer_Spare9,
    Integer_Spare10: integer;
  END;
  { TForm1 }

  TForm1 = CLASS(TForm)
    MenuItem7: TMenuItem;
    exit_file: TMenuItem;
    File_Quit: TMenuItem;
    Open_last_file: TCheckBox;
    Pref_ok_but: TButton;
    Pref_cancel_button: TButton;
    CalculatorDialog1: TCalculatorDialog;
    FindDialog1: TFindDialog;
    Preferences_Box: TGroupBox;
    Memo1: TMemo;
    Build: TMenuItem;
    MenuItem11: TMenuItem;
    no_optimizations: TRadioButton;
    Level1_optimizations: TRadioButton;
    Level2_optimizations: TRadioButton;
    Level3_optimizations: TRadioButton;
    Level4_optimizations: TRadioButton;
    RadioGroup1: TRadioGroup;
    Target: TMenuItem;
    Compile: TMenuItem;
    Make: TMenuItem;
    Compile_popup: TPopupMenu;
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
    PROCEDURE exit_fileClick(Sender: TObject);
    PROCEDURE File_QuitClick(Sender: TObject);
    PROCEDURE FormCreate(Sender: TObject);
    PROCEDURE FormResize(Sender: TObject);
    PROCEDURE Close_fileClick(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    PROCEDURE PreferencesClick(Sender: TObject);
    PROCEDURE CompileClick(Sender: TObject);
    PROCEDURE open_fileClick(Sender: TObject);
    PROCEDURE Pref_cancel_buttonClick(Sender: TObject);
    PROCEDURE Pref_ok_butClick(Sender: TObject);
    PROCEDURE Run_buttonClick(Sender: TObject);
    PROCEDURE saveas_fileClick(Sender: TObject);
    PROCEDURE Save_fileClick(Sender: TObject);
    PROCEDURE update_config_file;
    PROCEDURE read_config_file;

  private
    filename: string;
    filechanged: int64;
    Config_rec: TConfig_rec;
    ConfigFile: FILE OF TConfig_rec;
  public

  END;

VAR
  Form1: TForm1;

IMPLEMENTATION

{$R *.lfm}

{ TForm1 }
PROCEDURE TForm1.update_config_file;
VAR
  ConfFile: FILE OF TConfig_rec;
BEGIN
  Assignfile(ConfFile, 'fpeide.cfg');
  Rewrite(ConfFile);
  Write(confFile, Config_rec);
  Closefile(Conffile);
END;

PROCEDURE TForm1.read_config_file;
VAR
  ConfFile: FILE OF TConfig_rec;
BEGIN
  IF fileexists('fpeide.cfg') THEN
  BEGIN
    AssignFile(ConfFile, 'fpeide.cfg');
    Reset(ConfFile);
    Read(confFile, Config_rec);
    Closefile(confFile);
    Open_last_file.Checked := Config_rec.openlastfile;
    IF ((Config_rec.last_file <> '') AND (Open_last_file.Checked)) THEN
      IF FileExists(Config_rec.last_file) THEN
      BEGIN
        filename := Config_rec.last_file;
        synedit1.Lines.LoadFromFile(filename);
        form1.Caption := 'Free Pascal IDE' + ' (' + filename + ')';
        filechanged := synedit1.ChangeStamp;
      END;
  END;
END;

PROCEDURE TForm1.FormCreate(Sender: TObject);
BEGIN
  synedit1.Width := form1.Width - 2 * synedit1.left;
  toolbar1.ButtonWidth := form1.Width DIV 10;
  toolbar2.ButtonWidth := form1.Width DIV 6;

  Preferences_Box.Left := toolbar1.ButtonWidth;
  Preferences_Box.top := 21;
  Preferences_Box.Visible := False;
  memo1.Width := form1.Width;
  synedit1.Height := form1.Height - (toolbar1.Height + toolbar2.Height) - memo1.Height;
  Config_rec.optimization := '-O1';
  read_config_file;
END;


PROCEDURE TForm1.Calculator_buttonClick(Sender: TObject);
BEGIN
  calculatordialog1.Execute;
END;

PROCEDURE TForm1.exit_fileClick(Sender: TObject);
BEGIN
  IF filename <> '' THEN
  BEGIN
    synedit1.Lines.SaveToFile(filename);
    filechanged := synedit1.ChangeStamp;
    halt;
  END
  ELSE
    ShowMessage('File has no name, please use "save as"');
END;

PROCEDURE TForm1.File_QuitClick(Sender: TObject);
BEGIN
  halt;
END;



PROCEDURE TForm1.Button1Click(Sender: TObject);
BEGIN
  Preferences_Box.Visible := False;
END;


PROCEDURE TForm1.FormResize(Sender: TObject);
BEGIN
  synedit1.Width := form1.Width - 2 * synedit1.left;
  toolbar1.ButtonWidth := form1.Width DIV 10;
  toolbar2.ButtonWidth := form1.Width DIV 6;
  synedit1.Height := form1.Height - (toolbar1.Height + toolbar2.Height) - memo1.Height;
  memo1.Width := form1.Width;
END;

PROCEDURE TForm1.Close_fileClick(Sender: TObject);
BEGIN
  IF (filechanged = synedit1.ChangeStamp) THEN
  BEGIN
    synedit1.Lines.Clear;
    filename := '';
    form1.Caption := 'Free Pascal IDE';
  END
  ELSE
    ShowMessage('file was changed but not saved');
END;


PROCEDURE TForm1.PreferencesClick(Sender: TObject);

BEGIN
  CASE Config_rec.Optimization OF
    '-O-': no_optimizations.Checked := True;
    '-O1': level1_optimizations.Checked := True;
    '-O2': level2_optimizations.Checked := True;
    '-O3': level3_optimizations.Checked := True;
    '-O4': level4_optimizations.Checked := True;
  END;
  Preferences_Box.Visible := True;
END;

PROCEDURE TForm1.CompileClick(Sender: TObject);
CONST
  BUF_SIZE = 2048; // Buffer size for reading the output in chunks

VAR
  AProcess:   TProcess;
  OutputStream: TStream;
  BytesRead, leng: longint;
  Buffer:     ARRAY[1..BUF_SIZE] OF byte;
  executable: string;

BEGIN
  leng := length(filename);
  executable := LeftStr(filename, leng - 3) + 'exe';
  IF filename <> '' THEN
  BEGIN
    IF FileExists(executable) THEN
      DeleteFile(executable);

    synedit1.Lines.SaveToFile(filename);
    filechanged := synedit1.ChangeStamp;
    ;
    AProcess := TProcess.Create(nil);
    memo1.Clear;
    AProcess.Executable := 'fpc';
    AProcess.Parameters.Add(Config_rec.optimization);  //optimization level
    //AProcess.Parameters.Add('-va');
    AProcess.Parameters.Add(filename);
    AProcess.Options := [poUsePipes, poNoConsole];
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
  form1.Caption := 'Free Pascal IDE' + ' (' + filename + ')';
  filechanged := synedit1.ChangeStamp;
  Config_rec.last_file := filename;
  update_config_file;
END;

PROCEDURE TForm1.Pref_cancel_buttonClick(Sender: TObject);
//ignore changes to preferences
BEGIN
  Preferences_Box.Visible := False;
END;

PROCEDURE TForm1.Pref_ok_butClick(Sender: TObject);   //add all preferences in here
BEGIN
  IF no_optimizations.Checked THEN
    Config_rec.optimization := '-O-';
  IF level1_optimizations.Checked THEN
    Config_rec.optimization := '-O1';
  IF level2_optimizations.Checked THEN
    Config_rec.optimization := '-O2';
  IF level3_optimizations.Checked THEN
    Config_rec.optimization := '-O3';
  IF level4_optimizations.Checked THEN
    Config_rec.optimization := '-O4';
  Config_rec.openlastfile := open_last_file.Checked;
  Preferences_Box.Visible := False;
  update_config_file;
END;

PROCEDURE TForm1.Run_buttonClick(Sender: TObject);
VAR
  Process:    TProcess;
  I, leng:    integer;
  executable: string;
BEGIN
  leng := length(filename);
  executable := LeftStr(filename, leng - 3) + 'exe';
  IF FileExists(executable) THEN
  BEGIN
    Process := TProcess.Create(nil);
    TRY
      Process.InheritHandles := False;
      Process.Options := [];
      Process.ShowWindow := swoShow;

      FOR I := 1 TO GetEnvironmentVariableCount DO
        Process.Environment.Add(GetEnvironmentString(I));

      Process.Executable := executable;
      Process.Execute;
    FINALLY
      Process.Free;
    END;
  END
  ELSE
    ShowMessage('Executable doesn''t exist. Must compile succesfully first');

END;

PROCEDURE TForm1.saveas_fileClick(Sender: TObject);
BEGIN
  IF SaveDialog1.Execute THEN
  BEGIN
    filename := saveDialog1.Filename;
    synedit1.Lines.SaveToFile(filename);
  END;
  form1.Caption := 'Free Pascal IDE' + ' (' + filename + ')';
  filechanged := synedit1.ChangeStamp;
  Config_rec.last_file := filename;
  update_config_file;
END;

PROCEDURE TForm1.Save_fileClick(Sender: TObject);

BEGIN
  IF filename <> '' THEN
  BEGIN
    synedit1.Lines.SaveToFile(filename);
    filechanged := synedit1.ChangeStamp;
  END
  ELSE
    ShowMessage('File has no name, please use "save as"');
  update_config_file;
END;



END.
