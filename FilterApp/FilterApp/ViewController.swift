//
//  ViewController.swift
//  navtest
//
//  Created by 根岸裕太 on 2019/02/10.
//  Copyright © 2019年 根岸裕太. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var baseView: UIView!
    @IBOutlet private weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.view.endEditing(true)
    }
    
    @IBAction private func tapFilterButton(_ sender: UIButton) {
        // 画面におけるBaseViewの部分を切り取り描画する
        var screenshot: UIImage?
        UIGraphicsBeginImageContextWithOptions(self.baseView.frame.size, false, UIScreen.main.scale)
        if let imageContext = UIGraphicsGetCurrentContext() {
            imageContext.translateBy(x: -self.view.frame.origin.x, y: -self.view.frame.origin.y)
            self.baseView.layer.render(in: imageContext)
            screenshot = UIGraphicsGetImageFromCurrentImageContext()
        }
        screenshot = UIGraphicsGetImageFromCurrentImageContext()
        
        screenshot?.draw(in: self.baseView.frame)
        
        // 描画したContextを取得し、Filterをかける。
        guard let context = UIGraphicsGetCurrentContext(),
            let originalImage = context.makeImage(),
            let bwFilter = CIFilter(name: "CIColorControls") else {
                return UIGraphicsEndImageContext()
        }
        
        let ciImage = CIImage(cgImage: originalImage)
        bwFilter.setValue(ciImage, forKey: kCIInputImageKey)
        // 彩度を下げる
        bwFilter.setValue(NSNumber(value: 0.0), forKey: kCIInputSaturationKey)
        
        // Contextにフィルターをかけ、UIImageを描画する。
        if let bwFilterOutput = bwFilter.outputImage {
            let outputImage: UIImage = UIImage(ciImage: bwFilterOutput)
            outputImage.draw(in: self.baseView.frame)
            
            self.imageView.image = outputImage
        }
        UIGraphicsEndImageContext()
    }

}

