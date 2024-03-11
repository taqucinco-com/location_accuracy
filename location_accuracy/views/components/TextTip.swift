//
//  TextTip.swift
//  location_accuracy
//
//  Created by sudo takuya on 2024/03/11.
//

import Foundation
import TipKit

struct AddTextTip: Tip {
    var title: Text {
        Text("音声認識操作")
    }
    var message: Text? {
        Text("recordという音声でも追加できます")
    }
    var image: Image? {
        nil
    }
}
