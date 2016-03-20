//
//  ViewController.swift
//  Meditations
//
//  Created by Bart Jacobs on 18/03/16.
//  Copyright © 2016 Bart Jacobs. All rights reserved.
//

import UIKit
import HealthKit

class ViewController: UIViewController {

    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var enableHealthKitButton: UIButton!

    lazy var healthStore = HKHealthStore()

    override func viewDidLoad() {
        super.viewDidLoad()

        messageLabel.hidden = true
        enableHealthKitButton.hidden = true

        if HKHealthStore.isHealthDataAvailable() {
            let authorizationStatus = healthStore.authorizationStatusForType(HKObjectType.workoutType())

            if authorizationStatus == .NotDetermined {
                enableHealthKitButton.hidden = false

            } else if authorizationStatus == .SharingDenied {
                messageLabel.hidden = false
                messageLabel.text = "Meditations doesn't have access to your workout data. You can enable access in the Settings application."
            }

        } else {
            messageLabel.hidden = false
            messageLabel.text = "HealthKit is not available on this device."
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func enableHealthKit(sender: AnyObject) {
        var shareTypes = Set<HKSampleType>()
        shareTypes.insert(HKSampleType.workoutType())

        var readTypes = Set<HKObjectType>()
        readTypes.insert(HKObjectType.workoutType())

        healthStore.requestAuthorizationToShareTypes(shareTypes, readTypes: readTypes) { (success, error) -> Void in
            if success {
                print("success")
            } else {
                print("failure")
            }

            if let error = error { print(error) }
        }
    }
    
}
