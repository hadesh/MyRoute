//
//  RecordViewController.swift
//  MyRoute
//
//  Created by xiaoming han on 14-7-21.
//  Copyright (c) 2014 AutoNavi. All rights reserved.
//

import UIKit

class RecordViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var tableView: UITableView?
    var routes: [Route]
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        
        routes = FileHelper.routesArray()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        routes = FileHelper.routesArray()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        
        self.view.backgroundColor = UIColor.grayColor()
        initTableView()
    }
    
    func initTableView() {
        
        tableView = UITableView(frame: view.bounds)
        tableView!.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
        
        tableView!.delegate = self
        tableView!.dataSource = self
        
        view.addSubview(tableView!)
    }
    
    //MARK:- Helpers
    
    func deleteRoute(index: Int) {
        
        if !routes.isEmpty {
            
            let route: Route = routes[index]
            FileHelper.deleteFile(route.title())
            
            routes.removeAtIndex(index)
        }
    }
        
    //MARK:- UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "routeCellIdentifier"

        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        
        if cell == nil {
            
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellIdentifier)
        }
        
        if !routes.isEmpty {
            
            let route: Route = routes[indexPath.row]
            
            cell!.textLabel?.text = route.title()
            cell!.detailTextLabel?.text = route.detail()
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle != UITableViewCellEditingStyle.Delete {
            return
        }
        
        deleteRoute(indexPath.row)
        
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        
    }
    
    //MARK:- UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if !routes.isEmpty {
            
            let route: Route = routes[indexPath.row]
            let displayController = DisplayViewController(nibName: nil, bundle: nil)
            displayController.title = "Display"
            displayController.route = route
            
            navigationController!.pushViewController(displayController, animated: true)
        }
  
    }
}
