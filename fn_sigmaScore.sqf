params ["_x_", "_yCoef", "_xCoef"];
scopeName "main";

_yCoef * 2 / (1 + exp(_xCoef * -_x_)) - _yCoef;
