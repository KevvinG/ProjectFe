//
//  HeartRateViewController.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-02-25.
//
//  HeartRate Graph and data generation created by Kevin Grzela 2021-02-26

// Imports
import UIKit
import HealthKit
import Charts

/*------------------------------------------------------------------------
 - Class: HeartRateViewController : UIViewController
 - Description: Holds logic for the Heart Rate Screen
 -----------------------------------------------------------------------*/
class HeartRateViewController: UIViewController {
    var healthDict:[Date:Double] = [:]
    var healthStore = HKHealthStore()
    let heartRateQuantity = HKUnit(from: "count/min")
    var value = 0
    var testArr = [String]()
    var testArr2 = [Double]()
    var testArr3 = [String]()
    // Class Variables
    var plotData = [Double](repeating: 0.0, count: 1000)
    var maxDataPoints = 100
    var frameRate = 5.0
    var alphaValue = 0.25
    var timer : Timer?
    var currentIndex: Int!
    var timeDuration:Double = 0.1
    
    // UI Variables
    @IBOutlet var dataButton: UIView!
    @IBOutlet var testLbl: UILabel!
    @IBOutlet var testLbl2: UILabel!
    @IBOutlet var testGraphBtn: UIButton!
    @IBOutlet weak var lineChartView: LineChartView!
    
    /*--------------------------------------------------------------------
     - Function: viewDidLoad()
     - Description: Initialize variables and screen before it loads
     -------------------------------------------------------------------*/
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        dataButton.addGestureRecognizer(tap)
        print("Bottom of viewdidLoad")
    }
    
    func customizeChart(dataPoints: [String], values: [Double]) {
      
      var dataEntries: [ChartDataEntry] = []
      
      for i in 0..<dataPoints.count {
        let dataEntry = ChartDataEntry(x: Double(i), y: values[i])
        dataEntries.append(dataEntry)
      }
      
        let lineChartDataSet = LineChartDataSet(entries: dataEntries, label: nil)
      let lineChartData = LineChartData(dataSet: lineChartDataSet)
      lineChartView.data = lineChartData
    }
    
    /*--------------------------------------------------------------------
     - Function: handleTap()
     - Description:
     -------------------------------------------------------------------*/
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil){
        fetchHealthData()
        if (testArr2.count > 0) {
            self.testLbl.text = "Max: \(testArr2.max() ?? 0)BPM"
            self.testLbl2.text = "Min: \(testArr2.min() ?? 0)BPM"
        } else {
            self.testLbl.text = "Not yet"
        }
    
        print("Button pressed")
        
    }
    
    @IBAction func testGraphBtnPress(_ sender: Any) {
        customizeChart(dataPoints: testArr3, values: testArr2)

    }
    
    func fetchHealthData() -> Void {
        let healthStore = HKHealthStore()
        if HKHealthStore.isHealthDataAvailable() {
            let readData = Set([
                HKObjectType.quantityType(forIdentifier: .heartRate)!
            ])
            
            healthStore.requestAuthorization(toShare: [], read: readData) { (success, error) in
                if success {
                    let calendar = NSCalendar.current
                    
                    var anchorComponents = calendar.dateComponents([.day, .month, .year, .weekday], from: NSDate() as Date)
                    
                    let offset = (7 + anchorComponents.weekday! - 2) % 7
                    
                    anchorComponents.day! -= offset
                    anchorComponents.hour = 2
                    
                    guard let anchorDate = Calendar.current.date(from: anchorComponents) else {
                        fatalError("*** unable to create a valid date from the given components ***")
                    }
                    
                    let interval = NSDateComponents()
                    interval.minute = 30
                                        
                    let endDate = Date()
                                                
                    guard let startDate = calendar.date(byAdding: .month, value: -1, to: endDate) else {
                        fatalError("*** Unable to calculate the start date ***")
                    }
                                        
                    guard let quantityType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate) else {
                        fatalError("*** Unable to create a step count type ***")
                    }

                    let query = HKStatisticsCollectionQuery(quantityType: quantityType,
                                                            quantitySamplePredicate: nil,
                                                                options: .discreteAverage,
                                                                anchorDate: anchorDate,
                                                                intervalComponents: interval as DateComponents)
                    
                    query.initialResultsHandler = {
                        query, results, error in
                        
                        guard let statsCollection = results else {
                            fatalError("*** An error occurred while calculating the statistics: \(String(describing: error?.localizedDescription)) ***")
                            
                        }
                                            
                        statsCollection.enumerateStatistics(from: startDate, to: endDate) { statistics, stop in
                            if let quantity = statistics.averageQuantity() {
                                let date = statistics.startDate
                                //for: E.g. for steps it's HKUnit.count()
                                let value = quantity.doubleValue(for: HKUnit(from: "count/min"))
                                print("done")
                                print(value)
                                print(date)
                                self.testArr.append(String(value))
                                self.testArr2.append(value)
                                self.healthDict[date] = value
                                //self.testArr3.append(date)
                                let formatter3 = DateFormatter()
                                formatter3.dateFormat = "HH:mm E, d MMM y"
                                print(formatter3.string(from: date))
                                self.testArr3.append(formatter3.string(from: date))
                            }
                        }
                        
                    }
                    
                    healthStore.execute(query)

                } else {
                    print("Authorization failed")

                }
            }

        }
    }
    
}
