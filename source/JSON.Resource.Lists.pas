unit JSON.Resource.Lists;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections, System.JSON,
  GenAI, GenAI.Types, JSON.Resource;

type
  EIndexOutOfBounds = class(EArgumentOutOfRangeException);
  EArgumentNil = class(EArgumentNilException);

  TJSONListParams<T: class; U: class, constructor> = class abstract(TJSONResource)
  private
    FData: TArray<U>;
  protected
    function EnsureIndex(const Index: Integer): T;
    function IndexOf(const Item: TObject): Integer;
    function ItemCheck(const Item: TObject): T;
  public
    function AddItem: U; virtual;
    function Clear: T;
    function Delete(const Index: Integer): T; overload;
    function Delete(const Item: TObject): T; overload; virtual;
    function WithData(const Value: TArray<U>): T; overload;
    function WithData(const Value: TArray<TFactory<U>>): T; overload;
    property Data: TArray<U> read FData write FData;
  end;

implementation

{ TDataList<T, U> }

function TJSONListParams<T, U>.AddItem: U;
begin
  Result := U.Create;
  FData := FData + [Result];
end;

function TJSONListParams<T, U>.Clear: T;
begin
  for var Item in FData do
    Item.Free;
  FData := [];
  Result := Self as T;
end;

function TJSONListParams<T, U>.Delete(const Item: TObject): T;
begin
  ItemCheck(Item);
  Result := Delete(IndexOf(Item));
end;

function TJSONListParams<T, U>.Delete(const Index: Integer): T;
begin
  if index < 0 then
    Exit(Self as T);

  EnsureIndex(Index);
  var FList := TList<U>.Create(Data);
  try
    FList[Index].Free;
    FList.Delete(Index);
    Data := FList.ToArray;
  finally
     FList.Free;
  end;
  Result := Self as T;
end;

function TJSONListParams<T, U>.EnsureIndex(const Index: Integer): T;
begin
  if Index >= Length(Data) then
    raise EIndexOutOfBounds.CreateFmt(
      'JSONList: index %d out of bounds [0..%d]', [Index, Length(Data)-1]);
  Result := Self as T;
end;

function TJSONListParams<T, U>.IndexOf(const Item: TObject): Integer;
begin
  for Result := 0 to High(FData) do
    if Pointer(FData[Result]) = Pointer(Item) then
      Exit;
  Result := -1;
end;

function TJSONListParams<T, U>.ItemCheck(const Item: TObject): T;
begin
  if not (Item is U) then
    raise EArgumentNil.CreateFmt(
            'Class %s not supported', [Item.ClassName]);
  Result := Self as T;
end;

function TJSONListParams<T, U>.WithData(const Value: TArray<TFactory<U>>): T;
begin
  for var i := Low(FData) to High(FData) do
    FData[i].Free;
  SetLength(FData, Length(Value));
  for var i := 0 to High(Value) do
    FData[i] := Value[i]();
  Result := Self as T;
end;

function TJSONListParams<T, U>.WithData(const Value: TArray<U>): T;
begin
  for var i := Low(FData) to High(FData) do
    FData[i].Free;
  FData := [];
  FData := Value;
  Result := Self as T;
end;

end.
