(*
  ElectrostaticsPackage.m
  
  A simple package demonstrating how to define constants, 
  a potential function, and convenience plotting functions 
  for two point charges.
  
  Usage:
    << ElectrostaticsPackage`
    
    Potential[x, y, charges]
    PlotPotential3D[charges, xRange, yRange]
    PlotPotentialContour[charges, xRange, yRange]
*)

(* -------------------------------------------- *)
(*  Start of Package Context                   *)
(* -------------------------------------------- *)
BeginPackage["ElectrostaticsPackage`"];

(* ::Section:: *)
(* Usage Messages *)

charge1posx::usage = "charge1posx is the x-position of the first charge."
charge1posy::usage = "charge1posy is the y-position of the first charge."
charge1q::usage    = "charge1q is the magnitude of the first charge."

charge2posx::usage = "charge2posx is the x-position of the second charge."
charge2posy::usage = "charge2posy is the y-position of the second charge."
charge2q::usage    = "charge2q is the magnitude of the second charge."

charges::usage     = "charges is a list of charge data in the form {{x1, y1, q1}, {x2, y2, q2}, ...}."

Potential::usage   = 
  "Potential[x, y, chargeList] returns the total electric potential at (x, y) due to a list of point charges.\n" <>
  "Each charge in the list is specified as {xi, yi, qi}."

PlotPotential3D::usage = 
  "PlotPotential3D[chargeList, {xMin, xMax}, {yMin, yMax}] plots a 3D surface of the potential over the specified region."

PlotPotentialContour::usage = 
  "PlotPotentialContour[chargeList, {xMin, xMax}, {yMin, yMax}] plots a contour map of the potential over the specified region."

(* -------------------------------------------- *)
(*  Private Context: Implementation            *)
(* -------------------------------------------- *)
Begin["`Private`"];

(*** Define the charge parameters ***)
charge1posx = 0.5;
charge1posy = 0.0;
charge1q    = 1.0;

charge2posx = -0.5;
charge2posy =  0.0;
charge2q    = 1.0;

(* Group charges into a list. 
   Feel free to generalize if you want more charges. *)
charges = {
  {charge1posx, charge1posy, charge1q},
  {charge2posx, charge2posy, charge2q}
};

(*** Define the Potential function ***)
Potential[x_, y_, chargeList_] := 
  Total[
    chargeList /. {
      {xi_?NumericQ, yi_?NumericQ, qi_?NumericQ} :>
        qi / Sqrt[(x - xi)^2 + (y - yi)^2]
    }
  ];

(*** Define a 3D Plot convenience function ***)
PlotPotential3D[chargeList_List, {xMin_, xMax_}, {yMin_, yMax_}, opts : OptionsPattern[]] := 
  Plot3D[
    Potential[x, y, chargeList],
    {x, xMin, xMax},
    {y, yMin, yMax},
    PlotRange -> {{-3, 3}, {-3, 3}, {-30, 30}},
    Contours -> 50,
    ColorFunction -> "TemperatureMap",
    PlotLegends -> BarLegend[Automatic, LegendLabel -> "Potential"],
    AxesLabel -> {Style["x(cm)", FontSize -> 20], Style["y(cm)", FontSize -> 20], Style["Potential(x,y)", FontSize -> 20]},
    Evaluate@FilterRules[{opts}, Options[Plot3D]]
  ];

PlotPotentialContour[chargeList_List, {xMin_, xMax_}, {yMin_, yMax_}, opts : OptionsPattern[]] :=
  ContourPlot[
    Potential[x, y, chargeList],
    {x, xMin, xMax},
    {y, yMin, yMax},
    PlotRange -> {{-3, 3}, {-3, 3}, {-30, 30}},
    Contours -> 100,
    ColorFunction -> "TemperatureMap",
    PlotLegends -> BarLegend[Automatic, LegendLabel -> "Potential"],
    PlotLabel -> "Contour Plot of Potential",
    AxesLabel -> {"x", "y"},
    Evaluate@FilterRules[{opts}, Options[ContourPlot]]
  ];

PlotAndSavePotential[chargeList_List, {xMin_, xMax_}, {yMin_, yMax_}, outFile_String] := Module[
  {val, plotObj},
  
  (* 1) Compute the potential at (1,1). *)
  val = Potential[1, 1, chargeList];
  
  (* 2) Create a 3D plot of the potential over {xMin,xMax} x {yMin,yMax}. *)
  plotObj = PlotPotential3D[chargeList, {xMin, xMax}, {yMin, yMax}];
  
  (* 3) Export that plot to a PDF file at the specified path. *)
  Export[outFile, plotObj];
  
  (* Return the numeric potential value for convenience. *)
  val
];

End[];  (* End Private Context *)

EndPackage[];

