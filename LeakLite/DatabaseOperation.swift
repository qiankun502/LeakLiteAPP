//
//  DatabaseOperation.swift
//  LeakLite
//
//  Created by macuser on 1/17/18.
//  Copyright © 2018 Rick Smith. All rights reserved.
//

import Foundation
import SQLite

class Database {
    
    var leaklitdatabase: Connection!
    let ResultTable = Table("LeakResult")
    let sSetupId = Expression<String>("SetupID")
    let sTestResult = Expression<String>("Result")
    let sFinalFlow = Expression<String>("Flow")
    let sPressure = Expression<String>("Pressure")
    let sExtPressure = Expression<String> ("ExtPres")
    let sTestTime = Expression<String> ("sTime")
    let dTestTime = Expression<Double> ("dTime")
    let sSensorName = Expression <String>("SensorName")
 //   let id = Expression <Int> ("id")



    func OpenDatabase() {
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("LeakResult").appendingPathExtension("sqlite3")
            let dbresult = try Connection(fileUrl.path)
            self.leaklitdatabase = dbresult
            print("Created")
        } catch {
            print(error)
        }
        print("CREATE TAPPED")
        
        let createTable = self.ResultTable.create { (table) in
            // table.column(self.id, primaryKey: true)
            table.column(self.sSetupId)
            table.column(self.sTestResult)
            table.column(self.sFinalFlow)
            table.column(self.sPressure)
            table.column(self.sExtPressure)
            table.column(self.sTestTime)
            table.column(self.dTestTime)
            table.column(self.sSensorName)
            
        }
        
        do {
            try self.leaklitdatabase.run(createTable)
            print("Created Table")
        } catch {
            print(error)
        }
        
