//
//  Setup.swift
//  LeakLite
//
//  Created by macuser on 9/28/17.
//  Copyright © 2017 Rick Smith. All rights reserved.
//

import Foundation

var mIntSetupUploadIndex = 0
var mInSetupReceiveIndex = 1
var mVerNumber = ""
var mSerialNumber = ""
var mSensorName = ""
var mstrTemperatureUnit = ""
var mstrPressureUnit = ""
var mstrFlowUnit = ""
var ValveSteps = 0
var CurrentTT = 0
var PreviousTT = 0
//var K = [[Double]]()
var K : [[Double]] = Array(repeating: Array(repeating: 0, count: 15), count: 4)
var V : [[Double]] = Array(repeating: Array(repeating: 0, count: 15), count: 4)
//var T = [[u_long]]()
var T : [[Int]] = Array(repeating: Array(repeating: 0, count: 15), count: 4)
var L : [String] = Array(repeating: "", count: 15)
var A4:Double = 0.0
var mdbl_Density:Double = 0.0
var mdbl_Pres:Double = 0.0
var FourthAI = false




var mCommand : [Int : String] = [
    1 : "!00RU2;",
    2 : "!00SQ3;0",
    3 : "!00RT1;",
    4 : "!00RT2;",
    5 : "!00RT3;",
    6 : "!00RT4;",
    7 : "!00RT5;",
    8 : "!00RT6;",
    9 : "!00RT7;",
    10 : "!00RT8;",
    11 : "!00RT9;",
    12 : "!00RTA;",
    13 : "!00RTB;",
    14 : "!00RTC;",
    15 : "!00RTD;",
    16 : "!00RK1;",
    17 : "!00RK2;",
    18 : "!00RK3;",
    19 : "!00RK4;",
    20 : "!00RK5;",
    21 : "!00RK6;",
    22 : "!00RK7;",
    23 : "!00RK9;",
    24 : "!00RKA;",
    25 : "!00RV1;",
    26 : "!00RV2;",
    27 : "!00RV3;",
    28 : "!00RV4;",
    29 : "!00RV5;",
    30 : "!00RV6;",
    31 : "!00RV7;",
    32 : "!00SQ3;1",
    33 : "!00RT1;",
    34 : "!00RT2;",
    35 : "!00RT3;",
    36 : "!00RT4;",
    37 : "!00RT5;",
    38 : "!00RT6;",
    39 : "!00RT7;",
    40 : "!00RT8;",
    41 : "!00RT9;",
    42 : "!00RTA;",
    43 : "!00RTB;",
    44 : "!00RTC;",
    45 : "!00RTD;",
    46 : "!00RK1;",
    47 : "!00RK2;",
    48 : "!00RK3;",
    49 : "!00RK4;",
    50 : "!00RK5;",
    51 : "!00RK6;",
    52 : "!00RK7;",
    53 : "!00RK9;",
    54 : "!00RKA;",
    55 : "!00RV1;",
    56 : "!00RV2;",
    57 : "!00RV3;",
    58 : "!00RV4;",
    59 : "!00RV5;",
    60 : "!00RV6;",
    61 : "!00RV7;",
    62 : "!00SQ3;2",
    63 : "!00RT1;",
    64 : "!00RT2;",
    65 : "!00RT3;",
    66 : "!00RT4;",
    67 : "!00RT5;",
    68 : "!00RT6;",
    69 : "!00RT7;",
    70 : "!00RT8;",
    71 : "!00RT9;",
    72 : "!00RTA;",
    73 : "!00RTB;",
    74 : "!00RTC;",
    75 : "!00RTD;",
    76 : "!00RK1;",
    77 : "!00RK2;",
    78 : "!00RK3;",
    79 : "!00RK4;",
    80 : "!00RK5;",
    81 : "!00RK6;",
    82 : "!00RK7;",
    83 : "!00RK9;",
    84 : "!00RKA;",
    85 : "!00RV1;",
    86 : "!00RV2;",
    87 : "!00RV3;",
    88 : "!00RV4;",
    89 : "!00RV5;",
    90 : "!00RV6;",
    91 : "!00RV7;",
    92 : "!00SQ3;3",
    93 : "!00RT1;",
    94 : "!00RT2;",
    95 : "!00RT3;",
    96 : "!00RT4;",
    97 : "!00RT5;",
    98 : "!00RT6;",
    99 : "!00RT7;",
    100 : "!00RT8;",
    101 : "!00RT9;",
    102 : "!00RTA;",
    103 : "!00RTB;",
    104 : "!00RTC;",
    105 : "!00RTD;",
    106 : "!00RK1;",
    107 : "!00RK2;",
    108 : "!00RK3;",
    109 : "!00RK4;",
    110 : "!00RK5;",
    111 : "!00RK6;",
    112 : "!00RK7;",
    113 : "!00RK9;",
    114 : "!00RKA;",
    115 : "!00RV1;",
    116 : "!00RV2;",
    117 : "!00RV3;",
    118 : "!00RV4;",
    119 : "!00RV5;",
    120 : "!00RV6;",
    121 : "!00RV7;",
    122 : "!00RU3;",
    123 : "!00RU4;",
    124 : "!00RA4;",
    125 : "!00RL1;",
    126 : "!00RL2;",
    127 : "!00RL3;",
    128 : "!00RL4;",
    129 : "!00RL5;",
    130 : "!00RL6;",
    131 : "!00RL7;",
    132 : "!00RL8;",
    133 : "!00RL9;",
    134 : "!00RLA;",
    135 : "!00RLB;",
    136 : "!00RLC;",
    137 : "!00RLD;",
    138 : "!00RLE;",
    139 : "!00RS1;",
    140 : "!00RS2;",
    141 : "!00RU5;",
    142 : "!00SQ3;0",
    143 : "!00RQ3;",
    144 : "!00RQ3;",
    145 : "!00RQ3;",
    146 : "!00RQ3;"
]
