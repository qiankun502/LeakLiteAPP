//
//  SelfDefinedFunction.swift
//  LeakLite
//
//  Created by macuser on 9/27/17.
//  Copyright © 2017 Rick Smith. All rights reserved.
//

import Foundation


public func GetTotalTime(CurrentTT: Int, ValveSteps: Int) -> Double
{
    var TinSec: Double = 0.0
    if (ValveSteps > 1)
    {
        for i in 1...ValveSteps
        {
            TinSec = TinSec + (Double(T[CurrentTT][i]))/100
        }
    }
    return TinSec
}

public func STRtoINT(str: String) -> Int
{
    var num = 0
    var c: Int
    switch (str) {
    case "0","1","2","3","4","5","6","7","8","9":
        c = Int(UnicodeScalar(str)!.value)
        num = c - Int(UnicodeScalar("0")!.value)
    case "A","B","C","D","E","F":
        c = Int(UnicodeScalar(str)!.value)
        num = 10 + c - Int(UnicodeScalar("A")!.value)
    case "a","b","c","d","e","f":
        c = Int(UnicodeScalar(str)!.value)
        num = 10 + c - Int(UnicodeScalar("a")!.value)
    default:
        num = 0
    }
    return num
}

public func GetValveStepNumber(U2str: String) -> Int
{
    let strLength = U2str.characters.count
//    let valvestep = STRtoINT(str: U2str.substringWithRange(Range<String.Index>(start: U2str.startIndex.advanced(by: 2, end:U2str.endIndex.advanced(by: 3)))))
 //   let start = U2str.index(U2str.startIndex, offsetBy: strLength-6)
 //   let end = U2str.index(U2str.endIndex, offsetBy: strLength-5)
 //   let range = start..<end
 //   let valvestep = STRtoINT( str: U2str.substring(with: range) )
    let valvestep = STRtoINT(str: GetSubstring(FullStr: U2str, Start: (strLength - 5), End: (strLength - 4)))
    return valvestep
}


public func Check4thAI(U2str: String) -> Bool
{
    let strLength=U2str.count
    let tempint=STRtoINT(str: GetSubstring(FullStr: U2str, Start: strLength-5, End: strLength-4))
    let has4thAI:Bool=((tempint & 1) == 1)
    return has4thAI
}



public func GetTempUnit(U3str: String) -> String
{
    switch (U3str)
    {
    case "0":
        return "Deg C"
    case "1":
        return "Deg F"
    default:
        return "Deg C"
    }
}

public func GetSubstring(FullStr: String, Start: Int, End: Int) -> String
{
    var SelectStr: String = ""
    var endindex=0
    if (FullStr.count==0){
        SelectStr=""
        print("empty string")
        return SelectStr
    }
    if (FullStr.count<Start){
        SelectStr=""
        print( "string too short")
        return SelectStr
    }
    if (FullStr.count<End){
      endindex = FullStr.count
        print( "string too short")
    }
    else
    {
        endindex=End
    }
    let start = FullStr.index(FullStr.startIndex, offsetBy: Start)
    let end = FullStr.index(FullStr.startIndex, offsetBy: endindex)
    let range = start..<end
    
    SelectStr=FullStr.substring(with: range)  // play
    return SelectStr
}

////////////////////////////////////////////////////////////
public func GetPressureUnit(U4str: String) -> String
{
    let numstr = U4str.components(separatedBy: "\n")

    switch (numstr[0])
    {
        case "0x0":
            return "kPa"
        case "0x1":
            return  "kg/cm2"
        case "0x2":
            return  "psia"
        case "0x3":
            return  "igHg"
        case "0x4":
            return  "inH2o"
        case "0x5":
            return  "psig"
        case "0x6":
            return  "Torr"
        case "0x7":
            return  "kPa-g"
        case "0x8":
            return  "bar-a"
        default:
            return "kPa"
    }
}

