//
//  ResultsViewController.swift
//  Brain Anatomy
//
//  Created by Felipe Martins on 24/04/17.
//  Copyright © 2017 Jagni. All rights reserved.
//

import Foundation
import UIKit
import UICircularProgressRing


class ResultViewController: UIViewController {
    
    //var quiz: [StudentQuiz]!
    var quiz : [Question]!
    var correctCount: Int!
    
    var grade = 0.0
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var incorrectLabel: UILabel!
    @IBOutlet weak var incorrectNumberLabel: UILabel!
    
    @IBOutlet weak var correctLabel: UILabel!
    @IBOutlet weak var correctNumberLabel: UILabel!
    @IBOutlet weak var correctArrow: UIImageView!
    @IBOutlet weak var correctImageView: UIImageView!
    
    @IBOutlet weak var progressRing: UICircularProgressRingView!
    
    @IBOutlet weak var incorrectArrow: UIImageView!
    
    @IBOutlet weak var stackView: UIStackView!
    
    var shouldHideBackButton = true
    
    override func viewDidLoad() {
       // self.progressRing.font = UIFont.systemFont(ofSize: 60, weight: UIFont.Weight.medium)
        nameLabel.text = "Teste"
        //self.navigationItem.title = "Resultado - \(quiz.simpleDate)"
        self.navigationItem.hidesBackButton = self.shouldHideBackButton
        //correctImageView.superview?.alpha = 0
        //correctImageView.image = UIImage(named: quiz.image)
        //correctImageView.tintColor = appMainColor
        progressRing.value = 0
        
        correctArrow.tintColor = appMainColor
        incorrectArrow.tintColor = UIColor(netHex: 0xaaaaaa)
        
        correctArrow.transform = CGAffineTransform(scaleX: -1, y: 1);
        incorrectArrow.transform = CGAffineTransform(scaleX: -1, y: 1);
        
        /*
        let correctQuestions = quiz.questions.filter { (item) -> Bool in
            item.value.correctKey == item.value.answeredKey
        }
        
        let wrongQuestions = quiz.questions.count - correctQuestions.count
         
        if correctQuestions.count == 1{
            correctLabel.text = "Questão correta"
        }
        if wrongQuestions == 1{
            incorrectLabel.text = "Questão incorreta"
        }
        
        if correctQuestions.count == 0{
            stackView.arrangedSubviews[0].isHidden = true
        } else if wrongQuestions == 0{
            stackView.arrangedSubviews[1].isHidden = true
        }
        
        correctNumberLabel.text = "\(correctQuestions.count)"
        incorrectNumberLabel.text = "\(wrongQuestions)"
        
        grade = 100 - 100*(Double(wrongQuestions)/Double(quiz.questions.count)).roundTo(places: 2)*/
        
        let wrongQuestions = quiz.count - correctCount
        
        if correctCount == 1{
            correctLabel.text = "Questão correta"
        }
        if wrongQuestions == 1{
            incorrectLabel.text = "Questão incorreta"
        }
        
        correctNumberLabel.text = "\(correctCount!)"
        incorrectNumberLabel.text = "\(wrongQuestions)"
        
        grade = 100 - 100*(Double(wrongQuestions)/Double(quiz.count))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setToolbarHidden(!self.shouldHideBackButton, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (shouldHideBackButton){
            super.viewDidAppear(animated)
            self.navigationItem.prompt = ""
            self.navigationItem.prompt = nil
        }
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTapClose(_:)))
        self.navigationController?.toolbar.addGestureRecognizer(recognizer)
        self.navigationController?.view.setNeedsLayout()
        
        UIView.animate(withDuration: 0.25) {
            self.navigationController?.view.layoutIfNeeded()
        }
        
        UIView.animate(withDuration: 0.25) {
           // self.correctImageView.superview?.alpha = 1
        }
        
        progressRing.setProgress(value: CGFloat(grade), animationDuration: 1)
        
    }
    
    @IBAction func didTapClose(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        //correctImageView.superview?.layer.cornerRadius = (correctImageView.superview?.bounds.width)!/2
    }
 /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! ResultDetailViewController
        controller.quiz = self.quiz
    }
 */
    
}

