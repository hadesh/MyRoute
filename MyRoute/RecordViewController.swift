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
    var routes: [Route]!
    
    override func viewDidLoad() {
        
        self.view.backgroundColor = UIColor.gray
        
        routes = FileHelper.routesArray()
        if routes.count == 0 {
            // 如果没有数据，则添加测试数据。
            let tempPath: String? = Bundle.main.path(forResource: "temp_20161024_152059", ofType: nil)
            
            if tempPath != nil {
                let record: Route? = NSKeyedUnarchiver.unarchiveObject(withFile: tempPath!) as? Route
                
                if record != nil {
                    
                    let name: String! = record!.title()
                    let path: String = FileHelper.filePathWithName(name: name)!
                    
                    NSKeyedArchiver.archiveRootObject(record!, toFile: path)
                    routes = FileHelper.routesArray()
                }
            }
        }
        
        initTableView()
    }
    
    func initTableView() {
        
        tableView = UITableView(frame: view.bounds)
        tableView!.autoresizingMask = [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleWidth]
        
        tableView!.delegate = self
        tableView!.dataSource = self
        
        view.addSubview(tableView!)
    }
    
    //MARK:- Helpers
    
    func deleteRoute(index: Int) {
        
        if !routes.isEmpty {
            
            let route: Route = routes[index]
            let _ = FileHelper.deleteFile(file: route.title())
            
            routes.remove(at: index)
        }
    }
        
    //MARK:- UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "routeCellIdentifier"

        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        
        if cell == nil {
            
            cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: cellIdentifier)
        }
        
        if !routes.isEmpty {
            
            let route: Route = routes[indexPath.row]
            
            cell!.textLabel?.text = route.title()
            cell!.detailTextLabel?.text = route.detail()
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle != UITableViewCellEditingStyle.delete {
            return
        }
        
        deleteRoute(index: indexPath.row)
        
        tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
        
    }
    
    //MARK:- UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        if !routes.isEmpty {
            
            let route: Route = routes[indexPath.row]
            let displayController = DisplayViewController(nibName: nil, bundle: nil)
            displayController.title = "Display"
            displayController.route = route
            
            navigationController!.pushViewController(displayController, animated: true)
        }
  
    }
}
