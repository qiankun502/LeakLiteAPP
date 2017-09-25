//
//  MainViewController.swift
//  CompassCompanion
//
//  Created by Rick Smith on 04/07/2016.
//  Copyright © 2016 Rick Smith. All rights reserved.
//

import UIKit
import CoreBluetooth
import Foundation

class MainViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
    var manager:CBCentralManager? = nil
    var mainPeripheral:CBPeripheral? = nil
    var mainCharacteristic:CBCharacteristic? = nil
    var time=0
    var rxState = 0
    var stringAll=""
    @IBOutlet weak var lbltimer: UILabel!
    let BLEService = "49535343-FE7D-4AE5-8FA9-9FAFD205E455"//"DFB0"
    
    let BLECharacteristic = "49535343-8841-43F4-A8D4-ECBE34729BB3"//DFB1"
     let BLECharacteristicRec = "49535343-1E4D-4BD9-BA61-23C647249616"
     var timer = Timer()
    
    @IBOutlet weak var recievedMessageText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager = CBCentralManager(delegate: self, queue: nil);
        customiseNavigationBar()
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(MainViewController.sendComd), userInfo: nil, repeats: true)
    }
  //////////////////////////////////////////////////
    //Send ount command
    func sendComd()
    {
        time+=1;
        lbltimer.text=String(time)
    }
    ///////////////////////////////////////////////////
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
        let helloWorld = "!00SQ1;5\r"
        let dataToSend = helloWorld.data(using: String.Encoding.utf8)
        
        if (mainPeripheral != nil) {
     //       mainPeripheral?.writeValue(dataToSend!, for: mainCharacteristic!, type: CBCharacteristicWriteType.withoutResponse)
            mainPeripheral?.writeValue(dataToSend!, for: mainCharacteristic!, type: .withResponse)
            
        } else {
            print("haven't discovered device yet")
        }
        
       // mainPeripheral?.readValue(for: <#T##CBCharacteristic#>)
    }
    
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
  /*
            //device information service
            if (service.uuid.uuidString == "180A") {
                peripheral.discoverCharacteristics(nil, for: service)
            }
            
            //GAP (Generic Access Profile) for Device Name
            // This replaces the deprecated CBUUIDGenericAccessProfileString
            if (service.uuid.uuidString == "1800") {
                peripheral.discoverCharacteristics(nil, for: service)
            }
  */
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
                /*
                
                 if ((parts[0].indexOf("SQ")>=0)||(parts[0].indexOf("RU")>=0)||(parts[0].indexOf("RT")>=0)||(parts[0].indexOf("RK")>=0)||(parts[0].indexOf("RV")>=0)||(parts[0].indexOf("RQ")>=0)||(parts[0].indexOf("RA")>=0)||(parts[0].indexOf("RL")>=0)||(parts[0].indexOf("RS")>=0))            //find if "SQ1;" exist, if yes, start to add to string.
                 {
                 mStrReceivedString="";
                 rxState= Constants.RX_START;
                 }
                 if ((parts[0].indexOf("\r")>=0) ||(parts[0].indexOf("\n")>=0))              //find if end charactor exist in the string; if yes append the string and end
                 {
                 String[] parts1=parts[0].split(Character.toString((char)13));  //find '\r'
                 rxState= Constants.RX_DONE;
                 mStrReceivedString=mStrReceivedString.concat(parts1[0]);
                 }
                 else {
                 mStrReceivedString=mStrReceivedString.concat(parts[0]);
                 }                */
                
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
}

