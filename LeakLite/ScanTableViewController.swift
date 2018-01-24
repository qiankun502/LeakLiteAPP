import CoreBluetooth
 import UIKit
 
 class ScanTableViewController: UITableViewController,CBCentralManagerDelegate {
    
    var peripherals:[CBPeripheral] = []
    var manager: CBCentralManager? = nil
    var parentView:MainViewController? = nil
    var Rowth = 0
 //   var mstrSensorName = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        scanBLEDevice()
    }
    func scanBLEDevice(){
        manager?.scanForPeripherals(withServices: nil, options: nil)
        //manager?.scanForPeripherals(withServices: [CBUUID(string: "49535343-FE7D-4AE5-8FA9-9FAFD205E455")], options: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 20.0) {
            self.stopScanForBLEDevice()
        }
        
    }
    func stopScanForBLEDevice(){
        manager?.stopScan()
        print("scan stopped")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return peripherals.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       //let cell = tableView.dequeueReusableCell(withIdentifier: "scanTableCell", for: indexPath)
  /*      if (peripherals[indexPath.row].name == nil)
        {
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
        else{
            
        }*/
   
        let cell = tableView.dequeueReusableCell(withIdentifier: "scanTableCell", for: indexPath)
        let peripheral = peripherals[indexPath.row]
        cell.textLabel?.text = peripheral.name
        tableView.tableFooterView = UIView(frame: .zero)

        return cell

        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let peripheral = peripherals[indexPath.row]
        manager?.connect(peripheral, options: nil)
    }
    
    
    //CBCentralMaganerDelegate code
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if (!peripherals.contains(peripheral)){
            peripherals.append(peripheral)
        }
        self.tableView.reloadData()
    }
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print(central.state)
    }
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        if (peripheral.name != nil)
        {
            // pass reference to connected peripheral to parentview
            parentView?.mainPeripheral = peripheral
            peripheral.delegate = parentView
            peripheral.discoverServices(nil)
            // set manager's delegate view to parent so it can call relevant disconnect methods
            manager?.delegate = parentView
            parentView?.customiseNavigationBar()
            
            if let navController = self.navigationController{
                navController.popViewController(animated: true)
                
            }
            print("Connected to "+peripheral.name!)
   //         mstrSensorName = peripheral.name
        }
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print(error!)
    }
 }