///////////////////////////////////////////////////////////
public func GetFlowUnit(U5str: String) -> String
{
    var flowunit,HighNibble,LowNibble: String
    let numstr1 = U5str.components(separatedBy: "0x")
    var numstr2 = numstr1[1].components(separatedBy: "\n")
    
    var tempstr: String
    
    if (numstr2[0].count == 1)
    {
        tempstr = "0" + numstr2[0]
    }
    else
    {
        tempstr = numstr2[0]
    }
    
    //String num1[],num2[];
    //num1 = U5str.split("0x");
    //num2 = num1[1].split("\n");
    //if (num2[0].substring(0).length()==1)
    //num2[0]="0"+num2[0];
    
    let start = tempstr.index(tempstr.startIndex, offsetBy: 1)
    
    
    switch (tempstr.substring(to: start))
    {
    case "7":
        if (tempstr.substring(to: start)=="4")
        {
            flowunit="SCCSe-6"
        }
        else{
            flowunit="SCCM"
        }
        return flowunit

    case "8":
        flowunit="SLM"
        return flowunit

    case "9":
        flowunit="SCFM"
        return flowunit

    case "0":
        HighNibble="cc"

    case "1":
        HighNibble="mm3"

    case "2":
        HighNibble="liter"

    case "3":
        HighNibble="gal"

    case "4":
        HighNibble="gram"

    case "5":
        HighNibble="mg"

    case "6":
        HighNibble="ug"

    default:
        HighNibble="cc"

    }
    
    switch (tempstr.substring(from: start))
    {
    case "0":
        LowNibble="sec"

    case "1":
        LowNibble="min"

    case "2":
        LowNibble="hr"

    default:
        LowNibble="sec"

    }
    flowunit=HighNibble + "/"+LowNibble;
    return flowunit;
}

public func AnytoCCMIN(indata: Double, strUnit: String) -> Double
{
    var outData = 0.0
    switch (strUnit)
    {
    case "cc/sec":
        outData=indata*60

    case "cc/min":
        outData=indata

    case "cc/hr":
        outData=indata/60.0;
        break;
    case "liter/sec":
        outData=indata*1000*60;
        break;
    case "liter/min":
        outData=indata*1000;
        break;
    case "liter/hr":
        outData=indata / 60;
        break;
    case "gal/sec":
        outData=indata * 3785.412 * 60;
        break;
    case "gal/min":
        outData=indata * 3785.412;
        break;
    case "gal/hr":
        outData=indata * 3785.412 / 60;
        break;
    case "mm3/sec":
        outData=indata / 1000.0 * 60;
        break;
    case "mm3/min":
        outData=indata/1000.0;
        break;
    case "mm3/hr":
        outData=indata/1000.0/60;
        break;
        
    case "gram/sec":
        outData=indata/mdbl_Density * 101.325 / mdbl_Pres * 1000*60/6.83;
        break;
    case "gram/min":
        outData=indata/mdbl_Density * 101.325 / mdbl_Pres * 1000/6.83;
        break;
    case "gram/hr":
        outData=indata/mdbl_Density * 101.325 / mdbl_Pres * 1000/60/6.83;
        break;
    case "mg/sec":
        outData=indata/mdbl_Density * 101.325 / mdbl_Pres * 60/6.83;
        break;
    case "mg/min":
        outData=indata/mdbl_Density * 101.325 / mdbl_Pres / 6.83;
        break;
    case "mg/hr":
        outData=indata/mdbl_Density * 101.325 / mdbl_Pres / 60/6.83;
        break;
    case "ug/sec":
        outData=indata/mdbl_Density * 101.325 / mdbl_Pres  / 1000/60/6.83;
        break;
    case "ug/min":
        outData=indata/mdbl_Density * 101.325 / mdbl_Pres / 1000/6.83;
        break;
    case "ug/hr":
        outData=indata/mdbl_Density * 101.325 / mdbl_Pres / 1000/60/6.83;
        break;
        
    case "SCCM":
        outData=indata * 101.325 / mdbl_Pres / 6.83;
        break;
    case "SLM":
        outData=indata * 101.325 / mdbl_Pres * 1000/6.83;
        break;
    case "SCFM":
        outData=indata * 101.325 / mdbl_Pres*28316 / 6.83;
        break;
    case "SCCSe6":
        outData=indata * 101.325 / mdbl_Pres * 60/1000000.0 / 6.83;
        break;
    default:
        outData=indata;
        break;
    }
    return outData;
}

