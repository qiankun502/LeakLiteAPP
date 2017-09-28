//
//  SelfDefinedFunction.swift
//  LeakLite
//
//  Created by macuser on 9/27/17.
//  Copyright © 2017 Rick Smith. All rights reserved.
//

import Foundation

import Charts




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

