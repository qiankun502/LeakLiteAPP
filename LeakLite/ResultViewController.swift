import UIKit
import SQLite
//import Foundation

class ResultVeiwCell: UITableViewCell{
    @IBOutlet weak var lbl_No: UILabel!
    
    @IBOutlet weak var lbl_Result: UILabel!
    @IBOutlet weak var lbl_TestID: UILabel!
    @IBOutlet weak var lbl_Flow: UILabel!
    @IBOutlet weak var lbl_Pres: UILabel!
    @IBOutlet weak var lbl_ExPres: UILabel!
    @IBOutlet weak var lbl_Time: UILabel!
    
    
}


class ResultViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UIPickerViewDelegate, UIPickerViewDataSource {
    var choices = ["All Type","TestType 1","TestType 2","TestType 3","TestType 4"]
    var sensornames: [String] = []
    var pickerView = UIPickerView()
    var typeValue = String()
    
    var database: Connection!
    let usersTable = Table("users")
    let id = Expression<Int>("TestID")
    let result = Expression<String>("Result")
    let flow = Expression<String>("Flow")
    let pressure = Expression<String>("Pressure")
    let Extpres = Expression<String>("Ext-Pres")
    let testtime = Expression<String>("time")
    private var ArrayResult: [String] = []
    private var ArrayTestID: [String] = []
    private var ArrayFlow: [String] = []
    private var ArrayPressure: [String] = []
    private var ArrayExPres: [String] = []
    private var ArrayTime: [String] = []
    var blStart: Bool = true   //true: start time selection, false: End time selection
    var blTimeMode: Bool = true    //true: Time selection, false: date selection
    var strDate:String = ""
    var bl_TTorName = true

    var pickerSensorName: [String] = [String]()
    
    @IBOutlet weak var tableView: UITableView!

    
    @IBOutlet weak var txt_TType: UITextField!
    @IBOutlet weak var txt_SensorName: UITextField!
    @IBOutlet weak var txt_SartTime: UITextField!
    @IBOutlet weak var txt_EndTime: UITextField!
    var datePicker : UIDatePicker!
    var datePickertime : UIDatePicker!
    
 
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //Pick data from start time text input
    func pickUpDate(_ textField : UITextField){
        // DatePicker
        self.datePickertime = UIDatePicker(frame:CGRect(x: 0, y: 116, width: self.view.frame.size.width, height: 116))
        self.datePickertime.backgroundColor = UIColor.white
        self.datePickertime.datePickerMode = UIDatePickerMode.time
        
        self.datePicker = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.datePicker.backgroundColor = UIColor.white
        if (blTimeMode == false) {
            self.datePicker.datePickerMode = UIDatePickerMode.dateAndTime
        }
        else {
            self.datePicker.datePickerMode = UIDatePickerMode.time
        }
  
        if (blTimeMode == false) {
        textField.inputView = self.datePicker
        }
        else {
            textField.inputView = self.datePickertime
        }
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        //toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
    }
    
    func doneClick() {
  
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm"
        if blStart == true {
            txt_SartTime.text = dateFormatter.string(from: datePicker.date)
            txt_SartTime.resignFirstResponder()
        }
        else {
            txt_EndTime.text = dateFormatter.string(from: datePicker.date)
            txt_EndTime.resignFirstResponder()
        }
        
        
    
        
        
    //    self.pickUpTime(self.txt_SartTime)
   /*
        blTimeMode = true
        self.pickUpDate(self.txt_SartTime)
        txt_SartTime.text = dateFormatter1.string(from: datePicker.date)
        txt_SartTime.resignFirstResponder()
 
        if blTimeMode == false {
            strDate = dateFormatter1.string(from: datePicker.date)   // get the date string
        }
        
        if blStart == true {
            txt_SartTime.text = strDate + dateFormatter1.string(from: datePicker.date)
            txt_SartTime.resignFirstResponder()
        }
        else {
            txt_EndTime.text = strDate + dateFormatter1.string(from: datePicker.date)
            txt_EndTime.resignFirstResponder()
        }
        
        if blTimeMode == false {
            blTimeMode = true
            self.pickUpTime(self.txt_SartTime)
        }*/
    }
    
