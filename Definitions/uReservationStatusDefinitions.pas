﻿unit uReservationStatusDefinitions;

interface

uses
  Graphics
  ;

type
  TReservationStatus = (
      rsUnKnown,
      rsReservations,
      rsGuests,
      rsDeparting,
      rsDeparted,
      rsReserved,
      rsOverbooked,
      rsAll,
      rsCurrent,
      rsAlotment,
      rsNoShow,
      rsBlocked,
      rsCanceled,
      rsTmp1,
      rsTmp2,
      rsDeleted);

    TReservationStatusHelper = record helper for TReservationStatus
    public
      // constructor
      /// <summary>
      ///   Create a TReservationStatus from a single character status string
      /// </summary>
      class function FromResStatus(const statusStr : string) : TReservationStatus; static;
      /// <summary>
      ///   Return a single character statusstring
      /// </summary>
      function ToStatusChar: Char;
      /// <summary>
      ///   Return the translated displaystring for a reservationstatus
      /// </summary>
      function AsReadableString : string;
      /// <summary>
      ///   Return the translated displaystring for use in maingrid hints. Slightly different texts then AsReadableString
      /// </summary>
      function AsReadableHint: string;
      /// <summary>
      ///   Return the colors (back and front) set for hotel to be used for displaying reservation data
      /// </summary>
      function ToColor(var backColor, fontColor : TColor) : boolean;
    end;


const
	STATUS_NOT_ARRIVED = 'P';
  STATUS_ARRIVED = 'G';
  STATUS_CHECKED_OUT = 'D';
  STATUS_CANCELLED = 'C';
  STATUS_WAITING_LIST = 'O';
  STATUS_NO_SHOW = 'N';
  STATUS_ALLOTMENT = 'A';
  STATUS_BLOCKED = 'B';
  STATUS_CANCELED = 'C';  //*HJ 140210
  STATUS_TMP1 = 'W';  //*HJ 140210
  STATUS_AWAITING_PAYMENT = 'Z';  //*BG 140304
  STATUS_DELETED = 'X';  //*BG 140304


implementation

uses
    PrjConst
  , SysUtils
  , uG
  ;


function TReservationStatusHelper.ToStatusChar: Char;
const
  cReservationStatusChars : Array[TReservationStatus] of char =
      ('P','P','G','G','D','P','O','P','G','A','N','B','C','W','Z','X');
begin
  Result := cReservationStatusChars[Self]; 
end;


function TReservationStatusHelper.AsReadableString : string;
begin
  case Self of
    rsReservations: result := GetTranslatedText('shTx_G_Reservation');
    rsGuests:       result := GetTranslatedText('shTx_G_Guest');
    rsDeparted:     result := GetTranslatedText('shTx_G_Departed');
    rsReserved:     result := GetTranslatedText('shTx_G_Reserved');
    rsOverbooked:   result := GetTranslatedText('shTx_G_Overbooked');
    rsAlotment:     result := GetTranslatedText('shTx_G_Alotment');
    rsNoShow:       result := GetTranslatedText('shTx_G_NoShow');
    rsBlocked:      result := GetTranslatedText('shTx_G_Blocked');
    rsDeparting:    result := GetTranslatedText('shTx_G_Departing');
    rsCurrent:      result := GetTranslatedText('shTx_G_Current');
    rsCanceled:     result := GetTranslatedText('shTx_G_Canceled');
    rsTmp1:         result := GetTranslatedText('shTx_G_Tmp1');
    rsTmp2:         result := GetTranslatedText('shTx_G_Tmp2');
  else
    Result := '';
  end;
end;

function TReservationStatusHelper.AsReadableHint: string;
begin
  Result := '';
  case Self of
      rsReservations: result := GetTranslatedText('shTx_G_DueToArrive');
      rsGuests:       result := GetTranslatedText('shTx_G_CheckedIn');
//      rsDeparting,
      rsDeparted:     result := GetTranslatedText('shTx_G_CheckedOut');
