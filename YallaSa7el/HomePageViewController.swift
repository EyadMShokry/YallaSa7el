//
//  HomePageViewController.swift
//  YallaSa7el
//
//  Created by Eyad Shokry on 1/13/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import CoreData


class HomePageViewController: UIViewController {
    
    // MARK: - UI Elements and variables
    
    @IBOutlet weak var apartementsTableView: UITableView!
    var controller: NSFetchedResultsController<Apartement>!
    
    
    // MARK: - ViewDidLoad Overriding
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apartementsTableView.dataSource = self
        apartementsTableView.delegate = self
        loadApartements()
    }
    
    
    // MARK: - fetching Apartements from Database
    
    func loadApartements(){
        let fetchRequest: NSFetchRequest<Apartement> = Apartement.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "additionDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        do {
            try controller.performFetch()
        } catch {
            print ("An error occured")
        }
    }
    
    
    // MARK: - Logout Implementation
    
    @IBAction func logoutBtnClicked(_ sender: UIButton) {
        if(Auth.auth().currentUser != nil){
            do {
                try Auth.auth().signOut()
                let viewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
                present(viewController!, animated: true, completion: nil)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
}


// MARK: - TableView DataSource and Delegate Extension

extension HomePageViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = controller.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = apartementsTableView.dequeueReusableCell(withIdentifier: "apartement", for: indexPath) as! ApartementTableViewCell
        configureCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: ApartementTableViewCell, indexPath: IndexPath){
        let singleApartement = controller.object(at: indexPath)
        cell.setMyCell(apartement: singleApartement)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let apartementDetailsVC = storyboard?.instantiateViewController(withIdentifier: "ApartementDetails") as! ApartementDetailsViewController
        apartementDetailsVC.apartementIndexPath = indexPath
        apartementDetailsVC.controller = controller
        navigationController?.pushViewController(apartementDetailsVC, animated: true)
    }
}


// MARK: - FetchedResultsControllerDelegate Extension

extension HomePageViewController:  NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        apartementsTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        apartementsTableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
            
        case .insert:
            if let indexPath = newIndexPath {
                apartementsTableView.insertRows(at: [indexPath], with: .fade)
            }
            break
            
        case .update:
            if let indexPath = indexPath {
                let cell = apartementsTableView.cellForRow(at: indexPath) as! ApartementTableViewCell
                configureCell(cell: cell, indexPath: indexPath)
            }
            break
            
        case .delete:
            if let indexPath = indexPath {
                apartementsTableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
            
        case.move:
            if let indexPath = indexPath {
                apartementsTableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath {
                apartementsTableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        }
    }
}



