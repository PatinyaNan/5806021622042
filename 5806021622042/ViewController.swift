//
//  ViewController.swift
//  5806021622042
//
//  Created by Admin on 24/4/2562 BE.
//  Copyright © 2562 Admin. All rights reserved.
//

import UIKit
import Charts
struct jsonstruct:Decodable {
    let name:String
    let capital:String
    let alpha2Code:String
    let alpha3Code:String
    let region:String
    let subregion:String
    let population: Int
    let area: Double?
    let gini: Double?
    
}
class ViewController: UIViewController, ChartViewDelegate {
    var region: String = "asia"
    //var textCountry: String = ""
    var fullNameArr = [String]()
    //var textCountry = [String]()
    var test = "asia"
    var testNa = [jsonstruct]()
    var country = [Double]()
    var population = [Double]()
    var name = [String]()
    let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    let unitsSold = [2.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 17.0, 2.0, 4.0, 5.0, 4.0]
    
    
    @IBOutlet weak var chartView: CombinedChartView!
    @IBOutlet weak var textSub: UITextField!
    @IBAction func OKNA(_ sender: Any) {
        if textSub.text == "" {
            alert(checkCondition: 0)
        } else {
            fullNameArr = textSub.text?.components(separatedBy: ",") ?? [""]
            if(fullNameArr.count ?? 2 <= 5 && fullNameArr.count ?? 2  >= 2) {
                
                region = textSub.text!
                print(region)
                self.viewDidLoad()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.setChart(xValues: self.name, yValuesLineChart:  self.country, yValuesBarChart: self.population)
                }
                
            } else {
                alert(checkCondition: 1)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getdata()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func getdata(){
        //print(region)
        //let jsonUrlString = "https://restcountries.eu/rest/v2/region/\(region)"
        let jsonUrlString = "https://restcountries.eu/rest/v2/all"
        //let jsonUrlString = "https://restcountries.eu/rest/v2/name/{name}"
        //let jsonUrlString = "https://restcountries.eu/rest/v2/lang/\(region)"
        guard let url = URL(string: jsonUrlString) else {return}
        URLSession.shared.dataTask(with: url) { (data, responds,err) in
            guard let data = data else {return}
            do {
                self.population = []
                self.country = []
                self.name = []
                self.testNa = try JSONDecoder().decode([jsonstruct].self, from: data)
                for mainarr in self.testNa{
//                    if(self.region == "all") {
//                        self.population.append(Double(mainarr.population)/1000000)
//                        self.country.append(Double(mainarr.gini ?? 0))
//                        self.name.append(mainarr.alpha3Code)
//                    }else {
                        for selectName in self.fullNameArr{
                            if selectName == mainarr.name {
                                print("mind: \(mainarr.name)")
                                self.population.append(Double(mainarr.population)/1000000)
                                self.country.append(Double(mainarr.gini ?? 0))
                                self.name.append(mainarr.alpha3Code)
                            }
                        }
//                    }
                }
            } catch let jsonErr {
                print("Error serializing json", jsonErr)
            }
            }.resume()
    }
    func setChart(xValues: [String], yValuesLineChart: [Double], yValuesBarChart: [Double]) {
        chartView.noDataText = "Please provide data for the chart."
        
        var yVals1 : [ChartDataEntry] = [ChartDataEntry]()
        var yVals2 : [BarChartDataEntry] = [BarChartDataEntry]()
        for i in 0..<xValues.count {
            yVals1.append(ChartDataEntry(x: Double(i), y: yValuesLineChart[i],data: xValues as AnyObject?))
            yVals2.append(BarChartDataEntry(x: Double(i), y: yValuesBarChart[i],data: xValues as AnyObject?))
        }
        
        let lineChartSet = LineChartDataSet(values: yVals1, label: "Line Data")
        let barChartSet: BarChartDataSet = BarChartDataSet(values: yVals2, label: "Bar Data")
        barChartSet.colors = [UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1)]
        
        let data: CombinedChartData = CombinedChartData()
        data.barData=BarChartData(dataSets: [barChartSet])
        if yValuesLineChart.contains(0) == false {
            data.lineData = LineChartData(dataSets:[lineChartSet] )
            
            
        }
        chartView.data = data
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:xValues)
        chartView.xAxis.granularity = 1
    }
    func alert (checkCondition: Int) {
        var msg = ""
        if checkCondition == 0 {
            msg = "Please input number of cities."
        } else {
            msg = "Not input string"
        }
        
        let alert = UIAlertController(title: "Warning", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

