//
//  ViewController.swift
//  FintecimalTest
//
//  Created by Jerry Lozano on 5/11/21.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Property
    @IBOutlet weak var locationListTable: UITableView!
    private let imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 250, height: 250))
        imageView.image = UIImage(named: "MyProfessionalLogotype")
        return imageView
    }()
    
    // MARK: GET DATA
    let getDataUrl: String = "https://fintecimal-test.herokuapp.com/api/interview"
    
    var model = [Model]()
    
    // MARK: Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LocationTableViewCell
        
        let user: Model
        user = model[indexPath.row]
        cell.streetNameLabel.text = user.streetName
        cell.suburbPlaceLabel.text = user.suburbPlace
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user: Model
        user = model[indexPath.row]
        let mapDetail = storyboard?.instantiateViewController(identifier: "MapDetail") as? MapDetail
        mapDetail?.getLatitude = user.fLocation!.latitude
        mapDetail?.getLongitude = user.fLocation!.longitude
        mapDetail?.getStreetName = user.streetName!
        mapDetail?.getSuburbPlace = user.suburbPlace!
        
        self.navigationController?.pushViewController(mapDetail!, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: Launch Screen Image Animation
        view.addSubview(imageView)
        
        // MARK: Alamofire Request
        Alamofire.request(getDataUrl).responseJSON { response in
            if let json = response.result.value {
                let locationsArray: NSArray = json as! NSArray
                for i in 0..<locationsArray.count {
                    
                    // Dictionary of Location
                    let cLocation = (locationsArray[i] as AnyObject).value(forKey: "location") as? [String: Double]
                    let xLatitude = cLocation!["latitude"]
                    let xLongitude = cLocation!["longitude"]
                    
                    self.model.append(Model(
                        streetName: (locationsArray[i] as AnyObject).value(forKey: "streetName") as? String,
                        suburbPlace: (locationsArray[i] as AnyObject).value(forKey: "suburb") as? String,
                        fVisited: (locationsArray[i] as AnyObject).value(forKey: "visited") as? Bool,
                        fLocation: CustomLocation(latitude: xLatitude!, longitude: xLongitude!)
                    ))
                }
                self.locationListTable.reloadData()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.center = view.center
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.animate()
        }
    }
}

// MARK: Shadow & Border Styling
extension UIView {
    
    @IBInspectable var maskToBounds: Bool {
        get { return layer.masksToBounds }
        set { layer.masksToBounds = false }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        get { return layer.shadowRadius }
        set { layer.shadowRadius = newValue }
    }

    @IBInspectable var shadowOpacity: CGFloat {
        get { return CGFloat(layer.shadowOpacity) }
        set { layer.shadowOpacity = Float(newValue) }
    }

    @IBInspectable var shadowOffset: CGSize {
        get { return layer.shadowOffset }
        set { layer.shadowOffset = newValue }
    }

    @IBInspectable var shadowColor: UIColor? {
        get { guard let cgColor = layer.shadowColor else { return nil }
            return UIColor(cgColor: cgColor)
        }
        set { layer.shadowColor = newValue?.cgColor }
    }
    
    @IBInspectable var cornerRadiusV: CGFloat {
        get { return layer.cornerRadius }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }

    @IBInspectable var borderWidthV: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }

    @IBInspectable var borderColorV: UIColor? {
        get { return UIColor(cgColor: layer.borderColor!) }
        set { layer.borderColor = newValue?.cgColor }
    }
}

extension ViewController {
    private func animate() {
        UIView.animate(withDuration: 1, animations: {
            let size = self.view.frame.size.width * 3
            let diffX = size - self.view.frame.size.width
            let diffY = self.view.frame.size.height - size
            self.imageView.frame = CGRect(
                x: -(diffX/2),
                y: diffY/2,
                width: size,
                height: size
            )
            self.imageView.alpha = 0
        }, completion: nil)
    }
}
