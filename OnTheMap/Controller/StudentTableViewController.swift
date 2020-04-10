//
//  StudentTableViewController.swift
//  OnTheMap
//
//  Created by Spencer Steggell on 3/17/20.
//  Copyright © 2020 Spencer Steggell. All rights reserved.
//

import Foundation
import UIKit


class StudentTableViewController: UIViewController {
    
    
    @IBOutlet var tableViewMap: UITableView!
    
    override func viewDidLoad() {
        
        let barButtonItemAddLoc = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        let refreshButtonItemAddLoc = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshButtonList))
        navigationItem.rightBarButtonItems = [barButtonItemAddLoc, refreshButtonItemAddLoc]
        
        UdacityClient.getStudentLocation{ (data, error) in
            guard let data = data else {
                return
            }
            StudentModel.studentList = data
            DispatchQueue.main.async {
                self.tableViewMap.reloadData()
            }
        }
    }
    
    @objc func addButtonPressed() {
        let addLocVC = storyboard!.instantiateViewController(withIdentifier: "AddLocationViewController")  as! AddLocationViewController
        navigationController?.pushViewController(addLocVC, animated: true)
    }
    
    @objc func refreshButtonList() {
        UdacityClient.getStudentLocation{ (data, error) in
            guard let data = data else {
                return
            }
            StudentModel.studentList = data
            DispatchQueue.main.async {
                self.tableViewMap.reloadData()
            }
        }
    }
}

extension StudentTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    //    Pulls the information from the API and organizes into the table view.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        print(StudentModel.studentList.count)
        return StudentModel.studentList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId") as! MapTableViewCell
        let studentVals = StudentModel.studentList
        cell.name?.text =  studentVals[indexPath.row].firstName + " " + studentVals[indexPath.row].lastName
        cell.url?.text = studentVals[indexPath.row].mediaURL
        
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        UIApplication.shared.open(URL(string: StudentModel.studentList[indexPath.row].mediaURL!)!, options: [:], completionHandler: nil)
    }
}




