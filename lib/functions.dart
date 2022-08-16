// ignore_for_file: non_constant_identifier_names

import 'dart:math' as math;

double PI = math.pi;

double Degrees(double rad) => rad / math.pi * 180;
double Radians(double deg) => deg / 180 * math.pi;

double Sqrt(double x) => math.sqrt(x);

double Sin(double x) => math.sin(Radians(x));
double Cos(double x) => math.cos(Radians(x));
double Tan(double x) => math.tan(Radians(x));

double aSin(double x) => Degrees(math.asin(x));
double aCos(double x) => Degrees(math.acos(x));
double aTan(double x) => Degrees(math.atan(x));
