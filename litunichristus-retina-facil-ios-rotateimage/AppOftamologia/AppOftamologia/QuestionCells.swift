//
//  QuestionCells.swift
//  QuizOrtopedia
//
//  Created by Jagni Dasa Horta Bezerra on 22/11/16.
//  Copyright © 2016 Jagni Dasa Horta Bezerra. All rights reserved.
//

import Foundation
import UIKit
import MGSwipeTableCell

class ImageCell : UITableViewCell{
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var questionImageView: UIImageView!
}

class AnswerCell : MGSwipeTableCell{
    
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var separator: UIView!
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var optionLabel: UILabel!
    var uid: String!
}

class ComentCell : UITableViewCell{
    @IBOutlet weak var comentTextView: UITextView!
    
    @IBOutlet weak var buttonNext: UIButton!
}


