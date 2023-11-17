program prjAPI_dhp;

{$APPTYPE CONSOLE}

{$R *.res}

uses Horse;

var
  App: THorse;

begin
//  App := THorse.Create(9000);

  THorse.Get('/ping',
    procedure(Req: THorseRequest; Res: THorseResponse)
    begin
      Res.Send('pong');
    end);

  THorse.Listen(9000);
//  App.Start;
end.
