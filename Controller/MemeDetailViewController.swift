//
//  MemeDetailViewController.swift
//  Meme-Me-1.0
//
//  Created by Desha Washington on 3/30/21.
//

import UIKit

class MemeDetailViewController: UIViewController {

    var meme: Meme!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      self.imageView?.image = self.meme.memedImage
       


    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       
    }

  }

