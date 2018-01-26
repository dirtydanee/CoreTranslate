//
//  UIImage+Rotation.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 20.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import UIKit

extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
}

extension UIImage {

    func rotate(byDegree degree: CGFloat) -> UIImage? {

        let rotatedViewBox = UIView(frame: CGRect(origin: .zero, size: self.size))
        let trasform = CGAffineTransform(rotationAngle: degree.degreesToRadians)
        rotatedViewBox.transform = trasform
        let rotatedSize = rotatedViewBox.frame.size

        UIGraphicsBeginImageContext(rotatedSize)

        guard let bitmap = UIGraphicsGetCurrentContext(),
              let cgImage = self.cgImage else {
            fatalError("Unable to get current graphics context")
        }

        bitmap.translateBy(x: rotatedSize.width, y:  rotatedSize.height)
        bitmap.rotate(by: degree.degreesToRadians)
        bitmap.scaleBy(x: 1, y: -1)
        bitmap.draw(cgImage, in: CGRect(x: -self.size.width, y: -self.size.height,
                                        width: self.size.width, height: self.size.height))

        let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return rotatedImage
    }

}
