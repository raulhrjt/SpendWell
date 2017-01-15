//
//  FirstViewController.swift
//  SpendWell
//
//  Created by Raul Hossa Rambo on 2017-01-05.
//  Copyright © 2017 Raul Hossa Rambo. All rights reserved.
//

import UIKit
import CoreData


class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    
    /*Variables
     */
    @IBOutlet var descripts: UITableView!
    //table view with information of title, price and rating
    
    @IBOutlet private weak var wellTrack: UIProgressView!
    //progress view for the rating
    
    @IBOutlet private weak var scrollView: UIScrollView!
    //scroll view
    
    @IBOutlet private weak var totalSpent: UILabel!
    //total spent (sum of all expenses)
    
    @IBOutlet private weak var textRecommend: UILabel!
    //recommended text according to rating
    
    var value: Float!
    //stores the current value of the rating
    
    var count: Int!
    //keeps track of the number of descriptions
    
    var sum: Float!
    //sum of all expenses
    
    var tasks: [EntityCell] = []
    
    var stuffType:String! = " "
    var quickActionString:String! = " "
    
       
    /*override functions
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
        {
            let indexPath: NSIndexPath = self.descripts.indexPathForSelectedRow! as NSIndexPath
            
            let task = tasks[indexPath.row]
            
             let dest: SingleCellViewController = segue.destination as! SingleCellViewController
            
            if(task.imageEntityCell != nil)
            {
            let imagePt = UIImage(data: (task.imageEntityCell! ) as Data)
                
                dest.showReceipt = imagePt
            }
            
            
       
        
        dest.showTitle = task.titleEntityCell!
        
        dest.showPrice = "$ " + task.priceEntityCell!
        
        dest.showRate = task.ratingEntityCell!
            
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        scrollView.contentSize.height = 2000
        
        
       
        
       
       
        
        //sets the height of scroll view
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        getData()
        descripts.reloadData()
        //reloads all descriptions from the table view
        
    }
    
    
    //initializes the table view
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        totalSpent.text = "0"
        count = 0
        sum = 0
        //return operation.descriptions.count
        return tasks.count
    }
    
    //@IBOutlet var titleLabel: UILabel!
    //implements the delet function for the table view and updates the total spent
    internal func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        
        if(editingStyle == UITableViewCellEditingStyle.delete)
        {
            
            
            let task = tasks[indexPath.row]
            
            if(Int(task.priceEntityCell!) != nil)
            {
                totalSpent.text = String(Int(totalSpent.text!)! - Int(task.priceEntityCell!)!)
            }
            
            context.delete(task)
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
           
            
            do{
                
                
                
                tasks = try context.fetch(EntityCell.fetchRequest())
            }
            catch{
                print("fetch failed")
            }
            
            
        
           
            descripts.reloadData()
        }
    }
    
    
    
    //
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var rate: Int!
        
       
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewCell") as! CellTableViewCell
        
        let task = tasks[indexPath.row]
        
        
        if(task.imageEntityCell != nil)
        {
        let imagePt = UIImage(data: (task.imageEntityCell! ) as Data)
            
        cell.cellImage.image = imagePt
        }
        
        
        
        
        cell.cellTitle.text = task.titleEntityCell!
        
        cell.cellPrice.text =  "$" + task.priceEntityCell!
        
       
        let swiftGreen = UIColor(red: 144, green: 203, blue: 119, alpha: 1)
        
        if(Int(task.ratingEntityCell!) != nil)
        {
            if(Float(task.ratingEntityCell!)! >= 0.50)
            {
                cell.backgroundColor = swiftGreen
            }
        }
        
        //*************************
        
       
        
        if(Int(task.priceEntityCell!) != nil)
        {
            
            totalSpent.text = String(Int(totalSpent.text!)! + Int(task.priceEntityCell!)!)
        }
        if(Int(task.ratingEntityCell!) != nil)
        {
            rate = Int(task.ratingEntityCell!)!
            value = (Float(rate))/100.0
            
            if(value != nil)
            {
                count = count + 1
                sum! = value + sum
                wellTrack.setProgress(Float(sum)/Float(count), animated: true)
                
                if((Float(sum)/Float(count) >= 0 ) && ((Float(sum)/Float(count) <= 0.25)))
                {
                    textRecommend.text = "\"Look for help when spending money\""
                }
                else if((Float(sum)/Float(count) > 0.25) && ((Float(sum)/Float(count) <= 0.50)))
                    
                {
                    textRecommend.text = "\"Poor job managing your money\""
                }
                else if((Float(sum)/Float(count) > 0.50) && ((Float(sum)/Float(count) <= 0.75)))
                    
                {
                    textRecommend.text = "\"Good job managing your money\""
                    
                }
                else if((Float(sum)/Float(count) > 0.75) && ((Float(sum)/Float(count) <= 1.00)))
                {
                    
                    textRecommend.text = "\"Great job managing your money\""
                }
            }
        }
        return cell
    }
    
    func getData(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do{
    
        
        tasks = try context.fetch(EntityCell.fetchRequest())
        }
        catch{
            print("fetch failed")
        }
    }
    
    
}

    
    
    
    
    
    
    
        


    


    


    
    
    
    
    
    
    
    
    