      /*   print("INSERT new record.")
          let alert = UIAlertController(title: "Insert User", message: nil, preferredStyle: .alert)
         alert.addTextField { (tf) in tf.placeholder = "Name" }
         alert.addTextField { (tf) in tf.placeholder = "Email" }
         let action = UIAlertAction(title: "Submit", style: .default) { (_) in
         guard let name = alert.textFields?.first?.text,
         let email = alert.textFields?.last?.text
         else { return }
         print(name)
         print(email)
         */
        /*    let insertRecord = self.ResultTable.insert( self.sSetupId <- setupid, self.sTestResult <- result, self.sFinalFlow <- flow, self.sPressure <- pressure, self.sExtPressure <- externalpres, self.sTestTime <- strtime, self.dTestTime <- dbltime, self.sSensorName <- sensorname)*/
        
        
    /*    let insertRecord = self.ResultTable.insert(self.sSetupId <- "121", self.sSensorName <- "test", self.sPressure <- "none", self.sTestResult <- "Pass", self.sFinalFlow <- "0.1", self.sExtPressure <- "1.1", self.sTestTime <- "2018", self.dTestTime <- 111111)
        do {
            try self.leaklitdatabase.run(insertRecord)
            print("INSERTED Record")
        } catch {
            print(error)
        }
        
        print("LIST TAPPED")
        
        do {
            let users = try self.leaklitdatabase.prepare(self.ResultTable)
            for user in users {
                print("userId: \(user[self.sPressure]), name: \(user[self.sSensorName]), email: \(user[self.sTestResult])")
            }
        } catch {
            print(error)
        }
        */
        
    }


    func InsertNewRecord(result: String, setupid: String, flow: String, pressure:String,externalpres:String, strtime:String, dbltime:Double, sensorname:String) {
        print("INSERT new record.")

        let insertRecord = self.ResultTable.insert(self.sTestResult <- result, self.sSetupId <- setupid, self.sFinalFlow <- flow, self.sPressure <- pressure, self.sExtPressure <- externalpres, self.dTestTime <- dbltime, self.sSensorName <- sensorname )
        do {
            try self.leaklitdatabase.run(insertRecord)
            print("INSERTED Record")
        } catch {
            print(error)
        }
    }
    //   alert.addAction(action)
    //   present(alert, animated: true, co//mpletion: ni


    func QueryRecord(startTime:Double, endtime: Double, setupid:String, sensorname:String ) ->AnySequence<Row>?{
        var filterCondition = (dTestTime > startTime) && (dTestTime < endtime)
        do {
            if setupid == "" {
                if sensorname == "" {
                    filterCondition = (dTestTime > startTime) && (dTestTime < endtime)
                }
                else {
                    filterCondition =  (dTestTime > startTime) && (dTestTime < endtime) && (sSensorName == sensorname)
                }
            }
            else {
                if sensorname == "" {
                    filterCondition =  (dTestTime>startTime) && (dTestTime<endtime) && (sSetupId == setupid)
                }
                else {
                    filterCondition =  (dTestTime>startTime) && (dTestTime<endtime) && (sSetupId == setupid) && (sSensorName == sensorname)
                }
            }
            let result = ResultTable.filter(filterCondition)
            return try leaklitdatabase.prepare(result.filter(filterCondition))
        } catch {
            // let nserror = error as NSError
            print ("Can't list result")
            return nil
        }
        
    }

    func listtestrecord() {
        print("LIST TAPPED")
  
        
        do {
      //      let users = try self.leaklitdatabase.prepare(self.ResultTable)
      //      for user in users {
      //          print("userId: \(user[self.sSetupId]), name: \(user[self.sSensorName]), email: \(user[self.sTestResult]), Time: \(user[self.sTestTime])")
            let users = QueryRecord (startTime:0, endtime:1000000, setupid: "",sensorname: "")
            for user in users! {
                print("userId: \(user[self.sPressure]), name: \(user[self.sSensorName]), email: \(user[self.sTestResult])")
            
            }
        } catch {
            print(error)
        }
    }
}
/*
    func OpenDatabase() {
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("LeakResult").appendingPathExtension("sqlite3")
            let dbresult = try Connection(fileUrl.path)
            leaklitdatabase = dbresult
            print("Created")
        } catch {
            print(error)
        }
        print("CREATE TAPPED")
        
        let createTable = ResultTable.create { (table) in
           // table.column(self.id, primaryKey: true)
            table.column(sSetupId)
            table.column(sTestResult)
            table.column(sFinalFlow)
            table.column(sPressure)
            table.column(sExtPressure)
            table.column(sTestTime)
            table.column(dTestTime)
            table.column(sSensorName)
            
        }
        
        do {
            try leaklitdatabase.run(createTable)
            print("Created Table")
        } catch {
            print(error)
        }
        
        print("INSERT new record.")

        let insertRecord = ResultTable.insert(sSetupId <- "121", sSensorName <- "test", sPressure <- "none", sTestResult <- "Pass", sFinalFlow <- "0.1", sExtPressure <- "1.1", sTestTime <- "2018", dTestTime <- 111111)
        do {
            try leaklitdatabase.run(insertRecord)
            print("INSERTED Record")
        } catch {
            print(error)
        }
        
        print("LIST TAPPED")
        
        do {
            let users = try leaklitdatabase.prepare(ResultTable)
            for user in users {
                print("userId: \(user[sPressure]), name: \(user[sSensorName]), email: \(user[sTestResult])")
            }
        } catch {
            print(error)
        }
    
    
    }


    func InsertNewRecord(result: String, setupid: String, flow: String, pressure:String,externalpres:String, strtime:String, dbltime:Double, sensorname:String) {
        print("INSERT new record.")

         let insertRecord = ResultTable.insert(dTestTime <- 1, sSensorName <- "test", sPressure <- "none")
            do {
                try leaklitdatabase.run(insertRecord)
                print("INSERTED Record")
            } catch {
                print(error)
            }
        
        }
     //   alert.addAction(action)
     //   present(alert, animated: true, co//mpletion: ni


    func QueryRecord(startTime:Double, endtime: Double, setupid:String, sensorname:String ) ->AnySequence<Row>?{
        var filterCondition = (dTestTime > startTime) && (dTestTime < endtime)
        do {
            if setupid == "" {
                if sensorname == "" {
                     filterCondition = (dTestTime > startTime) && (dTestTime < endtime)
                }
                else {
                     filterCondition =  (dTestTime > startTime) && (dTestTime < endtime) && (sSensorName == sensorname)
                }
            }
            else {
                 if sensorname == "" {
                     filterCondition =  (dTestTime>startTime) && (dTestTime<endtime) && (sSetupId == setupid)
                }
                else {
                     filterCondition =  (dTestTime>startTime) && (dTestTime<endtime) && (sSetupId == setupid) && (sSensorName == sensorname)
                }
            }
            let result = ResultTable.filter(filterCondition)
            return try leaklitdatabase.prepare(result.filter(filterCondition))
        } catch {
           // let nserror = error as NSError
            print ("Can't list result")
            return nil
        }
        
    }
    
    func listtestrecord() {
        print("LIST TAPPED")
        
        do {
            let users = try leaklitdatabase.prepare(ResultTable)
            for user in users {
                print("userId: \(user[sSetupId]), name: \(user[sSensorName]), email: \(user[sTestResult])")
            }
        } catch {
            print(error)
        }
    }
*/
//}

