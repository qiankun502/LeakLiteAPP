//
//  MainViewController.swift
//  CompassCompanion
//
//  Created by Rick Smith on 04/07/2016.
//  Copyright © 2016 Rick Smith. All rights reserved.
//

import UIKit
import CoreBluetooth
import Charts
import Foundation

class MainViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
    var manager:CBCentralManager? = nil
    var mainPeripheral:CBPeripheral? = nil
    var mainCharacteristic:CBCharacteristic? = nil
    var time=0
    var rxState = 0
    var stringAll=""
    var mblreceivedSQ = true
    var dollars = [0]
    var yVals : [ChartDataEntry] = [ChartDataEntry]()

    var PastTime = NSDate().timeIntervalSince1970
    
    @IBOutlet weak var lbltimer: UILabel!
    
   
    @IBOutlet weak var lblFlowReading: UILabel!
    
    @IBOutlet weak var lblIntPresReading: UILabel!
    @IBOutlet weak var lblExtPresReading: UILabel!
    @IBOutlet weak var lblTempReading: UILabel!
    
    @IBOutlet weak var lblFlowUnit: UILabel!
    @IBOutlet weak var lblPresUnit: UILabel!
    @IBOutlet weak var lblExtPresUnit: UILabel!
    @IBOutlet weak var lblTemperatureUnit: UILabel!

    @IBOutlet weak var lblFlowRange: UILabel!
    @IBOutlet weak var lblPresRange: UILabel!
    @IBOutlet weak var lblExPresRange: UILabel!
    
    @IBOutlet weak var lblStatus: UILabel!
 
    
    let BLEService = "49535343-FE7D-4AE5-8FA9-9FAFD205E455"//"DFB0"
    let BLECharacteristic = "49535343-8841-43F4-A8D4-ECBE34729BB3"//DFB1"
     let BLECharacteristicRec = "49535343-1E4D-4BD9-BA61-23C647249616"
     var timer = Timer()
    
    @IBOutlet weak var recievedMessageText: UILabel!
    
    @IBOutlet weak var lineChartView: LineChartView!
    override func viewDidLoad() {
        super.viewDidLoad()
        manager = CBCentralManager(delegate: self, queue: nil);
        customiseNavigationBar()
        //self.lineChartView.delegate = self
 /*       self.lineChartView.chartDescription?.textColor = UIColor.white
        self.lineChartView.gridBackgroundColor = UIColor.gray
        
        
        lineChartView.setVisibleXRange(minXRange: 0, maxXRange: 100)
        self.lineChartView.setVisibleXRangeMaximum(50)
        let xAxis=lineChartView.xAxis
        xAxis.axisMinimum=0
        xAxis.axisMaximum=50
 
        yVals.append(ChartDataEntry(x: Double(0), y: 0))
*/
        //setChartData(months:months)
        //setChartData()
        
        timer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(MainViewController.sendCommand), userInfo: nil, repeats: true)
    }
  //////////////////////////////////////////////////
    //Send ount command
 /*   func sendComd()
    {
        time+=1;
        if (mainPeripheral != nil) {
            sendCommand()
        }
        lbltimer.text=String(time)
    }*/
    ///////////////////////////////////////////////////
    
    
    @IBAction func StartTest(_ sender: UIButton)
    {
        let Command = "!00SM1;8\r"
        let dataToSend = Command.data(using: String.Encoding.utf8)
        
        if (mainPeripheral != nil) {
            mainPeripheral?.writeValue(dataToSend!, for: mainCharacteristic!, type: .withResponse)
        }
     PastTime = NSDate().timeIntervalSince1970
    }
    
    @IBAction func TestTypeSwitch(_ sender: Any)
    {
        let Command = "!00SM1;6\r"
        let dataToSend = Command.data(using: String.Encoding.utf8)
        
        if (mainPeripheral != nil) {
            mainPeripheral?.writeValue(dataToSend!, for: mainCharacteristic!, type: .withResponse)
        }
    }
    
    
    @IBAction func StopTest(_ sender: UIButton)
    {
        let Command = "!00SM1;9\r"
        let dataToSend = Command.data(using: String.Encoding.utf8)
        
        if (mainPeripheral != nil) {
            mainPeripheral?.writeValue(dataToSend!, for: mainCharacteristic!, type: .withResponse)
        }    }
    
    
    func customiseNavigationBar () {
        
        self.navigationItem.rightBarButtonItem = nil
        
        let rightButton = UIButton()
        
        if (mainPeripheral == nil) {
            rightButton.setTitle("Scan", for: [])
            rightButton.setTitleColor(UIColor.blue, for: [])
            rightButton.frame = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 60, height: 30))
            rightButton.addTarget(self, action: #selector(self.scanButtonPressed), for: .touchUpInside)
        } else {
            rightButton.setTitle("Disconnect", for: [])
            rightButton.setTitleColor(UIColor.blue, for: [])
            rightButton.frame = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 100, height: 30))
            rightButton.addTarget(self, action: #selector(self.disconnectButtonPressed), for: .touchUpInside)
        }
        
        let rightBarButton = UIBarButtonItem()
        rightBarButton.customView = rightButton
        self.navigationItem.rightBarButtonItem = rightBarButton
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "scan-segue") {
            let scanController : ScanTableViewController = segue.destination as! ScanTableViewController
            
            //set the manager's delegate to the scan view so it can call relevant connection methods
            manager?.delegate = scanController
            scanController.manager = manager
            scanController.parentView = self
        }
        
    }
    
    // MARK: Button Methods
    func scanButtonPressed() {
        performSegue(withIdentifier: "scan-segue", sender: nil)
    }
    
    func disconnectButtonPressed() {
        //this will call didDisconnectPeripheral, but if any other apps are using the device it will not immediately disconnect
        manager?.cancelPeripheralConnection(mainPeripheral!)
    }
    
    @IBAction func sendButtonPressed(_ sender: AnyObject) {
        if (mainPeripheral != nil) {
        sendCommand()
        }
            
       // mainPeripheral?.readValue(for: <#T##CBCharacteristic#>)
    }
    
    ////////////////////////////////////////////////////
    func sendCommand()
    {
        let Command = "!00SQ1;5\r"
        let dataToSend = Command.data(using: String.Encoding.utf8)
        
        if (mainPeripheral != nil) {
     //       if  (mblreceivedSQ == true)
     //       {
                mainPeripheral?.writeValue(dataToSend!, for: mainCharacteristic!, type: .withResponse)
                 mblreceivedSQ = false
     //       }
        }
    }
    ////////////////////////////////////////////////////////////////////
    
    // MARK: - CBCentralManagerDelegate Methods    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        mainPeripheral = nil
        customiseNavigationBar()
        print("Disconnected" + peripheral.name!)
    }
    
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print(central.state)
    }
    
    // MARK: CBPeripheralDelegate Methods
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        for service in peripheral.services! {
            
            print("Service found with UUID: " + service.uuid.uuidString)
            //Bluno Service
            if (service.uuid.uuidString == BLEService) {
                peripheral.discoverCharacteristics(nil, for: service)
            }
            
        }
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?)
    {
 
        if (service.uuid.uuidString == BLEService) {
            
            for characteristic in service.characteristics! {
                if (characteristic.uuid.uuidString == BLECharacteristicRec) {
                    peripheral.readValue(for: characteristic)
                    peripheral.setNotifyValue(true, for: characteristic)
                    //  peripheral.readValueForCharacteristic(for: characteristic)
                    print("Found a Device notify Characteristic")
                    
                }
                    
                if (characteristic.uuid.uuidString == BLECharacteristic) {
                   // peripheral.readValue(for: characteristic)
                    print("Found a Device Manufacturer Name Characteristic")
                    mainCharacteristic=characteristic
                } else if (characteristic.uuid.uuidString == "2A23") {
                    //peripheral.readValue(for: characteristic)
                    print("Found System ID")
                }
            }
        }
    }
  
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?)
    {
        if (characteristic.uuid.uuidString == BLECharacteristic)
        {
            //data recieved
            if(characteristic.value != nil)
            {
                let stringValue = String(data: characteristic.value!, encoding: String.Encoding.utf8)!
                recievedMessageText.text = stringValue
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?)
    {
        var stringValue=String()
        
        if (characteristic.uuid.uuidString == BLECharacteristicRec)
        {
            //data recieved
            if(characteristic.value != nil)
            {
                stringValue = String(data: characteristic.value!, encoding: String.Encoding.utf8)!
                
                if (stringValue.contains("SQ")) || (stringValue.contains("RU")) || (stringValue.contains("RT"))||(stringValue.contains("RK"))||(stringValue.contains("RV"))||(stringValue.contains("RQ") )||(stringValue.contains("SA"))||(stringValue.contains("RL"))||(stringValue.contains("RS"))
                {
                    stringAll=""
                    rxState=GlobalConstants.RX_START
                }
                if (stringValue.contains("\r"))||(stringValue.contains("\n"))
                {
                    stringAll=stringAll+stringValue
                    rxState=GlobalConstants.RX_DONE
                    recievedMessageText.text = stringAll
                    ParseMessage(Message: stringAll)
                }
                else
                {
                    stringAll=stringAll+stringValue
                }
                
                
            }
        }
    }
    
    func readValue(characteristic: CBCharacteristic!) {
        if characteristic != nil {
            mainPeripheral?.readValue(for: characteristic)
            mainPeripheral?.setNotifyValue(true, for: characteristic)
        } else {
            mainPeripheral?.discoverServices(nil)
        }
    }
    ////////////////////////////////////////////////////////////////////////////////////////
    func ParseMessage(Message:String)
    {
        var flow, press, extpres, temp, statusHex :String

        if Message.range(of: GlobalConstants.SQCOMMD) != nil
        {
            var datamessage = Message.components(separatedBy: GlobalConstants.SQCOMMD)
            var data=datamessage[1].components(separatedBy: ";")
            temp=data[0]
            press=data[1]
            flow=data[2]
            extpres = data[3]
            statusHex = data[4]
            let start = flow.index(flow.startIndex, offsetBy: 5)
            
            lblFlowReading.text = flow.substring(to: start)
            lblIntPresReading.text=press.substring(to: start)
            lblExtPresReading.text=extpres.substring(to: start)
            lblTempReading.text=temp.substring(to: start)
            lblStatus.text=statusHex
            mblreceivedSQ = true
           // setChartData()
        }
    }
    ////////////////////////////////////////////////////////////////////////////////////////
    
    @objc func setChartData()
    {
        
        let timediff = NSDate().timeIntervalSince1970 - PastTime
        yVals.append(ChartDataEntry(x: Double(timediff), y: 1))
        let set2: LineChartDataSet = LineChartDataSet(values: yVals, label: "flow")
        set2.axisDependency = .left // Line will correlate with left axis values
        set2.setColor(UIColor.red.withAlphaComponent(0.5)) // our line's opacity is 50%
        set2.setCircleColor(UIColor.red) // our circle will be dark red
        set2.lineWidth = 2.0
        set2.circleRadius = 1.0 // the radius of the node circle
        set2.fillAlpha = 65 / 255.0
        set2.fillColor = UIColor.red
        set2.highlightColor = UIColor.white
        set2.drawCircleHoleEnabled = true
        //3 - create an array to store our LineChartDataSets
        var dataSets2 : [LineChartDataSet] = [LineChartDataSet]()
        dataSets2.append(set2)
        //4 - pass our months in for our x-axis label value along with our dataSets
        
        let data2: LineChartData = LineChartData(dataSets: dataSets2)
        data2.setValueTextColor(UIColor.white)
        self.lineChartView.data = data2
        //       self.lineChartView.setVisibleXRangeMaximum(50)
        //        let xAxis=lineChartView.xAxis
        //        xAxis.axisMinimum=0
        //        xAxis.axisMaximum=50
        // self.lineChartView.setVisibleXRange(minXRange: 0, maxXRange: 200)
        //6 - add x-axis label
    }
/*
    func setChartData(months : [String])
    {
        datalength=Double(months.count)
        // 1 - creating an array of data entries
        //    var yVals1 : [ChartDataEntry] = [ChartDataEntry]()
        /*
         for i in 0..<months.count {
         yVals1.append(ChartDataEntry(x: Double(i), y: dollars[i]))
         }
         
         // 2 - create a data set with our array
         let set1: LineChartDataSet = LineChartDataSet(values: yVals1, label: "First Set")
         
         set1.axisDependency = .left // Line will correlate with left axis values
         set1.setColor(UIColor.red.withAlphaComponent(0.5)) // our line's opacity is 50%
         set1.setCircleColor(UIColor.red) // our circle will be dark red
         set1.lineWidth = 2.0
         set1.circleRadius = 2.0 // the radius of the node circle
         set1.fillAlpha = 65 / 255.0
         set1.fillColor = UIColor.red
         set1.highlightColor = UIColor.white
         set1.drawCircleHoleEnabled = true
         //3 - create an array to store our LineChartDataSets
         var dataSets : [LineChartDataSet] = [LineChartDataSet]()
         dataSets.append(set1)
         //4 - pass our months in for our x-axis label value along with our dataSets
         //let data: LineChartData = LineChartData(dataSets: dataSets)
         //       data.setValueTextColor(UIColor.white)
         
         ////5 - finally set our data
         //self.lineChartView.data.
         //        self.lineChartView.data = data
         
         */
        
        
        //       for i in 0..<months.count {
        //           yVals2.append(ChartDataEntry(x: Double(i), y: dollars1[i]))
        //       }
        let set2: LineChartDataSet = LineChartDataSet(values: yVals2, label: "Second Set")
        set2.axisDependency = .left // Line will correlate with left axis values
        set2.setColor(UIColor.red.withAlphaComponent(0.5)) // our line's opacity is 50%
        set2.setCircleColor(UIColor.red) // our circle will be dark red
        set2.lineWidth = 2.0
        set2.circleRadius = 2.0 // the radius of the node circle
        set2.fillAlpha = 65 / 255.0
        set2.fillColor = UIColor.red
        set2.highlightColor = UIColor.white
        set2.drawCircleHoleEnabled = true
        //3 - create an array to store our LineChartDataSets
        var dataSets2 : [LineChartDataSet] = [LineChartDataSet]()
        dataSets2.append(set2)
        //4 - pass our months in for our x-axis label value along with our dataSets
        
        let data2: LineChartData = LineChartData(dataSets: dataSets2)
        data2.setValueTextColor(UIColor.white)
        //5 - finally set our data
        //self.lineChartView.data.
        self.lineChartView.data = data2
        
        
        
        
        //6 - add x-axis label
        let xaxis = self.lineChartView.xAxis
        xaxis.valueFormatter = MyXAxisFormatter(months)
    }*/
}


class MyXAxisFormatter: NSObject, IAxisValueFormatter {
    
    let months: [String]
    
    init(_ months: [String]) {
        self.months = months
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return months[Int(value)]
    }
}


