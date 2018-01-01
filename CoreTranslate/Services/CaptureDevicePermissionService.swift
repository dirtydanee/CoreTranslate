//
//  CaptureDevicePermissionService.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 18.12.17.
//  Copyright © 2017 Dirtylabs. All rights reserved.
//

import Foundation
import AVFoundation

enum Result<T> {
    case success(T)
    case failure(Error)
}

final class CaptureDevicePermissionService {

    enum Error: Swift.Error {
        case requestingAccessFailed
        case rejected
    }

    static func requestIfNeeded(for mediaType: AVMediaType, completionBlock: @escaping (Result<Bool>) -> Void) {
        let status = AVCaptureDevice.authorizationStatus(for: mediaType)
        switch status {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: mediaType) { granted in
                if granted {
                    completionBlock(.success(granted))
                } else {
                    completionBlock(.failure(Error.requestingAccessFailed))
                }
            }
        case .authorized:
            completionBlock(.success(true))
        case .denied, .restricted:
            completionBlock(.failure(Error.rejected))
        }
    }
}