////////////////////////////////////////////////////////////////////////
public func AnytoKPA(inData: Double, strUnit: String) -> Double
{
    var outData = 0.0
    if (strUnit=="")
    {
        return 0;
    }
    
    switch (strUnit) {
    case "psig":
        outData = inData * 6.894757 + A4;
        break;
    case "kg/cm2":
        outData=inData*98.0665;
        break;
    case  "psia":
        outData = inData * 6.894757;
        break;
    case  "igHg":
        outData = inData  * 3.386388;
        break;
    case  "Torr":
        outData = inData  * 0.1333224;
        break;
    case  "kPa-g":
        outData = inData  + A4;
        break;
    case  "bar-a":
        outData = inData  * 100;
        break;
    default:
        outData = inData  ;
        break;
    }
    return outData;
}



////////////////////////////////////////////////////////////////////////
public func KPAtoAny(inData: Double, strUnit: String) -> Double
{
    var outData = 0.0
    if (strUnit=="")
    {
        return 0;
    }
    switch (strUnit) {
    case "psig":
        outData = (inData - A4 ) / 6.894757 ;
        break;
    case "kg/cm2":
        outData=inData/98.0665;
        break;
    case  "psia":
        outData = inData / 6.894757;
        break;
    case  "igHg":
        outData = inData  / 3.386388;
        break;
    case  "Torr":
        outData = inData  / 0.1333224;
        break;
    case  "kPa-g":
        outData = inData  - A4;
        break;
    case  "bar-a":
        outData = inData  / 100;
        break;
    default:
        outData = inData  ;
        break;
    }
    return outData;
}


public func GetStatusStr(Hexstr: String) -> (statusStr: String, bRunning: Bool)
    {
        var strStep: String
        var mbRunning = false
        
        switch (Hexstr)
        {
        case "0":
            strStep="Idle"

        case "1","2","3","4","5","6","7":
            strStep="Testing"
            mbRunning=true
        case "8","9","A":
            strStep="Stop"
        case "B","C","D","E":
            strStep="Unknow status"
        case "16":
            strStep="Pass"
        case "17":
            strStep="Pass-Relative"
        case "18":
            strStep="Pass-Reference"
        case "19":
            strStep="Pass-SSF"
        case "21":
            strStep="Pressure Saturated"
        case "22":
            strStep="Flow Saturated"
        case "23":
            strStep="Temp Saturated"
        case "24":
            strStep="GrossLeak"
        case "25":
            strStep="Fine Leak"
        case "26":
            strStep="Low Flow"
        case "27":
            strStep="Over Pressure"
        case "28":
            strStep="Back Flow"
        case "29":
            strStep="Blockage"
        case "2A":
            strStep="No Pressure"
        case "2B":
            strStep="Hi Flow-RM"
        case "2C":
            strStep="Low Flow-RM"
        case "2D":
            strStep="Large Leak"
        case "2E":
            strStep="Under Pressure"
        case "2F":
            strStep="Gross Leak V"
        case "30":
            strStep="PresRang High"
        case "31":
            strStep="PresRang Low"
        case "32":
            strStep="Ext Gross Leak"
        case "33":
            strStep="Ext Over Pressure"
        case "34":
            strStep="Ext Under Pressure"
        case "35":
            strStep="Ext Gross Leak V"
        default:
            strStep="Idle"

        
        }
        return (strStep, mbRunning)
    }


