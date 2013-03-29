uses GraphABC,ListUtils;
const
  RAD=5;
  MARGIN=4;
type 
//  coor=record
//    x:integer;
//    y:integer;
//  end;
  Vertex=class
    public
      constructor create(coorx,coory:integer);
      constructor create(coorx,coory:integer;vname:string);
      function getx:integer;
      function gety:integer;
      procedure setx(coorx:integer);
      procedure sety(coory:integer);
      procedure setvert(coorx,coory:integer);
      procedure draw(r:word);
    private
      x:integer;
      y:integer;
      vertname:string;
  end;
constructor Vertex.create(coorx,coory:integer);
  begin
    x:=coorx;
    y:=coory;
  end;
constructor Vertex.create(coorx,coory:integer;vname:string);
  begin
    create(coorx,coory);
    vertname:=vname;
  end;
function Vertex.getx:integer;
  begin
    getx:=x;
  end;
function Vertex.gety:integer; 
  begin
    gety:=y;
  end;
procedure Vertex.setx(coorx:integer);
  begin
    x:=coorx;
  end;
procedure Vertex.sety(coory:integer);
  begin
    y:=coory;
  end;
procedure Vertex.setvert(coorx,coory:integer);
  begin
    x:=coorx;
    y:=coory;
  end;
procedure Vertex.draw(r:word);
  begin
    SetPenColor(color.Black);
    SetBrushColor(Color.Black);
    Circle(x,y,r); 
  end;
type
  Edge = class
    public
      constructor create( vert1,vert2:Vertex); 
      function get1vert:Vertex;
      function get2vert:Vertex; 
      procedure draw;
    private
      vertpoint1:Vertex; 
      vertpoint2:Vertex;
  end;
constructor Edge.create(vert1,vert2:Vertex);
  begin
    vertpoint1:=vert1;
    vertpoint2:=vert2;
  end;
function Edge.get1vert:Vertex;
  begin
    get1vert:=vertpoint1;
  end;
function Edge.get2vert:Vertex;
  begin
    get2vert:=vertpoint2;
  end;
procedure Edge.draw;
  var x1,y1,x2,y2:integer;
  begin
    x1:=get1vert.getx;
    y1:=get1vert.gety;
    x2:=get2vert.getx;
    y2:=get2vert.gety;
    SetPenColor(Color.Black);
    line(x1,y1,x2,y2); 
  end;
type
  NearPredicate = class (Predicate<Vertex>)
    public
      constructor create(valx,valy,valrad:integer);
      function check(val:Vertex):boolean;
    private
      x:integer;
      y:integer;
      radius:integer;
  end;
constructor NearPredicate.create(valx,valy,valrad:integer);
  begin
    x:=valx;
    y:=valy;
    radius:=valrad;
  end;
function NearPredicate.check(val:Vertex):boolean;
  begin
    check:= SQR(val.x-x)+SQR(val.y-y)<=SQR(radius);
  end;
var vlist:List<Vertex>;
    edglist:List<Edge>;
    edg1vert,vertdrag:Vertex;
procedure printcoor(x,y:integer);
  begin
    SetFontSize(10); //ширина - 8-9,высота - 14
    SetFontColor(Color.Black);
    SetBrushColor(Color.White);
    TextOut(WindowWidth-100,2,inttostr(x)+' '+inttostr(y));
    SetPenColor(Color.Black);
  end;
procedure ClearAll;
  begin
    SetBrushColor(Color.White);
    SetPenColor(Color.White); 
    FillRect(-20,0,WindowWidth+20,WindowHeight+20);
  end;
procedure redrawall;
  var viter:iterator<Vertex>;
      edgiter:iterator<Edge>;
  begin
    LockDrawing;
    ClearAll;
    viter:=vlist.getBegin;
    while viter.hasNext do
      viter.takeNext.draw(RAD);
    edgiter:=edglist.getBegin;
    while edgiter.hasNext do
      edgiter.takeNext.draw;
    UnlockDrawing;
  end; 
procedure MouseUp(x,y,mb: integer);
  begin
    vertdrag:=nil;
  end;
procedure MouseDown(x,y,mb: integer);
  var iter:Iterator<Vertex>;
      nearpr:NearPredicate;
  begin
    nearpr:=new NearPredicate(x,y,RAD+1);
    iter:=vlist.find(nearpr);
    if not iter.hasnext then begin
      if mb=1 then begin
        vlist.push(new Vertex(x,y));
        vlist.getLast.draw(RAD);
        if edg1vert<>nil then begin
          //assert(vlist.getLast.getx=x,'getx<>x!');
          edglist.push(new Edge(edg1vert,vlist.getLast));
          edg1vert:=nil;
          redrawall;
        end;
      end;
      if (mb=2) and (edg1vert<>nil) then begin
        edg1vert:=nil;
        redrawall;
      end;
    end
    else begin
      if mb=1 then begin
        vertdrag:=iter.getNext;
        if edg1vert=nil then edg1vert:=iter.getNext
        else begin
          edglist.push(new Edge(edg1vert,iter.getNext));
          edg1vert:=nil;
          redrawall;
        end;
      end;
      if mb=2 then begin
        vlist.remove(iter);
        redrawall;
      end;
    end;
  end;
procedure keyU(key:integer);
  begin
    if key=vk_c then begin
      vlist :=new List<Vertex>;
      edglist := new List<Edge>;
      ClearAll;
    end;
//    if maxn<numvert then maxn:=numvert;
    if key=vk_e then CloseWindow;
    //TODO if (key=VK_ControlKey) then ctrl:=false;
    {if (key=VK_z) and (k=2) then begin
      k:=1;
      numedg:=numedg-1;
    end;}
//    if (key=vk_z) and (numvert<>0) then begin
//      LockDrawing;
//      ClearWindow;
//      numvert:=numvert-1;
//      for var i:=1 to numvert do
//        drawvert(i);
//      UnlockDrawing;
//    end;
  end;
procedure keyD(key:integer);
  begin
    {TODO if (key=VK_ControlKey) then ctrl:=true;
    if (key=VK_Z) and ctrl then writeln(2);}
  end;
procedure MouseMove(x,y,mb: integer);
  begin
    printcoor(x,y);
    if (mb=1) and (vertdrag<>nil) then begin
      {if (x>RAD-2) and (x<WindowWidth-RAD+2) and (y>RAD-2) and (y<WindowHeight-RAD+1) then begin
        v[vdragind].x:=x;
        v[vdragind].y:=y;
        redrawall;
      end};
      edg1vert:=nil;
      if (x<MARGIN) then x:=MARGIN;
      if (x>WindowWidth-MARGIN) then x:=WindowWidth-MARGIN;
      if (y<MARGIN) then y:=MARGIN;
      if (y>WindowHeight-MARGIN) then y:=WindowHeight-MARGIN;
      vertdrag.setvert(x,y);
      redrawall;
    end;
  //  if mb=2 then  begin
  //    SetPenColor(color.White);
  //    SetBrushColor(Color.White);
  //    Rectangle(x-10,y-10,x+10,y+10);
  //  end;
  end;
begin
  //ctrl:=false;
  SetWindowSize(800,600);
  vertdrag:=nil;
  edg1vert:=nil;
  vlist:=new List<Vertex>;
  edglist:= new List<Edge>;
  OnMouseDown := MouseDown;
  OnMouseMove := MouseMove;
  OnMouseUp:= MouseUp;
  OnKeyUp:= keyU;
  OnKeyDown:= keyD;
end.