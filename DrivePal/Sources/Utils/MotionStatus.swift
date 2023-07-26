//
//  MotionStatus.swift
//  DrivePal
//
//  Created by 제나 on 2023/07/26.
//

enum MotionStatus: Decodable, Encodable {
    case none, normal, suddenAcceleration, suddenStop, takingOff, landing
}
