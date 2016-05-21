//
//  AccordionMenuTableViewController.swift
//  AccordionTableSwift
//
//  Created by Victor Sigler on 2/4/15.
//  Copyright (c) 2015 Private. All rights reserved.
//

import UIKit
import Parse

class AccordionMenuTableViewController: UITableViewController {
    
    @IBOutlet weak var ligneNavItem: UINavigationItem!
    
    /// The number of elements in the data source
    var total = 0
    /// The identifier for the parent cells.
    let parentCellIdentifier = "ParentCell"
    /// The identifier for the child cells.
    let childCellIdentifier = "ChildCell"
    /// The data source
    var dataSource: [Parent]!
    /// Define wether can exist several cells expanded or not.
    let numberOfCellsExpanded: NumberOfCellExpanded = .One
    /// Constant to define the values for the tuple in case of not exist a cell expanded.
    let NoCellExpanded = (-1, -1)
    /// The index of the last cell expanded and its parent.
    var lastCellExpanded : (Int, Int)!
    
    var ligne : Lignes!
    
    var arretLigne : [PFObject]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ligneNavItem.title = "\(ligne!.originName)\(" → ")\(ligne!.destinationName)"
        self.lastCellExpanded = NoCellExpanded
        searchArret()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func searchArret(){
        let query: PFQuery = PFQuery(className: "ArretsLigne")
        query.whereKey("idLignes", equalTo: ligne.idLignes)
        query.orderByAscending("sqStartStop")
        query.fromLocalDatastore()
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if (error == nil) {
                //print(objects)
                self.arretLigne = objects
            }else{
                print(error)
            }
            dispatch_async(dispatch_get_main_queue()) {
                self.setInitialDataSource(numberOfRowParents: self.arretLigne.count, numberOfRowChildPerParent: 3)
                self.tableView.reloadData()
                
            }

            
        }
       
 
        
    }
    
    
    /**
     Set the initial data for test the table view.
     
     - parameter parents: The number of parents cells
     - parameter childs:  Then maximun number of child cells per parent.
     */
    private func setInitialDataSource(numberOfRowParents parents: Int, numberOfRowChildPerParent childs: Int) {
        
        // Set the total of cells initially.
        self.total = parents
        
        let data = [Parent](count: parents, repeatedValue: Parent(state: .Collapsed, childs: [String](), title: ""))
        
        dataSource = data.enumerate().map({ (index: Int, element: Parent) -> Parent in
            
            var newElement = element
            
            let test = arretLigne[index].objectForKey("stopName")
            
            newElement.title = test as! String
            
            let horaire = arretLigne[index].objectForKey("horaires") as! NSMutableArray
            let count = horaire.count
            // create the array for each cell
            //newElement.childs = (0..<count).enumerate().map {"Subitem \($0.index)"}
            newElement.childs = (0..<count).enumerate().map {(horaire[$0.index] as! String)}

            return newElement
        })
    }
    
    /**
     Expand the cell at the index specified.
     
     - parameter index: The index of the cell to expand.
     */
    private func expandItemAtIndex(index : Int, parent: Int) {
        
        // the data of the childs for the specific parent cell.
        let currentSubItems = self.dataSource[parent].childs
        
        // update the state of the cell.
        self.dataSource[parent].state = .Expanded
        
        // position to start to insert rows.
        var insertPos = index + 1
        
        let indexPaths = (0..<currentSubItems.count).map { _ -> NSIndexPath in
            let indexPath = NSIndexPath(forRow: insertPos, inSection: 0)
            insertPos += 1
            return indexPath
        }
        
        // insert the new rows
        self.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Fade)
        
        // update the total of rows
        self.total += currentSubItems.count
    }
    
    /**
     Collapse the cell at the index specified.
     
     - parameter index: The index of the cell to collapse
     */
    private func collapseSubItemsAtIndex(index : Int, parent: Int) {
        
        var indexPaths = [NSIndexPath]()
        
        let numberOfChilds = self.dataSource[parent].childs.count
        
        // update the state of the cell.
        self.dataSource[parent].state = .Collapsed
        
        guard index + 1 <= index + numberOfChilds else { return }
        
        // create an array of NSIndexPath with the selected positions
        indexPaths = (index + 1...index + numberOfChilds).map { NSIndexPath(forRow: $0, inSection: 0)}
        
        // remove the expanded cells
        self.tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Fade)
        
        // update the total of rows
        self.total -= numberOfChilds
    }
    
    /**
     Update the cells to expanded to collapsed state in case of allow severals cells expanded.
     
     - parameter parent: The parent of the cell
     - parameter index:  The index of the cell.
     */
    private func updateCells(parent: Int, index: Int) {
        
        switch (self.dataSource[parent].state) {
            
        case .Expanded:
            self.collapseSubItemsAtIndex(index, parent: parent)
            self.lastCellExpanded = NoCellExpanded
            
        case .Collapsed:
            switch (numberOfCellsExpanded) {
            case .One:
                // exist one cell expanded previously
                if self.lastCellExpanded != NoCellExpanded {
                    
                    let (indexOfCellExpanded, parentOfCellExpanded) = self.lastCellExpanded
                    
                    self.collapseSubItemsAtIndex(indexOfCellExpanded, parent: parentOfCellExpanded)
                    
                    // cell tapped is below of previously expanded, then we need to update the index to expand.
                    if parent > parentOfCellExpanded {
                        let newIndex = index - self.dataSource[parentOfCellExpanded].childs.count
                        self.expandItemAtIndex(newIndex, parent: parent)
                        self.lastCellExpanded = (newIndex, parent)
                    }
                    else {
                        self.expandItemAtIndex(index, parent: parent)
                        self.lastCellExpanded = (index, parent)
                    }
                }
                else {
                    self.expandItemAtIndex(index, parent: parent)
                    self.lastCellExpanded = (index, parent)
                }
            case .Several:
                self.expandItemAtIndex(index, parent: parent)
            }
        }
    }
    
    /**
     Find the parent position in the initial list, if the cell is parent and the actual position in the actual list.
     
     - parameter index: The index of the cell
     
     - returns: A tuple with the parent position, if it's a parent cell and the actual position righ now.
     */
    private func findParent(index : Int) -> (parent: Int, isParentCell: Bool, actualPosition: Int) {
        
        var position = 0, parent = 0
        guard position < index else { return (parent, true, parent) }
        
        var item = self.dataSource[parent]
        
        repeat {
            
            switch (item.state) {
            case .Expanded:
                position += item.childs.count + 1
            case .Collapsed:
                position += 1
            }
            
            parent += 1
            
            // if is not outside of dataSource boundaries
            if parent < self.dataSource.count {
                item = self.dataSource[parent]
            }
            
        } while (position < index)
        
        // if it's a parent cell the indexes are equal.
        if position == index {
            return (parent, position == index, position)
        }
        
        item = self.dataSource[parent - 1]
        return (parent - 1, position == index, position - item.childs.count - 1)
    }
    
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier ==  "showRouteMap"{
            let lmviewController = segue.destinationViewController as! LignesMapViewController
            lmviewController.detailLigne = arretLigne
            
            
        }
    }
    
    
}






