//
//  HeartRateViewController.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-02-25.
//
//  HeartRate Graph and data generation created by Kevin Grzela 2021-02-26

// Imports
import UIKit
import CorePlot
import HealthKit
import Charts

/*------------------------------------------------------------------------
 - Class: HeartRateViewController : UIViewController
 - Description: Holds logic for the Heart Rate Screen
 -----------------------------------------------------------------------*/
class HeartRateViewController: UIViewController, CPTScatterPlotDataSource, CPTAxisDelegate {
    private var scatterGraph : CPTXYGraph? = nil
    typealias plotDataType = [CPTScatterPlotField : Double]
    private var dataForPlot = [plotDataType]()
    var healthDict:[Date:Double] = [:]
    var healthStore = HKHealthStore()
    let heartRateQuantity = HKUnit(from: "count/min")
    var value = 0
    var testArr = [String]()
    var testArr2 = [Double]()
    var testArr3 = [Date]()
    // Class Variables
    var plotData = [Double](repeating: 0.0, count: 1000)
    var plot: CPTScatterPlot!
    var maxDataPoints = 100
    var frameRate = 5.0
    var alphaValue = 0.25
    var timer : Timer?
    var currentIndex: Int!
    var timeDuration:Double = 0.1
    
    // UI Variables
    @IBOutlet var bpmText: UILabel!
    @IBOutlet var hostView: CPTGraphHostingView!
    @IBOutlet var dataButton: UIView!
    @IBOutlet var xValue: UILabel!
    @IBOutlet var yValue: UILabel!
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
        //authorizeHealthKit()
        //startHeartRateQuery(quantityTypeIdentifier: .heartRate)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        dataButton.addGestureRecognizer(tap)
        //subscribeToHeartBeatChanges()
        print("Bottom of viewdidLoad")
        //initPlot()
//        customizeChart(dataPoints: testArr3, values: testArr2)

    }
    
    func customizeChart(dataPoints: [Date], values: [Double]) {
      
      var dataEntries: [ChartDataEntry] = []
      
      for i in 0..<dataPoints.count {
        let dataEntry = ChartDataEntry(x: values[i], y: Double(i))
        dataEntries.append(dataEntry)
      }
      
        let lineChartDataSet = LineChartDataSet(entries: dataEntries, label: nil)
      let lineChartData = LineChartData(dataSet: lineChartDataSet)
      lineChartView.data = lineChartData
    }
    
    /*--------------------------------------------------------------------
     - Function: initPlot()
     - Description:
     -------------------------------------------------------------------*/
    func initPlot(){
        configureGraphtView()
        configureGraphAxis()
        configurePlot()
    }
    
    /*--------------------------------------------------------------------
     - Function: handleTap()
     - Description:
     -------------------------------------------------------------------*/
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil){
//        timer?.invalidate()
//        timer = Timer.scheduledTimer(timeInterval: self.timeDuration, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
//
       // startHeartRateQuery(quantityTypeIdentifier: .heartRate)
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
//        testGraphing()
        customizeChart(dataPoints: testArr3, values: testArr2)

    }

    
    @objc func fireTimer(){
        let graph = self.hostView.hostedGraph
        let plot = graph?.plot(withIdentifier: "mindful-graph" as NSCopying)
        if((plot) != nil){
            if(self.plotData.count >= maxDataPoints){
                self.plotData.removeFirst()
                plot?.deleteData(inIndexRange:NSRange(location: 0, length: 1))
            }
        }
        guard let plotSpace = graph?.defaultPlotSpace as? CPTXYPlotSpace else { return }
        
        let location: NSInteger
        if self.currentIndex >= maxDataPoints {
            location = self.currentIndex - maxDataPoints + 2
        } else {
            location = 0
        }
        
        let range: NSInteger
        
        if location > 0 {
            range = location-1
        } else {
            range = 0
        }
        
        let oldRange =  CPTPlotRange(locationDecimal: CPTDecimalFromDouble(Double(range)), lengthDecimal: CPTDecimalFromDouble(Double(maxDataPoints-2)))
        let newRange =  CPTPlotRange(locationDecimal: CPTDecimalFromDouble(Double(location)), lengthDecimal: CPTDecimalFromDouble(Double(maxDataPoints-2)))
    
        CPTAnimation.animate(plotSpace, property: "xRange", from: oldRange, to: newRange, duration:0.3)
        
        self.currentIndex += 1;
        let point = Double.random(in: 75...85)
        self.plotData.append(point)
        //xValue.text = #"X: \#(String(format:"%.2f",Double(self.plotData.last!)))"#
        //yValue.text = #"Y: \#(UInt(self.currentIndex!)) Sec"#
        plot?.insertData(at: UInt(self.plotData.count-1), numberOfRecords: 1)
    }
    
    /*--------------------------------------------------------------------
     - Function: configureGraphView()
     - Description:
     -------------------------------------------------------------------*/
    func configureGraphtView(){
        hostView.allowPinchScaling = false
        self.plotData.removeAll()
        self.currentIndex = 0
    }
    
    /*--------------------------------------------------------------------
     - Function: coonfigureGraphAxis()
     - Description:
     -------------------------------------------------------------------*/
    func configureGraphAxis(){
        
        let graph = CPTXYGraph(frame: hostView.bounds)
        graph.plotAreaFrame?.masksToBorder = false
        hostView.hostedGraph = graph
        graph.backgroundColor = UIColor.black.cgColor
        graph.paddingBottom = 40.0
        graph.paddingLeft = 40.0
        graph.paddingTop = 30.0
        graph.paddingRight = 15.0
        

        //Set title for graph
        let titleStyle = CPTMutableTextStyle()
        titleStyle.color = CPTColor.white()
        titleStyle.fontName = "HelveticaNeue-Bold"
        titleStyle.fontSize = 20.0
        titleStyle.textAlignment = .center
        graph.titleTextStyle = titleStyle

        let title = "CorePlot"
        graph.title = title
        graph.titlePlotAreaFrameAnchor = .top
        graph.titleDisplacement = CGPoint(x: 0.0, y: 0.0)
        
        let axisSet = graph.axisSet as! CPTXYAxisSet
        
        let axisTextStyle = CPTMutableTextStyle()
        axisTextStyle.color = CPTColor.white()
        axisTextStyle.fontName = "HelveticaNeue-Bold"
        axisTextStyle.fontSize = 10.0
        axisTextStyle.textAlignment = .center
        let lineStyle = CPTMutableLineStyle()
        lineStyle.lineColor = CPTColor.white()
        lineStyle.lineWidth = 5
        let gridLineStyle = CPTMutableLineStyle()
        gridLineStyle.lineColor = CPTColor.gray()
        gridLineStyle.lineWidth = 0.5
       

        if let x = axisSet.xAxis {
            x.majorIntervalLength   = 20
            x.minorTicksPerInterval = 5
            x.labelTextStyle = axisTextStyle
            x.minorGridLineStyle = gridLineStyle
            x.axisLineStyle = lineStyle
            x.axisConstraints = CPTConstraints(lowerOffset: 0.0)
            x.delegate = self
        }

        if let y = axisSet.yAxis {
            y.majorIntervalLength   = 5
            y.minorTicksPerInterval = 5
            y.minorGridLineStyle = gridLineStyle
            y.labelTextStyle = axisTextStyle
            y.alternatingBandFills = [CPTFill(color: CPTColor.init(componentRed: 255, green: 255, blue: 255, alpha: 0.03)),CPTFill(color: CPTColor.black())]
            y.axisLineStyle = lineStyle
            y.axisConstraints = CPTConstraints(lowerOffset: 0.0)
            y.delegate = self
        }

        // Set plot space
        let xMin = 0.0
        let xMax = 100.0
        let yMin = 65.0
        let yMax = 95.0
        guard let plotSpace = graph.defaultPlotSpace as? CPTXYPlotSpace else { return }
        plotSpace.xRange = CPTPlotRange(locationDecimal: CPTDecimalFromDouble(xMin), lengthDecimal: CPTDecimalFromDouble(xMax - xMin))
        plotSpace.yRange = CPTPlotRange(locationDecimal: CPTDecimalFromDouble(yMin), lengthDecimal: CPTDecimalFromDouble(yMax - yMin))
        
    }
    
    /*--------------------------------------------------------------------
     - Function: configurePlot()
     - Description:
     -------------------------------------------------------------------*/
    func configurePlot(){
        plot = CPTScatterPlot()
        let plotLineStile = CPTMutableLineStyle()
        plotLineStile.lineJoin = .round
        plotLineStile.lineCap = .round
        plotLineStile.lineWidth = 2
        plotLineStile.lineColor = CPTColor.white()
        plot.dataLineStyle = plotLineStile
        plot.curvedInterpolationOption = .catmullCustomAlpha
        plot.interpolation = .curved
        plot.identifier = "mindful-graph" as NSCoding & NSCopying & NSObjectProtocol
        guard let graph = hostView.hostedGraph else { return }
        plot.dataSource = (self as CPTPlotDataSource)
        plot.delegate = (self as CALayerDelegate)
        graph.add(plot, to: graph.defaultPlotSpace)
    }
    
    func subscribeToHeartBeatChanges() {
        
        print("subscription fired")

      // Creating the sample for the heart rate
      guard let sampleType: HKSampleType =
        HKObjectType.quantityType(forIdentifier: .heartRate) else {
          return
      }

      /// Creating an observer, so updates are received whenever HealthKit’s
      // heart rate data changes.
      let heartRateQuery = HKObserverQuery.init(
        sampleType: sampleType,
        predicate: nil) { [weak self] _, _, error in
          guard error == nil else {
            //log.warn(error!)
            print(error!)
            return
          }

          /// When the completion is called, an other query is executed
          /// to fetch the latest heart rate
        self?.getCurrentHeartRateData(completion: { sample in
            guard let sample = sample else {
              return
            }

            /// The completion in called on a background thread, but we
            /// need to update the UI on the main.
            DispatchQueue.main.async {

              /// Converting the heart rate to bpm
              let heartRateUnit = HKUnit(from: "count/min")
              let heartRate = sample
                .quantity
                .doubleValue(for: heartRateUnit)

              /// Updating the UI with the retrieved value
              //self?.yValue.setText("\(Int(heartRate))")
                self?.yValue.text = "\(Int(heartRate))"
            }
          })
      }
    }
    
    func getCurrentHeartRateData(
        completion: @escaping (_ sample: HKQuantitySample?) -> Void) {

        /// Create sample type for the heart rate
        guard let sampleType = HKObjectType
          .quantityType(forIdentifier: .heartRate) else {
            completion(nil)
          return
        }

        /// Predicate for specifiying start and end dates for the query
        let predicate = HKQuery
          .predicateForSamples(
            withStart: Date.distantPast,
            end: Date(),
            options: .strictEndDate)

        /// Set sorting by date.
        let sortDescriptor = NSSortDescriptor(
          key: HKSampleSortIdentifierStartDate,
          ascending: false)

        /// Create the query
        let query = HKSampleQuery(
          sampleType: sampleType,
          predicate: predicate,
          limit: Int(HKObjectQueryNoLimit),
          sortDescriptors: [sortDescriptor]) { (_, results, error) in

            guard error == nil else {
              print("Error: \(error!.localizedDescription)")
              return
            }

            completion(results?[0] as? HKQuantitySample)
        }

        self.healthStore.execute(query)

    }
    
    func authorizeHealthKit() {
       
       // Used to define the identifiers that create quantity type objects.
         let healthKitTypes: Set = [
         HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!]
      // Requests permission to save and read the specified data types.
         healthStore.requestAuthorization(toShare: healthKitTypes, read: healthKitTypes) { _, _ in }
     }

    private func startHeartRateQuery(quantityTypeIdentifier: HKQuantityTypeIdentifier) {
            print("startHRQ")
            // We want data points from our current device
        let devicePredicate = HKQuery.predicateForObjects(from: [HKDevice.local()])
        //let devicePredicate = HKQuery.predicateForObjects(withMetadataKey: HKDevicePropertyKeyModel, allowedValues: ["Watch"])
//        let sPredicate = HKQuery.predicateForWorkouts(with: .crossTraining)
//        let sourcePredicate = HKQuery.predicateForObjects(from: .default())
        
        //3. Combine the predicates into a single predicate.
//        let devicePredicate = NSCompoundPredicate(andPredicateWithSubpredicates:
//          [sPredicate, sourcePredicate])
        //let devicePredicate = HKQuery.predicateForObjects(withDeviceProperty: HKDevicePropertyKeyModel, allowedValues: ["Watch"])
            // A query that returns changes to the HealthKit store, including a snapshot of new changes and continuous monitoring as a long-running query.
            let updateHandler: (HKAnchoredObjectQuery, [HKSample]?, [HKDeletedObject]?, HKQueryAnchor?, Error?) -> Void = {
                query, samples, deletedObjects, queryAnchor, error in
                
             // A sample that represents a quantity, including the value and the units.
            guard let samples = samples as? [HKQuantitySample] else {
                print("Error")
                return
            }
                
                print(samples.count)
                
            self.process(samples, type: quantityTypeIdentifier)

            }
            
            // It provides us with both the ability to receive a snapshot of data, and then on subsequent calls, a snapshot of what has changed.
            let query = HKAnchoredObjectQuery(type: HKObjectType.quantityType(forIdentifier: quantityTypeIdentifier)!, predicate: devicePredicate, anchor: nil, limit: HKObjectQueryNoLimit, resultsHandler: updateHandler)
            
            query.updateHandler = updateHandler
            
            // query execution
            
            healthStore.execute(query)
        }

    private func process(_ samples: [HKQuantitySample], type: HKQuantityTypeIdentifier) {
            // variable initialization
            var lastHeartRate = 0.0
            print("process started")
            
            // cycle and value assignment
            for sample in samples {
                print("For sample")
                if type == .heartRate {
                    lastHeartRate = sample.quantity.doubleValue(for: heartRateQuantity)
                }
                
                self.value = Int(lastHeartRate)
                self.yValue.text = String(self.value)
                print("HR Value")
                print(value)
            }
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
                                self.testArr3.append(date)
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

/*------------------------------------------------------------------------
 - Extension: HeartRateViewController : CPTScatterPlotDataScource, CPTScatterPlotDelegate
 - Description:
 -----------------------------------------------------------------------*/
//extension HeartRateViewController: CPTScatterPlotDataSource, CPTScatterPlotDelegate {
//
//    /*--------------------------------------------------------------------
//     - Function: numberOfRecords()
//     - Description:
//     -------------------------------------------------------------------*/
//    func numberOfRecords(for plot: CPTPlot) -> UInt {
//        return UInt(self.plotData.count)
//    }
//
//    /*--------------------------------------------------------------------
//     - Function: scatterplot()
//     - Description:
//     -------------------------------------------------------------------*/
//    func scatterPlot(_ plot: CPTScatterPlot, plotSymbolWasSelectedAtRecord idx: UInt, with event: UIEvent) {
//    }
//
//    /*--------------------------------------------------------------------
//     - Function: number()
//     - Description:
//     -------------------------------------------------------------------*/
//     func number(for plot: CPTPlot, field: UInt, record: UInt) -> Any? {
//
//       switch CPTScatterPlotField(rawValue: Int(field))! {
//
//            case .X:
//                return NSNumber(value: Int(record) + self.currentIndex-self.plotData.count)
//
//            case .Y:
//                return self.plotData[Int(record)] as NSNumber
//
//            default:
//                return 0
//        }
//    }
//}
