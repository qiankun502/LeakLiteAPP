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


class ResultViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
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


    @IBOutlet weak var tableView: UITableView!
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
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
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.

    }
    

   
    @IBAction func CreatTabletest(_ sender: UIButton) {
       LeakLiteDatabase.OpenDatabase()
       // sqlViewController().OpenDatabase()
    }

    private func ClearTable() {
        ArrayResult.removeAll()
        ArrayTestID.removeAll()
        ArrayFlow.removeAll()
        ArrayPressure.removeAll()
        ArrayExPres.removeAll()
        ArrayTime.removeAll()
  /*      ArrayResult.append("Result")
        ArrayTestID.append("TType")
        ArrayFlow.append("Flow")
        ArrayPressure.append("Pressure")
        ArrayExPres.append("Ext-Pres")
        ArrayTime.append("Test Time")*/
    }
    
    @IBAction func listrecord(_ sender: UIButton) {
        
        ClearTable()
        
        let users = LeakLiteDatabase.QueryRecord (startTime:0, endtime:1000000, setupid: "",sensorname: "")
        for user in users! {
            ArrayResult.append(user[LeakLiteDatabase.sTestResult])
            ArrayTestID.append(user[LeakLiteDatabase.sSetupId])
            ArrayFlow.append(user[LeakLiteDatabase.sFinalFlow])
            ArrayPressure.append(user[LeakLiteDatabase.sPressure])
            ArrayExPres.append(user[LeakLiteDatabase.sExtPressure])
            ArrayTime.append(user[LeakLiteDatabase.sTestTime])
             print("userId: \(user[LeakLiteDatabase.sPressure]), name: \(user[LeakLiteDatabase.sSensorName]), email: \(user[LeakLiteDatabase.sTestResult])")
        }
  /*      ArrayResult.append("111")
        ArrayTestID.append("111")
        ArrayFlow.append("111")
        ArrayPressure.append("111")
        ArrayExPres.append("111")
        ArrayTime.append("111")*/
        tableView.reloadData()
       // LeakLiteDatabase.listtestrecord()
       // sqlViewController().listitem();
    }
    
    
    @IBAction func addrecord(_ sender: UIButton) {
      //Database().InsertNewRecord(result: "Pass", setupid: "Testtype1", flow: "1.1", pressure: "2.2",externalpres: "3.3", strtime: "1-20-2018", dbltime: 1213231.212, sensorname: "demo2")
    }
}
