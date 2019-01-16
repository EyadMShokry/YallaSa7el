//
//  ApartementDetailsViewController.swift
//  YallaSa7el
//
//  Created by Eyad Shokry on 1/14/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit
import CoreData

class ApartementDetailsViewController: UIViewController, NSFetchedResultsControllerDelegate{
    
    
    // MARK: - UI Elements and Variables
    
    @IBOutlet weak var apartementTitle: UILabel!
    @IBOutlet weak var apartementImageView: UIImageView!
    @IBOutlet weak var apartementAddress: UILabel!
    @IBOutlet weak var apartementDistrict: UILabel!
    @IBOutlet weak var apartementNumberOfRooms: UILabel!
    @IBOutlet weak var apartementNumberOfBathrooms: UILabel!
    @IBOutlet weak var apartementPricePerNight: UILabel!
    var apartementIndexPath: IndexPath?
    var controller: NSFetchedResultsController<Apartement>!

    
    // MARK: - ViewDidLoad Overriding
    
    fileprivate func fillingSelectedApartementData(_ selectedApartement: Apartement) {
        apartementTitle.text = selectedApartement.apartementTitle
        apartementImageView.image = selectedApartement.apartementImage as? UIImage
        apartementAddress.text = selectedApartement.apartementAddress
        apartementDistrict.text = selectedApartement.apartementDistrict
        apartementNumberOfRooms.text = String(selectedApartement.numberOfRooms)
        apartementNumberOfBathrooms.text = String(selectedApartement.numberOfBathrooms)
        apartementPricePerNight.text = selectedApartement.oneNightPrice
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadApartements()
        let selectedApartement = controller.object(at: apartementIndexPath!)
        fillingSelectedApartementData(selectedApartement)
    }
    
    
    // MARK: - Fetching The Selected Apartement's Data
    
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

}
