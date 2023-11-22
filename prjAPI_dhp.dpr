program prjAPI_dhp;

{$APPTYPE CONSOLE}

{$R *.res}

uses Horse, System.JSON, Horse.Jhonson, Horse.BasicAuthentication, System.SysUtils;

var
  App: THorse;
  Users: TJSONArray;

begin
//  App := THorse.Create(9000);
  Users := TJSONArray.Create;
//  App.Use(Jhonson);
  THorse.Use(Jhonson);

  THorse.Use(HorseBasicAuthentication(
    function(const AUsername, APassword: string): Boolean
    begin
      Result := AUsername.Equals('user') and APassword.Equals('password');
    end));

  THorse.Get('/users',
    procedure(Req: THorseRequest; Res: THorseResponse)
    begin
      Res.Send<TJSONAncestor>(Users.Clone);
    end);

  THorse.Post('/user',
    procedure(Req: THorseRequest; Res: THorseResponse)
    var
        User: TJSONObject;
    begin
      User := Req.Body<TJSONObject>.Clone as TJSONObject;
      Users.AddElement(User);
      Res.Send<TJSONAncestor>(User.Clone).Status(THTTPStatus.Created);
    end);

  THorse.Delete('/user/:id',
    procedure(Req: THorseRequest; Res: THorseResponse)
    var
        id: Integer;
    begin
      id := Req.Params.Items['id'].ToInteger;
      Users.Remove(Pred(id)).Free;
      Res.Send<TJSONAncestor>(Users.Clone).Status(THTTPStatus.NoContent);
    end);

  THorse.Listen(9000);
//  App.Start;
end.
