uses GraphABC;
const RAD=4;
type 
//  coor=record
//    x:integer;
//    y:integer;
//  end;
  vertex=record
    x:integer;
    y:integer;
  end;
  edge=record
    ind1:byte; 
    ind2:byte;
  end;
var k:1..2;numvert,{maxn,}numedg:word;
    v:array [1..100] of vertex;
    u:array [1..100] of edge;
    vdragind:word;
function isinside(centx,centy,x,y:integer;r:integer):boolean;
  begin
    isinside:=sqrt(SQR(centx-x)+SQR(centy-y))<=r;
  end;
function findv(x,y:integer;r:integer;var pind:word):boolean;
  var found:boolean;
      i:word;
  begin
    found:=false;
    for i:=1 to numvert do begin
      if isinside(v[i].x,v[i].y,x,y,r) then begin
        found:=true;
        pind:=i;
        break;
      end;
    end;
    findv:=found;
  end;
procedure printcoor(x,y:integer);
  begin
    SetFontSize(10); //ширина - 8-9,высота - 14
    SetFontColor(Color.Black);
    SetBrushColor(Color.White);
    TextOut(WindowWidth-100,2,inttostr(x)+' '+inttostr(y));
    SetPenColor(Color.Black);
  end;
procedure drawvert(indvert:word);
  var x,y:integer;
  begin
    x:=v[indvert].x;
    y:=v[indvert].y;
    SetPenColor(color.Black);
    SetBrushColor(Color.Black);
    Circle(x,y,RAD);
    SetFontSize(6);
    SetFontColor(Color.Red);
    SetBrushColor(Color.Transparent);
    TextOut(x-4,y+rad+2,inttostr(indvert)); //ширина - 5-6,высота - 8
  end;
procedure drawedge(indedge:word);
  var edg:edge;
      v1,v2:vertex;
  begin
    edg:=u[indedge];
    v1:=v[edg.ind1];
    v2:=v[edg.ind2];
    SetPenColor(Color.Black);
    line(v1.x,v1.y,v2.x,v2.y);
  end;
procedure redrawall;
  var i:word;
  begin
    LockDrawing;
    ClearWindow;
    for i:=1 to numvert do
      drawvert(i);
    for i:=1 to numedg do
      drawedge(i);
    UnlockDrawing;
  end; 
procedure MouseUp(x,y,mb: integer);
  begin
    vdragind:=0;
  end;
procedure MouseDown(x,y,mb: integer);
  var vind:word;
  begin
    if not findv(x,y,RAD+1,vind) then begin
      if mb=1 then begin
        Inc(numvert);
        v[numvert].x:=x;
        v[numvert].y:=y;
        drawvert(numvert);
      end;
    end
    else begin
      if mb=1 then begin
        vdragind:=vind;
      end;
      if (mb=2) and (numvert<>0) then begin
        if (k=1) then begin
          Inc(numedg);
          u[numedg].ind1:=vind;
          k:=2;
        end;
        if (k=2) and (u[numedg].ind1<>vind) then begin
          u[numedg].ind2:=vind;
          drawedge(numedg);
          k:=1;
        end;
      end;
    end;
  end;
procedure keyc(key:integer);
  begin
    if key=vk_c then begin
      numedg:=0;
      numvert:=0;
      ClearWindow;
    end;
//    if maxn<numvert then maxn:=numvert;
    if key=vk_e then CloseWindow;
    if (key=VK_z) and (k=2) then begin
      k:=1;
      numedg:=numedg-1;
    end;
//    if (key=vk_z) and (numvert<>0) then begin
//      LockDrawing;
//      ClearWindow;
//      numvert:=numvert-1;
//      for var i:=1 to numvert do
//        drawvert(i);
//      UnlockDrawing;
//    end;
  end;
procedure MouseMove(x,y,mb: integer);
  begin
    printcoor(x,y);
    if (mb=1) and (vdragind>0) then begin
      v[vdragind].x:=x;
      v[vdragind].y:=y;
      redrawall;
    end;
  //  if mb=2 then  begin
  //    SetPenColor(color.White);
  //    SetBrushColor(Color.White);
  //    Rectangle(x-10,y-10,x+10,y+10);
  //  end;
  end;
begin
  SetWindowSize(800,600);
  k:=1; numvert:=0; numedg:=0;
  vdragind:=0; 
  OnMouseDown := MouseDown;
  OnMouseMove := MouseMove;
  OnKeyUp:= keyc;
end.