    func cancelClick() {
        txt_SartTime.resignFirstResponder()
    }
   /*
//////////////////////////////////////////////////////////////////////////////////////////////////
    //Pick time from start time text input
    func pickUpTime(_ textField : UITextField){
        // DatePicker
        
        self.datePickertime = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.datePickertime.backgroundColor = UIColor.white

         self.datePickertime.datePickerMode = UIDatePickerMode.time

        
        textField.inputView = self.datePickertime
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton1 = UIBarButtonItem(title: "Done1", style: .plain, target: self, action: #selector(self.doneClick1))
        let spaceButton1 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton1 = UIBarButtonItem(title: "Cancel1", style: .plain, target: self, action: #selector(self.cancelClick))
        toolBar.setItems([cancelButton1, spaceButton1, doneButton1], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
    }
    
    
    func doneClick1() {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateStyle = .short
        dateFormatter1.timeStyle = .none
        strDate = dateFormatter1.string(from: datePicker.date)   // get the date string
        txt_SartTime.resignFirstResponder()
        self.pickUpTime(self.txt_SartTime)}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
    
    @IBAction func StartDataTimeClick(_ sender: UITextField, forEvent event: UIEvent) {
        blStart = true
        blTimeMode = false
        
        self.pickUpDate(self.txt_SartTime)
    }
    //    @IBAction func EndTimeClick(_ sender: UITextField) {
 //       blStart = false
 //       blTimeMode = false
       // self.pickUpDate(self.txt_EndTime)
//    }
    //End Pick data from start time text input
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    @IBAction func EndTimeClick(_ sender: UITextField, forEvent event: UIEvent) {
            blStart = false
            blTimeMode = false
            self.pickUpDate(self.txt_EndTime)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ArrayResult.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCellIdentified", for: indexPath) as! ResultVeiwCell
        let text1 = String (indexPath.row + 1)
        let text2 = ArrayResult[indexPath.row]
        cell.lbl_No?.text = text1 //String (indexPath.row)
        cell.lbl_Result?.text = text2 //ArrayResult[indexPath.row]//UIImage(named: fruitName)
        cell.lbl_TestID?.text = ArrayTestID[indexPath.row]
        cell.lbl_Flow?.text = ArrayFlow[indexPath.row]
        cell.lbl_Pres?.text = ArrayPressure[indexPath.row]
        cell.lbl_ExPres?.text = ArrayExPres[indexPath.row]
        cell.lbl_Time?.text = ArrayTime[indexPath.row]
        // cell.lblStepTime?.textAlignment = .right
        //if cell.lbl_Result.text?.lowercased().range(of: "pass") != nil {
        

        if cell.lbl_Result.text?.lowercased().range(of: "pass") != nil {
            cell.contentView.backgroundColor = UIColor.green
        }
        else if cell.lbl_Result.text?.lowercased().range(of: "Idle") != nil {
            cell.contentView.backgroundColor = UIColor.yellow
        }
        else if cell.lbl_Result.text?.lowercased().range(of: "fail") != nil {
            cell.contentView.backgroundColor = UIColor.red
        }
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.

        sensornames = LeakLiteDatabase.RetreatSensorName()
        let todaysDate:NSDate = NSDate()
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm"
        let DateInFormat:String = dateFormatter.string(from: todaysDate as Date)
        txt_EndTime.text = DateInFormat
        
        let yesterdayDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        let YesterdayDateInFormat:String = dateFormatter.string(from: yesterdayDate as! Date)
        txt_SartTime.text = YesterdayDateInFormat
        
        
        
        
        
        
        txt_TType.text = "All Type"
        txt_SensorName.text  = "All Sensor"
        
    }
    

    @IBAction func CreatTabletest(_ sender: UIButton) {
       LeakLiteDatabase.DeleteData()
       // sqlViewController().OpenDatabase()
        
    }

    private func ClearTable() {
        ArrayResult.removeAll()
        ArrayTestID.removeAll()
        ArrayFlow.removeAll()
        ArrayPressure.removeAll()
        ArrayExPres.removeAll()
        ArrayTime.removeAll()
    }
    

    
    @IBAction func listallRecord(_ sender: UIButton) {
        
        ClearTable()
        
        let users = LeakLiteDatabase.QueryRecord (startTime:txt_SartTime.text!, endtime:txt_EndTime.text!, setupid: "",sensorname: "")
        for user in users! {
            ArrayResult.append(user[LeakLiteDatabase.sTestResult])
            ArrayTestID.append(user[LeakLiteDatabase.sSetupId])
            ArrayFlow.append(user[LeakLiteDatabase.sFinalFlow])
            ArrayPressure.append(user[LeakLiteDatabase.sPressure])
            ArrayExPres.append(user[LeakLiteDatabase.sExtPressure])
            ArrayTime.append(user[LeakLiteDatabase.sTestTime])
            print("userId: \(user[LeakLiteDatabase.sSensorName]), name: \(user[LeakLiteDatabase.sSensorName]), email: \(user[LeakLiteDatabase.sTestResult])")
        }
        tableView.reloadData()
 
        
        //print (names[0])
    }
    
    @IBAction func SensorNameClick(_ sender: UITextField) {
        bl_TTorName = false
        self.typeValue = "All Sensor"
        let alert = UIAlertController(title: "Sensor Name Selection", message: "\n\n\n\n\n\n", preferredStyle: .alert)
        alert.isModalInPopover = true
        
        let pickerFrame = UIPickerView(frame: CGRect(x: 5, y: 20, width: 250, height: 140))
        
        alert.view.addSubview(pickerFrame)
        pickerFrame.dataSource = self
        pickerFrame.delegate = self
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
            
            print("You selected " + self.typeValue )
            self.txt_SensorName.text = self.typeValue
            
        }))
        self.present(alert,animated: true, completion: nil )
        sender.inputView = UIView()
    }
    
    
    @IBAction func TTypeClick(_ sender: UITextField) {
        bl_TTorName = true
        self.typeValue = "All Type"
        let alert = UIAlertController(title: "Test Type Selection", message: "\n\n\n\n\n\n", preferredStyle: .alert)
        alert.isModalInPopover = true
        
        let pickerFrame = UIPickerView(frame: CGRect(x: 5, y: 20, width: 250, height: 140))
        
        alert.view.addSubview(pickerFrame)
        pickerFrame.dataSource = self
        pickerFrame.delegate = self
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
            
            print("You selected " + self.typeValue )
            self.txt_TType.text = self.typeValue
            
        }))
        self.present(alert,animated: true, completion: nil )
        sender.inputView = UIView()
    }

    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if bl_TTorName == true { //TT
           return choices.count
        }
        else { //sensor name
            return sensornames.count
        }
       //
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       
         if bl_TTorName == true { //TT
             return choices[row]
        }
         else{
            return sensornames[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if bl_TTorName == true { //TT
            if row == 0 {
                typeValue = "All Type"
            } else if row == 1 {
                typeValue = "TestTyp 1"
            } else if row == 2 {
                typeValue = "TestType 2"
            } else if row == 3 {
                typeValue = "TestType 3"
            } else if row == 4 {
                typeValue = "TestType 4"
            }
        }
        else {
            typeValue = sensornames[row]
        }
    
    }
    
    @IBAction func QueryClick(_ sender: UIButton) {
        ClearTable()
        
        let users = LeakLiteDatabase.QueryRecord (startTime:txt_SartTime.text!, endtime:txt_EndTime.text!, setupid: txt_TType.text!,sensorname: txt_SensorName.text!)
        for user in users! {
            ArrayResult.append(user[LeakLiteDatabase.sTestResult])
            ArrayTestID.append(user[LeakLiteDatabase.sSetupId])
            ArrayFlow.append(user[LeakLiteDatabase.sFinalFlow])
            ArrayPressure.append(user[LeakLiteDatabase.sPressure])
            ArrayExPres.append(user[LeakLiteDatabase.sExtPressure])
            ArrayTime.append(user[LeakLiteDatabase.sTestTime])
            print("userId: \(user[LeakLiteDatabase.sSensorName]), name: \(user[LeakLiteDatabase.sSensorName]), email: \(user[LeakLiteDatabase.sTestResult])")
        }
        tableView.reloadData()
    }
    
    @IBAction func addrecord(_ sender: UIButton) {
      //Database().InsertNewRecord(result: "Pass", setupid: "Testtype1", flow: "1.1", pressure: "2.2",externalpres: "3.3", strtime: "1-20-2018", dbltime: 1213231.212, sensorname: "demo2")
    }
}
