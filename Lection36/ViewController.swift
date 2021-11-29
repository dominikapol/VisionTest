//
//  ViewController.swift
//  Lection36
//
//  Created by Vladislav on 24.11.21.
//

import UIKit
import Vision

class ViewController: UIViewController {
    @IBOutlet private weak var imageView: UIImageView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let cgImage = UIImage(named: "bodypose")?.cgImage else { return }
        imageView.image = UIImage(cgImage: cgImage)
        // Create a new image-request handler.
        let requestHandler = VNImageRequestHandler(cgImage: cgImage)

        // Create a new request to recognize a human body pose.
        let request = VNDetectHumanBodyPoseRequest(completionHandler: { requestHandler, error in
            guard let bodyObservations = requestHandler.results as? [VNHumanBodyPoseObservation] else {
                return
            }
            
            for bodyObservation in bodyObservations {
                guard let recognizedBodyPoints = try? bodyObservation.recognizedPoints(.all) else {
                    continue
                }
                
                for recognizedBodyPoint in recognizedBodyPoints.values {
                    let point = VNImagePointForNormalizedPoint(
                        recognizedBodyPoint.location,
                        Int(self.imageView.frame.width),
                        Int(self.imageView.frame.height)
                    )
                    let pointView = UIView(
                        frame: CGRect(
                            x: point.x,
                            y: point.y,
                            width: 5,
                            height: 5
                        )
                    )
                    pointView.backgroundColor = .red
                    
                    self.imageView.addSubview(pointView)
                }
            }
        })

        do {
            // Perform the body pose-detection request.
            try requestHandler.perform([request])
        } catch {
            print("Unable to perform the request: \(error).")
        }
    }
}

