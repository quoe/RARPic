unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ExtDlgs, Jpeg, pngimage, ShellApi, DateUtils,
  Menus;

type
  TForm1 = class(TForm)
    LabeledEdit1: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
    LabeledEdit3: TLabeledEdit;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    OpenDialog2: TOpenDialog;
    Image1: TImage;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Image2: TImage;
    Image3: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    Label4: TLabel;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

function FileSize(fileName : wideString) : Int64;
var
  sr : TSearchRec;
begin
  if FindFirst(fileName, faAnyFile, sr ) = 0 then
     result := Int64(sr.FindData.nFileSizeHigh) shl Int64(32) + Int64(sr.FindData.nFileSizeLow)
  else
     result := -1;
  FindClose(sr) ;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    LabeledEdit1.Text := OpenDialog1.FileName;
    Image1.Picture.LoadFromFile(LabeledEdit1.Text);
    Label4.Caption := IntToStr(FileSize(LabeledEdit1.Text)) + ' байт';
    GroupBox3.Visible := TRUE;
    if GroupBox3.Visible and GroupBox4.Visible then
    begin
      GroupBox5.Visible := TRUE;
    end;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  if OpenDialog2.Execute then
  begin
    LabeledEdit2.Text := OpenDialog2.FileName;
    Label3.Caption := IntToStr(FileSize(LabeledEdit2.Text)) + ' байт';
    GroupBox4.Visible := TRUE;
    if GroupBox3.Visible and GroupBox4.Visible then
    begin
      GroupBox5.Visible := TRUE;
    end;
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  if SaveDialog1.Execute then
  begin
    LabeledEdit3.Text := SaveDialog1.FileName;
    GroupBox3.Visible := TRUE;
    if GroupBox3.Visible and GroupBox4.Visible then
    begin
      GroupBox5.Visible := TRUE;
    end;
  end;
end;

procedure TForm1.Image1Click(Sender: TObject);
begin
  ShellExecute(0,'Open', PChar(LabeledEdit1.Text),'',nil,1);
end;

procedure TForm1.Image2Click(Sender: TObject);
begin
  ShellExecute(0,'Open', PChar(LabeledEdit2.Text),'',nil,1);
end;

procedure Suicide;
var
 F: Textfile;
begin
 AssignFile(F,Changefileext(Paramstr(0),'.bat'));
 Rewrite(F);
 Writeln(F,':1');
 Writeln(F, Format('Erase "%s"',[Paramstr(0)]));
 Writeln(F, Format('If exist "%s" Goto 1',[Paramstr(0)]));
 Writeln(F, Format('Erase "%s"',[ChangeFileExt(Paramstr(0),'.bat')]));
 CloseFile(F);
 //WinExec(PChar(ChangeFileExt(Paramstr(0),'.bat')),SW_HIDE);
 //Halt;
end;

procedure TForm1.Image3Click(Sender: TObject);
var Path, PathBat: String;
  formattedDateTime : string;
  St: TStringList;
begin
  if (LabeledEdit1.Text = '') or (LabeledEdit2.Text = '') then
  begin
    ShowMessage('Либо картинка, либо архив отсутствует!');
    exit;
  end;
  DateTimeToString(formattedDateTime, 'yymmdd_hh-mm-ss', Now);
  Path := LabeledEdit3.Text;
  if LabeledEdit3.Text = '' then
  begin
    Path := ExtractFilePath(Application.ExeName) + formattedDateTime + '.jpg';
  end;
  PathBat :=ExtractFilePath(Application.ExeName) + formattedDateTime + '.bat';
  St:= TStringList.Create;
  St.Add('Copy /b "' + LabeledEdit1.Text + '" + "' + LabeledEdit2.Text + '" "' + Path + '"');
  St.Add('Erase "' + PathBat + '"');
  St.SaveToFile(PathBat);

  if Application.MessageBox('Запустить файл?', 'Запустить?', MB_YESNO + MB_ICONQUESTION +
  MB_DEFBUTTON2) = IDYES then
  begin
    ShellExecute(0,'Open', PChar(PathBat),'',nil,1);
  end;
  //Suicide;
  //ShellExecute(0,'Open', PChar(Path),'',nil,1);
end;

procedure TForm1.N3Click(Sender: TObject);
begin
  ShowMessage('Программа создания RAR-картинок. Полученный файл в итоге будет картинкой, которую можно открыть через WinRAR.                                                            quoe@mail.ru, 2015');
end;

procedure TForm1.N4Click(Sender: TObject);
begin
  if LabeledEdit3.Text = '' then
  begin
    ShellExecute(0,'Open', PChar(ExtractFilePath(Application.ExeName)),'',nil,1);
  end
  else
  begin
    ShellExecute(0,'Open', PChar(ExtractFilePath(LabeledEdit3.Text)),'',nil,1);
  end;
end;

procedure TForm1.N5Click(Sender: TObject);
begin
  Close;
end;

end.
