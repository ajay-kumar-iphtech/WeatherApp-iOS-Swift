//
//  Extensions.swift
//  Weather-App-iOS
//
//  Created by iPHTech on 19/07/23.
//

import Foundation
import UIKit

protocol ObjectSavable {
    func setObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable
    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable
}

enum ObjectSavableError: String, LocalizedError {
    case unableToEncode = "Unable to encode object into data"
    case noValue = "No data object found for the given key"
    case unableToDecode = "Unable to decode object into given type"
    
    var errorDescription: String? {
        rawValue
    }
}   

extension CGMutablePath {
    func createCurvedRectangle(width: CGFloat, height: CGFloat) -> CGMutablePath {
        self.move(to: CGPoint.init(x: 20, y: 0))
        self.addLine(to: CGPoint.init(x: width - 20, y: 0))
        self.addQuadCurve(to: CGPoint.init(x: width, y: 20), control: CGPoint.init(x: width, y: 0))
        self.addLine(to: CGPoint.init(x: width, y: height - 20))
        self.addQuadCurve(to: CGPoint.init(x: width - 20, y: height), control: CGPoint.init(x: width, y: height))
        self.addLine(to: CGPoint.init(x: 20, y: height))
        self.addQuadCurve(to: CGPoint.init(x: 0, y: height - 20), control: CGPoint.init(x: 0, y: height))
        self.addLine(to: CGPoint.init(x: 0, y: 20))
        self.addQuadCurve(to: CGPoint.init(x: 20, y: 0), control: CGPoint.init(x: 0, y: 0))
        return self
    }
}

extension CAShapeLayer {
    func addCurvedLayer(curvedRect: CGMutablePath) -> CAShapeLayer {
        self.path = curvedRect
        self.fillRule = CAShapeLayerFillRule.evenOdd
        self.fillColor = UIColor.red.cgColor
        return self
    }
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

extension UserDefaults: ObjectSavable {
    func setObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            set(data, forKey: forKey)
        } catch {
            throw ObjectSavableError.unableToEncode
        }
    }
    
    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable {
        guard let data = data(forKey: forKey) else { throw ObjectSavableError.noValue }
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(type, from: data)
            return object
        } catch {
            throw ObjectSavableError.unableToDecode
        }
    }
}