extension AccordionMenuTableViewController {
    
    // MARK: UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.total
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       //var cell : UITableViewCell!
        
        let (parent, isParentCell, actualPosition) = self.findParent(indexPath.row)
        
        if !isParentCell {
            let cell = tableView.dequeueReusableCellWithIdentifier(childCellIdentifier, forIndexPath: indexPath) as UITableViewCell
            cell.textLabel!.text = self.dataSource[parent].childs[indexPath.row - actualPosition - 1]
            //cell.backgroundColor = UIColor.greenColor()
            return cell

        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier(parentCellIdentifier, forIndexPath: indexPath) as! LignesArretsTableViewCell
            cell.arretLabel.text = self.dataSource[parent].title
            
            if (indexPath.row == 0){
                cell.stepsImageView.image = UIImage(named:"thermoD")
            } else if (indexPath.row == total-1){
                cell.stepsImageView.image = UIImage(named:"thermoFin")
            }else{
                cell.stepsImageView.image = UIImage(named:"thermo")
            }

      

            return cell

        }
        
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let (parent, isParentCell, actualPosition) = self.findParent(indexPath.row)
        
        guard isParentCell else {
            NSLog("A child was tapped!!!")
            
            // The value of the child is indexPath.row - actualPosition - 1
            NSLog("The value of the child is \(self.dataSource[parent].childs[indexPath.row - actualPosition - 1])")
            
            return
        }
        
        self.tableView.beginUpdates()
        self.updateCells(parent, index: indexPath.row)
        self.tableView.endUpdates()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return !self.findParent(indexPath.row).isParentCell ? 44.0 : 50
    }
}