//
//  QuizNavigationController.swift
//  AppOftamologia
//
//  Created by Jagni Dasa Horta Bezerra on 08/02/2018.
//  Copyright © 2018 Felipe Martins. All rights reserved.
//

import Foundation
import UIKit

class QuizNavigationController : UINavigationController{
    
    var quiz : [Question]!
    var keys = [String]()
    var quizCount = 0
    var correctCount = 0
    var incorrectCount = 0
    var cellComment : ComentCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //cheatManager.userIsAnswering = true
        //getQuiz()
        //quiz.shuffle()
        self.showNextQuestion()
       
    }
    
    
    func getQuiz(){
        
        firebaseRef!.child("quiz").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.hasChildren(){
                
                let quizDict = snapshot.value as? NSDictionary
                
                print("\(quizDict)")
                
                for key in (quizDict?.allKeys)!{
                    
                    print("\(key)")
                    let questionDict = quizDict![key] as! NSDictionary
                    
                    let question = Question(dict: questionDict)
                    
                    
                    self.quiz.append(question)
                    
                }
                
                
            }
            
            self.quiz.shuffle()
            //self.tableView.reloadData()
            self.showNextQuestion()
            
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    

    
    func quit(){
        self.dismiss(animated: true) {
            
        }
    }
    
    func advance(){
        
        quizCount += 1
        
        if quizCount < 3{
            showNextQuestion()
        } else {
            showResults()
            
        }
    }
    
    func showNextQuestion(){
        
        
        let questionController = self.storyboard?.instantiateViewController(withIdentifier: "question") as! QuestionController
        
        if(quiz.count == 0){
            getQuiz()
        }
        else{
            questionController.question = quiz[quizCount]
            //print(self.navigationController!.viewControllers.count)
            questionController.progressBarButtonItem.title = "\(quizCount + 1)/\(quiz.count)"
            questionController.correctCountBarButtonItem.title = "\(correctCount)"
            questionController.wrongCountBarButtonItem.title = "\(incorrectCount)"
            self.show(questionController, sender: nil)
            
            if self.viewControllers.count == 2{
                self.viewControllers.remove(at: 0)
            }
        }
        
    }
    
    func showResults(){
        
        let resultController = self.storyboard?.instantiateViewController(withIdentifier: "Result") as! ResultViewController
        
        resultController.quiz = quiz
        resultController.correctCount = self.correctCount
        
        self.show(resultController, sender: nil)
        self.viewControllers.remove(at: 0)
    }
}
