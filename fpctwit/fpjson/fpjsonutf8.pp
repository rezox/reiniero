{
    Adapted from fpjson.pp by Reinier Olislagers, 2012.
    UTF8 conversion. License unchanged.
    Original notice below:
    ***********************************************
    This file is part of the Free Component Library

    JSON Data structures
    Copyright (c) 2007 by Michael Van Canneyt michael@freepascal.org

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
{$mode objfpc}
{$h+}
unit fpjsonutf8;

interface

uses
  variants,
  SysUtils,
  classes,
  contnrs;

type

  TJSONtype = (jtUnknown, jtNumber, jtString, jtBoolean, jtNull, jtArray, jtObject);
  TJSONFloat = Double;
  TJSONStringType = AnsiString;
  TJSONCharType = AnsiChar;
  PJSONCharType = ^TJSONCharType;
  TFormatOption = (foSingleLineArray,   // Array without CR/LF : all on one line
                   foSingleLineObject,  // Object without CR/LF : all on one line
                   foDoNotQuoteMembers, // Do not quote object member names.
                   foUseTabchar);       // Use tab characters instead of spaces.
  TFormatOptions = set of TFormatOption;

Const
  DefaultIndentSize = 2;
  DefaultFormat     = [];
  AsJSONFormat      = [foSingleLineArray,foSingleLineObject]; // These options make FormatJSON behave as AsJSON
  
Type

  { TJSONData }
  
  TJSONData = class(TObject)
  protected
    function GetAsBoolean: Boolean; virtual; abstract;
    function GetAsFloat: TJSONFloat; virtual; abstract;
    function GetAsInteger: Integer; virtual; abstract;
    function GetAsInt64: Int64; virtual; abstract;
    function GetIsNull: Boolean; virtual;
    procedure SetAsBoolean(const AValue: Boolean); virtual; abstract;
    procedure SetAsFloat(const AValue: TJSONFloat); virtual; abstract;
    procedure SetAsInteger(const AValue: Integer); virtual; abstract;
    procedure SetAsInt64(const AValue: Int64); virtual; abstract;
    function GetAsJSON: TJSONStringType; virtual; abstract;
    function GetAsString: TJSONStringType; virtual; abstract;
    procedure SetAsString(const AValue: TJSONStringType); virtual; abstract;
    function GetValue: variant; virtual; abstract;
    procedure SetValue(const AValue: variant); virtual; abstract;
    function GetItem(Index : Integer): TJSONData; virtual;
    procedure SetItem(Index : Integer; const AValue: TJSONData); virtual;
    Function DoFormatJSON(Options : TFormatOptions; CurrentIndent, Indent : Integer) : TJSONStringType; virtual;
    function GetCount: Integer; virtual;
  public
    Constructor Create; virtual;
    Class function JSONType: TJSONType; virtual;
    Procedure Clear;  virtual; Abstract;
    Function Clone : TJSONData; virtual; abstract;
    Function FormatJSON(Options : TFormatOptions = DefaultFormat; Indentsize : Integer = DefaultIndentSize) : TJSONStringType; 
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TJSONData read GetItem write SetItem;
    property Value: variant read GetValue write SetValue;
    Property AsString : TJSONStringType Read GetAsString Write SetAsString;
    Property AsFloat : TJSONFloat Read GetAsFloat Write SetAsFloat;
    Property AsInteger : Integer Read GetAsInteger Write SetAsInteger;
    Property AsInt64 : Int64 Read GetAsInt64 Write SetAsInt64;
    Property AsBoolean : Boolean Read GetAsBoolean Write SetAsBoolean;
    Property IsNull : Boolean Read GetIsNull;
    Property AsJSON : TJSONStringType Read GetAsJSON;
  end;

  TJSONDataClass = Class of TJSONData;
  TJSONNumberType = (ntFloat,ntInteger,ntInt64);

  TJSONNumber = class(TJSONData)
  protected
  public
    class function JSONType: TJSONType; override;
    class function NumberType : TJSONNumberType; virtual; abstract;
  end;

  { TJSONFloatNumber }

  TJSONFloatNumber = class(TJSONNumber)
  Private
    FValue : TJSONFloat;
  protected
    function GetAsBoolean: Boolean; override;
    function GetAsFloat: TJSONFloat; override;
    function GetAsInteger: Integer; override;
    function GetAsInt64: Int64; override;
    procedure SetAsBoolean(const AValue: Boolean); override;
    procedure SetAsFloat(const AValue: TJSONFloat); override;
    procedure SetAsInteger(const AValue: Integer); override;
    procedure SetAsInt64(const AValue: Int64); override;
    function GetAsJSON: TJSONStringType; override;
    function GetAsString: TJSONStringType; override;
    procedure SetAsString(const AValue: TJSONStringType); override;
    function GetValue: variant; override;
    procedure SetValue(const AValue: variant); override;
  public
    Constructor Create(AValue : TJSONFloat); reintroduce;
    class function NumberType : TJSONNumberType; override;
    Procedure Clear;  override;
    Function Clone : TJSONData; override;
  end;
  
  { TJSONIntegerNumber }

  TJSONIntegerNumber = class(TJSONNumber)
  Private
    FValue : Integer;
  protected
    function GetAsBoolean: Boolean; override;
    function GetAsFloat: TJSONFloat; override;
    function GetAsInteger: Integer; override;
    function GetAsInt64: Int64; override;
    procedure SetAsBoolean(const AValue: Boolean); override;
    procedure SetAsFloat(const AValue: TJSONFloat); override;
    procedure SetAsInteger(const AValue: Integer); override;
    procedure SetAsInt64(const AValue: Int64); override;
    function GetAsJSON: TJSONStringType; override;
    function GetAsString: TJSONStringType; override;
    procedure SetAsString(const AValue: TJSONStringType); override;
    function GetValue: variant; override;
    procedure SetValue(const AValue: variant); override;
  public
    Constructor Create(AValue : Integer); reintroduce;
    class function NumberType : TJSONNumberType; override;
    Procedure Clear;  override;
    Function Clone : TJSONData; override;
  end;

  { TJSONInt64Number }

  TJSONInt64Number = class(TJSONNumber)
  Private
    FValue : Int64;
  protected
    function GetAsBoolean: Boolean; override;
    function GetAsFloat: TJSONFloat; override;
    function GetAsInteger: Integer; override;
    function GetAsInt64: Int64; override;
    procedure SetAsBoolean(const AValue: Boolean); override;
    procedure SetAsFloat(const AValue: TJSONFloat); override;
    procedure SetAsInteger(const AValue: Integer); override;
    procedure SetAsInt64(const AValue: Int64); override;
    function GetAsJSON: TJSONStringType; override;
    function GetAsString: TJSONStringType; override;
    procedure SetAsString(const AValue: TJSONStringType); override;
    function GetValue: variant; override;
    procedure SetValue(const AValue: variant); override;
  public
    Constructor Create(AValue : Int64); reintroduce;
    class function NumberType : TJSONNumberType; override;
    Procedure Clear;  override;
    Function Clone : TJSONData; override;
  end;

  { TJSONString }

  TJSONString = class(TJSONData)
  Private
    FValue: TJSONStringType;
  protected
    function GetValue: Variant; override;
    procedure SetValue(const AValue: Variant); override;
    function GetAsBoolean: Boolean; override;
    function GetAsFloat: TJSONFloat; override;
    function GetAsInteger: Integer; override;
    function GetAsInt64: Int64; override;
    procedure SetAsBoolean(const AValue: Boolean); override;
    procedure SetAsFloat(const AValue: TJSONFloat); override;
    procedure SetAsInteger(const AValue: Integer); override;
    procedure SetAsInt64(const AValue: Int64); override;
    function GetAsJSON: TJSONStringType; override;
    function GetAsString: TJSONStringType; override;
    procedure SetAsString(const AValue: TJSONStringType); override;
  public
    Constructor Create(const AValue : TJSONStringType); reintroduce;
    class function JSONType: TJSONType; override;
    Procedure Clear;  override;
    Function Clone : TJSONData; override;
  end;

  { TJSONboolean }

  TJSONBoolean = class(TJSONData)
  Private
    FValue: Boolean;
  protected
    function GetValue: Variant; override;
    procedure SetValue(const AValue: Variant); override;
    function GetAsBoolean: Boolean; override;
    function GetAsFloat: TJSONFloat; override;
    function GetAsInteger: Integer; override;
    function GetAsInt64: Int64; override;
    procedure SetAsBoolean(const AValue: Boolean); override;
    procedure SetAsFloat(const AValue: TJSONFloat); override;
    procedure SetAsInteger(const AValue: Integer); override;
    procedure SetAsInt64(const AValue: Int64); override;
    function GetAsJSON: TJSONStringType; override;
    function GetAsString: TJSONStringType; override;
    procedure SetAsString(const AValue: TJSONStringType); override;
  public
    Constructor Create(AValue : Boolean); reintroduce;
    class function JSONType: TJSONType; override;
    Procedure Clear;  override;
    Function Clone : TJSONData; override;
  end;

  { TJSONnull }

  TJSONNull = class(TJSONData)
  protected
    Procedure Converterror(From : Boolean);
    function GetAsBoolean: Boolean; override;
    function GetAsFloat: TJSONFloat; override;
    function GetAsInteger: Integer; override;
    function GetAsInt64: Int64; override;
    function GetIsNull: Boolean; override;
    procedure SetAsBoolean(const AValue: Boolean); override;
    procedure SetAsFloat(const AValue: TJSONFloat); override;
    procedure SetAsInteger(const AValue: Integer); override;
    procedure SetAsInt64(const AValue: Int64); override;
    function GetAsJSON: TJSONStringType; override;
    function GetAsString: TJSONStringType; override;
    procedure SetAsString(const AValue: TJSONStringType); override;
    function GetValue: variant; override;
    procedure SetValue(const AValue: variant); override;
  public
    class function JSONType: TJSONType; override;
    Procedure Clear;  override;
    Function Clone : TJSONData; override;
  end;

  TJSONArrayIterator = procedure(Item: TJSONData; Data: TObject; var Continue: Boolean) of object;

  { TJSONArray }
  TJSONObject = Class;

  TJSONArray = class(TJSONData)
  Private
    FList : TFPObjectList;
    function GetArrays(Index : Integer): TJSONArray;
    function GetBooleans(Index : Integer): Boolean;
    function GetFloats(Index : Integer): TJSONFloat;
    function GetIntegers(Index : Integer): Integer;
    function GetInt64s(Index : Integer): Int64;
    function GetNulls(Index : Integer): Boolean;
    function GetObjects(Index : Integer): TJSONObject;
    function GetStrings(Index : Integer): TJSONStringType;
    function GetTypes(Index : Integer): TJSONType;
    procedure SetArrays(Index : Integer; const AValue: TJSONArray);
    procedure SetBooleans(Index : Integer; const AValue: Boolean);
    procedure SetFloats(Index : Integer; const AValue: TJSONFloat);
    procedure SetIntegers(Index : Integer; const AValue: Integer);
    procedure SetInt64s(Index : Integer; const AValue: Int64);
    procedure SetObjects(Index : Integer; const AValue: TJSONObject);
    procedure SetStrings(Index : Integer; const AValue: TJSONStringType);
  protected
    Procedure Converterror(From : Boolean);
    function GetAsBoolean: Boolean; override;
    function GetAsFloat: TJSONFloat; override;
    function GetAsInteger: Integer; override;
    function GetAsInt64: Int64; override;
    procedure SetAsBoolean(const AValue: Boolean); override;
    procedure SetAsFloat(const AValue: TJSONFloat); override;
    procedure SetAsInteger(const AValue: Integer); override;
    procedure SetAsInt64(const AValue: Int64); override;
    function GetAsJSON: TJSONStringType; override;
    function GetAsString: TJSONStringType; override;
    procedure SetAsString(const AValue: TJSONStringType); override;
    function GetValue: variant; override;
    procedure SetValue(const AValue: variant); override;
    function GetCount: Integer; override;
    function GetItem(Index : Integer): TJSONData; override;
    procedure SetItem(Index : Integer; const AValue: TJSONData); override;
    Function DoFormatJSON(Options : TFormatOptions; CurrentIndent, Indent : Integer) : TJSONStringType; override;
  public
    Constructor Create; overload; reintroduce;
    Constructor Create(const Elements : Array of Const); overload;
    Destructor Destroy; override;
    class function JSONType: TJSONType; override;
    Function Clone : TJSONData; override;
    // Examine
    procedure Iterate(Iterator : TJSONArrayIterator; Data: TObject);
    function IndexOf(obj: TJSONData): Integer;
    // Manipulate
    Procedure Clear;  override;
    function Add(Item : TJSONData): Integer;
    function Add(I : Integer): Integer;
    function Add(I : Int64): Int64;
    function Add(const S : String): Integer;
    function Add: Integer;
    function Add(F : TJSONFloat): Integer;
    function Add(B : Boolean): Integer;
    function Add(AnArray : TJSONArray): Integer;
    function Add(AnObject: TJSONObject): Integer;
    Procedure Delete(Index : Integer);
    procedure Exchange(Index1, Index2: Integer);
    procedure Insert(Index: Integer);
    procedure Insert(Index: Integer; Item : TJSONData);
    procedure Insert(Index: Integer; I : Integer);
    procedure Insert(Index: Integer; I : Int64);
    procedure Insert(Index: Integer; const S : String);
    procedure Insert(Index: Integer; F : TJSONFloat);
    procedure Insert(Index: Integer; B : Boolean);
    procedure Insert(Index: Integer; AnArray : TJSONArray);
    procedure Insert(Index: Integer; AnObject: TJSONObject);
    procedure Move(CurIndex, NewIndex: Integer);
    Procedure Remove(Item : TJSONData);
    // Easy Access Properties.
    property Items;default;
    Property Types[Index : Integer] : TJSONType Read GetTypes;
    Property Nulls[Index : Integer] : Boolean Read GetNulls;
    Property Integers[Index : Integer] : Integer Read GetIntegers Write SetIntegers;
    Property Int64s[Index : Integer] : Int64 Read GetInt64s Write SetInt64s;
    Property Strings[Index : Integer] : TJSONStringType Read GetStrings Write SetStrings;
    Property Floats[Index : Integer] : TJSONFloat Read GetFloats Write SetFloats;
    Property Booleans[Index : Integer] : Boolean Read GetBooleans Write SetBooleans;
    Property Arrays[Index : Integer] : TJSONArray Read GetArrays Write SetArrays;
    Property Objects[Index : Integer] : TJSONObject Read GetObjects Write SetObjects;
  end;

  TJSONObjectIterator = procedure(Const AName : TJSONStringType; Item: TJSONData; Data: TObject; var Continue: Boolean) of object;

  { TJSONObject }

  TJSONObject = class(TJSONData)
  private
    FHash : TFPHashObjectList; // Careful : Names limited to 255 chars.
    function GetArrays(const AName : String): TJSONArray;
    function GetBooleans(const AName : String): Boolean;
    function GetElements(const AName: string): TJSONData;
    function GetFloats(const AName : String): TJSONFloat;
    function GetIntegers(const AName : String): Integer;
    function GetInt64s(const AName : String): Int64;
    function GetIsNull(const AName : String): Boolean; reintroduce;
    function GetNameOf(Index : Integer): TJSONStringType;
    function GetObjects(const AName : String): TJSONObject;
    function GetStrings(const AName : String): TJSONStringType;
    function GetTypes(const AName : String): TJSONType;
    procedure SetArrays(const AName : String; const AValue: TJSONArray);
    procedure SetBooleans(const AName : String; const AValue: Boolean);
    procedure SetElements(const AName: string; const AValue: TJSONData);
    procedure SetFloats(const AName : String; const AValue: TJSONFloat);
    procedure SetIntegers(const AName : String; const AValue: Integer);
    procedure SetInt64s(const AName : String; const AValue: Int64);
    procedure SetIsNull(const AName : String; const AValue: Boolean);
    procedure SetObjects(const AName : String; const AValue: TJSONObject);
    procedure SetStrings(const AName : String; const AValue: TJSONStringType);
  protected
    Procedure Converterror(From : Boolean);
    function GetAsBoolean: Boolean; override;
    function GetAsFloat: TJSONFloat; override;
    function GetAsInteger: Integer; override;
    function GetAsInt64: Int64; override;
    procedure SetAsBoolean(const AValue: Boolean); override;
    procedure SetAsFloat(const AValue: TJSONFloat); override;
    procedure SetAsInteger(const AValue: Integer); override;
    procedure SetAsInt64(const AValue: Int64); override;
    function GetAsJSON: TJSONStringType; override;
    function GetAsString: TJSONStringType; override;
    procedure SetAsString(const AValue: TJSONStringType); override;
    function GetValue: variant; override;
    procedure SetValue(const AValue: variant); override;
    function GetCount: Integer; override;
    function GetItem(Index : Integer): TJSONData; override;
    procedure SetItem(Index : Integer; const AValue: TJSONData); override;
    Function DoFormatJSON(Options : TFormatOptions; CurrentIndent, Indent : Integer) : TJSONStringType; override;
  public
    constructor Create; reintroduce;
    Constructor Create(const Elements : Array of Const); overload;
    destructor Destroy; override;
    class function JSONType: TJSONType; override;
    Function Clone : TJSONData; override;
    // Examine
    procedure Iterate(Iterator : TJSONObjectIterator; Data: TObject);
    function IndexOf(Item: TJSONData): Integer;
    Function IndexOfName(const AName: TJSONStringType; CaseInsensitive : Boolean = False): Integer;
    Function Find(Const AName : String) : TJSONData; overload;
    Function Find(Const AName : String; AType : TJSONType) : TJSONData; overload;
    Function Get(Const AName : String; ADefault : TJSONFloat) : TJSONFloat;
    Function Get(Const AName : String; ADefault : Integer) : Integer;
    Function Get(Const AName : String; ADefault : Int64) : Int64;
    Function Get(Const AName : String; ADefault : Boolean) : Boolean;
    Function Get(Const AName : String; ADefault : TJSONStringType) : TJSONStringTYpe;
    Function Get(Const AName : String; ADefault : TJSONArray) : TJSONArray;
    Function Get(Const AName : String; ADefault : TJSONObject) : TJSONObject;
    // Manipulate
    Procedure Clear;  override;
    function Add(const AName: TJSONStringType; AValue: TJSONData): Integer; overload;
    function Add(const AName: TJSONStringType; AValue: Boolean): Integer; overload;
    function Add(const AName: TJSONStringType; AValue: TJSONFloat): Integer; overload;
    function Add(const AName, AValue: TJSONStringType): Integer; overload;
    function Add(const AName: TJSONStringType; Avalue: Integer): Integer; overload;
    function Add(const AName: TJSONStringType; Avalue: Int64): Integer; overload;
    function Add(const AName: TJSONStringType): Integer; overload;
    function Add(const AName: TJSONStringType; AValue : TJSONArray): Integer; overload;
    procedure Delete(Index : Integer);
    procedure Delete(Const AName : string);
    procedure Remove(Item : TJSONData);
    Function Extract(Index : Integer) : TJSONData;
    Function Extract(Const AName : string) : TJSONData;

    // Easy access properties.
    property Names[Index : Integer] : TJSONStringType read GetNameOf;
    property Elements[AName: string] : TJSONData read GetElements write SetElements; default;

    Property Types[AName : String] : TJSONType Read GetTypes;
    Property Nulls[AName : String] : Boolean Read GetIsNull Write SetIsNull;
    Property Floats[AName : String] : TJSONFloat Read GetFloats Write SetFloats;
    Property Integers[AName : String] : Integer Read GetIntegers Write SetIntegers;
    Property Int64s[AName : String] : Int64 Read GetInt64s Write SetInt64s;
    Property Strings[AName : String] : TJSONStringType Read GetStrings Write SetStrings;
    Property Booleans[AName : String] : Boolean Read GetBooleans Write SetBooleans;
    Property Arrays[AName : String] : TJSONArray Read GetArrays Write SetArrays;
    Property Objects[AName : String] : TJSONObject Read GetObjects Write SetObjects;
  end;

  EJSON = Class(Exception);
  
Function StringToJSONString(const S : TJSONStringType) : TJSONStringType;
Function JSONStringToString(const S : TJSONStringType) : TJSONStringType;
Function JSONTypeName(JSONType : TJSONType) : String;


implementation

Uses typinfo;

Resourcestring
  SErrCannotConvertFromNull = 'Cannot convert data from Null value';
  SErrCannotConvertToNull = 'Cannot convert data to Null value';
  SErrCannotConvertFromArray = 'Cannot convert data from array value';
  SErrCannotConvertToArray = 'Cannot convert data to array value';
  SErrCannotConvertFromObject = 'Cannot convert data from object value';
  SErrCannotConvertToObject = 'Cannot convert data to object value';
  SErrInvalidFloat = 'Invalid float value : %s';
  SErrInvalidInteger = 'Invalid float value : %s';
  SErrCannotSetNotIsNull = 'IsNull cannot be set to False';
  SErrCannotAddArrayTwice = 'Adding an array object to an array twice is not allowed';
  SErrCannotAddObjectTwice = 'Adding an object to an array twice is not allowed';
  SErrUnknownTypeInConstructor = 'Unknown type in JSON%s constructor: %d';
  SErrNotJSONData = 'Cannot add object of type %s to TJSON%s';
  SErrPointerNotNil = 'Cannot add non-nil pointer to JSON%s';
  SErrOddNumber = 'TJSONObject must be constructed with name,value pairs';
  SErrNameMustBeString = 'TJSONObject constructor element name at pos %d is not a string';
  SErrNonexistentElement = 'Unknown object member: "%s"';
  
Function StringToJSONString(const S : TJSONStringType) : TJSONStringType;

Var
  I,J,L : Integer;
  P : PJSONCharType;

begin
  I:=1;
  J:=1;
  Result:='';
  L:=Length(S);
  P:=PJSONCharType(S);
  While I<=L do
    begin
    if (AnsiChar(P^) in ['"','/','\',#8,#9,#10,#12,#13]) then
      begin
      Result:=Result+Copy(S,J,I-J);
      Case P^ of
        '\' : Result:=Result+'\\';
        '/' : Result:=Result+'\/';
        '"' : Result:=Result+'\"';
        #8  : Result:=Result+'\b';
        #9  : Result:=Result+'\t';
        #10 : Result:=Result+'\n';
        #12 : Result:=Result+'\f';
        #13 : Result:=Result+'\r';
      end;
      J:=I+1;
      end;
    Inc(I);
    Inc(P);
    end;
  Result:=Result+Copy(S,J,I-1);
end;

Function JSONStringToString(const S : TJSONStringType) : TJSONStringType;

Var
  I,J,L : Integer;
  P : PJSONCharType;
  w : String;

begin
  I:=1;
  J:=1;
  L:=Length(S);
  Result:='';
  P:=PJSONCharType(S);
  While (I<=L) do
    begin
    if (P^='\') then
      begin
      Result:=Result+Copy(S,J,I-J);
      Inc(P);
      If (P^<>#0) then
        begin
        Inc(I);
        Case AnsiChar(P^) of
          '\','"','/'
              : Result:=Result+P^;
          'b' : Result:=Result+#8;
          't' : Result:=Result+#9;
          'n' : Result:=Result+#10;
          'f' : Result:=Result+#12;
          'r' : Result:=Result+#13;
          'u' : begin
                W:=Copy(S,I+1,4);
                Inc(I,4);
                Inc(P,4);
                Result:=Result+WideChar(StrToInt('$'+W));
                end;
        end;
        end;
      J:=I+1;
      end;
    Inc(I);
    Inc(P);
    end;
  Result:=Result+Copy(S,J,I-J+1);
end;

function JSONTypeName(JSONType: TJSONType): String;
begin
  Result:=GetEnumName(TypeInfo(TJSONType),Ord(JSONType));
end;



{ TJSONData }


function TJSONData.GetItem(Index : Integer): TJSONData;
begin
  Result:=nil;
end;

function TJSONData.GetCount: Integer;
begin
  Result:=0;
end;

constructor TJSONData.Create;
begin
  Clear;
end;

function TJSONData.GetIsNull: Boolean;
begin
  Result:=False;
end;

class function TJSONData.JSONType: TJSONType;
begin
  JSONType:=jtUnknown;
end;

procedure TJSONData.SetItem(Index : Integer; const AValue:
  TJSONData);
begin
  // Do Nothing
end;

Function TJSONData.FormatJSON(Options : TFormatOptions = DefaultFormat; IndentSize : Integer = DefaultIndentSize) : TJSONStringType;

begin
  Result:=DoFormatJSON(Options,0,IndentSize);
end;

Function TJSONData.DoFormatJSON(Options : TFormatOptions; CurrentIndent, Indent : Integer) : TJSONStringType; 

begin
  Result:=AsJSON;
end;

{ TJSONnumber }

class function TJSONnumber.JSONType: TJSONType;
begin
  Result:=jtNumber;
end;


{ TJSONstring }

class function TJSONstring.JSONType: TJSONType;
begin
  Result:=jtString;
end;

procedure TJSONString.Clear;
begin
  FValue:='';
end;

function TJSONString.Clone: TJSONData;

begin
  Result:=TJSONString.Create(Self.FValue);
end;

function TJSONstring.GetValue: Variant;
begin
  Result:=FValue;
end;

procedure TJSONstring.SetValue(const AValue: Variant);
begin
  FValue:=AValue;
end;


function TJSONstring.GetAsBoolean: Boolean;
begin
  Result:=StrToBool(FValue);
end;

function TJSONstring.GetAsFloat: TJSONFloat;

Var
  C : Integer;

begin
  Val(FValue,Result,C);
  If (C<>0) then
    If Not TryStrToFloat(FValue,Result) then
      Raise EConvertError.CreateFmt(SErrInvalidFloat,[FValue]);
end;

function TJSONstring.GetAsInteger: Integer;
begin
  Result:=StrToInt(FValue);
end;

function TJSONstring.GetAsInt64: Int64;
begin
  Result:=StrToInt64(FValue);
end;

procedure TJSONstring.SetAsBoolean(const AValue: Boolean);
begin
  FValue:=BoolToStr(AValue);
end;

procedure TJSONstring.SetAsFloat(const AValue: TJSONFloat);
begin
  FValue:=FloatToStr(AValue);
end;

procedure TJSONstring.SetAsInteger(const AValue: Integer);
begin
  FValue:=IntToStr(AValue);
end;

procedure TJSONstring.SetAsInt64(const AValue: Int64);
begin
  FValue:=IntToStr(AValue);
end;

function TJSONstring.GetAsJSON: TJSONStringType;
begin
  Result:='"'+StringToJSONString(FValue)+'"';
end;

function TJSONstring.GetAsString: TJSONStringType;
begin
  Result:=FValue;
end;

procedure TJSONstring.SetAsString(const AValue: TJSONStringType);
begin
  FValue:=AValue;
end;

constructor TJSONstring.Create(const AValue: TJSONStringType);
begin
  FValue:=AValue;
end;

{ TJSONboolean }


function TJSONboolean.GetValue: Variant;
begin
  Result:=FValue;
end;

class function TJSONboolean.JSONType: TJSONType;
begin
  Result:=jtBoolean;
end;

procedure TJSONBoolean.Clear;
begin
  FValue:=False;
end;

function TJSONBoolean.Clone: TJSONData;
begin
  Result:=TJSONBoolean.Create(Self.Fvalue);
end;


procedure TJSONboolean.SetValue(const AValue: Variant);
begin
  FValue:=boolean(AValue);
end;

function TJSONboolean.GetAsBoolean: Boolean;
begin
  Result:=FValue;
end;

function TJSONboolean.GetAsFloat: TJSONFloat;
begin
  Result:=Ord(FValue);
end;

function TJSONboolean.GetAsInteger: Integer;
begin
  Result:=Ord(FValue);
end;

function TJSONboolean.GetAsInt64: Int64;
begin
  Result:=Ord(FValue);
end;

procedure TJSONboolean.SetAsBoolean(const AValue: Boolean);
begin
  FValue:=AValue;
end;

procedure TJSONboolean.SetAsFloat(const AValue: TJSONFloat);
begin
  FValue:=(AValue<>0)
end;

procedure TJSONboolean.SetAsInteger(const AValue: Integer);
begin
  FValue:=(AValue<>0)
end;

procedure TJSONboolean.SetAsInt64(const AValue: Int64);
begin
  FValue:=(AValue<>0)
end;

function TJSONboolean.GetAsJSON: TJSONStringType;
begin
  If FValue then
    Result:='true'
  else
    Result:='false';
end;

function TJSONboolean.GetAsString: TJSONStringType;
begin
  Result:=BoolToStr(FValue, True);
end;

procedure TJSONboolean.SetAsString(const AValue: TJSONStringType);
begin
  FValue:=StrToBool(AValue);
end;

constructor TJSONboolean.Create(AValue: Boolean);
begin
  FValue:=AValue;
end;

{ TJSONnull }

procedure TJSONnull.Converterror(From : Boolean);
begin
  If From then
    Raise EJSON.Create(SErrCannotConvertFromNull)
  else
    Raise EJSON.Create(SErrCannotConvertToNull);
end;

{$warnings off}
function TJSONnull.GetAsBoolean: Boolean;
begin
  ConvertError(True);
end;

function TJSONnull.GetAsFloat: TJSONFloat;
begin
  ConvertError(True);
end;

function TJSONnull.GetAsInteger: Integer;
begin
  ConvertError(True);
end;

function TJSONnull.GetAsInt64: Int64;
begin
  ConvertError(True);
end;

function TJSONnull.GetIsNull: Boolean;
begin
  Result:=True;
end;

procedure TJSONnull.SetAsBoolean(const AValue: Boolean);
begin
  ConvertError(False);
end;

procedure TJSONnull.SetAsFloat(const AValue: TJSONFloat);
begin
  ConvertError(False);
end;

procedure TJSONnull.SetAsInteger(const AValue: Integer);
begin
  ConvertError(False);
end;

procedure TJSONnull.SetAsInt64(const AValue: Int64);
begin
  ConvertError(False);
end;

function TJSONnull.GetAsJSON: TJSONStringType;
begin
  Result:='null';
end;

function TJSONnull.GetAsString: TJSONStringType;
begin
  ConvertError(True);
end;

procedure TJSONnull.SetAsString(const AValue: TJSONStringType);
begin
  ConvertError(True);
end;

function TJSONnull.GetValue: Variant;
begin
  Result:=variants.Null;
end;

procedure TJSONnull.SetValue(const AValue: variant);
begin
  ConvertError(False);
end;

class function TJSONnull.JSONType: TJSONType;
begin
  Result:=jtNull;
end;

procedure TJSONNull.Clear;
begin
  // Do nothing
end;

function TJSONNull.Clone: TJSONData;
begin
  Result:=TJSONNull.Create;
end;

{$warnings on}



{ TJSONFloatNumber }

function TJSONFloatNumber.GetAsBoolean: Boolean;
begin
  Result:=(FValue<>0);
end;

function TJSONFloatNumber.GetAsFloat: TJSONFloat;
begin
  Result:=FValue;
end;

function TJSONFloatNumber.GetAsInteger: Integer;
begin
  Result:=Round(FValue);
end;

function TJSONFloatNumber.GetAsInt64: Int64;
begin
  Result:=Round(FValue);
end;

procedure TJSONFloatNumber.SetAsBoolean(const AValue: Boolean);
begin
  FValue:=Ord(AValue);
end;

procedure TJSONFloatNumber.SetAsFloat(const AValue: TJSONFloat);
begin
  FValue:=AValue;
end;

procedure TJSONFloatNumber.SetAsInteger(const AValue: Integer);
begin
  FValue:=AValue;
end;

procedure TJSONFloatNumber.SetAsInt64(const AValue: Int64);
begin
  FValue:=AValue;
end;

function TJSONFloatNumber.GetAsJSON: TJSONStringType;
begin
  Result:=AsString;
end;

function TJSONFloatNumber.GetAsString: TJSONStringType;
begin
  Str(FValue,Result);
end;

procedure TJSONFloatNumber.SetAsString(const AValue: TJSONStringType);

Var
  C : Integer;

begin
  Val(AValue,FValue,C);
  If (C<>0) then
    Raise EConvertError.CreateFmt(SErrInvalidFloat,[AValue]);
end;

function TJSONFloatNumber.GetValue: variant;
begin
  Result:=FValue;
end;

procedure TJSONFloatNumber.SetValue(const AValue: variant);
begin
  FValue:=AValue;
end;

constructor TJSONFloatNumber.Create(AValue: TJSONFloat);
begin
  FValue:=AValue;
end;

class function TJSONFloatNumber.NumberType: TJSONNumberType;
begin
  Result:=ntFloat;
end;

procedure TJSONFloatNumber.Clear;
begin
  FValue:=0;
end;

function TJSONFloatNumber.Clone: TJSONData;

begin
  Result:=TJSONFloatNumber.Create(Self.FValue);
end;

{ TJSONIntegerNumber }

function TJSONIntegerNumber.GetAsBoolean: Boolean;
begin
  Result:=FValue<>0;
end;

function TJSONIntegerNumber.GetAsFloat: TJSONFloat;
begin
  Result:=Ord(FValue);
end;

function TJSONIntegerNumber.GetAsInteger: Integer;
begin
  Result:=FValue;
end;

function TJSONIntegerNumber.GetAsInt64: Int64;
begin
  Result:=FValue;
end;

procedure TJSONIntegerNumber.SetAsBoolean(const AValue: Boolean);
begin
  FValue:=Ord(AValue);
end;

procedure TJSONIntegerNumber.SetAsFloat(const AValue: TJSONFloat);
begin
  FValue:=Round(AValue);
end;

procedure TJSONIntegerNumber.SetAsInteger(const AValue: Integer);
begin
  FValue:=AValue;
end;

procedure TJSONIntegerNumber.SetAsInt64(const AValue: Int64);
begin
  FValue:=AValue;
end;

function TJSONIntegerNumber.GetAsJSON: TJSONStringType;
begin
  Result:=AsString;
end;

function TJSONIntegerNumber.GetAsString: TJSONStringType;
begin
  Result:=IntToStr(FValue)
end;

procedure TJSONIntegerNumber.SetAsString(const AValue: TJSONStringType);
begin
  FValue:=StrToInt(AValue);
end;

function TJSONIntegerNumber.GetValue: variant;
begin
  Result:=FValue;
end;

procedure TJSONIntegerNumber.SetValue(const AValue: variant);
begin
  FValue:=AValue;
end;

constructor TJSONIntegerNumber.Create(AValue: Integer);
begin
  FValue:=AValue;
end;

class function TJSONIntegerNumber.NumberType: TJSONNumberType;
begin
  Result:=ntInteger;
end;

procedure TJSONIntegerNumber.Clear;
begin
  FValue:=0;
end;

function TJSONIntegerNumber.Clone: TJSONData;

begin
  Result:=TJSONIntegerNumber.Create(Self.FValue);
end;

{ TJSONInt64Number }

function TJSONInt64Number.GetAsInt64: Int64;
begin
  Result := FValue;
end;

procedure TJSONInt64Number.SetAsInt64(const AValue: Int64);
begin
  FValue := AValue;
end;

function TJSONInt64Number.GetAsBoolean: Boolean;
begin
  Result:=FValue<>0;
end;

function TJSONInt64Number.GetAsFloat: TJSONFloat;
begin
  Result:= FValue;
end;

function TJSONInt64Number.GetAsInteger: Integer;
begin
  Result := FValue;
end;

procedure TJSONInt64Number.SetAsBoolean(const AValue: Boolean);
begin
  FValue:=Ord(AValue);
end;

procedure TJSONInt64Number.SetAsFloat(const AValue: TJSONFloat);
begin
  FValue:=Round(AValue);
end;

procedure TJSONInt64Number.SetAsInteger(const AValue: Integer);
begin
  FValue:=AValue;
end;

function TJSONInt64Number.GetAsJSON: TJSONStringType;
begin
  Result:=AsString;
end;

function TJSONInt64Number.GetAsString: TJSONStringType;
begin
  Result:=IntToStr(FValue)
end;

procedure TJSONInt64Number.SetAsString(const AValue: TJSONStringType);
begin
  FValue:=StrToInt64(AValue);
end;

function TJSONInt64Number.GetValue: variant;
begin
  Result:=FValue;
end;

procedure TJSONInt64Number.SetValue(const AValue: variant);
begin
  FValue:=AValue;
end;

constructor TJSONInt64Number.Create(AValue: Int64);
begin
  FValue := AValue;
end;

class function TJSONInt64Number.NumberType: TJSONNumberType;
begin
  Result:=ntInt64;
end;

procedure TJSONInt64Number.Clear;
begin
  FValue:=0;
end;

function TJSONInt64Number.Clone: TJSONData;

begin
  Result:=TJSONInt64Number.Create(Self.FValue);
end;

{ TJSONArray }

function TJSONArray.GetBooleans(Index : Integer): Boolean;
begin
  Result:=Items[Index].AsBoolean;
end;

function TJSONArray.GetArrays(Index : Integer): TJSONArray;
begin
  Result:=Items[Index] as TJSONArray;
end;

function TJSONArray.GetFloats(Index : Integer): TJSONFloat;
begin
  Result:=Items[Index].AsFloat;
end;

function TJSONArray.GetIntegers(Index : Integer): Integer;
begin
  Result:=Items[Index].AsInteger;
end;

function TJSONArray.GetInt64s(Index : Integer): Int64;
begin
  Result:=Items[Index].AsInt64;
end;

function TJSONArray.GetNulls(Index : Integer): Boolean;
begin
  Result:=Items[Index].IsNull;
end;

function TJSONArray.GetObjects(Index : Integer): TJSONObject;
begin
  Result:=Items[Index] as TJSONObject;
end;

function TJSONArray.GetStrings(Index : Integer): TJSONStringType;
begin
  Result:=Items[Index].AsString;
end;

function TJSONArray.GetTypes(Index : Integer): TJSONType;
begin
  Result:=Items[Index].JSONType;
end;

procedure TJSONArray.SetArrays(Index : Integer; const AValue: TJSONArray);
begin
  Items[Index]:=AValue;
end;

procedure TJSONArray.SetBooleans(Index : Integer; const AValue: Boolean);

begin
  Items[Index]:=TJSonBoolean.Create(AValue);
end;

procedure TJSONArray.SetFloats(Index : Integer; const AValue: TJSONFloat);
begin
  Items[Index]:=TJSONFloatNumber.Create(AValue);
end;

procedure TJSONArray.SetIntegers(Index : Integer; const AValue: Integer);
begin
  Items[Index]:=TJSONIntegerNumber.Create(AValue);
end;

procedure TJSONArray.SetInt64s(Index : Integer; const AValue: Int64);
begin
  Items[Index]:=TJSONInt64Number.Create(AValue);
end;

procedure TJSONArray.SetObjects(Index : Integer; const AValue: TJSONObject);
begin
  Items[Index]:=AValue;
end;

procedure TJSONArray.SetStrings(Index : Integer; const AValue: TJSONStringType);
begin
  Items[Index]:=TJSONString.Create(AValue);
end;

procedure TJSONArray.Converterror(From: Boolean);
begin
  If From then
    Raise EJSON.Create(SErrCannotConvertFromArray)
  else
    Raise EJSON.Create(SErrCannotConvertToArray);
end;

{$warnings off}
function TJSONArray.GetAsBoolean: Boolean;
begin
  ConvertError(True);
end;

function TJSONArray.GetAsFloat: TJSONFloat;
begin
  ConvertError(True);
end;

function TJSONArray.GetAsInteger: Integer;
begin
  ConvertError(True);
end;

function TJSONArray.GetAsInt64: Int64;
begin
  ConvertError(True);
end;

procedure TJSONArray.SetAsBoolean(const AValue: Boolean);
begin
  ConvertError(False);
end;

procedure TJSONArray.SetAsFloat(const AValue: TJSONFloat);
begin
  ConvertError(False);
end;

procedure TJSONArray.SetAsInteger(const AValue: Integer);
begin
  ConvertError(False);
end;
procedure TJSONArray.SetAsInt64(const AValue: Int64);
begin
  ConvertError(False);
end;
{$warnings on}

function TJSONArray.GetAsJSON: TJSONStringType;

Var
  I : Integer;

begin
  Result:='[';
  For I:=0 to Count-1 do
    begin
    Result:=Result+Items[i].AsJSON;
    If (I<Count-1) then
      Result:=Result+', '
    end;
  Result:=Result+']';
end;

{$warnings off}

Function IndentString(Options : TFormatOptions; Indent : Integer) : TJSONStringType;

begin
  If (foUseTabChar in Options) then
    Result:=StringofChar(#9,Indent)
  else
    Result:=StringOfChar(' ',Indent);  
end;

Function TJSONArray.DoFormatJSON(Options : TFormatOptions; CurrentIndent, Indent : Integer) : TJSONStringType; 

Var
  I : Integer;
  
begin
  Result:='[';
  if not (foSingleLineArray in Options) then
    Result:=Result+sLineBreak;
  For I:=0 to Count-1 do
    begin
    if not (foSingleLineArray in Options) then
      Result:=Result+IndentString(Options, CurrentIndent+Indent);
    Result:=Result+Items[i].DoFormatJSON(Options,CurrentIndent+Indent,Indent);
    If (I<Count-1) then
      if (foSingleLineArray in Options) then
        Result:=Result+', '
      else
        Result:=Result+',';
    if not (foSingleLineArray in Options) then
      Result:=Result+sLineBreak
    end;
 if not (foSingleLineArray in Options) then
    Result:=Result+IndentString(Options, CurrentIndent);
  Result:=Result+']';
end;


function TJSONArray.GetAsString: TJSONStringType;
begin
  ConvertError(True);
end;

procedure TJSONArray.SetAsString(const AValue: TJSONStringType);
begin
  ConvertError(False);
end;

function TJSONArray.GetValue: variant;
begin
  ConvertError(True);
end;

procedure TJSONArray.SetValue(const AValue: variant);
begin
  ConvertError(False);
end;
{$warnings on}

function TJSONArray.GetCount: Integer;
begin
  Result:=Flist.Count;
end;

function TJSONArray.GetItem(Index: Integer): TJSONData;
begin
  Result:=FList[Index] as TJSONData;
end;

procedure TJSONArray.SetItem(Index: Integer; const AValue: TJSONData);
begin
  If (Index=FList.Count) then
    FList.Add(AValue)
  else
    FList[Index]:=AValue;
end;

constructor TJSONArray.Create;
begin
  Flist:=TFPObjectList.Create(True);
end;

Function VarRecToJSON(Const Element : TVarRec; const SourceType : String) : TJSONData;

begin
  Result:=Nil;
  With Element do
    case VType of
      vtInteger    : Result:=TJSONIntegerNumber.Create(VInteger);
      vtBoolean    : Result:=TJSONBoolean.Create(VBoolean);
      vtChar       : Result:=TJSONString.Create(VChar);
      vtExtended   : Result:=TJSONFloatNumber.Create(VExtended^);
      vtString     : Result:=TJSONString.Create(vString^);
      vtAnsiString : Result:=TJSONString.Create(AnsiString(vAnsiString));
      vtPChar      : Result:=TJSONString.Create(StrPas(VPChar));
      vtPointer    : If (VPointer<>Nil) then
                       Raise EJSON.CreateFmt(SErrPointerNotNil,[SourceType])
                     else
                       Result:=TJSONNull.Create;
      vtCurrency   : Result:=TJSONFloatNumber.Create(vCurrency^);
      vtInt64      : Result:=TJSONInt64Number.Create(vInt64^);
      vtObject     : if (VObject is TJSONData) then
                       Result:=TJSONData(VObject)
                     else
                       Raise EJSON.CreateFmt(SErrNotJSONData,[VObject.ClassName,SourceType]);
      //vtVariant    :
    else
      Raise EJSON.CreateFmt(SErrUnknownTypeInConstructor,[SourceType,VType])
    end;
end;

constructor TJSONArray.Create(Const Elements: array of const);

Var
  I : integer;
  J : TJSONData;

begin
  Create;
  For I:=Low(Elements) to High(Elements) do
    begin
    J:=VarRecToJSON(Elements[i],'Array');
    Add(J);
    end;
end;

Destructor TJSONArray.Destroy;
begin
  FreeAndNil(FList);
  inherited Destroy;
end;

class function TJSONArray.JSONType: TJSONType;
begin
  Result:=jtArray;
end;

function TJSONArray.Clone: TJSONData;

Var
  A : TJSONArray;
  I : Integer;

begin
  A:=TJSONArray.Create;
  try
    For I:=0 to Count-1 do
      A.Add(Self.Items[I].Clone);
    Result:=A;
  except
    A.Free;
    Raise;
  end;
end;

procedure TJSONArray.Iterate(Iterator: TJSONArrayIterator; Data: TObject);

Var
  I : Integer;
  Cont : Boolean;
  
begin
  I:=0;
  Cont:=True;
  While (I<FList.Count) and cont do
    begin
    Iterator(Items[i],Data,Cont);
    Inc(I);
    end;
end;

function TJSONArray.IndexOf(obj: TJSONData): Integer;
begin
  Result:=FList.IndexOf(Obj);
end;

procedure TJSONArray.Clear;
begin
  FList.Clear;
end;

function TJSONArray.Add(Item: TJSONData): Integer;
begin
  Result:=FList.Add(Item);
end;

function TJSONArray.Add(I: Integer): Integer;
begin
  Result:=Add(TJSONIntegerNumber.Create(I));
end;

function TJSONArray.Add(I: Int64): Int64;
begin
  Result:=Add(TJSONInt64Number.Create(I));
end;

function TJSONArray.Add(const S: String): Integer;
begin
  Result:=Add(TJSONString.Create(S));
end;

function TJSONArray.Add: Integer;
begin
  Result:=Add(TJSONNull.Create);
end;

function TJSONArray.Add(F: TJSONFloat): Integer;
begin
  Result:=Add(TJSONFloatNumber.Create(F));
end;

function TJSONArray.Add(B: Boolean): Integer;
begin
  Result:=Add(TJSONBoolean.Create(B));
end;

function TJSONArray.Add(AnArray: TJSONArray): Integer;
begin
  If (IndexOf(AnArray)<>-1) then
    Raise EJSON.Create(SErrCannotAddArrayTwice);
  Result:=Add(TJSONData(AnArray));
end;

function TJSONArray.Add(AnObject: TJSONObject): Integer;
begin
  If (IndexOf(AnObject)<>-1) then
    Raise EJSON.Create(SErrCannotAddObjectTwice);
  Result:=Add(TJSONData(AnObject));
end;

procedure TJSONArray.Delete(Index: Integer);
begin
  FList.Delete(Index);
end;

procedure TJSONArray.Exchange(Index1, Index2: Integer);
begin
  FList.Exchange(Index1, Index2);
end;

procedure TJSONArray.Insert(Index: Integer);
begin
  Insert(Index,TJSONNull.Create);
end;

procedure TJSONArray.Insert(Index: Integer; Item: TJSONData);
begin
  FList.Insert(Index, Item);
end;

procedure TJSONArray.Insert(Index: Integer; I: Integer);
begin
  FList.Insert(Index, TJSONIntegerNumber.Create(I));
end;

procedure TJSONArray.Insert(Index: Integer; I: Int64);
begin
  FList.Insert(Index, TJSONInt64Number.Create(I));
end;

procedure TJSONArray.Insert(Index: Integer; const S: String);
begin
  FList.Insert(Index, TJSONString.Create(S));
end;

procedure TJSONArray.Insert(Index: Integer; F: TJSONFloat);
begin
  FList.Insert(Index, TJSONFloatNumber.Create(F));
end;

procedure TJSONArray.Insert(Index: Integer; B: Boolean);
begin
  FList.Insert(Index, TJSONBoolean.Create(B));
end;

procedure TJSONArray.Insert(Index: Integer; AnArray: TJSONArray);
begin
  if (IndexOf(AnArray)<>-1) then
    raise EJSON.Create(SErrCannotAddArrayTwice);
  FList.Insert(Index, AnArray);
end;

procedure TJSONArray.Insert(Index: Integer; AnObject: TJSONObject);
begin
  if (IndexOf(AnObject)<>-1) then
    raise EJSON.Create(SErrCannotAddObjectTwice);
  FList.Insert(Index, AnObject);
end;

procedure TJSONArray.Move(CurIndex, NewIndex: Integer);
begin
  FList.Move(CurIndex, NewIndex);
end;

procedure TJSONArray.Remove(Item: TJSONData);
begin
  FList.Remove(Item);
end;

{ TJSONObject }

function TJSONObject.GetArrays(Const AName : String): TJSONArray;
begin
  Result:=GetElements(AName) as TJSONArray;
end;

function TJSONObject.GetBooleans(Const AName : String): Boolean;
begin
  Result:=GetElements(AName).AsBoolean;
end;

function TJSONObject.GetElements(Const AName: string): TJSONData;
begin
  Result:=TJSONData(FHash.Find(AName));
  If (Result=Nil) then
    Raise EJSON.CreateFmt(SErrNonexistentElement,[AName]);
end;

function TJSONObject.GetFloats(Const AName : String): TJSONFloat;
begin
  Result:=GetElements(AName).AsFloat;
end;

function TJSONObject.GetIntegers(Const AName : String): Integer;
begin
  Result:=GetElements(AName).AsInteger;
end;

function TJSONObject.GetInt64s(Const AName : String): Int64;
begin
  Result:=GetElements(AName).AsInt64;
end;

function TJSONObject.GetIsNull(Const AName : String): Boolean;
begin
  Result:=GetElements(AName).IsNull;
end;

function TJSONObject.GetNameOf(Index: Integer): TJSONStringType;
begin
  Result:=FHash.NameOfIndex(Index);
end;

function TJSONObject.GetObjects(const AName : String): TJSONObject;
begin
  Result:=GetElements(AName) as TJSONObject;
end;

function TJSONObject.GetStrings(const AName : String): TJSONStringType;
begin
  Result:=GetElements(AName).AsString;
end;

function TJSONObject.GetTypes(const AName : String): TJSONType;
begin
  Result:=Getelements(Aname).JSONType;
end;

procedure TJSONObject.SetArrays(const AName : String; const AValue: TJSONArray);

begin
  SetElements(AName,AVAlue);
end;

procedure TJSONObject.SetBooleans(const AName : String; const AValue: Boolean);
begin
  SetElements(AName,TJSONBoolean.Create(AVAlue));
end;

procedure TJSONObject.SetElements(const AName: string; const AValue: TJSONData);
Var
  Index : Integer;

begin
  Index:=FHash.FindIndexOf(AName);
  If (Index=-1) then
    FHash.Add(AName,AValue)
  else
    FHash.Items[Index]:=AValue; // Will free the previous value.
end;

procedure TJSONObject.SetFloats(const AName : String; const AValue: TJSONFloat);
begin
  SetElements(AName,TJSONFloatNumber.Create(AVAlue));
end;

procedure TJSONObject.SetIntegers(const AName : String; const AValue: Integer);
begin
  SetElements(AName,TJSONIntegerNumber.Create(AVAlue));
end;

procedure TJSONObject.SetInt64s(const AName : String; const AValue: Int64);
begin
  SetElements(AName,TJSONInt64Number.Create(AVAlue));
end;

procedure TJSONObject.SetIsNull(const AName : String; const AValue: Boolean);
begin
  If Not AValue then
    Raise EJSON.Create(SErrCannotSetNotIsNull);
  SetElements(AName,TJSONNull.Create);
end;

procedure TJSONObject.SetObjects(const AName : String; const AValue: TJSONObject);
begin
  SetElements(AName,AValue);
end;

procedure TJSONObject.SetStrings(const AName : String; const AValue: TJSONStringType);
begin
  SetElements(AName,TJSONString.Create(AVAlue));
end;

procedure TJSONObject.Converterror(From: Boolean);
begin
  If From then
    Raise EJSON.Create(SErrCannotConvertFromObject)
  else
    Raise EJSON.Create(SErrCannotConvertToObject);
end;

{$warnings off}
function TJSONObject.GetAsBoolean: Boolean;
begin
  ConvertError(True);
end;

function TJSONObject.GetAsFloat: TJSONFloat;
begin
  ConvertError(True);
end;

function TJSONObject.GetAsInteger: Integer;
begin
  ConvertError(True);
end;

function TJSONObject.GetAsInt64: Int64;
begin
  ConvertError(True);
end;

procedure TJSONObject.SetAsBoolean(const AValue: Boolean);
begin
  ConvertError(False);
end;

procedure TJSONObject.SetAsFloat(const AValue: TJSONFloat);
begin
  ConvertError(False);
end;

procedure TJSONObject.SetAsInteger(const AValue: Integer);
begin
  ConvertError(False);
end;

procedure TJSONObject.SetAsInt64(const AValue: Int64);
begin
  ConvertError(False);
end;
{$warnings on}

function TJSONObject.GetAsJSON: TJSONStringType;

Var
  I : Integer;

begin
  Result:='';
  For I:=0 to Count-1 do
    begin
    If (Result<>'') then
      Result:=Result+', ';
    Result:=Result+'"'+StringToJSONString(Names[i])+'" : '+Items[I].AsJSON;
    end;
  If (Result<>'') then
    Result:='{ '+Result+' }'
  else
    Result:='{}';
end;

{$warnings off}
function TJSONObject.GetAsString: TJSONStringType;
begin
  ConvertError(True);
end;

procedure TJSONObject.SetAsString(const AValue: TJSONStringType);
begin
  ConvertError(False);
end;

function TJSONObject.GetValue: variant;
begin
  ConvertError(True);
end;

procedure TJSONObject.SetValue(const AValue: variant);
begin
  ConvertError(False);
end;
{$warnings on}

function TJSONObject.GetCount: Integer;
begin
  Result:=FHash.Count;
end;

function TJSONObject.GetItem(Index: Integer): TJSONData;
begin
  Result:=TJSONData(FHash.Items[Index]);
end;

procedure TJSONObject.SetItem(Index: Integer; const AValue: TJSONData);
begin
  FHash.Items[Index]:=AValue;
end;

constructor TJSONObject.Create;
begin
  FHash:=TFPHashObjectList.Create(True);
end;



constructor TJSONObject.Create(const Elements: array of const);

Var
  I : integer;
  AName : String;
  J : TJSONData;

begin
  Create;
  If ((High(Elements)-Low(Elements)) mod 2)=0 then
    Raise EJSON.Create(SErrOddNumber);
  I:=Low(Elements);
  While I<=High(Elements) do
    begin
    With Elements[i] do
      Case VType of
        vtChar       : AName:=VChar;
        vtString     : AName:=vString^;
        vtAnsiString : AName:=(AnsiString(vAnsiString));
        vtPChar      : AName:=StrPas(VPChar);
      else
        Raise EJSON.CreateFmt(SErrNameMustBeString,[I+1]);
      end;
    If (ANAme='') then
      Raise EJSON.CreateFmt(SErrNameMustBeString,[I+1]);
    Inc(I);
    J:=VarRecToJSON(Elements[i],'Object');
    Add(AName,J);
    Inc(I);
    end;
end;


destructor TJSONObject.Destroy;
begin
  FreeAndNil(FHash);
  inherited Destroy;
end;

class function TJSONObject.JSONType: TJSONType;
begin
  Result:=jtObject;
end;

function TJSONObject.Clone: TJSONData;

Var
  O : TJSONObject;
  I: Integer;

begin
  O:=TJSONObject.Create;
  try
    For I:=0 to Count-1 do
      O.Add(Self.Names[I],Self.Items[I].Clone);
    Result:=O;
  except
    FreeAndNil(O);
    Raise;
  end;
end;


Function TJSONObject.DoFormatJSON(Options : TFormatOptions; CurrentIndent, Indent : Integer) : TJSONStringType; 

Var
  i : Integer;
  S : TJSONStringType;


begin
  CurrentIndent:=CurrentIndent+Indent;  
  For I:=0 to Count-1 do
    begin
    If (Result<>'') then
      begin
      If (foSingleLineObject in Options) then
        Result:=Result+', '
      else
        Result:=Result+','+SLineBreak;
      end;
    If not (foSingleLineObject in Options) then    
      Result:=Result+IndentString(Options,CurrentIndent);
    S:=StringToJSONString(Names[i]);
    If not (foDoNotQuoteMembers in options) then
      S:='"'+S+'"';
    Result:=Result+S+' : '+Items[I].DoFormatJSON(Options,CurrentIndent,Indent);
    end;
  If (Result<>'') then
    begin
    if (foSingleLineObject in Options) then
      Result:='{ '+Result+' }'
    else  
      Result:='{'+sLineBreak+Result+sLineBreak+indentString(options,CurrentIndent-Indent)+'}'
    end
  else
    Result:='{}';
end;

procedure TJSONObject.Iterate(Iterator: TJSONObjectIterator; Data: TObject);

Var
  I : Integer;
  Cont : Boolean;

begin
  I:=0;
  Cont:=True;
  While (I<FHash.Count) and cont do
    begin
    Iterator(Names[I],Items[i],Data,Cont);
    Inc(I);
    end;
end;

function TJSONObject.IndexOf(Item: TJSONData): Integer;
begin
  Result:=FHash.IndexOf(Item);
end;

function TJSONObject.IndexOfName(const AName: TJSONStringType; CaseInsensitive : Boolean = False): Integer;

begin
  Result:=FHash.FindIndexOf(AName);
  if (Result=-1) and CaseInsensitive then
    begin
    Result:=Count-1;
    While (Result>=0) and (CompareText(Names[Result],AName)<>0) do
      Dec(Result);
    end;
end;

procedure TJSONObject.Clear;
begin
  FHash.Clear;
end;

function TJSONObject.Add(const AName: TJSONStringType; AValue: TJSONData
  ): Integer;
begin
  Result:=FHash.Add(AName,AValue);
end;

function TJSONObject.Add(const AName: TJSONStringType; AValue: Boolean
  ): Integer;
begin
  Result:=Add(AName,TJSONBoolean.Create(AValue));
end;

function TJSONObject.Add(const AName: TJSONStringType; AValue: TJSONFloat): Integer;
begin
  Result:=Add(AName,TJSONFloatNumber.Create(AValue));
end;

function TJSONObject.Add(const AName, AValue: TJSONStringType): Integer;
begin
  Result:=Add(AName,TJSONString.Create(AValue));
end;

function TJSONObject.Add(const AName: TJSONStringType; Avalue: Integer): Integer;
begin
  Result:=Add(AName,TJSONIntegerNumber.Create(AValue));
end;

function TJSONObject.Add(const AName: TJSONStringType; Avalue: Int64): Integer;
begin
  Result:=Add(AName,TJSONInt64Number.Create(AValue));
end;

function TJSONObject.Add(const AName: TJSONStringType): Integer;
begin
  Result:=Add(AName,TJSONNull.Create);
end;

function TJSONObject.Add(const AName: TJSONStringType; AValue: TJSONArray
  ): Integer;
begin
  Result:=Add(AName,TJSONData(AValue));
end;

procedure TJSONObject.Delete(Index: Integer);
begin
  FHash.Delete(Index);
end;

procedure TJSONObject.Delete(Const AName: string);

Var
  I : Integer;

begin
  I:=IndexOfName(AName);
  if (I<>-1) then
    Delete(I);
end;

procedure TJSONObject.Remove(Item: TJSONData);
begin
  FHash.Remove(Item);
end;

function TJSONObject.Extract(Index: Integer): TJSONData;
begin
  Result:=Items[Index];
  FHash.Extract(Result);
end;

function TJSONObject.Extract(const AName: string): TJSONData;

Var
  I : Integer;

begin
  I:=IndexOfName(AName);
  if (I<>-1) then
    Result:=Extract(I)
  else
    Result:=Nil
end;

function TJSONObject.Get(const AName: String; ADefault: TJSONFloat
  ): TJSONFloat;

Var
  D : TJSONData;

begin
  D:=Find(AName,jtNumber);
  If D<>Nil then
    Result:=D.AsFloat
  else
    Result:=ADefault;
end;

function TJSONObject.Get(const AName: String; ADefault: Integer
  ): Integer;

Var
  D : TJSONData;

begin
  D:=Find(AName,jtNumber);
  If D<>Nil then
    Result:=D.AsInteger
  else
    Result:=ADefault;
end;

function TJSONObject.Get(const AName: String; ADefault: Int64): Int64;
Var
  D : TJSONData;

begin
  D:=Find(AName,jtNumber);
  If D<>Nil then
    Result:=D.AsInt64
  else
    Result:=ADefault;
end;

function TJSONObject.Get(const AName: String; ADefault: Boolean
  ): Boolean;
Var
  D : TJSONData;

begin
  D:=Find(AName,jtBoolean);
  If D<>Nil then
    Result:=D.AsBoolean
  else
    Result:=ADefault;
end;

function TJSONObject.Get(const AName: String; ADefault: TJSONStringType
  ): TJSONStringType;
Var
  D : TJSONData;

begin
  D:=Find(AName,jtString);
  If (D<>Nil) then
    Result:=D.AsString
  else
    Result:=ADefault;
end;

function TJSONObject.Get(const AName: String; ADefault: TJSONArray
  ): TJSONArray;
Var
  D : TJSONData;

begin
  D:=Find(AName,jtArray);
  If (D<>Nil) then
    Result:=TJSONArray(D)
  else
    Result:=ADefault;
end;

function TJSONObject.Get(const AName: String; ADefault: TJSONObject
  ): TJSONObject;
Var
  D : TJSONData;

begin
  D:=Find(AName,jtObject);
  If (D<>Nil) then
    Result:=TJSONObject(D)
  else
    Result:=ADefault;
end;

function TJSONObject.Find(const AName: String): TJSONData;

Var
  I : Integer;

begin
  I:=IndexOfName(AName);
  If (I<>-1) then
    Result:=Items[i]
  else
    Result:=Nil;
end;

function TJSONObject.Find(const AName: String; AType: TJSONType): TJSONData;
begin
  Result:=Find(AName);
  If Assigned(Result) and (Result.JSONType<>AType) then
    Result:=Nil;
end;

end.