//      rsReserved,
      rsOverbooked:   result := GetTranslatedText('shTx_G_WaitingList');
//      rsAll,
//      rsCurrent,
      rsAlotment:     result := GetTranslatedText('shTx_G_Alotment');
      rsNoShow:       result := GetTranslatedText('shTx_G_NoShow');
      rsBlocked:      result := GetTranslatedText('shTx_G_Blocked');
      rsCanceled:     result := GetTranslatedText('shTx_G_Canceled');
      rsTmp1:         result := GetTranslatedText('shTx_G_Tmp1');
      rsTmp2:         result := GetTranslatedText('shTx_G_Tmp2');
//      rsDeleted
  end
end;



class function TReservationStatusHelper.FromResStatus(const statusSTR : string) : TReservationStatus;
begin
  result := rsUnKnown;
  if statusStr.Length > 0 then
    case statusStr.chars[1] of
      'P': result := rsReservations;
      'G': result := rsGuests;
      'D': result := rsDeparted;
      'R': result := rsReserved;
      'O': result := rsOverbooked;
      'A': result := rsAlotment;
      'N': result := rsNoShow;
      'B': result := rsBlocked;
      'C': result := rsCanceled;
      'W': result := rsTmp1;
      'Z': result := rsTmp2;
    end;
end;


function TReservationStatusHelper.ToColor(var backColor, fontColor : TColor) : boolean;
begin
  result := false;
  case Self of
    rsReservations :
      begin
        backColor := g.qStatusAttr_Order.backgroundColor; //clRed;
        fontColor := g.qStatusAttr_Order.fontColor; //clWhite
        result := true;
      end;
    rsGuests :
      begin
        backColor := g.qStatusAttr_GuestStaying.backgroundColor; //clGreen;
        fontColor := g.qStatusAttr_GuestStaying.fontColor; //clWhite;
        result := true;
      end;
    rsDeparted :
      begin
        backColor := g.qStatusAttr_Departed.backgroundColor;
        fontColor := g.qStatusAttr_Departed.fontColor;  //clWhite;
        result := true;
      end;
    rsOverbooked :
      begin
        backColor := g.qStatusAttr_Waitinglist.backgroundColor; //clYellow;
        fontColor := g.qStatusAttr_Waitinglist.fontColor; //clBlack;
        result := true;
      end;
    rsNoShow :
      begin
        backColor := g.qStatusAttr_NoShow.backgroundColor; //clRed;
        fontColor := g.qStatusAttr_NoShow.fontColor;//clYellow;
        result := true;
      end;
    rsAlotment :
      begin
        backColor := g.qStatusAttr_Allotment.backgroundColor; //clWhite;
        fontColor := g.qStatusAttr_Allotment.fontColor;   //clRed;
        result := true;
      end;
    rsBlocked :
      begin
        backColor := g.qStatusAttr_Blocked.backgroundColor; //_tinyIntToColor(55);
        fontColor := g.qStatusAttr_Blocked.fontColor;  //_tinyIntToColor(0);
        result := true;
      end;
    rsCanceled :
      begin
        backColor := g.qStatusAttr_Canceled.backgroundColor; //;  //*HJ 140210
        fontColor := g.qStatusAttr_Canceled.fontColor;//;
        result := true;
      end;
    rsTmp1:
      begin
        backColor := g.qStatusAttr_TMP1.backgroundColor; //;  //*HJ 140210
        fontColor := g.qStatusAttr_TMP1.fontColor;//;
        result := true;
      end;
    rsTmp2 :
      begin
        backColor := g.qStatusAttr_TMP2.backgroundColor; //;   //*HJ 140210
        fontColor := g.qStatusAttr_TMP2.fontColor;//;
        result := true;
      end;
    else
      begin
        backColor := g.qStatusAttr_GuestStaying.backgroundColor; //clBlue;
        fontColor := g.qStatusAttr_GuestStaying.fontColor; // clYellow;
      end;
    end;
end;


end.