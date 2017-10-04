//
//  SetupViewController.swift
//  LeakLite
//
//  Created by macuser on 10/2/17.
//  Copyright © 2017 Rick Smith. All rights reserved.
//

import UIKit
class FruitTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblStepTime: UILabel!
    @IBOutlet weak var lblStepName: UILabel!
}

class SetupViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var lblFlowMin: UILabel!
    @IBOutlet weak var lblFlowMax: UILabel!
    @IBOutlet weak var lblPressureMin: UILabel!
    @IBOutlet weak var lblPressureMax: UILabel!
    @IBOutlet weak var lblPressureSet: UILabel!
    @IBOutlet weak var lblExtPresMin: UILabel!
    @IBOutlet weak var lblExtPresMax: UILabel!
    @IBOutlet weak var lblExtPresSet: UILabel!
    @IBOutlet weak var lblFlowUnit: UILabel!
    @IBOutlet weak var lblPresUnit: UILabel!
    @IBOutlet weak var lblExtPresUnit: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    //@IBOutlet weak var tableViewTime: UITableView!
    private var data: [String] = []
    private var dataTime: [String] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentified", for: indexPath) as! FruitTableViewCell
       // let text = data[indexPath.row] //2.
        
       // cell.textLabel?.text = text //3.

     //   cell.textLabel?.textAlignment = .justified
     //   return cell //4.
        
      //  let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentified", for: indexPath) as! FruitTableViewCell
        
        let text = data[indexPath.row]
        let text2 = dataTime[indexPath.row]
        cell.lblStepName?.text = text
        cell.lblStepTime?.text = text2//UIImage(named: fruitName)
         cell.lblStepTime?.textAlignment = .right
        
        return cell
    }
    
 /*
    func tableViewTime(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    
    func tableViewTime(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifierTime")! //1.
        
        let text = dataTime[indexPath.row] //2.
        
        cell.textLabel?.text = text //3.
        
        //   cell.textLabel?.textAlignment = .justified
        return cell //4.
    }
    */
    // THE NUMBER OF COULUMNS OF DADTA
    var IntSelectTT = 0
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    // THE UMBER OF ROWS OF DATA
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickTT.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickTT[row]
    }


    @IBOutlet weak var lblTest: UILabel!
    @IBOutlet weak var TTPicker: UIPickerView!
    
    @IBAction func clicktest(_ sender: UIButton) {
        lblTest.text = "clicked"
    }
    
    var pickTT: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UpdateSetup()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")        //connect data
        self.TTPicker.delegate = self
        self.TTPicker.dataSource = self
        pickTT = ["Test Type 1","Test Type 2","Test Type 3","Test Type 4"]
   
 
        
        
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    // Catpure the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
        IntSelectTT = row
        UpdateSetup()
        tableView.reloadData()
    }
    
    func UpdateSetup()
    {
        data.removeAll()
        dataTime.removeAll()
        data.append("No.      Name  ")
        dataTime.append("Time(s)")
        if ValveSteps > 2
        {
            for i in 1...ValveSteps
            {
                data.append("\(i)      " + L[i]) //+ "        " + (String)(T[IntSelectTT][i]))
                dataTime.append((String)(T[IntSelectTT][i-1]))
            }
            
            lblFlowMin.text = String(V[IntSelectTT][1])
            lblFlowMax.text = String(V[IntSelectTT][2])
            lblPressureMin.text = String(KPAtoAny(inData: K[IntSelectTT][3], strUnit: mstrPressureUnit))
            lblPressureMax.text = String(KPAtoAny(inData: K[IntSelectTT][2], strUnit: mstrPressureUnit))
            lblExtPresMin.text = String(KPAtoAny(inData: K[IntSelectTT][9], strUnit: mstrPressureUnit))
            lblExtPresMax.text = String(KPAtoAny(inData: K[IntSelectTT][10], strUnit: mstrPressureUnit))
            lblPressureSet.text = String(KPAtoAny(inData: K[IntSelectTT][0], strUnit: mstrPressureUnit))
            lblFlowUnit.text = mstrFlowUnit
            lblPresUnit.text = mstrPressureUnit
            lblExtPresUnit.text = mstrPressureUnit
        }
    }
/*
    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickTT.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    private func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickTT[row]
    }
*/
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
