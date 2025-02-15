# Snapshots of code


## Visualize potential of a 2D charge distribution

```
packageFile = 
  "/Users/ginnocen/Desktop/8022Mathematica/ElectrostaticsPackage.m";
Get[packageFile];

myCharges = {{1, 0, 3}, {-1, 0, 1}, {-1, -1, -2}};
PlotPotential3D[myCharges, {-3, 3}, {-3, 3}]
PlotPotentialContour[myCharges, {-3, 3}, {-3, 3}]
```
