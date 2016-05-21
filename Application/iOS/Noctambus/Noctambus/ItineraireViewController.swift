//
//  ItineraireViewController.swift
//  Noctambus
//
//  Created by Luca Falvo on 04.02.16.
//  Copyright © 2016 Noctambus. All rights reserved.
//

import UIKit
import KVNProgress

class ItineraireViewController: UIViewController, NSURLConnectionDataDelegate, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var origineTextField: AutoCompleteTextField!
    @IBOutlet weak var destinationTextField: AutoCompleteTextField!
    @IBOutlet weak var departArriveeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var RechercheButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var routeMapsButtonItem: UIBarButtonItem!
    
    let baseURLDirections = "https://maps.googleapis.com/maps/api/directions/json?"
    var stepsItineraire = [Itineraire]()
    var points : String!
    var duration : String!
    var dateChoisi = NSDate()

    private var responseData:NSMutableData?
    private var responseData2:NSMutableData?
    private var connection:NSURLConnection?
    private let googleMapsKey = "AIzaSyDlEpIuy8YCj51Ql0yXGK6xwYvV_8pLdZ0"
    private let baseURLString = "https://maps.googleapis.com/maps/api/place/autocomplete/json"
    
    @IBAction func routeMaps(sender: AnyObject) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        configureTextField()
        handleTextFieldInterfaces()
        configureDateTimePicker()
        let tapGesture = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
        //Met la date actuel
        configDateToday()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func dateTextFieldEditing(sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.DateAndTime
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: Selector("datePickerValueChanged:"), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    //Bouton Recherche
    @IBAction func RechercheAction(sender: AnyObject) {
        stepsItineraire.removeAll()
        points = ""
        
        let origin = origineTextField.text! as String
        let destination = destinationTextField.text! as String
        let depOuArr : String
        
        if departArriveeSegmentedControl.selectedSegmentIndex == 0{
            //depart
            depOuArr = "&departure_time=" + "\(Int(round(dateChoisi.timeIntervalSince1970)))"
        }else{
            //arrivee
            depOuArr = "&arrival_time=" + "\(Int(round(dateChoisi.timeIntervalSince1970)))"
        }
        KVNProgress.showWithStatus("Chargement des données...")
        callWebService(origin, destination: destination, departOuArrive: depOuArr)
    }
    
    func callWebService(origin: String! , destination: String!, departOuArrive: String){
        var directionsURLString = baseURLDirections + "origin=" + origin + "&destination=" + destination + departOuArrive + "&mode=transit"
        directionsURLString = directionsURLString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        //print (directionsURLString)
        
        Alamofire.request(.GET, directionsURLString).validate().responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    //print(json)
                    self.parseJSON(json)
                }
            case .Failure(let error):
                print(error)
                
            }
            dispatch_async(dispatch_get_main_queue()) {
                KVNProgress.dismiss()
                self.tableView.reloadData()
            }
            
        }
    }
    
    func parseJSON(json: JSON) {
        let status = json["status"].stringValue
        //print(status)
        if (status == "OK"){
            points = json["routes"][0]["overview_polyline"]["points"].stringValue
            let routes = json["routes"][0].dictionaryValue
            duration = routes["legs"]![0]["duration"]["text"].stringValue
            
            //START STEP
            let startAdress = routes["legs"]![0]["start_address"].stringValue
            let startlat = routes["legs"]![0]["start_location"]["lat"].doubleValue
            let startlng = routes["legs"]![0]["start_location"]["lng"].doubleValue
            let startTime = routes["legs"]![0]["departure_time"]["text"].stringValue
            
            //Finish step
            let finishAdress = routes["legs"]![0]["end_address"].stringValue
            let finishlat = routes["legs"]![0]["end_location"]["lat"].doubleValue
            let finishlng = routes["legs"]![0]["end_location"]["lng"].doubleValue
            let finishTime = routes["legs"]![0]["arrival_time"]["text"].stringValue
            //add start step
            let startStep =   Itineraire(titre: startAdress, instruction: "", departureTime: startTime, arrivalTime: "",
                lat: startlat, lng: startlng, duration: "", vehicleType: "", numStops: nil, line: "")
            self.stepsItineraire.append(startStep)
            
            //Other Step
            let steps = routes["legs"]![0]["steps"].arrayValue
            
            for var i = 0; i < steps.count; i++ {
                let instruction = steps[i]["html_instructions"].stringValue
                let duration = steps[i]["duration"]["text"].stringValue
                var titre = steps[i]["transit_details"]["departure_stop"]["name"].stringValue
                
                if(titre == "" && i > 0){
                    titre = steps[i-1]["transit_details"]["arrival_stop"]["name"].stringValue
                }
                
                let arrivalTime = steps[i]["transit_details"]["arrival_time"]["text"].stringValue
                let departureTime = steps[i]["transit_details"]["departure_time"]["text"].stringValue
                let numstop = steps[i]["transit_details"]["num_stops"].intValue
                let line = steps[i]["transit_details"]["line"]["short_name"].stringValue
                let lat = steps[i]["start_location"]["lat"].doubleValue
                let lng = steps[i]["start_location"]["lng"].doubleValue
                var type = ""
                
                if((steps[i]["travel_mode"].stringValue) == "WALKING"){
                    type = "WALKING"
                }else{
                    type = steps[i]["transit_details"]["line"]["vehicle"]["type"].stringValue
                }
                
                let otherStep =   Itineraire(titre: titre, instruction: instruction, departureTime: departureTime, arrivalTime: arrivalTime,
                    lat: lat, lng: lng, duration: duration, vehicleType: type, numStops: numstop, line: line)
                self.stepsItineraire.append(otherStep)
                
            }
            //add Last Step
            let finishStep =   Itineraire(titre: finishAdress, instruction: "", departureTime: "", arrivalTime: finishTime,
                lat: finishlat, lng: finishlng, duration: "", vehicleType: "", numStops: nil, line: "")
            self.stepsItineraire.append(finishStep)
            
        }else if (status == "ZERO_RESULTS"){
            let alert = UIAlertController(title: "Aucun résultat", message: "Aucun résultat ne correspond à votre recherche.", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(defaultAction)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stepsItineraire.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.row == 0 || indexPath.row == stepsItineraire.count-1){
            return 67.0
        }
        return 100.0
        
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let steps = stepsItineraire[indexPath.row]
        
        if (indexPath.row == 0 || indexPath.row == stepsItineraire.count-1){
            
            let cellIdentifier = "cellOriginDest"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! firstLastStepTableViewCell
            cell.titleLabel.text = steps.titre
            
            if (indexPath.row == 0){
                cell.departTimeLabel.text = steps.departureTime
                cell.startFinishImageView.image = UIImage(named:"start")
                
            }else{
                cell.departTimeLabel.text = steps.arrivalTime
                cell.startFinishImageView.image = UIImage(named:"finish")
            }
            
            return cell
            
        }else{
            let cellIdentifier = "cellStep"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! stepTableViewCell
            
            cell.arrivalTimeLabel.text = steps.arrivalTime
            cell.departTimeLabel.text = steps.departureTime
            cell.titleLabel.text = steps.titre
            
            if (steps.line != ""){
                cell.instructionLabel.text = "\(steps.line!)\(" → ")\(steps.instruction!)"
            }else{
                cell.instructionLabel.text = steps.instruction
            }
            
            var nbarret : String
            steps.numStops > 1 ? (nbarret = "\(steps.numStops!)\(" arrêts")") : (nbarret = "\(steps.numStops!)\(" arrêt")")
            
            switch (steps.vehicleType){
            case "TRAM"?:
                cell.stepImageView.image = UIImage(named:"tram")
                cell.numstopLabel.text = "\(steps.duration!)\(", ")\(nbarret)"
                break
            case "BUS"?:
                cell.stepImageView.image = UIImage(named:"bus")
                cell.numstopLabel.text = "\(steps.duration!)\(", ")\(nbarret)"
                break
            case "HEAVY_RAIL"?:
                cell.stepImageView.image = UIImage(named:"train")
                cell.numstopLabel.text = "\(steps.duration!)\(", ")\(nbarret)"
                break
            case "WALKING"?:
                cell.stepImageView.image = UIImage(named:"walking")
                cell.numstopLabel.text = "\("Environ ")\(steps.duration!)"
                break
            default:
                break
            }
            
            return cell
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier ==  "showRouteMaps"{
            let routeViewController = segue.destinationViewController as! routeMapsViewController
                routeViewController.points = points
                routeViewController.stepsAnnotation = stepsItineraire
        }
    }
    
    private func configureTextField(){
        origineTextField.autoCompleteTextColor = UIColor(red: 128.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 1.0)
        origineTextField.autoCompleteTextFont = UIFont(name: "HelveticaNeue-Light", size: 12)
        origineTextField.layer.borderColor = UIColor.grayColor().CGColor
        //origineTextField.autoCompleteCellHeight = 50
        origineTextField.maximumAutoCompleteCount = 20
        origineTextField.hidesWhenSelected = true
        origineTextField.hidesWhenEmpty = true
        origineTextField.enableAttributedText = true
        var attributes = [String:AnyObject]()
        attributes[NSForegroundColorAttributeName] = UIColor.blackColor()
        attributes[NSFontAttributeName] = UIFont(name: "HelveticaNeue-Bold", size: 12.0)
        origineTextField.autoCompleteAttributes = attributes
        
        destinationTextField.autoCompleteTextColor = UIColor(red: 128.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 1.0)
        destinationTextField.autoCompleteTextFont = UIFont(name: "HelveticaNeue-Light", size: 12)
        //origineTextField.autoCompleteCellHeight = 50
        destinationTextField.maximumAutoCompleteCount = 20
        destinationTextField.hidesWhenSelected = true
        destinationTextField.hidesWhenEmpty = true
        destinationTextField.enableAttributedText = true
        var attributes2 = [String:AnyObject]()
        attributes2[NSForegroundColorAttributeName] = UIColor.blackColor()
        attributes2[NSFontAttributeName] = UIFont(name: "HelveticaNeue-Bold", size: 12.0)
        destinationTextField.autoCompleteAttributes = attributes2
    }
    
    
    private func handleTextFieldInterfaces(){
        origineTextField.onTextChange = {[weak self] text in
            if !text.isEmpty{
                if self!.connection != nil{
                    self!.connection!.cancel()
                    self!.connection = nil
                }
                var urlString = "\(self!.baseURLString)?key=\(self!.googleMapsKey)&input=\(text)"
                //let url = NSURL(string: (urlString as NSString).stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)
                urlString = urlString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
                let url = NSURL(string: urlString)
                if url != nil{
                    let urlRequest = NSURLRequest(URL: url!)
                    self!.connection = NSURLConnection(request: urlRequest, delegate: self)
                }
            }
        }
        
        origineTextField.onSelect = {[weak self] text, indexpath in
        }
        
        destinationTextField.onTextChange = {[weak self] text in
            if !text.isEmpty{
                if self!.connection != nil{
                    self!.connection!.cancel()
                    self!.connection = nil
                }
                var urlString = "\(self!.baseURLString)?key=\(self!.googleMapsKey)&input=\(text)"
                //let url = NSURL(string: (urlString as NSString).stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)
                urlString = urlString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
                let url = NSURL(string: urlString)
                if url != nil{
                    let urlRequest = NSURLRequest(URL: url!)
                    self!.connection = NSURLConnection(request: urlRequest, delegate: self)
                }
            }
        }
        
        destinationTextField.onSelect = {[weak self] text, indexpath in
        }
        
    }
    
    //MARK: NSURLConnectionDelegate
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        responseData = NSMutableData()
        responseData2 = NSMutableData()
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        responseData?.appendData(data)
        responseData2?.appendData(data)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection) {
        if let data = responseData{
            
            do{
                let result = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                
                if let status = result["status"] as? String{
                    if status == "OK"{
                        if let predictions = result["predictions"] as? NSArray{
                            var locations = [String]()
                            for dict in predictions as! [NSDictionary]{
                                locations.append(dict["description"] as! String)
                            }
                            self.origineTextField.autoCompleteStrings = locations
                            self.destinationTextField.autoCompleteStrings   = locations
                            return
                        }
                    }
                }
                self.origineTextField.autoCompleteStrings = nil
                self.destinationTextField.autoCompleteStrings = nil
            }
            catch let error as NSError{
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        print("Error: \(error.localizedDescription)")
    }
    
    func dismissKeyboard(){
        self.origineTextField.resignFirstResponder()
        self.destinationTextField.resignFirstResponder()
        self.dateTextField.resignFirstResponder()
    }
    
    
    
    //DateTimePicker
    func configureDateTimePicker(){
        let toolBar = UIToolbar(frame: CGRectMake(0, self.view.frame.size.height/6, self.view.frame.size.width, 40.0))
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        toolBar.barTintColor = UIColor(red: 23.0/255.0, green: 79.0/255.0, blue: 174.0/255.0, alpha: 1.0)
        toolBar.tintColor = UIColor.yellowColor()
        let todayBtn = UIBarButtonItem(title: "Aujourd'hui", style: UIBarButtonItemStyle.Plain, target: self, action: "tappedToolBarBtn:")
        let okBarBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "donePressed:")
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        label.font = UIFont(name: "Helvetica", size: 12)
        label.backgroundColor = UIColor.clearColor()
        label.textColor = UIColor.whiteColor()
        label.text = "Date et heure"
        label.textAlignment = NSTextAlignment.Center
        let textBtn = UIBarButtonItem(customView: label)
        toolBar.setItems([todayBtn,flexSpace,textBtn,flexSpace,okBarBtn], animated: true)
        dateTextField.inputAccessoryView = toolBar
    }
    
    func donePressed(sender: UIBarButtonItem) {
        dateTextField.resignFirstResponder()
    }
    
    func tappedToolBarBtn(sender: UIBarButtonItem) {
        configDateToday()
        dateTextField.resignFirstResponder()
    }
    
    func configDateToday(){
        let dateformatter = NSDateFormatter()
        dateformatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateformatter.timeStyle = NSDateFormatterStyle.ShortStyle
        dateTextField.text = dateformatter.stringFromDate(NSDate())
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        dateTextField.text = dateFormatter.stringFromDate(sender.date)
        dateChoisi = sender.date
    }
    
    
    
}

